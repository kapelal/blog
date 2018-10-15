# Blog

[kapelal.io](kapelal.io)

## CV

### PDF

- Enlever le bloc hugo
- `cd cv && pandoc --standalone -c style.css --from markdown --to html -o index.html ./content/cv.md`
- `cat index.html | wkhtmltopdf - cv.pdf`
