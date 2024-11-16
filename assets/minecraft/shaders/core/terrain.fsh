#version 330

#moj_import <minecraft:fog.glsl>

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform vec2 ScreenSize;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;

in float has_blindness;
in float has_night_vision;

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

    if(has_night_vision > 0.0001) {
        // Vanilla color
        fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
    } else {
        //Dim color
        float norm = dot(color.xyz,color.xyz);
        vec4 output = vec4(color.xyz*norm*5,color.a);
        //vec4 lighter_output = mix(output, graycolor, 0.1) ;

        vec4 near_color = linear_fog(2*color, vertexDistance, 0, 4, output);
        vec4 far_falloff = linear_fog(near_color, vertexDistance, 0, 80, vec4(0.01,0.01,0.02,1));
        far_falloff = linear_fog(near_color, vertexDistance, 30, 60, far_falloff * 0.5);
        fragColor = far_falloff;
    }

}
