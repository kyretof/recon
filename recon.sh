#!/bin/bash

domain=$1
dir=$domain/recon
a=$dir/a.txt

if [ ! -d "$domain" ]; then
	mkdir $domain
fi

if [ ! -d "$dir" ]; then
	mkdir $dir
fi

echo “[+] Harvesting subdomains with amass...”
amass enum -d $domain | anew $url/a.txt
sort -u $dir/a.txt | anew $dir/amass.txt
rm $dir/a.txt

echo “[+] Harvesting subdomains with assetfinder...”
assetfinder --subs-only $domain | anew $dir/a.txt
cat $dir/a.txt | anew $dir/assetfinder.txt
rm $dir/a.txt

echo “[+] Harvesting subdomains with subfinder...”
subfinder -d $domain | anew $dir/a.txt
sort -u $dir/a.txt | anew $dir/subfinderl.txt
rm $dir/a.txt

echo “[+] Harvesting subdomains with waybackurls...”
echo $domain | waybackurls | anew $dir/a.txt
sort -u $dir/a.txt | anew $dir/waybackurls.txt
rm $dir/a.txt

echo "[+]Sorting subdomains..."
sort -u $dir/amass.txt $dir/assetfinder.txt $dir/subfinder.txt > $dir/final-sd.txt

#rm $dir/amass.txt $dir/assetfinder.txt $dir/subfinder.txt

echo "[+]HTTPX..."
httpx -silent -status-code -title -fc 404 -list $dir/final-sd.txt | anew $dir/live-sd.txt
httpx -silent -status-code -title -fc 404 -list $dir/waybackurls.txt | anew $dir/live-waybackurls.txt
