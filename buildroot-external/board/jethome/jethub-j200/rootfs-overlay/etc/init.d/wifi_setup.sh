#!/bin/sh

SETUP_FLAG="/etc/wifi_configured"
IFACE="wlan0"

if [ -f "$SETUP_FLAG" ]; then
    echo "Уже настроено, пропускаем"
    exit 0
fi

echo "Первый запуск, сканируем Wi-Fi сети..."
wpa_supplicant -B -i "$IFACE" -c /etc/wpa_supplicant.conf

sleep 3
wpa_cli -i "$IFACE" scan
sleep 5

SSID_LIST=$(wpa_cli -i "$IFACE" scan_results | awk 'NR > 2 { print $NF }' | nl)

echo "Обнаружены сети:"
echo "$SSID_LIST"

echo -n "Введите номер нужной сети: "
read -r NUM

SSID=$(echo "$SSID_LIST" | sed -n "${NUM}p" | cut -f2-)
echo "Вы выбрали: $SSID"

echo -n "Введите пароль для $SSID: "
read -r -s PSK
echo

echo "[wifi-setup] Настраиваем подключение..."

CONF=$(mktemp)

cat > "$CONF" <<EOF
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
network={
    ssid="${echo $SSID}"
    psk="${echo $PSK}"
}
EOF

echo "[wifi-setup] Сохраняем конфигурацию..."
cp "$CONF" /etc/wpa_supplicant.conf
rm "$CONF"

killall wpa_supplicant 2>/dev/null
sleep 1

wpa_supplicant -B -i "$IFACE" -c /etc/wpa_supplicant.conf
sleep 3

echo "[wifi-setup] Запускаем DHCP..."
udhcpc -i "$IFACE" -q -n -b

touch "$SETUP_FLAG"
echo "[wifi-setup] Настройка завершена и сохранена."