//
//  MacHookBridge.m
//  MacHook
//
//  Created by Mark Fingerhut on 12/17/19.
//  Copyright © 2019 Mark Fingerhut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <AppKit/Appkit.h>
#include "MacHook-Swift.h"
#pragma mark - C interface

extern "C" {
    char* _sayHiToUnity() {
        NSString *returnString = [[MacHook shared]SayHiToUnity];
        char* cStringCopy(const char* string);
        return cStringCopy([returnString UTF8String]);
        
    }

    void workingtransparent() {
        [MacHook initializeTransparent];
    }
    
    /*
    char* _initializeTransparent()
    {
        NSString *returnString = [[MacHook shared]initializeTransparent];
        char* cStringCopy(const char* string);
        return cStringCopy([returnString UTF8String]);
    }
     */
}

char* cStringCopy(const char* string){
    if (string == NULL){
        return NULL;
    }

    char* res = (char*)malloc(strlen(string)+1);
    strcpy(res, string);
    return res;
}
