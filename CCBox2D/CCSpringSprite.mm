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

#import "CCSpringSprite.h"
#import "CCBodySprite.h"


@implementation CCSpringSprite

@synthesize fixed = _fixed;
@synthesize length = _length;
@synthesize damping = _damping;
@synthesize frequency = _frequency;
@synthesize body1 = _body1;
@synthesize body2 = _body2;
@synthesize world = _world;

-(b2Joint *) joint
{
	return (b2Joint *)_distanceJoint;
}

-(void) setLength:(float)newLength
{
	_length = newLength;
	
	// if the distance joint exists
	if (_distanceJoint)
	{
		// set the distance joint length
		_distanceJoint->SetLength(_length / PTM_RATIO);
	}
}

-(void) setDamping:(float)newDamping
{
	_damping = newDamping;
	
	// if the distance joint exists
	if (_distanceJoint)
	{
		// set the distance joint damping
		_distanceJoint->SetDampingRatio(_damping);
	}
}

-(void) setFrequency:(float)newFrequency
{
	_frequency = newFrequency;
	
	// if the distance joint exists
	if (_distanceJoint)
	{
		// set the distance joint frequency
		_distanceJoint->SetFrequency(_frequency);
	}
}

-(void) setBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2
{
	[self setBody:sprite1 andBody:sprite2 atAnchor:sprite1.position andAnchor:sprite2.position];
}

-(void) setBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2 atAnchor:(CGPoint)anchor1 andAnchor:(CGPoint)anchor2
{
	_body1 = sprite1;
	_body2 = sprite2;
	_anchor1 = anchor1;
	_anchor2 = anchor2;
	
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
	// if the distance joint exists
	if (_distanceJoint)
	{
		// destroy the joint
		_distanceJoint->GetBodyA()->GetWorld()->DestroyJoint(_distanceJoint);
		_distanceJoint = NULL;
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
			// if the distance joint exists
			if (_distanceJoint)
			{
				// destroy it first
				[self destroyJoint];
			}
			
			// set up the data for the joint
			b2DistanceJointDef jointData;
			b2Vec2 anchor1(_anchor1.x / PTM_RATIO, _anchor1.y / PTM_RATIO);
			b2Vec2 anchor2(_anchor2.x / PTM_RATIO, _anchor2.y / PTM_RATIO);
			jointData.Initialize(_body1.body, _body2.body, anchor1, anchor2);
			if (_length >= 0)
				jointData.length = _length / PTM_RATIO;
			else
				_length = jointData.length * PTM_RATIO;
			jointData.dampingRatio = _damping;
			jointData.frequencyHz = _frequency;
			jointData.collideConnected = true;
			
			// create the joint
			_distanceJoint = (b2DistanceJoint *)(_world.world->CreateJoint(&jointData));
			
			// give it a reference to this sprite
			_distanceJoint->SetUserData(self);
			
			// update every frame
			[self scheduleUpdate];
		}
	}
}

-(id) init
{
	if ((self = [super init]))
	{
		_fixed = NO;
		_length = -1;
		_damping = 0;
		_frequency = 0;
		_anchor1 = CGPointZero;
		_anchor2 = CGPointZero;
		_distanceJoint = NULL;
		_body1 = nil;
		_body2 = nil;
		_world = nil;
	}
	return self;
}

-(void) update:(ccTime)delta
{
	// if distance joint exists
	if (_distanceJoint)
	{
		// update the anchor position
		b2Vec2 anchor1 = _distanceJoint->GetAnchorA();
		b2Vec2 anchor2 = _distanceJoint->GetAnchorB();
		_anchor1.x = anchor1.x * PTM_RATIO;
		_anchor1.y = anchor1.y * PTM_RATIO;
		_anchor2.x = anchor2.x * PTM_RATIO;
		_anchor2.y = anchor2.y * PTM_RATIO;
		
		// update the display properties to match
		[self setPosition:ccp((_anchor1.x + _anchor2.x) / 2, (_anchor1.y + _anchor2.y) / 2)];
		
		// if the joint is not fixed
		if (!_fixed)
		{
			// adjust the angle to match too
			float angle = atan2f(_anchor1.y - _anchor2.y, _anchor1.x - _anchor2.x);
			[self setRotation:CC_RADIANS_TO_DEGREES(-angle)];
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
	if (_distanceJoint)
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
