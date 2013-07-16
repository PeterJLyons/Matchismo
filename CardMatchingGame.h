//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Peter Lyons on 6/27/13.
//  Copyright (c) 2013 Peter Lyons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

-(id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck;

-(void)flipCardAtIndex:(NSUInteger)index;

-(Card *)cardAtIndex: (NSUInteger)index;


@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) NSString *play;
@property (strong, nonatomic) NSMutableArray *otherCards;
@property (nonatomic) int numberOfMatchingCards;
@end
