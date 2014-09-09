//
//  ADBParseWKT.m
//  Mapbox iOS SDK+WKT
//
//  Created by Lyubomir Marinov on 08.09.2014
//  Copyright (c) 2014 github.com/awedeebawe
//  All rights reserved.
//

#import "ADBParseWKT.h"
#import "ADBViewController.h"
#import <Mapbox/Mapbox.h>

@implementation ADBParseWKT

-(id)initWithMapView:(RMMapView *)mapView {
    self = [super init];
    
    if(self)
    {
        self.map = mapView;
    }
    return self;
}

-(void)processWKT:(NSString *)WKTstring {
    if([WKTstring rangeOfString:@"POINT"].location == 0) {
        [self processPoint:WKTstring];
    }
    else if ([WKTstring rangeOfString:@"LINESTRING"].location == 0) {
        [self processLinestring:WKTstring];
    }
    else if([WKTstring rangeOfString:@"POLYGON"].location == 0) {
        [self processPolygon:WKTstring];
    }
    else if([WKTstring rangeOfString:@"MULTIPOINT"].location == 0) {
        [self processMultipoint:WKTstring];
    }
    else if([WKTstring rangeOfString:@"MULTILINESTRING"].location == 0) {
        [self processMultilinestring:WKTstring];
    }
    else if([WKTstring rangeOfString:@"MULTIPOLYGON"].location == 0) {
        [self processMultipolygon:WKTstring];
    }
    else if([WKTstring rangeOfString:@"GEOMETRYCOLLECTION"].location == 0) {
        NSLog(@"The GEOMETRYCOLLECTION support was dropped before the initial commit. To get the old files, write me at e-mail: marinov@consultant.com");
    }
    else {
        NSLog(@"This type of geometry is not yet supported");
    }
}

-(void)processPoint:(NSString *)point {
    NSArray *coords = [self getCoordinates:point];
    for(int i = 0; i < [coords count]; i++) {
        NSArray *points = [[coords objectAtIndex:i] componentsSeparatedByString:@" "];
        NSString *lat = [points objectAtIndex:0];
        NSString *lng = [points objectAtIndex:1];
    
        CLLocation *markerLatLng = [[CLLocation alloc] initWithLatitude:[lat floatValue] longitude:[lng floatValue]];
        
        // initialize the marker...
        RMPointAnnotation *marker = [[RMPointAnnotation alloc] initWithMapView:self.map coordinate:markerLatLng.coordinate andTitle:nil];
        [self.map addAnnotation:marker];
    }
}

-(void)processLinestring:(NSString *)lineString {
    NSArray *coords = [self getCoordinates:lineString];
    
    NSMutableArray *linePoints = [[NSMutableArray alloc] init];

    for(int i = 0; i < [coords count]; i++) {
        NSArray *points = [[coords objectAtIndex:i] componentsSeparatedByString:@" "];
        NSString *lat = [points objectAtIndex:1];
        NSString *lng = [points objectAtIndex:0];
        CLLocation *lineLatLng = [[CLLocation alloc] initWithLatitude:[lat floatValue] longitude:[lng floatValue]];
        [linePoints addObject:lineLatLng];
    }
    
    // initialize the polyline...
    RMPolylineAnnotation *polyline = [[RMPolylineAnnotation alloc] initWithMapView:self.map points:linePoints];
    [self.map addAnnotation:polyline];
}

-(void)processPolygon:(NSString *)polygon {
    
    // check if the polygon has interior ring
    if([polygon rangeOfString:@"),("].location == NSNotFound) {
        NSMutableArray *polygonPoints = [[NSMutableArray alloc] init];
        NSArray *coords = [self getCoordinates:polygon];
        
        for(int i = 0; i < [coords count]; i++) {
            NSArray *points = [[coords objectAtIndex:i] componentsSeparatedByString:@" "];
            NSString *lat = [points objectAtIndex:1];
            NSString *lng = [points objectAtIndex:0];
            CLLocation *lineLatLng = [[CLLocation alloc] initWithLatitude:[lat floatValue] longitude:[lng floatValue]];
            [polygonPoints addObject:lineLatLng];
        }
        
        // initialize the polygon...
        RMPolygonAnnotation *polygon = [[RMPolygonAnnotation alloc] initWithMapView:self.map points:polygonPoints];
        [self.map addAnnotation:polygon];
    } else {
        NSMutableArray *polygonPoints = [[NSMutableArray alloc] init];
        // Mutable array to store the interior rings
        NSMutableArray *interiorRings = [[NSMutableArray alloc] init];
        
        // easy split hack (that we used with the GeometryCollections)
        polygon = [polygon stringByReplacingOccurrencesOfString:@")," withString:@")||"];
        NSArray *polygons = [polygon componentsSeparatedByString:@"||"];
        
        // first, let's process the interior rings
        for(int i = 1; i < [polygons count]; i++) {
            NSMutableArray *interiorPolygonPoints = [[NSMutableArray alloc] init];
            NSString *interiorRing = [polygons objectAtIndex:i];
            NSArray *coords = [self getCoordinates:interiorRing];
            
            for(int i = 0; i < [coords count]; i++) {
                NSArray *points = [[coords objectAtIndex:i] componentsSeparatedByString:@" "];
                NSString *lat = [points objectAtIndex:1];
                NSString *lng = [points objectAtIndex:0];
                CLLocation *lineLatLng = [[CLLocation alloc] initWithLatitude:[lat floatValue] longitude:[lng floatValue]];
                [interiorPolygonPoints addObject:lineLatLng];
            }
            
            // initialize the polygon...
            RMPolygonAnnotation *interiorPolygon = [[RMPolygonAnnotation alloc] initWithMapView:self.map points:interiorPolygonPoints];
            [interiorRings addObject:interiorPolygon];
        }
        
        // now the outer ring
        NSString *exteriorRing = [polygons objectAtIndex:0];
        NSArray *coords = [self getCoordinates:exteriorRing];
        
        for(int i = 0; i < [coords count]; i++) {
            NSArray *points = [[coords objectAtIndex:i] componentsSeparatedByString:@" "];
            NSString *lat = [points objectAtIndex:1];
            NSString *lng = [points objectAtIndex:0];
            CLLocation *lineLatLng = [[CLLocation alloc] initWithLatitude:[lat floatValue] longitude:[lng floatValue]];
            [polygonPoints addObject:lineLatLng];
        }
        
        // initialize the polygon...
        RMPolygonAnnotation *polygon = [[RMPolygonAnnotation alloc] initWithMapView:self.map points:polygonPoints interiorPolygons:interiorRings];
        [self.map addAnnotation:polygon];
    }
}

-(void)processMultipoint:(NSString *)multipoint {
    NSArray *points = [multipoint componentsSeparatedByString:@","];
    for(int i = 0; i < [points count]; i++) {
        [self processPoint:[points objectAtIndex:i]];
    }
}

-(void)processMultilinestring:(NSString *)multilinestring {
    NSArray *multilines = [multilinestring componentsSeparatedByString:@"),("];
    for(int i = 0; i < [multilines count]; i++) {
        [self processLinestring:[multilines objectAtIndex:i]];
    }
}

-(void)processMultipolygon:(NSString *)multipolygon {
    NSArray *multipolygons = [multipolygon componentsSeparatedByString:@")),(("];
    for(int i = 0; i < [multipolygons count]; i++) {
        [self processPolygon:[multipolygons objectAtIndex:i]];
    }
}

-(NSMutableArray *)getCoordinates:(NSString *)WKT {
    // This method is originaly developed by Joel Turnbull @ https://github.com/joelturnbull/
    NSMutableArray *coordinates = [[NSMutableArray alloc] init];
    
    NSError *error = nil;
    NSString *regexString = @"([-\\d\\.]+\\s[-\\d\\.]+)";
    
    NSRegularExpression *coordRegex = [NSRegularExpression regularExpressionWithPattern:regexString options:0 error:&error];
    
    NSArray *coordinatesStrings = [coordRegex matchesInString:WKT options:0 range: NSMakeRange(0, [WKT length])];
    
    for (NSTextCheckingResult *match in coordinatesStrings) {
        NSRange matchRange = [match rangeAtIndex:1];
        [coordinates addObject:[WKT substringWithRange:matchRange]];
    }
    
    return coordinates;
}

@end
