uniform float dt;
uniform float time;
uniform int level;
#define RANGE 2
#define SCALE 2

const vec4 BG0X = vec4(.2, .0, .5, 1.);
const vec4 BG1X = vec4(.5, .0, .2, 1.);
const vec4 BGXX = vec4(.5, .0, .0, 1.);
const vec4 BGPb = vec4(.3, .3, .4, 1.);
const vec4 BGSn = vec4(.2, .2, .2, 1.);
const vec4 BGFe = vec4(.3, .3, .3, 1.);
const vec4 BGCu = vec4(.5, .2, .0, 1.);
const vec4 BGAg = vec4(.5, .5, .5, 1.);
const vec4 BGAu = vec4(.4, .3, .1, 1.);

const vec4 cloudsXX = vec4(2., 0., 2., 1.);
const vec4 cloudsPb = vec4(2., 2., 0., 1.);
const vec4 cloudsSn = vec4(0., 0., 0., 1.);
const vec4 cloudsFe = vec4(2., .4, 0., 1.);
const vec4 cloudsCu = vec4(-1.,2., 2., 1.);
const vec4 cloudsAg = vec4(1.5,1.5,2., 1.);
const vec4 cloudsAu = vec4(2., 2., 0., 1.);
const vec4 cloudsIn = vec4(2., 2., 2., 1.);

// from http://lolengine.net/blog/2013/07/27/rgb-to-hsv-in-glsl //
const vec4 K = vec4(1., 2. / 3., 1. / 3., 3.);
vec3 hsv2rgb(vec3 c) {
    vec3 p = abs(fract(c.xxx + K.xyz) * 6. - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0., 1.), c.y);
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
///////////////////////////////////////////////////////////////////////////

vec4 getBGColor() {
	if (level <= 10) return BG0X;
	if (level <= 20) return BG1X;
	if (level <= 30) return BGXX;
	if (level == 31) return BGPb;
	if (level == 32) return BGSn;
	if (level == 33) return BGFe;
	if (level == 34) return BGCu;
	if (level == 35) return BGAg;
	if (level == 36) return BGAu;
	return vec4(hsv2rgb(vec3(time*.0666, .7, .4)), 1.);
}

vec4 getCloudColor() {
	if (level <= 30) return cloudsXX;
	if (level == 31) return cloudsPb;
	if (level == 32) return cloudsSn;
	if (level == 33) return cloudsFe;
	if (level == 34) return cloudsCu;
	if (level == 35) return cloudsAg;
	if (level == 36) return cloudsAu;
	return cloudsIn;
}

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
    vec4 newpixel = getBGColor();
    vec2 uv2 = uvs - .5;
    uv2.x *= love_ScreenSize.x/love_ScreenSize.y;
    if (uvs.y > .5) {
        // ground: grid thing
        newpixel += uv2.y*max(smoothstep(.1, .0, abs(fract(uv2.x/uv2.y)-.5)), pow(fract(time-1/uv2.y), 4))*0.6;
    } else {
        // sky: noise clouds
        uv2.y *= -1;
        newpixel += getCloudColor()*uv2.y*noise(25.*vec2(uv2.x/uv2.y, time-1./uv2.y));
    }
    
    return color * mix(oldpixel, newpixel, 1-pow(64, -max(dt, 0.01)));
    // return newpixel;
}
#endif

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position){
    return transform_projection * vertex_position;
}
#endif
