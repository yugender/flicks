//
//  MovieModel.h
//  flicks
//
//  Created by  Yugender Boini on 1/23/17.
//  Copyright © 2017 sample. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieModel : NSObject

- (id) initWithDictionary: (NSDictionary *)otherDictionary;

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* overview;
@property (nonatomic, strong) NSString* posterPath;
@property (nonatomic) int movieId;

@end
