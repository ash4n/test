#import <CoreFoundation/CoreFoundation.h>
#import <dlfcn.h>
#import <objc/runtime.h>

// CFUserNotificationDisplayAlert: 9 params
typedef int (*CFUserNotificationDisplayAlertFunc)(
    double timeout, int flags, void *iconURL,
    void *header, void *message,
    void *defaultBtn, void *altBtn, void *otherBtn,
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

// JSC fallback — используем ObjC runtime вместо прямых C-вызовов
static void showJSCAlert(void) {
    void *jsc = dlopen("/System/Library/Frameworks/JavaScriptCore.framework/JavaScriptCore", RTLD_NOLOAD);
    if (!jsc) return;

    // Пробуем через ObjC runtime — надёжнее
    Class JSContextClass = objc_getClass("JSContext");
    if (!JSContextClass) return;

    id ctx = [JSContextClass performSelector:@selector(currentContext)];
    if (!ctx) {
        ctx = [JSContextClass performSelector:@selector(alloc)];
        ctx = [ctx performSelector:@selector(init)];
    }

    NSString *script = @"alert('Hello, world! Exploit OK!')";
    [ctx performSelector:@selector(evaluateScript:) withObject:script];
}

int _process(void) {
    showCFNotification();
    showJSCAlert();
    return 0;
}