uniform float dt;
uniform float time;
uniform int level;
#define SCREENHEIGHT 240
#define LINEWIDTH .15
#define NOISEAMOUNT .03
const vec3 ORIGIN = vec3(0.);
// const vec4 bgcolour   = vec4(.3, .4, .3, 1.);
// const vec4 linecolour = vec4(.3, .9, .3, 1.);
const vec3 forward      = vec3( 0., 0., 1.);
const vec3 plane1normal = vec3( 0., 1., 0.);
const vec3 plane1side   = vec3(-1., 0., 0.);
const vec3 plane1point  = vec3( 0., 2., 0.);
const vec3 plane2normal = vec3( 0.,-1., 0.);
const vec3 plane2point  = vec3( 0.,-5., 0.);
const vec3 plane2side   = vec3( 1., 0., 0.);
const mat2 planeangle = mat2(cos(.5), sin(.5),
                            -sin(.5), cos(.5)); 
const vec4[10] BG_COLOUR_ARRAY = vec4[](
	vec4(  0/255.,  88/255., 248/255., 1.),
	vec4(  0/255., 168/255.,   0/255., 1.),
	vec4(216/255.,   0/255., 204/255., 1.),
	vec4(  0/255.,  88/255., 248/255., 1.),
	vec4(228/255.,   0/255.,  88/255., 1.),
	vec4(104/255., 136/255., 252/255., 1.),
	vec4(124/255., 124/255., 124/255., 1.),
	vec4(168/255.,   0/255.,  32/255., 1.),
	vec4(  0/255.,  88/255., 248/255., 1.),
	vec4(248/255.,  56/255.,   0/255., 1.)
);
const vec4[10] FG_COLOUR_ARRAY = vec4[](
	vec4( 60/255., 188/255., 252/255., 1.),
	vec4(184/255., 248/255.,  24/255., 1.),
	vec4(248/255., 120/255., 248/255., 1.),
	vec4( 88/255., 216/255.,  84/255., 1.),
	vec4( 88/255., 248/255., 152/255., 1.),
	vec4( 88/255., 248/255., 152/255., 1.),
	vec4(248/255.,  56/255.,   0/255., 1.),
	vec4(104/255.,  68/255., 252/255., 1.),
	vec4(248/255.,  56/255.,   0/255., 1.),
	vec4(252/255., 160/255.,  68/255., 1.)
);

// from https://en.wikipedia.org/wiki/Line%E2%80%93plane_intersection#Algebraic_form //
vec3 linePlaneIntersect(vec3 planenorm, vec3 planepoint, vec3 linedir, vec3 linepoint) {
	return linepoint + linedir * (dot(planepoint-linepoint, planenorm)/dot(linedir, planenorm));
}

//from https://gist.github.com/patriciogonzalezvivo/670c22f3966e662d2f83 //
float rand(vec2 n) { 
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

#ifdef PIXEL
vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords){
	// determine closest "big pixel" position - we're using this instead of the actual position from there on
	float aspectratio = love_ScreenSize.x/love_ScreenSize.y;
	float pxscale = ceil(love_ScreenSize.y / SCREENHEIGHT); //size of the "big pixel" in real-screen pixels
	vec2 pxsize = pxscale/love_ScreenSize.xy;  // uv range of a "big pixel"
	vec2 uvpx = uvs/pxsize; //uvs stretched to "big pixel" units
	vec2 pxcoord = (floor(uvpx)+.5) * pxsize; // uv position of the "big pixel" we're on
	vec2 subpxuv = (fract(uvpx)-.5); // position inside the "big pixel" (used later for glowing pixel effect)
	
	// sample previous frame, make it transparent a bit to make it like the pixels take time to fade out
    vec4 oldpixel = Texel(image, pxcoord);
	oldpixel.a = pow(0.01, dt);
	
    // background colour, prep for 3d funnies
	int bgindex = int(mod(level-1, 10));
    if (level > 30) bgindex += 10;
    vec4 newpixel = BG_COLOUR_ARRAY[bgindex];
	vec4 linecolour = FG_COLOUR_ARRAY[bgindex];
	vec2 uv2 = pxcoord - .5;
	uv2.x *= aspectratio;
	uv2 = planeangle * uv2; // rotated uvs because that's easier than doing a rotated plane lol
    vec3 uvdir = normalize(vec3(uv2, 1)); // direction of our (rotated) camera beam
	
	// two planes where we draw either a / or a \, similar to that one C64 program
	vec3 intersect1 = linePlaneIntersect(plane1normal, plane1point, uvdir, ORIGIN) - plane1point; // vector from the point of origin to the intersection
	if (intersect1.z > 0. && intersect1.z < 20.) {
		vec2 plane1pos = vec2(dot(intersect1, plane1side), dot(intersect1, forward)+time*.22); //same vector, projected into to the plane's coord system
		vec2 plane1cell = floor(plane1pos); // index of the tile we're on
		vec2 plane1frac = fract(plane1pos); // subtile position
		float distfactor1 = 1. - pow(intersect1.z/20., 2); // distance to camera (more or less)
		if (rand(plane1cell) < .5) {
			// doing a / line
			if (abs(plane1frac.y-plane1frac.x) < LINEWIDTH) newpixel = mix(newpixel, linecolour, distfactor1);
		} else {
			// doing a \ line
			if (abs(plane1frac.y+plane1frac.x - 1.) < LINEWIDTH) newpixel = mix(newpixel, linecolour, distfactor1);
		}
		// add a bit of random noise cause idk it looks more interesting or something
		newpixel.rgb += (clamp(vec3(rand(plane1pos), rand(plane1pos+1.), rand(plane1pos-1.)),1-NOISEAMOUNT, 1.)-1.+NOISEAMOUNT)/NOISEAMOUNT*distfactor1;
	}
	
	//same exact stuff with different values
	vec3 intersect2 = linePlaneIntersect(plane2normal, plane2point, uvdir, ORIGIN) - plane2point;
	if (intersect2.z > 0. && intersect2.z < 30.) {
		vec2 plane2pos = vec2(dot(intersect2, plane2side), dot(intersect2, forward)+time*.44);
		vec2 plane2cell = floor(plane2pos);
		vec2 plane2frac = fract(plane2pos);
		float distfactor2 = 1. - pow(intersect2.z/30., 2);
		if (rand(plane2cell) < .5) {
			if (abs(plane2frac.y-plane2frac.x) < LINEWIDTH) newpixel = mix(newpixel, linecolour, distfactor2);
		} else {
			if (abs(plane2frac.y+plane2frac.x - 1.) < LINEWIDTH) newpixel = mix(newpixel, linecolour, distfactor2);
		}
		newpixel.rgb += (clamp(vec3(rand(plane2pos), rand(plane2pos+1.), rand(plane2pos-1.)),1-NOISEAMOUNT, 1.)-1.+NOISEAMOUNT)/NOISEAMOUNT*distfactor2;
	}
	
	// merging old transparent frame and new frame, and adding a bit of brightness decay with distance
	vec4 finalpixel = mix(newpixel, oldpixel, pow(2., -15*dt));
	if (ceil(love_ScreenSize.y / SCREENHEIGHT) >= 3)
		// "big pixels" big enough to do the decay (1px doesn't leave room, 2px the bright spot lands between all 4 pixels and it looks uniform and dark)
		finalpixel.rgb *= 1. - .5*dot(subpxuv, subpxuv);
	return finalpixel;
}
#endif

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position){
    return transform_projection * vertex_position;
}
#endif
