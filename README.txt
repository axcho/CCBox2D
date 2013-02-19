ABOUT

CCBox2D is a cocos2d-flavored wrapper for Box2D, written by axcho on behalf of Fugazo, Inc.

In other words, *actual* integrated Box2D support for cocos2d, for the first time ever. Yay, easy physics! :D

The classes I've added are CCBodySprite, CCMotorSprite, CCSpringSprite, and CCWorldLayer. These make up CCBox2D. The rest are not mine and I don't mean to claim them as such. I include them here only so that you can easily test out CCBox2D and understand how it works in a sample project.

The files HelloWorldLayer.h and HelloWorldLayer.mm are modified versions of the originals in the "cocos2d Box2D Application" template, rewritten to use my CCBox2D wrapper instead of straight, unfiltered Box2D.

FEATURES

CCBox2D makes it easy to use rigid bodies, springs, and motors in your cocos2d applications for iOS. It takes the powerful but complicated functionality of the Box2D physics engine, and wraps it all up inside familiar cocos2d objects.

CCBodySprite wraps a Box2D b2Body in a cocos2d CCSprite.
CCMotorSprite wraps a Box2D b2RevoluteJoint in a cocos2d CCSprite.
CCSpringSprite wraps a Box2D b2DistanceJoint in a cocos2d CCSprite.
CCWorldLayer wraps a Box2D b2World in a cocos2d CCLayer.

This is enough to make a passable Angry Birds clone, or a game with all the ropes and ragdolls and vehicles you could possibly want.

For compatibility with cocos2d, CCBox2D uses pixels (or points) instead of meters, and degrees instead of radians, unlike Box2D. For example, motor speed is measured in degrees per second, rather than radians per second.

CCBox2D also measures mass in grams, instead of kilograms like Box2D, to compensate for pixels being smaller than meters. For example, motor torque is measured in grams times pixels squared over seconds squared, rather than in kilograms times meters squared over seconds squared (newton meters).

GETTING STARTED

If you just want the CCBox2D code, you can find it in the "CCBox2D" folder.

If you want to see how CCBox2D works in an actual sample project, you can try out the included Xcode project templates. The instructions for getting that to work depends on which version of Xcode you have.

If you don't have Xcode at all, you can download it here for free:
http://developer.apple.com/xcode/





NOTES

Keep in mind that when you create a new class that inherits from one of the CCBox2D classes, you are creating an Objective-C++ class, and so the .m extension must instead be a .mm extension. If you don't, you will get all sorts of errors.

Also, I apologize for the lack of documentation with CCBox2D! If there's enough interest I might take the time to put some sort of API reference together.

For now, look at the .h files and example project. If you really need to know more about the physics involved, I reluctantly refer you to the Box2D manual:
http://www.box2d.org/manual.html

Because the whole point of CCBox2D is to smooth over all the tricky concepts and techniques discussed in the Box2D manual, reading it may just confuse you more. Sadly that's all I can offer so far.

But still, if enough people are interested, who knows what could happen! :)




This will get your project up and running with pods.

Just create a Podfile in your existing project and include the following


Podfile
=======================
platform :ios, '5.0'

# Using the Default
pod 'box2d'
pod 'cocos2d'
pod 'CCBox2D' , :podspec => 'https://raw.github.com/jdp-global/CCBox2D/master/CCBox2d.podspec'



run pod install from terminal. 




CREDITS

Hi, I'm axcho.
http://axcho.com/

I wrote the code for CCBox2D:
https://github.com/axcho/CCBox2D

I wrote CCBox2D as an employee of Fugazo, Inc.
My boss let me share it with everyone for free! Cool!
http://www.fugazo.com/

Erin Catto wrote the code for Box2D:
http://www.box2d.org/

Ricardo Quesada wrote the code for cocos2d-iPhone:
http://www.cocos2d-iphone.org/

Visit our websites!!! :D

LICENSE

I copied this license from Box2D! Hope it works.

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

Anyway, enjoy! :)