using Twilert
using Base.Test
using JSON

cfgfile = open(dirname(@__FILE__) * "/../.twilertrc", "r")
cfg = JSON.parse(cfgfile)
close(cfgfile)

const sid = cfg["sid"]
const token = cfg["token"]
const to = cfg["to"]
const from = cfg["from"]

const to_invalid = "+15005550001"
const from_invalid = "+15005550001"

@test Twilert.alert("Test message") == :ok
@test Twilert.alert("Test message", to) == :ok
@test Twilert.alert("Test message", to, from) == :ok

@test Twilert.alert("Test message", to_invalid) == :error
@test Twilert.alert("Test message", to, from_invalid) == :error
