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

#import "Box2D.h"

#import "CCBodySprite.h"
#import "CCWorldLayer.h"
#import "CCShape.h"
#import "CCJointSprite.h"
#import "CCBox2DPrivate.h"

#pragma mark -

@implementation CCBodySprite
{    
}

#pragma mark - Properties

@synthesize onTouchDownBlock;
@synthesize startContact = _startContact;
@synthesize endContact = _endContact;
@synthesize collision = _collision;
@synthesize world = _world;
@synthesize worldLayer = _worldLayer;
@synthesize shapes = _shapes;
@synthesize surfaceVelocity = _surfaceVelocity;
@synthesize scaleFactorMoving = _scaleFactorMoving;
@synthesize physicsPosition;

@dynamic physicsType;
@dynamic collisionTypes;
@dynamic collidesWithTypes;
@dynamic active;
@dynamic sleepy;
@dynamic awake;
@dynamic fixed;
@dynamic bullet;
@dynamic damping;
@dynamic angularDamping;
@dynamic angularVelocity;
@dynamic velocity;

#pragma mark - Private

-(void) recursiveMarkTransformDirty
{
	for (id node in self.children)
		if ([node isKindOfClass:[CCBodySprite class]])
			[node recursiveMarkTransformDirty];
	_worldTransformDirty = YES;
}

-(CGAffineTransform) worldTransform
{
	if (_worldTransformDirty)
	{
		CGAffineTransform t = [self nodeToParentTransform];
		
		for (CCNode *p = _parent; [p class] == [self class]; p = p->_parent)
			t = CGAffineTransformConcat(t, [p nodeToParentTransform]);
		
		_worldTransform = CGAffineTransformInvert(t);
		_worldTransformDirty = NO;
	}
	
	return _worldTransform;
}

#pragma mark - Accessors

-(void) setPhysicsType:(PhysicsType)physicsType
{
	if (self.body)
		self.body->SetType((b2BodyType)physicsType);
	else
		self.bodyDef->type = (b2BodyType)physicsType;
}

-(PhysicsType) physicsType
{
	if (self.body)
		return (PhysicsType)self.body->GetType();
	else
		return (PhysicsType)self.bodyDef->type;
}

-(void) setCollisionTypes:(NSArray*)collisionTypes
{
	// if there was a previous list of collision types
	if (_collisionTypes)
	{
		// release it
		[_collisionTypes release], _collisionTypes = nil;
	}
	
	// save the new list of collision types
	_collisionTypes = collisionTypes;
	
	// reset the corresponding collision category
	_collisionCategory = 0;
	
	// if a list of collision types is specified
	if (_collisionTypes)
	{
		// keep it around in memory
		[_collisionTypes retain];
		
		// if the world layer exists
		if (self.worldLayer)
		{
			// for each collision type
			for (NSString* collisionType in _collisionTypes)
			{
				// get the index for the collision type
				NSUInteger index = [[self worldLayer] collisionTypeIndex:collisionType];

				// add it to the collision category
				_collisionCategory |= 1 << index;
			}
			
			// if the list of collision types is empty
			if ([_collisionTypes count] == 0)
			{
				// collide as everything
				_collisionCategory = 0xFFFF;
			}
			
			// for each shape in the body
			for (NSString* name in _shapes)
			{
				// get the shape
				CCShape* shape = [_shapes objectForKey:name];
			
				// set the collision category for the shape
				shape.collisionCategory = _collisionCategory;
			}
		}
		
	}
}

-(void) setCollisionTypesFromString:(NSString*)collisionTypesString
{
	[self setCollisionTypes:[collisionTypesString componentsSeparatedByString:@","]];
}

-(NSArray*) collisionTypes
{
	return _collisionTypes;
}

-(void) setCollidesWithTypes:(NSArray*)collidesWithTypes
{
	// if there was a previous list of collides with types
	if (_collidesWithTypes)
	{
		// release it
		[_collidesWithTypes release], _collidesWithTypes = nil;
	}
	
	// save the new list of collides with types
	_collidesWithTypes = collidesWithTypes;
	
	// reset the corresponding collision mask
	_collisionMask = 0;
	
	// if a list of collides with types is specified
	if (_collidesWithTypes)
	{
		// keep it around in memory
		[_collidesWithTypes retain];
		
		// if the world layer exists
		if (self.worldLayer)
		{
			// for each collides with type
			for (NSString* collidesWithType in _collidesWithTypes)
			{
				// get the index for the collision type
				NSUInteger index = [[self worldLayer] collisionTypeIndex:collidesWithType];

				// add it to the collision mask
				_collisionMask |= 1 << index;
			}
			
			// if the list of collides with types is empty
			if ([_collidesWithTypes count] == 0)
			{
				// collide with everything
				_collisionMask = 0xFFFF;
			}
			
			// for each shape in the body
			for (NSString* name in _shapes)
			{
				// get the shape
				CCShape* shape = [_shapes objectForKey:name];
			
				// set the collision mask for the shape
				shape.collisionMask = _collisionMask;
			}
		}
	}
}

-(void) setCollidesWithTypesFromString:(NSString*)collisionTypesString
{
	[self setCollidesWithTypes:[collisionTypesString componentsSeparatedByString:@","]];
}

-(NSArray*) collidesWithTypes
{
	return _collisionTypes;
}

-(BOOL) active
{
	if (self.body)
		return self.body->IsActive();
	else
		return self.bodyDef->active;
}

-(void) setActive:(BOOL)active
{
	if (self.body)
		self.body->SetActive(active);
	else
		self.bodyDef->active = active;
}

-(BOOL) sleepy
{
	if (self.body)
		return self.body->IsSleepingAllowed();
	else
		return self.bodyDef->allowSleep;
}

-(void) setSleepy:(BOOL)sleep
{
	if (self.body)
		self.body->SetSleepingAllowed(sleep);
	else
		self.bodyDef->allowSleep = sleep;
}

- (BOOL) awake
{
	if (self.body)
		return self.body->IsAwake();
	else
		return self.bodyDef->awake;
}

-(void) setAwake:(BOOL)awake
{
	if (self.body)
		self.body->SetAwake(awake);
	else
		self.bodyDef->awake = awake;
}

- (BOOL) fixed
{
	if (self.body)
		return self.body->IsFixedRotation();
	else
		return self.bodyDef->fixedRotation;
}

-(void) setFixed:(BOOL)fixed
{
	if (self.body)
		self.body->SetFixedRotation(fixed);
	else
		self.bodyDef->fixedRotation = fixed;
}

- (BOOL) bullet
{
	if (self.body)
		return self.body->IsBullet();
	else
		return self.bodyDef->bullet;
}

-(void) setBullet:(BOOL)bullet
{
	if (self.body)
		self.body->SetBullet(bullet);
	else
		self.bodyDef->bullet = bullet;
}

-(void) setDamping:(Float32)damping
{
	if (self.body)
		self.body->SetLinearDamping(damping);
	else
		self.bodyDef->linearDamping = damping;
}

-(void) setAngularDamping:(Float32)angularDamping
{
	if (self.body)
		self.body->SetAngularDamping(angularDamping);
	else
		self.bodyDef->angularDamping = angularDamping;
}

-(void) setAngularVelocity:(Float32)angularVelocity
{
	if (self.body)
		self.body->SetAngularVelocity(CC_DEGREES_TO_RADIANS(-angularVelocity));
	else
		self.bodyDef->angularVelocity = CC_DEGREES_TO_RADIANS(-angularVelocity);
}

-(void) setVelocity:(CGPoint)velocity
{
	b2Vec2 linearVelocity = b2Vec2(velocity.x * InvPTMRatio, velocity.y * InvPTMRatio);
	
	if (self.body)
		self.body->SetLinearVelocity(linearVelocity);
	else
		self.bodyDef->linearVelocity = linearVelocity;
}

-(CGPoint) velocity
{
	b2Vec2 linearVelocity;
	
	if (self.body)
		linearVelocity = self.body->GetLinearVelocity();
	else
		linearVelocity = self.bodyDef->linearVelocity;
		
	CGPoint result;

	result.x = linearVelocity.x * PTMRatio;
	result.y = linearVelocity.y * PTMRatio;
	
	return result;
}

-(void) setWorldLayer:(CCWorldLayer*)worldLayer
{
	if (_worldLayer != worldLayer)
	{
		_worldLayer = worldLayer;
		_world = _worldLayer.world;
		for (id child in self.children)
			if ([child respondsToSelector:@selector(setWorldLayer:)])
				[child setWorldLayer:worldLayer];
	}
}

-(void) setWorld:(b2World*)world
{
	if (_world != world)
	{
		_world = world;
		for (id child in self.children)
			if ([child respondsToSelector:@selector(setWorld:)])
				[child setWorld:world];
	}
}

#pragma mark - Dynamic Accessors

-(BOOL) isCreated
{
	return NULL != self.body;
}

-(Float32) mass
{
	if (!self.body)
		return 0;
	return
		self.body->GetMass();
}

-(Float32) inertia
{
	if (!self.body)
		return 0;
	return
		self.body->GetInertia();
}

#pragma mark - CCNode Accessors

-(void) setPosition:(CGPoint)newPosition
{
	super.position = newPosition;
	
	if (_world)
	{
		if (self.body)
		{
			CGPoint worldPosition = newPosition;
			
			if ([_parent isKindOfClass:[CCBodySprite class]])
				worldPosition = CGPointApplyAffineTransform(newPosition, CGAffineTransformInvert([(CCBodySprite*)_parent worldTransform]));
			
			b2Vec2 vec = b2Vec2(worldPosition.x * InvPTMRatio, worldPosition.y * InvPTMRatio);
			float32 angle = self.body->GetAngle();
			if (_world->IsLocked() == false)
			{
				self.body->SetTransform(vec, angle); // http://www.raywenderlich.com/forums/viewtopic.php?f=2&t=29&start=60
			}
			else
			{
				NSLog(@"WARNING: can't set transform on callback from listener");
			}
		}
	}
	else
	{
		NSLog(@"WARNING: no world set");
	}
	
	[self recursiveMarkTransformDirty];
}

-(void) setRotation:(Float32)newRotation
{
	super.rotation = newRotation;
	
	if (self.body)
		self.body->SetTransform(self.body->GetPosition(), CC_DEGREES_TO_RADIANS(-[self rotation]));
}

#pragma mark - Forces

-(void) applyForce:(CGPoint)force atLocation:(CGPoint)location asImpulse:(BOOL)impulse
{
	if (self.body)
	{
		// get force and location in world coordinates
		b2Vec2 b2Force(force.x * InvPTMRatio * GTKG_RATIO, force.y * InvPTMRatio * GTKG_RATIO);
		b2Vec2 b2Location(location.x * InvPTMRatio, location.y * InvPTMRatio);
		
		if (impulse)
		{
			self.body->ApplyLinearImpulse(b2Force, b2Location);
		}
		else
		{
			self.body->ApplyForce(b2Force, b2Location);
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
	if (self.body)
	{
		b2Vec2 center = self.body->GetWorldCenter();
		[self applyForce:force atLocation:ccp(center.x * PTMRatio, center.y * PTMRatio) asImpulse:impulse];
	}
}

-(void) applyForce:(CGPoint)force
{
	[self applyForce:force asImpulse:NO];
}

-(void) applyTorque:(Float32)torque asImpulse:(BOOL)impulse
{
	if (self.body)
	{
		if (impulse)
		{
		   self.body->ApplyAngularImpulse(torque * GTKG_RATIO); 
		}
		else
		{
		   self.body->ApplyTorque(torque * GTKG_RATIO); 
		}
	}
}

-(void) applyTorque:(Float32)torque
{
	[self applyTorque:torque asImpulse:NO];
}

#pragma mark - Shapes

-(CCShape*) shapeNamed:(NSString*)name
{
	return [_shapes objectForKey:name];
}

-(void) addShape:(CCShape*)shape named:(NSString*)name
{
	CCShape* oldShape = [_shapes objectForKey:name];

	if (self.body)
	{
		if (oldShape)
			[oldShape removeFixtureFromBody:self];
		[shape addFixtureToBody:self];
	}
	
	[_shapes setObject:shape forKey:name];
	
	// set the collision category and mask if they are explicitly defined
	if (_collisionTypes)
		shape.collisionCategory = _collisionCategory;
	if (_collidesWithTypes)
		shape.collisionMask = _collisionMask;
}

-(void) removeShapeNamed:(NSString*)name
{
	CCShape* shape = [_shapes objectForKey:name];
	
	if (!shape) return;
	
	if (self.body)
		[shape removeFixtureFromBody:self];
	
	[_shapes removeObjectForKey:name];
}

-(void) removeShapes
{
	for (NSString* name in [_shapes allKeys])
		[self removeShapeNamed:name];
}

-(void) addedToJoint:(CCJointSprite*)sprite
{
	if (!self.body)
	{
		if (!_joints)
			_joints = [[CCArray array] retain];
		
		[_joints addObject:sprite];
	}
	else
		[sprite onEnter];
}

- (NSString*)shapeDescription
{
	NSMutableArray* strings = [NSMutableArray array];
	
	for (NSString* name in _shapes)
	{
		[strings addObject:[NSString stringWithFormat:@"%@: %@", name, [[_shapes objectForKey:name] shapeDescription]]];
	}
	for (CCNode* node in self.children)
	{
		if ([node isKindOfClass:[CCBodySprite class]])
		{
			[strings addObject:[(CCBodySprite*)node shapeDescription]];
		}
	}

	return [strings componentsJoinedByString:@", "];
}

- (CGPoint)setPhysicsPosition
{
	b2Vec2 b2Position = b2Vec2(self.position.x / PTM_RATIO, self.position.y / PTM_RATIO);
	float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS(self.rotation);
	
	b2Vec2 vec;
	if (self.body)
	{
		self.body->SetTransform(b2Position, b2Angle);
	}
	else
	{
		self.bodyDef->position = b2Position;
	}
}

- (CGPoint)physicsPosition
{
	
	b2Vec2 vec;
	
	if (self.body)
	{
	   vec = self.body->GetPosition();
	}
	else
	{
	   vec = self.bodyDef->position;       
	}
 
	return CGPointMake(vec.x, vec.y);
}

#pragma mark - Body Management

-(void) destroyBody
{
	if (self.body)
	{
		// for each attached joint
		b2JointEdge* nextJoint;
		for (b2JointEdge* joint = self.body->GetJointList(); joint; joint = nextJoint)
		{
			// get the next joint ahead of time to avoid a bad pointer when joint is destroyed
			nextJoint = joint->next;
			
			// get the joint sprite
			CCJointSprite* sprite = (CCJointSprite*)(joint->joint->GetUserData());
			
			if (sprite)
				[sprite removeFromParentAndCleanup:YES];
		}
		
		// destroy the body
		self.body->GetWorld()->DestroyBody(self.body);
		self.body = NULL;
		self.bodyDef = new b2BodyDef();
		
		[self removeShapes];
	}
}

-(void) createBody
{
	if (_world)
	{
		if (self.body)
			[self destroyBody];
		 
		CGPoint position = _position;
		
		if ([_parent isKindOfClass:[CCBodySprite class]])
			position = CGPointApplyAffineTransform(_position, CGAffineTransformInvert([(CCBodySprite*)_parent worldTransform]));
		
		self.bodyDef->position = b2Vec2(position.x * InvPTMRatio, position.y * InvPTMRatio);
		self.body = _world->CreateBody(self.bodyDef);
		
		delete self.bodyDef;
		self.bodyDef = NULL;
		
		self.body->SetUserData(self);
		
		for (NSString *key in [_shapes allKeys])
			[[_shapes objectForKey:key] addFixtureToBody:self userData:key];
		
		for (CCSprite *sprite in _joints)
			if (sprite.parent) [sprite onEnter];
		
		[self scheduleUpdate];
	}
}

#pragma mark - NSObject

- (void) dealloc
{
	[self destroyBody];
	[_joints release], _joints = nil;
	[_shapes release], _shapes = nil;
	if (_collisionTypes)
		[_collisionTypes release], _collisionTypes = nil;
	if (_collidesWithTypes)
		[_collidesWithTypes release], _collidesWithTypes = nil;
	self.startContact = nil;
	self.onTouchDownBlock = nil;
	self.endContact = nil;
	self.collision = nil;
	[super dealloc];
}

-(id) init
{
	if ((self = [super init]))
	{
		self.bodyDef = new b2BodyDef();
		self.bodyDef->type = b2_dynamicBody;
		self.bodyDef->awake = YES;
		self.bodyDef->allowSleep = YES;
		self.bodyDef->userData = self;

		_wasActive = self.bodyDef->active = YES;

		_shapes = [[NSMutableDictionary alloc] init];
		_collisionTypes = nil;
		_collidesWithTypes = nil;
		_collisionCategory = 0;
		_collisionMask = 0;
	}
	return self;
}

-(id) initWithWorld:(b2World*)world bodyType:(b2BodyType)type
{
	if ((self = [super init]))
	{
		self.bodyDef = new b2BodyDef();
		self.bodyDef->type = type;
		self.bodyDef->awake = YES;
		self.bodyDef->allowSleep = YES;
		self.bodyDef->userData = self;
		
		_world = world;
		
		_wasActive = self.bodyDef->active = YES;
		
		_shapes = [[NSMutableDictionary alloc] init];
		_collisionTypes = nil;
		_collidesWithTypes = nil;
		_collisionCategory = 0;
		_collisionMask = 0;

		[self createBody];
	}
	return self;
}

-(void) configureSpriteForWorld:(b2World*)world bodyDef:(b2BodyDef)bodyDef 
{
	if (self.body)
		[self destroyBody];
	
	self.bodyDef = new b2BodyDef(bodyDef);
	_wasActive = self.bodyDef->active = YES;
	_world = world;

	[self createBody];
}

#pragma mark - Updating

-(void) update:(ccTime)delta
{
	if (!self.body)
		return;
	
	BOOL active = self.body->IsActive();
	
	if (!active && !_wasActive)
		return;
	
	b2Vec2 newBodyPos = self.body->GetPosition();
	CGPoint position = ccp(newBodyPos.x * PTMRatio, newBodyPos.y * PTMRatio);
	
	if ([_parent isKindOfClass:[CCBodySprite class]])
		position = CGPointApplyAffineTransform(position, [(CCBodySprite*)_parent worldTransform]);
	
	if (!CGPointEqualToPoint(position, _position))
	{
		[super setPosition: ccpMult(position,InvPTMRatio)];
		[self recursiveMarkTransformDirty];
	}
	
	[super setRotation:CC_RADIANS_TO_DEGREES(-self.body->GetAngle())];
	
	_wasActive = active;
}

#pragma mark - CCNode

-(void) onEnter
{
	[super onEnter];
	
	if (self.body)
		return;
	
	if (!_worldLayer && [_parent isKindOfClass:[CCWorldLayer class]])
		self.worldLayer = (CCWorldLayer*)_parent;
	
	if (_world)
		[self createBody];
}

-(void) onExit
{
	[self destroyBody];
	self.worldLayer = nil;
	[super onExit];
}

-(void) setScale:(float)scale
{
	[super setScale:scale];
}

-(CGPoint) centerPoint
{
	b2Vec2 vec = _body->GetWorldCenter();
	return CGPointMake(vec.x, vec.y);
}

// when initializing this class with super methods - in order to get the setPosition to catch - you must override these methods
/*+(id) spriteWithTexture:(CCTexture2D*)texture
{
	return [[[self alloc] initWithTexture:texture] autorelease];
}

+(id) spriteWithTexture:(CCTexture2D*)texture rect:(CGRect)rect
{
	return [[[self alloc] initWithTexture:texture rect:rect] autorelease];
}

+(id) spriteWithFile:(NSString*)filename
{
	return [[[self alloc] initWithFile:filename] autorelease];
}*/

+(id) spriteWithFile:(NSString*)filename rect:(CGRect)rect
{
	return [[[self alloc] initWithFile:filename rect:rect] autorelease];
}

/*+(id) spriteWithSpriteFrame:(CCSpriteFrame*)spriteFrame
{
	return [[[self alloc] initWithSpriteFrame:spriteFrame] autorelease];
}

+(id) spriteWithSpriteFrameName:(NSString*)spriteFrameName
{
	CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:spriteFrameName];
	
	NSAssert1(frame != nil, @"Invalid spriteFrameName: %@", spriteFrameName);
	return [self spriteWithSpriteFrame:frame];
}

+(id) spriteWithCGImage:(CGImageRef)image key:(NSString*)key
{
	return [[[self alloc] initWithCGImage:image key:key] autorelease];
}*/

@end
