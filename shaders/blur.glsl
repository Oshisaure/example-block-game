uniform vec2 Direction;
uniform int Spread;

float gaussian(float x) {
    return exp(-.5*pow(x, 2));
}

#ifdef PIXEL
vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords){
    vec4 result = vec4(0.);
    float weightsum = 0.;
    for (int i = 0; i <= Spread; i++) {
        vec2 vtex = i*Direction/love_ScreenSize.xy;
        float weight = gaussian(length(vtex));
        weightsum += weight;
        result += .5*weight*(Texel(image, uvs + vtex) + Texel(image, uvs - vtex));
    }
    
    return vec4(result.xyz/weightsum, 1.);
}
#endif

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position){
    return transform_projection * vertex_position;
}
#endif
