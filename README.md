FSInteractiveMap
================

A charting library to visualize data on a map. It's like geochart but for iOS!

Screenshots
---
<img src="Screenshots/screen00.png" width="320px" />&nbsp;<img src="Screenshots/screen01.png" width="320px" />&nbsp;<img src="Screenshots/screen02.png" width="320px" />

How to use
---
FSInteractiveMap is a subclass of UIView so it can be added as regular view. It's basically loading a map from a SVG file. There are a few by default but you can add any SVG you like.

```objc
NSDictionary* data = @{	@"asia" : @12,
                        @"australia" : @2,
                        @"north_america" : @5,
                        @"south_america" : @14,
                        @"africa" : @5,
                        @"europe" : @20
                      };
    
FSInteractiveMapView* map = [[FSInteractiveMapView alloc] initWithFrame:self.view.frame];

[map loadMap:@"world-continents-low" withData:data colorAxis:@[[UIColor lightGrayColor], [UIColor darkGrayColor]]];

[map setClickHandler:^(NSString* identifier, CAShapeLayer* layer) {
    self.detailDescriptionLabel.text = [NSString stringWithFormat:@"Continent clicked: %@", identifier];
}];
```