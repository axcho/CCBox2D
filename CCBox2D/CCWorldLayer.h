/*
 
 CCBox2D for iPhone: https://github.com/axcho/CCBox2D
 
 Copyright (c) 2011 axcho and Fugazo, Inc.
 
 This software is provided 'as-is', without any express or implied
 warranty. In no event will the authors be held liable for any damages
 arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose,
 including commercial applications, and to alter it and redistribute it
 freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not
 claim that you wrote the original software. If you use this software
 in a product, an acknowledgment in the product documentation would be
 appreciated but is not required.
 2. Altered source versions must be plainly marked as such, and must not be
 misrepresented as being the original software.
 3. This notice may not be removed or altered from any source distribution.
 
 */

#import <Cocos2DKit/Cocos2DKit.h>

// pixels to meters ratio
#define PTM_RATIO 32

// grams to kilograms ratio
#define GTKG_RATIO 1000


extern CGFloat PTMRatio;
extern CGFloat InvPTMRatio;


@class CCBodySprite;


typedef BOOL (^QueryTest)(CCBodySprite *bodySprite, NSString *shapeName);


@protocol ContactListenizer

-(void) onOverlapBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2;
-(void) onSeparateBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2;
-(void) onCollideBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2 withForce:(float)force withFrictionForce:(float)frictionForce;

@end

@interface CCWorldLayer : CCLayer <ContactListenizer>
{
	int _positionIterations, _velocityIterations;
	CGPoint _gravity;
}

// size of box around the point used for hit testing in -bodyAtPoint:queryTest:; defaults to 16x16 points
// smallest value supported is 2x2
@property (nonatomic) CGSize hitTestSize;

@property (nonatomic) CGPoint gravity;
@property (nonatomic) int positionIterations;
@property (nonatomic) int velocityIterations;
@property (nonatomic) BOOL debugDrawing;

// queryTest should return YES to continue searching
- (CCBodySprite *)bodyAtPoint:(CGPoint)point queryTest:(QueryTest)queryTest;

+ (void)setPixelsToMetresRatio:(CGFloat)ratio;
+ (CGFloat)pixelsToMetresRatio;

@end
