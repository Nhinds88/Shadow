precision mediump float;

uniform sampler2D uAlbedoTexture;
uniform sampler2D uShadowTexture;
uniform mat4 uLightVPMatrix;
uniform vec3 uDirectionToLight;
uniform vec3 uCameraPosition;

varying vec2 vTexCoords;
varying vec3 vWorldNormal;
varying vec3 vWorldPosition;

void main(void) {
    vec3 worldNormal01 = normalize(vWorldNormal);
    vec3 directionToEye01 = normalize(uCameraPosition - vWorldPosition);
    vec3 reflection01 = 2.0 * dot(worldNormal01, uDirectionToLight) * worldNormal01 - uDirectionToLight;

    float lambert = max(dot(worldNormal01, uDirectionToLight), 0.0);
    float specularIntensity = pow(max(dot(reflection01, directionToEye01), 0.0), 64.0);

    vec4 texColor = texture2D(uAlbedoTexture, vTexCoords);
    // vec4 shadowColor = texture2D(uShadowTexture, vTexCoords);

    vec3 ambient = vec3(0.2, 0.2, 0.2) * texColor.rgb;
    vec3 diffuseColor = texColor.rgb * lambert;
    vec3 specularColor = vec3(1.0, 1.0, 1.0) * specularIntensity;
    vec3 finalColor = ambient + diffuseColor + specularColor;

    vec4 lightSpaceNDC = (uLightVPMatrix * vec4(vWorldPosition, 1.0));
    lightSpaceNDC = lightSpaceNDC / lightSpaceNDC.w;
    vec2 lightSpaceUV = lightSpaceNDC.xy * 0.5 + 0.5;
    float lightDepth = lightSpaceNDC.z * 0.5 + 0.5;

    float bias = 0.004;

    vec4 shadowColor = texture2D(uShadowTexture, lightSpaceUV);
    if (lightDepth > (shadowColor.r + bias)) {
        gl_FragColor = vec4(ambient, 1);
    } else {
        gl_FragColor = vec4(finalColor, 1.0);
    }

    // if (abs(lightSpaceNDC.x) > 1.0) {
    //     gl_FragColor = vec4(1.0, 1.0, 0.0, 1.0);
    // }


    // vec4 shadowColor = texture2D(uShadowTexture, lightSpaceUV);

    // gl_FragColor = vec4(vTexCoords.x, vTexCoords.y, 0.0, 1.0);
    // gl_FragColor = vec4(vWorldNormal, 1.0);
    // // gl_FragColor = texColor;
    // gl_FragColor = texColor * lambert;
    // gl_FragColor = texColor;
    // gl_FragColor = vec4(texColor.rgb * lambert, 1.0);
    // gl_FragColor = vec4(uCameraPosition, 1.0);
    // gl_FragColor = vec4(vWorldPosition, 1.0);
    // gl_FragColor = vec4(directionToEye01, 1.0);
    // gl_FragColor = vec4(reflection01, 1.0);
    // gl_FragColor = vec4(specularIntensity, specularIntensity, specularIntensity, 1.0);
    // gl_FragColor = vec4(finalColor, 1.0);
    // gl_FragColor = vec4(shadowColor.rgb, 1.0);
    // gl_FragColor = vec4(lightDepth, lightDepth, lightDepth, 1.0);
    // gl_FragColor = shadowColor;
}
