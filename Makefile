typo:  ready 
	@- git status
	@- git commit -am "saving"
	@- git push origin master

commit:  ready 
	@- git status
	@- git commit -a 
	@- git push origin master

update:; @- git pull origin master
status:; @- git status

ready: gitting 

gitting:
	@git config --global credential.helper cache
	@git config credential.helper 'cache --timeout=3600'

timm:
	@git config --global user.name "Tim Menzies"
	@git config --global user.email tim.menzies@gmail.com


FILES_OUT = $($(shell ../src/*[^0-1].ok)FILES_IN:=x)

files:
	cd ../src; \
	for ffor f in $(HOME)/opt/ok/docs/*; do if [ $
