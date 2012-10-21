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
#import "CCShape.h"
#import "CCJointSprite.h"

#import "CCBox2DPrivate.h"


#pragma mark -
@implementation CCBodySprite {
    b2BodyDef *_bodyDef;
    b2Body *_body;
}

#pragma mark - Properties
@synthesize startContact=_startContact;
@synthesize endContact=_endContact;
@synthesize collision=_collision;
@synthesize world=_world;
@synthesize shapes=_shapes;
@synthesize surfaceVelocity = _surfaceVelocity;

@dynamic physicsType;
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
- (void)recursiveMarkTransformDirty {
    for(id node in self.children)
        if([node isKindOfClass:[CCBodySprite class]])
            [node recursiveMarkTransformDirty];
    _worldTransformDirty = YES;
}

- (CGAffineTransform)worldTransform {
    if(_worldTransformDirty) {
        
        CGAffineTransform t = [self nodeToParentTransform];
        
        for (CCNode *p = parent_; [p class] == [self class]; p = p->parent_)
            t = CGAffineTransformConcat(t, [p nodeToParentTransform]);
        
        _worldTransform = CGAffineTransformInvert(t);
        _worldTransformDirty = NO;
    }
    
    return _worldTransform;
}


#pragma mark - Accessors
- (b2Body *)body {
    return _body;
}

-(void) setPhysicsType:(PhysicsType)physicsType
{
	if (_body)
		_body->SetType((b2BodyType)physicsType);
    else
        _bodyDef->type = (b2BodyType)physicsType;
}

- (PhysicsType)physicsType {
    if(_body)
        return (PhysicsType) _body->GetType();
    else
        return (PhysicsType) _bodyDef->type;
}

- (BOOL)active {
    if(_body)
        return _body->IsActive();
    else
        return _bodyDef->active;
}

-(void) setActive:(BOOL)active
{
	if (_body)
		_body->SetActive(active);
    else
        _bodyDef->active = active;
}

- (BOOL)sleepy {
    if(_body)
        return _body->IsSleepingAllowed();
    else
        return _bodyDef->allowSleep;
}

-(void) setSleepy:(BOOL)sleep
{
	if (_body)
		_body->SetSleepingAllowed(sleep);
    else
        _bodyDef->allowSleep = sleep;
}

- (BOOL)awake {
    if(_body)
        return _body->IsAwake();
    else
        return _bodyDef->awake;
}

-(void)setAwake:(BOOL)awake
{
	if (_body)
		_body->SetAwake(awake);
	else
        _bodyDef->awake = awake;
}

- (BOOL)fixed {
    if(_body)
        return _body->IsFixedRotation();
    else
        return _bodyDef->fixedRotation;
}

-(void)setFixed:(BOOL)fixed
{
	if (_body)
		_body->SetFixedRotation(fixed);
    else
        _bodyDef->fixedRotation = fixed;
}

- (BOOL)bullet {
    if(_body)
        return _body->IsBullet();
    else
        return _bodyDef->bullet;
}

-(void) setBullet:(BOOL)bullet
{
	if (_body)
		_body->SetBullet(bullet);
    else
        _bodyDef->bullet = bullet;
}

-(void) setDamping:(Float32)damping
{
	if (_body)
		_body->SetLinearDamping(damping);
	else
        _bodyDef->linearDamping = damping;
}

-(void) setAngularDamping:(Float32)angularDamping
{
	if (_body)
		_body->SetAngularDamping(angularDamping);
	else
        _bodyDef->angularDamping = angularDamping;
}

-(void) setAngularVelocity:(Float32)angularVelocity
{
	if (_body)
		_body->SetAngularVelocity(CC_DEGREES_TO_RADIANS(-angularVelocity));
    else
        _bodyDef->angularVelocity = CC_DEGREES_TO_RADIANS(-angularVelocity);
}

-(void) setVelocity:(CGPoint)velocity
{
    b2Vec2 linearVelocity = b2Vec2(velocity.x * InvPTMRatio, velocity.y * InvPTMRatio);
    
	if (_body)
		_body->SetLinearVelocity(linearVelocity);
    else
        _bodyDef->linearVelocity = linearVelocity;
}

- (CGPoint)velocity {

    b2Vec2 linearVelocity;
    
    if(_body)
        linearVelocity = _body->GetLinearVelocity();
    else
        linearVelocity = _bodyDef->linearVelocity;
        
    CGPoint result;

    result.x = linearVelocity.x * PTMRatio;
    result.y = linearVelocity.y * PTMRatio;
    
    return result;
}

- (void)setWorld:(CCWorldLayer *)world {
    if(_world != world) {
        _world = world;
        for(id child in self.children)
            if([child respondsToSelector:@selector(setWorld:)])
                [child setWorld:world];
    }
}


#pragma mark - Dynamic Accessors
- (BOOL)isCreated {
    return NULL != _body;
}

- (Float32)mass {
    if(!_body) return 0;
    return _body->GetMass();
}

- (Float32)inertia {
    if(!_body) return 0;
    return _body->GetInertia();
}


#pragma mark - CCNode Accessors
-(void) setPosition:(CGPoint)newPosition
{
	super.position = newPosition;
    
//    NSLog(@"Set new sprite position: %@", NSStringFromCGPoint(newPosition));
	
	if (_body) {
        
        CGPoint worldPosition = newPosition;
        
        if([parent_ isKindOfClass:[CCBodySprite class]])
            worldPosition = CGPointApplyAffineTransform(newPosition, CGAffineTransformInvert([(CCBodySprite *)parent_ worldTransform]));
        
//        NSLog(@"Setting new body position: %@", NSStringFromCGPoint(worldPosition));
        
		_body->SetTransform(b2Vec2(worldPosition.x * InvPTMRatio, worldPosition.y * InvPTMRatio), _body->GetAngle());
	}
    
    [self recursiveMarkTransformDirty];
}

-(void) setRotation:(Float32)newRotation
{
	super.rotation = newRotation;
	
	if (_body)
		_body->SetTransform(_body->GetPosition(), CC_DEGREES_TO_RADIANS(-rotation_));
}


#pragma mark - Forces
-(void) applyForce:(CGPoint)force atLocation:(CGPoint)location asImpulse:(BOOL)impulse
{
	if (_body) {
        
		// get force and location in world coordinates
		b2Vec2 b2Force(force.x * InvPTMRatio * GTKG_RATIO, force.y * InvPTMRatio * GTKG_RATIO);
		b2Vec2 b2Location(location.x * InvPTMRatio, location.y * InvPTMRatio);
		
		if (impulse)
			_body->ApplyLinearImpulse(b2Force, b2Location);
		else
			_body->ApplyForce(b2Force, b2Location);
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
	[self applyForce:force atLocation:ccp(center.x * PTMRatio, center.y * PTMRatio) asImpulse:impulse];
}

-(void) applyForce:(CGPoint)force
{
	[self applyForce:force asImpulse:NO];
}

-(void) applyTorque:(Float32)torque asImpulse:(BOOL)impulse
{
	if (_body)
		if (impulse)
			_body->ApplyAngularImpulse(torque * GTKG_RATIO);
		else
			_body->ApplyTorque(torque * GTKG_RATIO);
}

-(void) applyTorque:(Float32)torque
{
	[self applyTorque:torque asImpulse:NO];
}


#pragma mark - Shapes
- (CCShape *)shapeNamed:(NSString *)name {
    return [_shapes objectForKey:name];
}

- (void)addShape:(CCShape *)shape named:(NSString *)name {
    
    CCShape *oldShape = [_shapes objectForKey:name];

	if (_body) {
        if(oldShape)
            [oldShape removeFixtureFromBody:self];
		[shape addFixtureToBody:self];
	}
    
    [_shapes setObject:shape forKey:name];
}

-(void) removeShapeNamed:(NSString *)name {
    
    CCShape *shape = [_shapes objectForKey:name];
    
    if(!shape) return;
    
    if(_body)
        [shape removeFixtureFromBody:self];
    
    [_shapes removeObjectForKey:name];
}

-(void) removeShapes {
    for(NSString *name in [_shapes allKeys])
        [self removeShapeNamed:name];
}

-(void) addedToJoint:(CCJointSprite *)sprite
{
	if (!_body) {
		if (!_joints)
			_joints = [[CCArray array] retain];
		
		[_joints addObject:sprite];
	}
	else
		[sprite onEnter];
}

- (NSString *)shapeDescription {
    
    NSMutableArray *strings = [NSMutableArray array];
    
    for(NSString *name in _shapes) {
        [strings addObject:[NSString stringWithFormat:@"%@: %@", name, [[_shapes objectForKey:name] shapeDescription]]];
    }
    for(CCNode *node in self.children) {
        if([node isKindOfClass:[CCBodySprite class]]) {
            [strings addObject:[(CCBodySprite *)node shapeDescription]];
        }
    }

    return [strings componentsJoinedByString:@", "];
}

- (CGPoint)physicsPosition {
    
    b2Vec2 vec;
        
    if(_body)
        vec = _body->GetPosition();
    else
        vec = _bodyDef->position;
    
    return CGPointMake(vec.x, vec.y);
}

#pragma mark - Body Management
-(void) destroyBody
{
	if (_body) {
        
		// for each attached joint
		b2JointEdge *nextJoint;
		for (b2JointEdge *joint = _body->GetJointList(); joint; joint = nextJoint)
		{
			// get the next joint ahead of time to avoid a bad pointer when joint is destroyed
			nextJoint = joint->next;
			
			// get the joint sprite
			CCJointSprite *sprite = (CCJointSprite *)(joint->joint->GetUserData());
			
			if (sprite)
				[sprite removeFromParentAndCleanup:YES];
		}
		
		// destroy the body
		_body->GetWorld()->DestroyBody(_body);
		_body = NULL;
        _bodyDef = new b2BodyDef();
        
        [self removeShapes];
	}
}

-(void) createBody
{
    if (_world.world)
    {
        if (_body)
            [self destroyBody];
        
        CGPoint position = position_;
        
        if([parent_ isKindOfClass:[CCBodySprite class]])
            position = CGPointApplyAffineTransform(position_, CGAffineTransformInvert([(CCBodySprite *)parent_ worldTransform]));
        
        _bodyDef->position = b2Vec2(position.x * InvPTMRatio, position.y * InvPTMRatio);
        _body = _world.world->CreateBody(_bodyDef);
        delete _bodyDef;
        _bodyDef = NULL;
        
        _body->SetUserData(self);
        
        for (NSString *key in [_shapes allKeys])
            [[_shapes objectForKey:key] addFixtureToBody:self userData:key];
        
        for (CCSprite *sprite in _joints)
            if (sprite.parent) [sprite onEnter];
        
        [self scheduleUpdate];
    }
}


#pragma mark - NSObject
- (void) dealloc {
	[self destroyBody];
    [_joints release], _joints = nil;
    [_shapes release], _shapes = nil;
    self.startContact = nil;
    self.endContact = nil;
    self.collision = nil;
	[super dealloc];
}

-(id) init
{
	if ((self = [super init]))
	{
        _bodyDef = new b2BodyDef();
        
        _bodyDef->type = b2_dynamicBody;
        _bodyDef->awake = YES;
        _bodyDef->allowSleep = YES;
        _bodyDef->userData = self;

        _wasActive = _bodyDef->active = YES;

		_shapes = [[NSMutableDictionary alloc] init];
	}
	return self;
}


#pragma mark - Updating
-(void) update:(ccTime)delta
{
	if(!_body)
        return;
    
    BOOL active = _body->IsActive();
    
    if(!active && !_wasActive)
        return;
    

    b2Vec2 newBodyPos = _body->GetPosition();
    CGPoint position = ccp(newBodyPos.x * PTMRatio, newBodyPos.y * PTMRatio);
    
    if([parent_ isKindOfClass:[CCBodySprite class]])
        position = CGPointApplyAffineTransform(position, [(CCBodySprite *)parent_ worldTransform]);
    
    if(!CGPointEqualToPoint(position, position_)) {
        [super setPosition:position];
        [self recursiveMarkTransformDirty];
    }
    
    [super setRotation:CC_RADIANS_TO_DEGREES(-_body->GetAngle())];
    
    _wasActive = active;
}


#pragma mark - CCNode
-(void) onEnter {
	[super onEnter];
	
	if (_body)
		return;
	
	if (!_world && [parent_ isKindOfClass:[CCWorldLayer class]])
        self.world = (CCWorldLayer *)parent_;
	
	if (_world)
		[self createBody];
}

-(void) onExit {
    [self destroyBody];
	self.world = nil;
	[super onExit];
}

@end
