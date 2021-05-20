uniform float dt;
uniform float time;
#define RANGE 2
#define SCALE 2

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
///////////////////////////////////////////////////////////////////////////

#ifdef PIXEL
vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords){
    // shitty box blur previous frame
    vec4 oldpixel = vec4(0.);
    for (int i = -RANGE; i <= RANGE; i++) {
        for (int j = -RANGE; j <= RANGE; j++) {
            oldpixel += Texel(image, uvs+SCALE*vec2(i, j)/love_ScreenSize.xy);
        }
    }
    oldpixel /= 4*RANGE*(RANGE+1)+1;
    
    // background colour
    vec4 newpixel = vec4(.2, .0, .5, 1.);
    vec2 uv2 = uvs - .5;
    uv2.x *= love_ScreenSize.x/love_ScreenSize.y;
    if (uvs.y > .5) {
        // ground: grid thing
        newpixel += uv2.y*max(smoothstep(.1, .0, abs(mod(uv2.x/uv2.y, 1)-.5)), pow(mod(time-1/uv2.y, 1), 4))*0.6;
    } else {
        // sky: noise clouds
        uv2.y *= -1;
        newpixel += vec4(2., 0., 2., 0.)*uv2.y*noise(25.*vec2(uv2.x/uv2.y, time-1./uv2.y));
    }
    
    return color * mix(oldpixel, newpixel, 1-pow(64, -dt));
    // return newpixel;
}
#endif

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position){
    return transform_projection * vertex_position;
}
#endif
