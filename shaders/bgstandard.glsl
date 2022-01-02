uniform float dt;
uniform float time;
uniform float leveltime;
uniform int   levelprev;
uniform int   level;
uniform Image moontex;
uniform Image moonnor;

#define PI  3.141592653589793238463
#define TAU 6.283185307179586476925
#define SCREENHEIGHT .35
#define TRANSITION_TIME 3.
const vec3 ORIGIN    = vec3(0., 0., 0.);
const vec3 BG_COLOUR = vec3(.2, .2, .2);

const vec3 moonpos  = vec3(-200., 150., 500.);
const vec3 moonaxis = normalize(vec3(2., -5., -1.));
const vec3 moonback = normalize(cross(moonaxis, vec3(1., 0., 0.)));
const vec3 moonleft = normalize(cross(moonaxis, moonback));
#define moonsize 200.
#define PIECE_SIZE 40.

// const vec3[5][21] PIECE_BLOCKS = vec3[5][20](
const vec3[5] PIECE_O1 = vec3[5](vec3( 0.0, 0.0, 0.0), vec3( 0.0, 0.0, 0.0), vec3( 0.0, 0.0, 0.0), vec3( 0.0, 0.0, 0.0), vec3( 0.0, 0.0, 0.0)); 

const vec3[5] PIECE_I2 = vec3[5](vec3( 0.5, 0.0, 0.0), vec3(-0.5, 0.0, 0.0), vec3(-0.5, 0.0, 0.0), vec3( 0.5, 0.0, 0.0), vec3( 0.5, 0.0, 0.0)); 

const vec3[5] PIECE_L3 = vec3[5](vec3( 0.5,-0.5, 0.0), vec3(-0.5, 0.5, 0.0), vec3(-0.5,-0.5, 0.0), vec3( 0.5,-0.5, 0.0), vec3( 0.5,-0.5, 0.0)); 
const vec3[5] PIECE_I3 = vec3[5](vec3( 1.0, 0.0, 0.0), vec3(-1.0, 0.0, 0.0), vec3( 0.0, 0.0, 0.0), vec3( 1.0, 0.0, 0.0), vec3( 1.0, 0.0, 0.0)); 

const vec3[5] PIECE_I4 = vec3[5](vec3( 0.5, 0.0, 0.0), vec3(-1.5, 0.0, 0.0), vec3(-0.5, 0.0, 0.0), vec3( 1.5, 0.0, 0.0), vec3( 1.5, 0.0, 0.0)); 
const vec3[5] PIECE_O4 = vec3[5](vec3( 0.5,-0.5, 0.0), vec3(-0.5, 0.5, 0.0), vec3(-0.5,-0.5, 0.0), vec3( 0.5, 0.5, 0.0), vec3( 0.5, 0.5, 0.0)); 
const vec3[5] PIECE_S4 = vec3[5](vec3( 1.0,-1.0, 0.0), vec3(-1.0, 0.0, 0.0), vec3( 0.0,-1.0, 0.0), vec3( 0.0, 0.0, 0.0), vec3( 0.0, 0.0, 0.0)); 
const vec3[5] PIECE_T4 = vec3[5](vec3( 1.0, 0.0, 0.0), vec3(-1.0, 0.0, 0.0), vec3( 0.0,-1.0, 0.0), vec3( 0.0, 0.0, 0.0), vec3( 0.0, 0.0, 0.0)); 
const vec3[5] PIECE_L4 = vec3[5](vec3( 1.0, 0.0, 0.0), vec3(-1.0, 0.0, 0.0), vec3(-1.0,-1.0, 0.0), vec3( 0.0, 0.0, 0.0), vec3( 0.0, 0.0, 0.0));

const vec3[5] PIECE_P5 = vec3[5](vec3( 1.0, 0.0, 0.0), vec3(-1.0, 0.0, 0.0), vec3(-1.0,-1.0, 0.0), vec3( 0.0, 0.0, 0.0), vec3( 0.0,-1.0, 0.0)); 
const vec3[5] PIECE_U5 = vec3[5](vec3( 1.0, 0.0, 0.0), vec3(-1.0, 0.0, 0.0), vec3(-1.0,-1.0, 0.0), vec3( 0.0, 0.0, 0.0), vec3( 1.0,-1.0, 0.0)); 
const vec3[5] PIECE_I5 = vec3[5](vec3( 1.0, 0.0, 0.0), vec3(-1.0, 0.0, 0.0), vec3(-2.0, 0.0, 0.0), vec3( 0.0, 0.0, 0.0), vec3( 2.0, 0.0, 0.0)); 
const vec3[5] PIECE_N5 = vec3[5](vec3( 0.5, 0.5, 0.0), vec3(-0.5,-0.5, 0.0), vec3(-1.5,-0.5, 0.0), vec3(-0.5, 0.5, 0.0), vec3( 1.5, 0.5, 0.0)); 
const vec3[5] PIECE_Y5 = vec3[5](vec3( 0.5, 0.5, 0.0), vec3(-0.5,-0.5, 0.0), vec3(-1.5, 0.5, 0.0), vec3(-0.5, 0.5, 0.0), vec3( 1.5, 0.5, 0.0)); 
const vec3[5] PIECE_L5 = vec3[5](vec3( 0.5, 0.5, 0.0), vec3( 1.5,-0.5, 0.0), vec3(-1.5, 0.5, 0.0), vec3(-0.5, 0.5, 0.0), vec3( 1.5, 0.5, 0.0)); 
const vec3[5] PIECE_V5 = vec3[5](vec3( 1.0, 1.0, 0.0), vec3( 1.0,-1.0, 0.0), vec3(-1.0, 1.0, 0.0), vec3( 0.0, 1.0, 0.0), vec3( 1.0, 0.0, 0.0)); 
const vec3[5] PIECE_W5 = vec3[5](vec3( 0.0, 0.0, 0.0), vec3( 1.0,-1.0, 0.0), vec3(-1.0, 1.0, 0.0), vec3( 0.0, 1.0, 0.0), vec3( 1.0, 0.0, 0.0)); 
const vec3[5] PIECE_Z5 = vec3[5](vec3( 0.0, 0.0, 0.0), vec3( 1.0,-1.0, 0.0), vec3(-1.0, 1.0, 0.0), vec3( 0.0, 1.0, 0.0), vec3( 0.0,-1.0, 0.0)); 
const vec3[5] PIECE_T5 = vec3[5](vec3( 0.0, 0.0, 0.0), vec3( 1.0, 1.0, 0.0), vec3(-1.0, 1.0, 0.0), vec3( 0.0, 1.0, 0.0), vec3( 0.0,-1.0, 0.0)); 
const vec3[5] PIECE_F5 = vec3[5](vec3( 0.0, 0.0, 0.0), vec3( 1.0, 0.0, 0.0), vec3(-1.0, 1.0, 0.0), vec3( 0.0, 1.0, 0.0), vec3( 0.0,-1.0, 0.0)); 
const vec3[5] PIECE_X5 = vec3[5](vec3( 0.0, 0.0, 0.0), vec3( 1.0, 0.0, 0.0), vec3(-1.0, 0.0, 0.0), vec3( 0.0, 1.0, 0.0), vec3( 0.0,-1.0, 0.0)); 
// )

vec3[5] getPieceForLevel(int lv) {
	// mom can we have array of array
	// we have array of array at home
	// array of array at home:
	
	if (lv ==  0) return PIECE_O1;
		
	if (lv ==  1) return PIECE_I2;
	
	if (lv ==  2) return PIECE_L3;
	if (lv ==  3) return PIECE_I3;
	
	if (lv ==  4) return PIECE_I4;
	if (lv ==  5) return PIECE_O4;
	if (lv ==  6) return PIECE_S4;
	if (lv ==  7) return PIECE_T4;
	if (lv ==  8) return PIECE_L4;
	
	if (lv ==  9) return PIECE_P5;
	if (lv == 10) return PIECE_U5;
	if (lv == 11) return PIECE_I5;
	if (lv == 12) return PIECE_N5;
	if (lv == 13) return PIECE_Y5;
	if (lv == 14) return PIECE_L5;
	if (lv == 15) return PIECE_V5;
	if (lv == 16) return PIECE_W5;
	if (lv == 17) return PIECE_Z5; 
	if (lv == 18) return PIECE_T5;
	if (lv == 19) return PIECE_F5;
				  return PIECE_X5;
}


// from https://en.wikipedia.org/wiki/HSL_and_HSV#HSL_to_RGB_alternative //
const vec3 N = vec3(0., 8., 4.);
vec3 hsl2rgb(vec3 c) {
	vec3 k = mod(N + c.x * 12., 12.);
	return c.z - c.y*min(c.z, 1.-c.z)*clamp(min(k-3., 9.-k), -1., 1.);
}

// from http://lolengine.net/blog/2013/07/27/rgb-to-hsv-in-glsl //
const vec4 K = vec4(1., 2. / 3., 1. / 3., 3.);
vec3 hsv2rgb(vec3 c) {
    vec3 p = abs(fract(c.xxx + K.xyz) * 6. - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0., 1.), c.y);
}

// from https://en.wikipedia.org/wiki/Line%E2%80%93plane_intersection#Algebraic_form //
vec3 linePlaneIntersect(vec3 planenorm, vec3 planepoint, vec3 linedir, vec3 linepoint) {
	return linepoint + linedir * (dot(planepoint-linepoint, planenorm)/dot(linedir, planenorm));
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

#define NUM_OCTAVES 5
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

mat3 roll(float angle) {
	float c = cos(angle), s = sin(angle);
	return mat3(1, 0, 0, 
	            0, c, s,
	            0,-s, c);
}

mat3 pitch(float angle) {
	float c = cos(angle), s = sin(angle);
	return mat3(c, 0,-s, 
	            0, 1, 0,
	            s, 0, c);
}

mat3 yaw(float angle) {
	float c = cos(angle), s = sin(angle);
	return mat3(c, s, 0, 
	           -s, c, 0,
	            0, 0, 1);
}

void drawSquare(inout vec3 pxcolour, vec3 norm, vec3 pos, vec3 sideA, vec3 sideB, vec3 uvdir, float size) {
	// get the point on the face plane where uvdir is pointing
	vec3 intersect = linePlaneIntersect(norm, pos, uvdir, ORIGIN) - pos;
	vec2 sqpos = vec2(dot(intersect, sideA), dot(intersect, sideB));
	
	// only draw if we're actually in the face
	if (sqpos == clamp(sqpos, -size*.5, size*.5)) {
		
		// projection of incident vector on the face's coordinates
		vec2 faceproj = vec2(dot(uvdir, sideA), dot(uvdir, sideB));
		
		pxcolour = hsv2rgb(vec3(
			// hue is based on the angle of said coordinates (gives rainbow effect as the face rotates)
			.5 + atan(faceproj.y, faceproj.x) / TAU,
			// when the projection is small (ie when looking at the face straight on), a colour wheel
			// singularity would show up, to fix this we lower the saturation to turn it white
			max(0., 10.*dot(faceproj, faceproj)),
			// value is based on how the reflected ray is coming back towards us
			// ie how dead on we are looking at the face
			.5 * (1.+dot(reflect(uvdir, norm), -uvdir))
		));
		
	}
}

void drawPiece(inout vec3 px_colour, vec3 position, mat3 orientation, vec3[5] blocks, float size, vec3 uvdir) {
	// apply rotation matrix, size, and global piece position to the block positions
	vec3[5] bl_rotated;
	for (int i = 0; i < blocks.length(); i++) {
		bl_rotated[i] = orientation*(blocks[i] * size) + position;
	}
	
	// in-place selection sort by closest to the camera for draw order
	// gets buggy when the blocks overlap but outside of the piece morph animation it never happens
	vec3 temp;
	for (int i = 0; i < bl_rotated.length(); i++) {
		int s = i;
		for (int j = i+1; j < bl_rotated.length(); j++) {
			if (length(bl_rotated[s] + position) < length(bl_rotated[j] + position)) {
				s = j;
			}
		}
		if (s != i) {
			temp          = bl_rotated[s];
			bl_rotated[s] = bl_rotated[i];
			bl_rotated[i] = temp;
		}
	}
	
	// draw faces
	for (int bl = 0; bl < bl_rotated.length(); bl++) {
		for (int i = 0; i < 3; i++) {
			// the rotation matrix is column per column the result of the transformation of (1;0;0), (0;1;0) and (0;0;1)
			// the 6 faces of the blocks have each of their normals being one of either those or the opposites
			// for each column of the matrix, either that vector or its opposite is pointing towards the camera
			// (ie v and -v can't both be pointing towards the camera) so we can pair them off and draw just one
			// so we can iterate over the matrix columns and if the vector is not facing us we draw the opposite face instead
			vec3 facenorm = orientation[i];
			if (dot(facenorm, uvdir) > 0) {
				facenorm = -facenorm;
			}
			drawSquare(
				px_colour,
				facenorm,
				// this is the center of the face, it is away from the middle of the block towards the face's normal
				bl_rotated[bl] + .45 * facenorm * size,
				// we use the other two columns in the rotation matrix for the up and right vectors of the face
				orientation[i>=2 ? i-2 : i+1],
				orientation[i>=1 ? i-1 : i+2],
				uvdir,
				size * .9
			);
		}
	}
}


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
		// compute a transformation matrix too to apply to the normalmap
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


#ifdef PIXEL
vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords){
    //scaling uvs
    vec2 uv2 = uvs - .5;
    uv2.x *= love_ScreenSize.x/love_ScreenSize.y;
    uv2 *= 2*SCREENHEIGHT;

    // direction of camera pixel
    vec3 uvdir = normalize(vec3(uv2, 1));
	
    // background colour
    vec3 colour = BG_COLOUR;
	
	// space cloudssssssssssssssssss
	colour += hsv2rgb(vec3(
		// hue varying smoothly on uvs and time
		noise(vec3(uv2*4., time*.1)),
		// not too bright but that doesn't need to vary
		.5,
		// value as fbm because fbm is good at making clouds
		.7*fbm(vec3(uv2*10., time*.1))
	));
	
	// piece position / angle
	vec3 piece_pos = vec3(170, -70+10*sin(.5*time), 500);
	mat3 rotation = yaw(cos(.5*time))*pitch(.3*time)*roll(.11*time);
	
	// get 2 pieces and interpolate block positions for
	// an animation of the piece morphing from one to the other
	vec3[5]  current_piece = getPieceForLevel(level);
	vec3[5] previous_piece = getPieceForLevel(levelprev);
	for (int i = 0; i < 5; i++)
		current_piece[i] = mix(previous_piece[i], current_piece[i], smoothstep(0., TRANSITION_TIME, leveltime));
	drawPiece(colour, piece_pos, rotation, current_piece, PIECE_SIZE, uvdir);
	
	
    ballpoint moonpoint = pointOnBall(uvdir, moonpos, moonsize, moonaxis, moonback, moonleft);
    if (moonpoint.valid) {
		// put the coordinates from latitude-longitude into x-y in a [0;1] range
		// the `- .1*time` bit on latitude is to make the moon appear to spin
        vec2 mooncoords = vec2(mod(moonpoint.latitude - .1*time, TAU)/TAU, moonpoint.longitude/PI +.5);
		
		// from those coordinates, poll the texture and the normal map
        colour = Texel(moontex, mooncoords).xyz;
        vec3 mapnormal = Texel(moonnor, mooncoords).xyz * 2. - 1.;
		// scaling the normal's z and renormalising it to affect the "bumpiness"
		mapnormal.z *= .5;
		mapnormal = normalize(mapnormal);
		
		// apply a filter that literally maps the coordinates to hsl because rainbow
        colour *= hsl2rgb(vec3(mooncoords.x, 1., mooncoords.y));
		// also apply the normalmap for shadows
		colour *= (.5+.5*dot(moonpoint.normaltransform * mapnormal, -uvdir));
    }
	return vec4(colour, 1.);
}
#endif

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position){
    return transform_projection * vertex_position;
}
#endif
