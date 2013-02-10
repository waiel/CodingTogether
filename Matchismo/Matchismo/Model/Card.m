//
//  Card.m
//  Matchismo
//
//  Created by Waiel Eid on 2/9/13.
//  Copyright (c) 2013 NextGen. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArray *)otherCards
{
    int score =0;
    
    for (Card *card in otherCards){
       
        if([card.contents isEqualToString:self.contents]){
            score=1;
        }
    }
        
    return score;
}

@end
