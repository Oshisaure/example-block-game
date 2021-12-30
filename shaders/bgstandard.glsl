uniform float dt;
uniform float time;

#define PI  3.141592653589793238463
#define TAU 6.283185307179586476925
#define SCREENHEIGHT .35
const vec3 ORIGIN    = vec3(0., 0., 0.);
const vec3 LIGHTDIR  = vec3(0., 0., -1.);
const vec3 BG_COLOUR = vec3(.8, .8, 1.);

const vec3[4] DEF_I = vec3[4](vec3(-1.5, 0.0, 0.0), vec3(-0.5, 0.0, 0.0), vec3( 0.5, 0.0, 0.0), vec3( 1.5, 0.0, 0.0));
const vec3[4] DEF_L = vec3[4](vec3( 0.0, 0.0, 0.0), vec3( 1.0, 0.0, 0.0), vec3( 1.0,-1.0, 0.0), vec3(-1.0, 0.0, 0.0));
const vec3[4] DEF_J = vec3[4](vec3( 0.0, 0.0, 0.0), vec3( 1.0, 0.0, 0.0), vec3(-1.0,-1.0, 0.0), vec3(-1.0, 0.0, 0.0));
const vec3[4] DEF_T = vec3[4](vec3( 0.0, 0.0, 0.0), vec3( 1.0, 0.0, 0.0), vec3( 0.0,-1.0, 0.0), vec3(-1.0, 0.0, 0.0));
const vec3[4] DEF_S = vec3[4](vec3( 0.0, 0.0, 0.0), vec3(-1.0, 0.0, 0.0), vec3( 0.0,-1.0, 0.0), vec3(-1.0,-1.0, 0.0));
const vec3[4] DEF_Z = vec3[4](vec3( 0.0, 0.0, 0.0), vec3( 1.0, 0.0, 0.0), vec3( 0.0,-1.0, 0.0), vec3( 1.0,-1.0, 0.0));
const vec3[4] DEF_O = vec3[4](vec3( 0.5, 0.5, 0.0), vec3( 0.5,-0.5, 0.0), vec3(-0.5, 0.5, 0.0), vec3(-0.5,-0.5, 0.0));

#define SIZE_I 40.
#define SIZE_L 40.
#define SIZE_J 40.
#define SIZE_T 40.
#define SIZE_S 40.
#define SIZE_Z 40.
#define SIZE_O 40.

const vec3 COLOUR_I = vec3( 83, 38,128)/255.;
const vec3 COLOUR_L = vec3(128, 38, 38)/255.;
const vec3 COLOUR_J = vec3( 38,128,128)/255.;
const vec3 COLOUR_T = vec3( 38,128, 83)/255.;
const vec3 COLOUR_S = vec3(128,128, 38)/255.;
const vec3 COLOUR_Z = vec3( 38, 38,128)/255.;
const vec3 COLOUR_O = vec3(128, 83,128)/255.;

// from https://en.wikipedia.org/wiki/Line%E2%80%93plane_intersection#Algebraic_form //
vec3 linePlaneIntersect(vec3 planenorm, vec3 planepoint, vec3 linedir, vec3 linepoint) {
	return linepoint + linedir * (dot(planepoint-linepoint, planenorm)/dot(linedir, planenorm));
}

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
/*
void sortMatByClosest(inout mat3 m, vec3 pos) {
	for (int i = 0; i < 3; i++) {
		if (dot(m[i], pos) > 0) m[i] *= -1;
	}
	vec3 temp;
	for (int j = 0; j <= 1; j++) {
		for (int i = 1; i < 3; i++) {
			if (length(m[i-1] + pos) > length(m[i] + pos)) {
				temp = m[i-1];
				m[i-1] = m[i];
				m[i] = temp;
			}
		}
	}
}

void sortBlocksByClosest(inout box[4] p) {
	box temp;
	for (int i = 0; i < p.length(); i++) {
		int s = i;
		for (int j = i+1; j < p.length(); j++) {
			if (length(p[s].position) < length(p[j].position)) {
				s = j;
			}
		}
		if (s != i) {
			temp = p[s];
			p[s] = p[i];
			p[i] = temp;
		}
	}
}

box[4] makePiece(vec3 pos, vec3[4] piecedef, float yawangle, float pitchangle, float rollangle, float size, vec3 colour) {
	mat3 orientation = yaw(yawangle)*pitch(pitchangle)*roll(rollangle);
	box[4] bl;
	for (int i = 0; i < 4; i++) {
		vec3 blockpos = pos+orientation*piecedef[i]*size;
		mat3 faces = orientation;
		sortMatByClosest(faces, blockpos);
		bl[i] = box(
			blockpos,
			size,
			colour,
			faces[2],
			faces[1],
			faces[0]
		);
	}
	sortBlocksByClosest(bl);
	return bl;
}
*/
void drawSquare(inout vec3 pxcolour, vec3 norm, vec3 pos, vec3 sideA, vec3 sideB, vec3 uvdir, float size, vec3 sqcolour) {
	vec3 intersect = linePlaneIntersect(norm, pos, uvdir, ORIGIN) - pos;
	vec2 sqpos = vec2(dot(intersect, sideA), dot(intersect, sideB));
	if (sqpos == clamp(sqpos, -size*.5, size*.5)) {
		pxcolour = sqcolour * .5 * (1.+dot(reflect(uvdir, norm), -uvdir));
	}
}
/*
void drawBlock(inout vec3 colour, box block, vec3 uvdir) {
	drawSquare(colour, block.front, .5*block.size*block.front + block.position, block.side , block.top  , uvdir, block.size, block.colour);
	drawSquare(colour, block.top  , .5*block.size*block.top   + block.position, block.front, block.side , uvdir, block.size, block.colour);
	drawSquare(colour, block.side , .5*block.size*block.side  + block.position, block.top  , block.front, uvdir, block.size, block.colour);
}


void drawPiece(inout vec3 colour, box[4] p, vec3 uvdir) {
	for (int i = 0; i < 4; i++) drawBlock(colour, p[i], uvdir);
}
*/

void drawPiece(inout vec3 px_colour, vec3 position, mat3 orientation, vec3[4] blocks, float size, vec3 piece_colour, vec3 uvdir) {
	// apply rotation/scale/translation
	vec3[4] bl_rotated;
	for (int i = 0; i < 4; i++) {
		bl_rotated[i] = orientation*(blocks[i] * size) + position;
	}
	
	// sort by closest
	vec3 temp;
	for (int i = 0; i < 4; i++) {
		int s = i;
		for (int j = i+1; j < 4; j++) {
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
	for (int bl = 0; bl < 4; bl++) {
		for (int i = 0; i < 3; i++) {
			vec3 facenorm = orientation[i];
			if (dot(facenorm, uvdir) > 0) {
				facenorm = -facenorm;
			}
			drawSquare(
				px_colour,
				-facenorm,
				bl_rotated[bl] + .45 * facenorm * size,
				orientation[i>=2 ? i-2 : i+1],
				orientation[i>=1 ? i-1 : i+2],
				uvdir,
				size * .9,
				piece_colour
			);
		}
	}
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
	/*
	box[4] PieceT = makePiece(
		vec3(80, -80, 400),
		DEF_T,
		0,
		0,
		0.1*time,
		20,
		COLOUR_T
	);
	*/
	// piece defs
	vec3 pos_t = vec3(80, -80, 400);
	
	mat3 rot_t = yaw(3*time)*pitch(7*time)*roll(5*time);
	
	drawPiece(colour,
		pos_t,
		rot_t,
		DEF_T,
		40.,
		COLOUR_T,
		uvdir
	);
	
	return vec4(colour, 1.);
}
#endif

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position){
    return transform_projection * vertex_position;
}
#endif
