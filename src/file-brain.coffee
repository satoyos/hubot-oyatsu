# Description
#   A Hubot script to persist hubot's brain using text-file
#
# Commands:
#   None
#
# Author:
#   Yoshifumi Sato <sato_yos@nifty.com>

Fs = require 'fs'

config =
  path: './brain.json'

module.exports = (robot) ->
  unless config.path?
    robot.logger.error 'process.env.HUBOT_FILE_BRAIN_PATH is not defined'
    return

  robot.brain.setAutoSave false

  load = ->
    if Fs.existsSync config.path
      data = JSON.parse Fs.readFileSync config.path, encodin: 'utf-8'
      robot.brain.mergeData data
    robot.brain.setAutoSave true

  save = (data) ->
    Fs.writeFileSync config.path, JSON.stringify data

  robot.brain.on 'save', save

  load()
  
