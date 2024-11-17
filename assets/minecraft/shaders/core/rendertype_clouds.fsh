#version 150

#moj_import <minecraft:fog.glsl>

uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;

out vec4 fragColor;

void main() {
    vec4 close_color = linear_fog(vertexColor, vertexDistance, 0.4*FogStart, FogEnd, vec4(0,0.05,0.1,1));
    fragColor = linear_fog(close_color, vertexDistance, 0.7*FogStart, FogEnd, vec4(0,0,0,1));
}
