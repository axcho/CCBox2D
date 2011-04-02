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

For compatibility with cocos2d, CCBox2D uses pixels (or points) instead of meters, and degrees instead of radians, unlike Box2D. For example, motor speed is measured in degrees per second, rather than radians per second. Motor torque is measured in kilograms times pixels squared per seconds squared, rather than in newton meters.

GETTING STARTED

If you just want the CCBox2D code, you can find it in the "CCBox2D" folder.

If you want to see how CCBox2D works in an actual sample project, you can try out the included Xcode project templates. The instructions for getting that to work depends on which version of Xcode you have.

If you don't have Xcode at all, you can download it here for free:
http://developer.apple.com/xcode/

INSTRUCTIONS FOR XCODE 3

If you have Xcode 3, you'll need cocos2d v1.0.0-beta for iPhone:
http://www.cocos2d-iphone.org/archives/1404

Follow the instructions here to download and install it:
http://www.cocos2d-iphone.org/wiki/doku.php/prog_guide:lesson_1._install_test

Once you've run install-templates.sh according to those instructions, this folder will have been created for you automatically:
~/Library/Application Support/Developer/Shared/Xcode/Project Templates/cocos2d 1.0.0/

Now you are ready to install CCBox2D.

Inside the "Xcode 3" folder, there is a folder called "cocos2d CCBox2D Application" - that's the project template.

To install it, copy the "cocos2d CCBox2D Application" folder into ~/Library/Application Support/Developer/Shared/Xcode/Project Templates/cocos2d 1.0.0/ alongside the other cocos2d template folders.

Then whenever you start a new project in Xcode 3, you can click on the "cocos2d 1.0.0" category under User Templates, and choose "cocos2d CCBox2D Application" as your project template.

This will give you a starting point for working with CCBox2D. If you click the "Build and Run" button, a simple physics demo should appear in the iPhone simulator. You can then poke around in the HelloWorldLayer.mm code to get a feel for how CCBox2D can be used.

INSTRUCTIONS FOR XCODE 4

If you have Xcode 4, you'll need cocos2d v1.0.0-rc for iPhone:
http://www.cocos2d-iphone.org/archives/1422

Follow the instructions here to download and install it:
http://www.cocos2d-iphone.org/wiki/doku.php/prog_guide:lesson_1._install_test

Once you've run install-templates.sh according to those instructions, this folder will have been created for you automatically:
~/Library/Developer/Xcode/Templates/cocos2d/

Now you are ready to install CCBox2D.

Inside the "Xcode 4" folder, there is a folder called "cocos2d_ccbox2d.xctemplate" - that's the project template.

To install it, copy the "cocos2d_ccbox2d.xctemplate" folder into ~/Library/Developer/Xcode/Templates/cocos2d/ alongside the other cocos2d template folders.

Then whenever you start a new project in Xcode 4, you can click on the "cocos2d category under iOS, and choose "ccbox2d" as your project template.

This will give you a starting point for working with CCBox2D. If you click the "Build and Run" button, a simple physics demo should appear in the iPhone simulator. You can then poke around in the HelloWorldLayer.mm code to get a feel for how CCBox2D can be used.

NOTES

Keep in mind that when you create a new class that inherits from one of the CCBox2D classes, you are creating an Objective-C++ class, and so the .m extension must instead be a .mm extension. If you don't, you will get all sorts of errors.

Also, I apologize for the lack of documentation with CCBox2D! If there's enough interest I might take the time to put some sort of API reference together.

For now, look at the .h files and example project. If you really need to know more about the physics involved, I reluctantly refer you to the Box2D manual:
http://www.box2d.org/manual.html

Because the whole point of CCBox2D is to smooth over all the tricky concepts and techniques discussed in the Box2D manual, reading it may just confuse you more. Sadly that's all I can offer so far.

But still, if enough people are interested, who knows what could happen! :)

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