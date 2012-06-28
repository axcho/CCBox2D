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


@interface CCSpringSprite : CCSprite <CCJointSprite>
{
	BOOL _fixed;
	float _length, _damping, _frequency;
	CGPoint _anchor1, _anchor2;
	CCBodySprite *_body1;
	CCBodySprite *_body2;
	CCWorldLayer *_world;
}

@property (nonatomic) float length;
@property (nonatomic) float damping;
@property (nonatomic) float frequency;

-(void) setBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2;
-(void) setBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2 atAnchor:(CGPoint)anchor1 andAnchor:(CGPoint)anchor2;

@end
