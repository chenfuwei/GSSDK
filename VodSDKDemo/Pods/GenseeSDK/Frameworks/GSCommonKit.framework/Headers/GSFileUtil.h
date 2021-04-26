//
//  FileUtil.h

//
//  Created by jiangcj on 15/3/31.
//  Copyright (c) 2015年 wolf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSFileUtil : NSObject



/*文件是否存在*/
+ (BOOL)isFileExisted:(NSString *)pathfileName;


/*创建指定名字的文件*/
+ (BOOL)createFileAtPath:(NSString *)fileName;


/*创建指定名字的文件夹*/
+ (BOOL)createDirectoryAtPath:(NSString *)fileName;


// 按路径清除文件
+ (void)clearCachesWithFilePath:(NSString *)path;


//获得文件的大小
+ (double)sizeWithFilePath:(NSString *)path;


+(BOOL)checkLogFileSizeCanZip:(NSString *)path;





/**
 根文件夹
 */
+(NSString*)getDiagnosisRootFilePath;



/**
 获取所有的历史文件
 */
+(NSArray*)getAllHistoryLogInDir:(NSString*)documentDir;




/**
 获取所有的zip文件
 */
+(NSArray*)getAllHistoryZipInDir:(NSString*)documentDir;


/**
 清除过期的zip文件
 */
+(void)clearHistoryZipInDirOutDate:(NSString*)documentDir;

/**
 清楚过期的图片标注图片
 */
+(void)clearHistoryAnnoPicInDirOutDate;

/**
 获取标注图片路径
 */
+(NSString*)getAnnoPicPath;


+(NSString*)getCurrentAppleDevice;



/**
 清除路径中的所有的.json文件
 */
+(void)clearJsonFileInDir:(NSString*)documentDir;


+(NSDictionary*)getDictionaryFromObject_Ext:(id)obj;



@end
