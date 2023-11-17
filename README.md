# A static html site with a blog converted from markdown

Source code & markdown for generating a website, forked from [jillesvangurp.com](https://www.jillesvangurp.com) and used for my own [website](https://hiramring.com). The site uses pandoc and a bit of bash to generate static pages.

As with [the original repo](https://github.com/jillesvangurp/www.jillesvangurp.com), feel free to copy and adapt as needed. This bunch of scripts is deliberately kept minimal and simple. Features I have added are:

1. Updated the `tailwind` CSS with code from the [Air template](https://github.com/markdowncss/air)
2. The use of dropdown menus in navigation
3. Adjusted index generation for the blog posts, to use the `title` field in the yaml header and to convert numerical months to month names (abbreviated) in the sidebar (which is limited to the 10 most recent posts)
4. Added short (200 character) summaries of each post in the article index
5. Added two different link styles in the CSS: one with normal underlines for regular text (default), and one without (`class="noform"`) for headings etc.
6. Added two different kinds of image styles in the CSS: one for radial images (`#radial`) like the portrait on the homepage and one for full-width images (default)

Additionally, I don't yet use the atom feed feature implemented by Jilles, since it requires playing around with Nginx (on my server) to support rewrite rules and I haven't taken the time to get that working. As a result, I hard-coded the blog posts and so they probably won't actually work with an atom feed, though they should display nicely in your `localhost` when run in the docker container. The site also needs a bit more styling work to get it working nicely on mobile devices.

## Features

- Uses pandoc to render github flavored markdown. This repo contains dummy pages that you can edit - for my site I exported some of my old articles to markdown format and did a bit of manual cleanup.
- Can be used to render code blocks as well
- Sitemap, article index, and recent articles are generated.
- Atom feed is generated for the articles, but this may require some adjustment depending on how your site is served.
- Tailwind css styling & css minifier.

## Usage

Instead of installing a lot of stuff, everything is done via docker. The docker container installs all the necessary tools, but it also means you need to have a local docker installation running, like [Docker desktop](https://www.docker.com/products/docker-desktop/).

```bash
# create docker container with tools and scripts
make docker
# build the site
make all
# check if you like what it did
# the command below starts a local apache server (`localhost:8080`) so you can view the changes if you prefer
make run
# turn off your server
make stop
# you should tweak the Makefile to update where and how you deploy before you run this. Uses rsync.
make deploy
```

## Directories and files

- `articles` this is where you put your blog articles. Use an iso date (year-month-day) as the name prefix so it gets sorted correctly.
- `docker` this is where all the scripts and the Dockerfile live.
- `pages` this is where the markdown for each of the pages live.
- `static` this is the static part of the website.
- `public` this directory is git ignored and is where the generated files end up.
- `templates` put your pandoc templates here.
- `footer.html` and `navigation.html` some hard coded navigation injected in the template.
- `Makefile` mostly self explanatory, you should tweak the hard coded values.

## License

The scripts & css are MIT licensed. The Markdown & website content is also, and uses attributed copyright-free images.
