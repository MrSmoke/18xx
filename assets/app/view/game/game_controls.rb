# frozen_string_literal: true

require 'game_manager'

module View
    module Game
        class GameControls < Snabberb::Component
            include Actionable
            include GameManager
            
            needs :game, store: true
            needs :user
            needs :confirm_endgame, store: true, default: false

            def render
                @settings = Lib::Storage[@game.id] || {}

                children = [master_mode]
                children << end_game unless @game.finished

                h(:div, [
                    h(:h3, 'Game Controls'),
                    *children,
                  ])
            end

            def master_mode
                mode = @settings[:master_mode] || false
                toggle = lambda do
                  Lib::Storage[@game.id] = @settings.merge('master_mode' => !mode)
                  update
                end
        
                h('div.margined', [
                  h(:button, { on: { click: toggle } }, "Master Mode #{mode ? '✅' : '❌'}"),
                  h(:label, "#{mode ? 'You can' : 'Enable to'} move for others"),
                ])
            end

            def end_game
                end_game =
                  if @confirm_endgame
                    confirm = lambda do
                      store(:confirm_endgame, false)
                      player = @game.players.find { |p| p.name == @user&.dig('name') }
                      process_action(Engine::Action::EndGame.new(player || @game.current_entity))
                      # Go to main page
                      store(:app_route, @app_route.split('#').first)
                    end
                    [
                      h(:button, { on: { click: -> { store(:confirm_endgame, false) } }, style: { width: '7rem' } }, 'Cancel'),
                      h(:button, { on: { click: confirm } }, 'Confirm End Game'),
                    ]
                  else
                    [
                      h(:button, { on: { click: -> { store(:confirm_endgame, true) } }, style: { width: '7rem' } }, 'End Game'),
                    ]
                  end
        
                h('div.margined', end_game)
            end

        end
    end
end