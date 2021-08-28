// Original Shader by Kenny : https://kenney.nl | twitter.com/KenneyNL
// Ported by Zacksly : zacksly.itch.io | twitter.com/_Zacksly

shader_type spatial;
render_mode specular_schlick_ggx, unshaded, world_vertex_coords;

uniform sampler2D texture : hint_albedo;
uniform vec4 base_color : hint_color = vec4(1, 1, 1, 1);
uniform vec4 top_color : hint_color = vec4(0.9, 0.9, 0.9, 1);
uniform vec4 right_color : hint_color = vec4(0.8, 0.8, 0.8, 1);
uniform vec4 front_color : hint_color = vec4(0.7, 0.7, 0.7, 1);
uniform float intensity = 1;

varying vec3 true_normal;

vec4 blendAwithBFunc(vec4 _c0l0r_blendA_rgba, vec4 _c0l0r_blendB_rgba, float _fade_blend_c0l0r){
	return mix(_c0l0r_blendA_rgba, _c0l0r_blendB_rgba, _c0l0r_blendB_rgba.a * _fade_blend_c0l0r);
}

void vertex() {
	true_normal = NORMAL;
}

void fragment() {
	
	vec3 temp_albedo = texture(texture, UV.xy).rgb * base_color.rgb * vec3(COLOR[0],COLOR[1],COLOR[2]);

	vec3 dir_x = vec3(true_normal.x) * vec3(true_normal.x);
	vec3 dir_y = vec3(true_normal.y) * vec3(true_normal.y);
	vec3 dir_z = vec3(true_normal.z) * vec3(true_normal.z);

	vec3 dot_result = vec3(dot(dir_x, vec3(0.333333, 0.333333, 0.333333)), dot(dir_y, vec3(0.333333, 0.333333, 0.333333)), dot(dir_z, vec3(0.333333, 0.333333, 0.333333)));

	vec3 temp_output = ( base_color.rgb * top_color.rgb );
	vec3 mix_result = ( mix( mix( mix( temp_output , ( base_color.rgb * right_color.rgb ) , dot_result.x ) , temp_output , dot_result.y ) , ( base_color.rgb * front_color.rgb ) , dot_result.z ) );

	ALBEDO = (vec4(temp_albedo, 1.0) * vec4(mix_result, 1.0) * intensity).rgb;

}