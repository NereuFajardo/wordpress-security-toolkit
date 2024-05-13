# wordpress-security-toolkit

git clone https://github.com/NereuFajardo/wordpress-security-toolkit.git

cd wordpress-security-toolkit

chmod +x scripts/*.sh

chmod +x run.sh

sudo ./run.sh

crontab -e

0 3 * * * /home/ubuntu/wordpress-security-toolkit/run.sh >> /var/log/run_sh_log.log 2>&1



