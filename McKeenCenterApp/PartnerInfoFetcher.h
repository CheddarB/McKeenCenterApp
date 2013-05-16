//
//  PartnerInfoFetcher.h
//  McKeenCenterApp
//
//  Created by Andrew Daniels on 4/17/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PartnerInfoFetcher : NSObject


-(id)initWithURLPath:(NSString *)url andID:(int)orgID;


@property (nonatomic) NSString * site;
@property (nonatomic) NSString * name;
@property (nonatomic) NSString * street;
@property (nonatomic) NSString * town;
@property (nonatomic) NSString * email;
@property (nonatomic) NSString * phone;

@end
