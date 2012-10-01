//
//  CCSliderJoint.h
//  CCBox2DJoints
//
//  Created by Chris Lowe on 8/7/11.
//  Copyright 2011 Chris Lowe. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCWorldLayer.h"
#import "CCJointSprite.h"


@interface CCSliderJoint : CCJointSprite {
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

-(void) setBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2 axis:(CGPoint)axis;
-(void) setBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2 atAnchor:(CGPoint)anchor axis:(CGPoint)axis;

@end
