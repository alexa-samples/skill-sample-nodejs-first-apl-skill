# --------------------------------------------------------------------------
# Make file for building this package. Needs Asciidoctor installed.
# https://asciidoctor.org/docs/user-manual/
# 
# asciidoctor-pdf
# https://asciidoctor.org/docs/asciidoctor-pdf/
# Server and open commands assume MacOS
# This relies on Asciidoctor installed to build it.
# See: https://asciidoctor.org/docs/user-manual/
# 
# For the PDFs, you need the pdf package. 
# See: https://asciidoctor.org/docs/asciidoctor-pdf/
# 
# For gifs to not give warnings in PDF mode, you need prawn-gmagick which relies on GraphicsMagick
#  brew install GraphicsMagick
# Then
#  sudo gem install prawn-gmagick
# 
## Usage Instructions
# To compile everything and open a specific page on your local (Apache) server, run something like:
#  make all page=module#
# 
# Where module# is the file name without the .adoc.
# 
# To just build, run:
#  make cleanbuild
# 
# Cleanbuild target will remove old artifacts and force a new build. 
# 
# To open a page on your local server (Assumes Apache), simply:
#  make open page=module#
# --------------------------------------------------------------------------

IP_ADDRESS = `ipconfig getifaddr en0`

#Puts artifacts into build directory. and the sites dir
build: 
	mkdir -p ~/Sites/optical-cupcake/modules/images
	cp ./modules/images/* ~/Sites/optical-cupcake/modules/images/
	find . -name '*.adoc' -exec asciidoctor -a icons=font --destination-dir ~/Sites/optical-cupcake/modules {} \;
	find . -name '*.adoc' -exec asciidoctor-pdf  -a icons=font --destination-dir ./build {} \;

clean: 
	rm -rf build/
	rm -rf ~/Sites/optical-cupcake/

cleanbuild: clean build

start-server:
	sudo apachectl start
	echo $(IP_ADDRESS)

stop-server:
	sudo apachectl stop

restart-server: stop-server start-server 
	
open:
	open http://$(IP_ADDRESS)/~muoioj/optical-cupcake/modules/$(page).html

zipall: 
	zip -r ./build/assets.zip modules/assets/*

all: cleanbuild zipall open
