//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Peter Lyons on 6/25/13.
//  Copyright (c) 2013 Peter Lyons. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutlet UIButton *cardButton;
@property (weak, nonatomic) IBOutlet UILabel *currentPlay;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *nGButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSwitch;
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation CardGameViewController


- (CardMatchingGame *)game
{
    if (!_game){
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[PlayingCardDeck alloc] init]];
        [self modeSwitch:self.gameModeSwitch];
    }
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (IBAction)newGame: (UIButton *)sender
{
    self.game = nil;
    self.flipCount = 0;
    self.gameModeSwitch.enabled = YES;
    [self updateUI];
}
- (void)updateUI
{
    UIImage *cardBackImage = [UIImage imageNamed:@"cardback.png"];
    for(UIButton *cardButton in self.cardButtons)
    {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState: UIControlStateSelected];
        [cardButton setTitle:card.contents forState: UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
        
        if (!card.isFaceUp)
        {
            [cardButton setImage:cardBackImage forState:UIControlStateNormal];
        } else {
            [cardButton setImage:nil forState:UIControlStateNormal];
        }

    }
    self.currentPlay.text = self.game.play;
    self.scoreLabel.text = [NSString stringWithFormat: @"Score: %d", self.game.score];
}

- (IBAction)modeSwitch: (UISegmentedControl *)sender
{
    switch ([sender selectedSegmentIndex]) {
        case 0:
            self.game.numberOfMatchingCards = 2;
            break;
        case 1:
            self.game.numberOfMatchingCards = 3;
            break;
        default:
            self.game.numberOfMatchingCards = 2;
            break;
    }
}




- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    self.gameModeSwitch.enabled = NO;
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
    
}


@end
