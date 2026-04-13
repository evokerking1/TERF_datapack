#version 330

#moj_import <minecraft:light.glsl>
#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>
#moj_import <minecraft:globals.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV1;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

flat out int shaderID; // Shader that will be used in fragment shader;
out float sphericalVertexDistance;
out float cylindricalVertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
flat out vec2 UVOrigin; // Corner of a current triangle
out vec2 texCoord1;
out vec2 texCoord2;
out vec4 control;

int calculateShaderID(in vec2 corner, float stepSize)
{
    int ID = 0;
    stepSize /= 16;
    for (int i = 1; i < 5; i++)
    {
        ID *= 10;
        ID += int(round((texture(Sampler0, corner + vec2(stepSize * i, 0)) * vertexColor * ColorModulator).w * 255)) - 250;
    }
    return ID;
}

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
    vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color) * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;
    
    shaderID = 0;

    // Here goes modified code
    // Check 2 oposite corners for special texels (alpha = 254)
    vec2 atlasSize = vec2(textureSize(Sampler0, 0));
    vec2 UVSize = 16 / atlasSize; // I dare say you have no reason not to make all UV sizes the same.
    vec2 corner = UV0 + vec2(0, UVSize.y); // Default corner
    int alpha = int(round((texture(Sampler0, corner) * vertexColor * ColorModulator).w * 255));

    if (alpha == 254)
    {
        shaderID = calculateShaderID(corner, UVSize.x);
        UVOrigin = UV0;
    }
    else
    {
        corner = UV0 + vec2(-UVSize.x, 0); // Oposite corner
        alpha = int(round((texture(Sampler0, corner) * vertexColor * ColorModulator).w * 255));
        if (alpha == 254)
        {
            shaderID = calculateShaderID(corner, UVSize.x);
            UVOrigin = UV0 - UVSize;
        }
    }
    // Back to vanilla stuff

    texCoord1 = UV1;
    texCoord2 = UV2;

    // Jona passes down the colour, so he can control animations.
    control = Color;
}
