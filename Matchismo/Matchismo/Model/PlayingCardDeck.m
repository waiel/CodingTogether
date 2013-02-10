//
//  PlayingCardDeck.m
//  Matchismo
//
//  Created by Waiel Eid on 2/9/13.
//  Copyright (c) 2013 NextGen. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck

- (id) init
{
    self = [super init];
    
    if(self){
        for (NSString *suit in [PlayingCard validSuits]){
            for(NSUInteger rank =1 ; rank <= [PlayingCard maxRank];rank++){
                PlayingCard *card = [[PlayingCard alloc] init];
                card.rank = rank;
                card.suit = suit;
                [self addCard:card atTop:YES];
            }
        }
    }
    return self;
}
@end
