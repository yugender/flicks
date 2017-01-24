//
//  MovieModel.m
//  flicks
//
//  Created by  Yugender Boini on 1/23/17.
//  Copyright © 2017 sample. All rights reserved.
//

#import "MovieModel.h"

@implementation MovieModel

- (id) initWithDictionary: (NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.title = dictionary[@"original_title"];
        self.overview = dictionary[@"overview"];
        self.posterPath = dictionary[@"poster_path"];
        self.movieId = [dictionary[@"id"] intValue];
    }
    return self;
}
@end
