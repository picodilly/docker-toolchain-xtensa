# ensure that the xtensa toochain is in the search path
export PATH=$PATH:$HOME/local/bin
# set esp32 dev kit path
export IDF_PATH=$HOME/esp32/esp-idf
# enable download
alias get-esp-idf='mkdir -p $IDF_PATH && cd $IDF_PATH && git clone --recursive https://github.com/espressif/esp-idf .'
