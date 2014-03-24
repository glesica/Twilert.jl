module Twilert

using HTTPClient.HTTPC
using JSON

export alert

# Constants

const TWILIO_BASE = "https://api.twilio.com/2010-04-01"

# Structures

type Credentials
    sid::String
    token::String
end

type Message
    body::String
    to::String
    from::String
    creds::Credentials
end

# Helper functions

function authheader(creds::Credentials)
    sid = creds.sid
    token = creds.token
    encoded = base64("$sid:$token")

    value = "Basic $encoded"

    return ("Authorization", value)
end

function sendmsg(msg::Message)
    sid = msg.creds.sid

    body = msg.body
    to = msg.to
    from = msg.from

    url = "$TWILIO_BASE/Accounts/$sid/Messages"
    data = [("Body", body), ("To", to), ("From", from)]
    headers = [authheader(msg.creds)]
    req = HTTPC.RequestOptions(headers=headers)

    resp = HTTPC.post(url, data, req)

    if resp.http_code == 201
        return :ok
    else
        return :error
    end
end

function loadcfg()
    cfgfile = Nothing
    try
        cfgfile = open(".twilertrc", "r")
    catch
        try
            home = homedir()
            cfgfile = open("$home/.twilertrc", "r")
        catch
            error("Failed to load config")
        end
    end
    
    cfg = JSON.parse(cfgfile)
    close(cfgfile)

    # Test for minimal set of keys
    if ! ("sid" in keys(cfg) && "token" in keys(cfg))
        error("Missing keys in config")
    end

    return cfg
end

# Exported functions

function alert(body::String, to::String, from::String, creds::Credentials)
    # Basic validation
    if first(to) != '+' || first(from) != '+'
        error("Phone number must begin with '+'")
    end
    if length(body) > 1600
        error("Message body too long")
    end

    msg = Message(body, to, from, creds)
    result = sendmsg(msg)

    return result
end

function alert(body::String, to::String, from::String)
    cfg = loadcfg()
    creds = Credentials(cfg["sid"], cfg["token"])
    return alert(body, to, from, creds)
end

function alert(body::String, to::String)
    cfg = loadcfg()
    if ! ("from" in keys(cfg))
        error("No 'from' key in config")
    end
    from = cfg["from"]
    return alert(body, to, from)
end

function alert(body::String)
    cfg = loadcfg()
    if ! ("to" in keys(cfg))
        error("No 'to' key in config")
    end
    to = cfg["to"]
    return alert(body, to)
end

end
