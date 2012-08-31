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

#import <Cocos2DKit/Cocos2DKit.h>


@class CCBodySprite, CCJointSprite, CCShape, CCWorldLayer;

typedef enum
{
	kStatic = 0,
	kKinematic,
	kDynamic
} PhysicsType;


typedef void (^ContactBlock)(CCBodySprite *other, NSString *shapeName, NSString *otherShapeName);
typedef void (^CollideBlock)(CCBodySprite *other, Float32 force, Float32 friction);



@interface CCBodySprite : CCSprite
{
	CCArray *_joints;
	CCWorldLayer *_world;
	
	NSMutableDictionary *_shapes;
    
    ContactBlock _startContact;
    ContactBlock _endContact;
    CollideBlock _collision;
    
    BOOL _wasActive;
}

@property (nonatomic) PhysicsType physicsType;

@property (nonatomic) BOOL active;
@property (nonatomic) BOOL sleepy;
@property (nonatomic) BOOL awake;
@property (nonatomic) BOOL fixed;
@property (nonatomic) BOOL bullet;
@property (nonatomic) float damping;
@property (nonatomic) float angularDamping;
@property (nonatomic) float angularVelocity;
@property (nonatomic) CGPoint velocity;

@property (nonatomic, readonly, copy) NSDictionary *shapes;

// -setWorld: recursively sets the world on any body or joint children
@property (nonatomic, assign) CCWorldLayer *world;

@property (nonatomic, copy) ContactBlock startContact;
@property (nonatomic, copy) ContactBlock endContact;
@property (nonatomic, copy) CollideBlock collision;


-(void) applyForce:(CGPoint)force atLocation:(CGPoint)location asImpulse:(BOOL)impulse;
-(void) applyForce:(CGPoint)force atLocation:(CGPoint)location;
-(void) applyForce:(CGPoint)force asImpulse:(BOOL)impulse;
-(void) applyForce:(CGPoint)force;
-(void) applyTorque:(float)torque asImpulse:(BOOL)impulse;
-(void) applyTorque:(float)torque;

- (CCShape *)shapeNamed:(NSString *)name;
- (void)addShape:(CCShape *)shape named:(NSString *)name;
-(void) removeShapeNamed:(NSString *)name;
-(void) removeShapes;

-(void) addedToJoint:(CCJointSprite *)sprite;

-(void) update:(ccTime)delta;

@end
