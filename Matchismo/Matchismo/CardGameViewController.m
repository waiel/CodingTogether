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
//@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
//@property (strong,nonatomic) Deck *deck;
@property (strong,nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (weak, nonatomic) IBOutlet UISwitch *gameMode;
@property (strong, nonatomic) IBOutlet UISlider *historySlider;
@end

@implementation CardGameViewController
//removed no need for it
//- (Deck *)deck
//{
//    if(!_deck){
//        _deck = [[PlayingCardDeck alloc] init];
//    }
//    return _deck;
//}



- (CardMatchingGame *)game
{
    if(!_game) _game= [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count gameMode:(self.gameMode ? 2:1) usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}


- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
// replaced with a updateUi method
//
//    for (UIButton *cardButton in cardButtons){
//        Card *card = [self.deck drawRandomCard];
//        [cardButton setTitle:card.contents forState:UIControlStateSelected];
//    }
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
        
    }
    self.historySlider.maximumValue = (float) self.game.gameHistory.count-1;
    self.historySlider.value = self.historySlider.maximumValue;
    self.descriptionLabel.text = [self.game.gameHistory lastObject];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
    self.flipLabel.text = [NSString stringWithFormat:@"Flips: %d",self.game.flipCount];

}

//update flip counter
//-(void)setFlipCount:(int)flipCount
//{
//    _flipCount = flipCount;
//   // self.flipLabel.text = [NSString stringWithFormat:@"Flips: %d",self.flipCount];
//   // NSLog(@"Flips updated to %d",self.flipCount);
//}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.historySlider.enabled = YES;
    self.dealButton.enabled = YES;
    self.gameMode.enabled = YES;
//    self.flipCount++;
    [self updateUI];
}


// reset game.
- (IBAction)dealGame {
    //reset game
    self.game = nil;
    
    //disable buttons & sliders
    self.historySlider.enabled = NO;
    self.historySlider.minimumValue=0;
    self.dealButton.enabled = NO;
    self.gameMode.enabled = NO;
    
    //update UI
    [self updateUI];
  //  self.descriptionLabel.text = @"";
}
- (IBAction)historySlider:(UISlider *)sender {
    self.descriptionLabel.text = self.game.gameHistory[(int) sender.value];
}

- (IBAction)gameModeSwitch:(UISwitch *)sender {
    [self dealGame];
}

@end
