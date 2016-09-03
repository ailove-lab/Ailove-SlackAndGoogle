fs = require('fs')
readline = require('readline')
google = require('googleapis')
googleAuth = require('google-auth-library')

# If modifying these scopes, delete your previously saved credentials
# at ~/.credentials/script-nodejs-quickstart.json
SCOPES = [ 
  'https://www.googleapis.com/auth/drive',
  'https://www.googleapis.com/auth/spreadsheets']

# TOKEN_DIR = (process.env.HOME or process.env.HOMEPATH or process.env.USERPROFILE) + '/.credentials/'
TOKEN_DIR = './'
TOKEN_PATH = TOKEN_DIR + 'access_token.json'
# Load client secrets from a local file.

###*
# Create an OAuth2 client with the given credentials, and then execute the
# given callback function.
#
# @param {Object} credentials The authorization client credentials.
# @param {function} callback The callback to call with the authorized client.
###

authorize = (credentials, callback)->
    clientSecret = credentials.installed.client_secret
    clientId = credentials.installed.client_id
    redirectUrl = credentials.installed.redirect_uris[0]
    auth = new googleAuth
    oauth2Client = new (auth.OAuth2)(clientId, clientSecret, redirectUrl)
    # Check if we have previously stored a token.
    fs.readFile TOKEN_PATH, (err, token) ->
        if err
            getNewToken oauth2Client, callback
        else
            oauth2Client.credentials = JSON.parse(token)
            callback oauth2Client

###*
# Get and store new token after prompting for user authorization, and then
# execute the given callback with the authorized OAuth2 client.
#
# @param {google.auth.OAuth2} oauth2Client The OAuth2 client to get token for.
# @param {getEventsCallback} callback The callback to call with the authorized
#     client.
###

getNewToken = (oauth2Client, callback) ->
  authUrl = oauth2Client.generateAuthUrl(
    access_type: 'offline'
    scope: SCOPES)
  console.log 'Authorize this app by visiting this url: ', authUrl
  rl = readline.createInterface(
    input: process.stdin
    output: process.stdout)
  rl.question 'Enter the code from that page here: ', (code) ->
    rl.close()
    oauth2Client.getToken code, (err, token) ->
      if err
        console.log 'Error while trying to retrieve access token', err
        return
      oauth2Client.credentials = token
      storeToken token
      callback oauth2Client

###*
# Store token to disk be used in later program executions.
#
# @param {Object} token The token to store to disk.
###

storeToken = (token) ->
  try
    fs.mkdirSync TOKEN_DIR
  catch err
    if err.code != 'EEXIST'
      throw err
  fs.writeFile TOKEN_PATH, JSON.stringify(token)
  console.log 'Token stored to ' + TOKEN_PATH

###*
# Call an Apps Script function to list the folders in the user's root
# Drive folder.
#
# @param {google.auth.OAuth2} auth An authorized OAuth2 client.
###

callAppsScript = (auth) ->
  scriptId = 'M2KKyOiR9nKTnFXMXZz9bmJZrIPuIe0A9'
  script = google.script('v1')
  # Make the API request. The request object is included here as 'resource'.
  script.scripts.run {
    auth: auth
    resource: 
      function: 'searchEmployeeByName'
      parameters: ['ailove офис', 'Екатерина']
    scriptId: scriptId
  }, (err, resp) ->
    console.error err
    if err
      # The API encountered a problem before the script started executing.
      console.log 'The API returned an error: ' + err
      return
    if resp.error
      # The API executed, but the script returned an error.
      # Extract the first (and only) set of error details. The values of this
      # object are the script's 'errorMessage' and 'errorType', and an array
      # of stack trace elements.
      error = resp.error.details[0]
      console.log 'Script error message: ' + error.errorMessage
      console.log 'Script error stacktrace:'
      if error.scriptStackTraceElements
        # There may not be a stacktrace if the script didn't start executing.
        i = 0
        while i < error.scriptStackTraceElements.length
          trace = error.scriptStackTraceElements[i]
          console.log '\u0009%s: %s', trace.function, trace.lineNumber
          i++
    else
      # The structure of the result will depend upon what the Apps Script
      # function returns. Here, the function returns an Apps Script Object
      # with String keys and values, and so the result is treated as a
      # Node.js object (folderSet).
      folderSet = resp.response.result
      console.log resp.response.result

fs.readFile 'client_secret.json', (err, content) ->
    if err
        console.log 'Error loading client secret file: ' + err
        return
    # Authorize a client with the loaded credentials, then call the
    # Google Apps Script Execution API.
    authorize JSON.parse(content), callAppsScript
