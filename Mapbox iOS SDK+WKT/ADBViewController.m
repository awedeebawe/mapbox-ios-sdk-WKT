//
//  ADBViewController.m
//  Mapbox iOS SDK+WKT
//
//  Created by Lyubomir Marinov on 08.09.2014
//  Copyright (c) 2014 github.com/awedeebawe
//  All rights reserved.
//

#import "ADBViewController.h"
#import "ADBParseWKT.h"
#import <Mapbox/Mapbox.h>

@interface ADBViewController ()

@end

@implementation ADBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Create tile server
    RMMapboxSource *tileServer = [[RMMapboxSource alloc] initWithMapID:@"examples.map-i86nkdio"];
    
    // initialize map
    RMMapView *mapView = [[RMMapView alloc] initWithFrame:self.view.frame andTilesource:tileServer];
    mapView.centerCoordinate = CLLocationCoordinate2DMake(35.0f, 27.0f);
    mapView.zoom = 3.0f;
    
    [self.view addSubview:mapView];
    
    // IMPORTANT: you MUST set this Autoresizing options, so the Map View will resize on device rotation!!! (P.S. this feature is missing in MapBox default SDK tutorials)
    [mapView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    NSString *multiPoint = @"MULTIPOINT((12 32),(42 22),(52 32))";
    NSString *multiLineString = @"MULTILINESTRING((49 39,36 48),(39 33,47 30,51 20,34 10))";
    NSString *multiPolygon = @"MULTIPOLYGON(((35 35,15 40,40 25,35 35)),((31 22,13 34,3 30,2 9,18 6,31 22),(20 20,10 15,10 25,20 20)))";
    
    ADBParseWKT *parser = [[ADBParseWKT alloc] initWithMapView:mapView];
    
    // EXAMPLES:
    
    // 1. Show the MULTIPOINT geometries
    [parser processWKT:multiPoint];
    // 2. Show the MULTILINESTRING geometries
    [parser processWKT:multiLineString];
    // 3. Show the MULTIPOLYGON geometries
    [parser processWKT:multiPolygon];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
