express = require 'express'
bodyParser = require 'body-parser'
request = require 'request'
app = express()

app.set 'port', (process.env.PORT || 5000)
app.use bodyParser.urlencoded(extended: false)
app.use bodyParser.json()

token = process.env.PAGE_ACCESS_TOKEN

# Index route
app.get '/', (req, res) ->
  res.send "I'm Eightbot!"

# For Facebook verification
app.get '/webhook/', (req, res) ->
  console.log 'test'
  if req.query['hub.verify_token'] == process.env.MESSENGER_VERIFY_TOKEN
    res.send req.query['hub.challenge']
  else
    res.send 'Error: invalid token'

# Process messages
app.post '/webhook', (req, res) ->
  console.log "Starting to process"
  messaging_events = req.body.entry[0].messaging
  for event in messaging_events
    console.log event
    sender = event.sender.id
    if event.message and event.message.text
      text = event.message.text
      sendTextMessage sender, "Text received, echo: #{text.substring(0, 200)}"
  res.sendStatus 200

# Send a message
sendTextMessage = (sender, text) ->
  messageData =
    text: text
  obj =
    url: 'https://graph.facebook.com/v2.6/me/messages'
    qs: {access_token: token}
    method: 'POST'
    json:
      recipient: id:sender
      message: messageData
  request obj, (error, response, body) ->
    if error
      console.log 'Error sending messages:', error
    else if response.body.error
      console.log 'Error:', response.body.error
 
app.listen app.get('port'), ->
  console.log 'Eightbot is running on port',
  app.get('port'),
  'in NODE_ENV:',
  process.env.NODE_ENV