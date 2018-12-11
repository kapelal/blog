# Blog

[kapelal.io](kapelal.io)

## CV

### Générer PDF

- Enlever le bloc hugo
- `cd cv && pandoc --standalone -c cv.css --from markdown --to html -o index.html cv.md`
- `cp cv.css /tmp && cat index.html | wkhtmltopdf - cv.pdf`
