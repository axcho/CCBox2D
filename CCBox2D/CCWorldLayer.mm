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
#import "CCBodySprite.h"
#import "CCBox2DPrivate.h"
#import "Render.h"



const CGFloat PTMRatio = PTM_RATIO;
const CGFloat InvPTMRatio = 1.0f / PTM_RATIO;


ContactConduit::ContactConduit(id<ContactListenizer> listenizer)
{
	// save the physics listener
	listener = listenizer;
}

void ContactConduit::BeginContact(b2Contact* contact)
{
	// extract the physics sprites from the contact
    b2Fixture *fixtureA = contact->GetFixtureA();
    b2Fixture *fixtureB = contact->GetFixtureB();
	CCBodySprite *sprite1 = (CCBodySprite *)fixtureA->GetBody()->GetUserData();
	CCBodySprite *sprite2 = (CCBodySprite *)fixtureB->GetBody()->GetUserData();
	
	// notify the physics sprites
    ContactBlock startContact = sprite1.startContact;
    
    if(startContact) startContact(sprite2, (NSString *)fixtureA->GetUserData(), (NSString *)fixtureB->GetUserData());
    
    startContact = sprite2.startContact;
    if(startContact) startContact(sprite1, (NSString *)fixtureB->GetUserData(), (NSString *)fixtureA->GetUserData());
	
	// notify the physics listener
	[listener onOverlapBody:sprite1 andBody:sprite2];
}

void ContactConduit::EndContact(b2Contact* contact)
{
	// extract the physics sprites from the contact
    b2Fixture *fixtureA = contact->GetFixtureA();
    b2Fixture *fixtureB = contact->GetFixtureB();
	CCBodySprite *sprite1 = (CCBodySprite *)fixtureA->GetBody()->GetUserData();
	CCBodySprite *sprite2 = (CCBodySprite *)fixtureB->GetBody()->GetUserData();
	
	// notify the physics sprites
    ContactBlock endContact = sprite1.endContact;
    if(endContact) endContact(sprite2, (NSString *)fixtureA->GetUserData(), (NSString *)fixtureB->GetUserData());
    endContact = sprite2.endContact;
    if(endContact) endContact(sprite1, (NSString *)fixtureB->GetUserData(), (NSString *)fixtureA->GetUserData());
	
	// notify the physics listener;
	[listener onSeparateBody:sprite1 andBody:sprite2];
}

void ContactConduit::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse)
{
	// extract the physics sprites from the contact
    b2Fixture *fixtureA = contact->GetFixtureA();
    b2Fixture *fixtureB = contact->GetFixtureB();
	CCBodySprite *sprite1 = (CCBodySprite *)fixtureA->GetBody()->GetUserData();
	CCBodySprite *sprite2 = (CCBodySprite *)fixtureB->GetBody()->GetUserData();
	
	// get the forces involved
	float force = 0.0f;
	float frictionForce = 0.0f;
	
	// for each contact point
	for (int i = 0; i < b2_maxManifoldPoints; i++)
	{
		// add the impulse to the total force
		force += impulse->normalImpulses[i];
		frictionForce += impulse->tangentImpulses[i];
	}
	
	// adjust the force units
	force *= PTM_RATIO / GTKG_RATIO;
	frictionForce *= PTM_RATIO / GTKG_RATIO;
	
	// notify the physics sprites
    CollideBlock collision = sprite1.collision;
    if(collision) collision(sprite2, force, frictionForce);
    collision = sprite2.collision;
    if(collision) collision(sprite1, force, frictionForce);
	
	// notify the physics listener
	[listener onCollideBody:sprite1 andBody:sprite2 withForce:force withFrictionForce:frictionForce];
}

@implementation CCWorldLayer {
    b2World *_world;
	ContactConduit *_conduit;
    DebugDraw *_debugDraw;
}

@synthesize positionIterations = _positionIterations;
@synthesize velocityIterations = _velocityIterations;
@synthesize gravity = _gravity;

@dynamic debugDrawing;

+ (void)initialize {
    
}

- (b2World *)world {
    return _world;
}

- (void)setPosition:(CGPoint)position {
    CGPoint oldPosition = position_;
    [super setPosition:position];
    // apply the transformation delta to the b2World
    _world->ShiftOrigin(b2Vec2((oldPosition.x - position.x) * InvPTMRatio, (oldPosition.y - position.y) * InvPTMRatio));
}

-(void) setGravity:(CGPoint)newGravity
{
	_gravity = newGravity;
	
	// if world exists
	if (_world)
	{
		// set the world gravity
		_world->SetGravity(b2Vec2(_gravity.x * InvPTMRatio, _gravity.y * InvPTMRatio));
		
		// for each body in the world
		for (b2Body *body = _world->GetBodyList(); body; body = body->GetNext())
		{
			// wake up the body
			body->SetAwake(true);
		}
	}
}

- (BOOL)debugDrawing {
    return NULL != _debugDraw;
}

- (void)setDebugDrawing:(BOOL)debugDrawing {
    if(debugDrawing && !_debugDraw) {
        _debugDraw = new DebugDraw();
        _debugDraw->SetFlags(b2Draw::e_shapeBit|b2Draw::e_jointBit|b2Draw::e_aabbBit /*|b2Draw::e_centerOfMassBit*/);
        _world->SetDebugDraw(_debugDraw);
    }
    else if(!debugDrawing && _debugDraw) {
        _world->SetDebugDraw(NULL);
        delete _debugDraw, _debugDraw = NULL;
    }
}

-(id) init
{
	if ((self = [super init]))
	{
		// set up Box2D stuff for collisions
		_world = new b2World(b2Vec2());
		_conduit = new ContactConduit(self);
		_world->SetContactListener(_conduit);
		[self setGravity:CGPointZero];
		
		// set iterations
		_velocityIterations = 1;
		_positionIterations = 1;
		
		// update every frame
		[self scheduleUpdate];
	}
	return self;
}

-(void) update:(ccTime)delta
{
	// if world exists
	if (_world)
	{
		// update physics simulation
		_world->Step(delta, _velocityIterations, _positionIterations);
	}
}

- (void)draw {
    [super draw];
    glPushMatrix();
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_COLOR_ARRAY);
    glScalef(PTM_RATIO, PTM_RATIO, PTM_RATIO);
    glTranslatef(-position_.x * InvPTMRatio, -position_.y * InvPTMRatio, 0);
    _world->DrawDebugData();
    glEnableClientState(GL_COLOR_ARRAY);
    glEnable(GL_TEXTURE_2D);
    glPopMatrix();
    glFlush();
}

- (void) dealloc
{
	// delete Box2D stuff
	delete _conduit;
	delete _world;
    
    if(_debugDraw) delete _debugDraw;
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

-(void) onOverlapBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2
{
}

-(void) onSeparateBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2
{
}

-(void) onCollideBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2 withForce:(float)force withFrictionForce:(float)frictionForce;
{
}

@end
