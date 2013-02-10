//
//  Deck.h
//  Matchismo
//
//  Created by Waiel Eid on 2/9/13.
//  Copyright (c) 2013 NextGen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL) atTop;

- (Card *)drawRandomCard;

@end
