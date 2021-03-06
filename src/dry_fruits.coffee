# Description
#   A hubot script that check opening Dry Fruits packeage
#
# Commands:
#   hubot 開け*|開封* - tell Hubot that you opened a dry fruit package
#   hubot df list   - list up all logs of opening dry fruit package
#   hubot df count  - return how many packages of dry fruit you opened
#   hubot df delete - delete last log of opening dry fruit package
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Yoshifumi Sato <sato_yos@nifty.com>

moment = require 'moment'

module.exports = (robot) ->
  moment.locale('ja')
  key = 'dry-fruits-logs'
  
  robot.respond /開け|開封/, (msg) ->
    org_logs = robot.brain.get(key) ? []
    logs = org_logs.map (ol) ->  moment(ol)
    logs.push moment()
    robot.brain.set(key, logs)
    robot.brain.save()
    week_beginning = moment().startOf('week')
    # msg.send "今週の始まりは、#{week_beginning.format('YYYY-MM-DD HH:mm')}" #
    week_logs = logs.filter (m) ->
      m.isAfter(week_beginning)
    msg.send "ドライフルーツを開けましたね。今週(#{week_beginning.format('MM/DD')}の週)は#{week_logs.length}袋目で、通算では#{logs.length}袋目です。"
    msg.send "（ちなみに、 #{logs[0].format('YYYY/MM/DD')} からカウントし始めています。）"

  robot.respond /df reset/, (msg) ->
    robot.brain.set(key, [])
    msg.send "ドライフルーツのログをリセットしました。"
    
  robot.respond /df list/, (msg) ->
    org_logs = robot.brain.get(key) ? []
    logs = org_logs.map (ol) ->  moment(ol)
    message = logs.map (l) ->
      "#{l.format('YYYY-MM-DD HH:mm')} に開けた。"
    .join '\n'
    msg.send message

  robot.respond /df delete/, (msg) ->
    org_logs = robot.brain.get(key) ? []
    logs = org_logs.map (ol) ->  moment(ol)
    removed_record = logs.pop()
    robot.brain.set(key, logs)
    robot.brain.save()
    msg.send "最後の記録(#{removed_record.format('YYYY-MM-DD HH:mm')})を削除しました。"

  robot.respond /df count/, (msg) ->
    org_logs = robot.brain.get(key) ? []
    logs = org_logs.map (ol) ->  moment(ol)
    msg.send "これまでに開けたドライフルーツ: #{logs.length}袋"
    
