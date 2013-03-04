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

#import "CCJointSprite.h"
#import "CCBox2DPrivate.h"

@interface CCJointSprite ()
@property (nonatomic) CCBodySprite* body1;
@property (nonatomic) CCBodySprite* body2;
@end

@implementation CCJointSprite

@synthesize fixed = _fixed;
@synthesize body1 = _body1;
@synthesize body2 = _body2;
@synthesize worldLayer = _worldLayer;
@synthesize world = _world;

#pragma mark - NSObject

-(void) dealloc
{
	[self destroyJoint];
	self.worldLayer = nil;
	self.world =  nil;
	self.body1 = nil;
	self.body2 = nil;
	[super dealloc];
}

#pragma mark - Accessors

-(void) setWorldLayer:(CCWorldLayer*)worldLayer
{
	if (_worldLayer != worldLayer)
	{
		_worldLayer = worldLayer;
		for (id child in self.children)
			if ([child respondsToSelector:@selector(setWorldLayer:)])
				[child setWorldLayer:worldLayer];
	}
}

#pragma mark - CCNode

-(void) onEnter
{
	[super onEnter];
	
	if ([self respondsToSelector:@selector(joint)])
	{
		if (self.joint)
			return;
	}
	
	if (!_worldLayer && [super.parent isKindOfClass:[CCWorldLayer class]])
		self.worldLayer = (CCWorldLayer*)super.parent;
	
	if (_world || _worldLayer)
		[self createJoint];
}

-(void) onExit
{
	[self destroyJoint];
	self.worldLayer = nil;
	self.world =nil;
	[super onExit];
}

#pragma mark - CCJointSprite

-(void) createJoint
{
}

-(void) destroyJoint
{
}

@end
