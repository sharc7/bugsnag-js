//
//  BugsnagDevice.m
//  Bugsnag
//
//  Created by Jamie Lynch on 01/04/2020.
//  Copyright © 2020 Bugsnag. All rights reserved.
//

#import "BugsnagDevice.h"
#import "BugsnagConfiguration.h"
#import "BugsnagCollections.h"

@implementation BugsnagDevice

+ (BugsnagDevice *)deserializeFromJson:(NSDictionary *)json {
    BugsnagDevice *device = [BugsnagDevice new];
    if (json != nil) {
        device.jailbroken = [json[@"jailbroken"] boolValue];
        device.id = json[@"id"];
        device.locale = json[@"locale"];
        device.manufacturer = json[@"manufacturer"];
        device.model = json[@"model"];
        device.modelNumber = json[@"modelNumber"];
        device.osName = json[@"osName"];
        device.osVersion = json[@"osVersion"];
        device.runtimeVersions = json[@"runtimeVersions"];
        device.totalMemory = json[@"totalMemory"];
    }
    return device;
}

+ (BugsnagDevice *)deviceWithDictionary:(NSDictionary *)event {
    BugsnagDevice *device = [BugsnagDevice new];
    [self populateFields:device dictionary:event];
    return device;
}

+ (void)populateFields:(BugsnagDevice *)device
            dictionary:(NSDictionary *)event {
    NSDictionary *system = event[@"system"];
    device.jailbroken = [system[@"jailbroken"] boolValue];
    device.id = system[@"device_app_hash"];
    device.locale = [[NSLocale currentLocale] localeIdentifier];
    device.manufacturer = @"Apple";
    device.model = system[@"machine"];
    device.modelNumber = system[@"model"];
    device.osName = system[@"system_name"];
    device.osVersion = system[@"system_version"];
    device.totalMemory = system[@"memory"][@"usable"];

    NSMutableDictionary *runtimeVersions = [NSMutableDictionary new];
    runtimeVersions[@"osBuild"] = system[@"os_version"];
    runtimeVersions[@"clangVersion"] = system[@"clang_version"];
    device.runtimeVersions = runtimeVersions;
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[@"jailbroken"] = @(self.jailbroken);
    dict[@"id"] = self.id;
    dict[@"locale"] = self.locale;
    dict[@"manufacturer"] = self.manufacturer;
    dict[@"model"] = self.model;
    dict[@"modelNumber"] = self.modelNumber;
    dict[@"osName"] = self.osName;
    dict[@"osVersion"] = self.osVersion;
    dict[@"runtimeVersions"] = self.runtimeVersions;
    dict[@"totalMemory"] = self.totalMemory;
    return dict;
}

- (void)appendRuntimeInfo:(NSDictionary *)info {
    NSMutableDictionary *versions = [self.runtimeVersions mutableCopy];
    [versions addEntriesFromDictionary:info];
    self.runtimeVersions = versions;
}

@end
