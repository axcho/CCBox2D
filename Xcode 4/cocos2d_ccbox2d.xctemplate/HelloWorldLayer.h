//
//  HelloWorldLayer.h
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// When you import this file, you import all the CCBox2D classes
#import "CCBox2D.h"


// HelloWorldLayer
@interface HelloWorldLayer : CCWorldLayer
{
	CCBodySprite *_lastBox;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

// adds a new sprite at a given coordinate
-(void) addNewSpriteWithCoords:(CGPoint)p;

@end
