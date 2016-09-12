express = require 'express'
bodyParser = require 'body-parser'
request = require 'request'
app = express()

app.set 'port', (process.env.PORT || 5000)
app.use bodyParser.urlencoded(extended: false)
app.use bodyParser.json()

token = process.env.FB_PAGE_ACCESS_TOKEN

# Index route
app.get '/', (req, res) ->
  res.send "I'm Eightbot!"

# For Facebook verification
app.get '/webhook/', (req, res) ->
  if req.query['hub.verify_token'] == process.env.MESSENGER_VERIFY_TOKEN
    res.send req.query['hub.challenge']
  else
    res.send 'Error: invalid token'

# Process messages
app.post '/webhook', (req, res) ->
  messaging_events = req.body.entry[0].messaging
  for event in messaging_events
    sender = event.sender.id
    if event.message and event.message.text
      text = event.message.text
      sendTextMessage sender, "Text received, echo: #{text.substring(0, 200)}"
  res.sendStatus 200


app.listen app.get('port'), ->
  console.log 'Eightbot is running on port',
  app.get('port'),
  'in NODE_ENV:',
  process.env.NODE_ENV