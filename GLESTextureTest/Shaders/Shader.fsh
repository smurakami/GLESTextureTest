//
//  Shader.fsh
//  GLESTextureTest
//
//  Created by 村上 晋太郎 on 2014/05/19.
//  Copyright (c) 2014年 村上 晋太郎. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
