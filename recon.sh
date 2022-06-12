#!/bin/bash

domain=$1
url=$domain/recon
a=$url/a.txt

if [ ! -d "$domain" ]; then
	mkdir $domain
fi

if [ ! -d "$url" ]; then
	mkdir $url
fi

echo "[+]Harvesting subdomains with amass..."
amass enum -d $domain max-dns-queries 100 >> $a
sort -u $a >> $url/amass.txt
rm $a

echo "[+]Harvesting subdomains with assetfinder..."
assetfinder --subs-only $domain >> $a
sort -u $a >> $url/assetfinder.txt
rm $a

echo "[+]Harvesting subdomains with subfinder..."
subfinder -d $domain >> $a
sort -u $a >> $url/subfinder.txt
rm $a

echo "[+]Harvesting subdomains with waybackurls..."
echo $domain | waybackurls >> $a
sort -u $a >> $url/waybackurls.txt
rm $a

echo "[+]Sorting subdomains..."
sort -u $url/amass.txt $url/assetfinder.txt $url/subfinder.txt >> $url/final-sd.txt

rm $url/amass.txt $url/assetfinder.txt $url/subfinder.txt

echo "[+]HTTPX..."
httpx -l $url/final-sd.txt -silent -status-code -title -sr $url/live-sd.txt
