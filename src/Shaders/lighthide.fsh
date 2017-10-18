precision mediump float;
vec4 textureColor;

varying vec2 v_texCoord;


vec3 rgb2hsb(float r, float g, float b)
{
    float rgbR = r*255.0;
    float rgbG = g*255.0;
    float rgbB = b*255.0;
    
    float max = rgbR;
    if (max < rgbG)max = rgbG;
    if (max < rgbB)max = rgbB;
    
    float min = rgbR;
    if (min > rgbG)min = rgbG;
    if (min > rgbB)min = rgbB;
    
    float hsbB = max/255.0;;
    float hsbS = 0.0;
    if (0.0 != max)hsbS = (max - min)/max;
    float hsbH = 0.0;
    
    if (max == rgbR && rgbG >= rgbB)
    {
        hsbH = (rgbG - rgbB) * 60.0 / (max - min) + 0.0;
    }
    else if (max == rgbR && rgbG < rgbB)
    {
        hsbH = (rgbG - rgbB) * 60.0 / (max - min) + 360.0;
    }
    else if (max == rgbG)
    {
        hsbH = (rgbB - rgbR) * 60.0 / (max - min) + 120.0;
    }
    else if (max == rgbB)
    {
        hsbH = (rgbR - rgbG) * 60.0 / (max - min) + 240.0;
    };
    
    return vec3(hsbH, hsbS, hsbB);
}


vec3 hsb2rgb(float h, float s, float v)
{
    float r = 0.0;
    float g = 0.0;
    float b = 0.0;
    
    int i = int ( mod((h / 60.0), 6.0) );
    float f = (h / 60.0) - float(i);
    float p = v * (1.0 - s);
    float q = v * (1.0 - f * s);
    float t = v * (1.0 - (1.0 - f) * s);
    
    if (i == 0)
    {
        r = v;
        g = t;
        b = p;
    }
    else if (i == 1)
    {
        r = q;
        g = v;
        b = p;
    }
    else if (i == 2)
    {
        r = p;
        g = v;
        b = t;
    }
    else if (i == 3)
    {
        r = p;
        g = q;
        b = v;
    }
    else if (i == 4)
    {
        r = t;
        g = p;
        b = v;
    }
    else if (i == 5)
    {
        r = v;
        g = p;
        b = q;
    };
    
    return vec3(r,g,b);
}





void main()
{
	
    vec4 textureColor = texture2D(CC_Texture0, v_texCoord);
    if( textureColor.a != 0.0 )
    {
        vec3 hsb = rgb2hsb(textureColor.r, textureColor.g, textureColor.b);
            
		hsb.z = hsb.z + 0.1;
		if (hsb.z >= 1.0)
		{
			hsb.z = 1.0;
		}
		
		vec3 rgb = hsb2rgb(hsb.x, hsb.y, hsb.z);
		textureColor.r = rgb.x;
		textureColor.g = rgb.y;
		textureColor.b = rgb.z;
    }
    gl_FragColor = textureColor;
}