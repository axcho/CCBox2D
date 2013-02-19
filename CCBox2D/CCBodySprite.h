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

#import "cocos2d.h"


@class CCWorldLayer;
@protocol CCJointSprite;

typedef enum
{
	kStatic,
	kKinematic,
	kDynamic
} PhysicsType;

@interface CCBodySprite : CCSprite
{
	PhysicsType _physicsType;
	unsigned short _collisionType, _collidesWithType;
	BOOL _active, _sleepy, _awake, _solid, _fixed, _bullet;
	float _density, _friction, _bounce;
	float _damping, _angularDamping;
	float _angularVelocity;
	CGPoint _velocity;
	CCArray *_joints;
	CCWorldLayer *_world;
	
	NSMutableDictionary *_shapes;
	NSMutableDictionary *_shapeData;
}

@property (nonatomic) PhysicsType physicsType;
@property (nonatomic) unsigned short collisionType;
@property (nonatomic) unsigned short collidesWithType;
@property (nonatomic) BOOL active;
@property (nonatomic) BOOL sleepy;
@property (nonatomic) BOOL awake;
@property (nonatomic) BOOL solid;
@property (nonatomic) BOOL fixed;
@property (nonatomic) BOOL bullet;
@property (nonatomic) float density;
@property (nonatomic) float friction;
@property (nonatomic) float bounce;
@property (nonatomic) float damping;
@property (nonatomic) float angularDamping;
@property (nonatomic) float angularVelocity;
@property (nonatomic) CGPoint velocity;
@property (nonatomic, assign) CCWorldLayer *world;

-(void) setDensity:(float)newDensity forShape:(NSString *)shapeName;
-(void) setFriction:(float)newFriction forShape:(NSString *)shapeName;
-(void) setBounce:(float)newBounce forShape:(NSString *)shapeName;

-(void) applyForce:(CGPoint)force atLocation:(CGPoint)location asImpulse:(BOOL)impulse;
-(void) applyForce:(CGPoint)force atLocation:(CGPoint)location;
-(void) applyForce:(CGPoint)force asImpulse:(BOOL)impulse;
-(void) applyForce:(CGPoint)force;
-(void) applyTorque:(float)torque asImpulse:(BOOL)impulse;
-(void) applyTorque:(float)torque;

-(void) addBoxWithName:(NSString *)shapeName ofSize:(CGSize)shapeSize atLocation:(CGPoint)shapeLocation;
-(void) addBoxWithName:(NSString *)shapeName ofSize:(CGSize)shapeSize;
-(void) addBoxWithName:(NSString *)shapeName;

-(void) addCircleWithName:(NSString *)shapeName ofRadius:(float)shapeRadius atLocation:(CGPoint)shapeLocation;
-(void) addCircleWithName:(NSString *)shapeName ofRadius:(float)shapeRadius;
-(void) addCircleWithName:(NSString *)shapeName;

-(void) addPolygonWithName:(NSString *)shapeName withVertices:(CCArray *)shapeVertices;

-(void) addChainWithName:(NSString *)shapeName withVertices:(CGPoint *)chainVertices count:(NSUInteger)count;

-(void) removeShapeWithName:(NSString *)shapeName;
-(void) removeShapes;

-(void) addedToJoint:(CCSprite<CCJointSprite> *)sprite;

-(void) update:(ccTime)delta;

-(void) onOverlapBody:(CCBodySprite *)sprite;
-(void) onSeparateBody:(CCBodySprite *)sprite;
-(void) onCollideBody:(CCBodySprite *)sprite withForce:(float)force withFrictionForce:(float)frictionForce;

@end
