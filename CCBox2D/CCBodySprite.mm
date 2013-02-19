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

#import <Box2D/Box2D.h>

#import "CCBodySprite.h"
#import "CCWorldLayer.h"
#import "CCBox2DPrivate.h"


@implementation CCBodySprite {
    b2Body *_body;
}

@synthesize physicsType = _physicsType;
@synthesize collisionType = _collisionType;
@synthesize collidesWithType = _collidesWithType;
@synthesize active = _active;
@synthesize sleepy = _sleepy;
@synthesize awake = _awake;
@synthesize solid = _solid;
@synthesize fixed = _fixed;
@synthesize bullet = _bullet;
@synthesize density = _density;
@synthesize friction = _friction;
@synthesize bounce = _bounce;
@synthesize damping = _damping;
@synthesize angularDamping = _angularDamping;
@synthesize angularVelocity = _angularVelocity;
@synthesize velocity = _velocity;
@synthesize world = _world;

- (b2Body *)body {
    return _body;
}

-(void) setPhysicsType:(PhysicsType)newPhysicsType
{
	_physicsType = newPhysicsType;
	
	// if body exists
	if (_body)
	{
		// set the body physics type
		_body->SetType(_physicsType == kStatic ? b2_staticBody :
					   _physicsType == kKinematic ? b2_kinematicBody :
					   _physicsType == kDynamic ? b2_dynamicBody :
					   _body->GetType());
	}
}

-(void) setCollisionType:(uint16)newCollisionType
{
	_collisionType = newCollisionType;
	
	// if body exists
	if (_body)
	{
		// for each shape in the body
		NSArray *shapeNames = [_shapes allKeys];
		for (NSString *shapeName in shapeNames)
		{
			// get the shape
			b2Fixture *shape = (b2Fixture *)[[_shapes objectForKey:shapeName] pointerValue];
			
			// get the collision filter for the shape
			b2Filter filter = shape->GetFilterData();
			
			// adjust the collision type
			filter.categoryBits = _collisionType;
			
			// set the collision filter
			shape->SetFilterData(filter);
		}
	}
}

-(void) setCollidesWithType:(uint16)newCollidesWithType
{
	_collidesWithType = newCollidesWithType;
	
	// if body exists
	if (_body)
	{
		
		// for each shape in the body
		NSArray *shapeNames = [_shapes allKeys];
		for (NSString *shapeName in shapeNames)
		{
			// get the shape
			b2Fixture *shape = (b2Fixture *)[[_shapes objectForKey:shapeName] pointerValue];
			
			// get the collision filter for the shape
			b2Filter filter = shape->GetFilterData();
			
			// adjust the collides with type
			filter.maskBits = _collidesWithType;
			
			// set the collision filter
			shape->SetFilterData(filter);
		}
	}
}

-(void) setActive:(BOOL)newActive
{
	_active = newActive;
	
	// if body exists
	if (_body)
	{
		// set the body active
		_body->SetActive(_active);
	}
    // This makes no sense! Doesn't matter if it's active when it has no body, but when it creates one, it should honour this setting!!!@!
//	else
//	{
//		// sprite cannot be active without body
//		_active = NO;
//	}
}

-(void) setSleepy:(BOOL)newSleepy
{
	_sleepy = newSleepy;
	
	// if body exists
	if (_body)
	{
		// set the body sleepy
		_body->SetSleepingAllowed(_sleepy);
	}
}

-(void) setAwake:(BOOL)newAwake
{
	_awake = newAwake;
	
	// if body exists
	if (_body)
	{
		// set the body awake
		_body->SetAwake(_awake);
	}
}

-(void) setSolid:(BOOL)newSolid
{
	_solid = newSolid;
	
	// if body exists
	if (_body)
	{
		// for each shape in the body
		NSArray *shapeNames = [_shapes allKeys];
		for (NSString *shapeName in shapeNames)
		{
			// get the shape
			b2Fixture *shape = (b2Fixture *)[[_shapes objectForKey:shapeName] pointerValue];
			
			// set the shape solid
			shape->SetSensor(!_solid);
		}
	}
	else
	{
		// for each shape data in the body
		NSArray *shapeNames = [_shapeData allKeys];
		for (NSString *shapeName in shapeNames)
		{
			// get the shape data
			b2FixtureDef *shapeData = (b2FixtureDef *)[[_shapeData objectForKey:shapeName] pointerValue];
			
			// set the shape data solid
			shapeData->isSensor = !_solid;
		}
	}
}

-(void) setFixed:(BOOL)newFixed
{
	_fixed = newFixed;
	
	// if body exists
	if (_body)
	{
		// set the body fixed
		_body->SetFixedRotation(_fixed);
	}
}

-(void) setBullet:(BOOL)newBullet
{
	_bullet = newBullet;
	
	// if body exists
	if (_body)
	{
		// set the body bullet
		_body->SetBullet(_bullet);
	}
}

-(void) setDensity:(float)newDensity
{
	_density = newDensity;
	
	// if body exists
	if (_body)
	{
		// for each shape in the body
		NSArray *shapeNames = [_shapes allKeys];
		for (NSString *shapeName in shapeNames)
		{
			// get the shape
			b2Fixture *shape = (b2Fixture *)[[_shapes objectForKey:shapeName] pointerValue];
			
			// set the shape density
			shape->SetDensity(_density * PTM_RATIO * PTM_RATIO / GTKG_RATIO);
		}
	}
	else
	{
		// for each shape data in the body
		NSArray *shapeNames = [_shapeData allKeys];
		for (NSString *shapeName in shapeNames)
		{
			// get the shape data
			b2FixtureDef *shapeData = (b2FixtureDef *)[[_shapeData objectForKey:shapeName] pointerValue];
			
			// set the shape data density
			shapeData->density = _density * PTM_RATIO * PTM_RATIO / GTKG_RATIO;
		}
	}
}

-(void) setDensity:(float)newDensity forShape:(NSString *)shapeName
{
	// if body exists
	if (_body)
	{
		// get the shape with the given name
		b2Fixture *shape = (b2Fixture *)[[_shapes objectForKey:shapeName] pointerValue];
		
		// if the shape exists
		if (shape)
		{
			shape->SetDensity(newDensity * PTM_RATIO * PTM_RATIO / GTKG_RATIO);
		}
	}
	else
	{
		// get the shape data with the given name
		b2FixtureDef *shapeData = (b2FixtureDef *)[[_shapeData objectForKey:shapeName] pointerValue];
		
		// if the shape data exists
		if (shapeData)
		{
			// set the shape data density
			shapeData->density = newDensity * PTM_RATIO * PTM_RATIO / GTKG_RATIO;
		}
	}
}

-(void) setFriction:(float)newFriction
{
	_friction = newFriction;
	
	// if body exists
	if (_body)
	{
		// for each shape in the body
		NSArray *shapeNames = [_shapes allKeys];
		for (NSString *shapeName in shapeNames)
		{
			// get the shape
			b2Fixture *shape = (b2Fixture *)[[_shapes objectForKey:shapeName] pointerValue];
			
			// set the shape friction
			shape->SetFriction(_friction);
		}
	}
	else
	{
		// for each shape data in the body
		NSArray *shapeNames = [_shapeData allKeys];
		for (NSString *shapeName in shapeNames)
		{
			// get the shape data
			b2FixtureDef *shapeData = (b2FixtureDef *)[[_shapeData objectForKey:shapeName] pointerValue];
			
			// set the shape data friction
			shapeData->friction = _friction;
		}
	}
}

-(void) setFriction:(float)newFriction forShape:(NSString *)shapeName
{
	// if body exists
	if (_body)
	{
		// get the shape with the given name
		b2Fixture *shape = (b2Fixture *)[[_shapes objectForKey:shapeName] pointerValue];
		
		// if the shape exists
		if (shape)
		{
			// set the shape friction
			shape->SetFriction(newFriction);
		}
	}
	else
	{
		// get the shape data with the given name
		b2FixtureDef *shapeData = (b2FixtureDef *)[[_shapeData objectForKey:shapeName] pointerValue];
		
		// if the shape data exists
		if (shapeData)
		{
			// set the shape data friction
			shapeData->friction = newFriction;
		}
	}
}

-(void) setBounce:(float)newBounce
{
	_bounce = newBounce;
	
	// if body exists
	if (_body)
	{
		// for each shape in the body
		NSArray *shapeNames = [_shapes allKeys];
		for (NSString *shapeName in shapeNames)
		{
			// get the shape
			b2Fixture *shape = (b2Fixture *)[[_shapes objectForKey:shapeName] pointerValue];
			
			// set the shape bounce
			shape->SetRestitution(_bounce);
		}
	}
	else
	{
		// for each shape data in the body
		NSArray *shapeNames = [_shapeData allKeys];
		for (NSString *shapeName in shapeNames)
		{
			// get the shape data
			b2FixtureDef *shapeData = (b2FixtureDef *)[[_shapeData objectForKey:shapeName] pointerValue];
			
			// set the shape data bounce
			shapeData->restitution = _bounce;
		}
	}
}

-(void) setBounce:(float)newBounce forShape:(NSString *)shapeName
{
	// if body exists
	if (_body)
	{
		// get the shape with the given name
		b2Fixture *shape = (b2Fixture *)[[_shapes objectForKey:shapeName] pointerValue];
		
		// if the shape exists
		if (shape)
		{
			// set the shape bounce
			shape->SetRestitution(newBounce);
		}
	}
	else
	{
		// get the shape data with the given name
		b2FixtureDef *shapeData = (b2FixtureDef *)[[_shapeData objectForKey:shapeName] pointerValue];
		
		// if the shape data exists
		if (shapeData)
		{
			// set the shape data bounce
			shapeData->restitution = newBounce;
		}
	}
}

-(void) setDamping:(float)newDamping
{
	_damping = newDamping;
	
	// if body exists
	if (_body)
	{
		// set the body damping
		_body->SetLinearDamping(_damping);
	}
}

-(void) setAngularDamping:(float)newAngularDamping
{
	_angularDamping = newAngularDamping;
	
	// if body exists
	if (_body)
	{
		// set the body angular damping
		_body->SetAngularDamping(_angularDamping);
	}
}

-(void) setAngularVelocity:(float)newAngularVelocity
{
	_angularVelocity = newAngularVelocity;
	
	// if body exists
	if (_body)
	{
		// set the body angular velocity in radians
		_body->SetAngularVelocity(CC_DEGREES_TO_RADIANS(-_angularVelocity));
	}
}

-(void) setVelocity:(CGPoint)newVelocity
{
	_velocity = newVelocity;
	
	// if body exists
	if (_body)
	{
		// set the body velocity
		_body->SetLinearVelocity(b2Vec2(_velocity.x * InvPTMRatio, _velocity.y * InvPTMRatio));
	}
}

- (CGPoint)velocity {

    CGPoint result;

    if(_body)
    {
        b2Vec2 vel = _body->GetLinearVelocity();
        result.x = vel.x;
        result.y = vel.y;
    }
    else
    {
        result = _velocity;
    }
    
    return result;
}

-(void) setPosition:(CGPoint)newPosition
{
	super.position = newPosition;
    
    NSLog(@"Set new sprite position: %@", NSStringFromCGPoint(newPosition));
	
	// if body exists
	if (_body)
	{
        CGPoint worldPosition = [self.parent convertToWorldSpace:newPosition];
        
        NSLog(@"Setting new body position: %@", NSStringFromCGPoint(worldPosition));
        
		// set the body position in world coordinates
		_body->SetTransform(b2Vec2(worldPosition.x * InvPTMRatio, worldPosition.y * InvPTMRatio), _body->GetAngle());
	}
}

-(void) setRotation:(float)newRotation
{
	super.rotation = newRotation;
	
	// if body exists
	if (_body)
	{
		// set the body rotation in radians
		_body->SetTransform(_body->GetPosition(), CC_DEGREES_TO_RADIANS(-[self rotation]));
	}
}

-(void) applyForce:(CGPoint)force atLocation:(CGPoint)location asImpulse:(BOOL)impulse
{
	// if body exists
	if (_body)
	{
		// get force and location in world coordinates
		b2Vec2 b2Force(force.x * InvPTMRatio * GTKG_RATIO, force.y * InvPTMRatio * GTKG_RATIO);
		b2Vec2 b2Location(location.x * InvPTMRatio, location.y * InvPTMRatio);
		
		// if the force should be an instantaneous impulse
		if (impulse)
		{
			// apply an instant linear impulse
			_body->ApplyLinearImpulse(b2Force, b2Location);
		}
		else
		{
			// apply the force
			_body->ApplyForce(b2Force, b2Location);
		}
	}
}

-(void) applyForce:(CGPoint)force atLocation:(CGPoint)location
{
	[self applyForce:force atLocation:location asImpulse:NO];
}

-(void) applyForce:(CGPoint)force asImpulse:(BOOL)impulse
{
	// apply force to center of object
	b2Vec2 center = _body->GetWorldCenter();
	[self applyForce:force atLocation:ccp(center.x * PTM_RATIO, center.y * PTM_RATIO) asImpulse:impulse];
}

-(void) applyForce:(CGPoint)force
{
	[self applyForce:force asImpulse:NO];
}

-(void) applyTorque:(float)torque asImpulse:(BOOL)impulse
{
	// if body exists
	if (_body)
	{
		// if the torque should be an instantaneous impulse
		if (impulse)
		{
			// apply an instant linear impulse
			_body->ApplyAngularImpulse(torque * InvPTMRatio * InvPTMRatio * GTKG_RATIO);
		}
		else
		{
			// apply the torque
			_body->ApplyTorque(torque * InvPTMRatio * InvPTMRatio * GTKG_RATIO);
		}
	}
}

-(void) applyTorque:(float)torque
{
	[self applyTorque:torque asImpulse:NO];
}

-(void) addShape:(b2Shape *)shape withName:(NSString *)shapeName
{
	// set up the data for the shape
	b2FixtureDef *shapeData = new b2FixtureDef();
	shapeData->shape = shape;
	shapeData->density = _density * PTM_RATIO * PTM_RATIO / GTKG_RATIO;
	shapeData->friction = _friction;
	shapeData->restitution = _bounce;
	shapeData->isSensor = !_solid;
	
	// start with no shape object
	b2Fixture* shapeObject = NULL;
	
	// if the body exists
	if (_body)
	{
		// get the shape with the given name
		b2Fixture *oldShape = (b2Fixture *)[[_shapes objectForKey:shapeName] pointerValue];
		
		// if the shape is already in the list
		if (oldShape)
		{
			// remove the old shape from the body
			_body->DestroyFixture(oldShape);
			
		}
		
		// set the collision type of the shape
		shapeData->filter.categoryBits = _collisionType;
		shapeData->filter.maskBits = _collidesWithType;
		
		// add the shape to the body and get the shape object
		shapeObject = _body->CreateFixture(shapeData);
	}
	
	// if the shape object exists
	if (shapeObject)
	{
		// add it to the list of shapes
		[_shapes setObject:[NSValue valueWithPointer:shapeObject] forKey:shapeName];
		
		// delete the shape data
		delete shapeData->shape;
		shapeData->shape = NULL;
		delete shapeData;
	}
	else
	{
		// get the shape data with the given name
		b2FixtureDef *oldShapeData = (b2FixtureDef *)[[_shapeData objectForKey:shapeName] pointerValue];
		
		// if the shape data was already in the list
		if (oldShapeData)
		{
			// remove the old shape data from the list
			[_shapeData removeObjectForKey:shapeName];
			
			// if the shape exists
			if (oldShapeData->shape)
			{
				// delete the shape
				delete oldShapeData->shape;
				oldShapeData->shape = NULL;
			}
			
			// delete the old shape data
			delete oldShapeData;
		}
		
		// save the new shape data
		[_shapeData setObject:[NSValue valueWithPointer:shapeData] forKey:shapeName];
	}			
}

-(void) addBoxWithName:(NSString *)shapeName ofSize:(CGSize)shapeSize atLocation:(CGPoint)shapeLocation
{
	// create a box shape
	b2PolygonShape *boxShape = new b2PolygonShape();
	boxShape->SetAsBox(shapeSize.width / 2 * InvPTMRatio, shapeSize.height / 2 * InvPTMRatio, b2Vec2((shapeLocation.x - _position.x) * InvPTMRatio, (shapeLocation.y - _position.y) * InvPTMRatio), 0);
	
	// add it
	[self addShape:boxShape withName:shapeName];
}

-(void) addBoxWithName:(NSString *)shapeName ofSize:(CGSize)shapeSize
{
	[self addBoxWithName:shapeName ofSize:shapeSize atLocation:_position];
}

-(void) addBoxWithName:(NSString *)shapeName
{
	[self addBoxWithName:shapeName ofSize:_rect.size];
}

-(void) addCircleWithName:(NSString *)shapeName ofRadius:(float)shapeRadius atLocation:(CGPoint)shapeLocation
{
	// create a circle shape
	b2CircleShape *circleShape = new b2CircleShape();
	circleShape->m_radius = shapeRadius * InvPTMRatio;
	circleShape->m_p.Set((shapeLocation.x - _position.x) * InvPTMRatio, (shapeLocation.y - _position.y) * InvPTMRatio);
	
	// add it
	[self addShape:circleShape withName:shapeName];
}

-(void) addCircleWithName:(NSString *)shapeName ofRadius:(float)shapeRadius
{
	[self addCircleWithName:shapeName ofRadius:shapeRadius atLocation:_position];
}

-(void) addCircleWithName:(NSString *)shapeName
{
	float width = _rect.size.width;
	float height = _rect.size.height;
	float diameter = (width < height) ? width : height;
	[self addCircleWithName:shapeName ofRadius:(diameter / 2)];
}

-(void) addPolygonWithName:(NSString *)shapeName withVertices:(CCArray *)shapeVertices
{
	// the number of vertices should be within limits
	assert([shapeVertices count] <= b2_maxPolygonVertices);
	
	// create a new array of vertices
	b2Vec2 vertices[b2_maxPolygonVertices];
	
	// convert the array of vertices into world coordinates
	int i = 0;
	NSValue *vertex;
	CCARRAY_FOREACH(shapeVertices, vertex)
	{
		// save the vertex in world coordinates
		CGPoint point = [vertex CGPointValue];
		vertices[i] = b2Vec2((point.x - _position.x) * InvPTMRatio, (point.y - _position.y) * InvPTMRatio);
		
		// next vertex
		i++;
	}
	
	// create a polygon shape
	b2PolygonShape *polygonShape = new b2PolygonShape();
	polygonShape->Set(vertices, [shapeVertices count]);
	
	// add it
	[self addShape:polygonShape withName:shapeName];
}

-(void) addChainWithName:(NSString *)shapeName withVertices:(CGPoint *)chainVertices count:(NSUInteger)count {
    
    b2ChainShape *chainShape = new b2ChainShape();
    
    chainShape->CreateLoop((b2Vec2 *)chainVertices, count);
    
    [self addShape:chainShape withName:shapeName];
}

-(void) removeShapeWithName:(NSString *)shapeName
{
	// if body exists
	if (_body)
	{
		// get the shape with the given name
		b2Fixture *oldShape = (b2Fixture *)[[_shapes objectForKey:shapeName] pointerValue];
		
		// if the shape is already in the list
		if (oldShape)
		{
			// remove the shape from the list
			[_shapes removeObjectForKey:shapeName];
			
			// remove the old shape from the body
			_body->DestroyFixture(oldShape);
		}
	}
	else
	{
		// get the shape data with the given name
		b2FixtureDef *oldShapeData = (b2FixtureDef *)[[_shapeData objectForKey:shapeName] pointerValue];
		
		// remove the old shape data from the list
		[_shapeData removeObjectForKey:shapeName];
		
		// if the shape data was already in the list
		if (oldShapeData)
		{
			// if the shape exists
			if (oldShapeData->shape)
			{
				// delete the shape
				delete oldShapeData->shape;
				oldShapeData->shape = NULL;
			}
			
			// delete the old shape data
			delete oldShapeData;
		}
	}
}

-(void) removeShapes
{
	// if body exists
	if (_body)
	{
		// for each shape in the body
		NSArray *shapeNames = [_shapes allKeys];
		for (NSString *shapeName in shapeNames)
		{
			// get the shape
			b2Fixture *shape = (b2Fixture *)[[_shapes objectForKey:shapeName] pointerValue];
			
			// remove the shape from the list
			[_shapes removeObjectForKey:shapeName];
			
			// remove the shape from the body
			_body->DestroyFixture(shape);
		}
		
		// clear the list
		[_shapes removeAllObjects];
	}
	else
	{
		// for each shape data in the body
		NSArray *shapeNames = [_shapeData allKeys];
		for (NSString *shapeName in shapeNames)
		{
			// get the shape data
			b2FixtureDef *shapeData = (b2FixtureDef *)[[_shapeData objectForKey:shapeName] pointerValue];
			
			// remove the shape data from the list
			[_shapeData removeObjectForKey:shapeName];
			
			// if the shape exists
			if (shapeData->shape)
			{
				// delete the shape
				delete shapeData->shape;
				shapeData->shape = NULL;
			}
			
			// delete the shape data
			delete shapeData;
		}
		
		// clear the list
		[_shapeData removeAllObjects];
	}
}

-(void) addedToJoint:(CCSprite<CCJointSprite> *)sprite
{
	// if the body does not yet exist
	if (!_body)
	{
		// if joint list does not exist
		if (!_joints)
		{
			_joints = [[CCArray array] retain];
		}
		
		// add the joint to the list of joints
		[_joints addObject:sprite];
	}
	else
	{
		// activate the joint
		[sprite onEnter];
	}

}

-(void) destroyBody
{
	// if body exists
	if (_body)
	{
		// for each attached joint
		b2JointEdge *nextJoint;
		for (b2JointEdge *joint = _body->GetJointList(); joint; joint = nextJoint)
		{
			// get the next joint ahead of time to avoid a bad pointer when joint is destroyed
			nextJoint = joint->next;
			
			// get the joint sprite
			CCSprite<CCJointSprite> *sprite = (CCSprite<CCJointSprite> *)(joint->joint->GetUserData());
			
			// if the sprite exists
			if (sprite)
			{
				// remove the sprite
				[sprite removeFromParentAndCleanup:YES];
			}
		}
		
		// destroy the body
		_body->GetWorld()->DestroyBody(_body);
		_body = NULL;
	}
	
	// be inactive
	_active = false;
}

-(void) createBody
{
	// if physics manager exists
	if (_world)
	{
		// if the world exists
		if (_world.world)
		{
			// if body exists
			if (_body)
			{
				// destroy it first
				[self destroyBody];
			}
			
            CGPoint worldPosition = [self.parent convertToWorldSpace:self.position];

			// set up the data for the body
			b2BodyDef bodyData;
			bodyData.linearVelocity = b2Vec2(_velocity.x * InvPTMRatio, _velocity.y * InvPTMRatio);
			bodyData.angularVelocity = CC_DEGREES_TO_RADIANS(-_angularVelocity);
			bodyData.angularDamping = _angularDamping;
			bodyData.linearDamping = _damping;
			bodyData.position = b2Vec2(worldPosition.x * InvPTMRatio, worldPosition.y * InvPTMRatio);
			bodyData.angle = CC_DEGREES_TO_RADIANS(-[self rotation]);
//			_active = true;
			bodyData.active = _active;
			bodyData.allowSleep = _sleepy;
			bodyData.awake = _awake;
			bodyData.fixedRotation = _fixed;
			bodyData.bullet = _bullet;
			bodyData.type = (_physicsType == kStatic ? b2_staticBody :
							  _physicsType == kKinematic ? b2_kinematicBody :
							  _physicsType == kDynamic ? b2_dynamicBody :
							  bodyData.type);
			
			// create the body
			_body = _world.world->CreateBody(&bodyData);
			
			// give it a reference to this sprite
			_body->SetUserData(self);
			
			// add all the shapes to the body
			NSArray *shapeNames = [_shapeData allKeys];
			for (NSString *shapeName in shapeNames)
			{
				// get the shape data
				b2FixtureDef *shapeData = (b2FixtureDef *)[[_shapeData objectForKey:shapeName] pointerValue];
				
				// set the collision type of the shape
				shapeData->filter.categoryBits = _collisionType;
				shapeData->filter.maskBits = _collidesWithType;
				
				// add the shape to the body and get the shape object
				b2Fixture* shapeObject = _body->CreateFixture(shapeData);
				
				// add the shape object to the map
				[_shapes setObject:[NSValue valueWithPointer:shapeObject] forKey:shapeName];
				
				// remove the shape data from the list
				[_shapeData removeObjectForKey:shapeName];
				
				// if the shape exists
				if (shapeData->shape)
				{
					// delete the shape
					delete shapeData->shape;
					shapeData->shape = NULL;
				}
				
				// delete the shape data
				delete shapeData;
			}
			
			// clear the old shape data
			[_shapeData removeAllObjects];
			
			// if there are any joints
			if (_joints)
			{
				// for each associated joint sprite
				CCSprite *sprite;
				CCARRAY_FOREACH(_joints, sprite)
				{
					// if the joint is already added
					if (sprite.parent)
					{
						// reactivate the joint?
						[sprite onEnter];
					}
				}
			}
			
			// update every frame
			[self scheduleUpdate];
		}
	}
}

-(id) init
{
	if ((self = [super init]))
	{
		_physicsType = kDynamic;
		_collisionType = 0xFFFF;
		_collidesWithType = 0xFFFF;
		_active = YES;
		_sleepy = YES;
		_awake = YES;
		_solid = YES;
		_fixed = NO;
		_bullet = NO;
		_density = 1.0;
		_friction = 0.3;
		_bounce = 0.2;
		_damping = 0.0;
		_angularDamping = 0.0;
		_angularVelocity = 0.0;
		_velocity = CGPointZero;
		_body = NULL;
		_joints = nil;
		_world = nil;
		
		_shapes = [[NSMutableDictionary alloc] init];
		_shapeData = [[NSMutableDictionary alloc] init];
	}
	return self;
}

-(void) update:(ccTime)delta
{
	// if body exists
	if (_body)
	{
		// check if the body is active
		BOOL wasActive = _active;
		_active = _body->IsActive();
		
		// if the body is or was active
		if (_active || wasActive)
		{
			// update the display properties to match
			b2Vec2 bodyPosition = _body->GetPosition();
            CGPoint worldPosition = ccp(bodyPosition.x * PTM_RATIO, bodyPosition.y * PTM_RATIO);
            CGPoint localPosition = [self.parent convertToNodeSpace:worldPosition];
            
            if([self.parent isKindOfClass:[CCWorldLayer class]] && !CGPointEqualToPoint(worldPosition, localPosition))
//                NSAssert(CGPointEqualToPoint(worldPosition, localPosition), @"Calculation Error");
                [self.parent convertToNodeSpace:worldPosition];
            
			[super setPosition:localPosition];
			[super setRotation:CC_RADIANS_TO_DEGREES(-_body->GetAngle())];
			
			// check if the body is awake
			_awake = _body->IsAwake();
		}
	}
}

- (void) dealloc
{
	// remove body from world
	[self destroyBody];
	
	// remove joints array
	if (_joints)
		[_joints release];
	
	// remove the shape dictionary
	if (_shapes)
		[_shapes release];
	
	// remove the shape data dictionary
	if (_shapeData)
		[_shapeData release];
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

-(void) onEnter
{
	[super onEnter];
	
	// skip if the body already exists
	if (_body)
		return;
	
	// if physics manager is not defined
	if (!_world)
	{
		// if parent is a physics manager
		if ([_parent isKindOfClass:[CCWorldLayer class]])
		{
			// use the parent as the physics manager
			_world = (CCWorldLayer *)_parent;
		}
	}
	
	// if physics manager is defined now
	if (_world)
	{
		// create the body
		[self createBody];
	}
}

-(void) onExit
{
	[super onExit];
	
	// destroy the body
	[self destroyBody];
	
	// get rid of the physics manager reference too
	_world = nil;
}

-(void) onOverlapBody:(CCBodySprite *)sprite
{
}

-(void) onSeparateBody:(CCBodySprite *)sprite
{
}

-(void) onCollideBody:(CCBodySprite *)sprite withForce:(float)force withFrictionForce:(float)frictionForce
{
}

@end
