This is a project made for Lima Technology as a technical test.
The subject was:

The iOS challenge is to build an app for iPhone. This app will give the user access to a "file system" that can be accessed using an HTTP REST API. The documentation for the API can be found at https://github.com/loderunner/webfs. The endpoint for this exercise is located at http://ioschallenge.api.meetlima.com/

We encourage you to take 15 minutes to write a readme.txt to explain your code and your technical choices. You can use any library or framework of your choice.

Mandatory features
The application will include the following features:
Navigate "file system"
List directory contents
Enter directories
Return to parent directory
View media files (jpg, mp3, mp4)
Pull to refresh

Optional features
The application can also include the following features:
Read other media type (xls, word, ppt etc...)
Add directory
Upload picture (from library)
Take picture or video with camera
Record audio with microphone
Read other media types
Open files in other application
Be creative!

Additional features are not mandatory! We'd rather see only a couple additional features well written than a ton of half-baked ideas.

________________________________________

Here are some details about my code:
- I created a class named HttpHelper that handles all web services calls
- In general, we use constants that can be used over all the application: I declare them in Constants files
- DirectoryListViewController is the controller used for listing all directories
- I represented a Document with a class named LimaDocument: because all documents have some properties in common like the name, the path, the mime type (represented as an enum),…
- In order to see a document, I created a superclass named DetailViewController: for each type of document we must have the name and the path to display the document and we set the title with the file name. Then I created a DetailTextViewController to read a text in a UITextView, a DetailImageViewController to read an image (in a image view for classic images or in a webview for  gifs), a DetailAudioVisualViewController to read audio or video files (I use a MPMoviePlayerController that can read both files)

.flac files can’t be read by any iOS default control. I saw that we must convert .flac files into wav files in order to play the sound. There are some libraries that can do it but I didn’t have time for the moment to look in detail after them. So I made just an alert displaying that we can’t read these format for the moment.

For this version, I didn’t take time to make a cache but I think it would be best. I would have created a core data database that reflects the directories and files.
But I don’t know what kind of delay would be acceptable without refreshing datas?
For example, if we have a text file that was already in cache, the text can be changed. I saw that there is a property named modification_time in the file details: If this property reflects the last modification date, we can compare it with the one saved in database, and if there is a difference (of 1mn or just a difference?) we launch the webservice to get this file details again.