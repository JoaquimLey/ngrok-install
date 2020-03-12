# ngrok-install
A simple-self sufficient script that installs a ngrok ssh tunnel service that runs on boot for the raspberry pi:

## Install

You'll need your account's `AUTH_TOKEN` get it on your ngrok's dashboard: 
- https://dashboard.ngrok.com/auth

On your Pi's shell
1. Copy/Download the `install.sh` file
2. Give permission:
 ```
sudo chmod 755 install.sh
```
3. Run
```
sudo ./install.sh <AUTH_TOKEN> <REGION>
```
- `REGION` argument is optional (defaults to `us`)

## Uninstall
To stop/remove ngrok from your pi

On your Pi's shell
1. Copy/Download the `uninstall.sh` file
2. Give permission:
 ```
sudo chmod 755 uninstall.sh
```
3. Run

```
sudo ./uninstall.sh
```

---------------------

## Alias
I've written an alias to make it simple to connect to ngrok tunnels.

On your local machine's `bash`/`zshrc` add:
```
alias ngrok='function _f() { ssh -p "$1" pi@0.tcp."${2:-eu}".ngrok.io } ; _f'
```

#### Connect using the alias
Open the terminal and run:
```
ngrok PORT REGION
```
- `REGION` argument is optional: `<us|eu|ap|au>`

Since **I'm in Europe I've defaulted** the alias to `eu`, depending on your region you can change:
`"${2:-eu}"` to your choice of default region, **e.g:** `"${2:-us}"`

#### Now to ssh into any of my pi's I just run
_where `11223` is the port:_
```bash
ngrok 11223

# Same as (depending on your default value)
ngrok 11223 <us|eu|ap|au>

# Or if I wish to connect to my non-default region
ngrok 11223 us
```

### Misc

- Special thanks: https://github.com/vincenthsu/systemd-ngrok
- I'm not affiliated with ngrok.com or inconshreveable.com

### License

	Copyright © 2020 Joaquim Ley

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.
	See the License for the specific language governing permissions and
	limitations under the License.