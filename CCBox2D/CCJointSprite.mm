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
@synthesize world = _world;

#pragma mark - NSObject
- (void)dealloc {
    self.world = nil;
    self.body1 = nil;
    self.body2 = nil;
    [super dealloc];
}


#pragma mark - Accessors
- (void)setWorld:(CCWorldLayer *)world {
    if(_world != world) {
        _world = world;
        for(id child in self.children)
            if([child respondsToSelector:@selector(setWorld:)])
                [child setWorld:world];
    }
}


#pragma mark - CCNode
-(void) onEnter {
	[super onEnter];
	
	if (self.joint)
		return;
	
	if (!_world && [super.parent isKindOfClass:[CCWorldLayer class]])
			self.world = (CCWorldLayer *)super.parent;
	
	if (_world)
		[self createJoint];
}

-(void) onExit {
	[super onExit];
    [self destroyJoint];
	self.world = nil;
}


#pragma mark - CCJointSprite
- (void)createJoint {}
- (void)destroyJoint {}

@end
