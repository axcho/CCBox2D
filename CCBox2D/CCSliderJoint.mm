//
//  CCSliderJoint.m
//  CCBox2DJoints
//
//  Created by Chris Lowe on 8/7/11.
//  Copyright 2011 Chris Lowe. All rights reserved.
//

#import "CCSliderJoint.h"
#import "CCBodySprite.h"
#import "CCBox2DPrivate.h"

@implementation CCSliderJoint {
    b2PrismaticJoint *_prismaticJoint;
}

@synthesize running = _running;
@synthesize limited = _limited;
@synthesize speed = _motorSpeed;
@synthesize power = _maxTorque;
@synthesize minTranslation = _minTranslation;
@synthesize maxTranslation = _maxTranslation;

-(b2Joint *) joint
{
	return (b2Joint *)_prismaticJoint;
}

-(void) setRunning:(BOOL)newRunning
{
	_running = newRunning;
	
	// if the revolute joint exists
	if (_prismaticJoint)
	{
		// set the revolute joint motor
		_prismaticJoint->EnableMotor(_running);
	}
}

-(void) setLimited:(BOOL)newLimited
{
	_limited = newLimited;
	
	// if the revolute joint exists
	if (_prismaticJoint)
	{
		// set the revolute joint limited
		_prismaticJoint->EnableLimit(_limited);
	}
}

-(void) setSpeed:(float)newSpeed
{
	_motorSpeed = newSpeed;
	
	// if the revolute joint exists
	if (_prismaticJoint)
	{
		// set the revolute joint speed
		_prismaticJoint->SetMotorSpeed(CC_DEGREES_TO_RADIANS(-_motorSpeed));
	}
}

-(void) setPower:(float)newPower
{
	_maxForce = newPower;
	
	// if the revolute joint exists
	if (_prismaticJoint)
	{
		// set the revolute joint power
		_prismaticJoint->SetMaxMotorForce(_maxForce * GTKG_RATIO);
	}
}

-(void) setMinRotation:(float)minTranslation
{
	_minTranslation = minTranslation;
	
	// if the revolute joint exists
	if (_prismaticJoint)
	{
		// set the revolute joint limits
		_prismaticJoint->SetLimits(CC_DEGREES_TO_RADIANS(-_maxTranslation), CC_DEGREES_TO_RADIANS(-_minTranslation));
	}
}

-(void) setMaxRotation:(float)maxTranslation
{
	_maxTranslation = maxTranslation;
	
	// if the revolute joint exists
	if (_prismaticJoint)
	{
		// set the revolute joint limits
		_prismaticJoint->SetLimits(CC_DEGREES_TO_RADIANS(-_maxTranslation), CC_DEGREES_TO_RADIANS(-_minTranslation));
	}
}


-(void) setBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2 axis:(CGPoint)axis
{
    CGPoint anchor = ccp((sprite1.position.x + sprite2.position.x) / 2, (sprite1.position.y + sprite2.position.y) / 2);
	[self setBody:sprite1 andBody:sprite2 atAnchor:anchor axis:axis];
}

-(void) setBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2 atAnchor:(CGPoint)anchor axis:(CGPoint)axis
{
	_body1 = sprite1;
	_body2 = sprite2;
	_anchor = anchor;
    _axis = axis;
	
	// if both sprites exist
	if (_body1 && _body2)
	{
		// notify them that they are attached to this joint
		[_body1 addedToJoint:self];
		[_body2 addedToJoint:self];
	}
}


-(void) destroyJoint
{
	// if the revolute joint exists
	if (_prismaticJoint)
	{
		// destroy the joint
		_prismaticJoint->GetBodyA()->GetWorld()->DestroyJoint(_prismaticJoint);
		_prismaticJoint = NULL;
	}
}

-(void) createJoint
{
	// if the physics manager exists
	if (_world)
	{
		// if the world and bodies exist
		if (_world.world && _body1.body && _body2.body)
		{
			// if the revolute joint exists
			if (_prismaticJoint)
			{
				// destroy it first
				[self destroyJoint];
			}
			
			// set up the data for the joint
			b2PrismaticJointDef jointData;
            CGPoint p = [self.parent convertToWorldSpace:_anchor];
			b2Vec2 anchor(p.x * InvPTMRatio, p.y * InvPTMRatio);
            
			jointData.Initialize(_body1.body, _body2.body, anchor, b2Vec2(_axis.x, _axis.y));
			jointData.enableMotor = _running;
			jointData.enableLimit = _limited;
			jointData.motorSpeed = - CC_DEGREES_TO_RADIANS(_motorSpeed);
			jointData.maxMotorForce = _maxForce * GTKG_RATIO;
			jointData.lowerTranslation = -(_maxTranslation * InvPTMRatio);
			jointData.upperTranslation = -(_minTranslation * InvPTMRatio);
			jointData.collideConnected = false;
			
			// create the joint
			_prismaticJoint = (b2PrismaticJoint *)(_world.world->CreateJoint(&jointData));
			
			// give it a reference to this sprite
			_prismaticJoint->SetUserData(self);
			
			// update every frame
			[self scheduleUpdate];
		}
	}
}

-(id) init
{
	if ((self = [super init]))
	{
        _prismaticJoint = NULL;
		_body1 = nil;
		_body2 = nil;
		_world = nil;
	}
	return self;
}

-(void) update:(ccTime)delta
{
	// if revolute joint exists
	if (_prismaticJoint)
	{
		// update the anchor position
		b2Vec2 anchor = _prismaticJoint->GetAnchorA();
		_anchor.x = anchor.x * PTMRatio;
		_anchor.y = anchor.y * PTMRatio;
		
		// update the display properties to match
		[self setPosition:ccp(_anchor.x, _anchor.y)];
		
		// if the joint is not fixed
		if (!_fixed)
		{
			// adjust the angle to match too
			[self setRotation:CC_RADIANS_TO_DEGREES(-_prismaticJoint->GetJointTranslation())];
		}
	}
}

@end
