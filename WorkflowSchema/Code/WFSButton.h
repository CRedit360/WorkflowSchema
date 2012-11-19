//
//  RUIButton.h
//  RemoteUserInterface
//
//  Created by Simon Booth on 11/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFSSchematising.h"
#import "WFSAction.h"

@interface WFSButton : UIButton <WFSSchematising>

@property (nonatomic, strong) id message;
@property (nonatomic, copy) NSString *name;

@end
