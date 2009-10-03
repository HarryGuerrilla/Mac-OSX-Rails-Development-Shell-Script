Mac OS X Development Setup
===========================

This shell script comes with ABSOLUTELY NO WARRANTY.

v.0.0.1 updated on 09/28/09                           
by Tony Pelaez http://tonypelaez.com

Synopsis
--------

This script hopes to make it easier to get your Mac setup with the proper tools to do 
Ruby on Rails and other web development work.

The script installs [Macports](http://www.macports.org/ "Macports") from source with 
which the necessary unix tools are installed to do Rails development. Macports offers the 
advantage of being able to install custom builds of unix tools without overriding the operating
system's defaults.

The script also installs [Emacs](http://www.gnu.org/software/emacs/ "Emacs") and sets it up to be used as a Rails IDE.

It has been tested on Mac OS X 10.6.1 and is currently under development.

Usage
-----

Show help:
	bash install_mac_dev_suite.sh -h
	
With all options:
	bash install_mac_dev_suite.sh -p password \
	--bash-profile location/of/file/with/additional/bash/commands \
	--copy-scripts locations/of/scripts/to/copy/to/~/scripts \
	--git-clones locations/of/script/to/load/git/repos \
	--mysql-backup location/of/gz/mysql/backup/which/will/be/restored

Skip the unwanted parts:
	bash install_mac_dev_suite.sh -p password \
	--skip-emacs \
	--skip-mysql \
	--skip-apache

What is Installed
-----------------

###Macports:###
	The following ports are currently installed:
	  apache2 @2.2.13_2+darwin+preforkmpm (active)
	  apr @1.3.8_0 (active)
	  apr-util @1.3.9_0 (active)
	  aspell @0.60.6_2+macosx (active)
	  aspell-dict-en @6.0_0 (active)
	  autoconf @2.64_2 (active)
	  autoconf213 @2.13_1 (active)
	  automake @1.11_0 (active)
	  bash-completion @1.0_2 (active)
	  bzip2 @1.0.5_3+darwin (active)
	  cairo @1.8.8_0+macosx (active)
	  curl @7.19.6_0 (active)
	  cyrus-sasl2 @2.1.23_0+kerberos (active)
	  db46 @4.6.21_5 (active)
	  expat @2.0.1_0 (active)
	  fontconfig @2.7.3_0+macosx (active)
	  freetype @2.3.9_1+macosx (active)
	  gawk @3.1.7_0 (active)
	  gettext @0.17_4 (active)
	  ghostscript @8.70_0 (active)
	  git-core @1.6.4.4_0+bash_completion+doc+svn (active)
	  gperf @3.0.4_0 (active)
	  gsed @4.2.1_0 (active)
	  help2man @1.36.4_1 (active)
	  ImageMagick @6.5.6-1_0+gs+q8+wmf (active)
	  jpeg @6b_3 (active)
	  libiconv @1.13_0 (active)
	  libidn @1.15_0 (active)
	  libpixman @0.16.2_0 (active)
	  libpng @1.2.38_0 (active)
	  libtool @2.2.6a_0 (active)
	  libwmf @0.2.8.4_2 (active)
	  libxml2 @2.7.5_0 (active)
	  lzmautils @4.32.7_1 (active)
	  m4 @1.4.13_0 (active)
	  mhash @0.9.9.9_0 (active)
	  mysql5-devel @5.1.39_0 (active)
	  mysql5-server-devel @5.1.39_0 (active)
	  ncurses @5.7_0+darwin_10 (active)
	  ncursesw @5.7_0+darwin_10 (active)
	  neon @0.28.6_0 (active)
	  openssl @0.9.8k_0+darwin (active)
	  p5-compress-raw-bzip2 @2.021_0 (active)
	  p5-compress-raw-zlib @2.021_0 (active)
	  p5-crypt-ssleay @0.57_0 (active)
	  p5-error @0.17015_0 (active)
	  p5-html-parser @3.62_0 (active)
	  p5-html-tagset @3.20_0 (active)
	  p5-io-compress @2.021_3 (active)
	  p5-libwww-perl @5.832_0 (active)
	  p5-locale-gettext @1.05_0 (active)
	  p5-svn-simple @0.27_0 (active)
	  p5-term-readkey @2.30_0 (active)
	  p5-uri @1.40_0 (active)
	  p7zip @9.04_0 (active)
	  pcre @7.9_0 (active)
	  perl5 @5.8.9_0 (active)
	  perl5.8 @5.8.9_3 (active)
	  php5 @5.3.0_3+apache2+darwin_10+macosx+pear (active)
	  pkgconfig @0.23_1 (active)
	  popt @1.15_0 (active)
	  rb-rubygems @1.3.4_0 (active)
	  readline @6.0.000_2+darwin (active)
	  rsync @3.0.6_0 (active)
	  ruby @1.8.7-p174_0+darwin+thread_hooks (active)
	  serf @0.3.0_0 (active)
	  sqlite3 @3.6.18_0 (active)
	  subversion @1.6.5_0 (active)
	  subversion-perlbindings @1.6.5_1 (active)
	  texinfo @4.13_0 (active)
	  tiff @3.9.1_0+macosx (active)
	  tree @1.5.2.2_0 (active)
	  wget @1.12_0 (active)
	  xorg-bigreqsproto @1.1.0_0 (active)
	  xorg-inputproto @2.0_0 (active)
	  xorg-kbproto @1.0.3_0 (active)
	  xorg-libice @1.0.6_0 (active)
	  xorg-libsm @1.1.1_0 (active)
	  xorg-libX11 @1.3_0 (active)
	  xorg-libXau @1.0.5_0 (active)
	  xorg-libXdmcp @1.0.3_0 (active)
	  xorg-libXext @1.1_0 (active)
	  xorg-libXt @1.0.6_0 (active)
	  xorg-renderproto @0.11_0 (active)
	  xorg-util-macros @1.3.0_0 (active)
	  xorg-xcmiscproto @1.2.0_0 (active)
	  xorg-xextproto @7.1.1_0 (active)
	  xorg-xf86bigfontproto @1.2.0_0 (active)
	  xorg-xproto @7.0.16_0 (active)
	  xorg-xtrans @1.2.4_0 (active)
	  xrender @0.9.5_0 (active)
	  zlib @1.2.3_3 (active)

###Ruby:###
	ruby:

	   ruby-1.9.1-p243 : ruby 1.9.1p243 (2009-07-16 revision 24175) [i386-darwin10.0.0]

	jruby:

	   jruby-1.3.1 : jruby 1.3.1 (ruby 1.8.6p287) (2009-06-15 2fd6c3d) (Java HotSpot(TM) 64-Bit Server VM 1.6.0_15) [x86_64-java]

	ree:

	   ruby-enterprise-1.8.7-20090928 : ruby 1.8.7 (2009-06-12 patchlevel 174) [i686-darwin10.0.0], MBARI 0x6770, Ruby Enterprise Edition 20090928 

	system:

	=> ruby 1.8.7 (2009-06-12 patchlevel 174) [i686-darwin10]


###Gems:###
	*** LOCAL GEMS ***

	actionmailer (2.3.4, 2.2.2)
	actionpack (2.3.4, 2.2.2)
	activemerchant (1.4.1)
	activerecord (2.3.4, 2.2.2)
	activerecord-tableless (0.1.0)
	activeresource (2.3.4, 2.2.2)
	activesupport (2.3.4, 2.2.2)
	archive-tar-minitar (0.5.2)
	authlogic (2.1.2)
	autotest-rails (4.1.0)
	aws-s3 (0.6.2)
	builder (2.1.2)
	calendar_date_select (1.15)
	capistrano (2.5.9)
	cgi_multipart_eof_fix (2.5.0)
	chronic (0.2.3)
	color (1.4.0)
	columnize (0.3.1)
	daemons (1.0.10)
	dnssd (1.3)
	fastri (0.3.1.1)
	fastthread (1.0.7)
	fcgi (0.8.7)
	ferret (0.11.6)
	flexmock (0.8.6)
	gem_plugin (0.2.3)
	haml-edge (2.3.43)
	HarryGuerilla-damn-layout-generators (0.1.3)
	highline (1.5.1)
	hoe (2.3.3)
	hpricot (0.8.1)
	json (1.1.9)
	libxml-ruby (1.1.3)
	linecache (0.43)
	liquid (2.0.0)
	mime-types (1.16)
	mislav-will_paginate (2.3.11)
	mocha (0.9.8)
	mongrel (1.1.5)
	mongrel_cluster (1.0.5)
	mysql (2.8.1)
	needle (1.3.0)
	net-scp (1.0.2)
	net-sftp (2.0.2)
	net-ssh (2.0.15)
	net-ssh-gateway (1.0.1)
	nokogiri (1.3.3)
	passenger (2.2.5)
	pdf-writer (1.1.8)
	rack (1.0.0)
	radiant (0.8.1)
	rails (2.3.4, 2.2.2)
	rails-app-installer (0.2.0)
	rake (0.8.7)
	rcov (0.8.1.2.0)
	RedCloth (4.2.2)
	redgreen (1.2.2)
	rmagick (2.11.1)
	rspec (1.2.8, 1.1.11)
	rspec-rails (1.2.7.1, 1.1.11)
	ruby-debug (0.10.3)
	ruby-debug-base (0.10.3)
	ruby-openid (2.1.7)
	rubyforge (2.0.1)
	rvm (0.0.53)
	scrapi (1.2.0)
	searchlogic (2.3.5)
	spree (0.9.0)
	sqlite3-ruby (1.2.5)
	termios (0.9.4)
	thoughtbot-factory_girl (1.2.2)
	thoughtbot-paperclip (2.3.1)
	thoughtbot-shoulda (2.10.2)
	tidy (1.1.2)
	tlsmail (0.0.1)
	transaction-simple (1.4.0)
	typo (5.3)
	webrat (0.5.3)
	xml-simple (1.0.12)
	xmpp4r (0.5)
	ZenTest (4.1.4)

### Emacs ###
	GNU Emacs 23.1.50.1
	Copyright (C) 2009 Free Software Foundation, Inc.
	GNU Emacs comes with ABSOLUTELY NO WARRANTY.
	You may redistribute copies of Emacs
	under the terms of the GNU General Public License.
	For more information about these matters, see the file named COPYING.
