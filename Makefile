.DEFAULT_GOAL := all

export SITEGEN=docker run -v $(shell pwd):/root sitegen

.PHONY: docker
docker:
	docker build docker -t sitegen

.PHONY: clean
clean:
	rm -rf public

.PHONY: pages
pages:
	mkdir -p public/blog
	# link so we can develop
	cp .htaccess public
	cp -R static public
	# cp -R wp-content public
	$(SITEGEN) pd-pages.sh

.PHONY: blogindex
blogindex:
	$(SITEGEN) indexgenerator.sh

.PHONY: blog
blog: blogindex
	$(SITEGEN) pd-articles.sh

.PHONY: run
run:
	docker run -dit --rm --name site-httpd -p 8080:80 -v "$(shell pwd)/public":/usr/local/apache2/htdocs/ httpd

.PHONY: stop
stop:
	docker kill site-httpd

.PHONY: minify
minify:
  # tailwind expects node_modules but it only exists in the docker file; so link it here temporarily
	rm -f node_modules
	$(SITEGEN) ln -s /npm/node_modules
	$(SITEGEN) npx postcss tailwind.css -o style.css
	rm node_modules
	echo '```html' > sample.md
	echo "OHAI" >> sample.md
	echo '```' >> sample.md
	$(SITEGEN) pandoc --template=highlighting-css.template sample.md -o highlighting.css
	rm sample.md
	cat highlighting.css >> style.css
	$(SITEGEN) minify style.css -o public/style.css

.PHONY: sitemap
sitemap:
	$(SITEGEN) sitemap.sh

.PHONY: atom
atom:
	$(SITEGEN) atom.sh

.PHONY: deploy
deploy:
	rsync -hvrPt public/* user@11.111.111.11:~/websitename/
	scp public/.htaccess hiram@11.111.111.11:~/websitename/

.PHONY: all
all: clean pages blog sitemap atom minify
