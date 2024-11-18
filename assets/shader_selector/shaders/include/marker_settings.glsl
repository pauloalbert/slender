
// define distinct values, counting from 1:
#define SHADER_NOISE_CHANNEL 1
#define SHADER_F5_CHANNEL 2

/*
signature:
 ADD_MARKER(channel, green, alpha, op, rate)
*/
// append different marker definitions
#define LIST_MARKERS \
ADD_MARKER(SHADER_NOISE_CHANNEL, 255, 204, 0, 2) \
ADD_MARKER(SHADER_NOISE_CHANNEL, 204, 204, 1, 2) \
ADD_MARKER(SHADER_F5_CHANNEL, 102, 153, 5, 4) \
// ADD_MARKER(SHADER_F5_CHANNEL, 51, 153, 1, 0.8)

#define MARKER_RED 254

// Screen pixel that the marker ends up on if it uses channel k:
// Mapping follows structure that is like an inverted cantor pairing (but only producing coordinates with an even sum)
#define MARKER_POS(k) (ivec2(2*int(ceil(sqrt(k)) - 1.0),0) + (k - int((ceil(sqrt(k)) - 1.0)*(ceil(sqrt(k)) - 1.0)) - 1)*ivec2(-1, 1))
