class Htdnet::ZonesController < ApplicationController
  include Htdnet::HtdnetClient

  public
  def show
    id = params[:id]
    
    info = get_detail_for_zone id

    respond_to do |f|
      f.json {
        render :layout => false, :json => info.to_json
      }
    end
  end

  def set_volume
    logger.debug(params)
    id = params[:id]
    volume = params[:volume]

    set_zone_volume(id, volume)

    respond_ok
  end

  def enable
    enable_zone params[:id]

    respond_ok
  end
  
  def disable
    disable_zone params[:id]

    respond_ok
  end

  def mute
  end

  def unmute
  end

  def set_source(id, srcid)
    return set_zone_source(id, srcid)
  end

  private 
  def respond_ok
    respond_to do |f|
      f.json {
        render :layout => false, :json => {:result => 'ok'}.to_json
      }
    end
  end

end
