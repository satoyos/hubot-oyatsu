# Description
#   A hubot script that check oyatsu
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot hello - <what the respond trigger does>
#   orly - <what the hear trigger does>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Yoshifumi Sato <sato_yos@nifty.com>

moment = require 'moment'

module.exports = (robot) ->
  moment.locale('ja')
  key = 'ice-coffee-logs'
  
  robot.respond /飲ん|飲み/, (msg) ->
    org_logs = robot.brain.get(key) ? []
    logs = org_logs.map (ol) ->  moment(ol)
    logs.push moment()
    robot.brain.set(key, logs)
    robot.brain.save()
    today_beginning = moment().hour(0).minute(0).seconds(0)
    today_logs = logs.filter (m) ->
      m.isAfter(today_beginning)
    msg.send "なるほど、氷コーヒーですね。私の記憶が確かならば、今日#{today_logs.length}杯目ですが、合ってます？"

  robot.respond /coffee reset/, (msg) ->
    robot.brain.set(key, [])
    msg.send "氷コーヒーのログをリセットしました。"
    
  robot.respond /coffee list/, (msg) ->
    org_logs = robot.brain.get(key) ? []
    logs = org_logs.map (ol) ->  moment(ol)
    message = logs.map (l) ->
      "#{l.format('YYYY-MM-DD HH:mm')} に飲んだ。"
    .join '\n'
    msg.send message
