# MuseApp
Muse Music Journal Entry App on Core Data


Muse is an iOS journaling app with music pinning capabilities. While writing an entry, users can pin a currently playing song (from your local iTunes/Apple Music library) to that specific text. When that entry is revisit or edit in the future, the pinned songs playback.



When I first started this app [7 weeks](http://leojkwan.com/2015/07/26/week-7-8-at-flatiron/) into an iOS summer program in NYC, I connected Muse to the Parse SDK as my primary storage for entries, and photos.


##Screenshots

<div align="center">
<tr>
        <td>
        <img src="https://leokwanblog.files.wordpress.com/2015/10/home-screens-copy-23x.jpg" width="275" />
    </td>
        <td>
        <img src="https://leokwanblog.files.wordpress.com/2015/10/home-screens-copy-33x.jpg" width="275" />
    </td>
</tr>
</div>
<div align="center">
<div align="center">
<tr>
    <td>
        <img src="https://leokwanblog.files.wordpress.com/2015/10/home-screens3x.jpg" width="275" />
    </td>
    <td>
        <img src="https://leokwanblog.files.wordpress.com/2015/10/home-screens-copy3x.jpg" width="275" />
    </td>
</tr>
</div>
<div align="center">



##Features
	•	Leveraged MPMediaQuery with NSPredicates to identify currently playing songs.
	•	Integrated MPMusicPlayerController to play pinned songs from Apple Music and local library.
	•	Integrated NSFetchedResultsController to handle managed object updates
	•	Created random song picker feature to kick start a journal entry with music.
	•	Markdown syntax in journal entries to handle attributed text and styling.


##Frameworks Used
	•	MediaPlayer
	•	Core Data
	•	PHPhoto

##Pods
	1.	APParallaxHeader
	2.	Masonry
	3.	IHKeyboardAvoiding
	4.	MCSwipeTableViewCell
	5.	SCLAlertView-Objective-C
	6.	CWStatusBarNotification
	7.	AttributedMarkdown

