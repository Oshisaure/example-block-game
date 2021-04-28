#define UV_CENTRE vec2(0.5, 0.5)

#ifdef PIXEL
extern mat3x3 shift;
extern vec3 angle;
extern vec2 distort;
extern float time;

float random(in float s){
    return fract(sin(s)*100000.);
}

vec2 random2(in float s) {
    return vec2(random(s), random(s+1.));
}

mat2 rotateOrigin(in float ang){
    float c = cos(ang);
    float s = sin(ang);
    return mat2(c,-s,
                s, c);
}

vec2 rotateAround(in vec2 uv, in vec2 centre, in float angle) {
    return ( (uv-centre) * rotateOrigin(angle) ) + centre;
}

vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords){
    //vec4 pixel = Texel(image, uvs);
    float pixelr = Texel(image, random2(time+0.+uvs.x+uvs.y)*distort + rotateAround(uvs, UV_CENTRE, angle.r)+shift[0].xy).r;
    float pixelg = Texel(image, random2(time+2.+uvs.x+uvs.y)*distort + rotateAround(uvs, UV_CENTRE, angle.g)+shift[1].xy).g;
    float pixelb = Texel(image, random2(time+4.+uvs.x+uvs.y)*distort + rotateAround(uvs, UV_CENTRE, angle.b)+shift[2].xy).b;
    
    return vec4(pixelr, pixelg, pixelb, color.a);
}
#endif

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position){
    return transform_projection * vertex_position;
}
#endif