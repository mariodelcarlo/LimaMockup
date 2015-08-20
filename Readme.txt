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