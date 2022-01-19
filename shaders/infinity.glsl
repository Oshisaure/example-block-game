uniform float time;


/*
  0102      0607  
09    12  14    17
18      22      26 
27    30  32    35 
  3738      4243  
*/
// 20 pixels are in the loop (double counting the crossing point)
#define delta 0.05

// from http://lolengine.net/blog/2013/07/27/rgb-to-hsv-in-glsl //
const vec4 K = vec4(1., 2. / 3., 1. / 3., 3.);
vec3 hsv2rgb(vec3 c) {
    vec3 p = abs(fract(c.xxx + K.xyz) * 6. - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0., 1.), c.y);
}
//////////////////////////////////////////////////////////////////

#ifdef PIXEL
vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords){
	int index = int(uvs.y*5)*9+int(uvs.x*9);
	float offset;
	     if (index == 22) offset = min(fract(time), fract(time+.5)); // this is either 0*delta or 10*delta
	
	else if (index == 12) offset = fract(time +  1*delta);
	else if (index ==  2) offset = fract(time +  2*delta);
	else if (index ==  1) offset = fract(time +  3*delta);
	else if (index ==  9) offset = fract(time +  4*delta);
	else if (index == 18) offset = fract(time +  5*delta);
	else if (index == 27) offset = fract(time +  6*delta);
	else if (index == 37) offset = fract(time +  7*delta);
	else if (index == 38) offset = fract(time +  8*delta);
	else if (index == 30) offset = fract(time +  9*delta);
	
	else if (index == 14) offset = fract(time + 11*delta);
	else if (index ==  6) offset = fract(time + 12*delta);
	else if (index ==  7) offset = fract(time + 13*delta);
	else if (index == 17) offset = fract(time + 14*delta);
	else if (index == 26) offset = fract(time + 15*delta);
	else if (index == 35) offset = fract(time + 16*delta);
	else if (index == 43) offset = fract(time + 17*delta);
	else if (index == 42) offset = fract(time + 18*delta);
	else if (index == 32) offset = fract(time + 19*delta);
	
	else return vec4(0.); // not part of the infinity sign
	
	
    return vec4(hsv2rgb(vec3(offset+time*.5, .5, 1.-.5*offset)), 1.) * color;
}
#endif

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position){
    return transform_projection * vertex_position;
}
#endif