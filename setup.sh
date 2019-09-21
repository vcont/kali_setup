#!/bin/bash
# icons
# ❌⏳💀🎉 ℹ️ ⚠️ 🚀 ✅ ♻ 🚮 🛡 🔧  ⚙ 

# run update and upgrade, before running script
# apt update && apt upgrade -y
## curl -L --silent https://bit.ly/31BE8PI | bash
#
#
# TODO 
# /usr/bin/script --append --flush --timing=timing_"$(date +"%Y_%m_%d_%H_%M_%S_%N_%p").log" terminal_"$(date +"%Y_%m_%d_%H_%M_%S_%N_%p").log"
# pip3 list --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install --upgrade
# pip list --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install --upgrade

# set colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE="\033[01;34m" # Heading
NO_COLOR='\033[0m'
CLEAR_LINE='\r\033[K'
BOLD="\033[01;01m" # Highlight
RESET="\033[00m" # Normal

# set env variable for apt-get installs
export DEBIAN_FRONTEND=noninteractive

# set git to cache credentials for 30 minutes
git config --global credential.helper "cache --timeout=1800"

# verify running as root
if [[ "${EUID}" -ne 0 ]]; then
  echo -e ' '${RED}'[!]'${RESET}" This script must be ${RED}run as root${RESET}" 1>&2
  echo -e ' '${RED}'[!]'${RESET}" Quitting..." 1>&2
  exit 1
else
  echo -e "  🚀 ${BOLD}Starting Kali setup script${RESET}"
fi

# enable https repository
cat <<EOF>/etc/apt/sources.list
deb https://http.kali.org/kali kali-rolling main non-free contrib
EOF

compute_start_time(){
    start_time=$(date +%s)
    echo "\n\n Install started - $start_time \n" >> script.log
}

configure_environment(){
    echo "HISTTIMEFORMAT='%m/%d/%y %T '" >> /root/.bashrc
}

apt_update() {  
    printf "  ⏳  apt-get update\n" | tee -a script.log
    apt-get update -qq >> script.log 2>>script_error.log
}

apt_upgrade() {
    printf "  ⏳  apt-get upgrade\n" | tee -a script.log
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -qq >> script.log 2>>script_error.log
}

apt_package_install() {
    echo "\n [+] installing $1 via apt-get\n" >> script.log
    apt-get install -y -q $1 >> script.log 2>>script_error.log
}

kali_metapackages() {
    printf "  ⏳  install Kali metapackages\n" | tee -a script.log
    for package in kali-linux-forensic kali-linux-pwtools kali-linux-web kali-linux-wireless forensics-all
    do
        apt-get install -y -q $package >> script.log 2>>script_error.log
    done
}

install_kernel_headers() {
    printf "  ⏳  install kernel headers\n" | tee -a script.log
    apt -y -qq install make gcc "linux-headers-$(uname -r)" >> script.log 2>>script_error.log \
    || printf ' '${RED}'[!] Issue with apt install'${RESET} 1>&2
    if [[ $? != 0 ]]; then
    echo -e ' '${RED}'[!]'${RESET}" There was an ${RED}issue installing kernel headers${RESET}" 1>&2
        printf " ${YELLOW}[i]${RESET} Are you ${YELLOW}USING${RESET} the ${YELLOW}latest kernel${RESET}?"
        printf " ${YELLOW}[i]${RESET} ${YELLOW}Reboot${RESET} your machine"
    fi
}

install_python2_related(){
    printf "  ⏳  Installing python2 related libraries\n" | tee -a script.log
    # terminaltables - 
    # pwntools - 
    # xortool - 
    pip -q install terminaltables pwntools xortool
}

install_python3_related(){
    printf "  ⏳  Installing python3 related libraries\n" | tee -a script.log
    # pipenv - python virtual environments
    # pysmb - python smb library used in some exploits
    # pycryptodome - python crypto module
    # pysnmp - 
    # requests - 
    # future - 
    # paramiko - 
    # selenium - control chrome browser
    pip3 -q install pipenv pysmb pycryptodome pysnmp requests future paramiko selenium awscli
}

install_base_os_tools(){
    printf "  ⏳  Installing base os tools programs\n" | tee -a script.log
    # network-manager-openvpn-gnome - 
    # openresolv - 
    # strace - 
    # ltrace - 
    # gnome-screenshot - 
    # sshfs - mount file system over ssh
    # nfs-common - 
    # open-vm-tools-desktop - for vmware intergration
    # sshuttle - VPN/proxy over ssh 
    # autossh - specify password ofr ssh in cli
    # gimp - graphics design
    # transmission-gtk - bittorrent client
    # dbeaver - GUI universal db viewer
    # jq - cli json processor
    # aria2 - CLI download manager with torrent and http resume support
    # git-sizer - detailed size information on git repos
    for package in network-manager-openvpn-gnome openresolv strace ltrace gnome-screenshot sshfs nfs-common open-vm-tools-desktop sshuttle autossh gimp transmission-gtk dbeaver jq aria2 git-sizer
    do
        apt-get install -y -q $package >> script.log 2>>script_error.log
    done 
}

install_fonts(){
    printf "  ⏳  Downloading fonts Montserrat and Source Code Pro (installation is manual)\n" | tee -a script.log
    cd /root/Downloads
    wget --quiet https://fonts.google.com/download?family=Montserrat
    wget --quiet https://fonts.google.com/download?family=Source%20Code%20Pro
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi

}

install_re_tools(){
    printf "  ⏳  Installing re programs\n" | tee -a script.log
    # exiftool - 
    # okteta - 
    # hexcurse - 
    for package in exiftool okteta hexcurse
    do
        apt-get install -y -q $package >> script.log 2>>script_error.log
    done 
}

install_exploit_tools(){
    printf "  ⏳  Installing exploit programs\n" | tee -a script.log
    # gcc-multilib - multi arch libs
    # mingw-w64 - windows compile
    # crackmapexec - pass the hash
    for package in gcc-multilib mingw-w64 crackmapexec
    do
        apt-get install -y -q $package >> script.log 2>>script_error.log
    done 
}

install_steg_programs(){
    printf "  ⏳  Installing steg programs\n" | tee -a script.log
    # stegosuite - steganography
    # steghide - steganography
    # steghide-doc - documentation for steghide
    # audacity - sound editor / spectogram
    for package in stegosuite steghide steghide-doc audacity
    do
        apt-get install -y -q $package >> script.log 2>>script_error.log
    done
}

install_web_tools(){
    printf "  ⏳  Installing web programs\n" | tee -a script.log
    # gobuster - directory brute forcer
    for package in gobuster
    do
        apt-get install -y -q $package >> script.log 2>>script_error.log
    done 
}

folder_prep(){
    # create folders for later installs and workflow
    printf "  ⏳  making directories\n" | tee -a script.log
    mkdir -p /root/git
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log 
    fi
    mkdir -p /root/utils
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log 
    fi
    mkdir -p /root/dev
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log 
    fi
    mkdir -p /root/share
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log 
    fi 
    mkdir -p /root/ctf
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log 
    fi 
    mkdir -p /root/.ssh
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log 
    fi
    mkdir -p /root/history
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log 
    fi 
}

github_desktop() {
    printf "  ⏳  Github desktop - fork for linux https://github.com/shiftkey/desktop/releases\n" | tee -a script.log
    cd /root/Downloads
    wget --quiet https://github.com/shiftkey/desktop/releases/download/release-1.6.6-linux2/GitHubDesktop-linux-1.6.6-linux2.deb
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    apt_package_install ./GitHubDesktop-linux*
    rm -f ./GitHubDesktop-linux*
}

install_vscode() {
    printf "  ⏳  Installing VS Code\n" | tee -a script.log
    # Download the Microsoft GPG key, and convert it from OpenPGP ASCII 
    # armor format to GnuPG format
    curl --silent https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    # Move the file into your apt trusted keys directory (requires root)
    mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg

    # Add the VS Code Repository
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list

    # Update and install Visual Studio Code 
    apt_update
    apt-get install -y -q code >> script.log 2>>script_error.log
}

configure_vscode() {
    printf "  🔧  configure wireshark\n" | tee -a script.log
    code --user-data-dir /root/.vscode --install-extension christian-kohler.path-intellisense >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension coenraads.bracket-pair-colorizer >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension eamodio.gitlens >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension ibm.output-colorizer >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension ms-azuretools.vscode-docker >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension ms-python.python >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension ms-vscode.cpptools >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension ms-vscode-remote.remote-ssh >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension ms-vscode-remote.remote-ssh-edit >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension ms-vscode-remote.remote-ssh-explorer >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension romanpeshkov.vscode-text-tables >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension shakram02.bash-beautify >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension shan.code-settings-sync >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension visualstudioexptteam.vscodeintellicode >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension vscode-icons-team.vscode-icons >> script.log 2>>script_error.log
    code --user-data-dir /root/.vscode --install-extension yzhang.markdown-all-in-one >> script.log 2>>script_error.log
}

install_sublime() {
    printf "  ⏳  Installing Sublime Text\n" | tee -a script.log
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi

    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    apt_update
    apt-get install -y -q sublime-text >> script.log 2>>script_error.log
}

install_mega() {
    printf "  ⏳  Installing MEGAsync\n" | tee -a script.log
    cd /root/Downloads
    wget --quiet https://mega.nz/linux/MEGAsync/Debian_9.0/amd64/megasync-Debian_9.0_amd64.deb
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    wget --quiet http://ftp.cl.debian.org/debian/pool/main/libr/libraw/libraw15_0.17.2-6+deb9u1_amd64.deb
    apt_package_install ./libraw15* >> script.log 2>>script_error.log
    apt install libcrypto++6 libmediainfo0v5 libzen0v5 >> script.log 2>>script_error.log
    apt_package_install ./megasync-Debian_9.0_amd64* >> script.log 2>>script_error.log
    rm -f ./megasync-Debian_9.0_amd64*  ./libraw15*
}


install_rtfm(){
    printf "  ⏳  Installing RTFM\n" | tee -a script.log
    git clone --quiet https://github.com/leostat/rtfm.git /opt/rtfm/
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    chmod +x /opt/rtfm/rtfm.py
    /opt/rtfm/rtfm.py -u >> script.log 2>&1
    ln -s /opt/rtfm/rtfm.py /usr/local/bin/rtfm.py
}

install_docker(){
    printf "  ⏳  Installing docker\n" | tee -a script.log
    curl -fsSL --silent https://download.docker.com/linux/debian/gpg | sudo apt-key add - >> script.log 2>>script_error.log
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    echo 'deb https://download.docker.com/linux/debian stretch stable' > /etc/apt/sources.list.d/docker.list
    apt_update
    echo "\n [+] installing docker-ce via apt-get\n" >> script.log
    apt-get install -y -q docker-ce >> script.log 2>>script_error.log
    systemctl enable docker >> script.log 2>>script_error.log
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    docker version >> script.log 2>>script_error.log
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
}

install_ghidra(){
    printf "  ⏳  Install Ghidra\n" | tee -a script.log
    cd /root/utils
    wget --quiet https://www.ghidra-sre.org/ghidra_9.0.4_PUBLIC_20190516.zip
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi  
    unzip -qq ghidra*
    ln -s /root/utils/ghidra_9.0.4/ghidraRun /usr/local/bin/ghidraRun
    rm ghidra*.zip
}

install_routersploit_framework(){
    printf "  ⏳  Install routersploit framework\n" | tee -a script.log
    cd /root/utils
    git clone --quiet https://www.github.com/threat9/routersploit
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi  
    cd routersploit
    python3 -m pip install -q -r requirements.txt
    ln -s /root/utils/routersploit/rsf.py /usr/local/bin/rsf.py
    cd ~
}

install_stegcracker(){
    printf "  ⏳  Install Stegcracker\n" | tee -a script.log
    curl --silent https://raw.githubusercontent.com/Paradoxis/StegCracker/master/stegcracker > /usr/local/bin/stegcracker
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi    
    chmod +x /usr/local/bin/stegcracker
}

install_wine(){
    printf "  ⏳  Install wine & wine32\n" | tee -a script.log
    dpkg --add-architecture i386
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi  
    apt_update
    apt_package_install wine32 
    apt_package_install wine
}

install_dirsearch(){
    printf "  ⏳  Install dirseach\n" | tee -a script.log
    cd /root/utils
    git clone --quiet https://github.com/maurosoria/dirsearch.git
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    ln -s /root/utils/dirsearch/dirsearch.py /usr/local/bin/dirsearch.py
    cd /root
}

install_clicknroot(){
    printf "  ⏳  Install ClickNRoot\n" | tee -a script.log
    cd /root/utils
    git clone --quiet https://github.com/evait-security/ClickNRoot.git
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    cd /root
}

install_reptile(){
    printf "  ⏳  Install Reptile\n" | tee -a script.log
    cd /root/utils
    git clone --quiet https://github.com/f0rb1dd3n/Reptile.git
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    cd /root
}

install_chrome(){
    printf "  ⏳  Install Chrome\n" | tee -a script.log
    wget --quiet https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi  
    dpkg -i ./google-chrome-stable_current_amd64.deb >> script.log
    apt --fix-broken install -y
    rm -f ./google-chrome-stable_current_amd64.deb
    # enable chrome start as root
    cp /usr/bin/google-chrome-stable /usr/bin/google-chrome-stable.old && sed -i 's/^\(exec.*\)$/\1 --user-data-dir/' /usr/bin/google-chrome-stable
    sed -i -e 's@Exec=/usr/bin/google-chrome-stable %U@Exec=/usr/bin/google-chrome-stable %U --no-sandbox@g' /usr/share/applications/google-chrome.desktop 
    # chrome alias
    echo "alias chrome='google-chrome-stable --no-sandbox file:///root/dev/start_page/index.html'" >> /root/.bashrc
}

install_chromium(){
    printf "  ⏳  Install Chromium\n" | tee -a script.log
    apt_package_install chromium
    echo "# simply override settings above" >> /etc/chromium/default
    echo 'CHROMIUM_FLAGS="--password-store=detect --user-data-dir"' >> /etc/chromium/default
}

install_nmap_vulscan(){
    printf "  ⏳  Install NMAP vulscan\n" | tee -a script.log
    cd /usr/share/nmap/scripts/
    git clone --quiet https://github.com/scipag/vulscan.git
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi  
}

install_lazydocker(){
    printf "  ⏳  Install lazydocker\n" | tee -a script.log
    cd /root/utils
    curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi  
}

bash_aliases() {
    printf "  ⏳  adding bash aliases\n" | tee -a script.log
    # git aliases
    #echo "alias gs='git status'" >> /root/.bashrc
    #echo "alias ga='git add -A'" >> /root/.bashrc
    # increase history size
    sed -i "s/HISTSIZE=1000/HISTSIZE=1000000/g" /root/.bashrc
}

john_bash_completion() {
    printf "  ⏳  enabling john bash completion\n" | tee -a script.log
    echo ". /usr/share/bash-completion/completions/john.bash_completion" >> /root/.bashrc
}

unzip_rockyou(){
    printf "  ⏳  Install gunzip rockyou\n" | tee -a script.log
    cd /usr/share/wordlists/
    gunzip -q /usr/share/wordlists/rockyou.txt.gz
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    cd /root
}

install_gnome_theme(){
    printf "  ⏳  Install Gnome Theme - Vimix https://github.com/vinceliuice/vimix-gtk-themes\n" | tee -a script.log
    cd /root/Downloads
    git clone --quiet https://github.com/vinceliuice/vimix-gtk-themes
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    for package in gtk2-engines-murrine gtk2-engines-pixbuf
    do
        apt-get install -y -q $package >> script.log 2>>script_error.log
    done
    cd vimix-gtk-themes/
    ./Install -n vimix -c dark -t beryl
    rm -rf /root/Downloads/vimix-gtk-themes/
}

configure_vim(){
    printf "  🔧  configure vim\n" | tee -a script.log
    cd /root
    cat > .vimrc <<-ENDOFVIM
    set tabstop=8
    set expandtab
    set shiftwidth=4
    set softtabstop=4
    set background=dark
    " turn on code syntax
    syntax on
    set mouse=a
    " show line numbers
    set number
	ENDOFVIM
}

configure_gedit(){
    printf "  🔧  configure gedit\n" | tee -a script.log
    # show line numbers
    gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
    # set theme to match the rest of dark themes
    gsettings set org.gnome.gedit.preferences.editor scheme oblivion
}

configure_wireshark(){
    printf "  🔧  configure wireshark\n" | tee -a script.log
    cd /root
    mkdir -p /root/.config/wireshark
    cat > /root/.config/wireshark/preferences <<-ENDOFWIRESHARK
    # Default capture device
    # A string
    capture.device: eth0
    # Scroll packet list during capture?
    # TRUE or FALSE (case-insensitive)
    capture.auto_scroll: FALSE
    # Resolve addresses to names?
    # TRUE or FALSE (case-insensitive), or a list of address types to resolve.
    name_resolve: FALSE
    # Resolve Ethernet MAC address to manufacturer names
    # TRUE or FALSE (case-insensitive)
    nameres.mac_name: FALSE
    # Resolve TCP/UDP ports into service names
    # TRUE or FALSE (case-insensitive)
    nameres.transport_name: FALSE
    # Capture in Pcap-NG format?
    # TRUE or FALSE (case-insensitive)
    capture.pcap_ng: FALSE
    # Font name for packet list, protocol tree, and hex dump panes.
    # A string
    gui.qt.font_name: Monospace,10,-1,5,50,0,0,0,0,0
    # Resolve addresses to names?
    # TRUE or FALSE (case-insensitive), or a list of address types to resolve.
    name_resolve: FALSE
    # Display all hidden protocol items in the packet list.
    # TRUE or FALSE (case-insensitive)
    protocols.display_hidden_proto_items: TRUE
	ENDOFWIRESHARK
}

configure_git(){
    printf "  🔧  Configure git username, email, name\n" | tee -a script.log
    git config --global user.name "NOP Researcher"
    git config --global user.email nopresearcher@gmail.com
    git config --global credential.username "nopresearcher"
}

configure_metasploit(){
    printf "  🔧  configure metasploit\n" | tee -a script.log
    service postgresql start >> script.log
    msfdb init >> script.log
}

update_wpscan(){
    printf "  ⏳  update wpscan\n" | tee -a script.log
    wpscan --update >> script.log
}

pull_utilities(){
    printf "  ⏳  Pull nopresearcher utilities\n" | tee -a script.log
    cd /root/utils
    git clone --quiet https://github.com/nopresearcher/utilities.git
    if [[ $? != 0 ]]; then
	    printf "${CLEAR_LINE}❌${RED} $1 failed ${NO_COLOR}\n"
        echo "$1 failed " >> script.log
    fi
    ln -s /root/utils/utilities/serveme /usr/local/bin/serveme
    ln -s /root/utils/utilities/ips /usr/local/bin/ips
    ln -s /root/utils/utilities/revshell-php /usr/local/bin/revshell-php
    ln -s /root/utils/utilities/public /usr/local/bin/public

}

apt_cleanup(){
    printf "  ♻  cleaning up apt\n" | tee -a script.log
    DEBIAN_FRONTEND=noninteractive apt-get -f install >> script.log 2>>script_error.log
    apt-get -y autoremove >> script.log 2>>script_error.log
    apt-get -y autoclean >> script.log 2>>script_error.log
    apt-get -y clean >> script.log 2>>script_error.log
}

additional_clean(){
    printf "  ♻  additional cleaning\n" | tee -a script.log
    cd /root # go home
    updatedb # update slocated database
    history -cw 2>/dev/null # clean history
}

manual_stuff_to_do(){
    printf "  ⏳  Adding Manual work\n" | tee -a script.log
    echo "=============Firefox addons===========" >> script_todo.log
    echo "FoxyProxy Standard" >> script_todo.log
    echo "" >> script_todo.log
    echo "=============Install fonts============" >> script_todo.log
    echo "Google Fonts on 'Downloads' folder" >> script_todo.log
    echo "" >> script_todo.log
    echo "======Install Gnome Extensions========" >> script_todo.log
    echo "'Dash to Panel' from https://extensions.gnome.org/"  >> script_todo.log
    echo "and cutomize your Windows Manager" >> script_todo.log
    echo "" >> script_todo.log
}

compute_finish_time(){
    finish_time=$(date +%s)
    echo -e "  ⌛ Time (roughly) taken: ${YELLOW}$(( $(( finish_time - start_time )) / 60 )) minutes${RESET}"
    echo "\n\n Install completed - $finish_time \n" >> script.log
}

script_todo_print() {
    printf "  ⏳  Printing todo\n" | tee -a script.log
    cat script_todo.log
}

main () {
    compute_start_time
    configure_environment
    apt_update
    #apt_upgrade
    kali_metapackages
    install_kernel_headers
    install_python2_related
    install_python3_related
    install_base_os_tools
    install_fonts
    #install_usb_gps
    #install_rf_tools
    #install_re_tools
    #install_exploit_tools
    #install_steg_programs
    #install_web_tools
    #folder_prep
    #github_desktop
    #install_vscode
    #configure_vscode
    #install_rtfm
    install_sublime
    install_mega
    install_docker
    #pull_cyberchef
    #install_ghidra
    #install_peda
    #install_gef
    #install_binary_ninja
    #install_routersploit_framework
    #install_stegcracker
    install_wine
    #install_dirsearch
    #install_clicknroot
    #install_reptile
    install_chrome
    install_chromium
    install_nmap_vulscan
    #install_lazydocker
    bash_aliases
    john_bash_completion
    unzip_rockyou
    install_gnome_theme
    #install_sourcepro_font
    #configure_gnome_settings
    #enable_auto_login
    #configure_gdb
    configure_vim
    configure_gedit
    configure_wireshark
    #configure_git
    configure_metasploit
    update_wpscan
    #pull_utilities
    apt_cleanup
    additional_clean
    manual_stuff_to_do
    compute_finish_time
    script_todo_print
}

main
