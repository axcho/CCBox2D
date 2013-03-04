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

#import "CCWorldLayer.h"
#import "CCJointSprite.h"

@interface CCPistonSprite : CCJointSprite
{
	BOOL _running, _limited;
	float _motorSpeed, _maxForce, _minTranslation, _maxTranslation;
	CGPoint _anchor;
	CGPoint _axis;
}

@property (nonatomic) BOOL running;
@property (nonatomic) BOOL limited;
@property (nonatomic) float speed;
@property (nonatomic) float power;
@property (nonatomic) float minTranslation;
@property (nonatomic) float maxTranslation;

-(void) setBody:(CCBodySprite*)sprite1 andBody:(CCBodySprite*)sprite2 axis:(CGPoint)axis;
-(void) setBody:(CCBodySprite*)sprite1 andBody:(CCBodySprite*)sprite2 atAnchor:(CGPoint)anchor axis:(CGPoint)axis;

@end
