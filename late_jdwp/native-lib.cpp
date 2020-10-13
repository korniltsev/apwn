#include <jni.h>
#include <string>
#include <dlfcn.h>

// https://tech.meituan.com/2017/07/20/android-remote-debug.html

enum JdwpTransportType {
    kJdwpTransportUnknown = 0,
    kJdwpTransportSocket,       // transport=dt_socket
    kJdwpTransportAndroidAdb,   // transport=dt_android_adb
};


struct JdwpOptions {
    JdwpTransportType transport = kJdwpTransportUnknown;
    bool server = false;
    bool suspend = false;
    std::string host = "";
    uint16_t port = static_cast<uint16_t>(-1);
};


extern "C" JNIEXPORT
jint JNI_OnLoad(JavaVM *vm, void *reserved) {
    void *art = dlopen("libart.so", RTLD_NOW);
    JdwpOptions options;
    options.transport = kJdwpTransportSocket;
    options.server = true;
    options.suspend = false;
    options.host = "0.0.0.0";
    options.port = 1337;

    void (*allowJdwp)() = (void (*)()) dlsym(art, "_ZN3art3Dbg14SetJdwpAllowedEb");
    void (*stopJdwp)() = (void (*)()) dlsym(art, "_ZN3art3Dbg8StopJdwpEv");
    void (*startjdwp)() = (void (*)()) dlsym(art, "_ZN3art3Dbg9StartJdwpEv");
    void (*configureJdwp)(struct JdwpOptions *) = (void (*)(struct JdwpOptions *)) dlsym(art,
                                                                                         "_ZN3art3Dbg13ConfigureJdwpERKNS_4JDWP11JdwpOptionsE");

    allowJdwp();
    stopJdwp();
    configureJdwp(&options);
    startjdwp();
    return JNI_VERSION_1_6;
}
