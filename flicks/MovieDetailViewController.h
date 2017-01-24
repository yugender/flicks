//
//  MovieDetailViewController.h
//  flicks
//
//  Created by  Yugender Boini on 1/25/17.
//  Copyright © 2017 sample. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieModel.h"
#import "MovieDetailModel.h"

@interface MovieDetailViewController : UIViewController
@property (strong, nonatomic) MovieModel *movie;
@end
