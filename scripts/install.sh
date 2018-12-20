sudo apt-get update
sudo apt-get install -y nginx git-core qrencode python-virtualenv
git clone https://github.com/chubin/qrenco.de
cd qrenco.de
virtualenv ve/
ve/bin/pip install -r requirements.txt

sudo cp config/qrencode.conf /etc/nginx/sites-available/default
mkdir -p ~/log/
nohup ve/bin/python bin/srv.py >> ~/log/qrencode.log 2>&1 &

sudo /etc/init.d/nginx restart
