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

GLfloat gCubeVertexData[216 + 108] =
{
  // Data layout for each line below is:
  // positionX, positionY, positionZ,     normalX, normalY, normalZ,
  0.5f, -0.5f, -0.5f,        1.0f, 0.0f, 0.0f,     0.0, 1.0, 1.0,
  0.5f, 0.5f, -0.5f,         1.0f, 0.0f, 0.0f,     0.0, 1.0, 1.0,
  0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,     0.0, 1.0, 1.0,
  0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,     0.0, 1.0, 1.0,
  0.5f, 0.5f, -0.5f,          1.0f, 0.0f, 0.0f,     0.0, 1.0, 1.0,
  0.5f, 0.5f, 0.5f,         1.0f, 0.0f, 0.0f,     0.0, 1.0, 1.0,
  
  0.5f, 0.5f, -0.5f,         0.0f, 1.0f, 0.0f,     0.0, 1.0, 1.0,
  -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,     0.0, 1.0, 1.0,
  0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,     0.0, 1.0, 1.0,
  0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,     0.0, 1.0, 1.0,
  -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,     0.0, 1.0, 1.0,
  -0.5f, 0.5f, 0.5f,         0.0f, 1.0f, 0.0f,     0.0, 1.0, 1.0,
  
  -0.5f, 0.5f, -0.5f,        -1.0f, 0.0f, 0.0f,     0.0, 1.0, 1.0,
  -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,     0.0, 1.0, 1.0,
  -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,     0.0, 1.0, 1.0,
  -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,     0.0, 1.0, 1.0,
  -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,     0.0, 1.0, 1.0,
  -0.5f, -0.5f, 0.5f,        -1.0f, 0.0f, 0.0f,     0.0, 1.0, 1.0,
  
  -0.5f, -0.5f, -0.5f,       0.0f, -1.0f, 0.0f,     0.0, 1.0, 1.0,
  0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,     0.0, 1.0, 1.0,
  -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,     0.0, 1.0, 1.0,
  -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,     0.0, 1.0, 1.0,
  0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,     0.0, 1.0, 1.0,
  0.5f, -0.5f, 0.5f,         0.0f, -1.0f, 0.0f,     0.0, 1.0, 1.0,
  
  0.5f, 0.5f, 0.5f,          0.0f, 0.0f, 1.0f,     0.0, 1.0, 1.0,
  -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,     0.0, 1.0, 1.0,
  0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,     0.0, 1.0, 1.0,
  0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,     0.0, 1.0, 1.0,
  -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,     0.0, 1.0, 1.0,
  -0.5f, -0.5f, 0.5f,        0.0f, 0.0f, 1.0f,     0.0, 1.0, 1.0,
  
  0.5f, -0.5f, -0.5f,        0.0f, 0.0f, -1.0f,     0.0, 1.0, 1.0,
  -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,     0.0, 1.0, 1.0,
  0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,     0.0, 1.0, 1.0,
  0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,     0.0, 1.0, 1.0,
  -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,     0.0, 1.0, 1.0,
  -0.5f, 0.5f, -0.5f,        0.0f, 0.0f, -1.0f,     0.0, 1.0, 1.0,
};

#define SQUARE_DATA_LEN (3 * 3 * 4)
GLfloat gSquareData[SQUARE_DATA_LEN] = {
  // Data layout for each line below is:
  // positionX, positionY, positionZ,     normalX, normalY, normalZ,
  0.5f, -0.5f, -0.5f,        1.0f, 0.0f, 0.0f,     0.0, 1.0, 1.0,
  0.5f,  0.5f, -0.5f,        1.0f, 0.0f, 0.0f,     0.0, 1.0, 1.0,
  0.5f, -0.5f,  0.5f,        1.0f, 0.0f, 0.0f,     0.0, 1.0, 1.0,
  0.5f,  0.5f,  0.5f,        1.0f, 0.0f, 0.0f,     0.0, 1.0, 1.0,
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
  [self setupSquareColor];
  
  [self setupTexture];
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
  self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
  self.effect.colorMaterialEnabled = GL_TRUE;
  
  glEnable(GL_DEPTH_TEST);
	//** アルファブレンド
	glEnable( GL_BLEND );
	glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
  
  glGenVertexArraysOES(1, &_vertexArray);
  glBindVertexArrayOES(_vertexArray);
  
  glGenBuffers(1, &_vertexBuffer);
  glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
  glBufferData(GL_ARRAY_BUFFER, sizeof(gSquareData), gSquareData, GL_STATIC_DRAW);
  
  glEnableVertexAttribArray(GLKVertexAttribPosition);
  glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 36, BUFFER_OFFSET(0));
  glEnableVertexAttribArray(GLKVertexAttribNormal);
  glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 36, BUFFER_OFFSET(12));
  glEnableVertexAttribArray(GLKVertexAttribColor);
  glVertexAttribPointer(GLKVertexAttribColor, 3, GL_FLOAT, GL_FALSE, 36, BUFFER_OFFSET(24));
  //                                         次元数                   次元数 x sizeof(GLfloat) x 要素数
  
  glBindVertexArrayOES(0);
}

- (void)setupBoxColor
{
  GLfloat color[3] = {1.0, 1.0, 1.0};
  for (int i = 0; i < 6 * 6; i++){
    for (int k = 0; k < 3; k++){
      gCubeVertexData[i * 3 * 3 + 3 * 2 + k] = color[k];
    }
  }
}

- (void)setupSquareColor
{
  GLfloat color[3] = {1.0, 1.0, 1.0};
  for (int i = 0; i < SQUARE_DATA_LEN / 9; i++){
    for (int k = 0; k < 3; k++){
      gSquareData[i * 3 * 3 + 3 * 2 + k] = color[k];
    }
  }
}

static BOOL isExponent(int x)
{
  return ( x & ( x - 1 ) ) == 0;
}

static int exponent( int num )
{
  int r = 2;
  while ( num > r )
    r *= 2;
  return r;
}

- (void)setupTexture
{
  // 画像のロード
  UIImage* pImage = [ UIImage imageNamed:@"moyashi.png" ];
  _texSize = _imageSize = pImage.size;
  
  // 画像のサイズ変更
  if (!isExponent(_imageSize.width)){
    _texSize.width = exponent(_imageSize.width);
  }
  
  if (!isExponent(_imageSize.height)){
    _texSize.height = exponent(_imageSize.height);
  }

  // ビットマップのデータを用意する
  // 1ピクセルあたりRGBA = 4バイト必要
  GLubyte* pImageData = ( GLubyte* )calloc( _texSize.width * _texSize.height * 4, sizeof( GLubyte ) );
  
  
  // 描画先のグラフィックスコンテキストを作成
  CGColorSpaceRef pColor = CGImageGetColorSpace( pImage.CGImage );
  
  CGContextRef pImageContext = CGBitmapContextCreate( pImageData, _texSize.width, _texSize.height, 8, _texSize.width * 4, pColor, kCGImageAlphaPremultipliedLast );
  
  
  // 左下からになってしまうため
  CGContextTranslateCTM( pImageContext, 0.0, _texSize.height - _imageSize.height );
  
  // コンテキストに書き込み = ビットマップに書き込み
  CGContextDrawImage( pImageContext, CGRectMake( 0, 0, _imageSize.width, _imageSize.height ), pImage.CGImage );
  
  // 確認
//  [self confirmImage:pImageContext];
  
  // いらないものを削除する
  CGContextRelease( pImageContext );
  CGColorSpaceRelease( pColor );
  
	// テクスチャ領域を生成し、 mTexture 変数に識別番号を入れる。
    glGenTextures( 1, &_texture );
    
    // これから使用するテクスチャをセットする。
    glBindTexture( GL_TEXTURE_2D, _texture );
    
	
    // 自動的にミップマップ画像を作成してくれる
    glTexParameteri( GL_TEXTURE_2D, GL_GENERATE_MIPMAP_HINT, GL_TRUE );
    // テクスチャを拡大縮小するときの保管方法
    glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER , GL_LINEAR );
    glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    // テクスチャの繰り返し方法
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE );
    
	
	// テクスチャとポリゴンの合成方法
	// 初期は GL_MODULATE
	//glTexEnvi( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE );		// テクスチャ色で置き換える
	//glTexEnvi( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_DECAL );			// アルファ値が1以下の所がポリゴン色と混ざる
	//glTexEnvi( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE );		// ポリゴン色との掛け算
	 
    
    // 画像をテクスチャに貼り付けます。
    // テクスチャは2のべき乗。
    glTexImage2D( GL_TEXTURE_2D, 0, GL_RGBA, _texSize.width, _texSize.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, pImageData );
	/* テクスチャの割り当て */
    
    free( pImageData );
  
}

- (void)confirmImage:(CGContextRef) imageContext
{
  // 確認
  CGImageRef pdI = CGBitmapContextCreateImage( imageContext );
  UIImage* pTes = [UIImage imageWithCGImage:pdI ];
  NSData *data = UIImagePNGRepresentation( pTes );
  
  NSString *filePath = [NSString stringWithFormat:@"/Users/murakamishintarou/DeskTop/test.png" ];
  
  if ( [data writeToFile:filePath atomically:YES] )
    NSLog(@"生成されたよ。");
  else
    NSLog(@"なにかおかしいっすよ。");
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
  
  GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -4.0f);
  baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, _rotation, 0.0f, 1.0f, 0.0f);
  
  // Compute the model view matrix for the object rendered with GLKit
  GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -1.5f);
  modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
  modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
  
  self.effect.transform.modelviewMatrix = modelViewMatrix;
  
  _rotation += self.timeSinceLastUpdate * 0.5f;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
  glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  
  glBindVertexArrayOES(_vertexArray);
  // Render the object with GLKit
  [self.effect prepareToDraw];
  
  
  // テクスチャ座標
  GLfloat tx = 0.0f;
  GLfloat ty = 0.0f;
  GLfloat tw = _imageSize.width/_texSize.width;
  GLfloat th = _imageSize.height/_texSize.height;
  
  const GLfloat texCoords[] =
  {
    tx,	 ty,	 // 左上
    tx + tw,	ty,	 // 右上
    tx,	 ty + th,	// 左下
    tx + tw,	ty + th,	// 右下
  };
  
  // テクスチャ機能を有効にする
  glEnable( GL_TEXTURE_2D );
  glBindTexture( GL_TEXTURE_2D, _texture );
  
  //** テクスチャ座標をOpenGL ESに教える
  //**     座標の数、 型、 オフセット値, テクスチャ座標が入った配列
  glTexCoordPointer( 2, GL_FLOAT, 0, texCoords );
  glEnableClientState( GL_TEXTURE_COORD_ARRAY );
  
  glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

@end
