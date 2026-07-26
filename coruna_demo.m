#import <CoreFoundation/CoreFoundation.h>
#import <dlfcn.h>
#import <objc/message.h>
#import <objc/runtime.h>

// CFUserNotificationDisplayAlert: 9 params
typedef int (*CFUserNotificationDisplayAlertFunc)(
    double timeout, int flags, CFStringRef iconURL,
    CFStringRef header, CFStringRef message,
    CFStringRef defaultBtn, CFStringRef altBtn, CFStringRef otherBtn,
    void *response
);

static void showCFNotification(void) {
    void *cf = dlopen("/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation", RTLD_NOLOAD);
    if (!cf) return;

    CFUserNotificationDisplayAlertFunc fn = dlsym(cf, "CFUserNotificationDisplayAlert");
    if (!fn) return;

    fn(0, 0, NULL, CFSTR("Coruna Demo"),
       CFSTR("Hello, world!\nExploit chain works!"),
       CFSTR("OK"), NULL, NULL, NULL);
}

// JSC fallback — objc_msgSend вместо performSelector (ARC-safe)
static void showJSCAlert(void) {
    void *jsc = dlopen("/System/Library/Frameworks/JavaScriptCore.framework/JavaScriptCore", RTLD_NOLOAD);
    if (!jsc) return;

    Class JSContextClass = objc_getClass("JSContext");
    if (!JSContextClass) return;

    SEL currentCtxSEL = sel_getUid("currentContext");
    id ctx = ((id (*)(id, SEL))objc_msgSend)(JSContextClass, currentCtxSEL);
    if (!ctx) {
        SEL allocSEL = sel_getUid("alloc");
        SEL initSEL = sel_getUid("init");
        ctx = ((id (*)(id, SEL))objc_msgSend)(JSContextClass, allocSEL);
        ctx = ((id (*)(id, SEL))objc_msgSend)(ctx, initSEL);
    }

    SEL evalSEL = sel_getUid("evaluateScript:");
    NSString *script = @"alert('Hello, world! Exploit OK!')";
    ((id (*)(id, SEL, id))objc_msgSend)(ctx, evalSEL, script);
}

int _process(void) {
    showCFNotification();
    showJSCAlert();
    return 0;
}