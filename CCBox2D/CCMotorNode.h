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


@interface CCMotorNode : CCNode <CCJointNode>
{
	BOOL _fixed;
	BOOL _running, _limited;
	float _motorSpeed, _maxTorque, _minRotation, _maxRotation;
	CGPoint _anchor;
	CCBodyNode *_body1;
	CCBodyNode *_body2;
	CCWorldLayer *_world;
}

@property (nonatomic) BOOL running;
@property (nonatomic) BOOL limited;
@property (nonatomic) float speed;
@property (nonatomic) float power;
@property (nonatomic) float minRotation;
@property (nonatomic) float maxRotation;

-(void) setBody:(CCBodyNode *)sprite1 andBody:(CCBodyNode *)sprite2;
-(void) setBody:(CCBodyNode *)sprite1 andBody:(CCBodyNode *)sprite2 atAnchor:(CGPoint)anchor;

@end
