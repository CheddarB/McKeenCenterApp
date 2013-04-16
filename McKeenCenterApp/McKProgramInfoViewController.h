//
//  McKProgramInfoViewController.h
//  McKeenCenterApp
//
//  Created by Evan Hoyt on 4/15/13.
//  Copyright (c) 2013 Andrew Daniels and Evan Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface McKProgramInfoViewController : UIViewController{
    @public
    NSString *title;
    NSString *subtitle;
}
@property (strong, nonatomic) IBOutlet UITextView *titleView;
@property (strong, nonatomic) IBOutlet UITextView *subtitleView;
@end
