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

module.exports = (robot) ->
  robot.respond /飲んだ/, (msg) ->
    msg.send "氷コーヒーですね。分かります。了解ですが、まだ記録はできません"
