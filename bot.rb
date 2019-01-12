#!/usr/bin/env ruby

require 'csv'
require 'rubygems'
require 'dotenv/load'
require 'mastodon'
require 'open-uri'
require 'tempfile'


token = ENV["MASTODON_TOKEN"]
mastodon = Mastodon::REST::Client.new(base_url: 'https://botsin.space', bearer_token:token)

source = ENV["DATA_FILE"] || "BBCSoundEffects.csv"
lines = File.read(source, :encoding => 'UTF-8').split(/\n/)
lines.shift

count = lines.count

if ENV['INDEX']
  data = lines[ENV['INDEX'].to_i]
else
  data = lines.sample
end

puts data

data = CSV.parse(data).first

#"location","description","secs","category","CDNumber","CDName","tracknum"
#"07046130.wav","Bulldozer (tracked vehicle) - starting ticking over, driving away - 1981 (6B1, reprocessed)","133","","ECD081","Exterior Effects","5"

# [
#   "07046130.wav",
#   "Bulldozer (tracked vehicle) - starting ticking over, driving away - 1981 (6B1, reprocessed)",
#   "133",
#   "",
#   "ECD081",
#   "Exterior Effects",
#   "5"
# ]


filename = data[0]
description = data[1]
category = data[3]

url = "http://bbcsfx.acropolis.org.uk/?q=#{filename}"
if category != "" && category != description
  status = "#{category}: #{description} #{url}"
else
  status = "#{description} #{url}"
end

status = status.gsub(/,/, ", ").gsub(/ +/, ' ')

media_url = "http://bbcsfx.acropolis.org.uk/assets/#{filename}"
puts media_url
uri = URI.parse(media_url) #=> #<URI::HTTP>
io = uri.open

file = Tempfile.new(['input', '.wav'])
FileUtils.mv io.path, file.path


# switch to mp3s when mastodon supports them
# https://github.com/tootsuite/mastodon/compare/feature-audio
# 6

#mp3 = Tempfile.new(['output', '.mp3'])
mp4 = Tempfile.new(['output', '.mp4'])

# generate a glitched image as cover for the audio
`bundle exec ./image-glitch ./hearts.jpg 10; convert glitch.png -quality 20 glitch.jpg`

#cmd = "sox #{file.path} #{mp3.path}"

#cmd = "ffmpeg -y -loop 1 -i glitch.jpg -i #{file.path} -c:a aac -ab 112k -c:v libx264 -shortest #{mp4.path}"
cmd = "ffmpeg -y -loop 1 -i glitch.jpg -i #{file.path} -c:a aac -ab 112k -c:v libx264 -shortest #{mp4.path}"
puts cmd

`#{cmd}`

if File.exist?(mp4.path)
#if File.exist?(mp3.path)  
  media = mastodon.upload_media(mp4.path)
  mastodon.create_status(status, nil, [ media.id ])
end
