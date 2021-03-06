//
//  CharacterTableViewCell.h
//  LostCharacterDatabase
//
//  Created by Calvin Hildreth on 4/1/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkForDeleteButton.h"

@interface CharacterTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *dateOfDeathLabel;
@property (strong, nonatomic) IBOutlet MarkForDeleteButton *myDeleteOnEditModeButton;
@end
