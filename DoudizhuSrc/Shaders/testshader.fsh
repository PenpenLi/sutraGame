varying vec2 v_texCoord;



void main(){

vec4 textureColor = texture2D(CC_Texture0, v_texCoord );
vec3 GlowColor = vec3(1.0, 1.0, 0.0);
vec2 TextureSize = vec2(527.0, 586.0);
float GlowExpand = 1.0;
float GlowRange = 10.0;
float samplerPre = 2.0;                                                                                                    
float radiusX = 1.0 / TextureSize.x;                                                                                       
float radiusY = 1.0 / TextureSize.y;                                                                                      
float glowAlpha = 0.0;                                                                                                    
float count = 0.0;                                                                                                        
for( float i = -GlowRange ; i <= GlowRange ; i += samplerPre )                                                            
{                                                                                                                         
   for( float j = -GlowRange ; j <= GlowRange ; j += samplerPre )                                                        
	{                                                                                                                     
		vec2 samplerTexCoord = vec2( v_texCoord.x + j * radiusX , v_texCoord.y + i * radiusY );                           
	   if( samplerTexCoord.x < 0.0 || samplerTexCoord.x > 1.0 || samplerTexCoord.y <0.0 || samplerTexCoord.y > 1.0 )     
			glowAlpha += 0.0;                                                                                              
	   else             
			glowAlpha += texture2D( CC_Texture0, samplerTexCoord ).a;     
		count += 1.0;                                                                                                      
	}                                                                                                                     
}                                                                                                                          
glowAlpha /= (count+500.0); 
float R = GlowColor.r;                                                                                                          
float G = GlowColor.g;                                                                                                           
float B = GlowColor.b;                                                                                                         
float A = glowAlpha * GlowExpand;
if(textureColor.a < 1.0)
	textureColor = vec4(R, G, B, A);
gl_FragColor = textureColor;
}