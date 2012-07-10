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

@synthesize fixed = _fixed;
@synthesize running = _running;
@synthesize limited = _limited;
@synthesize speed = _motorSpeed;
@synthesize power = _maxTorque;
@synthesize minRotation = _minRotation;
@synthesize maxRotation = _maxRotation;
@synthesize body1 = _body1;
@synthesize body2 = _body2;
@synthesize world = _world;

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
		_prismaticJoint->SetMaxMotorForce(_maxForce / PTM_RATIO / PTM_RATIO * GTKG_RATIO);
	}
}

-(void) setMinRotation:(float)newMinRotation
{
	_minRotation = newMinRotation;
	
	// if the revolute joint exists
	if (_prismaticJoint)
	{
		// set the revolute joint limits
		_prismaticJoint->SetLimits(CC_DEGREES_TO_RADIANS(-_maxRotation), CC_DEGREES_TO_RADIANS(-_minRotation));
	}
}

-(void) setMaxRotation:(float)newMaxRotation
{
	_maxRotation = newMaxRotation;
	
	// if the revolute joint exists
	if (_prismaticJoint)
	{
		// set the revolute joint limits
		_prismaticJoint->SetLimits(CC_DEGREES_TO_RADIANS(-_maxRotation), CC_DEGREES_TO_RADIANS(-_minRotation));
	}
}


-(void) setBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2
{
	[self setBody:sprite1 andBody:sprite2 atAnchor:ccp((sprite1.position.x + sprite2.position.x) / 2, (sprite1.position.y + sprite2.position.y) / 2)];
}

-(void) setBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2 atAnchor:(CGPoint)anchor
{
	_body1 = sprite1;
	_body2 = sprite2;
	_anchor = anchor;
	
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
			b2Vec2 anchor(_anchor.x / PTM_RATIO, _anchor.y / PTM_RATIO);
			//jointData.Initialize(_body1.body, _body2.body, anchor);
			jointData.enableMotor = _running;
			jointData.enableLimit = _limited;
			jointData.motorSpeed = CC_DEGREES_TO_RADIANS(-_motorSpeed);
			jointData.maxMotorForce = _maxForce / PTM_RATIO / PTM_RATIO * GTKG_RATIO;
			jointData.lowerTranslation = CC_DEGREES_TO_RADIANS(-_maxRotation);
			jointData.upperTranslation = CC_DEGREES_TO_RADIANS(-_minRotation);
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
		_anchor.x = anchor.x * PTM_RATIO;
		_anchor.y = anchor.y * PTM_RATIO;
		
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

- (void) dealloc
{
	// remove joint from world
	[self destroyJoint];
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

-(void) onEnter
{
	[super onEnter];
	
	// skip if the joint already exists
	if (_prismaticJoint)
		return;
	
	// if physics manager is not defined
	if (!_world)
	{
		// if parent is a physics manager
		if ([super.parent isKindOfClass:[CCWorldLayer class]])
		{
			// use the parent as the physics manager
			_world = (CCWorldLayer *)super.parent;
		}
	}
	
	// if physics manager is defined now
	if (_world)
	{
		// create the joint
		[self createJoint];
	}
}

-(void) onExit
{
	[super onExit];
	
	// destroy the joint
	[self destroyJoint];
	
	// get rid of the physics manager reference too
	_world = nil;
}

@end
