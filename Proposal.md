# App-Project
Project for the programming minor by Fabian de Moel. 

## Problem statement
A familiar problem for old people is that they can't keep up with the fast paced changes in technology. Yet their children are able to interact with this technology very well and outpace them. This is cause for a rift; your grandparents are not able to interact with complex apps like you are. An effect hereof is that grandparents cannot participate in social media, whilst they would very much enjoy some of the content produced by their grandchildren on these platforms. Grandchildren on the other hand are happy that their grandparents aren't on these platforms, since some of the content they produce or parttake are not meant for their eyes.

## Solution
To combat this problem, applications need to be more accessible and usible to those less tech savy. A possible solution would be an app that has two types of user profile; one with a simple interface for the technologically challenged, and a complex interface for those more comfortable with technology. This would increase usability without giving up functionality.

## Sketch
![Sketch](doc/AppProjectSketch.png)

## Main features
1. MVP
 - Log in
 
1.1 Interface Simple:
 - Home screen with family/friends their name and picture on it
 - Click a person and an overview of their posts is shown

1.2 Interface Complex:
 - Interface simple
 - Settings menu
 - Content upload possibility
 
 2. Optional

2.1 Interface Simple:
 - Message interface on the person page
 - Simplified content upload
 - Help menu with ability to allow contacts to change settings remotely

2.2 Interface Complex:
 - Ability to change settings remotely
 - Edit uploaded content
 
 ## Prerequisites
1. Data Sources:
 - None, people will provide their own content

2. External Components:
 - A database where the information can be cointained

3. Similar mobile apps:
 - Facebook, whatsapp, instagram. They have all the features I'm looking to implement, but lack the specified interface for the technologically challenged. These all work with a stack system, the last added object appears on top of the feed. My system would just work like a simple overview, where date of update will be disregarded at first.

4. Hardest part:
 - Creating the interconnectivity between users that is required for it to function. Content has to be viewed on one device as it was uploaded on the other. 
