uniform float dt;
uniform float time;
#define PI       3.141592653589793238463
#define TAU      6.283185307179586476925
#define ROOT432 20.784609690826527522329

#define SEALEVEL     20.
#define TIDEHEIGHT    2.
#define TIDESPREADX  20.
#define TIDESPREADY  40.
#define FIELDOFVIEW  45.

float badsin(float k) {
    float m = mod(k/TAU, 1);
    return ROOT432*m*(m-.5)*(m-1);
}


#ifdef PIXEL
vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords){
    float aspectratio = love_ScreenSize.y/love_ScreenSize.x;
    vec2 uv2 = uvs - .5;
    uv2.y *= aspectratio;
    // background colour
    vec4 newpixel = vec4(.0, .0, .0, 1.);
    if (uv2.y > 0) {
        // ground: grid thing
        newpixel += uv2.y*max(smoothstep(.1, .0, abs(mod(uv2.x/uv2.y, 1)-.5)), pow(mod(time-1/uv2.y, 1), 4))*0.6;
    } else {
        // sky: noise clouds
        // vec2 uv2 = uvs - .5;
        // uv2.y *= -1;
        // newpixel += vec4(2., 0., 2., 0.)*uv2.y*noise(25.*vec2(uv2.x/uv2.y, time-1./uv2.y));
    }
    
    // return color * mix(oldpixel, newpixel, 1-pow(64, -dt));
    return newpixel;
}
#endif

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position){
    return transform_projection * vertex_position;
}
#endif
