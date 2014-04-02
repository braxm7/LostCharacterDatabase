//
//  PickerViewController.m
//  LostCharacterDatabase
//
//  Created by Calvin Hildreth on 4/1/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "PickerViewController.h"

@interface PickerViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) NSArray *pickerArray;
@property (strong, nonatomic) IBOutlet UIPickerView *myPickerView;

@end

@implementation PickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pickerArray = @[@"actor", @"passenger", @"dateOfDeath", @"gender", @"planeSeat"];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickerArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pickerArray[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.stringForSelectedPickerRow = self.pickerArray[row];
}

@end
