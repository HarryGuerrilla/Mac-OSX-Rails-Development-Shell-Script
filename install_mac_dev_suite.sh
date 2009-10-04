#!/bin/bash
#
# Setup Mac OS 10.6 Operating System for Ruby On Rails and Web Development.
# Install Macports, Emacs, and Useful gems.
# 
# Tony Pelaez
# 

# shopt -s -o nounset


# Global Declarations
# ----------------------------------------------------------------------------

declare -rx SCRIPT=${0##*/}                  # Name of Script

declare -x ORIG_PWD=$PWD                     # Starting Directory
declare -x ORIG_USER=$USER
declare SUDO_PASS	                     # Will hold sudo password
# declare BACKUP_DATE	                     # Will hold folder name of latest Backup

declare -rx port="/opt/local/bin/port"	     # Macports
declare -rx git="/opt/local/bin/git"         # Git
declare -rx svn="/opt/local/bin/svn"	     # Subversion
declare -rx php="/opt/local/bin/php"         # Php
declare -rx convert="/opt/local/bin/convert" # ImageMagick

declare -r OPTSTRING="-p:, h"
declare SKIP_EMACS=0
declare SKIP_MYSQL=0
declare SKIP_APACHE=0
declare SKIP_TREE=`which tree`
declare SKIP_WGET=`which wget`
declare SKIP_ASPELL=`which aspell`
declare MYSQL_BACKUP
declare COPY_SCRIPTS
declare GIT_CLONES
declare BASH_PROFILE
declare RESULT


# Configure getopt
# ----------------------------------------------------------------------------


RESULT='getopt --name "$SCRIPT" --options "$OPTSTRING" \
 	--longoptions "skip-emacs,skip-mysql,mysql-backup:,help,copy-scripts:,git-clones:,skip-apache,bash-profile:" -- "$@"'

if [ $? -gt 0 ]; then
    exit 192
fi

eval set -- "$RESULT"

while [ $# -gt 0 ]; do
    case "$1" in
	-p ) shift
	    if [ $# -eq 0 ]; then
		printf "$SCRIPT:$LINENO: %s\n" "password for -p is missing" >&2
		exit 192
	    fi
	    SUDO_PASS="$1"
	    ;;
	--skip-emacs )
	    SKIP_EMACS=1
	    ;;
	--skip-mysql )
	    SKIP_MYSQL=1
	    ;;
	--skip-apache )
	    SKIP_APACHE=1
	    ;;
	--mysql-backup ) shift
	    if [ $# -eq 0 ]; then
		printf "$SCRIPT:$LINENO: %s\n" "location for --mysql-backup is missing" >&2
	        exit 192
	    fi
	    MYSQL_BACKUP="$1"
	    ;;
	--copy-scripts ) shift
	    if [ $# -eq 0 ]; then
		printf "$SCRIPT:$LINENO: %s\n" "location for --copy-scripts is missing" >&2
		exit 192
	    fi
	    COPY_SCRIPTS="$1"
	    ;;
	--git-clones ) shift
	    if [ $# -eq 0 ]; then
		printf "$SCRIPT:$LINENO: %s\n" "location for --git-clones is missing" >&2
		exit 192
            fi
	    GIT_CLONES="$1"
	    ;;
        --bash-profile ) shift
            if [ $# -eq 0 ]; then
                printf "$SCRIPT:$LINENO: %s\n" "location for --bash-profile is missing" >&2
            fi
            BASH_PROFILE="$1"
            ;;
	-h | --help ) shift
	    printf "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n" \
			    "usage: $SCRIPT [" \
				"                 [-p sudo password]" \
				"                 [--bash-profile location]" \
				"                 [--copy-scripts location]" \
				"                 [--git-clones script] " \
				"                 [--mysql-backup file]" \
				"                 [--skip-emacs]" \
				"                 [--skip-mysql]" \
				"                 [--skip-apache] " \
				"            ]" >&2
	    exit 192
	    ;;
    esac
    shift
done


# Main Script
# ----------------------------------------------------------------------------

echo Starting $SCRIPT....

# Title
cat <<END_TITLE_SCREEN

=====================================================,
        _  _          _        _  _ ___      _        
       | ||_' \/  |\`.|_ '  '  |_'|_  |  | | |_|       
       |_|,_| /\  |,'|_  \/   ,_||_  |  |_| |         
                                                      
====================================================='
v.0.0.1 updated on 09/28/09                           
by Tony Pelaez http://tonypelaez.com                  




END_TITLE_SCREEN

# Get User Information
if [ ! $SUDO_PASS ] ; then
    echo "Password:"
    read SUDO_PASS
fi

# echo "Enter Folder Name Of Backup:"
# read BACKUP_DATE

# Create Default Directories
mkdir -v $HOME/src

if [ $COPY_SCRIPTS ] ; then
    mkdir -v $HOME/scripts
    printf "\n%s\n" ":: Created Script Directory ::"
fi



# Setup Shell Profile --------------------------------------------------------
touch $HOME/.bash_profile
cp $HOME/.bash_profile $HOME/.bash_profile.bk # Make backup of profile just in case

if [ $BASH_PROFILE ]; then
	printf "%s\n%s\n\n" \
	"# Imported Profile" \
	"# ================" \
	>> $HOME/.bash_profile
	cat $BASH_PROFILE >> $HOME/.bash_profile
fi

printf "%s\n%s\n\n%s\n\n%s\n%s\n%s\n%s\n%s\n%s\n\n%s\n%s\n\n" \
\
"# Profile Settings By OS X Dev Setup" \
"# ==================================" \
\
"export DISPLAY=:0.0" \
\
"# Terminal Prompt & Colors" \
"export PS1='\n\$(git branch &>/dev/null; if [ \$? -eq 0 ]; then \\" \
"echo \"\[\033[0;35m\]br:\[\e[32;40m\]\$(git branch | grep ^*|sed s/\*\ //) \[\033[0;33m\]\W\"; else " \
"echo \"\[\033[0;36m\]\u \[\033[0;33m\]\w\";fi)\[\033[00m\] \\$ '" \
"export CLICOLOR=1" \
"export LSCOLORS=ExFxCxDxBxegedabagacex" \
\
"# Aliases" \
"alias ls='ls -p1h'" \
>> $HOME/.bash_profile


# Copy Backup Scripts
if [ $COPY_SCRIPTS ] ; then
    cp -r $COPY_SCRIPTS $HOME/scripts
    printf "\n%s\n" ":: Copied scripts to $HOME/scripts ::"
    printf "%s\n%s\n\n" \
        "# PATH for Scripts" \
        "export PATH=\$PATH:~/scripts" \
    >> $HOME/.bash_profile
fi

# Load Updated Shell Profile
source $HOME/.bash_profile



# Install Macports --------------------------------------------------------------
# http://guide.macports.org/#installing.macports.subversion
if [[ ! -x $port ]]; then # Test to see if Macports is installed before downloading
	mkdir -p $HOME/src/macports
	svn checkout http://svn.macports.org/repository/macports/trunk/base $HOME/src/macports
	cd $HOME/src/macports
	./configure --enable-readline
	make
	echo $SUDO_PASS | sudo -S make install
	make distclean
	cd $ORIG_PWD

	# Configure PATH for Macports
	printf "%s\n%s\n\n" \
	"export PATH=/opt/local/bin:/opt/local/sbin:\$PATH" \
	"export MANPATH=/opt/local/share/man:\$MANPATH" \
	>> $HOME/.bash_profile
	source $HOME/.bash_profile
        printf "\n%s\n" ":: Installed Macports ::"
else
    printf "%s\n" "Skipping Installation of Macports"
fi

echo $SUDO_PASS | sudo -S port -v selfupdate

# http://www.metaskills.net/2009/9/5/the-ultimate-os-x-snow-leopard-stack-for-rails-development-x86_64-macports-ruby-1-8-1-9-sql-server-more
# Install Macports Subversion
if [[ ! -x $svn ]]; then
	echo $SUDO_PASS | sudo -S port install subversion
        printf "\n%s\n" ":: Installed Macports Subversion ::"
else
    printf "%s\n" "Skipping Installation of Subversion"
fi

# Install Macports Git
if [[ ! -x $git ]]; then
    echo $SUDO_PASS | sudo -S port install git-core +svn +bash_completion
    printf "%s\n%s\n%s\n%s\n%s\n%s\n\n" \
           "# Setup for git" \
           "export PATH=\$PATH:/opt/local/bin/git" \
           "if [ -f /opt/local/etc/bash_completion ]; then" \
           "   . /opt/local/etc/bash_completion" \
           "fi" \
           "export GIT_EDITOR=\"emacs\""
    >> $HOME/.bash_profile
    source $HOME/.bash_profile
    echo "database.yml\n*.log\ntmp/*\n.DS_Store" >> .gitignore
    git config --global core.excludesfile .gitignore
    git config --global user.name "Tony Pelaez"
    git config --global user.email tnyplz@gmail.com
    git config --global color.branch auto
    git config --global color.diff auto
    git config --global color.interactive auto
    git config --global color.status auto
    git config --global core.editor "emacs"
    git config --global merge.tool opendiff
    set mainfont {Monaco 12}
    set textfont {Monaco 12}
    set uifont {Monaco 12}
    rm -rf .gitignore # TODO move to cleanup section
    printf "\n%s\n" ":: Installed Macports Git ::"
else
    printf "%s\n" "Skipping Installation of git"
fi

if [ "$SKIP_APACHE" -eq "1" ]; then
    printf "%s\n" "Skipping installation of Apache2"
else
    echo $SUDO_PASS | sudo -S  port install apache2
    echo $SUDO_PASS | sudo -S launchctl load -w /Library/LaunchDaemons/org.macports.apache2.plist
    echo export "PATH=/opt/local/apache2/bin:\$PATH" >> $HOME/.bash_profile
    source $HOME/.bash_profile
    echo $SUDO_PASS | sudo -S apachectl start
    printf "\n%s\n" ":: Installed Macports Apache 2 ::"
fi

if [ $SKIP_TREE ]; then
	printf "%s\n" "Skipping Installation of tree"
else
	echo $SUDO_PASS | sudo -S  port install tree
    printf "\n%s\n" ":: Installed Macports tree ::"
fi

if [ $SKIP_WGET ]; then
	printf "%s\n" "Skipping Installation of wget"
else
	echo $SUDO_PASS | sudo -S  port install wget
    printf "\n%s\n" ":: Installed Macports wget ::"
fi

if [ $SKIPP_ASPELL ]; then
	printf"%s\n" "Skipping Installation of aspell"
else
	echo $SUDO_PASS | sudo -S  port install aspell
	echo $SUDO_PASS | sudo -S  port install aspell-dict-en
    printf "\n%s\n" ":: Installed Macports aspell ::"
fi

if [[ ! -x $php ]]; then
    echo $SUDO_PASS | sudo -S  port install php5 +apache2 +php5-mysql +pear
    cd /opt/local/apache2/modules
    echo $SUDO_PASS | sudo -S /opt/local/apache2/bin/apxs -a -e -n "php5" libphp5.so
    cd $ORIG_PWD
else
    printf "%s\n" "Skipping Installation of php"
fi

if [[ ! -x $convert ]]; then
    echo $SUDO_PASS | sudo -S  port install tiff -macosx imagemagick +q8 +gs +wmf
else
    printf "%s\n" "Skipping Installation of ImageMagick"
fi

# Install Emacs
#http://cvs.savannah.gnu.org/viewvc/emacs/nextstep/INSTALL?root=emacs&view=markup
if [ "$SKIP_EMACS" -eq "1" ] ; then
    printf "%s\n" "Skipping Installation of Emacs"
else
    cd $HOME/src
    cvs -z3 -d:pserver:anonymous@cvs.savannah.gnu.org:/sources/emacs co emacs
    cd emacs
    # emacs build was failinga s 64bit configure as 32bit might be fixed in the 
    # future
    declare -x CC="gcc -arch i386"
    ./configure --with-ns
    make bootstrap
    make install
    mv nextstep/Emacs.app /Applications/Emacs.app
    cd $HOME/src
    git clone git://github.com/HarryGuerilla/emacs-starter-kit.git dot.emacs.d
    ln -s $HOME/src/dot.emacs.d $HOME/.emacs.d
    cd dot.emacs.d
    git submodule init
    git submodule update
    echo export PATH=/Applications/Emacs.app/Contents/MacOS:\$PATH >> $HOME/.bash_profile
    echo export GIT_EDITOR="emacs"
    echo export EDITOR="emacs"
    cd $ORIG_PWD
    unset CC
fi

# Install Ruby and Ruby on Rails
gem sources -a http://gems.github.com
echo $SUDO_PASS | sudo -S  port install ruby
echo $SUDO_PASS | sudo -S  port install rb-rubygems
echo $SUDO_PASS | sudo -S  gem install rvm
rvm-install
source $HOME/.bash_profile
rvm install 1.9.1
rvm install jruby
rvm install ree

# Install Passenger for Easy Rails Development
echo $SUDO_PASS | sudo -S gem install passenger
echo $SUDO_PASS | sudo -S su
export APXS2=/opt/apache2/bin/apxs
passenger-install-apache2-module
touch /opt/local/apache2/conf/extra/passenger.conf
echo "LoadModule passenger_module /opt/local/lib/ruby/gems/1.8/gems/passenger-2.2.5/ext/apache2/mod_passenger.so" >> /opt/local/apache2/conf/extra/passenger.conf
echo "PassengerRoot /opt/local/lib/ruby/gems/1.8/gems/passenger-2.2.5" >> /opt/local/apache2/conf/extra/passenger.conf
echo "PassengerRuby /opt/local/bin/ruby" >> /opt/local/apache2/conf/extra/passenger.conf
echo "Include /opt/local/apache2/conf/extra/passenger.conf" >> /opt/local/apache2/conf/httpd.conf
apachectl restart
su - $ORIG_USER

echo $SUDO_PASS | sudo -S gem install --include-dependencies authlogic autotest-rails aws-s3 calendar_date_select \
capistrano fastri ferret haml-edge hoe hpricot liquid mislav-will_paginate \
mocha mongrel pdf-writer radiant rails rcov redgreen right-aws rspec \
rspec-rails ruby-debug scrapi spree thoughtbot-factory_girl thoughtbot-paperclip \
thoughtbot-shoulda tlsmail typo webrat tidy ZenTest HarryGuerilla-damn-layout-generators \
rmagick termios cgi_multipart_eof_fix daemons dnssd fastthread fcgi highline \
libxml-ruby needle ruby-openid ruby yadis rubynode xmpp4r sqlite3-ruby

printf "%s\n%s\n\n" "# RSpec" "export RSPEC=true" \
>> $HOME/.bash_profile


# Install MySQL
# http://blog.twg.ca/tag/snow-leopard/
# http://2tbsp.com/content/install_and_configure_mysql_5_macports
if [ "$SKIP_MYSQL" -eq "1" ] ; then
    printf "%s\n" "Skipping Installation of MySQL"
else
    echo $SUDO_PASS | sudo -S port install mysql5-server-devel
    echo $SUDO_PASS | sudo -S launchctl load -w /Library/LaunchDaemons/org.macports.mysql5.plist
	printf "%s\n%s\n\n%s\n%s\n%s\n" \
	"# MySQL Config" \
	"# ============" \
	"alias mysqladmin='mysqladmin5'" \
	"alias mysqlstart='sudo launchctl load -w /Library/LaunchDaemons/org.macports.mysql5.plist'" \
	"alias mysqlstop='sudo launchctl unload -w /Library/LaunchDaemons/org.macports.mysql5.plist'" \
	>> $HOME/.bash_profile
    source $HOME/.bash_profile
    cd /opt/local/bin
    echo $SUDO_PASS | sudo -S ln -s ../lib/mysql5/bin/mysql mysql
    cd $ORIG_PWD
    echo $SUDO_PASS | sudo -S -u mysql mysql_install_db5
    env ARCHFLAGS="-arch x86_64" echo $SUDO_PASS | sudo -S gem install mysql -- --with-mysql-config=/opt/local/bin/mysql_config5
    #echo $SUDO_PASS | sudo -S mysql_secure_installation5
    #cd $ORIG_PWD
fi

if [ $MYSQL_BACKUP ] ; then
    printf "%s\n" "Restoring MySQL Backup"
    gunzip $MYSQL_BACKUP | mysql -u root -p
fi


# Check out development websites
if [ $GIT_CLONES ] ; then
    bash $GIT_CLONES
fi


# Cleanup

cat <<DONE

=====================================================,
-----------------------------------------------------

Installation Complete!!!!!

You might still want to run the following to secure 
the mysql installation:

    sudo mysql_secure_installation5






DONE

exit 0
