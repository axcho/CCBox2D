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

#ifndef CCBox2D_CCBox2DPrivate_h
#define CCBox2D_CCBox2DPrivate_h

#import <Box2D/Box2D.h>

#import "CCShape.h"
#import "CCBodySprite.h"
#import "CCWorldLayer.h"
#import "CCJointSprite.h"

extern CGFloat PTMRatio;
extern CGFloat InvPTMRatio;

static inline NSString* StringForVector(const b2Vec2* vector)
{
	return [NSString stringWithFormat:@"{%.2f, %.2f}", vector->x, vector->y];
}

extern NSString *StringForCircle(const b2CircleShape* circle);
extern NSString *StringForPolygon(const b2PolygonShape* polygon);
extern NSString *StringForEdge(const b2EdgeShape* edge);
extern NSString *StringForChain(const b2ChainShape* chain);

@interface CCBodySprite (CCBox2DPrivate)
@property (nonatomic, readonly) b2Body* body;
-(CGAffineTransform) worldTransform;
-(void) recursiveMarkTransformDirty;
@end

@interface CCJointSprite (CCBox2DPrivate)
@property (nonatomic, readonly) b2Joint* joint;
@end

@interface CCWorldLayer (CCBox2DPrivate)
@property (nonatomic, readonly) b2World* world;
@end

class ContactConduit : public b2ContactListener
{
public:
	ContactConduit(id<ContactListenizer> listenizer);
	
	virtual void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
	virtual void BeginContact(b2Contact* contact);
	virtual void EndContact(b2Contact* contact);
	virtual void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
	
	id<ContactListenizer> listener;
};

typedef BOOL (^QueryBlock)(b2Fixture *fixture);

class QueryCallback : public b2QueryCallback
{
public:
	QueryCallback(QueryBlock block)
	{
		queryBlock = [block copy];
	}
	
	~QueryCallback()
	{
		[queryBlock release];
		queryBlock = nil;
	}
	
	bool ReportFixture(b2Fixture *fixture);
	
private:
	QueryBlock queryBlock;
};

#endif
