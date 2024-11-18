#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:lightmap_inputs.glsl>
#moj_import <minecraft:darkness.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec4 lightMapColor;
in vec4 overlayColor;
in vec2 texCoord0;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0);
#ifdef ALPHA_CUTOUT
    if (color.a < ALPHA_CUTOUT) {
        discard;
    }
#endif
    color *= vertexColor * ColorModulator;
#ifndef NO_OVERLAY
    color.rgb = mix(overlayColor.rgb, color.rgb, overlayColor.a);
#endif
#ifndef EMISSIVE
    color *= lightMapColor;
#endif
    float has_blindness = isBlind(FogEnd) ? 1 : 0;
    if(has_blindness > 0.0001) {
        // Vanilla color
        fragColor = linear_fog(1.5*color, vertexDistance, FogStart, FogEnd* 100, vec4(0.01,0.08,0.1,1));
    } else {
        //Dim color
        fragColor = get_frag_color(color, vertexDistance);
    }
}
