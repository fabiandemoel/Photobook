# Day 1
After meeting with the teacher I made a decision between the two apps I had in mind. I made a design, which you can find in DESIGN.md.

# Day 2, 3, 4
Made general structure; views, buttons, stacks and such.

# Day 5
In the original design, I wanted to use a page view controller to go present the contacts:
![Sketch](doc/20190604_1240582.jpg)

But after some solid advice I decided to opt for a simple list view controller, which I am more familiar with. This should make the process easier.

# Day 6, 7
Implemented basic transport functionality for the contacts pages

![ContactsScreenshot](doc/ContactsScreenshot.png)

Wrote down some idea's for the User and Picture objects

![Sketch](doc/ObjectsSketch.png)

# Day 8, 9, 10

Got the advice to google for Flask documentation on how to upload images. I have gotten around to creating some users and picture data objects on the server, but images don't seem to be working. I found a small bug, which gave me an error, I had a '/' in the upload folder variable, which was unnecessary. Still doesn't work though.

Simplified user Objects

# Day 11

Found some quality Log In code: https://mycodetips.com/swift-ios/create-login-screen-alert-view-controller-using-uialertcontroller-swift-1306.html. Implemented it mostly, still need to put in the right communication with the server. This is in an alert window instead of a seperate screen as I had in my original sketches, but it works quite well.

Sketch:
![Sketch](doc/LogInSketch.png)

Realised:
![Sketch](doc/LogInScreenshot.png)


# Day 12

Downsized the user and picture objects to the essentials, added some methods to use them more easily.

# Day 13

Got the fetchImages method working. Also implemented transport functionality for Users own content, decided to just use the title and image instead of the full description. This should leave some more space and make it less crowded. Also have chosen to not use profile pictures yet, first try to get the basics covered.

![Sketch](doc/PersonalContentScreenshot.png)


# Day 14

Added error messages to the log in menu

![Sketch](doc/LogInErrorScreenshot.png)


# Day 15

Lost half of the code when uploaded to Github, tried to get it back but didn't work out. Missing is now the code that handles communications with the server, started rewriting it.


# Day 16, 17

Rebuild the remaining code, good exercise.


# Day 18

Switched the upload code to work with base64 strings, but this slowed down the app. Showed no positive results so going back to file upload.

# Day 19

Have run through all of StackOverflow to get the Application Transport Security to allow the networking code, also asked the staff, but with no results.

# Day 20, 21

Got the advice to switch back to base64 strings, implemented it but string doesn't revert back to image. Seems to be a problem with '+' in string being converted to '%20' and then becoming spaces.


