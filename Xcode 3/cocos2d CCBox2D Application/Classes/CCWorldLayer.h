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
#import "cocos2d.h"

#define PTM_RATIO 32


@class CCBodySprite;

@protocol ContactListenizer

-(void) onOverlapBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2;
-(void) onSeparateBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2;
-(void) onCollideBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2 withForce:(float)force withFrictionForce:(float)frictionForce;

@end

class ContactConduit : public b2ContactListener
{
public:
    ContactConduit(id<ContactListenizer> listenizer);
    
	virtual void BeginContact(b2Contact* contact);
	virtual void EndContact(b2Contact* contact);
	virtual void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
	
	id<ContactListenizer> listener;
};

@interface CCWorldLayer : CCLayer <ContactListenizer>
{
	int _positionIterations, _velocityIterations;
	CGPoint _gravity;
	b2World *_world;
	
	ContactConduit *_conduit;
}

@property (nonatomic) int positionIterations;
@property (nonatomic) int velocityIterations;
@property (nonatomic) CGPoint gravity;
@property (nonatomic, readonly) b2World *world;

-(void) onOverlapBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2;
-(void) onSeparateBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2;
-(void) onCollideBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2 withForce:(float)force withFrictionForce:(float)frictionForce;

@end

@protocol CCJointSprite

@property (nonatomic) BOOL fixed;
@property (nonatomic, readonly) b2Joint *joint;
@property (nonatomic, readonly) CCBodySprite *body1;
@property (nonatomic, readonly) CCBodySprite *body2;
@property (nonatomic, assign) CCWorldLayer *world;

@end
