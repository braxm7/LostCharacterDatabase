//
//  RootViewController.m
//  LostCharacterDatabase
//
//  Created by Calvin Hildreth on 4/1/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "RootViewController.h"
#import "CharacterList.h"
#import "CharacterTableViewCell.h"

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *lostCharactersArray;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UITextField *actorTextField;
@property (strong, nonatomic) IBOutlet UITextField *passengerTextField;
@property (strong, nonatomic) IBOutlet UITextField *dateOfDeathTextField;

@end

@implementation RootViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"lost" ofType:@"plist"];
    self.lostCharactersArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
    [self load];
}

#pragma mark -- tableview delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lostCharactersArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CharacterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellReuseID"];
    
    if ([self.lostCharactersArray[indexPath.row] isKindOfClass:[NSDictionary class]]) {
        cell.textLabel.text = self.lostCharactersArray[indexPath.row][@"actor"];
        cell.detailTextLabel.text = self.lostCharactersArray[indexPath.row][@"passenger"];
    }
    else
    {
        cell.textLabel.text = [self.lostCharactersArray[indexPath.row] actor];
        cell.detailTextLabel.text = [self.lostCharactersArray[indexPath.row] passenger];
        cell.dateOfDeathLabel.text = [self.lostCharactersArray[indexPath.row] dateOfDeath];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.lostCharactersArray removeObjectAtIndex:indexPath.row];
        [self.myTableView reloadData];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"SMOKE MONSTER";
}

#pragma mark -- database management

-(void)load
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"CharacterList"];
    NSSortDescriptor *actorNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"actor" ascending:YES];
    NSArray *sortDescriptorsArray = [NSArray arrayWithObject:actorNameDescriptor];
    request.sortDescriptors = sortDescriptorsArray;
    NSMutableArray *lostCharactersArray = (id)[self.managedObjectContext executeFetchRequest:request error:nil];
    
    if (lostCharactersArray.count)
    {
        self.lostCharactersArray = lostCharactersArray;
    }
    [self.myTableView reloadData];
}

#pragma mark -- button methods

- (IBAction)addButton:(id)sender
{
    CharacterList *character = [NSEntityDescription insertNewObjectForEntityForName:@"CharacterList" inManagedObjectContext:self.managedObjectContext];
    
    character.actor = self.actorTextField.text;
    character.passenger = self.passengerTextField.text;
    character.dateOfDeath = self.dateOfDeathTextField.text;
    
    [self.managedObjectContext save:nil];
    [self load];
    
}

@end
