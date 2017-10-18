varying vec2 v_texCoord;

vec4 composite(vec4 over, vec4 under)
{
return over + (1.0 - over.a)*under;
}
void main(){
vec4 c = texture2D(CC_Texture0, v_texCoord);
gl_FragColor.xyz = vec3(0.2126*c.r + 0.7152*c.g + 0.0722*c.b);
gl_FragColor.w = c.w;
}