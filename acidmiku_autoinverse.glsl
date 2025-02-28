//!DESC Invert-When-Median-Near-White with Smooth Transition (using smoothstep)
//!HOOK MAIN
//!BIND HOOKED
//!COMPONENTS 4

#define INVERT_THRESHOLD 0.5
#define TRANSITION_WIDTH 0.1  // Adjust to widen/narrow the luminance band over which the transition occurs

// Standard luminance calculation.
float get_luma(vec4 rgba) {
    return dot(rgba.rgb, vec3(0.299, 0.587, 0.114));
}

vec4 hook() {
    // Define 9 sample positions across the screen.
    vec2 sampleCoords[9];
    sampleCoords[0] = vec2(0.25, 0.25);
    sampleCoords[1] = vec2(0.50, 0.25);
    sampleCoords[2] = vec2(0.75, 0.25);
    sampleCoords[3] = vec2(0.25, 0.50);
    sampleCoords[4] = vec2(0.50, 0.50);
    sampleCoords[5] = vec2(0.75, 0.50);
    sampleCoords[6] = vec2(0.25, 0.75);
    sampleCoords[7] = vec2(0.50, 0.75);
    sampleCoords[8] = vec2(0.75, 0.75);
    
    // Gather luminance from the samples.
    float lumas[9];
    for (int i = 0; i < 9; i++) {
         lumas[i] = get_luma(HOOKED_tex(sampleCoords[i]));
    }
    
    // Bubble sort to compute the median luminance.
    for (int i = 0; i < 8; i++) {
         for (int j = 0; j < 8 - i; j++) {
              if (lumas[j] > lumas[j+1]) {
                  float tmp = lumas[j];
                  lumas[j] = lumas[j+1];
                  lumas[j+1] = tmp;
              }
         }
    }
    float medianLuma = lumas[4]; // 5th element is the median.
    
    // Compute a smooth inversion factor that ramps from 0 to 1 as the median luma goes from 
    // (INVERT_THRESHOLD - TRANSITION_WIDTH) to (INVERT_THRESHOLD + TRANSITION_WIDTH).
    float inversionFactor = smoothstep(INVERT_THRESHOLD - TRANSITION_WIDTH,
                                       INVERT_THRESHOLD + TRANSITION_WIDTH,
                                       medianLuma);
    
    // Fetch the current pixel color.
    vec4 color = HOOKED_tex(HOOKED_pos);
    
    // Blend the original and inverted colors.
    vec3 inverted = vec3(1.0) - color.rgb;
    color.rgb = mix(color.rgb, inverted, inversionFactor);
    
    return color;
}
