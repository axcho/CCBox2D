//
//  HelloWorldLayer.mm
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

// Import the interfaces
#import "HelloWorldLayer.h"


// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};

enum {
	kBoxCollisionType = 1,
	kWallCollisionType = 2
};

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		// enable touches
		self.isTouchEnabled = YES;
		
		// enable accelerometer
		self.isAccelerometerEnabled = YES;
		
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);
		
		// Define the gravity vector.
		self.gravity = ccp(0.0f, -320.0f);
		
		// Define the simulation accuracy
		self.velocityIterations = 8;
		self.positionIterations = 1;
		
		// Define the ground box.
		CCBodySprite* ground = [CCBodySprite node];
		ground.physicsType = kStatic;
		ground.collisionType = kWallCollisionType;
		ground.collidesWithType = kBoxCollisionType;
		[self addChild:ground];
		
		// Define the ground box shape.
		CCArray* bottom = [CCArray arrayWithCapacity:4];
		[bottom addObject:[NSValue valueWithCGPoint:ccp(0, 0)]];
		[bottom addObject:[NSValue valueWithCGPoint:ccp(screenSize.width, 0)]];
		[ground addPolygonWithName:@"bottom" withVertices:bottom];
		
		CCArray* top = [CCArray arrayWithCapacity:4];
		[top addObject:[NSValue valueWithCGPoint:ccp(0, screenSize.height)]];
		[top addObject:[NSValue valueWithCGPoint:ccp(screenSize.width, screenSize.height)]];
		[ground addPolygonWithName:@"top" withVertices:top];
		
		CCArray* left = [CCArray arrayWithCapacity:4];
		[left addObject:[NSValue valueWithCGPoint:ccp(0, screenSize.height)]];
		[left addObject:[NSValue valueWithCGPoint:ccp(0, 0)]];
		[ground addPolygonWithName:@"left" withVertices:left];
		
		CCArray* right = [CCArray arrayWithCapacity:4];
		[right addObject:[NSValue valueWithCGPoint:ccp(screenSize.width, screenSize.height)]];
		[right addObject:[NSValue valueWithCGPoint:ccp(screenSize.width, 0)]];
		[ground addPolygonWithName:@"right" withVertices:right];
		
		// Set up sprite
		_lastBox = nil;
		
		CCSpriteBatchNode *batch = [CCSpriteBatchNode batchNodeWithFile:@"blocks.png" capacity:150];
		[self addChild:batch z:0 tag:kTagBatchNode];
		
		[self addNewSpriteWithCoords:ccp(screenSize.width/2, screenSize.height/2)];
		
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Tap screen" fontName:@"Marker Felt" fontSize:32];
		[self addChild:label z:0];
		[label setColor:ccc3(0,0,255)];
		label.position = ccp( screenSize.width/2, screenSize.height-50);
	}
	return self;
}

-(void) addNewSpriteWithCoords:(CGPoint)p
{
	CCLOG(@"Add sprite %0.2f x %02.f",p.x,p.y);
	CCSpriteBatchNode *batch = (CCSpriteBatchNode*) [self getChildByTag:kTagBatchNode];
	
	//We have a 64x64 sprite sheet with 4 different 32x32 images.  The following code is
	//just randomly picking one of the images
	int idx = (CCRANDOM_0_1() > .5 ? 0:1);
	int idy = (CCRANDOM_0_1() > .5 ? 0:1);
	CCBodySprite *sprite = [CCBodySprite spriteWithBatchNode:batch rect:CGRectMake(32 * idx,32 * idy,32,32)];
	sprite.world = self;
	sprite.physicsType = kDynamic;
	sprite.collisionType = kBoxCollisionType;
	sprite.collidesWithType = kBoxCollisionType | kWallCollisionType;
	sprite.position = ccp(p.x, p.y);
	sprite.density = 1.0f;
	sprite.friction = 0.3f;
	[sprite addBoxWithName:@"box"];
	[batch addChild:sprite];
	
	// if another box exists
	if (_lastBox)
	{
		// add a spring between this and the last box!
		//CCSpringSprite *spring = [CCSpringSprite node];
		//[spring setBody:_lastBox andBody:sprite];
		//spring.length = 32;
		//[self addChild:spring];
		
		// or add a motor!
		//CCMotorSprite *motor = [CCMotorSprite spriteWithFile:@"Icon-Small.png"];
		//[motor setBody:_lastBox andBody:sprite];
		//motor.running = YES;
		//motor.speed = 100;
		//motor.power = 100;
		//[self addChild:motor];
	}
	
	// save this as the last box
	_lastBox = sprite;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
		
		[self addNewSpriteWithCoords: location];
	}
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0, prevY=0;
	
	//#define kFilterFactor 0.05f
#define kFilterFactor 1.0f	// don't use filter. the code is here just as an example
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	// accelerometer values are in "Portrait" mode. Change them to Landscape left
	// multiply the gravity by 10
	[self setGravity:CGPointMake(-accelY * 320, accelX * 320)];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

-(void) onOverlapBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2
{
	// check if two boxes have started to overlap
	if (sprite1.collisionType == kBoxCollisionType && sprite2.collisionType == kBoxCollisionType) {
		
		//CCLOG(@"Two boxes have overlapped. Cool.");
	}
}

-(void) onSeparateBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2
{
	// check if two boxes are no longer overlapping
	if (sprite1.collisionType == kBoxCollisionType && sprite2.collisionType == kBoxCollisionType) {
		
		//CCLOG(@"Two boxes stopped overlapping. That's okay too.");
	}
}

-(void) onCollideBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2 withForce:(float)force withFrictionForce:(float)frictionForce
{
	// check if two boxes have collided in the last update
	if (sprite1.collisionType == kBoxCollisionType && sprite2.collisionType == kBoxCollisionType) {
		
		//CCLOG(@"Two boxes have collided, yay!");
	}
}

@end
