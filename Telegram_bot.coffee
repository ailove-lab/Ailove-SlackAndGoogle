TelegramBot = require 'node-telegram-bot-api'

token = '...'

bot = new TelegramBot token, polling: true

#// Matches /echo [whatever]
bot.onText /\/echo (.+)/,  (msg, match)->
    fromId = msg.from.id
    resp = match[1]
    bot.sendMessage(fromId, resp)

# Any kind of message
# bot.on 'message', (msg)->
#     chatId = msg.chat.id
#     # // photo can be: a file path, a stream or a Telegram file_id
#     photo = 'logo.jpg'
#     bot.sendPhoto chatId, photo
