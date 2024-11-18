#version 330

#moj_import <minecraft:light.glsl>
#moj_import <minecraft:lightmap_inputs.glsl>

vec4 get_vertex_light(sampler2D Sampler2, vec4 gl_Position, ivec2 UV2, vec2 ScreenSize, float FogEnd, float GameTime) {
    vec4 light = minecraft_sample_lightmap(Sampler2, ivec2(UV2.x,max(160-15*gl_Position.z,0)));

    float has_blindness = isBlind(FogEnd) ? 1 : 0;
    float has_night_vision = getNightVisionFactor(Sampler2);

    if(has_night_vision > 0.001) {
        // Circle - changing the lighting if in the circle
        float aspect = ScreenSize.x / ScreenSize.y;
        vec2 center = gl_Position.xy - vec2(0.5,0.5);
        //lower center on sprint
        if (has_night_vision < 0.9){
            center.y += gl_Position.z *  (0.4+0.1*sin(GameTime*8888)*sin(GameTime*8888)*sin(GameTime*8888));   //should be gl_.z not squared
            center.x += gl_Position.z *  (0.1*sin(GameTime*6966)*sin(GameTime*6966)*sin(GameTime*6966));   //should be gl_.z not squared

        }

        center.x *= aspect;
        float radius = 0.7;
        if (dot(center,center)  < radius * gl_Position.z* gl_Position.z) {
            float value = 1 - (dot(center,center) / (gl_Position.z*gl_Position.z)) / radius;
            value *= 0.9;
            value = min(0.6,value);
            value *= max(0.5,min(1,(1-1/gl_Position.z)));   //close weaker
            value *= max(0.5,min(1, (3/sqrt(gl_Position.z))));  //far weaker
            light = vec4(vec3(max(value,light.x)), 1.0);
        }
    }

    return light;
}