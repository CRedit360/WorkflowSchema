//
//  WFSMacros.h
//  WorkflowSchema
//
//  Created by Simon Booth on 14/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#define WFSLocalizedString(K, V) [[NSBundle bundleForClass:[self class]] localizedStringForKey:K value:V table:@"WorkflowSchema"]
#define WFSCastOrNil(X, C) ([X isKindOfClass:[C class]] ? (C *)X : nil)