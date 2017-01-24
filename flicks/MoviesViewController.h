//
//  ViewController.h
//  flicks
//
//  Created by  Yugender Boini on 1/23/17.
//  Copyright © 2017 sample. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoviesViewController : UIViewController

typedef NS_ENUM(NSInteger, MovieListType) {
    MovieListTypeNowPlaying,
    MovieListTypeTopRated,
};
@property (nonatomic) MovieListType movieListType;

@end

