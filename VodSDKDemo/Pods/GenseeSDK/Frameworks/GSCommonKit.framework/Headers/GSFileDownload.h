//
//  GSFileDownload.h
//  GSCommonKit
//
//  Created by net263 on 2020/11/12.
//  Copyright © 2020 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSFileDownload : NSObject
@property(nonatomic, assign)unsigned int docID;
@property(nonatomic, assign)unsigned int pageID;
@property(nonatomic, assign)long long annoID;
@property(nonatomic, copy)void(^block)(NSString* filePath);
-(void)downloadTaskWithURL:(NSString*)fileUrl;
@end

NS_ASSUME_NONNULL_END
