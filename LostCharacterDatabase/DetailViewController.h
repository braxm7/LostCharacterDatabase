//
//  DetailViewController.h
//  LostCharacterDatabase
//
//  Created by Calvin Hildreth on 4/1/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSString *actor;
@property (strong, nonatomic) NSString *passenger;
@property (strong, nonatomic) NSString *dateOfDeath;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *planeSeat;
@property (strong, nonatomic) UIImage *characterImage;

@end
