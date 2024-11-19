#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:darkness.glsl>
#moj_import <minecraft:lightmap_inputs.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec2 texCoord1;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    if (color.a < 0.1) {
        discard;
    }
    if (vertexDistance < 500){
        float has_blindness = isBlind(FogEnd) ? 1 : 0;
        if(has_blindness > 0.0001) {
            // Vanilla color
            fragColor = linear_fog(1.5*color, vertexDistance, FogStart, FogEnd* 100, vec4(0.01,0.08,0.1,1));
        } else {
            //Dim color
            fragColor = get_frag_color(color, vertexDistance);
        }
        return;
    }
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
