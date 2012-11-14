//
//  WFSTableSection.h
//  WFSWorkflow
//
//  Created by Simon Booth on 17/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFSSchematising.h"

@interface WFSTableSection : NSObject <WFSSchematising>

@property (nonatomic, strong, readonly) NSString *headerTitle;
@property (nonatomic, strong, readonly) NSArray *cells;
@property (nonatomic, strong, readonly) NSString *footerTitle;

@end
