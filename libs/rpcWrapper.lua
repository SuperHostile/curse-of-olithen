discordRPC = require("libs/discordRPC")

function discordRPC.ready(userId, username, discriminator, avatar)
    print(string.format("Discord: ready (%s, %s, %s, %s)", userId, username, discriminator, avatar))
end

function discordRPC.disconnected(errorCode, message)
    print(string.format("Discord: disconnected (%d: %s)", errorCode, message))
end

function discordRPC.errored(errorCode, message)
    print(string.format("Discord: error (%d: %s)", errorCode, message))
end

function discordRPC.joinGame(joinSecret)
    print(string.format("Discord: join (%s)", joinSecret))
end

function discordRPC.spectateGame(spectateSecret)
    print(string.format("Discord: spectate (%s)", spectateSecret))
end

function discordRPC.joinRequest(userId, username, discriminator, avatar)
    print(string.format("Discord: join request (%s, %s, %s, %s)", userId, username, discriminator, avatar))
    discordRPC.respond(userId, "yes")
end

discordRPC.initialize("", true)

local now = os.time(os.date("*t"))
presence = {
  state = lang_get_url_translation("rpc.loading"),
  details = "",
  startTimestamp = now,
  largeImageKey = "pls"
}

nextPresenceUpdate = 0

function update_presence(place, biome)
  presence = {
    state = lang_get_url_translation("rpc.in_biome") .. lang_get_url_translation(biome),
    details = lang_get_url_translation("rpc.playing_as"),
    startTimestamp = presence.startTimestamp,
    largeImageKey = "pls"
  }
end

if USE_PRESENCE then
  discordRPC.updatePresence(presence)
end