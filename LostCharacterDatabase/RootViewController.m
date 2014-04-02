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
#import "DetailViewController.h"
#import "PickerViewController.h"
#import "MarkForDeleteButton.h"

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *lostCharactersArray;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UITextField *actorTextField;
@property (strong, nonatomic) IBOutlet UITextField *passengerTextField;
@property (strong, nonatomic) IBOutlet UITextField *dateOfDeathTextField;
@property (strong, nonatomic) IBOutlet UITextField *genderTextField;
@property (strong, nonatomic) IBOutlet UITextField *planeSeatTextField;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) NSMutableArray *markedForDeletionArray;
@property (strong, nonatomic) NSString *sortKey;
@property BOOL isEditModeEnabled;
@end

@implementation RootViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sortKey = @"actor";
    self.isEditModeEnabled = NO;
    self.markedForDeletionArray = [NSMutableArray new];
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

    cell.textLabel.text = [self.lostCharactersArray[indexPath.row] actor];
    cell.detailTextLabel.text = [self.lostCharactersArray[indexPath.row] passenger];
    if ([cell.detailTextLabel.text isEqualToString:@"Hugo “Hurley” Reyes"])
    {
        cell.imageView.image = [UIImage imageNamed:@"hurley"];
    }
    else if ([cell.detailTextLabel.text isEqualToString:@"Kate Austen"])
    {
        cell.imageView.image = [UIImage imageNamed:@"kate"];
    }
    else if ([cell.detailTextLabel.text isEqualToString:@"Jack Shephard"])
    {
        cell.imageView.image = [UIImage imageNamed:@"jack"];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"jeff"];
    }
    
    if (self.isEditModeEnabled)
    {
        cell.myDeleteOnEditModeButton.hidden = NO;
        cell.myDeleteOnEditModeButton.enabled = YES;
    }
    else
    {
        cell.myDeleteOnEditModeButton.hidden = YES;
        cell.myDeleteOnEditModeButton.enabled = NO;
    }
    cell.myDeleteOnEditModeButton.indexPath = indexPath;
    cell.dateOfDeathLabel.text = [self.lostCharactersArray[indexPath.row] dateOfDeath];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.managedObjectContext deleteObject:self.lostCharactersArray[indexPath.row]];
        [self.managedObjectContext save:nil];
        [self load];
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
    NSSortDescriptor *actorNameDescriptor = [[NSSortDescriptor alloc] initWithKey:self.sortKey ascending:YES];
    NSArray *sortDescriptorsArray = [NSArray arrayWithObject:actorNameDescriptor];
    request.sortDescriptors = sortDescriptorsArray;
    NSMutableArray *lostCharactersArray = (id)[self.managedObjectContext executeFetchRequest:request error:nil];
    
    if (lostCharactersArray.count)
    {
        self.lostCharactersArray = lostCharactersArray;
    }
    else
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"lost" ofType:@"plist"];
        NSMutableArray *lostCharactersArray = [[NSMutableArray alloc] initWithContentsOfFile:path];

        for (NSDictionary *defautCharacter in lostCharactersArray) {
            CharacterList *character = [NSEntityDescription insertNewObjectForEntityForName:@"CharacterList" inManagedObjectContext:self.managedObjectContext];
            character.actor = defautCharacter[@"actor"];
            character.passenger = defautCharacter[@"passenger"];
            
            [self.managedObjectContext save:nil];
        }
        [self load];
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
    character.gender = self.genderTextField.text;
    character.planeSeat = self.planeSeatTextField.text;
    
    [self.managedObjectContext save:nil];
    [self load];
    
}

- (IBAction)onEditButtonPressed:(UIButton *)sender
{
    self.isEditModeEnabled = !self.isEditModeEnabled;
    
    if (self.isEditModeEnabled)
    {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
    }
    else
    {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        for (NSIndexPath *indexPath in self.markedForDeletionArray)
        {
            [self.managedObjectContext deleteObject:self.lostCharactersArray[indexPath.row]];
        }
        [self.managedObjectContext save:nil];
        [self load];
        [self.myTableView reloadData];
    }
    [self.myTableView reloadData];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (self.isEditModeEnabled) {
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)cell
{
    if ([segue.identifier isEqualToString:@"detailViewSegue"])
    {
        NSIndexPath *indexPath = [self.myTableView indexPathForCell:cell];
        DetailViewController *destination = segue.destinationViewController;
        destination.actor = [self.lostCharactersArray[indexPath.row] actor];
        destination.passenger = [self.lostCharactersArray[indexPath.row] passenger];
        destination.dateOfDeath = [self.lostCharactersArray[indexPath.row] dateOfDeath];
        destination.gender = [self.lostCharactersArray[indexPath.row] gender];
        destination.planeSeat = [self.lostCharactersArray[indexPath.row] planeSeat];
        destination.characterImage = cell.imageView.image;
    }

    
}

-(IBAction)unwindToRootViewController:(UIStoryboardSegue *)segue
{
    PickerViewController *source = segue.sourceViewController;
    self.sortKey = source.stringForSelectedPickerRow;
    [self load];
}

- (IBAction)onEditDeleteButtonPressed:(MarkForDeleteButton *)button
{
    [self.markedForDeletionArray addObject:button.indexPath];
    NSLog(@"%@", button.indexPath);
    NSLog(@"%@",self.markedForDeletionArray);
}

@end
