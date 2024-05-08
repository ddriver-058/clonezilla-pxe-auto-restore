
This is a PXE image server that uses Clonezilla to automatically restore images based on the device's MAC address. 

I first developed it in my bare-metal RKE implementation. Most recently, I used it to deploy Vagrant hosts. 

You should be able to:
- Populate values in dhcpd.conf
- Populate values in pxelinux.cfg/default
- Dump your Clonezilla saved image to a folder within image-samba/images
- Populate values in api.yaml, including your CZ saved image folder (e.g., my-img-1)

Then run 'docker compose up' to start the PXE server!

The most essential pieces are:
- A Docker Compose deployment that configures a PXE server, a samba share to host images from, and an R HTTP server (api.r)
- a pxelinux.cfg file containing the PXE configuration, including the ocs_live_run and ocs_prerun commands that automate image restoration
- a script getAndRunOcsSrCall.sh that hits the HTTP server with ifconfig output to receive an inner script, ocs-sr.sh, that calls a Clonezilla command to restore the correct image
- a configuration file api.yaml that maps MAC addresses to an ocs-sr command that loads the correct image, referencing an image from the samba share (image-samba/images)
