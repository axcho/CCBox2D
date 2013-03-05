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
#import "Box2D.h"

@class CCBodySprite;

@interface CCShape : NSObject<NSCoding>

@property (nonatomic, assign) b2FixtureDef* fixtureDef;
@property (nonatomic, assign) b2Fixture* fixture;

@property (nonatomic, assign) id userData;

@property (nonatomic, assign) Float32 density;
@property (nonatomic, assign) Float32 friction;
@property (nonatomic, assign) Float32 restitution;
@property (nonatomic, assign) UInt16 collisionCategory;
@property (nonatomic, assign) UInt16 collisionMask;
@property (nonatomic, assign) SInt16 collisionGroup;
@property (nonatomic, assign, getter = isSensor) BOOL sensor;

@property (nonatomic, readonly) CGRect boundingBox;

//-(id) initWithShape:(b2Shape*)shape;
- (void)addFixtureToBody:(CCBodySprite*)body userData:(id)userData;
- (void)addFixtureToBody:(CCBodySprite*)body;
- (void)removeFixtureFromBody:(CCBodySprite*)body;

- (NSString*)shapeDescription;
+ (CCShape*)boxWithFixtureDef:(b2FixtureDef)fixtureDef;
+ (CCShape*)boxWithRect:(CGRect)rect;
+ (CCShape*)circleWithCenter:(CGPoint)center radius:(Float32)radius;
+ (CCShape*)polygonWithVertices:(CCArray*)shapeVertices;
+ (CCShape*)chainWithVertices:(CGPoint*)chainVertices count:(NSUInteger)count;
+ (CCShape*)edgeWithVec1:(b2Vec2 )vec1 vec2:(b2Vec2 )vec2;

// helpers
+ (CCShape*)polygonWithVecVertices:(b2Vec2*)vertices count:(int)count;

@end
