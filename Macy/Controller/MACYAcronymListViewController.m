//
//  MACYAcronymListViewController.m
//  Macy
//
//  Created by Durgesh Gupta on 9/30/15.
//  Copyright © 2015 Durgesh Gupta. All rights reserved.
//

#import "MACYAcronymListViewController.h"
#import "MACYAcronymListCell.h"
#import <MBProgressHUD.h>
#import "DataManager.h"

static NSString* const kOK = @"OK";
static NSString* const kError = @"Error";
static NSString* const kLoading = @"Loading";
static NSString* const kReuseIdentifier = @"reuseID";
static NSString* const kMessage = @"Text Filed Cann't be emply";

@interface MACYAcronymListViewController ()<MBProgressHUDDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtURL;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnGo;
@property (strong, nonatomic) NSMutableArray *dataSourceArray;
@property (strong, nonatomic) MBProgressHUD *activityIndicator;

@end

@implementation MACYAcronymListViewController


// Lazy initialization

-(NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc] init];
    }
    return _dataSourceArray;
}

-(MBProgressHUD *)activityIndicator
{
    if (!_activityIndicator) {
            _activityIndicator = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            [self.navigationController.view addSubview:_activityIndicator];
            _activityIndicator.delegate = self;
            _activityIndicator.labelText = kLoading;
            _activityIndicator.square = YES;
        }
    return _activityIndicator;
}
#pragma mark API Call

-(void)apiCall
{
    [self.activityIndicator show:YES];
    NSString *urlString  = self.txtURL.text;
    __weak MACYAcronymListViewController *weakSelf = self;
    [DataManager fetchAcronymsForString:urlString withCompletionHandaler:^(id responseData, NSError *error) {
        if (responseData) {
            weakSelf.dataSourceArray = (NSMutableArray *)responseData;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                [weakSelf.activityIndicator hide:YES];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf handleError:error];
                [weakSelf.activityIndicator hide:YES];
            });
            
        }
    }];
}

-(void)handleError:(NSError *)error{
   
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:kError
                                  message:[error localizedDescription]
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:kOK
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];

}

-(void)addRefreshControl
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl setTintColor:[UIColor magentaColor]];
    [refreshControl addTarget:self action:@selector(updateTable) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
}

-(void)internalSetUP
{
    self.txtURL.text = @"FBI";
    [self addRefreshControl];
}
-(void)awakeFromNib
{
    [self internalSetUP];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self apiCall];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MACYAcronymListCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier forIndexPath:indexPath];
    NSDictionary *dict = self.dataSourceArray[indexPath.row];
    [cell setDataWithDict:dict];
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.dataSourceArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark IBAction

- (IBAction)goButtonTapped:(id)sender
{
    if ([self isValidText]) {
        [self.txtURL resignFirstResponder];
        [self apiCall];
    }else{
        [self requiredFieldError];
    }
    
}

-(BOOL)isValidText
{
    // There could be some other validations as well, like checking for special characters etc.
    BOOL retValue = NO;
    if ([self.txtURL.text isEqualToString:@""]) {
        retValue = NO;
    }else{
        retValue = YES;
    }
    return retValue;
}

-(void)requiredFieldError{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:kError
                                  message:kMessage
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:kOK
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma maek Update Table
#pragma mark Private Method

-(void)updateTable
{
    [self.activityIndicator show:YES];
    NSString *urlString  = self.txtURL.text;
    __weak MACYAcronymListViewController *weakSelf = self;
    [DataManager fetchAcronymsForString:urlString withCompletionHandaler:^(id responseData, NSError *error) {
        if (responseData) {
           
            weakSelf.dataSourceArray = (NSMutableArray *)responseData;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                [weakSelf.activityIndicator hide:YES];
                [weakSelf.refreshControl endRefreshing];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf handleError:error];
                [weakSelf.activityIndicator hide:YES];
                [weakSelf.refreshControl endRefreshing];
            });
            
        }
    }];
}

@end
