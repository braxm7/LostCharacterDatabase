//
//  DetailViewController.m
//  LostCharacterDatabase
//
//  Created by Calvin Hildreth on 4/1/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *actorLabel;
@property (strong, nonatomic) IBOutlet UILabel *passengerLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateOfDeathLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) IBOutlet UILabel *planeSeatLabel;
@property (strong, nonatomic) IBOutlet UIImageView *characterImageView;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.actorLabel.text = [NSString stringWithFormat:@"Name: %@", self.actor];
    self.passengerLabel.text = [NSString stringWithFormat:@"Character: %@", self.passenger];
    self.dateOfDeathLabel.text = [NSString stringWithFormat:@"Died in show: %@", self.dateOfDeath];
    self.genderLabel.text = [NSString stringWithFormat:@"gender: %@", self.gender];
    self.planeSeatLabel.text = [NSString stringWithFormat:@"Plane Seat # %@", self.planeSeat];
    self.characterImageView.image = self.characterImage;
    
}


@end
