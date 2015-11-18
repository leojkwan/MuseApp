
# <a style="text-decoration:none" href="http://www.musetheapp.com">Muse - Journal with Sound</a>

<a style="text-decoration:none" href="https://itunes.apple.com/app/id1044888483?aId=1001l5Yq&ct=app-website">
<img style="text-decoration:none;text-align:right" src="https://d2kfjaekmjmy1l.cloudfront.net/images/websites/public/app-store-black-on-color@2x-vd3eb32e86e4d.png" width="150"/></a>

Music && Journaling iOS App on Core Data 

Muse is a mobile journaling app with music pinning capabilities. That is, while an entry is written on Muse, users can pin a currently playing song (from your local iTunes/Apple Music library) to that specific text. When that entry is revisit or edit in the future, the pinned songs playback.

When I first started this app [7 weeks](http://leojkwan.com/2015/07/26/week-7-8-at-flatiron/) into an iOS summer program in NYC, I connected this project with the Parse SDK to store and save entries. I decided to strip away the Parse plug-in backend  entirely and instead have Muse rely entirely on Core Data for persistance. 

##Screenshots (old)

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
<tr>
        <td>
        <img src="https://leokwanblog.files.wordpress.com/2015/10/home-screens-copy-23x.jpg" width="275" />
    </td>
        <td>
        <img src="https://leokwanblog.files.wordpress.com/2015/10/home-screens-copy-33x.jpg" width="275" />
    </td>
</tr>
</div>




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

