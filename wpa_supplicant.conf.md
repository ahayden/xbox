## wpa_supplicant.conf for radius and psk wireless

```
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
country=US
update_config=1

network={
  ssid="ssid1"
# get output from `wpa_passphrase ssid1 pskstring`
  psk=pskhash
  priority=10
}
network={
  ssid="ssid2"
# get hash with `wpa_supplicant -Dnl80211 -iwlan0 -c/etc/wpa_supplicant/wpa_supplicant.conf`
  ca_cert="hash://server/sha256/outputhash"
  key_mgmt=WPA-EAP
  eap=PEAP
  identity="username"
# generate with `iconv -t utf16le | openssl md4 >> output`
  password=hash:passwordhash
  phase2="autheap=MSCHAPV2"
  priority=100
}
```
