# Sentinel 

> The goal of this project is to create a self-sufficient time-lapse camera that can survive for over a year, exposed to the elements in climate zone 3C. The camera will take periodic snapshots from its vantage point and upload them over a cellular connection via SFTP. These images can later be combined into a time-lapse video by the administrator.

+ [Preamble](#preamble)
+ [Hardware Build](#hardware-build)
+ [Software Deployment](#software-deployment)

## Preamble

In order to follow along with this build, you would need to have the following components and tools available to you:

### Things to be aware of

1. The type of camera you choose its subsequent resolution impacts the amount of bandwidth you will consume in a given 30 day period. Make sure that you plan for upload accordingly. `sentinel-upload` will only transfer content every 5 minutes to reduce bandwidth. With a 1920x1080 resolution captures will be around 150kb - 200kb in size, which is roughly 1.08GB in transfer every 30 days.

2. This setup targets the daylight hours, and does not take pictures at night, even though my camera has IR for night imaging. This is purely to reduce bandwidth for my particular use-case.

3. Working with a 5 minute cadence should yield roughly 180 images per day (assuming 15 hours of capture operaton), which should yield one day passing in 7 seconds of video, assuming 1080p @ 24fps. By contrast, a year worth of content would yield around 45 minutes of video if all frames are usable (which they won't be during the winter due to contracted periods of daylight).

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
- [Low profile 4.6dBi antenna](https://sixfab.com/product/lte-antenna-sma-high-gain-71mm/)
- [Waterproof SMA to u.FL RF Adaptor](https://sixfab.com/product/waterproof-sma-to-u-fl-rf-adapter-cable/)
- 14AWG stranded cabling for power
- 14AWG female spade connectors
- 2x DC inline fuses

### Suggested Tools

- Multi-meter and knowledge about how to use it
- Drill and bits large enough for the penetrations for your grommets

## Hardware Build

1. Install the LTE shield using [the Sixfab instructions](https://docs.sixfab.com/docs/raspberry-pi-cellular-iot-hat-introduction)

### Weatherproof penetrations

Given we need to get power to our Pi, and the solar controller, and allow for the antenna to get signal, we have to carefully make penetrations in the mounting box. This is done by drilling holes in the box that match the diameter of your grommets. You'll want to drill pilot holds and progressively make the hole bigger and bigger, instead of drilling one big hole to avoid breaking the box wall. Here are some pictures of the finished penetrations with wires run through:

![Sealed Box Penetrations](https://raw.githubusercontent.com/timperrett/sentinel/master/docs/img/IMG_3792.jpeg)

The antenna is a big of a special case: it comes with a rubberized gasket integrated onto the SMA socket so you can carefully drill a whole that is the right size for the socket and then screw it back together. I decided to go with a low-profile antenna, you may need something different if you're in an area with poor signal.

![Sealed Antenna](https://raw.githubusercontent.com/timperrett/sentinel/master/docs/img/IMG_3787.jpeg)

Internally, the box I was using had a hand bread board style mounting plate which allowed me to secure the various pieces in a fairly orderly fashion. In the end, my box internals looked like this:

![Box Internals](https://raw.githubusercontent.com/timperrett/sentinel/master/docs/img/IMG_3794.jpeg)

I had a nightmare of a time with the USB cable for the camera and just couldn't fit it through the grommet so I ended up carefully cutting off the casing for the USB plug so that it could fit. I then used electrical tape to seal up the area that was previosuly cased on the cable as a precaution.

## Software Deployment

There is a set of initial setup that must be done manually to get the Pi's accessible remotely (and available for automatic provisioning). I used the following steps to get the nodes going:

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

#### Site Playbook

Once you've bootstrapped your pi and you can SSH with your key, then one can simply run the ansible site plays, and let it install all the nessicary gubbins for sentinel.

```
./site.yml
```

#### Debugging

Sentinel is implemented as a script ([found here](https://github.com/timperrett/sentinel/blob/master/roles/sentinel/files/sentinel)) and a pair of system units to trigger execution. The script has a few handy switches (see all options using `--help`):

+ `--disable-sftp` Disable uploading to the SFP server; this can be especially useful if you are debugging the setup with your camera and do not care about uploading.
+ `--disable-throttling` Disables the upload on 5 minutely windows; with the systemd units implemented as is here, this will result in uploading every minute. This can be helpful for debuging or if you simply want closer to real-time imaging.

As these are regular systemd units, you can inspect their output using `journalctl -u sentinel.service -e` for the sentinel unit itself, or `systemctl list-timers --all` if you want to checkout the last/next execution of the timer.

