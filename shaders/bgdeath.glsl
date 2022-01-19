uniform float time;

#define HEIGHTFLOOR 2.
#define HEIGHTSKY   -2.
#define SPIKEHEIGHT 0.2
#define RAYSTEP     0.2 
#define RAYREACH    10.

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

#ifdef PIXEL
vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords){
    // 3d-ized uvs
    vec2 uv2 = uvs*2.-1.;
    uv2.x *= love_ScreenSize.x/love_ScreenSize.y;
    vec3 uvdir = normalize(vec3(uv2, 1));
    
    // Cloud background
    vec2 planecoord = HEIGHTSKY*uvdir.xz/uv2.y;
    vec4 newpixel = vec4(noise(planecoord+vec2(0., time))/planecoord.y, 0., 0., 1.);
    
    // Iterate up to a maximum length to simulate the ray's trajectory
    for (vec3 ray = vec3(0.); length(ray) < RAYREACH; ray += uvdir*RAYSTEP) {
        float maxheight = SPIKEHEIGHT*ray.x*ray.x;
        float curheight = -ray.y + HEIGHTFLOOR;
        // Use noise to generate random spikes
        // If the ray is under the spike then we just hit it
        if (curheight < maxheight*noise(ray.xz+vec2(0., time))) {
            // Red component is just how far the ray is from the camera
            float bright = curheight*(1.-length(ray)/RAYREACH);
            // Yellow component scales with the maximum possible height of the spike
            float yellow = bright*curheight*curheight/maxheight/maxheight;
            newpixel = vec4(bright, yellow, 0., 1.);
            break;
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
