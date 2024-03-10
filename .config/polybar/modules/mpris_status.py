#!/usr/bin/env python3

import sys

import gi
gi.require_version('Playerctl', '2.0')
from gi.repository import Playerctl, GLib

manager = Playerctl.PlayerManager()

playing = False

def on_metadata(player, *_):
    if player.props.status == "Stopped":
        return
    metadata = player.props.metadata
    keys = metadata.keys()
    playing = player.props.status == "Playing"
    if 'xesam:artist' in keys and 'xesam:title' in keys:
        artist = metadata['xesam:artist'][0]
        title = metadata['xesam:title']
        if len(title) > 30:
            title = title[:30] + "…"
        status = '{}{} - {}%{{u-}}'.format("%{u#eba0ac}%{+u}" if playing else "",
                                        artist,
                                        title)
        print(status, flush=True)

def player_prio(p):
    match p.props.status:
        case "Playing":
            return 3
        case "Paused":
            return 2
        case "Stopped":
            return 1
        case _:
            return 0

def init_player(name):
    # choose if you want to manage the player based on the name
    player = Playerctl.Player.new_from_name(name)
    player.connect('playback-status::playing', on_metadata, manager)
    player.connect('playback-status::paused', on_metadata, manager)
    player.connect('playback-status::stopped', on_player_vanished, manager)
    player.connect('metadata', on_metadata, manager)
    manager.manage_player(player)
    for player in sorted(manager.props.players, key = player_prio):
        on_metadata(player)


def on_name_appeared(_, name):
    init_player(name)

def on_player_vanished(*_):
    print(flush=True)
    for player in manager.props.players:
        on_metadata(player)


manager.connect('name-appeared', on_name_appeared)
manager.connect('player-vanished', on_player_vanished)

for name in manager.props.player_names:
    init_player(name)

main = GLib.MainLoop()
main.run()
