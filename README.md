# MuseApp
Muse Music Journal Entry App on Core Data


Muse is an iOS journaling app with music pinning capabilities. While writing an entry, users can pin a currently playing song (from your local iTunes/Apple Music library) to that specific text. When that entry is revisit or edit in the future, the pinned songs playback.



When I first started this app [7 weeks](http://leojkwan.com/2015/07/26/week-7-8-at-flatiron/) into an iOS summer program in NYC, I connected Muse to the Parse SDK as my primary storage for entries, and photos.


##Screenshots



##Features
	•	Leveraged MPMediaQuery with NSPredicates to identify currently playing songs.
	•	Integrated MPMusicPlayerController to play pinned songs from Apple Music and local library.
	•	Integrated NSFetchedResultsController to handle managed object updates
	•	Created random song picker feature to kick start a journal entry with music.
	•	Markdown syntax in journal entries to handle attributed text and styling.

##Frameworks Used
+ Leveraged MPMediaQuery with NSPredicates to identify the currently playing song.
+ Integrated MPMusicPlayerController to play pinned songs from Apple Music and local library.
