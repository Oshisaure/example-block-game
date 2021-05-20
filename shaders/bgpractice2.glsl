uniform float dt;
uniform float time;

#define PI  3.141592653589793238463
#define TAU 6.283185307179586476925

#define SCREENHEIGHT .35
uniform Image moontex;
uniform Image moonnor;

const vec3 LIGHTDIR = normalize(vec3( -20.,  -40.,  -50.));
const vec3 amigapos  = vec3(0., 52., 10.);
const vec3 amigaaxis = vec3(1., 0., 0.);
const vec3 amigaback = vec3(0., 0., 1.);
const vec3 amigaleft = vec3(0., 1., 0.);
#define AMIGAROWS 50.
#define AMIGACOLS 100.

#define STARSDENSITY 35.

struct ballpoint {
    bool valid;
    float longitude;
    float latitude;
    vec3 normal;
    mat3 normaltransform;
};

ballpoint pointOnBall(vec3 uvdir, vec3 ballpos, float ballsize, vec3 ballaxis, vec3 ballback, vec3 ballleft) {
    // assuming all vec3s except ballpos are normalized
    
    // get point closest to ball
    float d = dot(uvdir, ballpos);
    vec3 closest = d * uvdir;
    float mindist = distance(closest, ballpos);
    if (mindist < ballsize && d >= 0) {
        // actually hitting the ball, draw it
        
        // the contact point, the closest point and the centre of the ball make a right triangle
        // so we can get the length between the first two from the other distances
        // we then move back along the beam that distance to get the contact point
        vec3 surfacepoint = closest - uvdir * sqrt(ballsize*ballsize - mindist*mindist);
        vec3 surfacevec = normalize(surfacepoint - ballpos);
        
        // longitude and latitude calculations for texture position
        // shoutouts to https://stackoverflow.com/questions/5674149/3d-coordinates-on-a-sphere-to-latitude-and-longitude
        float longitude = .5*PI-acos(dot(surfacevec, ballaxis));
        float latitude  = atan(dot(ballback, surfacevec), dot(ballleft, surfacevec));
        float clo = cos(longitude), slo = sin(longitude);
        float cla = cos(latitude) , sla = sin(latitude) ;
        mat3 transform = mat3(ballback, ballaxis, ballleft)
                       * mat3(cla, 0  ,-sla,
                              0  , 1  , 0  ,
                              sla, 0  , cla)
                       * mat3(1  , 0  , 0  ,
                              0  , clo,-slo,
                              0  , slo, clo)
                       ;
        return ballpoint(true, longitude, latitude, surfacevec, transform);
    }
    return ballpoint(false, 0., 0., vec3(0.), mat3(0.));
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

#define NUM_OCTAVES 5
float fbm(vec2 x) {
	float v = 0.0;
	float a = 0.5;
	vec2 shift = vec2(100);
	// Rotate to reduce axial bias
    mat2 rot = mat2(cos(0.5), sin(0.5), -sin(0.5), cos(0.50));
	for (int i = 0; i < NUM_OCTAVES; ++i) {
		v += a * noise(x);
		x = rot * x * 2.0 + shift;
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

    // background colour
    vec4 newpixel = vec4(.1, .0, .3, 1.);
    // direction of camera pixel
    vec3 uvdir = normalize(vec3(uv2, 1));
    
    ballpoint amigapoint = pointOnBall(uvdir, amigapos, 50., amigaaxis, amigaback, amigaleft);
    if (amigapoint.valid) {
        // test
        // newpixel.xyz = vec3(longitude, latitude, 0.);
        amigapoint.latitude = mod(amigapoint.latitude - .01*time, TAU);
        // amiga ball
        // checkerboard on longitude and latitude
        float red = mod(floor(amigapoint.longitude/PI*AMIGAROWS) + floor(amigapoint.latitude/TAU*AMIGACOLS), 2);
        newpixel.xyz = vec3(1.,red,red) * dot(amigapoint.normal, LIGHTDIR) * 2.;
        
    } else {
        // floating moon
        vec3 moonpos  = vec3(150., -70.+10.*cos(time*.2), 400.);
        vec3 moonaxis = normalize(vec3(.3, cos(time*.04), sin(time*.04)));
        vec3 moonback = normalize(cross(moonaxis, vec3(0.,0.,1.)));
        vec3 moonleft = cross(moonaxis, moonback);
        // vec3 moonpos  = vec3(150., -70, 400.);
        // vec3 moonaxis = vec3(0.,1.,0.);
        // vec3 moonback = vec3(0.,0.,1.);
        // vec3 moonleft = cross(moonaxis, moonback);
        
        
        ballpoint moonpoint = pointOnBall(uvdir, moonpos, 100., moonaxis, moonback, moonleft);
        if (moonpoint.valid) {
            moonpoint.latitude = mod(moonpoint.latitude, TAU);
            // moon texture
            newpixel = Texel(moontex, vec2(moonpoint.latitude/TAU, moonpoint.longitude/PI +.5));
            // adjusting normal with normalmap
            vec3 mapnormal = Texel(moonnor, vec2(moonpoint.latitude/TAU, moonpoint.longitude/PI +.5)).xyz * 2. - 1.;
            newpixel.xyz *= dot(moonpoint.normaltransform * mapnormal, LIGHTDIR);
        } else {
            // space clouds background
            newpixel.xyz += vec3(.7, .1, .3) * sqrt(fbm(15*uv2+time*vec2(.2, .1)) * fbm(10*uv2.yx+time*vec2(.1,-.2)))*2;
            // random stars
            
            // lots of random but essentially, the screen is divided into square cells
            // in which i place one star at a random spot towards the middle
            vec2 cell = floor(uv2*STARSDENSITY);
            // the randomness makes the stars off the grid
            // and with enough of them it looks somewhat convincing i guess
            float r = rand(cell);
            vec2 starpos = .25+.5*vec2(r, rand(cell+r));
            // shine of the stars changes with time so it's a bit sparkly
            // not how stars behave but i think it looks good
            float intensity = noise((starpos+cell)*5.+time);
            newpixel.xyz += vec3(1., 1., rand(cell*intensity)) * (1.-smoothstep(.0, .002*intensity, distance(uv2, (cell+starpos)/STARSDENSITY)))*intensity;
        }
    }
    return newpixel;
}
#endif

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position){
    return transform_projection * vertex_position;
}
#endif
