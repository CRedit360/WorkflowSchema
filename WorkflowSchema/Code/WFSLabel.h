//
//  RUILabel.h
//  RemoteUserInterface
//
//  Created by Simon Booth on 11/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFSSchematising.h"

@interface WFSLabel : UILabel <WFSSchematising>

@property (nonatomic, copy) NSString *name;

@end
