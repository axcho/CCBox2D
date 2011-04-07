//
//  AppDelegate.h
//  CCBox2dPE
//
//  Created by Andreas Low on 07.04.11.
//  Copyright codeandweb.de 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
