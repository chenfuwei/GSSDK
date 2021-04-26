//
//  GSFileUpload.h
//  GSCommonKit
//
//  Created by net263 on 2020/10/27.
//  Copyright © 2020 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GSUploadImageType)
{
    GSUploadImagePNG,
    GSUploadImageJPEG
};
@interface GSUploadImageParams : NSObject
@property(nonatomic, copy)NSString* fileName;
@property(nonatomic, assign)GSUploadImageType imageType;
@property(nonatomic, strong)NSData* fileData;
//specs;用于用户生成需要的特定规格的图片，当前只支持指定图片的宽，高，清晰度(百分比如：原图20%),灰度（0否，1是）。参数格式：宽，高，清晰度，灰度。组内以逗号分割，组与组以分号分割。如：100,200,20,0;200,500,70,1;
@property(nonatomic, copy)NSString* specs;
@end

@protocol GSUploadFileDelegate <NSObject>

-(void)onUploadBegin:(NSString*)fileName;
-(void)onUploadProgress:(float)percent fileName:(NSString*)fileName;
-(void)onUploadSuccess:(NSString*)fileName;
-(void)onUploadFailure:(NSError*)error fileName:(NSString*)fileName;

@end


@interface GSFileUpload : NSObject
@property(nonatomic, weak)id<GSUploadFileDelegate> uploadFileDelegate;
-(void)uploadFile:(NSString*)uploadUrl params:(NSDictionary*)params fileName:(NSString*)fileName fileData:(NSData*)data success:(void(^)(NSData*data))successBlock failure:(void(^)(NSError*))failureBlock;
-(void)uploadImage:(NSString*)uploadUrl  params:(NSDictionary*)params imageContent:(GSUploadImageParams*)imageContent success:(void(^)(NSData*data))successBlock failure:(void(^)(NSError*))failureBlock;
@end

NS_ASSUME_NONNULL_END
