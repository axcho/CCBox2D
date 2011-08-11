//
//  CCSliderJoint.h
//  CCBox2DJoints
//
//  Created by Chris Lowe on 8/7/11.
//  Copyright 2011 Chris Lowe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCWorldLayer.h"

@interface CCSliderJoint : CCSprite <CCJointSprite> {
   
   BOOL _fixed;
   BOOL _running, _limited;
	float _motorSpeed, _maxForce, _minRotation, _maxRotation;
	CGPoint _anchor;
	b2PrismaticJoint *_prismaticJoint;
	CCBodySprite *_body1;
	CCBodySprite *_body2;
	CCWorldLayer *_world;
}

@property (nonatomic) BOOL running;
@property (nonatomic) BOOL limited;
@property (nonatomic) float speed;
@property (nonatomic) float power;
@property (nonatomic) float minRotation;
@property (nonatomic) float maxRotation;

-(void) setBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2;
-(void) setBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2 atAnchor:(CGPoint)anchor;

@end
