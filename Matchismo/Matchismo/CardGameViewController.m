//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Waiel Eid on 2/9/13.
//  Copyright (c) 2013 NextGen. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong,nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (weak, nonatomic) IBOutlet UISwitch *gameMode;
@property (strong, nonatomic) IBOutlet UISlider *historySlider;
@end

@implementation CardGameViewController


- (CardMatchingGame *)game
{
    if(!_game) _game= [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count gameMode:(self.gameMode.on ? 2:1) usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}


- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}


//update interface.
- (void)updateUI
{
   
    
    for(UIButton *cardButton in self.cardButtons){
        Card *card = [self.game  cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.unplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0 ;
        
        if(!cardButton.selected){
            [cardButton setImage:[UIImage imageNamed:@"card.jpg"] forState:UIControlStateNormal];
        }else{
            [cardButton setImage:nil forState:UIControlStateNormal];
        }

    }
    self.historySlider.maximumValue = (float) self.game.gameHistory.count-1;
    self.historySlider.value = self.historySlider.maximumValue;
    self.descriptionLabel.alpha = 1.0;
    self.descriptionLabel.text = [self.game.gameHistory lastObject];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
    self.flipLabel.text = [NSString stringWithFormat:@"Flips: %d",self.game.flipCount];

}


- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.gameMode.enabled = NO;
    [self updateUI];
}


// reset game.
- (IBAction)dealGame {
    self.game = nil;
    self.historySlider.minimumValue=0;
    self.gameMode.enabled = YES;
    [self updateUI];
}
- (IBAction)historySlider:(UISlider *)sender {
    self.descriptionLabel.text = self.game.gameHistory[(int) sender.value];
    self.descriptionLabel.alpha = 0.3;
}

- (IBAction)gameModeSwitch:(UISwitch *)sender {
    [self dealGame];
}

@end
