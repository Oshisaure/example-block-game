uniform vec2 Direction;
uniform int Spread;

float gaussian(float x) {
    return exp(-.5*pow(x, 2));
}

#ifdef PIXEL
vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords){
    vec3 result = vec3(0.);
    float weightsum = 0.;
    for (int i = 0; i <= 10; i++) {
        vec2 vtex = i*Direction*Spread/4000;
        float weight = gaussian(length(vtex)*Spread);
        weightsum += weight;
        vec3 left  = Texel(image, uvs - vtex).xyz;
        vec3 right = Texel(image, uvs + vtex).xyz;
        result += .5*weight*(left + right);
    }
    
    return vec4(result/weightsum, 1.);
}
#endif

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position){
    return transform_projection * vertex_position;
}
#endif
