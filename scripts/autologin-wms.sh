#!/bin/sh
#
# Script untuk login otomatis di jaringan venue WMS
# Oleh: KopiJahe (https://github.com/kopijahe)

# Selama script berjalan, lakukan hal ini:
while [ true ]; do
# Buat variabel randomid yang terdiri dari 4 karakter yang terdiri dari angka 0-9 serta huruf a-z dan A-Z
randomid=$(head -4 /dev/urandom | tr -dc "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" | head -c4)
# Tentukan variabel loginwifi dari berkas /etc/login_wms.txt
# Jangan lupa untuk berikan izin eksekusi berkas dengan perintah:
# chmod +x /etc/login_wms.txt
loginwms=$(eval "echo \"$(cat /etc/login_file.txt)\"")
# Tentukan variabel status dari hasil unduhan berkas
# dari: http://periksakoneksi.kopijahe.my.id/cek
# dan simpan hasilnya di stdout
status=$(curl --silent --max-redirs 1 --connect-timeout 10  "http://periksakoneksi.kopijahe.my.id/cek")
# Jika variabel status hasil unduhan tadi sama dengan "OK", maka
if [[ "$status" = "OK" ]]; then
# Beritahu pengguna bahwa sudah terkoneksi dengan Internet
# Dan simpan hasilnya di /tmp/internet.status untuk pengecekan
echo "Sudah terkoneksi dengan Internet" | tee /tmp/internet.status
# Jika hasilnya tidak sama, berarti tidak terkoneksi dengan Internet, maka:
else
# Catat tanggal dan jam login terakhir,
echo "Percobaan login terakhir:" | tee /tmp/last.login
date | tee -a /tmp/last.login
# Catat pula status percobaan login terakhir
echo "Status percobaan login terakhir:" | tee -a  /tmp/last.login
# Dan lakukan login, serta catat semua hasilnya di berkas /tmp/last.login untuk pengecekan
$loginwms | tee -a /tmp/internet.status /tmp/last.login | logger
fi
# Istirahat selama 10 detik sebelum melakukan pengecekan lagi
sleep 10
# Selesai
done