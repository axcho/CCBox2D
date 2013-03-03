//
//  CCJointSprite.m
//  CCBox2D
//
//  Created by Brent Gulanowski on 12-08-15.
//  Copyright (c) 2012 Marketcircle Inc. All rights reserved.
//

#import "CCJointSprite.h"

#import "CCBox2DPrivate.h"


@interface CCJointSprite ()
@property (nonatomic) CCBodySprite *body1;
@property (nonatomic) CCBodySprite *body2;
@end


@implementation CCJointSprite

@synthesize fixed = _fixed;
@synthesize body1 = _body1;
@synthesize body2 = _body2;
@synthesize worldLayer = _worldLayer;
@synthesize world = _world;

#pragma mark - NSObject
- (void)dealloc {
    [self destroyJoint];
    self.worldLayer = nil;
    self.world =  nil;
    self.body1 = nil;
    self.body2 = nil;
    [super dealloc];
}


#pragma mark - Accessors
- (void)setWorldLayer:(CCWorldLayer *)worldLayer {
    if(_worldLayer != worldLayer) {
        _worldLayer = worldLayer;
        for(id child in self.children)
            if([child respondsToSelector:@selector(setWorldLayer:)])
                [child setWorldLayer:worldLayer];
    }
}


#pragma mark - CCNode
-(void) onEnter {
	[super onEnter];
	
	if ([self respondsToSelector:@selector(joint)]){
        if (self.joint) {
            return;
        }
    }

	
	if (!_worldLayer && [super.parent isKindOfClass:[CCWorldLayer class]])
			self.worldLayer = (CCWorldLayer *)super.parent;
	
	if (_world || _worldLayer)
		[self createJoint];
}

-(void) onExit {
    [self destroyJoint];
	self.worldLayer = nil;
    self.world =nil;
	[super onExit];
}


#pragma mark - CCJointSprite
- (void)createJoint {}
- (void)destroyJoint {}

@end
