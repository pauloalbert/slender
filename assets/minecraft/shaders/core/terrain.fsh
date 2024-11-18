#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:lightmap_inputs.glsl>
#moj_import <minecraft:darkness.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform vec2 ScreenSize;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;


out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    
#ifdef ALPHA_CUTOUT
    if (color.a < ALPHA_CUTOUT) {
        discard;
    }
#endif

  //  vec4 fog1 = linear_fog(color, vertexDistance, 0, 30, vec4(0.01,0.01,0.04,1));
  //  vec4 fog2 = linear_fog(color, vertexDistance, 0, 5, vec4(0.01,0.01,0.01,1));
  //  vec4 mix1 = mix(fog1,color, 0.3);
  //  vec4 mix2 = mix(fog2,color, 0.65);
    float has_blindness = isBlind(FogEnd) ? 1 : 0;
    if(has_blindness > 0.0001) {
        // Vanilla color
        fragColor = linear_fog(1.5*color, vertexDistance, FogStart, FogEnd* 100, vec4(0.01,0.08,0.1,1));
    } else {
        //Dim color
        fragColor = get_frag_color(color, vertexDistance);
    }

}
