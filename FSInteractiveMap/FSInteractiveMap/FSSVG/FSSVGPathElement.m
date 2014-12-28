//
//  FSSVGPathElement.m
//  FSInteractiveMap
//
//  Created by Arthur GUIBERT on 22/12/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import "FSSVGPathElement.h"
#import "FSSVGUtils.h"

@interface FSSVGPathElement()
@property (nonatomic) CGPoint lastPoint;
@end

@implementation FSSVGPathElement

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    _lastPoint.x = _lastPoint.y = 0;
    self.fill = NO;
    self.title = [attributes objectForKey:@"title"];
    self.identifier = [attributes objectForKey:@"id"];
    self.className = [attributes objectForKey:@"class"];
    self.tranform = [attributes objectForKey:@"transform"];
    self.path = nil;
    [self parsePathData:[attributes objectForKey:@"d"]];
    [FSSVGUtils parseTransform:self.tranform];
    
    // Check the fill attribute
    if([attributes objectForKey:@"fill"] && [[attributes objectForKey:@"fill"] isEqualToString:@"none"]) {
        self.fill = NO;
    }
    
    return self;
}

- (void)parsePathData:(NSString*)pathData
{
    if(!pathData || [pathData length] == 0)
        return;
    
    self.path = [UIBezierPath bezierPath];
    
    // Old-schoold C parsing as it's simpler and has a lower overhead
    unsigned long dataLength = [pathData length];
    const char* p = [[pathData dataUsingEncoding:NSASCIIStringEncoding] bytes];
    
    // The value can't be longer than the path data
    char* value = malloc(dataLength * sizeof(char));
    unsigned int valueIndex = 0;
    
    char currentCommand = 0;
    
    for(int i=0;i<dataLength;i++)
    {
        if(isalpha(p[i]) && p[i] != 'e')
        {
            value[valueIndex] = '\0';
            if(valueIndex > 0)
                [self executeCommand:currentCommand forValue:value];
            valueIndex = 0;
            currentCommand = p[i];
            continue;
        }
        
        value[valueIndex++] = p[i];
    }
    
    value[valueIndex] = '\0';
    [self executeCommand:currentCommand forValue:value];
    
    free(value);
}

- (void)executeCommand:(char)command forValue:(const char*)value
{
    NSArray* coordinates = [FSSVGUtils parsePoints:value];
    
    if([coordinates count] == 0 && command != 'z' && command != 'Z')
        return;
    
    switch (command) {
        case 'M':
            [self executeMoveTo:coordinates absolute:YES];
            break;
        case 'm':
            [self executeMoveTo:coordinates absolute:NO];
            break;
            
        case 'L':
            [self executeLineTo:coordinates absolute:YES];
            break;
            
        case 'l':
            [self executeLineTo:coordinates absolute:NO];
            break;
            
        case 'H':
            [self executeHorizontalLineTo:coordinates absolute:YES];
            break;
            
        case 'h':
            [self executeHorizontalLineTo:coordinates absolute:NO];
            break;
            
        case 'V':
            [self executeVerticalLineTo:coordinates absolute:YES];
            break;
            
        case 'v':
            [self executeVerticalLineTo:coordinates absolute:NO];
            break;
            
        case 'c':
            [self executeCurveTo:coordinates absolute:NO];
            break;
            
        case 'C':
            [self executeCurveTo:coordinates absolute:YES];
            break;
            
        case 'Z':
        case 'z':
            [_path closePath];
            self.fill = YES;
            break;
            
        default:
            NSLog(@"Warning: Unknown command %c",command);
            break;
    }
        
}

- (void)executeMoveTo:(NSArray*)coordinates absolute:(BOOL)isAbsolute
{
    for(int i=0;i<[coordinates count] / 2;i++) {
        CGPoint p;
        
        // Bounds checking
        if(i * 2 + 2 > [coordinates count])
            return;
        
        p.x = [coordinates[i * 2] floatValue];
        p.y = [coordinates[i * 2 + 1] floatValue];
        
        if(isAbsolute)
            _lastPoint = p;
        else
            _lastPoint = CGPointMake(p.x + _lastPoint.x, p.y + _lastPoint.y);
        
        [_path moveToPoint:_lastPoint];
    }
}

- (void)executeLineTo:(NSArray*)coordinates absolute:(BOOL)isAbsolute
{
    for(int i=0;i<[coordinates count] / 2;i++) {
        CGPoint p;
        
        // Bounds checking
        if(i * 2 + 2 > [coordinates count])
            return;
        
        p.x = [coordinates[i * 2] floatValue];
        p.y = [coordinates[i * 2 + 1] floatValue];
        
        if(isAbsolute)
            _lastPoint = p;
        else
            _lastPoint = CGPointMake(p.x + _lastPoint.x, p.y + _lastPoint.y);
        
        [_path addLineToPoint:_lastPoint];
    }
}

- (void)executeHorizontalLineTo:(NSArray*)coordinates absolute:(BOOL)isAbsolute
{
    for(int i=0;i<[coordinates count];i++) {

        // Bounds checking
        if(i + 1 > [coordinates count])
            return;
        
        float value = [coordinates[i * 2] floatValue];
        
        if(isAbsolute)
            _lastPoint.x = value;
        else
            _lastPoint = CGPointMake(value + _lastPoint.x, _lastPoint.y);
        
            
        [_path addLineToPoint:_lastPoint];
    }
}

- (void)executeVerticalLineTo:(NSArray*)coordinates absolute:(BOOL)isAbsolute
{
    for(int i=0;i<[coordinates count];i++) {
        
        // Bounds checking
        if(i + 1 > [coordinates count])
            return;
        
        float value = [coordinates[i * 2] floatValue];
        
        if(isAbsolute)
            _lastPoint.y = value;
        else
            _lastPoint = CGPointMake(_lastPoint.x, value + _lastPoint.y);
        
        
        [_path addLineToPoint:_lastPoint];
    }
}

- (void)executeCurveTo:(NSArray*)coordinates absolute:(BOOL)isAbsolute
{
    for(int i=0;i<[coordinates count] / 6;i++) {
        CGPoint c1,c2,p;
        
        // Bounds checking
        if(i * 6 + 6 > [coordinates count])
            return;
        
        c1.x = [coordinates[i * 6] floatValue];
        c1.y = [coordinates[i * 6 + 1] floatValue];
        
        c2.x = [coordinates[i * 6 + 2] floatValue];
        c2.y = [coordinates[i * 6 + 3] floatValue];
        
        p.x = [coordinates[i * 6 + 4] floatValue];
        p.y = [coordinates[i * 6 + 5] floatValue];
        
        if(isAbsolute) {
            _lastPoint = CGPointMake(p.x, p.y);
            [_path addCurveToPoint:_lastPoint
                     controlPoint1:CGPointMake(c1.x, c1.y)
                     controlPoint2:CGPointMake(c2.x, c2.y)];
        } else {
            [_path addCurveToPoint:CGPointMake(_lastPoint.x + p.x, _lastPoint.y + p.y)
                     controlPoint1:CGPointMake(_lastPoint.x + c1.x, _lastPoint.y + c1.y)
                     controlPoint2:CGPointMake(_lastPoint.x + c2.x, _lastPoint.y + c2.y)];
            
            _lastPoint = CGPointMake(_lastPoint.x + p.x, _lastPoint.y + p.y);
        }
        
    }
}

@end
