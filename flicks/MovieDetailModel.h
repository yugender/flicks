//
//  MovieDetailModel.h
//  flicks
//
//  Created by  Yugender Boini on 1/27/17.
//  Copyright © 2017 sample. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieDetailModel : NSObject

- (id) initWithDictionary: (NSDictionary *)dictionary;

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* overview;
@property (nonatomic, strong) NSURL* posterUrl;
@property (nonatomic, strong) NSString* posterPath;
@property (nonatomic, strong) NSString* releaseDate;
@property (nonatomic) int movieId;
@property (nonatomic) int runTime;
@property (nonatomic) float rating;

@end
