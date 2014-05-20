//
//  GLSprite.m
//  GLESTextureTest
//
//  Created by 村上 晋太郎 on 2014/05/20.
//  Copyright (c) 2014年 村上 晋太郎. All rights reserved.

#import "GLSprite.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

#define VERTEX_ELEM_LEN (3+3+2)
#define VERTEX_NUM 4
#define VERTEX_LEN (VERTEX_ELEM_LEN * VERTEX_NUM)

static GLfloat gCubeVertexData[VERTEX_LEN] =
{
  // Data layout for each line below is:
  // positionX, positionY, positionZ,     normalX, normalY, normalZ,   textureX, textureY
  0.5f, -0.5f, -0.5f,        0.0f, 0.0f, 1.0f,    1.0f, 1.0f,
  -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, 1.0f,    0.0f, 1.0f,
  0.5f, 0.5f, -0.5f,         0.0f, 0.0f, 1.0f,    1.0f, 0.0f,
  -0.5f, 0.5f, -0.5f,        0.0f, 0.0f, 1.0f,    0.0f, 0.0f,
};


@implementation GLSprite
- (id)init {
  self = [super init];
  if (self) {
    
  }
  return self;
}

- (void)update
{
  
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
  
}

@end
