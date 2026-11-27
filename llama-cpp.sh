#!/data/data/com.termux/files/usr/bin/bash

clear

yes | pkg install llama-cpp -y

curl -#LOC - https://huggingface.co/itlwas/Qwen2-Math-1.5B-Instruct-Q4_K_M-GGUF/resolve/main/qwen2-math-1.5b-instruct-q4_k_m.gguf

cat > ~/ai.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash

MODEL="qwen2-math-1.5b-instruct-q4_k_m.gguf"
PORT=8080

# Detect Wi-Fi LAN IP
ip_address=$(python -c '
import socket

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
try:
    s.connect(("8.8.8.8", 80))
    ip = s.getsockname()[0]
    if ip.startswith("127.") or ip == "0.0.0.0":
        print("IP_NOT_FOUND")
    else:
        print(ip)
except OSError:
    print("IP_NOT_FOUND")
finally:
    s.close()
' 2>/dev/null)

clear
echo "=================================="
echo "       LOCAL AI SERVER"
echo "=================================="
echo ""
echo " Model : $MODEL"
echo " Host  : 0.0.0.0"
echo " Port  : $PORT"
echo ""

if [ "$ip_address" != "IP_NOT_FOUND" ] && [ -n "$ip_address" ]; then
    echo " WiFi LAN IP : $ip_address"
    echo " LAN URL     : http://$ip_address:$PORT"
else
    echo " WiFi LAN IP : Not Connected"
fi

echo ""
echo " Local URL   : http://127.0.0.1:$PORT"
echo "=================================="
echo ""
echo "Starting AI Server..."
echo ""

llama serve \
    -m "$MODEL" \
    -t 4 \
    --host 0.0.0.0 \
    --port "$PORT"
EOF

chmod +x ~/ai.sh


