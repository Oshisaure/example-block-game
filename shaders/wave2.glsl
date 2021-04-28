#define SAMPLES 200
#define TAU 6.28318530717958647692528676655900576839
#define MAXFREQ .5*samplerate
#define MINFREQ SAMPLES/samplerate

uniform float dt;
uniform int samplerate;
uniform float[SAMPLES+1] soundL;
uniform float[SAMPLES+1] soundR;


const vec4 K = vec4(1., 2. / 3., 1. / 3., 3.);
vec3 hsv2rgb(vec3 c) {
    // from http://lolengine.net/blog/2013/07/27/rgb-to-hsv-in-glsl
    vec3 p = abs(fract(c.xxx + K.xyz) * 6. - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0., 1.), c.y);
}

vec2 ftL(float freq) {
    vec2 sum = vec2(0.,0.);
    float arg = 0.;
    for (int i = 0; i < soundL.length(); i++) {
        arg = -freq * TAU * i / samplerate;
        sum += vec2(cos(arg), sin(arg)) * soundL[i];
    }
    return sum;
}

vec2 ftR(float freq) {
    vec2 sum = vec2(0.,0.);
    float arg = 0.;
    for (int i = 0; i < soundR.length(); i++) {
        arg = -freq * TAU * i / samplerate;
        sum += vec2(cos(arg), sin(arg)) * soundR[i];
    }
    return sum;
}

#ifdef PIXEL
vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords){
    
    vec4 oldpixel = Texel(image, uvs);
    // return oldpixel * color;
    
    // float avg = 0.;
    
    
    // uvs.x -= .5;
    float freq = mix(MINFREQ, MAXFREQ, distance(uvs, vec2(.5)));
    float fR = length(ftR(freq));
    float fL = length(ftL(freq));
    vec4 newpixel = vec4(fR*fR, fL*fL, fR*fL, 1);
    return mix(oldpixel, newpixel, pow(.15, 60*dt));
}
#endif

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position){
    return transform_projection * vertex_position;
}
#endif
