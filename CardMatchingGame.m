//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Peter Lyons on 6/27/13.
//  Copyright (c) 2013 Peter Lyons. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic, readwrite) int score;
@property (nonatomic, readwrite) NSString *play;
@end

@implementation CardMatchingGame

- (int)numberOfMatchingCards
{
    if (!_numberOfMatchingCards) {
        _numberOfMatchingCards = 2;
    }
    return _numberOfMatchingCards;
}

- (void)setNumberOfMatchingCards:(int)numberOfMatchingCards
{
    if (numberOfMatchingCards < 2) _numberOfMatchingCards = 2;
    else if (numberOfMatchingCards > 3) _numberOfMatchingCards = 3;
    else _numberOfMatchingCards = numberOfMatchingCards;
}

@synthesize numberOfMatchingCards = _numberOfMatchingCards;

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self)
    {
        for(int i = 0; i < count; i++)
        {
            Card *card = [deck drawRandomCard];
            if(!card)
            {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
        
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

#define FLIP_COST 1
#define MISMATCH_PENALTY 2
#define MATCH_BONUS 4

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    _play = @"flipped up ";
    _play = [_play stringByAppendingString: card.contents];
    [_play stringByAppendingFormat: @" has been flipped."];
    if (!card.isUnplayable) {
        if(!card.isFaceUp){
            NSMutableArray *otherCards = [[NSMutableArray alloc] init];
            NSMutableArray *otherContents = [[NSMutableArray alloc] init];
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    [otherCards addObject:otherCard];
                    [otherContents addObject:otherCard.contents];
                }
            }
            if ([otherCards count] < self.numberOfMatchingCards - 1)
            {
                self.play = [NSString stringWithFormat: @"Flipped up %@", card.contents];
            } else {
                int matchScore = [card match:otherCards];
                if (matchScore) {
                    card.unplayable = YES;
                    for (Card *otherCard in otherCards)
                    {
                        otherCard.unplayable = YES;
                    }
                    self.score += matchScore * MATCH_BONUS;
                    self.score += matchScore * MATCH_BONUS;
                    _play = @"Match!";
                } else {
                    for (Card *otherCard in otherCards) {
                        otherCard.faceUp = NO;
                    }
                    self.score -= MISMATCH_PENALTY;
                    _play = @"Mismatch!";
                }
        }
         self.score -= FLIP_COST;
            
        }
    
    card.faceUp = !card.isFaceUp;
}
}


@end
