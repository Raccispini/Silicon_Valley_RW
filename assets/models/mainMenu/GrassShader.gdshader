shader_type spatial;
render_mode cull_back, unshaded;

uniform sampler2D albedo_texture;
uniform float alpha_cutoff = 0.5;
uniform float brightness = 1.0;
uniform float wind_strength = 0.5;
uniform float wind_speed = 1.0;
uniform float wind_scale = 1.0;
uniform vec3 wind_direction = vec3(1.0, 0.0, 0.5);

// Altezza massima della mesh (da regolare se non è normalizzata)
uniform float max_height = 1.0;

uniform float randomness_strength = 1.0;

// Funzione hash deterministica
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

void vertex() {
    vec3 wind_dir = normalize(wind_direction);
    float height_factor = clamp(VERTEX.y / max_height, 0.0, 1.0);

    // Calcolo random offset basato su posizione
    float randomness = hash(VERTEX.xz) * randomness_strength;
    float phase_offset = randomness * 10.0;

    float wave = sin((VERTEX.x * wind_scale + TIME * wind_speed + phase_offset) +
                     (VERTEX.z * wind_scale)) * wind_strength;

    vec3 offset = wind_dir * wave * height_factor;
    VERTEX += offset;
}

void fragment() {
    vec4 tex_color = texture(albedo_texture, UV);

    // 🆕 Applica la luminosità
    ALBEDO = tex_color.rgb * brightness;

    ALPHA = tex_color.a;
    ALPHA_SCISSOR_THRESHOLD = alpha_cutoff;
}
