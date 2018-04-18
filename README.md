

### REQUIREMENTS ###


### BUILD ###
iOS 8.2.1 SDK or later
(Swift version 3.02 or later)

### RUNTIME ###
iOS 9.0 or later 
(for older version need to remove all UI elements from UIStackView(via Storyboard) and reinstall them without UIStackView )

This app might be interesting for you if you are looking for implementing and handling follow gestures:

* UITapGestureRecognizer   (separated handling one tap and two taps)
    * UITapGestureRecognizer (1 tap)
    * UITapGestureRecognizer (2 taps)
* UIPinchGestureRecognizer (scaling separately in EACH axis of three(horizontal, vertical, diagonal) axises in main view as well in highlited view)
    * UIPinchGestureRecognizer Horizontal (X)
    * UIPinchGestureRecognizer Vertical   (Y)
    * UIPinchGestureRecognizer Diagonal   (D)
* UIRotationGestureRecognizer
* UIPanGestureRecognizer
* UILongPressGestureRecognizer


### About Funny Rectangles ###

Hi there,

Welcome to app "Funny Rectangles"

![screenshot](https://github.com/PROudoxa/git-first/blob/master/screenshotLogo.jpg)
![screenshot](https://github.com/PROudoxa/git-first/blob/master/screenshot.jpg)

This app provides you opportunity for managing rectangles using gestures and having fun with them.

You may:
Create, rotate, scale, highlight, move, change color, delete.


### Getting started ###

### Building && Running ###

a) using simulator iOS apps:

clone or download the project
open project folder
double click to file FunnyRectangles.xcodeproj

in Xcode in scheme section(top left corner) select

    target "FunnyRectangles" -> in "simulators" section select "iPhone 7"(or another simulator)

in Xcode menu go to:

    Product -> Run       (or just hotkey command + R)

the app will be builing and run by Xcode

Have fun!
Have a nice day!


b) using Apple device(iPhone/iPad):

clone or download the project
open project folder
double click to file FunnyRectangles.xcodeproj

in Xcode in scheme section(top left corner) select

        target "FunnyRectangles" -> in "devices" section select one of available devices(dont forget to connect it before)

in Xcode menu go to:

        Product -> Run       (or just hotkey command + R)

the app will be builing and run by Xcode

Have fun!
Have a nice day!


I hope the above is useful to you.
Please feel free to contact me if you need any additional information
