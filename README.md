## Twilert.jl

### Introduction

Twilert is a small, simple library for sending SMS alerts using the Twilio
(https://www.twilio.com/) API. The idea is that you can integrate it into
long-running code to let you know when a job is finished, when an error occurs,
or when user intervention is required.

I was inspired by some of my own experiences running simulations. My code would
need to run for 5-30 minutes, too long to sit and stare at it, but too short to
go home and check in the next day. My solution at the time was to kick things
off with a shell script and using a text-to-speech app to alert me when things
were finished (or when everything had exploded). This worked fine as long as I
stayed in the room, but sometimes I like to wander around, thus Twilert.

### Usage

Using Twilert is dead simple:

    julia> using Twilert

    julia> Twilert.alert("All done!")

This assumes you have created a text file in JSON format in either your home
directory or the current working directory with the following keys:

  * `sid` - your user account SID on Twilio
  * `token` - your account token on Twilio
  * `to` - the phone number you want to message
  * `from` - the Twilio phone number to use for sending the message

See the `example.jl` file in the `test` directory for some example usage.
