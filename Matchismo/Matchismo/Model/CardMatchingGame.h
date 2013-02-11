//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Waiel Eid on 2/9/13.
//  Copyright (c) 2013 NextGen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject
//update initilization to take game mode
//- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck;

- (id)initWithCardCount:(NSUInteger)cardCount gameMode:(int)gameMode usingDeck:(Deck *)deck;

- (void)flipCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;


@property (nonatomic,readonly) int score;
@property (nonatomic) int flipCount;
@property (strong,nonatomic) NSMutableArray *gameHistory;
@end
