class Htdnet::KeypadsController < ApplicationController
  include Htdnet::HtdnetClient
  include Htdnet::HtdnetParser

  def show
    html = get_keypad_html

    respond_to do |f|
      f.jsonr { 
        render :layout => false, :json => { 
          :status => :ok,
          :zones => [
          ]
        }.to_json
      }
    end
  end
end
