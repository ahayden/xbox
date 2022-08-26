# Set up container runner
For Alfa AWUS036ACH, with Realtek 8812AU chipset, on raspberry pi 4 (aarch64) 
compile kernel module and install via DKMS

```
sudo apt-get install rasbperrypi-kernel-headers dkms 
cd && git clone https://github.com/ahayden/rtl8812au
cd rtl8812au
export ARCH=arm64
sed -i 's/^MAKE="/MAKE="ARCH=arm64\ /' dkms.conf
sed -i 's/CONFIG_PLATFORM_ARM64_RPI = n/CONFIG_PLATFORM_ARM64_RPI = y/g' Makefile
make
sudo make dkms_install
```
### Confirm module loads
`lsmod |grep 88XXau`

### Install docker engine
```
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
 $ sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

# Set up container
1. Read the Dockerfiles and GitHub Actions scripts.
2. Fork this repo into your user namespace in GitHub. The workflow will
   build and register containers for you. The users in the containers
   will be named after your GitHub user.
3. Generate an SSH keypair on your container runner
   - `ssh-keygen -t ecdsa -f ~/.ssh/xbox`
4. Run the base container and copy the public part of the new key in
   - `docker compose run base /bin/bash -l`
   - paste the contents of `~/.ssh/xbox.pub` on your container runner 
     into `~/.ssh/authorized_keys` in the container environment
   - `chmod 644 ~/.ssh/authorized_keys`
5. Append a host definition like this to `~/.ssh/config` on your
   container runner 
   ```
   Host xbox
     HostName localhost
     Port 2222
     LocalForward 5910 xbox:5910
     User ${your_github_username}
     IdentityFile ~/.ssh/xbox
   ```
6. Edit `docker-compose.yaml` to make two changes:
   1. Change all references of `image:` to your GHCR user namespace:
      `image: ghcr.io/${your_github_user}/xbox:base`
   2. Share only the mounts you want between your host filesystem and 
      the xbox/base containers. It is currently sharing the following:
      ```
         - ~/src:/home/$USER/src
         - ~/.config/git:/home/$USER/.config/git
         - ~/.vimrc:/home/$USER/.vimrc
      ```

## Display
1. You can override the Xvfb resolution by adding a string that defines
   resolution and color depth in a `.env` file in the same director as the
   compose file:
   ```
   $ cat .env 
     RESOLUTION=2560x1600x24
   ```
2. HiDP works
  - `mate-tweak` -> Windows -> HiDP to scale up most apps to have crisp fonts
  - Set the MacOS VNC client to Display -> Show full size
  - Pass `-Dsun.java2d.uiScale=2.0` to a java app

## Connecting
1. Run the graphical container from your container runner
   - `docker compose up`
2. Bring up the SSH tunnel in another shell on your container runner
   - `ssh xbox`
3. VNC connect to through the tunnel, with something like MacOS Screen
   Sharing
   - Finder -> Go -> Connect to Server -> `vnc://localhost:5910`
   - See 'Bugs' for a password string
- 'Container runner' could possibly use the `base` container as bastion 
remote host instead...

### Or, just run container
I.e., `docker compose run headless bash`

## Bugs
- There is currently a bug in MacOS 11.2 that does not allow the VNC
(MacOS Screen Sharing) dialog to connect through with null passwords, so 
this script sets the VNC password to "fixthisbug". This is fine because 
the VNC interface is presented only to the container network and 
authorization actually happens at the SSH step.

