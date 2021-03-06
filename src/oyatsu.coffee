# Description
#   A hubot script that check oyatsu
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot 飲ん*|飲み* - tell Hubot that you had a cup of ice coffee
#   hubot coffee list   - list up all logs of ice coffee
#   hubot coffee count  - return how many cups of ice coffee you drunk
#   hubot coffee delete - delete last log of drinking ice coffee
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
    msg.send "なるほど、氷コーヒーですね。私の記憶が確かならば、今日#{today_logs.length}杯目で、通算では#{logs.length}杯目です。"
    msg.send "（ちなみに、 #{logs[0].format('YYYY/MM/DD')} からカウントし始めています。）"

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

  robot.respond /coffee delete/, (msg) ->
    org_logs = robot.brain.get(key) ? []
    logs = org_logs.map (ol) ->  moment(ol)
    removed_record = logs.pop()
    robot.brain.set(key, logs)
    robot.brain.save()
    msg.send "最後の記録(#{removed_record.format('YYYY-MM-DD HH:mm')})を削除しました。"

  robot.respond /coffee count/, (msg) ->
    org_logs = robot.brain.get(key) ? []
    logs = org_logs.map (ol) ->  moment(ol)
    msg.send "これまでに飲んだ氷珈琲の杯数: #{logs.length}"    
    
