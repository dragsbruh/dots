# parts blatantly stolen from https://github.com/maxwell-bland/i3-natural-scrolling-and-tap/blob/master/inverse-scroll.sh
# dont tell anyone, tho :3

xinput set-prop "MSFT0001:01 04F3:31BE Touchpad" "libinput Tapping Enabled" 1 &

# id=`xinput list | grep -i "Touchpad" | cut -d'=' -f2 | cut -d'[' -f1`
# natural_scrolling_id=`xinput list-props $id | \
#                       grep -i "Natural Scrolling Enabled (" \
#                       | cut -d'(' -f2 | cut -d')' -f1`

xinput --set-prop $id $natural_scrolling_id 1
