html:
	cp cv/cv.css /tmp/cv.css
	pandoc --standalone -c cv.css --from markdown --to html -o cv/index.html cv/cv.md

pdf:
	cp cv/cv.css /tmp/cv.css
	cat cv/index.html | wkhtmltopdf - static/cv.pdf

local:
	hugo server -D
