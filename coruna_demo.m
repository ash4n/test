#import <CoreFoundation/CoreFoundation.h>
#import <dlfcn.h>
#import <objc/message.h>
#import <objc/runtime.h>

static void tryOpenURL(void) {
    NSURL *url = [NSURL URLWithString:@"http://360.cn"];

    // 1. UIApplication openURL:options:completionHandler: (iOS 10+)
    Class UIAppClass = objc_getClass("UIApplication");
    if (UIAppClass) {
        id app = ((id (*)(id, SEL))objc_msgSend)(UIAppClass, sel_getUid("sharedApplication"));
        if (app) {
            SEL sel = sel_getUid("openURL:options:completionHandler:");
            if (((BOOL (*)(id, SEL, id, id, id))objc_msgSend)(app, sel, url, @{}, nil)) {
                return;
            }
        }
    }

    // 2. LSApplicationWorkspace openSensitiveURL:withOptions:
    Class wsClass = objc_getClass("LSApplicationWorkspace");
    if (wsClass) {
        id ws = ((id (*)(id, SEL))objc_msgSend)(wsClass, sel_getUid("defaultWorkspace"));
        SEL sel = sel_getUid("openSensitiveURL:withOptions:");
        if (ws && [ws respondsToSelector:sel]) {
            ((BOOL (*)(id, SEL, id, id))objc_msgSend)(ws, sel, url, @{});
            return;
        }
    }

    // 3. SBSOpenSensitiveURL (SpringBoardServices C API)
    void *sbs = dlopen("/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices", RTLD_LAZY);
    if (sbs) {
        int (*openURL)(void*, CFURLRef, void*) = dlsym(sbs, "SBSOpenSensitiveURL");
        if (openURL) {
            openURL(NULL, (__bridge CFURLRef)url, NULL);
            return;
        }
    }

    // 4. Fallback: AudioToolbox sound + vibrate
    void *at = dlopen("/System/Library/Frameworks/AudioToolbox.framework/AudioToolbox", RTLD_LAZY);
    if (at) {
        void (*play)(int) = dlsym(at, "AudioServicesPlaySystemSound");
        if (play) {
            play(1007);
            play(0xFFF);
        }
    }
}

int _process(void) {
    tryOpenURL();
    return 0;
}
