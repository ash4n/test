#import <CoreFoundation/CoreFoundation.h>
#import <dlfcn.h>

static void showCFNotification(void) {
    void *cf = dlopen("/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation", RTLD_NOLOAD);
    if (!cf) return;

    typeof(CFUserNotificationDisplayAlert) *fn = dlsym(cf, "CFUserNotificationDisplayAlert");
    if (!fn) return;

    fn(0, 0, NULL, CFSTR("Coruna Demo"),
       CFSTR("Hello, world!\nExploit chain works!"),
       CFSTR("OK"), NULL, NULL, NULL);
}

static void showJSCAlert(void) {
    void *jsc = dlopen("/System/Library/Frameworks/JavaScriptCore.framework/JavaScriptCore", RTLD_NOLOAD);
    if (!jsc) return;

    void *(*createCtx)(void) = dlsym(jsc, "JSGlobalContextCreate");
    void *(*eval)(void*, void*, void*, void*, int, void*) = dlsym(jsc, "JSEvaluateScript");
    void *(*strCreate)(const char*) = dlsym(jsc, "JSStringCreateWithUTF8CString");
    void (*strRelease)(void*) = dlsym(jsc, "JSStringRelease");

    if (!createCtx || !eval || !strCreate) return;

    void *ctx = createCtx(NULL);
    void *script = strCreate("alert('Hello, world! Exploit OK!')");
    eval(ctx, script, NULL, NULL, 0, NULL);
    strRelease(script);
}

int _process(void) {
    showCFNotification();
    showJSCAlert();
    return 0;
}