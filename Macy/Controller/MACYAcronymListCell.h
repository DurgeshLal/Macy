//
//  MACYAcronymListCell.h
//  Macy
//
//  Created by Durgesh Gupta on 9/30/15.
//  Copyright © 2015 Durgesh Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MACYAcronymListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblAcronym;

-(void)setDataWithDict:(NSDictionary *)dict;
@end
