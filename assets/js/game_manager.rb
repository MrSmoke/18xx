# frozen_string_literal: true

require 'api'
require 'lib/request'
require 'lib/storage'

module GameManager
  include Api

  def self.included(base)
    base.needs :game_data, default: nil, store: true
    base.needs :games, default: [], store: true
    base.needs :app_route, default: nil, store: true
    base.needs :flash_opts, default: {}, store: true
  end

  def create_game(params)
    safe_post('/game', params) do |data|
      store(:games, [data] + @games)
    end
  end

  def delete_game(game)
    safe_post('/game/delete', game) do |data|
      store(:games, @games.reject { |g| g['id'] == data['id'] })
    end
  end

  def join_game(game)
    safe_post('/game/join', game) do |data|
      update_game(data)
    end
  end

  def leave_game(game)
    safe_post('/game/leave', game) do |data|
      update_game(data)
    end
  end

  def start_game(game)
    safe_post('/game/start', game) do |data|
      update_game(data)
    end
  end

  def enter_game(game)
    url = "/game/#{game['id']}"
    safe_post(url) do |data|
      store(:game_data, data, skip: true)
      store(:app_route, url)
    end
  end

  private

  def update_game(game)
    store(:games, @games.map { |g| g['id'] == game['id'] ? game : g })
  end
end
