//
//  WFSSchema+WFSDocumentation.m
//  WorkflowSchema
//
//  Created by Simon Booth on 23/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSSchema+WFSDocumentation.h"
#import "NSObject+WFSSchematising.h"
#import "WFSCondition.h"

@interface WFSSchema ()

+ (NSMutableDictionary *)registeredClasses;

@end

@implementation WFSSchema (WFSDocumentation)

#define Sort(X) [X sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]

+ (NSArray *)registeredTypesDescendingFromClass:(Class)baseClass
{
    NSMutableArray *types = [NSMutableArray array];
    NSDictionary *registeredClasses = [self registeredClasses];
    
    for (NSString *typeName in Sort(registeredClasses.allKeys))
    {
        Class registeredClass = registeredClasses[typeName];
        
        if ([registeredClass isSubclassOfClass:baseClass])
        {
            [types addObject:registeredClass];
        }
    }
    
    return types;
}

+ (NSArray *)registeredTypeNamesDescendingFromClass:(Class)baseClass
{
    NSMutableArray *typeNames = [NSMutableArray array];
    NSDictionary *registeredClasses = [self registeredClasses];
    
    for (NSString *typeName in Sort(registeredClasses.allKeys))
    {
        Class registeredClass = registeredClasses[typeName];
        
        if ([registeredClass isSubclassOfClass:baseClass])
        {
            [typeNames addObject:typeName];
        }
    }
    
    return typeNames;
}

+ (NSArray *)defaultClassesMatchingParameterName:(NSString *)parameterName inType:(Class)type
{
    NSMutableArray *classes = [NSMutableArray array];
    NSArray *defaultSchemaParameters = [type defaultSchemaParameters];
    
    for (NSArray *defaultSchemaParameter in defaultSchemaParameters)
    {
        if (![defaultSchemaParameter isKindOfClass:[NSArray class]] || (defaultSchemaParameter.count != 2))
        {
            [NSException raise:NSInternalInconsistencyException format:@"defaultSchemaParameters incorrectly defined for %@", type];
        }
        
        Class defaultType = defaultSchemaParameter[0];
        NSString *defaultName = defaultSchemaParameter[1];
        
        if ([defaultName isEqualToString:parameterName])
        {
            [classes addObject:defaultType];
        }
    }
    
    return classes;
}

#pragma mark - DTD

+ (NSString *)elementDeclarationForPossibleChildren:(NSArray *)children
{
    // Parameter proxies can have defaults and templates. Conditional schemata can have success or failure values and conditions.
    children = [children arrayByAddingObjectsFromArray:@[ @"default", @"template", @"successValue", @"failureValue", @"condition" ]];
    children = [children arrayByAddingObjectsFromArray:[self registeredTypeNamesDescendingFromClass:[WFSCondition class]]];
    
    NSString *declaration = [Sort(children) componentsJoinedByString:@"|"];
    
    // If it can contain a string tag, it can contain a bare string
    if ([children containsObject:@"string"]) declaration = [@"#PCDATA|" stringByAppendingString:declaration];
    return declaration;
}

+ (NSString *)documentTypeDescription
{
    NSMutableString *documentTypeDescription = [NSMutableString string];
    
    // We require the workflow to contain exactly one controller
    NSMutableSet *possibleWorkflowChildren = [NSMutableSet set];
    for (NSString *typeName in [self registeredTypeNamesDescendingFromClass:[UIViewController class]])
    {
        [possibleWorkflowChildren addObject:typeName];
    }
    NSString *declaration = [self elementDeclarationForPossibleChildren:possibleWorkflowChildren.allObjects];
    [documentTypeDescription appendString:@"<!-- DOCUMENT ROOT -->\n"];
    [documentTypeDescription appendFormat:@"<!ELEMENT workflow (%@) >\n\n", declaration];
    
    [documentTypeDescription appendString:@"<!-- OBJECT ELEMENTS -->\n\n"];
    
    NSDictionary *registeredClasses = [self registeredClasses];
    NSMutableDictionary *possibleParameterChildren = [NSMutableDictionary dictionary];
    NSMutableDictionary *possibleParameterParents = [NSMutableDictionary dictionary];
    for (NSString *objectTypeName in Sort(registeredClasses.allKeys))
    {
        NSMutableSet *possibleObjectChildren = [NSMutableSet set];
        Class objectClass = registeredClasses[objectTypeName];
        [documentTypeDescription appendFormat:@"<!-- %@ maps to %@ -->\n", objectTypeName, objectClass];
        
        NSDictionary *parameters = [objectClass schemaParameterTypes];
        for (NSString *parameterName in parameters.allKeys)
        {
            // Whatever happens, you can have a child with the parameter name.
            [possibleObjectChildren addObject:parameterName];
            
            // if there's a default for the parameter, you can also have the default types as bare schemata
            for (Class matchingClass in [self defaultClassesMatchingParameterName:parameterName inType:objectClass])
            {
                for (NSString *typeName in [self registeredTypeNamesDescendingFromClass:matchingClass])
                {
                    [possibleObjectChildren addObject:typeName];
                }
            }
            
            // if a class is registered with the same name, then the schema will always contain WFSSchema objects rather than WFSSchemaParameter objects.  So we don't need to worry about their children because we'll handle them elsewhere in this loop.
            if (registeredClasses[parameterName])
            {
                continue;
            }
            
            
            NSMutableSet *parents = possibleParameterParents[parameterName];
            if (!parents)
            {
                parents = [NSMutableSet set];
                possibleParameterParents[parameterName] = parents;
            }
            [parents addObject:objectTypeName];
            
            NSMutableSet *children = possibleParameterChildren[parameterName];
            if (!children)
            {
                children = [NSMutableSet set];
                possibleParameterChildren[parameterName] = children;
            }
            
            NSArray *parameterTypes = [parameters[parameterName] flattenedArray];
            
            for (Class parameterType in parameterTypes)
            {
                for (NSString *parameterTypeName in [self registeredTypeNamesDescendingFromClass:parameterType])
                {
                    [children addObject:parameterTypeName];
                }
            }
        }
        
        NSString *declaration = [self elementDeclarationForPossibleChildren:possibleObjectChildren.allObjects];
        [documentTypeDescription appendFormat:@"<!ELEMENT %@ %@ >\n", objectTypeName, (declaration.length > 0) ? [NSString stringWithFormat:@"(%@)*", declaration] : @"EMPTY"];
        [documentTypeDescription appendFormat:@"<!ATTLIST %@\nname CDATA #IMPLIED\nconditional CDATA #IMPLIED\nclass CDATA #IMPLIED\nkeyPath CDATA #IMPLIED\nvalueName CDATA #IMPLIED\n>\n\n", objectTypeName];
    }
    
    [documentTypeDescription appendString:@"<!-- PARAMETER ELEMENTS -->\n\n"];
    for (NSString *parameterName in Sort(possibleParameterChildren.allKeys))
    {
        NSSet *children = possibleParameterChildren[parameterName];
        NSString *declaration = [self elementDeclarationForPossibleChildren:children.allObjects];
        
        NSSet *parents = possibleParameterParents[parameterName];
        
        [documentTypeDescription appendFormat:@"<!-- %@ appears in %@ -->\n", parameterName, [Sort(parents.allObjects) componentsJoinedByString:@","]];
        [documentTypeDescription appendFormat:@"<!ELEMENT %@ (%@)* >\n\n", parameterName, declaration];
    }
    
    [documentTypeDescription appendString:@"<!-- PARAMETER PROXY ELEMENTS -->\n\n"];
    NSString *parameterProxyDeclaration = [self elementDeclarationForPossibleChildren:registeredClasses.allKeys];
    [documentTypeDescription appendFormat:@"<!ELEMENT default (%@)* >\n", parameterProxyDeclaration];
    [documentTypeDescription appendFormat:@"<!ELEMENT template (%@)* >\n", parameterProxyDeclaration];
    [documentTypeDescription appendFormat:@"<!ELEMENT successValue (%@)* >\n", parameterProxyDeclaration];
    [documentTypeDescription appendFormat:@"<!ELEMENT failureValue (%@)* >\n", parameterProxyDeclaration];
    
    return documentTypeDescription;
}

#pragma mark - XSD

+ (BOOL)objectTypeCanContainText:(Class)objectType
{
    for (NSArray *defaultParameter in [objectType defaultSchemaParameters])
    {
        Class defaultParameterClass = defaultParameter[0];
        
        if ([[NSString class] isSubclassOfClass:defaultParameterClass])
        {
            return YES;
        }
    }
    
    return NO;
}

+ (NSString *)choicesForParameterName:(NSString *)parameterName indent:(NSString *)indent
{
    NSMutableString *choices = [NSMutableString string];
    
    Class parameterType = [self registeredClassForTypeName:parameterName];
    [choices appendFormat:@"%@<xsd:element name=\"%@\" type=\"%@\" />\n", indent, parameterName, parameterType];
    
    return choices;
}

+ (NSString *)xmlSchemaDefinition
{
    NSDictionary *registeredClasses = [self registeredClasses];
    
    NSMutableString *xmlSchemaDefinition = [NSMutableString string];
    [xmlSchemaDefinition appendString:@"<xsd:schema xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">\n\n"];
    
    [xmlSchemaDefinition appendString:@"<!-- DOCUMENT ROOT -->\n"];
    [xmlSchemaDefinition appendString:@"<xsd:element name=\"workflow\">\n"];
    
    // We require the workflow to contain exactly one controller
    [xmlSchemaDefinition appendString:@"  <xsd:complexType>\n"];
    [xmlSchemaDefinition appendString:@"    <xsd:choice>\n"];
    for (NSString *controllerTypeName in [self registeredTypeNamesDescendingFromClass:[UIViewController class]])
    {
        Class controllerType = registeredClasses[controllerTypeName];
        [xmlSchemaDefinition appendFormat:@"      <xsd:element name=\"%@\" type=\"%@\" />\n", controllerTypeName, controllerType];
    }
    [xmlSchemaDefinition appendString:@"    </xsd:choice>\n"];
    [xmlSchemaDefinition appendString:@"  </xsd:complexType>\n"];
    [xmlSchemaDefinition appendString:@"</xsd:element>\n\n"];
    
    NSMutableSet *emittedClasses = [NSMutableSet setWithCapacity:registeredClasses.count];
    
    for (NSString *objectTypeName in Sort(registeredClasses.allKeys))
    {
        Class objectType = registeredClasses[objectTypeName];
        BOOL objectMixed = [self objectTypeCanContainText:objectType];
        
        NSString *className = NSStringFromClass(objectType);
        if (![objectType isSchematisableClass]) className = [NSString stringWithFormat:@"%@ (abstract)", className];
        
        [xmlSchemaDefinition appendFormat:@"<!-- %@ maps to %@ -->\n", objectTypeName, className];
        if ([emittedClasses containsObject:objectType])
        {
            [xmlSchemaDefinition appendFormat:@"<!-- %@ was already emitted -->\n\n", objectType];
            continue;
        }
        else [emittedClasses addObject:objectType];
        
        [xmlSchemaDefinition appendFormat:@"<xsd:complexType name=\"%@\" %@>\n", objectType, (objectMixed ? @"mixed=\"true\"" : @"")];
        
        NSArray *descendantTypes = [self registeredTypesDescendingFromClass:objectType];
        NSArray *conditionTypes = [self registeredTypesDescendingFromClass:[WFSCondition class]];
        NSDictionary *parameters = @{
                @"default" : descendantTypes,
                @"template" : descendantTypes,
                @"successValue" : descendantTypes,
                @"failureValue" : descendantTypes,
                @"condition" : conditionTypes
        };
        
        if ([objectType isSchematisableClass])
        {
            parameters = [parameters dictionaryByAddingEntriesFromDictionary:[objectType schemaParameterTypes]];
        }
        
        if (parameters.count > 0)
        {
            [xmlSchemaDefinition appendString:@"  <xsd:choice minOccurs=\"0\" maxOccurs=\"unbounded\">\n"];
            
            for (NSString *parameterName in Sort(parameters.allKeys))
            {
                [xmlSchemaDefinition appendFormat:@"    <xsd:group ref=\"%@.%@\" />\n", objectType, parameterName];
            }
            
            [xmlSchemaDefinition appendString:@"  </xsd:choice>\n"];
        }
        
        if ([objectType isSchematisableClass])
        {
            [xmlSchemaDefinition appendString:@"  <xsd:attribute name=\"keyPath\" type=\"xsd:string\" />\n"];
            [xmlSchemaDefinition appendString:@"  <xsd:attribute name=\"valueName\" type=\"xsd:string\" />\n"];
            [xmlSchemaDefinition appendString:@"  <xsd:attribute name=\"name\" type=\"xsd:string\" />\n"];
            [xmlSchemaDefinition appendString:@"  <xsd:attribute name=\"conditional\" type=\"xsd:string\" />\n"];
            [xmlSchemaDefinition appendString:@"  <xsd:attribute name=\"class\" type=\"xsd:string\" />\n"];
        }
        else
        {
            [xmlSchemaDefinition appendString:@"  <xsd:attribute name=\"keyPath\" type=\"xsd:string\" use=\"required\" />\n"];
            [xmlSchemaDefinition appendString:@"  <xsd:attribute name=\"valueName\" type=\"xsd:string\" />\n"];
        }
        
        [xmlSchemaDefinition appendString:@"</xsd:complexType>\n\n"];
        
        for (NSString *parameterName in Sort(parameters.allKeys))
        {
            NSArray *parameterTypes = [parameters[parameterName] flattenedArray];
            
            BOOL parameterMixed = NO;
            for (Class type in parameterTypes)
            {
                if ([[NSString class] isSubclassOfClass:type]) parameterMixed = YES;
            }
            
            [xmlSchemaDefinition appendFormat:@"<xsd:group name=\"%@.%@\">\n", objectType, parameterName];
            [xmlSchemaDefinition appendString:@"  <xsd:choice>\n"];
            
            // anything defined as a default can appear in place of a parameter
            NSMutableSet *defaultTypeNames = [NSMutableSet set];
            
            for (Class defaultBaseType in [self defaultClassesMatchingParameterName:parameterName inType:objectType])
            {
                for (NSString *defaultTypeName in [self registeredTypeNamesDescendingFromClass:defaultBaseType])
                {
                    [defaultTypeNames addObject:defaultTypeName];
                }
            }
            
            // Conditions are default for conditionalSchema
            for (NSString *defaultTypeName in [self registeredTypeNamesDescendingFromClass:[WFSCondition class]])
            {
                [defaultTypeNames addObject:defaultTypeName];
            }
            
            for (NSString *defaultTypeName in Sort(defaultTypeNames.allObjects))
            {
                [xmlSchemaDefinition appendString:[self choicesForParameterName:defaultTypeName indent:@"    "]];
            }
            
            if (registeredClasses[parameterName])
            {
                // if there's a class registered to the parameter, that tag can appear; if it's a default, it already did.
                if (![defaultTypeNames containsObject:parameterName])
                {
                    [xmlSchemaDefinition appendString:[self choicesForParameterName:parameterName indent:@"    "]];
                }
            }
            else
            {
                NSMutableSet *registeredTypeNames = [NSMutableSet set];
                
                for (Class parameterType in parameterTypes)
                {
                    for (NSString *registeredTypeName in [self registeredTypeNamesDescendingFromClass:parameterType])
                    {
                        [registeredTypeNames addObject:registeredTypeName];
                    }
                }
                
                [xmlSchemaDefinition appendFormat:@"    <xsd:element name=\"%@\">\n", parameterName];
                [xmlSchemaDefinition appendFormat:@"      <xsd:complexType %@>\n", (parameterMixed ? @"mixed=\"true\"" : @"")];
                
                BOOL unbounded = [[(Class)objectType arraySchemaParameters] containsObject:parameterName];
                [xmlSchemaDefinition appendFormat:@"        <xsd:choice minOccurs=\"%@\" maxOccurs=\"%@\" >\n", (parameterMixed ? @"0" : @"1"), (unbounded ? @"unbounded" : @"1")];
                
                for (NSString *registeredTypeName in Sort(registeredTypeNames.allObjects))
                {
                    [xmlSchemaDefinition appendString:[self choicesForParameterName:registeredTypeName indent:@"          "]];
                }
                
                [xmlSchemaDefinition appendString:@"        </xsd:choice>\n"];
                [xmlSchemaDefinition appendString:@"      </xsd:complexType>\n"];
                [xmlSchemaDefinition appendString:@"    </xsd:element>\n"];
            }
            
            [xmlSchemaDefinition appendString:@"  </xsd:choice>\n"];
            [xmlSchemaDefinition appendString:@"</xsd:group>\n\n"];
        }
    }
    
    [xmlSchemaDefinition appendString:@"</xsd:schema>"];
    return xmlSchemaDefinition;
}

@end
