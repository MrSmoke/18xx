# frozen_string_literal: true

require 'game_manager'
require 'lib/storage'
require 'view/game/game_data'
require 'view/game/notepad'
require 'view/game/actionable'
require 'view/game/auto_router_settings'
require 'view/game/game_controls'

module View
  module Game
    class Tools < Snabberb::Component
      include GameManager

      needs :game, store: true
      needs :user

      def render
        h(:div, [
          h(Notepad),
          h(RenameHotseat),
          h(AutoRouterSettings),
          h(GameData, actions: @game.raw_actions.map(&:to_h)),
          h(GameControls, user: @user),
          *help_links,
        ])
      end

      def player_notification
        h('div.margined', [
          h(:label, 'Send any player a notification (via email/webhooks) by tagging them in game chat: @username'),
        ])
      end

      def help_links
        props = {
          attrs: {
            href: 'https://github.com/tobymao/18xx/wiki/Power-User-Features#hotkeys--shortcuts',
            title: 'Open wiki: hotkeys & shortcuts',
          },
        }

        [h(:h2, 'Help'), h(:a, props, 'Hotkeys & Shortcuts'), player_notification]
      end
    end
  end
end
