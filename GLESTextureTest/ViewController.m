//
//  ViewController.m
//  GLESTextureTest
//
//  Created by 村上 晋太郎 on 2014/05/19.
//  Copyright (c) 2014年 村上 晋太郎. All rights reserved.
//

#import "ViewController.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

// Uniform index.
enum
{
  UNIFORM_MODELVIEWPROJECTION_MATRIX,
  UNIFORM_NORMAL_MATRIX,
  NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum
{
  ATTRIB_VERTEX,
  ATTRIB_NORMAL,
  NUM_ATTRIBUTES
};

#define VERTEX_ELEM_LEN (3+3+2)
#define VERTEX_NUM 4
#define VERTEX_LEN (VERTEX_ELEM_LEN * VERTEX_NUM)
GLfloat gCubeVertexData[VERTEX_LEN] =
{
  // Data layout for each line below is:
  // positionX, positionY, positionZ,     normalX, normalY, normalZ,
  0.5f, -0.5f, -0.5f,        0.0f, 0.0f, 1.0f,    1.0f, 1.0f,
  -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, 1.0f,    0.0f, 1.0f,
  0.5f, 0.5f, -0.5f,         0.0f, 0.0f, 1.0f,    1.0f, 0.0f,
  -0.5f, 0.5f, -0.5f,        0.0f, 0.0f, 1.0f,    0.0f, 0.0f,
};

@interface ViewController () {
  GLuint _program;
  
  GLKMatrix4 _modelViewProjectionMatrix;
  GLKMatrix3 _normalMatrix;
  float _rotation;
  
  GLuint _vertexArray;
  GLuint _vertexBuffer;
  GLuint _texture;
  
  
  CGSize _texSize;
  CGSize _imageSize;
}

@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

- (void)setupGL;
- (void)tearDownGL;

@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  
  if (!self.context) {
    NSLog(@"Failed to create ES context");
  }
  
  GLKView *view = (GLKView *)self.view;
  view.context = self.context;
  view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
  
  [self setupGL];
}

- (void)dealloc
{
  [self tearDownGL];
  
  if ([EAGLContext currentContext] == self.context) {
    [EAGLContext setCurrentContext:nil];
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  
  if ([self isViewLoaded] && ([[self view] window] == nil)) {
    self.view = nil;
    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
      [EAGLContext setCurrentContext:nil];
    }
    self.context = nil;
  }
  
  // Dispose of any resources that can be recreated.
}

- (void)setupGL
{
  [EAGLContext setCurrentContext:self.context];
  
  self.effect = [[GLKBaseEffect alloc] init];
  self.effect.light0.enabled = GL_TRUE;
  self.effect.light0.diffuseColor
  = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
  self.effect.colorMaterialEnabled = YES;
//  self.effect.light0.position = GLKVector4Make(0, 0, 0, 0);
  
  GLKVector4 pos = self.effect.light0.position;
  
  glEnable(GL_DEPTH_TEST);
	//** アルファブレンド
	glEnable( GL_BLEND );
	glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
  
  //
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
  
  NSURL *imageURL = [[NSBundle mainBundle]
                     URLForResource:@"moyashi" withExtension:@"png"];
  _texInfo = [GLKTextureLoader
              textureWithContentsOfURL:imageURL
              options:nil error:NULL];
}

- (void)tearDownGL
{
  [EAGLContext setCurrentContext:self.context];
  
  glDeleteBuffers(1, &_vertexBuffer);
  glDeleteVertexArraysOES(1, &_vertexArray);
  
  self.effect = nil;
  
  if (_program) {
    glDeleteProgram(_program);
    _program = 0;
  }
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
  float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
  GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
  
  self.effect.transform.projectionMatrix = projectionMatrix;
  
  GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 0.0f);
//  baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, _rotation, 0.0f, 1.0f, 0.0f);
  
  // Compute the model view matrix for the object rendered with GLKit
  GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -5.0f);
//  modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
  modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
  
  self.effect.transform.modelviewMatrix = modelViewMatrix;
  
//  _rotation += self.timeSinceLastUpdate * 0.5f;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
  glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  
  glBindVertexArrayOES(_vertexArray);
  
  // Render the object with GLKit
  self.effect.texture2d0.enabled = GL_TRUE;
  self.effect.texture2d0.name = _texInfo.name;
  self.effect.texture2d0.target = _texInfo.target;
  [self.effect prepareToDraw];
  
  glDrawArrays(GL_TRIANGLE_STRIP, 0, VERTEX_NUM);
}

@end
