//
//  WSTAssert.h
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 26/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//
// There are some tests that we'd have liked to see as proper unit tests,
// but which rely on the application environment to exist.  So instead we
// run them as a step in a KIF scenario.

/* nested macro to get the value of the macro, not the macro name */
#define WST_MACRO_VALUE_TO_STRING_( m ) #m
#define WST_MACRO_VALUE_TO_STRING( m ) WST_MACRO_VALUE_TO_STRING_( m )

#define WSTFailOnError(E) { if (E) { if (outError) *outError = E; return KIFTestStepResultFailure; } }
#define WSTAssert(X) if (!(X)) { if (outError) *outError = WFSError(@"Assertion failed at line %d: " WST_MACRO_VALUE_TO_STRING(X), __LINE__); return KIFTestStepResultFailure; }

#define WSTAssertEqualImages(X, Y) WSTAssert( [UIImagePNGRepresentation(X) isEqual:UIImagePNGRepresentation(Y)] )