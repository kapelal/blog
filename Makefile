html:
	cp cv/cv.css /tmp/cv.css
	pandoc --standalone -c cv.css --from markdown --to html -o cv/index.html cv/cv.md

pdf:
	@docker run -it --rm -v `pwd`/cv:/cv -v `pwd`/static:/static --workdir /cv --entrypoint bash michaelperrin/wkhtmltopdf -c "cp /cv/cv.css /tmp/cv.css && cat /cv/index.html | wkhtmltopdf - /static/cv.pdf"

local:
	docker run -it -v /home/rdesousa/git/kapelal/blog:/site -w /site -p 1313:1313 kapelal/gohugo-docker server --bind 0.0.0.0 -D
