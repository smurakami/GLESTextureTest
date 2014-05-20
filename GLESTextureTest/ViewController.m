//
//  ViewController.m
//  GLESTextureTest
//
//  Created by 村上 晋太郎 on 2014/05/19.
//  Copyright (c) 2014年 村上 晋太郎. All rights reserved.
//

#import "ViewController.h"
#import "GLSprite.h"

@interface ViewController ()

@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;
@property (strong, nonatomic) NSMutableArray * sprites;

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
  
  glEnable(GL_DEPTH_TEST);
	// アルファブレンド
	glEnable( GL_BLEND );
	glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
  
  // 物体生成
  _sprites = [NSMutableArray array];
}

- (void)tearDownGL
{
  [EAGLContext setCurrentContext:self.context];
  self.effect = nil;
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
  float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
  GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
  
  self.effect.transform.projectionMatrix = projectionMatrix;
  
  GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 0.0f);
  
  GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -5.0f);
//  modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
  modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
  
  self.effect.transform.modelviewMatrix = modelViewMatrix;
  
  [_sprites enumerateObjectsUsingBlock:^(GLSprite * sprite, NSUInteger idx, BOOL *stop){
    [sprite update];
  }];
//  _rotation += self.timeSinceLastUpdate * 0.5f;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
  glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  
  // Render the object with GLKit
  [_sprites enumerateObjectsUsingBlock:^(GLSprite * sprite, NSUInteger idx, BOOL *stop){
    [sprite glkView:view drawInRect:rect];
  }];
}

#pragma mark - test
- (void)appendSprite
{
  GLSprite * sprite = [[GLSprite alloc] initWithContext:_context effect:_effect];
  [_sprites addObject:sprite];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self appendSprite];
}

@end
