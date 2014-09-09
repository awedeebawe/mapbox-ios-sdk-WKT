mapbox-ios-sdk-WKT
==================

SUMMARY
-------
This is a class that adds WKT (Well-Known Text) geometry support for Mapbox iOS SDK.


Currently supported geometries:

 * POINT
 * MULTIPOINT
 * LINESTRING
 * MULTILINESTRING
 * POLYGON
 * MULTIPOLYGON

USAGE
-----
To use this class just add the following code in the begining of your UIView / AppDelegate .m file:
```
#import "ADBParseWKT.h"
```
and then after you initialize your MapView object add the following code:
```
NSString *sampleWKT = @"MULTIPOLYGON(((35 35,15 40,40 25,35 35)),((31 22,13 34,3 30,2 9,18 6,31 22),(20 20,10 15,10 25,20 20)))";

ADBParseWKT *parser = [[ADBParseWKT alloc] initWithMapView:mapView];
[parser processWKT:sampleWKT];
```
and voilà! You have your first polygons on your map!

Or you can use directly use the internal public methods as follows:
```
// POINT
[parser processPoint:sampleWKT];
// LINESTRING
[parser processLinestring:sampleWKT];
// POLYGON
[parser processPolygon:sampleWKT];
// MULTIPOINT
[parser processMultipoint:sampleWKT];
// MULTILINESTRING
[parser processMultilinestring:sampleWKT];
// MULTIPOLYGON
[parser processMultipolygon:sampleWKT];
```

TODO
----
Initially it was written to support also GEOMETRYCOLLECTION geometries, but later I dropped it (_it was written in a hurry and it was based on some ugly string manipulations._). In the future I may add improved support for GEOMETRYCOLLECTION plus additional geometry tipes if possible.
