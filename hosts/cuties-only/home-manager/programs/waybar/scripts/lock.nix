{pkgs}:
pkgs.writeShellScript "lock" ''
  map_leds() { sed 's/0/-/g; s/1/x/g'; }
  echo "󰞙 $(getleds n | map_leds) 󰘲 $(getleds c | map_leds) 󰞒 $(getleds s | map_leds)"
''
