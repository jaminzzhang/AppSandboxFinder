//
//  ASConstants.h
//  AppSandboxFinder
//
//  Created by Jamin on 13-4-27.
//  Copyright (c) 2013年 Jaminz. All rights reserved.
//


#ifndef AppSandboxFinder_ASConstants_h
#define AppSandboxFinder_ASConstants_h


#if ! __has_feature(objc_arc)


#define ASAutorelease(__v)                  ([__v autorelease])
#define ASReturnAutoreleased(__v)           ASAutorelease(__v)

#define ASRetain(__v)                       ([__v retain])
#define ASReturnRetained(__v)               ASRetain(__v)


#define ASCopy(__v)                         ([__v copy])
#define ASReturnCopyed(__v)                 ASCopy(__v)

#define ASRelease(__v)                      ([__v release])



#else

#define ASAutorelease(__v)
#define ASReturnAutoreleased(__v)           (__v)

#define ASRetain(__v)
#define ASReturnRetained(__v)               (__v)


#define ASCopy(__v)
#define ASReturnCopyed(__v)                 (__v)


#define ASRelease(__v)

#endif


#endif