import re
import requests
import time
import csv

VT_API_KEY = "*******"
VT_IP_URL = "https://www.virustotal.com/api/v3/ip_addresses/{}"
HEADERS = {"x-apikey": VT_API_KEY}

def extract_ips_from_txt(file_path):
    pattern = re.compile(r'"key"\s*:\s*"([^"]+)"')
    with open(file_path, 'r') as f:
        content = f.read()
    return pattern.findall(content)

def query_virustotal_ip(ip):
    url = VT_IP_URL.format(ip)
    try:
        response = requests.get(url, headers=HEADERS)
        if response.status_code == 200:
            data = response.json()
            attrs = data.get('data', {}).get('attributes', {})
            country = attrs.get('country', 'Unknown')
            malicious_votes = attrs.get('last_analysis_stats', {}).get('malicious', 0)
            return country, malicious_votes
        else:
            print(f"VT API error for IP {ip}: HTTP {response.status_code}")
            return "Unknown", 0
    except Exception as e:
        print(f"Exception querying VT for IP {ip}: {e}")
        return "Unknown", 0

if __name__ == "__main__":
    filename = "ips.txt"
    output_csv = "ips_malicious.csv"
    ips = extract_ips_from_txt(filename)
    print(f"Extraídas {len(ips)} IPs del archivo.")

    with open(output_csv, mode='w', newline='') as csvfile:
        fieldnames = ['ip', 'country', 'malicious_votes']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()

        for idx, ip in enumerate(ips, 1):
            country, malicious = query_virustotal_ip(ip)
            print(f"{idx}/{len(ips)}: {ip} => País: {country}, Malicious votes: {malicious}")
            writer.writerow({'ip': ip, 'country': country, 'malicious_votes': malicious})

            if idx < len(ips):
                time.sleep(0.1)  # Para respetar límite API

    print(f"Resultados guardados en {output_csv}")
