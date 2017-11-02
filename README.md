# Bitsnet Login
This is a script for logging into the Captive Portal at BITS Goa

## Features
- Save your username and password once and login with ease.
- Use UNLIMITED accounts to login. (You'll need the ID and password, of course)
- Logout from the commandline. No need to keep the login page open.
- Use CLI or App.
- Update from the CLI with single command.
- Man page for integrated experience with the GNU/Linux desktop
- Easy installation.

## Usage
Use the installed app from launcher
OR
Use terminal to issue this command: ```bitsnet```

### Options
```
    -u USERNAME
        Use specific username
    -p PASSWORD
        Specify a different password
    -o
        Logout
    -f
        Force login attempt
    -U
        Update program
    -q
        Quiet mode. Don't send a notification
    -h
        Display help
    -d
        Turn debug on
```

## How to install
- Fire up a terminal and punch in these commands:
```
git clone https://github.com/OSDLabs/BitsnetLogin
cd BitsnetLogin
make
sudo make install
```
- You can now login via terminal (`bitsnet`) or by launching the app from launcher
- Run `man bitsnet` or `bitsnet -h` for help

NOTE: You'll need to use this command if upgrading from version 1.x.x: `rm ~/.bitsnetrc`

## Suggestion, comments or complaints
You can add your suggestions, complaints or any bugs you find [here](https://github.com/OSDLabs/BitsnetLogin/issues).

## Author
[UTkarsh Maheshwari](https://github.com/UtkarshMe),  
**[OSDLabs](https://github.com/OSDLabs)**

## License
[GPL version 3](https://github.com/OSDLabs/BitsnetLogin/blob/master/LICENSE)
