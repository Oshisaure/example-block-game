// adapted from https://stackoverflow.com/questions/5281261/generating-a-normal-map-from-a-height-map //
uniform vec3 off; // will be specified when generating the normal map
const vec2 size = vec2(.3,0.0);
#ifdef PIXEL
vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords){
    float s01 = Texel(image, uvs - off.xz).x;
    float s21 = Texel(image, uvs + off.xz).x;
    float s10 = Texel(image, uvs - off.zy).x;
    float s12 = Texel(image, uvs + off.zy).x;
    vec3 va = normalize(vec3(size.xy,s21-s01));
    vec3 vb = normalize(vec3(size.yx,s12-s10));
    vec3 bump = normalize(cross(va,vb));

    return vec4(bump*.5+.5, 1);
}
#endif

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position){
    return transform_projection * vertex_position;
}
#endif