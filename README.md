# arm64_to_iossimulator
Patch script to run decrypted IOS apps with IOS simulator.

<p align="center">
  <img width="30%" height="30%" src="IOS_Simulator_Screen.png?raw=true" alt="FQLite Screenshot"/>
</p>

# Background
This small script allows you to run third party apps written for 
IPhone and IPad on the IOS Simulator. It is necessary for security 
researchers to analyse ios apps. Unfortunately, Apple does not offer 
the option of copying a third party app from an iPhone or iPad and 
running it in a sandbox environment. This small project helps to patch an 
app that was developed for IOS so that it runs on the IOS Simulator.  

To do this, however, we first need a decrypted app. Each IOS app that is 
downloaded from the App Store is protected 
by the so-called [Fairplay DRM](https://developer.bitmovin.com/playback/docs/how-does-fairplay-work) . The source code of the respective app is 
encrypted with the hardware key of the target device. Accordingly, the app must be 
decrypted before it can be installed on the simulator.  Fortunately, there are a 
number of tools that allow the app to be decrypted. However, this requires a device 
that has been jailbroken. Decryption can be done with frameworks like 
[clutch](https://github.com/kazaf0322/clutch) or [frida](https://github.com/AloneMonkey/frida-ios-dump). 


# Prerequisites
A number of conditions must  be met for the successful porting of a decrypted app:
- the script only works with Silicon Macs
- XCode needs to be installed on the target system
- Xcode Command Line Tools are installed. 

# Run the Script
To run the script you need to open a terminal first. The app to be patched should be located in the same directory as the 
bash script. The app can then be easily patched with the following command:

```bash
./patchit.sh <myappname.app>
```
The customized _.app_ file can then be transferred to a started simulator instance using drag & drop. 
The app should then start normally. 

# What does the program actually do?
The script automatically searches for the binary files within the app and adjusts the header information 
in these files. The binary format of executable files under MacOS and IOS is [Mach-O](https://en.wikipedia.org/wiki/Mach-O). The target platform 
is adapted from IPhoneOS (value **0x6**) to IOS Simulator (value **0x7**). The static and dynamic libraries in the Frameworks directory are also adapted.
The _info.plist_ file, which is used to manage the app's basic configuration settings, is also patched. 
The customized files must also be signed again afterwards. The script also takes care of this. The script was successfully tested with the following apps:

| App  | Version | Success   | Comment    |
| :---:   | :---: | :---: |  :---: |
| Youtube | 19.34.2   |  Yes  |        | 
| Discord | 247.0      |  Yes  |        | 
| TikTok  |       |  Yes  |        |
| X(Twitter) |9.2 | Yes |       |
| WeChat | | Yes |  |
| Tinder | 15.17.0 | Yes |  |
| SQliteFlow || Yes |    |

# Known Issues
A number of apps crash on startup after patching. This is the case for Instagram, Facebook or WhatsApp, for example. The apps are chrashing with
_"... Termination Reason: DYLD 4 Symbol missing Symbol not found: __MXSignpostMetricsSnapshot"_. The reason for this crash becomes clear when we look at the **MXSignpost_Private.h** file:

<p align="center">
  <img width="70%" height="70%" src="ScreenShot_MXSignPost.png?raw=true" alt="Screenshot of MXSignpost_Private.h"/>
</p>

