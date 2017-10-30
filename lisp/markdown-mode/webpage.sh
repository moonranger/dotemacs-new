#!/bin/sh

STARTRE='^;;; Commentary:$'
STOPRE='^$'
DATE=$(date +"%B %e, %Y %H:%M %Z")

echo "title: Markdown Mode for Emacs
description: A major mode for GNU Emacs for editing Markdown-formatted text files.
markup: markdown
city: Columbus
created: May 24, 2007 23:47 GMT
modified: $DATE
style: #badges { margin-bottom: 1.5rem; }

<div id=\"badges\">
<a href=\"https://github.com/jrblevin/markdown-mode\"><img src=\"https://img.shields.io/github/stars/jrblevin/markdown-mode.svg?style=social&label=GitHub\" alt=\"GitHub\"/></a>
<a href=\"https://melpa.org/#/markdown-mode\"><img src=\"https://melpa.org/packages/markdown-mode-badge.svg\" alt=\"MELPA badge\"/></a>
<a href=\"https://stable.melpa.org/#/markdown-mode\"><img src=\"https://stable.melpa.org/packages/markdown-mode-badge.svg\" alt=\"MELPA stable badge\"/></a>
<a href=\"https://travis-ci.org/jrblevin/markdown-mode\"><img src=\"https://travis-ci.org/jrblevin/markdown-mode.svg?branch=master\" alt=\"Travis CI Build Status\"/></a>
<a href=\"https://leanpub.com/markdown-mode\"><img src=\"https://img.shields.io/badge/leanpub-guide-orange.svg\" alt=\"Guide to Markdown Mode for Emacs\"/></a>
</div>" > index.text

echo "# Emacs Markdown Mode [![MELPA badge][melpa-badge]][melpa-link] [![MELPA stable badge][melpa-stable-badge]][melpa-stable-link] [![Travis CI Build Status][travis-badge]][travis-link] [![Guide to Markdown Mode for Emacs][leanpub-badge]][leanpub-link]

  [melpa-link]: https://melpa.org/#/markdown-mode
  [melpa-stable-link]: https://stable.melpa.org/#/markdown-mode
  [melpa-badge]: https://melpa.org/packages/markdown-mode-badge.svg
  [melpa-stable-badge]: https://stable.melpa.org/packages/markdown-mode-badge.svg
  [travis-link]: https://travis-ci.org/jrblevin/markdown-mode
  [travis-badge]: https://travis-ci.org/jrblevin/markdown-mode.svg?branch=master
  [leanpub-link]: https://leanpub.com/markdown-mode
  [leanpub-badge]: https://img.shields.io/badge/leanpub-guide-orange.svg

<!-- This file is autogenerated by webpage.sh from the comments at the top of
     markdown-mode.el. Make edits there, not here. -->" > README.md

cat markdown-mode.el |\
    # Keep only the Commentary section
    awk "/$STARTRE/,/$STOPRE/" |\
    # Remove the start and step regexps
    grep -v "$STARTRE" | grep -v "$STOPRE" |\
    # Convert headers
    sed -e 's/^;;; \(.*\):$/## \1/' |\
    # Remove leading spaces (but don't disturb pre blocks)
    sed -e 's/^;;[ ]\{0,1\}//' |\
    # Escape wiki links
    #sed -e 's/\(\[\[[^]\n]*\]\]\)/\\\1/g' |\
    # Use <kbd> tags for single characters (except `t`)
    sed -e 's/`\([^`t]\)`/<kbd>\1<\/kbd>/g' |\
    # Use <kbd> tags for TAB and RET keys
    sed -e 's/`TAB`/<kbd>TAB<\/kbd>/g' |\
    sed -e 's/`RET`/<kbd>RET<\/kbd>/g' |\
    # Use <kbd> tags for keybindings prefixed by C, M, or S
    sed -e 's/`\([CMS]-[^`]*\)`/<kbd>\1<\/kbd>/g' |\
    # Use Markdown-style backticks for single-quoted lisp code
    sed -e 's/`\([^'\'']*\)'\''/`\1`/g' |\
    # checkdoc wants Lisp to always be capitalized
    sed -e 's/^\([ ]*\)``` Lisp$/\1```lisp/' |\
    # Remove email addresses
    sed -e 's/ <[^>]*@[^<]*> / /g' \
    | tee -a README.md >> index.text