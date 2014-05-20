//
//  GLSprite.h
//  GLESTextureTest
//
//  Created by 村上 晋太郎 on 2014/05/20.
//  Copyright (c) 2014年 村上 晋太郎. All rights reserved.
//
// ================
//     GLSprite
// ================
//
// OpenGLESの3D空間上に絵を張り付けるクラスです。
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface GLSprite : NSObject
- (id)initWithContext:(EAGLContext *)context effect:(GLKBaseEffect *)effect;
- (void)update;
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect;
@end
