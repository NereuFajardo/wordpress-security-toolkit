# WordPress Security Toolkit

A suite of automated actions to ensure the security of your wordpress.

## Scripts

- **salt-keys.sh**: Generates new keys to ensure the renewal of the encryption of your access data.

- **pingback.sh**: Famous for being an exploit with destructive potential, this ensures you stay safe by disabling pingbacks.

## 1. Clone the repo:

```bash
git clone https://github.com/NereuFajardo/wordpress-security-toolkit.git
```

## 2. Open the directory

```bash
cd wordpress-security-toolkit
```

## 3. Grant permissions

```bash
chmod +x scripts/*.sh
chmod +x run.sh
```

## 4. Run script

```bash
sudo ./run.sh
```

## 5. Open Cron Tab

```bash
crontab -e
```

## 6. Insert cron info 
This will run 1 at week and save log

```bash
0 3 * * 0 /home/ubuntu/wordpress-security-toolkit/run.sh >> /var/log/run_sh_log.log 2>&1
```
