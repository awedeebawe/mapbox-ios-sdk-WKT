//
//  ADBParseWKT.h
//  Mapbox iOS SDK+WKT
//
//  Created by Lyubomir Marinov on 08.09.2014
//  Copyright (c) 2014 github.com/awedeebawe
//  All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mapbox/Mapbox.h>

@interface ADBParseWKT : NSObject

@property (nonatomic, strong) NSMutableArray *geometries;
@property (nonatomic, strong) RMMapView *map;

-(id)initWithMapView:(RMMapView *)mapView;

-(void)processWKT:(NSString *)WKTstring;
-(void)processPoint:(NSString *)point;
-(void)processLinestring:(NSString *)lineString;
-(void)processPolygon:(NSString *)polygon;
-(void)processMultipoint:(NSString *)multipoint;
-(void)processMultilinestring:(NSString *)multilinestring;
-(void)processMultipolygon:(NSString *)multipolygon;

@end
