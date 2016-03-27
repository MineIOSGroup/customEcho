//
//  NTESContactDataMember.m
//  NIM
//
//  Created by chris on 15/9/21.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "NTESContactDataMember.h"
#import "NTESSpellingCenter.h"

@implementation NTESContactDataMember

- (CGFloat)uiHeight{
    return 50;
}

//userId和Vcname必有一个有值，根据有值的状态push进不同的页面

- (NSString *)vcName{
    return nil;
}

- (NSString *)reuseId{
    return @"NTESContactDataItem";
}

- (NSString *)cellName{
    return @"NIMContactDataCell";
}

- (NSString *)badge{
    return @"";
}

- (NSString *)groupTitle {
    NSString *title = [[NTESSpellingCenter sharedCenter] firstLetter:self.kitInfo.showName].capitalizedString;
    unichar character = [title characterAtIndex:0];
    if (character >= 'A' && character <= 'Z') {
        return title;
    }else{
        return @"#";
    }
}

- (NSString *)userId{
    return self.kitInfo.infoId;
}

- (UIImage *)icon{
    return self.kitInfo.avatarImage;
}

- (NSString *)avatarUrl{
    return self.kitInfo.avatarUrlString;
}

- (NSString *)memberId{
    return self.kitInfo.infoId;
}

- (NSString *)showName{
    return self.kitInfo.showName;
}

- (BOOL)showAccessoryView{
    return NO;
}

- (id)sortKey {
    return [[NTESSpellingCenter sharedCenter] spellingForString:self.kitInfo.showName].shortSpelling;
}

- (BOOL)isEqual:(id)object{
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    return [self.kitInfo.infoId isEqualToString:[[object kitInfo] infoId]];
}


@end
