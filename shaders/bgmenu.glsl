uniform float dt;
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
    // pick a point that moves around the screen
    vec2 focus = .4*vec2(cos(time*.45), sin(time*.44)) + .5;
    vec2 uv2 = uvs - focus;
    // rescale previous frame around said moving point
    vec3 oldpixel = pow(.9, dt)*Texel(image, uv2*pow(5., dt) + focus).xyz;
    // ooo rainbow funny
    vec3 overlay = hsv2rgb(vec3(time*.1, 1., .5*sin(2*time)+.5));
    // apply rainbow to edge of screen (which will be rescaled on the next frame hence tunnel effect)
    vec2 uvabs = abs(uvs-.5);
    return vec4(mix(oldpixel, overlay, smoothstep(0.49, 0.5, max(uvabs.x, uvabs.y))), 1.);
}
#endif

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position){
    return transform_projection * vertex_position;
}
#endif
