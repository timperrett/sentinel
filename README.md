# Sentinel 

> The goal of this project is to create a self-sufficient time-lapse camera that can survive for over a year, exposed to the elements in climate zone 3C. The camera will take periodic snapshots from its vantage point and upload them over a cellular connection via SFTP. These images can later be combined into a time-lapse video by the administrator.

+ [Preamble](#preamble)
+ [Hardware Build](#hardware-build)

## Preamble

In order to follow along with this build, you would need to have the following components and tools available to you:

### Things to be aware of

1. The type of camera you choose its subsequent resolution impacts the amount of bandwidth you will consume in a given 30 day period. Make sure that you plan for upload accordingly. `sentinel-upload` will only transfer content every 5 minutes to reduce bandwidth. With a 1920x1080 resolution captures will be around 150kb - 200kb in size, which is roughly 1.08GB in transfer every 30 days.

2. This setup targets the daylight hours, and does not take pictures at night, even though my camera has IR for night imaging. This is purely to reduce bandwidth for my particular use-case.

3. Working with a 5 minute cadence should yield roughly 

### Parts List

- [12v 12amp/hr battery](https://www.amazon.com/gp/product/B00K8I758O/ref=ppx_yo_dt_b_asin_title_o02_s00?ie=UTF8&psc=1)
- [PWM solar controller](https://www.amazon.com/gp/product/B07L9Q95QJ/ref=ppx_yo_dt_b_asin_title_o03_s00?ie=UTF8&psc=1)
- [35W solar panel](https://www.amazon.com/gp/product/B07Y49LSMN/ref=ppx_yo_dt_b_asin_title_o03_s00?ie=UTF8&psc=1)
- [Electrical Enclosure](https://www.amazon.com/gp/product/B085QD5S8D/ref=ppx_yo_dt_b_asin_title_o03_s01?ie=UTF8&psc=1)
- [USB Camera](https://www.amazon.com/gp/product/B07N1DBRZW/ref=ppx_yo_dt_b_asin_title_o00_s00?ie=UTF8&psc=1)
- [12v to 5v buck converter](https://www.adafruit.com/product/1385)
- [Raspberry Pi](https://www.raspberrypi.org/products/raspberry-pi-4-model-b/); i'm using v3B
- [LTE shield](https://community.sixfab.com/c/raspberry-pi-hats/cellular-iot-hat/)
- [Waterproof grommets sufficient large for your cabling](https://www.amazon.com/gp/product/B01GJ03AUQ/ref=ppx_od_dt_b_asin_title_s00?ie=UTF8&psc=1)
- 14AWG stranded cabling for power
- 14AWG female spade connectors
- 2x DC inline fuses

### Suggested Tools

- Multi-meter and knowledge about how to use it
- Drill and bits large enough for the penetrations for your grommets

## Hardware Build

1. Install the LTE shield 
2. 

## Software Deployment

There is a set of initial setup that must be done manually to get the Pi's accessible remotely (and availalbe for automatic provisioning). I used the following steps to get the nodes going:

```
# set a new root password
$ sudo passwd root
<enter new password>

# set your the password for the `pi` user
$ sudo passwd pi
<enter new password>

$ sudo reboot

# update the system, disable avahi and bluetooth
$ sudo systemctl enable ssh && \
  sudo systemctl start ssh

# optionally install a few useful utilities
$ sudo apt-get install -y htop

```
