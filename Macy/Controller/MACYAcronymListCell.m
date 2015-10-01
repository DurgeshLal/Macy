//
//  MACYAcronymListCell.m
//  Macy
//
//  Created by Durgesh Gupta on 9/30/15.
//  Copyright © 2015 Durgesh Gupta. All rights reserved.
//

#import "MACYAcronymListCell.h"

@implementation MACYAcronymListCell

-(void)setDataWithDict:(NSDictionary *)dict{
    self.lblAcronym.text = dict[@"lf"];
}

-(void)prepareForReuse{
    self.lblAcronym.text = @"";
}
@end
