all: dist/main.js dist/index.html dist/style.less dist/interop.js bootstrap less

bootstrap: dist/bootstrap-3.3.4/css/bootstrap-theme.css dist/bootstrap-3.3.4/css/bootstrap-theme.css.map dist/bootstrap-3.3.4/css/bootstrap-theme.min.css dist/bootstrap-3.3.4/css/bootstrap.css dist/bootstrap-3.3.4/css/bootstrap.css.map dist/bootstrap-3.3.4/css/bootstrap.min.css dist/bootstrap-3.3.4/fonts/glyphicons-halflings-regular.eot dist/bootstrap-3.3.4/fonts/glyphicons-halflings-regular.svg dist/bootstrap-3.3.4/fonts/glyphicons-halflings-regular.ttf dist/bootstrap-3.3.4/fonts/glyphicons-halflings-regular.woff dist/bootstrap-3.3.4/fonts/glyphicons-halflings-regular.woff2

less: dist/less-2.3.1/less.min.js

dist:
	@mkdir $@

dist/bootstrap-3.3.4/fonts/%: vendor/bootstrap-3.3.4/fonts/%
	@mkdir -p dist/bootstrap-3.3.4/fonts
	cp $< $@

dist/bootstrap-3.3.4/css/%: vendor/bootstrap-3.3.4/css/%
	@mkdir -p dist/bootstrap-3.3.4/css
	cp $< $@

dist/less-2.3.1/%: vendor/less-2.3.1/%
	@mkdir -p dist/less-2.3.1
	cp $< $@

dist/main.js: src/* dist
	elm-make src/Main.elm --output=$@

dist/%.css: static/%.css dist
	cp $< $@

dist/%.less: static/%.less dist
	cp $< $@

dist/%.html: static/%.html dist
	cp $< $@

dist/%.js: static/%.js dist
	cp $< $@

dist/%.json: static/%.json dist
	cp $< $@

dist/%.gif: static/%.gif dist
	cp $< $@

dist/%.ico: static/%.ico dist
	cp $< $@

prod: ../github-pages/style.css ../github-pages/main.js ../github-pages/interop.js

../github-pages/style.css: dist/style.less
	lessc $< > $@

../github-pages/%.js: dist/%.js
	cp $< $@
