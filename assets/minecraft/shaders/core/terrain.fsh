#version 330

#moj_import <minecraft:fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform vec2 ScreenSize;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;

in float has_blindness;

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

    if(has_blindness > 0.0001) {
        // Vanilla color
        fragColor = linear_fog(1.5*color, vertexDistance, FogStart, FogEnd* 100, vec4(0.01,0.08,0.1,1));
    } else {
        //Dim color
        float norm = dot(color.xyz,color.xyz);
        norm = min(norm*5, 1.4);
        vec4 output = vec4(color.xyz*norm,color.a);
        //vec4 lighter_output = mix(output, graycolor, 0.1) ;

        vec4 near_color = linear_fog(1.5*color, vertexDistance, 0, 4, (1+0.5*smoothstep(40,60,vertexDistance))*output);
        vec4 far_falloff = linear_fog(near_color, vertexDistance, 0, 60, vec4(0.01,0.01,0.02,1));
        far_falloff = linear_fog(near_color, vertexDistance, 30, 40, far_falloff * 0.5);
        fragColor = far_falloff;
    }

}
