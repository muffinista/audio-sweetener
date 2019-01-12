# Audio Sweetener

This is the code for the Mastodon bot https://botsin.space/@AudioSweetener

It toots random audio samples from the BBC Sound Effects
archive. Until Mastodon supports posting audio files, the bot converts
them into a video file with a glitched image.

## What's Here?

There's a few files of interest:

- bot.rb is the main code for the bot
- Dockerfile is a docker file that handles dependencies/etc
- build.sh will build a docker image
- run.sh will run the bot

## Thanks Very Much To:

- The BBC for creating and posting this archive
- the [Data Is
  Plural](https://tinyletter.com/data-is-plural/letters/data-is-plural-2019-01-09-edition)
  mailing list and [this
  tweet](https://twitter.com/sephiramy/status/1080887893265068032)
  which mentioned that there was a CSV of the archive. I'd known about
  this archive for awhile but didn't realize there was a
  straightforward way to access a list of all the files.





