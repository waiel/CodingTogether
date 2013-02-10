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
@property (nonatomic) NSString *description;
@end

@implementation CardMatchingGame


- (NSMutableArray *)cards
{
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}


- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
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
        
    }
    return self;
}



- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}


#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST   1

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    if(!card.isUnplayable){
        if(!card.isFaceUp){
            //see if flipping this card up creates a match
            for(Card *otherCards in self.cards){
                if(otherCards.isFaceUp && !otherCards.isUnplayable){
                    int matchScore = [card match:@[otherCards]];
                    if(matchScore){
                        otherCards.unplayable = YES;
                        card.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                        self.description = [NSString stringWithFormat:@"You Matched %@ & %@ for %d",card.contents,otherCards.contents,matchScore * MATCH_BONUS];
                    }else{
                        otherCards.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        if(otherCards.isFaceUp){
                            self.description = [NSString stringWithFormat:@"%@ & %@ Doesn't match %d penality",card.contents,otherCards.contents,MISMATCH_PENALTY];
                            
                            
                        }else{
                            self.description = [NSString stringWithFormat:@"You Flipped: %@",card.contents];
                        }
                        
                        
                    }
                    
                    break;
                }else{
                    self.description = [NSString stringWithFormat:@"You Flipped: %@",card.contents];
                }
            }
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
    }
}
@end
