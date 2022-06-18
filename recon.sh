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

echo "[+] Harvesting subdomains with amass..."
amass enum -d $domain | anew $url/a.txt
sort -u $dir/a.txt | anew $dir/amass.txt
rm $dir/a.txt

echo "[+] Harvesting subdomains with assetfinder..."
assetfinder --subs-only $domain | anew $dir/a.txt
sort -u $dir/a.txt | anew $dir/assetfinder.txt
rm $dir/a.txt

echo "[+] Harvesting subdomains with subfinder..."
subfinder -d $domain | anew $dir/a.txt
sort -u $dir/a.txt | anew $dir/subfinderl.txt
rm $dir/a.txt

echo "[+] Harvesting subdomains with Sublist3r..."
python3 Sublist3r/sublist3r.py -d $domain -o $dir/a.txt
sort -u $dir/a.txt | anew $dir/sublist3r.txt
rm $dir/a.txt

echo "[+] Harvesting subdomains with waybackurls..."
echo $domain | waybackurls | anew $dir/a.txt
sort -u $dir/a.txt | anew $dir/waybackurls.txt
rm $dir/a.txt

echo "[+]Sorting subdomains..."
sort -u $dir/amass.txt $dir/assetfinder.txt $dir/subfinder.txt $dir/sublist3r.txt > $dir/final-sd.txt

rm $dir/amass.txt $dir/assetfinder.txt $dir/subfinder.txt $dir/sublist3r.txt

echo "[+]HTTPX..."
httpx -silent -sc -fc 404 -title -list $dir/final-sd.txt | anew $dir/live-sd.txt
httpx -silent -sc -fc 404 -title -list $dir/waybackurls.txt | anew $dir/live-waybackurls.txt

rm $dir/waybackurls.txt
