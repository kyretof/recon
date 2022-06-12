#!/bin/bash

domain=$1
a=$url/a.txt

if [ ! -d "$domain" ]; then
	mkdir $domain
fi

if [ ! -d "$url" ]; then
	mkdir $url
fi

url=$domain/recon

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
sort -u $url/amass.txt $url/assetfinder.txt $url/subfinder.txt >> $url/subdomain-final.txt

rm $url/amass.txt $url/assetfinder.txt $url/subfinder.txt

echo "[+]HTTPX..."
httpx -silent -status-code -title -tech-detect -list  subdomain-final.txt
