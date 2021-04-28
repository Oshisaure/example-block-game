#define MAXDIST .005
#define SAMPLES 50
#define XSTEP 1./SAMPLES

uniform float time;
uniform float dt;
uniform float[SAMPLES+1] soundL;
uniform float[SAMPLES+1] soundR;
uniform float avgL;
uniform float avgR;
#ifdef PIXEL

vec2 proj(vec2 a, vec2 b, vec2 m) {
    vec2 v = b-a;
    vec2 w = m-a;
    return a+(b-a)*clamp(dot(v,w)/dot(v,v),0,1);
}

vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords){
    /*
    vec4 oldpixel = Texel(image, uvs);
    return oldpixel * color;
    */
    
    float dL = MAXDIST*2;
    float dR = MAXDIST*2;
    // float avg = 0.;
    
    for (int i = 0; i < SAMPLES; i++) {
        dL = min(dL, distance(uvs, proj(vec2(i*XSTEP, .5 + .5*soundL[i]), vec2((i+1)*XSTEP, .5 + .5*soundL[i+1]), uvs)));
        dR = min(dR, distance(uvs, proj(vec2(i*XSTEP, .5 + .5*soundR[i]), vec2((i+1)*XSTEP, .5 + .5*soundR[i+1]), uvs)));
        // avg += abs(soundL[i]*soundR[i])/SAMPLES;
    }
    float resL = smoothstep(-MAXDIST, 0, -dL);
    float resR = smoothstep(-MAXDIST, 0, -dR);
    return vec4(resL+avgL, max(resL, resR), resR+avgR, 1);
}
#endif

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position){
    return transform_projection * vertex_position;
}
#endif
