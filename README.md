# NXP Application Code Hub
[<img src="https://mcuxpresso.nxp.com/static/icon/nxp-logo-color.svg" width="100"/>](https://www.nxp.com)

## Near and Far Motion Detection using Wi-Fi CSI on FRDM i.MX 91 + IW610
The Near and Far Motion Detection demo updates a webpage with real-time CSI-based motion detection between the DUT (STA) and external AP.

#### Boards: FRDM-IMX91
#### Categories: Networking, Wireless Connectivity, Security
#### Peripherals: Wi-Fi
#### Toolchains: GCC

## Table of Contents
1. [Software](#step1)
2. [Hardware](#step2)
3. [Setup](#step3)
4. [Results](#step4)
5. [FAQs](#step5) 
6. [Support](#step6)
7. [Release Notes](#step7)

## 1. Software<a name="step1"></a>
- [Linux-BSP for FRDM-i.MX91](https://www.nxp.com/webapp/sps/download/license.jsp?colCode=L6.12.34-2.1.0_IMX91&appType=file1&DOWNLOAD_ID=null)
- [Wireless utilities and example images](https://www.nxp.com/lgfiles/NMG/SCE/Connectivity/ACH-1654/Wireless-Utilities-and-example-Images.zip)

## 2. Hardware<a name="step2"></a>
- [FRDM-i.MX91](https://www.nxp.com/design/design-center/development-boards-and-designs/FRDM-IMX91)
- [Ublox Maya-W476](https://www.digikey.in/en/products/detail/u-blox/MAYA-W476-00B/26436930)

## 3. Setup<a name="step3"></a>
### 3.1 Pre-Requisites/Requirements
1. FRDM i.MX91 Development Board (DUT)
2. External Access Point (Ex-AP / Router)
3. Mobile phone or laptop to connect to DUT-AP (uap0)
4. Mobile phone or laptop to initiate communication from Ex-AP backend to DUT-STA (mlan0)
5. Download the Wireless-Utilities-and-example-Images.zip package from the Wireless utilities and example image link.
6. Put the mlancsi utility in the csi_webserver directory from the Wireless-Utilities-and-example-Images.zip package.
7. Create the config directory in the csi_webserver directory and put the config files in the config directory from the Wireless-Utilities-and-example-Images.zip package.
8. Put example images in the csi_webserver directory from the Wireless-Utilities-and-example-Images.zip package.

### 3.2 Steps
1. Flash BSP
    - Download Linux BSP for FRDM-i.MX91 from the link mentioned in Software section.
    - Power ON DUT and flash the downloaded Linux BSP.
2. Deploy Application
    - Copy "csi_webserver" directory on DUT.
    - Enter to the directory 
    ```
    # cd csi_webserver 
    ```
	- Make the utilitis and script executable.
	```
    # chmod +x mlancsi board_load_secure.sh test_csi_conference.sh
    ```

3. Update Ex-AP Credentials in Configuration File:
    - Update the existing SSID and password with those of the Ex-AP that DUT-STA should connect to.

4. Configure DUT

Run the script:
```
# ./board_load_secure.sh
```
This script will perform below configurations:
- Load driver and firmware
- Enable STA mode(mlan0) and connect to Ex-AP
- Obtain dynamic IP for mlan0 via udhcpc
- Assign static IP 192.168.4.1 to uap0 and enable DUT-AP (uap0)

5. Connect Mobile Device
    - Connect to DUT-AP (uap0); Mobile device gets dynamic IP in 192.168.4.xx range.
    - If mobile fails to connect to DUT-AP, set static IP from advanced network settings.
6. Update Configurations
    - config/csi.conf:
		- The default packet type is set as HE 20 MHz, so the AP must support 802.11ax.
		- Update Ex-AP MAC
		- Update Channel - The channel value must be provided in hex format. For example, channel 36 should be set as 24.
		- Update Band settings - Band 00: 2.4GHz, Band 01: 5GHz.
    - config/mlancsi.conf: Update Ex-AP MAC
7. Verify Connectivity
    - DUT-STA (mlan0) ↔ Ex-AP
    - DUT-AP (uap0) ↔ Mobile device
    - IPs assigned to both interfaces
8. Backend Communication
    - Connect another device (Mobile/laptop) to Ex-AP and ping DUT-STA from it.
9. Run CSI Test
```
# ./test_csi_conference.sh
```
This script will perform below configurations:
- Start web server on 192.168.4.1
- Monitor real-time CSI data
- The webpage updates with corresponding motion-detection images based on the predefined CSI range.

10. From the mobile device connected to the EX-AP (backend), initiate data communication to DUT-STA (mlan0) using ping or iperf. The ping or iperf interval must be set as >=0.5 seconds to get the accurate motion detection.

11. From the mobile device connected to the DUT-AP (uap0), open any web browser and enter "http://192.168.4.1" in the address bar to access the hosted webpage.

### 3.3 Notes
- uap0 must use static IP 192.168.4.1 (mandatory for web hosting).
- PACKET_TYPE in mlancsi.conf may vary depending on Ex-AP; configure accordingly to collect AMI values.

## 4. Results<a name="step4"></a>
Once the scripts are executed, you can observe multiple logs on the DUT console. Below is the breakdown:

- After running ./board_load_secure.sh 
Displays DUT interface details (STA & AP configuration):
```
    phy#0
        Interface wfd0
                ifindex 6
                wdev 0x3
                addr ba:f4:4f:ab:43:61
                type managed
                txpower 8.00 dBm
        Interface uap0
                ifindex 5
                wdev 0x2
                addr ba:f4:4f:ab:44:61
                ssid NXP_WiFi_AP
                type AP
                channel 36 (5180 MHz), width: 20 MHz, center1: 5180 MHz
                txpower 8.00 dBm
        Interface mlan0
                ifindex 4
                wdev 0x1
                addr b8:f4:4f:ab:43:61
                ssid ASUS_5G
                type managed
                channel 36 (5180 MHz), width: 20 MHz, center1: 5180 MHz
                txpower 8.00 dBm
```
- After executing ./test_csi_conference.sh, Logs confirming webserver startup:
```
Serving HTTP on 192.168.4.1 port 80 (http://192.168.4.1:80/) ...
192.168.4.2 - - [29/May/2025 23:13:23] "GET /current.png?t=1774595418940 HTTP/1.1" 200 -
```

- CSI Monitoring Initialized
```
---------------------------------------------------
------- NXP Wifi CSI Processing app v1.2 ------
---------------------------------------------------

[INFO] Initializing App
00 01 02 03
00 01 02 03
aa
01
24
00
01
00
01
Found 9 bytes in the csifilter0 section of conf file config/csi.conf.
7c 10 c9 02 da 4c 02 08 00
Found -1 bytes in the csifilter1 section of conf file config/csi.conf.
Expected filter size is 9
Found 1 CSI filters
awk: cmd. line:1: (FILENAME=- FNR=1) fatal: attempt to access field -1
CSI Value:
awk: cmd. line:1: (FILENAME=- FNR=1) fatal: attempt to access field -1
CSI Value:
192.168.4.2 - - [29/May/2025 23:13:25] "GET /current.png?t=1774595420937 HTTP/1.1" 200 -
CSI Value: ---------------------------------------------------
192.168.4.2 - - [29/May/2025 23:13:26] "GET / HTTP/1.1" 304 -
CSI Value: v1.2
192.168.4.2 - - [29/May/2025 23:13:26] "GET /current.png HTTP/1.1" 200 -
CSI Value: ---------------------------------------------------
awk: cmd. line:1: (FILENAME=- FNR=1) fatal: attempt to access field -1
CSI Value:
CSI Value: Initializing
CSI Value: file
192.168.4.2 - - [29/May/2025 23:13:28] "GET /current.png?t=1774595424018 HTTP/1.1" 200 -
CSI Value: CSI_EVENT_CFG
CSI Value: MAC_ADDR=7c:10:c9:02:da:4c
CSI Value: PACKET_TYPE=3
192.168.4.2 - - [29/May/2025 23:13:30] "GET /current.png?t=1774595426013 HTTP/1.1" 200 -
CSI Value: FORMAT_BW=0
CSI Value: UPDATE_REF=1
CSI Value: IIR_ALPHA=0.100000
CSI Value: KALMAN_P0=0.500000
192.168.4.2 - - [29/May/2025 23:13:32] "GET /current.png?t=1774595428015 HTTP/1.1" 200 -
CSI Value: KALMAN_ALPHA=0.005000
CSI Value: KALMAN_N0=0.200000
CSI Value: NUM_CSI=0
```
- Motion Detection & Image Update
```
CSI Value: -7.6
Near motion detected
CSI Value: -7.2
Near motion detected
CSI Value: -7.7
Near motion detected
192.168.4.2 - - [29/May/2025 23:13:36] "GET /current.png?t=1774595432014 HTTP/1.1" 200 -
CSI Value: -8.6
Near motion detected
CSI Value: -11.2
Near motion detected
192.168.4.2 - - [29/May/2025 23:13:38] "GET /current.png?t=1762516461560 HTTP/1.1" 200 -
CSI Value: -12.1
Far motion detected
192.168.4.2 - - [29/May/2025 23:13:40] "GET /current.png?t=1762516462559 HTTP/1.1" 200 -
CSI Value: -13.2
Far motion detected
```

## 5. FAQs<a name="step5"></a>
*Include FAQs here if appropriate. If there are none, then remove this section.*

## 6. Support<a name="step6"></a>
*Provide URLs for help here.*

#### Project Metadata

<!----- Boards ----->
[![Board badge](https://img.shields.io/badge/Board-FRDM&ndash;IMX91-blue)]()

<!----- Categories ----->
[![Category badge](https://img.shields.io/badge/Category-NETWORKING-yellowgreen)](https://mcuxpresso.nxp.com/appcodehub?category=networking)
[![Category badge](https://img.shields.io/badge/Category-WIRELESS%20CONNECTIVITY-yellowgreen)](https://mcuxpresso.nxp.com/appcodehub?category=wireless_connectivity)
[![Category badge](https://img.shields.io/badge/Category-SECURITY-yellowgreen)](https://mcuxpresso.nxp.com/appcodehub?category=security)

<!----- Peripherals ----->
[![Peripheral badge](https://img.shields.io/badge/Peripheral-WI&ndash;FI-yellow)](https://mcuxpresso.nxp.com/appcodehub?peripheral=wifi)

<!----- Toolchains ----->
[![Toolchain badge](https://img.shields.io/badge/Toolchain-GCC-orange)](https://mcuxpresso.nxp.com/appcodehub?toolchain=gcc)

Questions regarding the content/correctness of this example can be entered as Issues within this GitHub repository.

>**Warning**: For more general technical questions regarding NXP Microcontrollers and the difference in expected functionality, enter your questions on the [NXP Community Forum](https://community.nxp.com/)

[![Follow us on Youtube](https://img.shields.io/badge/Youtube-Follow%20us%20on%20Youtube-red.svg)](https://www.youtube.com/NXP_Semiconductors)
[![Follow us on LinkedIn](https://img.shields.io/badge/LinkedIn-Follow%20us%20on%20LinkedIn-blue.svg)](https://www.linkedin.com/company/nxp-semiconductors)
[![Follow us on Facebook](https://img.shields.io/badge/Facebook-Follow%20us%20on%20Facebook-blue.svg)](https://www.facebook.com/nxpsemi/)
[![Follow us on Twitter](https://img.shields.io/badge/X-Follow%20us%20on%20X-black.svg)](https://x.com/NXP)

## 7. Release Notes<a name="step7"></a>
| Version | Description / Update                           | Date                        |
|:-------:|------------------------------------------------|----------------------------:|
| 1.1     | Initial release on Application Code Hub        | March 25<sup>th</sup> 2026 |