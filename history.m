
#备份hassbian的配置文件
#开始按照HomeAssiatant.m安装
#先安装python3.6依赖的软件包
sudo apt-get install build-essential tk-dev libncurses5-dev libncursesw5-dev libreadline6-dev libdb5.3-dev libgdbm-dev libsqlite3-dev libssl-dev libbz2-dev libexpat1-dev liblzma-dev zlib1g-dev
#编译安装python3.6
wget https://www.python.org/ftp/python/3.6.3/Python-3.6.3.tgz
tar xzvf Python-3.6.3.tgz
cd Python-3.6.3/
./configure
make
sudo make install
#安装完成查看版本
python -V
python3 -V
pip3 -V
如果是从Python 3.4 升级到 3.6，需要重新安装 HASS，运行前删除配置文件夹中的 deps 文件夹
rm ~/.homeassistant/deps -rf



安装花生壳
cd /tmp
sudo wget http://download.oray.com/peanuthull/embed/phddns_rapi_3.0.2.armhf.deb
sudo chmod 777 phddns_rapi_3.0.2.armhf.deb
sudo dpkg -i phddns_rapi_3.0.2.armhf.deb
假如提交失败打开树莓派
sudo phddns restart

小米空气净化器的接入https://bbs.hassbian.com/thread-2999-1-1.html


