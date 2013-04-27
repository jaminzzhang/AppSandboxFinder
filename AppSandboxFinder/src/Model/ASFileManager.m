//
//  ASFileManager.m
//  AppSandboxFinder
//
//  Created by Jamin on 13-4-6.
//  Copyright (c) 2013年 Jaminz. All rights reserved.
//

#import "ASFileManager.h"
#import "ASConstants.h"

@implementation ASFileManager



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



+ (BOOL)checkFileExists:(NSString *)path
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:path];
}


+ (NSMutableArray *)localFilesAtPath:(NSString *)path
{
    BOOL isExist = [ASFileManager checkFileExists:path];
    if (isExist) {
        
        NSMutableArray * subFiles = [NSMutableArray array];
        NSMutableArray * subDirs = [NSMutableArray array];
        NSDirectoryEnumerator *dirEnumerator = [[NSFileManager defaultManager] enumeratorAtURL:[NSURL fileURLWithPath:path]
                                                                    includingPropertiesForKeys:nil
                                                                                       options:(NSDirectoryEnumerationSkipsSubdirectoryDescendants | NSDirectoryEnumerationSkipsHiddenFiles)
                                                                                  errorHandler:nil];
        for (NSURL *theURL in dirEnumerator) {
            NSString *fileName;
            [theURL getResourceValue:&fileName forKey:NSURLNameKey error:NULL];
            
            NSNumber *isDirectory;
            [theURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
            
            NSString * subPath = [path stringByAppendingPathComponent:fileName];
            
            // Ignore subFiles under the _extras directory
            if ([isDirectory boolValue] == YES) {
                ASDir *dir = [[ASDir alloc] init];
                dir.name = fileName;
                dir.path = subPath;
                
                NSInteger dirCount = subDirs.count;
                
                if (dirCount == 0) {
                    [subDirs addObject:dir];
                
                } else {
                    for (NSInteger i = 0; i < dirCount; i++) {
                        ASDir *aDir = [subDirs objectAtIndex:i];
                        if (NSOrderedAscending == [dir.name localizedStandardCompare:aDir.name]) {
                            [subDirs insertObject:dir atIndex:i];
                            break;
                        }
                        
                        //遍历到最后，没有找到合适的位置插入，直接加到队尾
                        if (i == dirCount - 1) {
                            [subDirs addObject:dir];
                        }
                    }
                }
                
                ASRelease(dir);

            } else {
                ASFile *file = [[ASFile alloc] init];
                file.name = fileName;
                file.path = subPath;
                NSInteger filesCount = subFiles.count;
                
                if (filesCount  == 0) {
                    [subFiles addObject:file];
                    
                } else {
                    for (NSInteger i = 0; i < filesCount; i++) {
                        ASFile *aFile = [subFiles objectAtIndex:i];
                        if (NSOrderedAscending == [file.name localizedStandardCompare:aFile.name]) {
                            [subFiles insertObject:file atIndex:i];
                            break;
                        }
                        
                        if (i == filesCount - 1) {
                            [subFiles addObject:file];
                        }
                        
                    }
                }
                
                ASRelease(file);

            }
        }
        
        [subDirs addObjectsFromArray:subFiles];
        return [NSArray arrayWithArray:subDirs];
        //        return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    }
    
    return nil;
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
    NSString *iconFileName = [NSString stringWithFormat:@"icon_file_%@.png", extension];
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
        
        iconFileName = [NSString stringWithFormat:@"icon_file_%@.png", extension];
        iconImage = [UIImage imageNamed:iconFileName];
        
    }
    
    return iconImage;
}


+ (UIImage *)getFileIcon:(id<ASFile>)file
{
    if ([file isKindOfClass:[ASDir class]]) {
        return [UIImage imageNamed:@"icon_file_folder.png"];
    } else {
        return [ASFileManager getFileIconOfName:file.name];
    }
}



@end
