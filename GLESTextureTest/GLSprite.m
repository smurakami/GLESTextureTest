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

@interface GLSprite()
@property (nonatomic) GLKBaseEffect * effect;
@property (nonatomic) GLuint vertexArray;
@property (nonatomic) GLuint vertexBuffer;
@property (nonatomic) GLKTextureInfo *texInfo;
@end

@implementation GLSprite
- (id)initWithEffect:(GLKBaseEffect *)effect
{
  self = [super init];
  if (self) {
    _effect = effect;
    [self setupVertex];
    [self setupTexture];
  }
  return self;
}

- (void)dealloc
{
  glDeleteBuffers(1, &_vertexBuffer);
  glDeleteVertexArraysOES(1, &_vertexArray);
}

- (void)setupVertex
{
  glGenVertexArraysOES(1, &_vertexArray);
  glBindVertexArrayOES(_vertexArray);
  
  glGenBuffers(1, &_vertexBuffer);
  glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
  glBufferData(GL_ARRAY_BUFFER, sizeof(gCubeVertexData), gCubeVertexData, GL_STATIC_DRAW);
  
  glEnableVertexAttribArray(GLKVertexAttribPosition);
  glVertexAttribPointer(GLKVertexAttribPosition,
                        3, GL_FLOAT, GL_FALSE,
                        VERTEX_ELEM_LEN * sizeof(GLfloat), BUFFER_OFFSET(0));
  
  glEnableVertexAttribArray(GLKVertexAttribNormal);
  glVertexAttribPointer(GLKVertexAttribNormal,
                        3, GL_FLOAT, GL_FALSE,
                        VERTEX_ELEM_LEN * sizeof(GLfloat), BUFFER_OFFSET(sizeof(GLfloat)*3));
  
  glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
  glVertexAttribPointer(GLKVertexAttribTexCoord0,
                        2, GL_FLOAT, GL_FALSE,
                        VERTEX_ELEM_LEN * sizeof(GLfloat), BUFFER_OFFSET(sizeof(GLfloat)*6));
  
  glBindVertexArrayOES(0);
}

- (void)setupTexture
{
  NSURL *imageURL = [[NSBundle mainBundle]
                     URLForResource:@"moyashi" withExtension:@"png"];
  _texInfo = [GLKTextureLoader
              textureWithContentsOfURL:imageURL
              options:nil error:NULL];
}

- (void)update
{
  
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
  glBindVertexArrayOES(_vertexArray);
  
  // Render the object with GLKit
  self.effect.texture2d0.enabled = GL_TRUE;
  self.effect.texture2d0.name = _texInfo.name;
  self.effect.texture2d0.target = _texInfo.target;
  [self.effect prepareToDraw];
  
  glDrawArrays(GL_TRIANGLE_STRIP, 0, VERTEX_NUM);
}

@end
