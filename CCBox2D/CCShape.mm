//
//  CCShape.m
//  CCBox2D
//
//  Created by Brent Gulanowski on 12-07-12.
//  Copyright (c) 2012 Marketcircle Inc. All rights reserved.
//

#import "CCShape.h"

#import "CCBox2DPrivate.h"


#pragma mark -
@implementation CCShape {
    b2FixtureDef *_fixtureDef;
    b2Fixture *_fixture;
}


#pragma mark - Properties

@dynamic userData;
@dynamic density;
@dynamic friction;
@dynamic restitution;
@dynamic sensor;
@dynamic collisionCategory;
@dynamic collisionMask;
@dynamic collisionGroup;


#pragma mark - Private
- (id)initWithShape:(b2Shape *)shape {
    self = [super init];
    if(self) {
        _fixtureDef = new b2FixtureDef();
        _fixtureDef->shape = shape;
        _fixtureDef->filter.categoryBits = 0xFFFF;
        _fixtureDef->filter.maskBits = 0xFFFF;
        _fixtureDef->density = 1.0f;
        _fixtureDef->friction = 0.3f;
        _fixtureDef->restitution = 0.2f;
    }
    return self;
}


#pragma mark - Accessors
- (b2Fixture *)fixture {
    return _fixture;
}

- (id)userData {
    return (id)_fixtureDef->userData;
}

- (void)setUserData:(id)userData {
    _fixtureDef->userData = userData;
}

- (Float32)density {
    const static Float32 conversionFactor = InvPTMRatio * InvPTMRatio * GTKG_RATIO;
    return conversionFactor * _fixtureDef->density;
}

- (void)setDensity:(Float32)density {
    const static Float32 conversionFactor = PTM_RATIO * PTM_RATIO / GTKG_RATIO;
    _fixtureDef->density = density * conversionFactor;
}

- (Float32)friction {
    return _fixtureDef->friction;
}

- (void)setFriction:(Float32)friction {
    _fixtureDef->friction = friction;
}

- (BOOL)isSensor {
    return _fixtureDef->isSensor;
}

- (void)setSensor:(BOOL)sensor {
    _fixtureDef->isSensor = sensor;
}

-(UInt16)collisionCategory {
    return _fixtureDef->filter.categoryBits;
}

- (void)setCollisionCategory:(UInt16)collisionCategory {
    _fixtureDef->filter.categoryBits = collisionCategory;
}

- (UInt16)collisionMask {
    return _fixtureDef->filter.maskBits;
}

- (void)setCollisionMask:(UInt16)collisionMask {
    _fixtureDef->filter.maskBits = collisionMask;
}

- (SInt16)collisionGroup {
    return _fixtureDef->filter.groupIndex;
}

-(void)setCollisionGroup:(SInt16)collisionGroup {
    _fixtureDef->filter.groupIndex = collisionGroup;
}


#pragma mark - CCShape
- (void)addFixtureToBody:(CCBodySprite *)body {
    NSAssert1(_fixtureDef, @"Fixture already on a body; cannot add to new body %@", body);
    body.body->CreateFixture(_fixtureDef);
    delete _fixtureDef->shape;
    delete _fixtureDef;
    _fixtureDef = NULL;
}

- (void)removeFixtureFromBody:(CCBodySprite *)body {
    NSAssert1(_fixture, @"Fixture not set! Cannot remove from body %@", body);
    body.body->DestroyFixture(_fixture);
    _fixture = NULL;
}

+ (CCShape *)boxWithRect:(CGRect)rect {
    
    b2PolygonShape *polygon = new b2PolygonShape();
    b2Vec2 center = b2Vec2(CGRectGetMidX(rect)*InvPTMRatio, CGRectGetMidY(rect)*InvPTMRatio);
    
    // TODO: add angle support
    polygon->SetAsBox(rect.size.width*0.5f*InvPTMRatio, rect.size.height*0.5f*InvPTMRatio, center, 0);
    
    CCShape *ccShape = [[self alloc] initWithShape:polygon];
    
    return [ccShape autorelease];
}

+ (CCShape *)circleWithCenter:(CGPoint)center radius:(Float32)radius {
    
    b2CircleShape *circle = new b2CircleShape();
    
    circle->m_radius = radius * InvPTMRatio;
    circle->m_p = b2Vec2(center.x*InvPTMRatio, center.y*InvPTMRatio);
    
    return [[[self alloc] initWithShape:circle] autorelease];
}

+ (CCShape *)polygonWithVertices:(CCArray *)shapeVertices {
    
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
		vertices[i] = b2Vec2(point.x * InvPTMRatio, point.y * InvPTMRatio);
		
		// next vertex
		i++;
	}
	
	// create a polygon shape
	b2PolygonShape *polygonShape = new b2PolygonShape();
    
	polygonShape->Set(vertices, [shapeVertices count]);

    return [[[self alloc] initWithShape:polygonShape] autorelease];
}

+ (CCShape *)chainWithVertices:(CGPoint *)chainVertices count:(NSUInteger)count {
    
    b2ChainShape *chainShape = new b2ChainShape();
    
    chainShape->CreateLoop((b2Vec2 *)chainVertices, count);

    return [[[self alloc] initWithShape:chainShape] autorelease];
}

@end
