#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
float range_x = 0.3;

float k = 0;

void main(void)
{
	float sin_value = sin(radians((v_texCoord.x/range_x)*90)) ;
	sin_value = sin_value*range_x;
	
	float vx = floor(v_texCoord.x/range_x)*range_x + sin_value;
	gl_FragColor = texture2D(CC_Texture0, vec2(vx, v_texCoord.y));
}