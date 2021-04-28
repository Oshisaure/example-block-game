uniform float time;

// from http://lolengine.net/blog/2013/07/27/rgb-to-hsv-in-glsl //
const vec4 K = vec4(1., 2. / 3., 1. / 3., 3.);
vec3 hsv2rgb(vec3 c) {
    vec3 p = abs(fract(c.xxx + K.xyz) * 6. - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0., 1.), c.y);
}
//////////////////////////////////////////////////////////////////

#ifdef PIXEL
vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords){
    vec4 pixel = Texel(image, uvs);
    return pixel * color * vec4(hsv2rgb(vec3(time + uvs.x, 0.5, 1)), 1);
}
#endif

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position){
    return transform_projection * vertex_position;
}
#endif
