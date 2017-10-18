varying vec2 v_texCoord;



void main(){

vec4 textureColor = texture2D(CC_Texture0, v_texCoord );
vec4 accum;
float radius=0.015;

accum += texture2D(CC_Texture0, vec2(v_texCoord.x - radius, v_texCoord.y - radius));
accum += texture2D(CC_Texture0, vec2(v_texCoord.x + radius, v_texCoord.y - radius));
accum += texture2D(CC_Texture0, vec2(v_texCoord.x + radius, v_texCoord.y + radius));
accum += texture2D(CC_Texture0, vec2(v_texCoord.x - radius, v_texCoord.y + radius));

accum *= 1.0;
accum.rgb =  vec3(1,1,0) * accum.a;

textureColor = ( accum * (1.0 - textureColor.a)) + (textureColor * textureColor.a);

gl_FragColor = textureColor;
}