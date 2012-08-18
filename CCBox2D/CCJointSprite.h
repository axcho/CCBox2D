//
//  CCJointSprite.h
//  CCBox2D
//
//  Created by Brent Gulanowski on 12-08-15.
//  Copyright (c) 2012 Marketcircle Inc. All rights reserved.
//

#import <Cocos2DKit/Cocos2DKit.h>

#import "CCBodySprite.h"


@interface CCJointSprite : CCSprite {
    CCBodySprite *_body1;
    CCBodySprite *_body2;
    CCWorldLayer *_world;
    BOOL _fixed;
}

@property (nonatomic, readonly) CCBodySprite *body1;
@property (nonatomic, readonly) CCBodySprite *body2;
@property (nonatomic, assign)   CCWorldLayer *world;
@property (nonatomic) BOOL fixed;

-(void) createJoint;
-(void) destroyJoint;

@end
