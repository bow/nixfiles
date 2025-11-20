{
  pkgs,
  ...
}:
pkgs.writeShellScript "polybar-module-battery-combined.sh" ''
  SCRIPT_PATH="''$(readlink -f "''$0")"

  # Returns 1 if AC power is connected, 0 otherwise.
  get_ac_status() {
      ac_id=''$(${pkgs.upower}/bin/upower -e | ${pkgs.gnugrep}/bin/grep line_power_AC)
      if ${pkgs.upower}/bin/upower -i "''${ac_id}" | ${pkgs.gnugrep}/bin/grep -Eq 'online:\s+yes'; then
          ${pkgs.coreutils}/bin/echo 1
      else
          ${pkgs.coreutils}/bin/echo 0
      fi
  }

  # Returns the charge percentage from all batteries combined.
  calc_battery_percent() {
      total_energy=0
      total_full=0

      for bat in ''$(${pkgs.upower}/bin/upower -e | ${pkgs.gnugrep}/bin/grep battery_BAT); do
          cur=''$(${pkgs.upower}/bin/upower -i "''$bat" | ${pkgs.gawk}/bin/awk '/energy:/{print ''$2}')
          full=''$(${pkgs.upower}/bin/upower -i "''$bat" | ${pkgs.gawk}/bin/awk '/energy-full:/{print ''$2}')
          total_energy=''$(${pkgs.coreutils}/bin/echo "''$total_energy + ''$cur" | ${pkgs.bc}/bin/bc)
          total_full=''$(${pkgs.coreutils}/bin/echo "''$total_full + ''$full" | ${pkgs.bc}/bin/bc)
      done

      total_full_int="''$(printf "%.0f" "''$total_full")"

      if [ "''$total_full_int" -gt 0 ]; then
          ${pkgs.coreutils}/bin/echo "''$total_energy / ''$total_full" | ${pkgs.bc}/bin/bc -l | ${pkgs.gawk}/bin/awk '{printf("%.0f\n", ''$1 * 100)}'
      fi
  }

  # Prints the power status for display in polybar.
  print_power_status() {
      battery_percent=''$(calc_battery_percent)

      # System does not have battery.
      if [ -z "''$battery_percent" ]; then
          icon=""
          ${pkgs.coreutils}/bin/echo "%{F#504945}''$icon"

      # System has battery and it is plugged in.
      elif [ "''$(get_ac_status)" -eq 1 ]; then

          # Battery is (close to) full.
          if [ "''$battery_percent" -ge 99 ] || [ -z "''$battery_percent" ] ; then
              icon=""
              ${pkgs.coreutils}/bin/echo "%{F#504945}''$icon"

          # Battery is charging.
          else
              icon=""
              ${pkgs.coreutils}/bin/echo "%{F#504945}''$icon %{F#e8e8d3}''$battery_percent%"
          fi

      # System has battery and it is not plugged in.
      elif [ "''$battery_percent" -ge 0 ]; then
          if [ "''$battery_percent" -ge 85 ]; then
              icon=" "
          elif [ "''$battery_percent" -ge 60 ]; then
              icon=" "
          elif [ "''$battery_percent" -ge 40 ]; then
              icon=" "
          elif [ "''$battery_percent" -ge 15 ]; then
              icon=" "
          else
              icon=" "
          fi

          ${pkgs.coreutils}/bin/echo "%{F#504945}''$icon %{F#e8e8d3}''$battery_percent%"

      # Error state.
      else
          icon=""
          ${pkgs.coreutils}/bin/echo "%{F#bd2c40}''$icon"
      fi
  }

    case "''$1" in
        --update)
            pid=''$(pgrep -xf "/bin/sh ''${SCRIPT_PATH}")

            if [ "''$pid" != "" ]; then
                ${pkgs.coreutils}/bin/kill -10 "''$pid"
            fi
            ;;
        *)
            trap exit INT
            trap "${pkgs.coreutils}/bin/echo" USR1

            while true; do
                print_power_status

                ${pkgs.coreutils}/bin/sleep 30 &
                wait
            done
            ;;
    esac
''
