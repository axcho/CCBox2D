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

#import "CCShape.h"
#import "CCBox2DPrivate.h"

NSString* StringForCircle(const b2CircleShape* circle)
{
	return [NSString stringWithFormat:@"Circle (c:%@, r:%.2f)", StringForVector(&circle->m_p), circle->m_radius];
}

NSString* StringForPolygon(const b2PolygonShape* polygon)
{
	return [NSString stringWithFormat:@"Polygon (c:%@, #:%d)", StringForVector(&polygon->m_centroid), polygon->m_count];
}

NSString* StringForEdge(const b2EdgeShape* edge)
{
	return [NSString stringWithFormat:@"Edge (A:%@, B:%@)", StringForVector(&edge->m_vertex1), StringForVector(&edge->m_vertex2)];
}

NSString* StringForChain(const b2ChainShape* chain)
{
	return [NSString stringWithFormat:@"Chain (S:%@, #:%d)", StringForVector(chain->m_vertices), chain->m_count];
}

static b2BlockAllocator* _allocator;

#pragma mark -

@implementation CCShape
{
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
@synthesize fixture = _fixture;
@synthesize fixtureDef = _fixtureDef;

#pragma mark - Private

-(id) initWithShape:(b2Shape*)shape
{
	self = [super init];
	if (self)
	{
		_fixtureDef = new b2FixtureDef();
		_fixtureDef->shape = shape;
		_fixtureDef->filter.categoryBits = 0xFFFF;
		_fixtureDef->filter.maskBits = 0xFFFF;
		_fixtureDef->density = 1.0f;
		_fixtureDef->friction = 0.3f;
		_fixtureDef->restitution = 0.8f;
	}
	return self;
}

#define THROW_MISSING_FIXTURE_EXCEPTION() [NSException raise:NSInternalInconsistencyException format:@"CCShape should have either a fixture or a fixtureDef at all times"]

-(id) userData
{
	if (_fixtureDef)
		return (id)_fixtureDef->userData;
	else if (_fixture)
		return (id)_fixture->GetUserData();
	else
		THROW_MISSING_FIXTURE_EXCEPTION();
	return nil;
}

-(void) setUserData:(id)userData
{
	if (_fixtureDef)
		_fixtureDef->userData = userData;
	else if (_fixture)
		_fixture->SetUserData(userData);
	else
		THROW_MISSING_FIXTURE_EXCEPTION();
}

-(Float32) density
{
	Float32 density;
	
	if (_fixtureDef)
		density = _fixtureDef->density;
	else if (_fixture)
		density = _fixture->GetDensity();
	else
		THROW_MISSING_FIXTURE_EXCEPTION();
	
	return density;
}

-(void) setDensity:(Float32)density
{
	if (_fixtureDef)
		_fixtureDef->density = density;
	else if (_fixture)
		_fixture->SetDensity(density);
	else
		THROW_MISSING_FIXTURE_EXCEPTION();
}

-(Float32) friction
{
	if (_fixtureDef)
		return _fixtureDef->friction;
	else if (_fixture)
		return _fixture->GetFriction();
	else
		THROW_MISSING_FIXTURE_EXCEPTION();
	return 0;
}

-(void) setFriction:(Float32)friction
{
	if (_fixtureDef)
		_fixtureDef->friction = friction;
	else if (_fixture)
		_fixture->SetFriction(friction);
	else
		THROW_MISSING_FIXTURE_EXCEPTION();
}

-(BOOL) isSensor
{
	if (_fixtureDef)
		return _fixtureDef->isSensor;
	else if (_fixture)
		return _fixture->IsSensor();
	else
		THROW_MISSING_FIXTURE_EXCEPTION();
	return NO;
}

-(void) setSensor:(BOOL)sensor
{
	if (_fixtureDef)
		_fixtureDef->isSensor = sensor;
	else if (_fixture)
		_fixture->SetSensor(sensor);
	else
		THROW_MISSING_FIXTURE_EXCEPTION();
}

-(UInt16) collisionCategory
{
	if (_fixtureDef)
		return _fixtureDef->filter.categoryBits;
	else if (_fixture)
		return _fixture->GetFilterData().categoryBits;
	else
		THROW_MISSING_FIXTURE_EXCEPTION();
	return 0;
}

-(void) setCollisionCategory:(UInt16)collisionCategory
{
	if (_fixtureDef)
		_fixtureDef->filter.categoryBits = collisionCategory;
	else if (_fixture)
	{
		b2Filter filter = _fixture->GetFilterData();
		filter.categoryBits = collisionCategory;
		_fixture->SetFilterData(filter);
	}
	else
		THROW_MISSING_FIXTURE_EXCEPTION();
}

-(UInt16) collisionMask
{
	if (_fixtureDef)
		return _fixtureDef->filter.maskBits;
	else if (_fixture)
		return _fixture->GetFilterData().maskBits;
	else
		THROW_MISSING_FIXTURE_EXCEPTION();
	return 0;
}

-(void) setCollisionMask:(UInt16)collisionMask
{
	if (_fixtureDef)
		_fixtureDef->filter.maskBits = collisionMask;
	else if (_fixture)
	{
		b2Filter filter = _fixture->GetFilterData();
		filter.maskBits = collisionMask;
		_fixture->SetFilterData(filter);
	}
	else
		THROW_MISSING_FIXTURE_EXCEPTION();
}

-(SInt16) collisionGroup
{
	if (_fixtureDef)
		return _fixtureDef->filter.groupIndex;
	else if (_fixture)
		return _fixture->GetFilterData().groupIndex;
	else
		THROW_MISSING_FIXTURE_EXCEPTION();
	return 0;
}

-(void) setCollisionGroup:(SInt16)collisionGroup
{
	if (_fixtureDef)
		_fixtureDef->filter.groupIndex = collisionGroup;
	else if (_fixture)
	{
		b2Filter filter = _fixture->GetFilterData();
		filter.groupIndex = collisionGroup;
		_fixture->SetFilterData(filter);
	}
	else
		THROW_MISSING_FIXTURE_EXCEPTION();
}

-(Float32) restitution
{
	if (_fixtureDef)
		return _fixtureDef->restitution;
	else if (_fixture)
		return _fixture->GetRestitution();
	else
		THROW_MISSING_FIXTURE_EXCEPTION();
	return 0;
}

-(void) setRestitution:(Float32)restitution
{
	if (_fixtureDef)
		_fixtureDef->restitution = restitution;
	else if (_fixture)
		_fixture->SetRestitution(restitution);
	else
		THROW_MISSING_FIXTURE_EXCEPTION();
}

-(CGRect) boundingBox
{
	const b2Shape* shape = _fixtureDef ? _fixtureDef->shape : _fixture->GetShape();
	b2AABB box;
	b2Transform transform;
	
	if (_fixture)
		transform = _fixture->GetBody()->GetTransform();
	else
		transform.SetIdentity();
	
	shape->ComputeAABB(&box, transform, 0);
	
	return CGRectMake(box.lowerBound.x * PTMRatio, box.lowerBound.y * PTMRatio, (box.upperBound.x - box.lowerBound.x) * PTMRatio, (box.upperBound.y - box.lowerBound.y) * PTMRatio);
}

#pragma mark - NSCoding

-(void) decodeCircleWithCoder:(NSKeyedUnarchiver*)aDecoder
{
	b2CircleShape* circle = new b2CircleShape();
	CGPoint position = [aDecoder decodeCGPointForKey:@"circle_position"];
	
	circle->m_p = b2Vec2(position.x, position.y);
	
	_fixtureDef->shape = circle;
}

-(void) decodeEdgeWithCoder:(NSKeyedUnarchiver*)aDecoder
{
	b2EdgeShape* edge = new b2EdgeShape();
	CGPoint point;
	
	if ([aDecoder decodeBoolForKey:@"has_vertex_0"])
	{
		edge->m_hasVertex0 = true;
		point = [aDecoder decodeCGPointForKey:@"edge_vertex_0"];
		edge->m_vertex0 = b2Vec2(point.x, point.y);
	}
	
	point = [aDecoder decodeCGPointForKey:@"edge_vertex_1"];
	edge->m_vertex1 = b2Vec2(point.x, point.y);
	point = [aDecoder decodeCGPointForKey:@"edge_vertex_2"];
	edge->m_vertex2 = b2Vec2(point.x, point.y);
	
	if ([aDecoder decodeBoolForKey:@"has_vertex_3"])
	{
		edge->m_hasVertex3 = true;
		point = [aDecoder decodeCGPointForKey:@"edge_vertex_3"];
		edge->m_vertex2 = b2Vec2(point.x, point.y);
	}
	
	_fixtureDef->shape = edge;
}

-(void) decodePolygonWithCoder:(NSKeyedUnarchiver*)aDecoder
{
	b2PolygonShape* polygon = new b2PolygonShape();

	int32 count = [aDecoder decodeInt32ForKey:@"polygon_count"];
	polygon->m_count = count;
	
	NSData* vertices = [aDecoder decodeObjectForKey:@"polygon_vertices"];
	polygon->Set((b2Vec2*)[vertices bytes], [aDecoder decodeInt32ForKey:@"polygon_count"]);
		
	_fixtureDef->shape = polygon;
}

-(void) decodeChainWithCoder:(NSKeyedUnarchiver*)aDecoder
{
	b2ChainShape* chain = new b2ChainShape();
	
	NSData* vertices = [aDecoder decodeObjectForKey:@"chain_vertices"];
	chain->CreateLoop((b2Vec2*)[vertices bytes], [aDecoder decodeInt32ForKey:@"chain_count"]);

	_fixtureDef->shape = chain;
}

-(void) decodeShapeWithCoder:(NSKeyedUnarchiver*)aDecoder
{
	b2Shape::Type type = _fixtureDef->shape->GetType();
	
	switch (type)
	{
		case b2Shape::e_circle:
			[self decodeCircleWithCoder:aDecoder];
			break;
			
		case b2Shape::e_edge:
			[self decodeEdgeWithCoder:aDecoder];
			break;
			
		case b2Shape::e_polygon:
			[self decodePolygonWithCoder:aDecoder];
			break;
			
		case b2Shape::e_chain:
			[self decodeChainWithCoder:aDecoder];
			break;
			
		default:
			break;
	}
}

-(id) initWithCoder:(NSKeyedUnarchiver*)aDecoder
{
	self = [super init];
	if (self)
	{
		[self decodeShapeWithCoder:aDecoder];
		_fixtureDef->density = [aDecoder decodeFloatForKey:@"density"];
		_fixtureDef->friction = [aDecoder decodeFloatForKey:@"friction"];
		_fixtureDef->restitution = [aDecoder decodeFloatForKey:@"restitution"];
		_fixtureDef->filter.groupIndex = [aDecoder decodeIntForKey:@"group"];
		_fixtureDef->filter.categoryBits = [aDecoder decodeIntForKey:@"category"];
		_fixtureDef->filter.maskBits = [aDecoder decodeIntForKey:@"mask"];
		_fixtureDef->isSensor = [aDecoder decodeBoolForKey:@"is_sensor"];
	}
	
	return self;
}

-(void) encodeCircle:(const b2CircleShape*)circle withCoder:(NSKeyedArchiver*)aCoder
{
	[aCoder encodeCGPoint:CGPointMake(circle->m_p.x, circle->m_p.y) forKey:@"circle_position"];
}

-(void) encodeEdge:(const b2EdgeShape*)edge withCoder:(NSKeyedArchiver*)aCoder
{
	if (edge->m_hasVertex0)
	{
		[aCoder encodeBool:YES forKey:@"has_vertex_0"];
		[aCoder encodeCGPoint:CGPointMake(edge->m_vertex0.x, edge->m_vertex0.y) forKey:@"edge_vertex_0"];
	}
	
	[aCoder encodeCGPoint:CGPointMake(edge->m_vertex1.x, edge->m_vertex1.y) forKey:@"edge_vertex_1"];
	[aCoder encodeCGPoint:CGPointMake(edge->m_vertex2.x, edge->m_vertex2.y) forKey:@"edge_vertex_2"];
	
	if (edge->m_hasVertex3)
	{
		[aCoder encodeBool:YES forKey:@"has_vertex_3"];
		[aCoder encodeCGPoint:CGPointMake(edge->m_vertex3.x, edge->m_vertex3.y) forKey:@"edge_vertex_3"];
	}
}

-(void) encodePolygon:(const b2PolygonShape*)polygon withCoder:(NSKeyedArchiver*)aCoder
{
	int32 count = polygon->m_count;
	
	[aCoder encodeInt32:count forKey:@"polygon_count"];
	[aCoder encodeObject:[NSData dataWithBytesNoCopy:(void*)polygon->m_vertices length:sizeof(b2Vec2)*count] forKey:@"polygon_vertices"];
	// We DON'T encode the normals or the centroid; they will be recalculated
	//[aCoder encodeObject:[NSData dataWithBytesNoCopy:polygon->m_normals length:sizeof(b2Vec2)*count] forKey:@"polygon_normals"];
	//[aCoder encodeCGPoint:CGPointMake(polygon->m_centroid.x, polygon->m_centroid.y) forKey:@"polygon_centroid"];
}

-(void) encodeChain:(const b2ChainShape*)chain withCoder:(NSKeyedArchiver*)aCoder
{
	[aCoder encodeObject:[NSData dataWithBytesNoCopy:chain->m_vertices length:chain->m_count * sizeof(b2Vec2)] forKey:@"chain_vertices"];
	[aCoder encodeInt32:chain->m_count forKey:@"chain_count"];
}

-(void) encodeShapeWithCoder:(NSKeyedArchiver*)aCoder
{
	const b2Shape* shape = _fixtureDef ? _fixtureDef->shape : _fixture->GetShape();
	b2Shape::Type type = shape->GetType();
	
	[aCoder encodeFloat:_fixtureDef->shape->m_radius forKey:@"shape_radius"];
	[aCoder encodeInt:type forKey:@"shape_type"];
	
	switch (type)
	{
		case b2Shape::e_chain:
			[self encodeChain:(b2ChainShape*)shape withCoder:aCoder];
			break;
			
		case b2Shape::e_edge:
			[self encodeEdge:(b2EdgeShape*)shape withCoder:aCoder];
			break;
			
		case b2Shape::e_circle:
			[self encodeCircle:(b2CircleShape*)shape withCoder:aCoder];
			break;
			
		case b2Shape::e_polygon:
			[self encodePolygon:(b2PolygonShape*)shape withCoder:aCoder];
			break;
			
		default:
			break;
	}
}

-(void) encodeWithCoder:(NSKeyedArchiver*)aCoder
{    
	[self encodeShapeWithCoder:aCoder];
	
	[aCoder encodeFloat:_fixtureDef->density forKey:@"density"];
	[aCoder encodeFloat:_fixtureDef->friction forKey:@"friction"];
	[aCoder encodeFloat:_fixtureDef->restitution forKey:@"restitution"];
	[aCoder encodeInt:_fixtureDef->filter.groupIndex forKey:@"group"];
	[aCoder encodeInt:_fixtureDef->filter.categoryBits forKey:@"category"];
	[aCoder encodeInt:_fixtureDef->filter.maskBits forKey:@"mask"];
	[aCoder encodeBool:_fixtureDef->isSensor forKey:@"is_sensor"];
}

#pragma mark - NSObject

-(void) dealloc
{
	self.userData = nil;
	[super dealloc];
}

+(void) initialize
{
	if (self == [CCShape class])
	{
		_allocator = new b2BlockAllocator();
	}
}

#pragma mark - CCShape

-(void) addFixtureToBody:(CCBodySprite*)body userData:(id)userData
{
	NSAssert1(_fixtureDef, @"Fixture already on a body; cannot add to new body %@", body);
	_fixtureDef->userData = userData;
	_fixture = body.body->CreateFixture(_fixtureDef);
	delete _fixtureDef->shape;
	delete _fixtureDef;
	_fixtureDef = NULL;
	body.body->ResetMassData();
}

-(void) addFixtureToBody:(CCBodySprite*)body
{
	[self addFixtureToBody:body userData:nil];
}

-(void) removeFixtureFromBody:(CCBodySprite*)body
{
	NSAssert1(_fixture, @"Fixture not set! Cannot remove from body %@", body);
	
	// Regenerate the fixture definition
	_fixtureDef = new b2FixtureDef();
	_fixtureDef->shape = _fixture->GetShape()->Clone(_allocator);
	_fixtureDef->density = _fixture->GetDensity();
	_fixtureDef->friction = _fixture->GetFriction();
	_fixtureDef->restitution = _fixture->GetRestitution();
	_fixtureDef->filter = _fixture->GetFilterData();
	_fixtureDef->isSensor = _fixture->IsSensor();
	
	body.body->DestroyFixture(_fixture);
	_fixture = NULL;
	body.body->ResetMassData();
}

-(NSString*) shapeDescription
{
	const b2Shape* shape;
	
	if (_fixture)
		shape = _fixture->GetShape();
	else
		shape = _fixtureDef->shape;
	
	switch (shape->GetType())
	{
		case b2Shape::e_circle:
			return StringForCircle((b2CircleShape*)shape);
		case b2Shape::e_polygon:
			return StringForPolygon((b2PolygonShape*)shape);
		case b2Shape::e_chain:
			return StringForChain((b2ChainShape*)shape);
		case b2Shape::e_edge:
			return StringForEdge((b2EdgeShape*)shape);
		default:
			break;
	}
	
	return nil;
}

+(CCShape*) boxWithFixtureDef:(b2FixtureDef)mFixtureDef
{
	CCShape* ccShape = [[self alloc] init];
	ccShape.fixtureDef = new b2FixtureDef(mFixtureDef);
	return [ccShape autorelease];
}

+(CCShape*) boxWithRect:(CGRect)rect
{
	b2PolygonShape* polygon = new b2PolygonShape();
	b2Vec2 center = b2Vec2(CGRectGetMidX(rect) * InvPTMRatio, CGRectGetMidY(rect) * InvPTMRatio);
	
	polygon->SetAsBox(rect.size.width * 0.5f * InvPTMRatio, rect.size.height * 0.5f * InvPTMRatio, center, 0);
	
	CCShape *ccShape = [[self alloc] initWithShape:polygon];
	
	return [ccShape autorelease];
}

+(CCShape*) circleWithCenter:(CGPoint)center radius:(Float32)radius
{
	b2CircleShape* circle = new b2CircleShape();
	
	circle->m_radius = radius * InvPTMRatio;
	circle->m_p = b2Vec2(center.x * InvPTMRatio, center.y * InvPTMRatio);
	
	return [[[self alloc] initWithShape:circle] autorelease];
}

+(CCShape*) polygonWithVertices:(CCArray*)shapeVertices
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
		vertices[i] = b2Vec2(point.x * InvPTMRatio, point.y * InvPTMRatio);
		
		// next vertex
		i++;
	}
	
	// create a polygon shape
	b2PolygonShape *polygonShape = new b2PolygonShape();
	
	polygonShape->Set(vertices, [shapeVertices count]);

	return [[[self alloc] initWithShape:polygonShape] autorelease];
}

+(CCShape*) polygonWithVecVertices:(b2Vec2*)vertices count:(int)count
{
	// create a polygon shape
	b2PolygonShape *polygonShape = new b2PolygonShape();
	polygonShape->Set(vertices, count);
	
	return [[[self alloc] initWithShape:polygonShape] autorelease];
}

+(CCShape*) chainWithVertices:(CGPoint*)chainVertices count:(NSUInteger)count
{
	b2ChainShape *chainShape = new b2ChainShape();
	b2Vec2 *vertices = new b2Vec2[count];
	
	for (NSUInteger i = 0; i < count; ++i)
	{
		vertices[i].x = InvPTMRatio * chainVertices[i].x;
		vertices[i].y = InvPTMRatio * chainVertices[i].y;
	}
	chainShape->CreateLoop(vertices, count);
	
	delete [] vertices;

	return [[[self alloc] initWithShape:chainShape] autorelease];
}

+(CCShape*) edgeWithVec1:(b2Vec2)vec1 vec2:(b2Vec2)vec2
{
	b2EdgeShape *edge = new b2EdgeShape();
	edge->Set(b2Vec2(vec1), b2Vec2(vec2));
	
	return [[[self alloc] initWithShape:edge] autorelease];
}

@end
