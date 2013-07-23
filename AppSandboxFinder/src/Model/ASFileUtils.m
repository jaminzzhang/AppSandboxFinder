//
//  ASFileUtils.m
//  AppSandboxFinder
//
//  Created by Jamin on 13-4-6.
//  Copyright (c) 2013年 Jaminz. All rights reserved.
//

#import "ASFileUtils.h"
#import "ASConstants.h"

@implementation ASFileUtils



+ (BOOL)isImageFile:(NSString *)fileName
{
    NSString *extension = nil;
    
    if ([fileName hasPrefix:@"assets-library"])
    {
        NSArray *array = [fileName componentsSeparatedByString:@"ext="];
        if (array.count != 0)
        {
            extension = [[array lastObject] uppercaseString];
        }
    }
    else
    {
        extension = [[fileName pathExtension] uppercaseString];
    }
    
    return ([extension isEqualToString:@"PNG"]
            || [extension isEqualToString:@"JPG"]
            || [extension isEqualToString:@"JPEG"]
            || [extension isEqualToString:@"BMP"]
            || [extension isEqualToString:@"GIF"]
            || [extension isEqualToString:@"TIIF"]);
}


+ (BOOL)isVideoFile:(NSString *)fileName
{
    NSString *extension = nil;
    if ([fileName hasPrefix:@"assets-library"])
    {
        NSArray *array = [fileName componentsSeparatedByString:@"ext="];
        if (array.count != 0)
        {
            extension = [[array lastObject] uppercaseString];
        }
    }
    else
    {
        extension = [[fileName pathExtension] uppercaseString];
    }
    
    return ([extension isEqualToString:@"MP4"]
            || [extension isEqualToString:@"MOV"]
            || [extension isEqualToString:@"MKV"]
            || [extension isEqualToString:@"3GP"]
            || [extension isEqualToString:@"MPV"]);
}


+ (BOOL)isAudioFile:(NSString *)fileName
{
    NSString *extension = [fileName pathExtension].uppercaseString;
    
    return ([extension isEqualToString:@"MP3"]
            || [extension isEqualToString:@"WAV"]
            || [extension isEqualToString:@"M4A"]
            || [extension isEqualToString:@"M4R"]
            || [extension isEqualToString:@"AAC"]
            || [extension isEqualToString:@"ALAC"]
            || [extension isEqualToString:@"AIFF"]);
}




+ (BOOL)isCompressedFile:(NSString *)fileName
{
    NSString *extension = [fileName pathExtension].uppercaseString;
    
    return ([extension isEqualToString:@"RAR"]
            || [extension isEqualToString:@"ZIP"]
            || [extension isEqualToString:@"7Z"]);
}




+ (UIImage *)getFileIconOfName:(NSString *)fileName
{
    NSString *extension = nil;
    
    if ([fileName hasPrefix:@"assets-library"]) {
        NSArray *array = [fileName componentsSeparatedByString:@"ext="];
        if (array.count != 0) {
            extension = [array lastObject];
        }
    } else {
        extension = [fileName pathExtension].lowercaseString;
    }
    
    if (extension.length == 0) {
        extension = @"unknown";
    } else if ([extension isEqualToString:@"jpeg"]) {
        extension = @"jpg";
    } else if ([extension isEqualToString:@"pptx"]) {
        extension = @"ppt";
    } else if ([extension isEqualToString:@"docx"]) {
        extension = @"doc";
    } else if ([extension isEqualToString:@"xlsx"]) {
        extension = @"xls";
    } else if ([extension isEqualToString:@"rtf"]) {
        extension = @"txt";
    } else if ([self isCompressedFile:fileName]) {
        extension = @"compress";
    }
    
    
    UIImage *iconImage = nil;
    NSString *iconFileName = [NSString stringWithFormat:@"as_icon_file_%@.png", extension];
    iconImage = [UIImage imageNamed:iconFileName];
    if (iconImage == nil) {
        
        if ([self isVideoFile:fileName]) {
            extension = @"video";
        } else if ([self isAudioFile:fileName]) {
            extension = @"audio";
        } else if ([self isImageFile:fileName]) {
            extension = @"image";
        } else {
            extension = @"unknown";
        }
        
        iconFileName = [NSString stringWithFormat:@"as_icon_file_%@.png", extension];
        iconImage = [UIImage imageNamed:iconFileName];
        
    }
    
    return iconImage;
}


+ (UIImage *)getFileIcon:(id<ASFile>)file
{
    if ([file isKindOfClass:[ASDir class]]) {
        return [UIImage imageNamed:@"as_icon_file_folder.png"];
    } else {
        return [ASFileUtils getFileIconOfName:file.name];
    }
}




+ (BOOL)checkFileExists:(NSString *)path
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:path];
}



+ (BOOL)isDirAtPath:(NSString *)path
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExists = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    return (isExists && isDir);
}



+ (NSMutableArray *)localFilesAtPath:(NSString *)path
{
    ASDir * dir = ASReturnAutoreleased([[ASDir alloc] initWithPath:path]);
    return [ASFileUtils localFilesInDir:dir];
}


+ (NSMutableArray *)localFilesInDir:(ASDir *)dir
{
    BOOL isExist = [ASFileUtils checkFileExists:dir.path];
    if (isExist) {
        
        NSMutableArray * subFiles = [NSMutableArray array];
        NSMutableArray * subDirs = [NSMutableArray array];
        NSFileManager * fileManager = [NSFileManager defaultManager];
        
        NSDirectoryEnumerator *dirEnumerator = [fileManager enumeratorAtURL:[NSURL fileURLWithPath:dir.path]
                                                 includingPropertiesForKeys:nil
                                                                    options:(NSDirectoryEnumerationSkipsSubdirectoryDescendants | NSDirectoryEnumerationSkipsHiddenFiles)
                                                               errorHandler:nil];
        for (NSURL *theURL in dirEnumerator) {
            NSString * fileName = nil;
            [theURL getResourceValue:&fileName forKey:NSURLNameKey error:NULL];
            
            NSNumber * isDirectory = nil;
            [theURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
            
            NSNumber * fileSizeNum = nil;
            [theURL getResourceValue:&fileSizeNum forKey:NSURLFileSizeKey error:NULL];
            
            NSDate * fileCreateTime = nil;
            [theURL getResourceValue:&fileCreateTime forKey:NSURLCreationDateKey error:NULL];
            
            NSDate * fileModifyTime = nil;
            [theURL getResourceValue:&fileModifyTime forKey:NSURLContentModificationDateKey error:NULL];
            
            
            NSString * typeIdentifier = nil;
            [theURL getResourceValue:&typeIdentifier forKey:NSURLTypeIdentifierKey error:NULL];
            
            
            
            NSString * subPath = [dir.path stringByAppendingPathComponent:fileName];
            
            if ([isDirectory boolValue] == YES) {
                ASDir *subDir = [[ASDir alloc] init];
                subDir.name = fileName;
                subDir.path = subPath;
                subDir.size = [fileSizeNum longLongValue];
                subDir.ctime = fileCreateTime;
                subDir.mtime = fileModifyTime;
                subDir.fatherDir = dir;
                
                subDir.childrenCount = [[fileManager contentsOfDirectoryAtPath:subPath error:nil] count];
                
                NSInteger dirCount = subDirs.count;
                
                if (dirCount == 0) {
                    [subDirs addObject:subDir];
                    
                } else {
                    for (NSInteger i = 0; i < dirCount; i++) {
                        ASDir *aDir = [subDirs objectAtIndex:i];
                        if (NSOrderedAscending == [subDir.name localizedStandardCompare:aDir.name]) {
                            [subDirs insertObject:subDir atIndex:i];
                            break;
                        }
                        
                        //遍历到最后，没有找到合适的位置插入，直接加到队尾
                        if (i == dirCount - 1) {
                            [subDirs addObject:subDir];
                        }
                    }
                }
                
                ASRelease(dir);
                
            } else {
                ASFile *subFile = [[ASFile alloc] init];
                subFile.name = fileName;
                subFile.path = subPath;
                subFile.typeIdentifier = typeIdentifier;
                subFile.size = [fileSizeNum longLongValue];
                subFile.ctime = fileCreateTime;
                subFile.mtime = fileModifyTime;
                subFile.fatherDir = dir;
                NSInteger filesCount = subFiles.count;
                
                if (filesCount  == 0) {
                    [subFiles addObject:subFile];
                    
                } else {
                    for (NSInteger i = 0; i < filesCount; i++) {
                        ASFile *aFile = [subFiles objectAtIndex:i];
                        if (NSOrderedAscending == [subFile.name localizedStandardCompare:aFile.name]) {
                            [subFiles insertObject:subFile atIndex:i];
                            break;
                        }
                        
                        if (i == filesCount - 1) {
                            [subFiles addObject:subFile];
                        }
                        
                    }
                }
                
                ASRelease(subFile);
                
            }
        }
        
        [subDirs addObjectsFromArray:subFiles];
        return [NSArray arrayWithArray:subDirs];
        //        return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    }
    
    return nil;

}



+ (BOOL)deleteFileAtPath:(NSString *)path
{
    BOOL isExist = [ASFileUtils checkFileExists:path];
    if (isExist) {
        return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    
    return NO;
}




+ (NSString *)formatFileSize:(long long)byteSize
{
    NSInteger carryCount = -1;
    double dSize = byteSize;
    NSString * formatStr = nil;
	char *s = "KMGTP";
    
    
    
    while (fabs(dSize) >= 1024.0 && carryCount < 5) {
        dSize = dSize / 1024;
        carryCount++;
    }
    
    if (carryCount >= 0) {
        formatStr = [NSString stringWithFormat:@"%.1f%cB", dSize, s[carryCount]];
    } else {
        formatStr = [NSString stringWithFormat:@"%.1fB", dSize];
    }
    
    return formatStr;
}

@end
