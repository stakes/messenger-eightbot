express = require 'express'
bodyParser = require 'body-parser'
request = require 'request'
app = express()

app.set 'port', (process.env.PORT || 5000)

app.use bodyParser.urlencoded(extended: false)

app.use bodyParser.json()

# Index route
app.get '/', (req, res) ->
  res.send "I'm Eightbot!"

# For Facebook verification
app.get '/webhook/', (req, res) ->
  if req.query['hub.verify_token'] == 'my_voice_is_my_password_verify_me'
    res.send req.query['hub.challenge']
  else
    res.send 'Error: invalid token'

app.listen app.get('port'), ->
  console.log 'Eightbot is running on port', app.get('port')