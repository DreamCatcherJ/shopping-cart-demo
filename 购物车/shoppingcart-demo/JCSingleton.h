// ## :拼接前后两个字符串
// 如果整个运行过程只需要初始化一次,加下面代码
/**
 - (instancetype)init{
     __block id temp = self;
     static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
        if ((temp = [super init])) {// 初始化
        }
     });
     self = temp;
     return self;
 }
 */
#define JCSingleton_h(name)  +(instancetype)shared##name;
#if __has_feature(objc_arc) // arc
    #define JCSingleton_m(name) \
    +(instancetype)shared##name{ \
        return [[self alloc] init]; \
    }\
    \
    - (id)copyWithZone:(NSZone *)zone{\
    return self;\
    }\
    \
    + (instancetype)allocWithZone:(struct _NSZone *)zone {\
    static id instance;\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        instance = [super allocWithZone:zone];\
    });\
    return instance;\
    }

#else // 非arc
    #define JCSingleton_m(name) \
    +(instancetype)shared##name{ \
    return [[self alloc] init]; \
    }\
    \
    - (id)copyWithZone:(NSZone *)zone{\
        return self;\
    }\
    \
    + (instancetype)allocWithZone:(struct _NSZone *)zone {\
    static id instance;\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
    instance = [super allocWithZone:zone];\
    });\
    return instance;\
    }\
    - (oneway void)release {\
        \
    }\
    \
    - (instancetype)autorelease {\
        return self;\
    }\
    \
    - (instancetype)retain {\
        return self;\
    }
#endif