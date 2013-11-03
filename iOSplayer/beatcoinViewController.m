//
//  beatcoinViewController.m
//  iOSplayer
//
//  Created by franck on 10/26/13.
//  Copyright (c) 2013 franck. All rights reserved.
//

#import "beatcoinViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MediaPlayer/MPMediaItemCollection.h"
#import "beatcoinAPI.h"

@interface beatcoinViewController ()

@property (weak, nonatomic) IBOutlet UIButton *addSongsButton;
@property (weak, nonatomic) IBOutlet UITextField *playingLabel;
@property (strong, nonatomic) beatcoinAPI * beatcoinAPI;

@property BOOL playingASong;



@end

@implementation beatcoinViewController

@synthesize musicPlayer;
@synthesize playingLabel;
@synthesize playingASong;
@synthesize beatcoinAPI=_beatcoinAPI;


- (void)viewDidLoad
{
    
    playingASong=FALSE;
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    musicPlayer.repeatMode=MPMusicRepeatModeNone;
    musicPlayer.shuffleMode = MPMusicShuffleModeOff;
    _statusLine.text=@"waiting for song";

    [musicPlayer stop];
    
    /*
    
    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
    [self.musicPlayer setQueueWithQuery:songsQuery];
    */
    
    [self createTimer];
    [self registerMediaPlayerNotifications];
    
    
    MPMediaQuery *songQuery = [MPMediaQuery songsQuery];
    NSArray *songs = [songQuery items];
    MPMediaItemCollection *currentQueue = [[MPMediaItemCollection alloc] initWithItems:songs];
    
    
    _beatcoinAPI=[[beatcoinAPI alloc] init];
    [_beatcoinAPI postLibrary:currentQueue];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) registerMediaPlayerNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver: self
                           selector: @selector (handle_NowPlayingItemChanged:)
                               name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object: musicPlayer];
    
    
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_PlaybackStateChanged:)
                               name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                             object: musicPlayer];
    /*
     [notificationCenter addObserver: self
     selector: @selector (handle_VolumeChanged:)
     name: MPMusicPlayerControllerVolumeDidChangeNotification
     object: musicPlayer];
     */
    [musicPlayer beginGeneratingPlaybackNotifications];
}



- (void) handle_NowPlayingItemChanged: (id) notification
{
    
    MPMediaItem *currentItem = [musicPlayer nowPlayingItem];
    NSLog(@"handle_NowPlayingItemChanged:");
    
    [self printItem:musicPlayer.nowPlayingItem];
    
    
    /*
    NSString *titleString = [currentItem valueForProperty:MPMediaItemPropertyTitle];
    if (titleString) {
        playingLabel.text = [NSString stringWithFormat:@"Title: %@",titleString];
    } else {
        playingLabel.text = @"Title: Unknown title";
    }
     */
    
    if ([currentItem valueForProperty: MPMediaItemPropertyPersistentID]==nil ) {
        
        playingASong=FALSE;
        NSLog(@"no song played");
        _statusLine.text=@"waiting for song";

    }
}


- (void) handle_PlaybackStateChanged: (id) notification
{
    MPMusicPlaybackState playbackState = [musicPlayer playbackState];
    
    if (playbackState == MPMusicPlaybackStatePaused) {
        NSLog(@"handle_PlaybackStateChanged: MPMusicPlaybackStatePaused");
       // playingASong=FALSE;

    } else if (playbackState == MPMusicPlaybackStatePlaying) {
        NSLog(@"musicPlayer.nowPlayingItem=");
        NSLog(@"indexOfNowPlayingItem=%lu",(unsigned long)musicPlayer.indexOfNowPlayingItem);
        NSString *status = @"playing ";
        NSString *status2=[status stringByAppendingString:[musicPlayer.nowPlayingItem valueForProperty: MPMediaItemPropertyTitle]];
        status =[musicPlayer.nowPlayingItem valueForProperty: MPMediaItemPropertyArtist];
        _statusLine.text= [NSString stringWithFormat:@"%@ %@", status2, status];
        

        

        [self printItem:musicPlayer.nowPlayingItem];
    } else if (playbackState == MPMusicPlaybackStateStopped) {
        NSLog (@"handle_PlaybackStateChanged: MPMusicPlaybackStateStopped");
       // [musicPlayer stop];
       // playingASong=FALSE;
       // _statusLine.text=@"waiting for song";


    }
}


- (void) fetchAndPlaySong {
    
    /*
    MPMediaPropertyPredicate *predicate =
    [MPMediaPropertyPredicate predicateWithValue: @"Non_Existant_Song_Name"
                                     forProperty: MPMediaItemPropertyTitle];
    MPMediaQuery *q = [[MPMediaQuery alloc] init];
    [q addFilterPredicate: predicate];
    [musicPlayer setQueueWithQuery:q];
    */
    
   // musicPlayer.nowPlayingItem = nil;
  //  [musicPlayer stop];
 
   // NSNumber * a=[beatcoinAPI getPlay];
    
    NSString * a=[_beatcoinAPI getPlayByName];
    
    if (a==nil) return;
    
   
    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];

    /*
    [self.musicPlayer setQueueWithQuery:songsQuery];
    
    MPMediaQuery *mq  = [[MPMediaQuery alloc] init]; //[MPMediaQuery songsQuery];
    
  
    MPMediaPropertyPredicate *songNamePredicate = [MPMediaPropertyPredicate
                                                   predicateWithValue:a

                                                   forProperty:MPMediaItemPropertyPersistentID];
    
    
    [mq addFilterPredicate:songNamePredicate];

    NSLog(@"[mq items]:%@ [mq items] %@",[mq items],[[mq items] class]);

    [musicPlayer setQueueWithQuery:mq];
    
    for (a in [mq items]) {
        NSLog(@"%@",a);
    }
    */
    
    MPMediaQuery *mq  = [MPMediaQuery songsQuery];
    MPMediaPropertyPredicate *songNamePredicate = [MPMediaPropertyPredicate
                                                   predicateWithValue:a
                                                   forProperty:MPMediaItemPropertyTitle];
    [mq addFilterPredicate:songNamePredicate];
    [musicPlayer setQueueWithQuery:mq];
    //[mp play];
    for (a in [mq items]) {
        NSLog(@"%@",a);
    }
    
    [musicPlayer play];

    playingASong=TRUE;
    

    NSLog(@"playing a fetched song !");
    
}

- (NSTimer*)createTimer {
    
    // create timer on run loop
    return [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES];
}

- (void)timerTicked:(NSTimer*)timer {
    
    if (playingASong==TRUE) return;
    NSLog(@"timerTicked: calling fetchAndPlaySong");
    [self fetchAndPlaySong];
    
}


- (void) printItem:(id)object {
    NSLog(@"Title: %@", [object valueForProperty: MPMediaItemPropertyTitle]);
    NSLog(@"Artist: %@", [object valueForProperty: MPMediaItemPropertyArtist]);
    NSLog(@"PersistentID: %@", [object valueForProperty: MPMediaItemPropertyPersistentID]);
}
- (IBAction)showMediaPicker:(id)sender
{
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAny];
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = YES;
    mediaPicker.prompt = @"Select songs to play";
    [self presentModalViewController:mediaPicker animated:YES];
}

- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection
{
    /*
    if (mediaItemCollection) {
        [beatcoinAPI postLibrary:mediaItemCollection];
    }
     */
    
    [self dismissModalViewControllerAnimated: YES];
}
- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
    [self dismissModalViewControllerAnimated: YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self
													name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
												  object: musicPlayer];
	
	[[NSNotificationCenter defaultCenter] removeObserver: self
													name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
												  object: musicPlayer];
    
    
	[musicPlayer endGeneratingPlaybackNotifications];
    
    
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver: self
													name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
												  object: musicPlayer];
	
	[[NSNotificationCenter defaultCenter] removeObserver: self
													name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
												  object: musicPlayer];
    
    /*
     [[NSNotificationCenter defaultCenter] removeObserver: self
     name: MPMusicPlayerControllerVolumeDidChangeNotification
     object: musicPlayer];
     */
	[musicPlayer endGeneratingPlaybackNotifications];
    
    /*
     [artworkImageView release];
     artworkImageView = nil;
     [titleLabel release];
     titleLabel = nil;
     [artistLabel release];
     artistLabel = nil;
     [albumLabel release];
     albumLabel = nil;
     [volumeSlider release];
     volumeSlider = nil;
     [playPauseButton release];
     playPauseButton = nil;
     [musicPlayer release];
     */
    [musicPlayer stop];
    
    [super viewDidUnload];
    
}

@end
