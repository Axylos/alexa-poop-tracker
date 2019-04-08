require 'sinatra'
require 'byebug'
require 'sinatra/json'
require 'awesome_print'
require 'sinatra/reloader' if development?
require_relative 'models'

set :port, 8055

def build_response(txt)
  {
    "version": "1.0",
    "response": {
      "outputSpeech": {
        "type": "PlainText",
        "text": txt
      },
      "shouldEndSession": false,
      reprompt: {
        "outputSpeech": {
          type: "PlainText",
          text: "I guess that's all",
          playBehavior: "REPLACE_ENQUEUED"
        }
      }
    }
  }
end

get '/' do
  p params
  json({msg: :ok})
end

post '/' do
  content_type :json
  p body
  body = JSON.parse request.body.read
  req = body["request"]
  if req["type"] == "IntentRequest" && req["intent"]["name"] == 'RecordPoop'

    data = {
      user_id: body["session"]["user"]["userId"],
      session_id: body["session"]["sessionId"],
      aws_timestamp: body["request"]["timestamp"],
      locale: body["request"]["locale"],
    }

    Poop.create!(data)
    count = Poop.user_day_poops(data[:user_id]).count
    json build_response("Ah! Got it!  You have taken #{count} poops today")
  else
    p req
    json build_response('What can I do for you')
  end
end

