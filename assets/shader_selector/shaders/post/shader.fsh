#version 330

#moj_import <shader_selector:marker_settings.glsl>
#moj_import <shader_selector:utils.glsl>

uniform sampler2D MainSampler;
uniform sampler2D DataSampler;
uniform sampler2D BlurSampler;

uniform vec2 OutSize;
uniform float GameTime;

in vec2 texCoord;

out vec4 fragColor;

float readChannel(int channel) {
    return decodeColor(texelFetch(DataSampler, ivec2(4, channel), 0));
}

float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

void main() {

    // Apply rotation effect
    // Read rotation amount
    float rotationAmount = readChannel(EXAMPLE_ROTATION_CHANNEL);

    // Convert to radians
    float angle = radians(rotationAmount * 360.0);

    // Apply rotation to texture coordinates
    vec2 uv = (texCoord - 0.5) * OutSize;
    uv *= mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    uv = uv / OutSize + 0.5;

    // Show color at texture coordinates
    fragColor = texture(MainSampler, uv);
    // If texture coordinates are out of bounds, show blurred version
    if (uv.x < 0. || uv.x > 1. || uv.y < 0. || uv.y > 1.) {
        fragColor = texture(BlurSampler, (uv - 0.5)*sqrt(0.5) + 0.5);
    }

    // Apply greyscale effect
    // Get full greyscale color
    vec3 greyscale =  vec3(random(vec2(floor(uv.x*500)/500, floor(uv.y*500)/500)*(1 + GameTime)));
    
    // Apply greyscale color
    float greyscaleAmount = readChannel(EXAMPLE_GREYSCALE_CHANNEL);
    fragColor.rgb = mix(fragColor.rgb, greyscale, greyscaleAmount);

//#define DEBUG
#ifdef DEBUG
    // Show data sampler on screen
    if (texCoord.x < .25 && texCoord.y < .25) {
        uv = texCoord * 4.0;
        vec4 col = texture(DataSampler, uv);
        if (uv.x > 1./5.)
            col = vec4(vec3(fract(decodeColor(col))), 1.0);
        fragColor = col;
    }
#endif
}