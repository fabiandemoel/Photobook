# Report

## Description
This report concerns an image focused social media application that allows the user to choose the extend of it's functionality. It works with a server to which a user's content and info is uploaded.

![Sketch](doc/UserViewScreenshot.png)

## Technical Design
The application main function is presenting content that is retreived from a server. Furthermore it can also post content to said server, and edit existing content. Next to this the user can change the extent of functions available to increase or decrease the ease of use.

## Classes
The application is build on 2 different classes which each have their own networking code, and a class specifically for holding an image string. 
### User
Firstly, the User class. The User class consists of the following variables: name, id, type, friendsFamily and password. The name variable is used to retreive and post content, the id variable is used on the server, the type identifies the extent to which functions are available and friendsFamily lists the contacts of the user. The user class also has a few different functions which can provide a sample user, save a user when the app has been moved to the background and load said user when the app is shutdown. In order to access and alter the same user in different views, in the AppDelegate the current user is set as a global user.
The User class is accompanied by the UserController which contains the networking code. This code retreives users that are in the contact list. Outside of this it also enables the addition of new friends, a change of password and a change of user type.
### Picture
Secondly, the Picture class. This class contains the details that are needed to load the posts of the users. The variables in this class are: id, title and description. The id is, again, used on the server, the title is used for retrieving the actual image and the description tells the user what the picture is about.
The Picture class is bound to the PictureController, which fetches, posts, edits and deletes image data. The details concerning the data and the string describing the image are retrieved and posted seperately.
The ImageString class holds the base64 string that is converted to an image.

## Views
These classes are used throughout 3 tabbars, 2 of which have multiple views.
### ContactsTableView
This list view holds the contacts found in the friendsFamily variable of our current user. On this page we tap switch user, which will present a pop up, and change accounts by either logging in or registering for a new account. When tapped, the other tabs check if a change has occured in the user, and it adjusts it's content. We can also add contacts by tapping the plus sign, this will also present a pop up where we can enter a username. By tapping on the name of a contact we go to her or his content on the UserContentTableView. On their content page we see another list view, holding the the titles and small previews of the images they have posted. By tapping on the image we are brought to the UserPostView which has the title in the header, the full picture in the upper half of the page and the description in the lower half.
### MyContentTableView
This view mirrors the UserContentTableView but here we find the user's own content. By tapping the plus sign we can add new content, and by tapping on an image we can view and edit existing content. Both happen in the NewPostView, since either editing or adding will create a new post. By tapping the edit button in the UserContentTableView the existing content can be deleted. The functionality on this page is slightly more advanced, so in order to upkeep the ease of use it is unavailable in the simple mode. A pop up will appear upon entry in simple mode and inform the user of this fact, they can then choose to be redirected to the contacts tab or the settings tab where they can adjust the simple mode setting. Upon reentry, the status of the user type is checked if it was adjusted.
### SettingsTableView
In the SettingsTableView the name of the current user is presented, their password can be entered and simple mode can be turned on or off. By clicking 'Save settings' a put request is send to the server and the global user in the appDelegate is adjusted.

## Development Challenges
In order to make the app more easily creatable, I made some design changes. I switched to list views, since I was more familiar with those than the views I had originally put in my design. Furthermore I left out the messaging option since that on its own could have been an app. What I struggled most with to get right was the correct implementation of the networking code. At first I wrote code that would upload and fetch a jpeg to and from the server, the fetching worked well but the upload showed several issues. Following this I tried to convert my images to base64 strings, but this slowed down my application and server immensely. Thus I went back to uploading jpegs, improved my code and the code on the server and asked the staff for help. For some reason I have yet to uncover xCode sees my request as HTTP, and even though I adjusted the info.plist and tried to solve it together with the staff I could not find a solution. So I reverted to base64 strings, shrunk down the size off the images on recommendation of the staff, and got the app working as I wanted.

## Reflection
Sacrificing some design was a good idea, it helped me focus on the bigger challenge that I was facing, namely the upload code. Focussing on my main functionality should have had priority from the start. By using the base64 string this functionality was brought to life, so the initial decision to do this was the right one, I should have stuck with it though. Ideally I would have rather used the jpeg files because this would allow for files to be their original size, but a compromise had to be made. In an ideal world I would implement something like Alamofire to handle the uploads, unfortunately I didn't research it enough at the start to use it. I will take that with me to my next project.
