# GOOGLE DRIVE API
fs = require('fs')
readline = require('readline')
google = require('googleapis')
googleAuth = require('google-auth-library')

TOKEN_DIR = './'
TOKEN_PATH = TOKEN_DIR + 'access_token.json'

# TELEGRAM API
TelegramBot = require 'node-telegram-bot-api'
telegram_token = '...'



### INIT GOOGLE API ###

await fs.readFile 'client_secret.json', defer(err, content)
if err
    console.error 'Error loading client secret file: ' + err
    process.exit -1

# Authorize a client with the loaded credentials, then call the
# Google Apps Script Execution API.
credentials = JSON.parse content
clientSecret = credentials.installed.client_secret
clientId = credentials.installed.client_id
redirectUrl = credentials.installed.redirect_uris[0]
auth = new googleAuth
oauth2Client = new (auth.OAuth2)(clientId, clientSecret, redirectUrl)
# Check if we have previously stored a token.
await fs.readFile TOKEN_PATH, defer(err, token)
if err
    console.error err
    process.exit -1 

oauth2Client.credentials = JSON.parse(token)

searchEmployeeByName = (name, callback) ->
    scriptId = '...'
    script = google.script('v1')
    # Make the API request. The request object is included here as 'resource'.
    request = 
        auth: oauth2Client
        resource: 
            function: 'searchEmployeeByName'
            parameters: ['ailove офис', name]
        scriptId: scriptId

    await script.scripts.run request, defer(err, resp)
    
    if err
        return callback 'The API returned an error: ' + err

    if resp.error
        return callback JSON.stringify err
    
    callback resp.response.result

# TEST
# await searchEmployeeByName "Константин", defer employees
# console.log employees
# process.exit 0

### INIT TELEGRAM BOT ###

bot = new TelegramBot telegram_token, polling: true

bot.onText /\/start/,  (msg, match)->
    bot.sendPhoto msg.from.id, "logo.jpg"

bot.onText /\/help/,  (msg, match)->
    bot.sendMessage msg.from.id, """
    /help - Эта подсказка
    /name Имя - Поиск сотрудника"""
    

# Matches /echo [whatever]
# bot.onText /\/echo (.+)/,  (msg, match)->
    # fromId = msg.from.id
    # resp = match[1]
    # bot.sendMessage fromId, resp

# Matches /echo [whatever]
bot.onText /\/name (.+)/,  (msg, match)->
    fromId = msg.from.id
    await searchEmployeeByName match[1], defer result
    # console.log result
    if result.length is 0
        return bot.sendMessage msg.from.id, "Никого с именем '#{match[1]}' не найдено"
    bot.sendMessage msg.from.id, result.join '\n'

# Any kind of message
# bot.on 'message', (msg)->
#     chatId = msg.chat.id
#     # // photo can be: a file path, a stream or a Telegram file_id
#     photo = 'logo.jpg'
#     bot.sendPhoto chatId, photo
