#version 150

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

    // Vanilla color
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
    
    float FogColorRedValue = ceil(FogColor.r * 255);
    float FogColorGreenValue = ceil(FogColor.g * 255);
    float FogColorBlueValue = ceil(FogColor.b * 255);

    if (FogColorRedValue == 159 && FogColorGreenValue == 188 && FogColorBlueValue == 201 ||
        FogColorRedValue == 153 && FogColorGreenValue == 26 && FogColorBlueValue == 0 || 
        FogColorRedValue == 0 && FogColorGreenValue == 0 && FogColorBlueValue == 0) {
            float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
            vec4 graycolor = vec4(vec3(gray), color.a);
            
            
            vec4 lighter_output = mix(color, graycolor, 0.1) ;
            vec4 output = linear_fog(lighter_output, vertexDistance, 0, 90, vec4(0.01,0.01,0.04,1));
            
            float norm = dot(output.xyz,output.xyz);
            output = vec4(output.xyz*norm*10,color.a);
            fragColor = linear_fog(2*color, vertexDistance, 0, 3, output);
    }

}
