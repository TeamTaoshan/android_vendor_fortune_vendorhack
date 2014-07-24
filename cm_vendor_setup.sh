for combo in $(curl -s https://raw.github.com/CyanogenMod/hudson/master/cm-build-targets | sed -e 's/#.*$//' | sed -e 's/cm_/nameless_/g' |  grep cm-11.0 | awk {'print $1'})
do
    add_lunch_combo $combo
done

