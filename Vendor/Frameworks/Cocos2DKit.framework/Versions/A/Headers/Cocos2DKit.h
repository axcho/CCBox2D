//
//  Cocos2DKit.h
//  Cocos2DKit
//
//  Created by Brent Gulanowski on 12-05-04.
//  Copyright (c) 2012 Marketcircle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 
 #ifdef COCOS2DKIT
 #import <Cocos2DKit/CCSprite.h>
 #else

 #if ! defined (COCOS2DKIT)

 */

#define COCOS2DKIT

#if TARGET_OS_IPHONE
#import <Cocos2DKit/CCTouchDelegateProtocol.h>

#import <Cocos2DKit/glu.h>
#import <Cocos2DKit/ESRenderer.h>
#import <Cocos2DKit/EAGLView.h>
#import <Cocos2DKit/CCGL.h>

#elif TARGET_OS_MAC
#import <Cocos2DKit/MacGLView.h>
#endif

#import <Cocos2DKit/CCNS.h>

#import <Cocos2DKit/uthash.h>
#import <Cocos2DKit/ccTypes.h>
#import <Cocos2DKit/ccConfig.h>

#import <Cocos2DKit/CCTexture2D.h>

#import <Cocos2DKit/CCProtocols.h>

#import <Cocos2DKit/CCDirector.h>
#import <Cocos2DKit/CCDirectorIOS.h>

#import <Cocos2DKit/ccMacros.h>
#import <Cocos2DKit/ccCArray.h>
#import <Cocos2DKit/CCArray.h>
#import <Cocos2DKit/CGPointExtension.h>
#import <Cocos2DKit/TransformUtils.h>
#import <Cocos2DKit/ZipUtils.h>


#import <Cocos2DKit/CCAction.h>
#import <Cocos2DKit/CCActionInterval.h>
#import <Cocos2DKit/CCActionCamera.h>
#import <Cocos2DKit/CCActionEase.h>
#import <Cocos2DKit/CCActionGrid.h>
#import <Cocos2DKit/CCActionGrid3D.h>
#import <Cocos2DKit/CCActionInstant.h>
#import <Cocos2DKit/CCActionManager.h>
#import <Cocos2DKit/CCActionPageTurn3D.h>
#import <Cocos2DKit/CCActionProgressTimer.h>
#import <Cocos2DKit/CCActionTiledGrid.h>
#import <Cocos2DKit/CCActionTween.h>

#import <Cocos2DKit/CCAnimation.h>
#import <Cocos2DKit/CCAnimationCAche.h>
#import <Cocos2DKit/CCAtlasNode.h>
#import <Cocos2DKit/CCBlockSupport.h>
#import <Cocos2DKit/CCCamera.h>
#import <Cocos2DKit/CCConfiguration.h>
#import <Cocos2DKit/CCDrawingPrimitives.h>
#import <Cocos2DKit/CCGrabber.h>
#import <Cocos2DKit/CCGrid.h>
#import <Cocos2DKit/CCLabelAtlas.h>
#import <Cocos2DKit/CCLabelBMFont.h>
#import <Cocos2DKit/CCLabelTTF.h>
#import <Cocos2DKit/CCLayer.h>
#import <Cocos2DKit/CCMenu.h>
#import <Cocos2DKit/CCMenuItem.h>
#import <Cocos2DKit/CCMotionStreak.h>
#import <Cocos2DKit/CCNode.h>
#import <Cocos2DKit/CCParallaxNode.h>
#import <Cocos2DKit/CCParticleBatchNode.h>
#import <Cocos2DKit/CCParticleExamples.h>
#import <Cocos2DKit/CCParticleSystem.h>
#import <Cocos2DKit/CCParticleSystemPoint.h>
#import <Cocos2DKit/CCParticleSystemQuad.h>
#import <Cocos2DKit/CCProgressTimer.h>
#import <Cocos2DKit/CCRenderTexture.h>
#import <Cocos2DKit/CCRibbon.h>
#import <Cocos2DKit/CCScene.h>
#import <Cocos2DKit/CCScheduler.h>
#import <Cocos2DKit/CCSprite.h>
#import <Cocos2DKit/CCSpriteBatchNode.h>
#import <Cocos2DKit/CCSpriteFrame.h>
#import <Cocos2DKit/CCSpriteFrameCache.h>
#import <Cocos2DKit/CCTextureAtlas.h>
#import <Cocos2DKit/CCTextureCache.h>
#import <Cocos2DKit/CCTexturePVR.h>
#import <Cocos2DKit/CCTileMapAtlas.h>
#import <Cocos2DKit/CCTMXLayer.h>
#import <Cocos2DKit/CCTMXObjectGroup.h>
#import <Cocos2DKit/CCTMXTiledMap.h>
#import <Cocos2DKit/CCTMXXMLParser.h>
#import <Cocos2DKit/CCTransition.h>
#import <Cocos2DKit/CCTransitionPageTurn.h>
#import <Cocos2DKit/CCTransitionRadial.h>
#import <Cocos2DKit/CCTouchDispatcher.h>
#import <Cocos2DKit/CCTouchHandler.h>

#import <Cocos2DKit/FontLabel.h>
#import <Cocos2DKit/FontLabelStringDrawing.h>
#import <Cocos2DKit/FontManager.h>
#import <Cocos2DKit/ZAttributedString.h>
#import <Cocos2DKit/ZFont.h>


@interface Cocos2DKit : NSObject

@end
