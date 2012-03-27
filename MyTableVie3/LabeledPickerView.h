//
//  LabeledPickerView.h
//  MyTableVie3
//
//  Created by Linus Lin on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LabeledPickerView : UIPickerView {
	NSMutableDictionary *labels;
}

@property (nonatomic, readonly) NSMutableDictionary * labels;
/** Adds the label for the given component. */
- (void) addLabel:(NSString *)labeltext forComponent:(NSUInteger)component forLongestString:(NSString *)longestString;
- (void) updateLabel:(NSString *)labeltext forComponent:(NSUInteger)component;

@end
