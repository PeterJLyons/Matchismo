//
//  Deck.h
//  Matchismo
//
//  Created by Peter Lyons on 6/26/13.
//  Copyright (c) 2013 Peter Lyons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (Card *)drawRandomCard;

@end