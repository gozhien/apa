#!/bin/bash

# --- KONFIGURASI PATH & PORT ---
BIN_UZ="./uz.so"
BIN_LOAD="./load.so" # Sesuaikan path libload Anda
LOG="load.log"

L_PORTS_UZ=("1080" "1081" "1082" "1083" "1084" "1085" "1086" "1087")
L_PORT_LOAD="7777" # Port output gabungan (load)

# --- KONFIGURASI AKUN & PARAMETER TUNNEL ---
SERVER="ip_atau_domain_server_anda"     # Isi dengan Server Anda
PASSWORD="password_akun_anda"           # Isi dengan Password Anda
OBFS_KEY='hu``hqb`c'
SERVER_PORTS="6000-7750,7751-9500,9501-11225,11251-13000,13001-14750,14751-16500,16501-18250,18251-19999"

# Konfigurasi Limit & Jendela Terima
UP_SPEED="1 Mbps"
DOWN_SPEED="3 Mbps"
RECV_WINDOW_CONN=4194304
RECV_WINDOW=1048576

# --- FUNGSI CLEANUP ---
cleanup() {
    pkill -9 -f "$BIN_UZ" > /dev/null 2>&1
    pkill -9 -f "libload" > /dev/null 2>&1
}

# Pastikan environment bersih sebelum mulai
cleanup

# --- EKSEKUSI ---
clear
echo "Memulai Tunnel UZ..."

# 1. Jalankan UZ sebanyak list port (8 port berbeda)
for PORT in "${L_PORTS_UZ[@]}"; do
    JSON_STRING="{\"server\":\"$SERVER:$SERVER_PORTS\",\"obfs\":\"$OBFS_KEY\",\"auth\":\"$PASSWORD\",\"socks5\":{\"listen\":\"127.0.0.1:$PORT\"},\"insecure\":true,\"up\":\"$UP_SPEED\",\"down\":\"$DOWN_SPEED\",\"recvwindowconn\":$RECV_WINDOW_CONN,\"recvwindow\":$RECV_WINDOW}"

    $BIN_UZ -s "$OBFS_KEY" -c "$JSON_STRING" > /dev/null 2>&1 &
    echo "[+] UZ started on port $PORT"
done

# 2. Jalankan LOAD (menggunakan format tunnel 1-4 seperti aslinya)
echo "[+] Starting LOAD..."
$BIN_LOAD -lhost 127.0.0.1 -lport $L_PORT_LOAD -tunnel 127.0.0.1:1080 127.0.0.1:1081 127.0.0.1:1082 127.0.0.1:1083 >> $LOG 2>&1 &

echo "BERHASIL! Proxy SOCKS5 (Gabungan) berjalan di port $L_PORT_LOAD"

# Trap untuk cleanup saat script dihentikan (CTRL+C)
trap "cleanup; exit" SIGINT SIGTERM
while true; do sleep 1; done
