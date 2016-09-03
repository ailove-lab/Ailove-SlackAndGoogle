# GOOGLE DRIVE API

fs          = require('fs')
readline    = require('readline')
google      = require('googleapis')
googleAuth  = require('google-auth-library')
TelegramBot = require 'node-telegram-bot-api'
cfg         = require('./config')


TOKEN_DIR  = './'
TOKEN_PATH = TOKEN_DIR + 'access_token.json'

scriptId = cfg.script_id
script   = google.script('v1')

telegram_token = cfg.telegram_token

employes = {}



### INIT GOOGLE API ###

await fs.readFile 'client_secret.json', defer(err, content)
if err
    console.error 'Error loading client secret file: ' + err
    process.exit -1

# Authorize a client with the loaded credentials, then call the
# Google Apps Script Execution API.
credentials  = JSON.parse content
clientSecret = credentials.installed.client_secret
clientId     = credentials.installed.client_id
redirectUrl  = credentials.installed.redirect_uris[0]
auth         = new googleAuth
oauth2Client = new (auth.OAuth2)(clientId, clientSecret, redirectUrl)

# Check if we have previously stored a token.
await fs.readFile TOKEN_PATH, defer(err, token)
if err
    console.error err
    process.exit -1 

oauth2Client.credentials = JSON.parse(token)



### BOT API ###

searchEmployeeByName = (name, callback) ->
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


searchEmployeeByDivision = (division, callback) ->

    request = 
        auth: oauth2Client
        resource: 
            function: 'searchEmployeeByDivision'
            parameters: ['ailove офис', division]
        scriptId: scriptId

    await script.scripts.run request, defer(err, resp)
    
    if err
        return callback 'The API returned an error: ' + err

    if resp.error
        return callback JSON.stringify err
    
    callback resp.response.result


getListOfDivisions = (callback) ->

    request = 
        auth: oauth2Client
        resource: 
            function: 'getListOfDivisions'
            parameters: ['ailove офис']
        scriptId: scriptId

    await script.scripts.run request, defer(err, resp)
    
    if err
        return callback 'The API returned an error: ' + err

    if resp.error
        return callback JSON.stringify err
    
    callback resp.response.result


searchEmployeeByPosition = (position, callback) ->

    request = 
        auth: oauth2Client
        resource: 
            function: 'searchEmployeeByPosition'
            parameters: ['ailove офис', position]
        scriptId: scriptId

    await script.scripts.run request, defer(err, resp)
    
    if err
        return callback 'The API returned an error: ' + err

    if resp.error
        return callback JSON.stringify err
    
    callback resp.response.result


searchEmployeeByPhone = (phone, callback) ->

    request = 
        auth: oauth2Client
        resource: 
            function: 'searchEmployeeByPhone'
            parameters: ['ailove офис', phone]
        scriptId: scriptId

    await script.scripts.run request, defer(err, resp)

    if err
        return callback 'The API returned an error: ' + err

    if resp.error
        return callback JSON.stringify err
    
    callback resp.response.result


pushenStickers = [
    "BQADAgADtgADmY-lBwlqL7J-la83Ag"
    "BQADBAADxgIAAlI5kwaWbz4LnOTR9QI"
    "BQADAgADGgEAApmPpQcVS4piscKf1gI"
    "BQADAgADDwEAAjbsGwU9wqxYK8myKgI"
    "BQADAgADuAADmY-lB98Xhw-VyBIhAg"
    "BQADAgADOQEAAjbsGwVOJ89tj8YY7gI"
    "BQADAgADQAEAAjbsGwW35blshnfFjgI"
    "BQADAgAD0QEAAjbsGwWmp840o5xVfgI"]

randomPushenSticker = ()->pushenStickers[Math.random()*pushenStickers.length|0]

pushenMoneyAnswers = [
    "Мало!", "Ещё!", "Больше!", "Не жмоться!", "Я знаю у тебя есть ещё!", "Раскошеливайся!", "Больше денег!"
    "И это всё?", "Ну ты и жмот!", "Ты меня хочешь оскорбить?", "А в другом кармане?", "И куртку!", "И мотоцикл"
    "Сейчас обижусь", "Мне этого даже на бутерброд не хватит!", "Это что рубли?"]

randomPushenAnswer = ()->pushenMoneyAnswers[Math.random()*pushenMoneyAnswers.length|0]

# TEST
# await getListOfDivisions defer divisions
# console.log divisions
# process.exit 0


### INIT TELEGRAM BOT ###

bot = new TelegramBot telegram_token, polling: true

phoneToCat = "Отдать коту свой телефон 📱"
moneyToCat = "Дать коту денег 💵"


checkEmployee = (uid, cb)->

    return cb true if uid of employes

    bot.sendSticker uid, "BQADAgADvAEAAjbsGwVRWFeV22KuLgI"
    await setTimeout defer(), 1000
    
    params = 
        reply_markup: JSON.stringify(
            keyboard:[
                [text: phoneToCat, request_contact:true]
                [text: moneyToCat]
            ]
            resize_keyboard: true)
    bot.sendMessage uid, """
        Мне нужен твой телефон и все твои деньги!
        """, params 
    
    cb false


sendHelp = (uid) -> bot.sendMessage uid, """
    /help - Эта подсказка
    /name Имя - Поиск сотрудника
    /div Отдел - Список сотрудниов в отделе
    /pos Должность - Список сотрудниов по должности
    
    *Внимание!*

    Поиск очень дотошный и проверяет полное совпадение искомого. Например `Кайнов Илья` не будет найден, если он записан как `Илья Кайнов`

    Ищите просто `/name Илья` или даже `/name ил` - в последнем случае найдутся все у кого есть в имени `ил` 

    """, parse_mode:'markdown'
  


### TELEGRAM CALLBACKS ###

bot.on "message", (msg)->
   
    console.log msg
    
    if msg.text is moneyToCat
        bot.sendSticker msg.from.id, randomPushenSticker()
        await setTimeout defer(), 1000
        bot.sendMessage msg.from.id, randomPushenAnswer()
        return
        
    # Проверяем сотрудника, есть ли его телефон
    if msg.contact
        if msg.contact.user_id is msg.from.id
        
            # удаляем все кроме цифр и первую цифру
            phone = msg.contact.phone_number?.replace(/[^\d]+/g, '')[1..]
            await searchEmployeeByPhone phone, defer result
            if result?.length
                
                employes[msg.from.id] = msg.contact
                
                params = 
                    reply_markup: JSON.stringify(hide_keyboard:true)
                    parse_mode: "HTML"
                bot.sendSticker msg.from.id, "BQADAgADTAMAAjbsGwW-DVv9LZvErQI"
                bot.sendMessage msg.from.id, """
                    Aгент #{msg.from.id}?
                    
                    #{result[0]}
                    Извините, не узнал вас в гриме!
                    """, params
                
                await setTimeout defer(), 1000

                sendHelp msg.from.id

            else
                bot.sendSticker msg.from.id, "BQADAgADcAMAAjbsGwVDMuARxEYKkwI"
                bot.sendMessage msg.from.id, """
                    Алё! #{msg.from.first_name}? 
                    Я не нашел номер #{phone} в базе сотрудников!
                    Попроси Катю проверить твой номер!
                    """
        else
            bot.sendMessage msg.from.id, """
                Алё! КГБ?

                Тут гражданин #{msg.from.first_name} #{msg.from.last_name}  @#{msg.from.username}
                Паспортный номер: #{msg.from.id}

                Дал мне не свой телефон!

                Алё!

                Кто достал? Я достал?

                Алё!
                """
            bot.sendSticker msg.from.id, "BQADAgADpQADmY-lB-LCuAfA4KxGAg"

bot.onText /\/start/,  (msg, match)->
    
    await checkEmployee msg.from.id, defer employee
    return unless employee



bot.onText /\/help(@AiloveTeamBot)*/,  (msg, match)->

    await checkEmployee msg.from.id, defer employee
    return unless employee

    sendHelp msg.from.id

bot.onText /\/name(@AiloveTeamBot)*$/,  (msg, match)->
    
    await checkEmployee msg.from.id, defer employee
    return unless employee

    bot.sendMessage msg.from.id, 
        "после `/name` нужно добавить искомое имя или его часть!",
        parse_mode: "markdown"

bot.onText /\/name(@AiloveTeamBot)* (.+)/,  (msg, match)->

    await checkEmployee msg.from.id, defer employee
    return unless employee

    fromId = msg.from.id
    await searchEmployeeByName match[2], defer result
    # console.log result
    if result.length is 0
        return bot.sendMessage msg.from.id, "Никого с именем '#{match[2]}' не найдено"
    bot.sendMessage msg.from.id, result.join('\n'), parse_mode: "HTML"

bot.onText /^\/div$/,  (msg, match)->

    await checkEmployee msg.from.id, defer employee
    return unless employee

    fromId = msg.from.id
    await getListOfDivisions defer divisions
    buttons = []
    for d, i in divisions
        row = i/3|0
        buttons[row]?=[]
        buttons[row].push "/div #{d}"

    bot.sendMessage msg.from.id, "Выбирите отдел",
        reply_to_message_id: msg.message_id
        reply_markup: JSON.stringify 
            keyboard:          buttons 
            selective:         true
            resize_keyboard:   true
            one_time_keyboard: true

bot.onText /\/div(@AiloveTeamBot)* (.+)/,  (msg, match)->

    await checkEmployee msg.from.id, defer employee
    return unless employee

    fromId = msg.from.id
    await searchEmployeeByDivision match[2], defer result
    # console.log result
    if result.length is 0
        return bot.sendMessage msg.from.id, "Отдела с '#{match[2]}' в названии не найдено"
    bot.sendMessage msg.from.id, result.join('\n'), 
        parse_mode: "HTML"
        reply_to_message_id: msg.message_id 
        reply_markup: JSON.stringify
            hide_keyboard: true
            selective:     true

bot.onText /\/pos(@AiloveTeamBot)*$/,  (msg, match)->
    
    await checkEmployee msg.from.id, defer employee
    return unless employee

    bot.sendMessage msg.from.id, 
        "после `/pos` нужно добавить искомую должность или её часть!",
        parse_mode: "markdown"

bot.onText /\/pos(@AiloveTeamBot)* (.+)/,  (msg, match)->

    await checkEmployee msg.from.id, defer employee
    return unless employee

    fromId = msg.from.id
    await searchEmployeeByPosition match[2], defer result
    # console.log result
    if result.length is 0
        return bot.sendMessage msg.from.id, "Должности с '#{match[2]}' в названии не найдено"
    bot.sendMessage msg.from.id, result.join('\n'), parse_mode: "HTML"
