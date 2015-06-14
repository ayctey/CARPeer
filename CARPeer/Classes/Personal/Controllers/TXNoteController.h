//
//  TXNoteController.h
//  CARPeer

//备注控制器

//  Created by yezejiang on 15-1-17.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXModifyIntroductionController.h"

@protocol TXNoteControllerDelegate;

@interface TXNoteController : TXModifyIntroductionController


@property (nonatomic,assign) id<TXNoteControllerDelegate> delegate;

@end

@protocol TXNoteControllerDelegate<NSObject>

@required

-(void)getTextViewText:(NSString *)Note;

@end


