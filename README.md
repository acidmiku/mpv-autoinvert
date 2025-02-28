# mpv-autoinvert
A custom shader for MPV media player that dynamically inverts colors when the screen becomes too bright, designed specifically to help individuals with myodesopsia (floaters).

## What is Myodesopsia?
Myodesopsia, commonly known as eye floaters, is a condition where small shapes appear to drift through your field of vision. These floaters become significantly more visible against bright backgrounds, which can be particularly distracting when watching videos with bright or white scenes.

## How This Shader Helps

This shader:
- Analyzes the median brightness of the screen in real-time
- Smoothly inverts colors when the screen becomes too bright
- Creates better contrast to reduce the visibility of floaters
- Provides a comfortable viewing experience without jarring transitions

## Installation

1. Locate your MPV shader directory:
   - Linux/macOS: `~/.config/mpv/shaders/`
   - Windows: `%APPDATA%\mpv\shaders\`

2. Create the directory if it doesn't exist:
   ```
   mkdir -p ~/.config/mpv/shaders/
   ```

3. Save the shader file as `acidmiku_autoinverse.glsl` in this directory.

## Usage

Add the following line to your MPV `input.conf` file:

```
CTRL+7 no-osd change-list glsl-shaders set "~~/shaders/acidmiku_autoinverse.glsl"; show-text "acidmiku_autoinverse shader loaded"
```

With this configuration, you can:
- Press `CTRL+7` to load the shader
- The shader will automatically invert colors when the screen becomes too bright
- A confirmation message will appear when the shader is loaded

## Customization

The shader has two main adjustable parameters:

```glsl
#define INVERT_THRESHOLD 0.5      // Brightness threshold to trigger inversion (0.0-1.0)
#define TRANSITION_WIDTH 0.1      // Width of the transition band for smooth inversion
```

- **INVERT_THRESHOLD**: Determines at what brightness level inversion begins (higher values mean it only inverts on brighter scenes)
- **TRANSITION_WIDTH**: Controls how gradual the transition is between normal and inverted colors

## How It Works

1. The shader samples 9 points across the screen
2. Calculates the median luminance value using a simple sorting algorithm
3. When the median brightness exceeds the threshold, it begins smoothly inverting colors
4. Uses a smoothstep function to create a natural transition rather than a harsh cutoff

## Performance

No measurable impact on performance.

## License

This shader is released under the Apache License. Feel free to modify and distribute it according to your needs.
3. Submit a pull request
