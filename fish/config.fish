if status is-interactive
    # Commands to run in interactive sessions can go here

    set -U fish_greeting

    set -gx PATH $HOME/.bun/bin $PATH
    set -gx PATH $HOME/.cargo/bin $PATH
    set -gx PATH $HOME/go/bin $PATH
    set -gx PATH $HOME/.duckdb/cli/latest $PATH
    set -gx PATH $HOME/.local/bin $PATH
    set -gx PATH $HOME/.spicetify $PATH
    set -gx PATH /home/linuxbrew/.linuxbrew/bin $PATH

    abbr ls exa
    abbr ll "exa -la"
    abbr tree "exa --tree"
    abbr hx helix
    abbr cinny "$HOME/tools/cinny/cinny.AppImage"
    abbr anytype "$HOME/tools/anytype/anytype.AppImage"
    abbr obsidian "$HOME/tools/obsidian/obsidian.AppImage"

    # i think ill come around to zoxide later
    # zoxide init fish | source
    # alias cd z

    starship init fish | source
    enable_transience

    function vencord_update
        sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"
    end

    function git
        # the fact that i need this utility is embarassing
        # i copy `git clone <url>`
        # and if forget the command contains `git clone`
        # and type `git clone <paste>`
        # which resolves to `git clone git clone <url>`
        if test (count $argv) -ge 3
            if test "$argv[1]" = clone; and test "$argv[2]" = git
                set argv $argv[1] $argv[3..-1]
            end
        end
        command git $argv
    end

    function reload
        . ~/.config/fish/config.fish
    end

    function mountwin
        sudo mount -t ntfs-3g -o ro /dev/nvme0n1p3 /mnt/windows
    end

    function umountwin
        sudo umount /mnt/windows
    end

    function musicdl
        set -l audio_format mp3
        set -l metadata --write-info-json
        set -l output_path "."
        set -l dry_run 0

        argparse n 'f=' 'o=' d -- $argv
        or return 1

        if set -q _flag_n
            set metadata ""
        end

        if set -q _flag_f
            set audio_format $_flag_f
        end

        if set -q _flag_o
            set output_path $_flag_o
        end

        if set -q _flag_d
            set dry_run 1
        end

        set -l url (string join " " $argv)

        if test -z "$url"
            echo "Usage: musicdl [-n] [-f format] [-o output_path] [-d] <URL>"
            return 1
        end

        mkdir -p $output_path

        set -l yt_cmd "yt-dlp --extract-audio --audio-format $audio_format $metadata --output \"$output_path/%(title)s.%(ext)s\" $url"

        if test $dry_run -eq 1
            echo "Dry run: $yt_cmd"
            return
        end

        eval $yt_cmd

        if test -n "$metadata"
            set -l title (yt-dlp --get-title $url)
            mv "$output_path/$title.info.json" "$output_path/$title.json"
        end
    end
    function soundboardon
        set MIC "alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Mic1__source"
        set OUT "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Speaker__sink"
        set IDS "/tmp/soundboard.txt"

        # Check if soundboard is already initialized and load the appropriate modules if not
        if test -f $IDS -a -s $IDS
            echo "Soundboard already initialized, checking existing modules..."
            # Check for existing SoundBoard sink and loopbacks
            set existing_sinks (pactl list short sinks | grep "SoundBoard")
            set existing_sources (pactl list short sources | grep "SoundBoard")

            # If SoundBoard sink exists, unload it
            if test -n "$existing_sinks"
                echo "SoundBoard sink found, unloading..."
                pactl unload-module (echo $existing_sinks | awk '{print $1}')
            end

            # If CombinedInput sink exists, unload it
            set existing_combined_input (pactl list short sinks | grep "CombinedInput")
            if test -n "$existing_combined_input"
                echo "CombinedInput sink found, unloading..."
                pactl unload-module (echo $existing_combined_input | awk '{print $1}')
            end

            # If loopbacks exist, unload them
            set existing_loopbacks (pactl list short modules | grep "module-loopback")
            for loopback in $existing_loopbacks
                echo "Existing loopback found, unloading..."
                pactl unload-module (echo $loopback | awk '{print $1}')
            end
        else
            echo "Soundboard not initialized, proceeding with initialization..."
        end

        # Reset soundboard initialization file
        echo -n >$IDS

        # Load modules
        pactl load-module module-null-sink media.class=Audio/Sink channel_map=front-left,front-right sink_name=SoundBoard >>$IDS
        pactl load-module module-null-sink sink_name=CombinedInput sink_properties=device.description="CombinedInput" >>$IDS

        pactl load-module module-loopback source=SoundBoard.monitor sink=$OUT latency_msec=1 >>$IDS
        pactl load-module module-loopback source=SoundBoard.monitor sink=CombinedInput latency_msec=1 >>$IDS
        pactl load-module module-loopback source=$MIC sink=CombinedInput latency_msec=1 >>$IDS

        # Set volume and default source
        pactl set-source-volume SoundBoard.monitor 50000
        pactl set-source-volume $MIC 60000
        pactl set-default-source CombinedInput.monitor

        echo "Soundboard initialized"
    end

    function soundboard
        if test -z "$argv"
            echo "What file do I play?"
            return 1
        end

        # Check if the SoundBoard sink exists before attempting to play audio
        set soundboard_sink (pactl list short sinks | grep "SoundBoard")
        if test -z "$soundboard_sink"
            echo "SoundBoard sink not found! Please initialize the soundboard first."
            return 1
        end

        # Play file using mpv
        mpv --audio-device=pulse::SoundBoard $argv
    end

    function airpodsup
        bluetoothctl connect 4C:B9:10:6D:71:5A
        sleep 3
        pactl set-default-sink bluez_output.4C_B9_10_6D_71_5A.1
    end

    function airpodsdown
        pactl set-default-sink alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Speaker__sink
        bluetoothctl disconnect 4C:B9:10:6D:71:5A
    end

    /usr/bin/pfetch
end

fish_add_path /home/dragsbruh/.spicetify
nvm use latest >> /dev/null
