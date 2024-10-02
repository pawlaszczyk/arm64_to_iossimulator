# arm64_to_iossimulator
Patch script to run decrypted IOS-Apps with IOS simulator

# arm64_to_iossimulator
Patch script to run decrypted IOS-Apps with IOS simulator.

# Background
This small script allows you to run third party apps written for 
IPhone and IPad on the IOS Simulator. It is necessary for security 
researchers to analyse ios apps. Unfortunately, Apple does not offer 
the option of copying a third party app from an iPhone or iPad and 
running it in a sandbox environment. This small project helps to patch an 
app that was developed for IOS so that it runs on the IOS Simulator.  

To do this, however, we first need a decrypted app. Each IOS app that is 
downloaded from the App Store is protected 
by the so-called Fairplay DRM. The source code of the respective app is 
encrypted with the hardware key of the target device. Accordingly, the app must be 
decrypted before it can be installed on the simulator.  Fortunately, there are a 
number of tools that allow the app to be decrypted. However, this requires a device 
that has been jailbroken. Decryption can be done with frameworks like 
[clutch](https://github.com/kazaf0322/clutch) or [frida](https://github.com/AloneMonkey/frida-ios-dump). 



# Prerequisites
A number of conditions must  be met for the successful porting of a decrypted app:
- the script only works with Silicon Macs
- XCode needs to be installed on the target system
- Xcode Command Line Tools has are installed. 

# Run the Script
To run the script you need to open a terminal first. To execute the script, a cli must 
first be started. The app to be patched should be located in the same directory as the 
bash script. The app can then be easily patched with the following command:






