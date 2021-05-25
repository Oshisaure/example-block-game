uniform float dt;
uniform float time;
#define PI            3.141592653589793238463
#define TAU           6.283185307179586476925
#define SCREENHEIGHT  .60
#define SEALEVEL      20.
#define SEAREFRACTION 1.3
#define SHAPETHICNESS 15.
#define SHAPEGLOWNESS 20.
#define SHAPESIZENESS 250.
const vec3 SHAPEPOS = vec3(0., -200., 1000);
const vec3 LIGHTDIR = vec3(0.,0.,1.);
const vec2 DVEC     = vec2(.00, .01);
// colours
const vec4 sky   = vec4(.4, .6, .7, 1.);
const vec4 light = vec4(.9, .9, .9, 1.);
const vec4 water = vec4(.7, .5, .5, 1.);
const vec4 watr2 = vec4(.9, .6, .7, 1.);
const vec4 shape = vec4(.9, .6, .7, 1.);

float distanceLineToSegment(vec3 lineOrigin, vec3 lineDir, vec3 segA, vec3 segB) {
    float distanceA = distance(dot(segA-lineOrigin, lineDir)*lineDir + lineOrigin, segA);
    float distanceB = distance(dot(segB-lineOrigin, lineDir)*lineDir + lineOrigin, segB);
    
    // get the line perpendicular to both the line and the segment since that's where the shortest distance is
    vec3 segDir = segB - segA;
    vec3 shortDir = normalize(cross(lineDir, segDir));
    
    // parallel lines case
    if (dot(shortDir, shortDir) == 0.)
        return distanceA;
    
    // get distance from line to line
    float shortest = abs(dot(shortDir, segA - lineOrigin));
    // project on the line perpendicular to the original line and the shortest line
    // this allows us to see if A and B are on opposite sides compared to the closest segment point
    vec3 p = cross(shortDir, lineDir);
    if (dot(lineOrigin - segA, p) * dot(lineOrigin - segB, p) < 0)
        // A and B are either side of the closest point meaning the closest point is part of the segment
        return shortest;
    // A and B are on the same side so whichever is the closest is the distance we're looking for
    return min(distanceA, distanceB);
}

//from https://gist.github.com/patriciogonzalezvivo/670c22f3966e662d2f83 //
float rand(vec2 n) { 
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec2 p){
	vec2 ip = floor(p);
	vec2 u = fract(p);
	u = u*u*(3.0-2.0*u);
	
	float res = mix(
		mix(rand(ip),rand(ip+vec2(1.0,0.0)),u.x),
		mix(rand(ip+vec2(0.0,1.0)),rand(ip+vec2(1.0,1.0)),u.x),u.y);
	return res*res;
}

float mod289(float x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 mod289(vec4 x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 perm(vec4 x){return mod289(((x * 34.0) + 1.0) * x);}

float noise(vec3 p){
    vec3 a = floor(p);
    vec3 d = p - a;
    d = d * d * (3.0 - 2.0 * d);

    vec4 b = a.xxyy + vec4(0.0, 1.0, 0.0, 1.0);
    vec4 k1 = perm(b.xyxy);
    vec4 k2 = perm(k1.xyxy + b.zzww);

    vec4 c = k2 + a.zzzz;
    vec4 k3 = perm(c);
    vec4 k4 = perm(c + 1.0);

    vec4 o1 = fract(k3 * (1.0 / 41.0));
    vec4 o2 = fract(k4 * (1.0 / 41.0));

    vec4 o3 = o2 * d.z + o1 * (1.0 - d.z);
    vec2 o4 = o3.yw * d.x + o3.xz * (1.0 - d.x);

    return o4.y * d.y + o4.x * (1.0 - d.y);
}

#define NUM_OCTAVES 4
float fbm(vec3 x) {
	float v = 0.0;
	float a = 0.5;
	vec3 shift = vec3(100);
	for (int i = 0; i < NUM_OCTAVES; ++i) {
		v += a * noise(x);
		x = x * 2.0 + shift;
		a *= 0.5;
	}
	return v;
}
///////////////////////////////////////////////////////////////////////////

#ifdef PIXEL
vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords){
    //scaling uvs
    vec2 uv2 = uvs - .5;
    uv2.x *= love_ScreenSize.x/love_ScreenSize.y;
    uv2 *= 2*SCREENHEIGHT;

    // direction of camera pixel
    vec3 uvdir = normalize(vec3(uv2, 1));
    
    vec3 startpoint = vec3(0.);
    vec4 reflectioncolour = mix(sky, light, pow(dot(uvdir, LIGHTDIR), 5));
    vec4 refractioncolour = vec4(0.);
    float reflectionindex = 1.;
    if (uvdir.y > 0.) {
        startpoint = uvdir / uvdir.y * (SEALEVEL);
        if (startpoint.z < 400.) {
            // point we hit on the sea plane
            vec2 planecoord = startpoint.xz*.5;
            // generate random height map from fbm
            vec3 tide = vec3(planecoord, time*.5+noise(planecoord));
            float h = fbm(tide);
            // derivate to get normals
            vec3 dx = normalize(vec3(.02, fbm(tide+DVEC.yxx) - h, .00));
            vec3 dz = normalize(vec3(.00, fbm(tide+DVEC.xyx) - h, .02));
            vec3 normal = cross(dz, dx);
            // reflected and refracted rays
            vec3 reflected = normalize(reflect(uvdir, normal));
            vec3 refracted = normalize(refract(uvdir, normal, 1/SEAREFRACTION));
            // Schlick's approximation for how much refraction
            float r = (1-SEAREFRACTION)/(1+SEAREFRACTION);
            r *= r;
            r += (1-r)*pow(1-dot(uvdir, normal), 5);
            // update values
            refractioncolour = mix(watr2, water, dot(refracted, LIGHTDIR));
            reflectioncolour = mix(sky  , light, max(pow(dot(reflected, LIGHTDIR), 5),0.));
            reflectionindex = clamp(0, 1, r + startpoint.z*.0025);
            uvdir = reflected;
        }
    }
    vec2 uvb = uvdir.xy/uvdir.z;
    vec4 blend = vec4(
        1.-smoothstep(0,0.15,abs(uvb.y-2*abs(uvb.x) + 1.00)),
        1.-smoothstep(0,0.15,abs(uvb.y-2*abs(uvb.x) + 1.05)),
        1.-smoothstep(0,0.15,abs(uvb.y-2*abs(uvb.x) + 1.10)),
        0.
    );
    reflectioncolour = mix(reflectioncolour, vec4(1., 1., 1., 1.), blend);
    float a = time*0.8, b = time*0.4, c = time*.2;
    float ca = cos(a), sa = sin(a), cb = cos(b), sb = sin(b), cc = cos(c), sc = sin(c);
    mat3 spin = mat3(sc, cc,  0,
                     cc,-sc,  0,
                      0,  0,  1)
              * mat3( 0, sb, cb,
                      0, cb,-sb,
                      1,  0,  0)
              * mat3(ca,  0, sa,
                      0,  1,  0,
                    -sa,  0, ca);
    vec3 spinX = spin[0], spinY = spin[1], spinZ = spin[2];
    vec3 Xpos = SHAPEPOS + SHAPESIZENESS*spinX, Xneg = SHAPEPOS - SHAPESIZENESS*spinX;
    vec3 Ypos = SHAPEPOS + SHAPESIZENESS*spinY, Yneg = SHAPEPOS - SHAPESIZENESS*spinY;
    vec3 Zpos = SHAPEPOS + SHAPESIZENESS*spinZ, Zneg = SHAPEPOS - SHAPESIZENESS*spinZ;
    float d =  distanceLineToSegment(startpoint, uvdir, Xpos, Ypos);
    d = min(d, distanceLineToSegment(startpoint, uvdir, Xpos, Yneg));
    d = min(d, distanceLineToSegment(startpoint, uvdir, Xpos, Zpos));
    d = min(d, distanceLineToSegment(startpoint, uvdir, Xpos, Zneg));
    d = min(d, distanceLineToSegment(startpoint, uvdir, Xneg, Ypos));
    d = min(d, distanceLineToSegment(startpoint, uvdir, Xneg, Yneg));
    d = min(d, distanceLineToSegment(startpoint, uvdir, Xneg, Zpos));
    d = min(d, distanceLineToSegment(startpoint, uvdir, Xneg, Zneg));
    d = min(d, distanceLineToSegment(startpoint, uvdir, Ypos, Zpos));
    d = min(d, distanceLineToSegment(startpoint, uvdir, Ypos, Zneg));
    d = min(d, distanceLineToSegment(startpoint, uvdir, Yneg, Zpos));
    d = min(d, distanceLineToSegment(startpoint, uvdir, Yneg, Zneg));
    if (d < SHAPETHICNESS) {
        reflectioncolour = shape;
    } else {
        reflectioncolour = mix(reflectioncolour, shape, 1/(1+d/SHAPEGLOWNESS));
    }
    
    return mix(refractioncolour, reflectioncolour, reflectionindex);
}
#endif

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position){
    return transform_projection * vertex_position;
}
#endif
