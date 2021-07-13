
SCRIPT_DIR=$(dirname "$0") 
YQ=$SCRIPT_DIR/yq
if [ -d "$1" ]
then
for o in $1/*.yaml; do 
    echo Scrubbing $o
    cat $o |  $YQ eval '.data.username="hidden-username"' - |    $YQ eval '.data.".dockercfg"="hidden-docker"'  - | $YQ eval '.data.password="hidden-password"'  - > tmp.yaml 
    mv tmp.yaml $o
    echo 'Scrubbed file: ' $o
    cat $o
    echo '----'
done
fi