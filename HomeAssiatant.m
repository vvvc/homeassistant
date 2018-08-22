sudo hassbian-config install homeassistant
#如果等待时间过久却没有出现初始界面，可尝试使用以下命令强制初始安装：
sudo systemctl enable install_homeassistant.service
sudo systemctl start install_homeassistant.service

#如果使用此方法，未来更新指令如下：//我还没有更新过
sudo systemctl stop home-assistant@homeassistant.service
sudo su -s /bin/bash homeassistant
source /srv/homeassistant/bin/activate
pip3 install --upgrade homeassistant
exit
sudo systemctl start home-assistant@homeassistant.service

#更新源信息
sudo nano /etc/apt/sources.list

#用上下左右调整光标在所有源前面将第一行用#注释掉，并将如下源复制，右击鼠标右键粘进去，然后Ctrl+x，输入y保存。
deb http://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian/ stretch main contrib non-free rpi
deb-src http://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian/ stretch main contrib non-free rpi

#然后继续修改源，首先输入如下命令，回车
sudo nano /etc/apt/sources.list.d/raspi.list

#然后跟上面一样的操作方法
deb http://mirror.tuna.tsinghua.edu.cn/raspberrypi/ stretch main ui
deb-src http://mirror.tuna.tsinghua.edu.cn/raspberrypi/ stretch main ui

#然后就能愉快的更新了，等代码跑完就完成了源更新了
sudo apt-get update
sudo apt-get install npm
sudo npm install -g n
sudo n stable


#安装samba
sudo hassbian-config install samba
#重启samba
sudo service smbd restart


#安装Mosquitto，这个就是MQTT平台，方便接入第三方设备，比如sonoff等设备
sudo hassbian-config install mosquitto
#安装cloud9编辑器
sudo hassbian-config install cloud9



#默认数据库建议更换为MariaDB数据库，毕竟好太多
sudo hassbian-config install mariadb
#新建数据库，回车后会提醒输入密码。密码输错想退格按Ctrl+C结束命令，之后重新执行即可。
sudo mariadb -u root -p
#新建数据表单，先将下面的“user”和“pwd”手动改成你的，再粘贴进去，回车，user可能是admin、root、pi，pwd为自己设置的密码。
CREATE DATABASE hass_db;
CREATE USER 'user'@'localhost' IDENTIFIED BY 'pwd';
GRANT ALL PRIVILEGES ON *.* TO 'user'@'localhost';
FLUSH PRIVILEGES;
exit
#这样MariaDB数据库就装好了

#接下来就安装HomeKit环境首先安装git和screen
sudo apt-get install -y screen git

#然后安装nodejs（粘贴一行回车后执行完再粘贴第二行）
nodejs -v
#如果有v8.xx.x之类的版本号，下面的两行就别执行了
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs

#安装Homekit依赖包libavahi（一行一行输入回车）
sudo apt-get -y install libavahi-compat-libdnssd-dev
#sudo npm install -g --unsafe-perm homebridge hap-nodejs node-gyp
sudo npm install -g --unsafe-perm hap-nodejs node-gyp

cd /usr/local/lib/node_modules/homebridge/
#如果有显示不存在文件夹，替换成 下面一行
cd /usr/lib/node_modules/homebridge/

sudo npm install --unsafe-perm bignum

cd /usr/local/lib/node_modules/hap-nodejs/node_modules/ed25519-hap/
#如果有显示不存在文件夹，替换成 下面一行
cd /usr/lib/node_modules/hap-nodejs/node_modules/ed25519-hap/

sudo node-gyp BUILDTYPE=Release rebuild
#安装HomeBridge的插件HomeBridge-HomeAssitant
cd /
sudo npm install -g homebridge-homeassistant

#安装完了就线运行以下homebridge
homebridge

#然后看到报错信息，按Ctrl+C停止homebridge运行，然后输入如下命令
cd /home/pi/.homebridge
sudo nano config.json

#然后将如下的命令中树莓派MAC地址、访问地址和HomeAssistant的密码（默认是raspberry）和Pin码（这个可改可不改，但要遵循123-45-678的格式）黏贴如下命令
#下文内#之后的备注  粘帖进去之前 最好删掉
{
    "bridge": {
        "name": "HomeKit",
        "username": "B8:D2:EB:47:4A:71", #树莓派MAC地址，改成你自己的
        "port": 56666,
        "pin": "111-12-222"
    },
    "platforms": [{
        "platform": "HomeAssistant",
        "name": "HomeAssistant",
        "host": "http://192.168.1.XXX:8123", #HomeAssistant的访问地址，改成自己的
        "password": "raspberry", #HomeAssistant的密码，默认是raspberry
        "supported_types": ["binary_sensor","cover","fan","garage_door","input_boolean","light","lock","media_player","rollershutter","scene","sensor","switch","climate","script","automation"],
        "default_visibility": "visible"
    }]
}

#然后按Ctrl+X键，输入y，保存退出
#然后重新运行homebridge服务，输入如下命令，回车
homebridge

#可以试试iphone上家庭添加，看是否出现homebridge，没什么问题了就按Ctrl+C停止homebridge运行

#上面的设置都按照我的步骤，这边就能显示出你设置的pin码或者就是111-12-222
#然后就正式启动homebridge服务了，逐行输入如下命令
cd /
sudo useradd --system homebridge
sudo mkdir /var/homebridge
sudo cp ~/.homebridge/config.json /var/homebridge/
sudo cp -r ~/.homebridge/persist /var/homebridge
sudo chmod -R 0777 /var/homebridge

#快成功了，输入如下命令
cd /etc/default
sudo nano homebridge

#然后黏贴如下内容，按Ctrl+X键，输入y，保存退出
开始此行不要复制
# Defaults / Configuration options for homebridge
# The following settings tells homebridge where to find the config.json file and where to persist the data (i.e. pairing and others)
HOMEBRIDGE_OPTS=-U /var/homebridge

# If you uncomment the following line, homebridge will log more 
# You can display this via systemd's journalctl: journalctl -f -u homebridge
# DEBUG=*
结束此行不要复制

#然后继续输入如下命令
cd /etc/systemd/system
sudo nano homebridge.service

#继续黏贴如下内容，按Ctrl+X键，输入y，保存退出
开始复制此行不要复制
[Unit]
Description=Node.js HomeKit Server 
After=syslog.target network-online.target

[Service]
Type=simple
User=homebridge
EnvironmentFile=/etc/default/homebridge
ExecStart=/usr/local/lib/node_modules/homebridge/bin/homebridge $HOMEBRIDGE_OPTS
Restart=on-failure
RestartSec=10
KillMode=process

[Install]
WantedBy=multi-user.target
结束复制此行不要复制

#最后一步设置下homebridge的开机启动
cd /
sudo systemctl daemon-reload
sudo systemctl enable homebridge

#这样基本的环境就搭建好了，然后重启树莓派即可
sudo reboot

#重启后查看homebridge运行状态
sudo systemctl status homebridge.service




