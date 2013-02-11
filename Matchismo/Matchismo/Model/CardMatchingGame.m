//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Waiel Eid on 2/9/13.
//  Copyright (c) 2013 NextGen. All rights reserved.
//

#import "CardMatchingGame.h"


@interface CardMatchingGame()
@property (strong,nonatomic) NSMutableArray *cards;
@property (nonatomic) int score;
@property (nonatomic) int gameMode;


@end

@implementation CardMatchingGame

//define statistics
#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST   1


- (NSMutableArray *)cards
{
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}


-(NSMutableArray *)gameHistory{
    
    if(!_gameHistory)
        _gameHistory = [NSMutableArray arrayWithObject:@"Match Cards by Suit or rank"];
    return _gameHistory;
}


//- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
- (id)initWithCardCount:(NSUInteger)count gameMode:(int)gamemode usingDeck:(Deck *)deck
{
    self = [super init];
    if(self){
        
        for (int i = 0; i < count; i++){
            Card *card = [deck drawRandomCard];
            if(!card){
                self = nil;
            }else{
                self.cards[i]=card;
            }
        }
        self.gameMode = gamemode;
        self.flipCount = 0;
    }
    return self;
}



- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

- (void)flipCardAtIndex:(NSUInteger)index
{
    
    Card *card = [self cardAtIndex:index];
    BOOL gameEnd = NO;
    
    if(!card.isUnplayable){
        if(!card.faceUp){
            
            NSMutableArray *otherCards = [[NSMutableArray alloc] init];
            NSMutableArray *played = [[NSMutableArray alloc] init];
            for(Card *otherCard in self.cards){
                if(otherCard.isFaceUp && !otherCard.isUnplayable){
                    
                    [otherCards addObject:otherCard];
                    //if number of flipped cards equels the game mode
                    if(otherCards.count == self.gameMode){
                        
                        int matchScore = [card match:otherCards];
                       
                        if(matchScore){
                            //set card to unplayable mode
                            
                            for(Card *ocard in otherCards){
                                ocard.unplayable = YES;
                                [played addObject:ocard.contents];
                            }
                            card.unplayable = YES;
                            self.score += matchScore * MATCH_BONUS * (self.gameMode);
                            [self.gameHistory addObject:[NSString stringWithFormat:@"Matched %@ %@ For %d points", card.contents,
                                [played componentsJoinedByString:@" "],
                                 matchScore * MATCH_BONUS * (self.gameMode)]
                            ];
                            gameEnd = YES;
                        }else{
                            //face down cards
                            
                            for(Card *ocard in otherCards){
                                ocard.faceUp = NO;
                                [played addObject:ocard.contents];
                                
                            }
                            
                            self.score -= MISMATCH_PENALTY;
                            [self.gameHistory addObject:[NSString stringWithFormat:@"%@ %@ doesn't match! lost %d points",
                                                         card.contents,
                                                         [played componentsJoinedByString:@" "],
                                                         MISMATCH_PENALTY]
                            ];
                            gameEnd = YES;
                        
                        }
                        
                    }else{
                        gameEnd = NO;
                    }
                }
                if(!gameEnd)
                [self.gameHistory addObject:[NSString stringWithFormat:@"You Flipped: %@",card.contents]];

            }
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
    }
    self.flipCount++;
    
}



///old method for flipCardAtIndex
//- (void)flipCardAtIndex:(NSUInteger)index
//{
//    
//    Card *card = [self cardAtIndex:index];
//    if(!card.isUnplayable){
//        if(!card.isFaceUp){
//            
//            //see if flipping this card up creates a match
//            for(Card *otherCards in self.cards){
//                if(otherCards.isFaceUp && !otherCards.isUnplayable){
//                   int matchScore = [card match:@[otherCards]];
//                        if(matchScore){
//                            otherCards.unplayable = YES;
//                            card.unplayable = YES;
//                            self.score += matchScore * MATCH_BONUS;
//                            [self.gameHistory addObject:[NSString stringWithFormat:@"You Matched %@ & %@ for %d",card.contents,otherCards.contents,matchScore * MATCH_BONUS]];    
//                            //self.description = [NSString stringWithFormat:@"You Matched %@ & %@ for %d",card.contents,otherCards.contents,matchScore * MATCH_BONUS];
//                        }else{
//                            otherCards.faceUp = NO;
//                            self.score -= MISMATCH_PENALTY;
//                            if(otherCards.isFaceUp){
//                                [self.gameHistory addObject:[NSString stringWithFormat:@"%@ & %@ Doesn't match %d penality",card.contents,otherCards.contents,MISMATCH_PENALTY]];
//                               // self.description = [NSString stringWithFormat:@"%@ & %@ Doesn't match %d penality",card.contents,otherCards.contents,MISMATCH_PENALTY];
//                            }else{
//                                
//                                [self.gameHistory addObject:[NSString stringWithFormat:@"You Flipped: %@",card.contents]];
//                               // self.description = [NSString stringWithFormat:@"You Flipped: %@",card.contents];
//                            }
//                        }
//            
//                    
//                    break;
//                }else{
//                    [self.gameHistory addObject:[NSString stringWithFormat:@"You Flipped: %@",card.contents]];
//                    //self.description = [NSString stringWithFormat:@"You Flipped: %@",card.contents];
//                }
//            }
//            self.score -= FLIP_COST;
//        }
//        card.faceUp = !card.isFaceUp;
//    }
//}
@end
