GalileoTracker is a simple iOS application that makes your Motrr Galileo motion platform
track the largest face that your iPhone's camera can see.  It does this by using the face
detection functionality of the OpenCV computer vision library to locate the face, and then
moving the Galileo unil the face is centered.

The project contains everything you need except for a copy of Motrr's
GalileoControl.framework, which you can download at:

http://dev.motrr.com/sdk

GalileoTracker is built on top of CVFunhouse, a framework for rapid development of
computer vision applications using the OpenCV computer vision library on iOS.  For
more informaton on CVFunhouse, see:

https://github.com/jeradesign/CVFunhouse

For more information on the OpenCV computer vision library, see:

http://opencv.org
