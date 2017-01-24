//
//  MovieDetailModel.m
//  flicks
//
//  Created by  Yugender Boini on 1/27/17.
//  Copyright © 2017 sample. All rights reserved.
//

#import "MovieDetailModel.h"

@implementation MovieDetailModel

- (id) initWithDictionary: (NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.title = dictionary[@"original_title"];
        self.overview = dictionary[@"overview"];
        self.posterUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://image.tmdb.org/t/p/w342%@",dictionary[@"poster_path"]]];
        self.posterPath = dictionary[@"poster_path"];
        self.movieId = [dictionary[@"id"] intValue];
        self.releaseDate = dictionary[@"release_date"];
        NSObject *runtime = dictionary[@"runtime"];
        if (runtime && ![runtime isEqual:[NSNull null]]) {
            self.runTime = [dictionary[@"runtime"] intValue];
        } else {
            self.runTime = 0;
        }
        
        self.rating = [dictionary[@"vote_average"] floatValue];
    }
    return self;
}

@end
