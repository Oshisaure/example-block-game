uniform float dt;
uniform float time;

// from https://gist.github.com/patriciogonzalezvivo/670c22f3966e662d2f83 //
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
////////////////////////////////////////////////////////////////////////////

// adapted from https://stackoverflow.com/questions/849211/shortest-distance-between-a-point-and-a-line-segment //
float line_distance(vec2 v, vec2 w, vec2 p) {
  // Return minimum distance between line segment vw and point p
  vec2 vw = w - v;
  float l2 = dot(vw, vw);  // i.e. |w-v|^2 -  avoid a sqrt
  if (l2 == 0.0) return distance(p, v);   // v == w case
  // Consider the line extending the segment, parameterized as v + t (w - v).
  // We find projection of point p onto the line. 
  // It falls where t = [(p-v) . (w-v)] / |w-v|^2
  // We clamp t from [0,1] to handle points outside the segment vw.
  float t = max(0, min(1, dot(p - v, vw) / l2));
  vec2 projection = v + t * vw;  // Projection falls on the segment
  return distance(p, projection);
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

float rand1(float s){
    return fract(sin(s)*100000.);
}

#ifdef PIXEL
vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords){
    // previous frame
    vec4 oldpixel = Texel(image, (uvs-.5)*pow(1.2, dt)+.5);
    
    // background colour
    vec4 newpixel = vec4(.1, .1, .3, 1.);
    // noise clouds
    float angle = .5*cos(time*.1);
    float c = cos(angle);
    float s = sin(angle);
    vec2 uv2 = mat2(c, -s, s, c)*(uvs - .5);
    uv2.y = abs(uv2.y);
    uv2.x *= love_ScreenSize.x/love_ScreenSize.y;
    vec2 skypoint = vec2(uv2.x/uv2.y, 10.*time-1./uv2.y);
    // lightning
    float lightningintensity = 1-fract(time*.4);
    float lightningcount = time*.4 + lightningintensity;
    vec2 lightningabs = vec2(rand1(lightningcount)-.5, rand1(lightningcount+rand1(lightningcount))*.2+.1);
    lightningabs.x = sign(lightningabs.x)*sqrt(abs(lightningabs.x));
    vec2 lightningsky = vec2(lightningabs.x/lightningabs.y,10.*time-1./lightningabs.y);
    float d = line_distance(lightningabs, vec2(lightningabs.x, 0.), uv2)*20.;
    
    newpixel += vec4(.5, 1.5, 1.5, 0.)*uv2.y*noise(10.*skypoint)*(1+lightningintensity*3./distance(skypoint, lightningsky));
    newpixel += vec4(1.,1.,1.,0.)*lightningintensity/(1+d*d);
    
    
    return color * mix(oldpixel, newpixel, 1-pow(64, -dt));
    // return newpixel;
}
#endif

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position){
    return transform_projection * vertex_position;
}
#endif
