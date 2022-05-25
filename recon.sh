#!/bin/bash

domain=$1

if [ ! -d "$domain" ]; then
	mkdir $domain
fi

if [ ! -d "$domain/recon" ]; then
	mkdir $domain/recon
fi

url=$domain/recon

echo "[+]Harvesting subdomains with amass..."
amass enum -d $domain max-dns-queries 100 >> $url/a.txt
sort -u $url/a.txt >> $url/amass-final.txt
rm $url/a.txt

echo "[+]Harvesting subdomains with assetfinder..."
assetfinder --subs-only $domain >> $url/a.txt
sort -u $url/a.txt >> $url/assetfinder-final.txt
rm $url/a.txt

echo "[+]Harvesting subdomains with subfinder..."
subfinder -d $domain >> $url/a.txt
sort -u $url/a.txt >> $url/subfinder-final.txt
rm $url/a.txt

echo "[+]Harvesting subdomains with waybackurls..."
echo $domain | waybackurls >> $url/a.txt
sort -u $url/a.txt >> $url/waybackurls.txt
rm $url/a.txt

echo "[+]Sorting subdomains..."
sort -u $url/amass-final.txt $url/assetfinder-final.txt $url/subfinder-final.txt >> $url/domain-final.txt
