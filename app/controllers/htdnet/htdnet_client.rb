require 'nokogiri'
require 'net/http'
require 'open-uri'

module Htdnet::HtdnetClient

  KEYPAD_URL = 'http://192.168.1.129/keypad.html'
  SETUP_URL = 'http://192.168.1.128/setup.html'

  public
  def get_detail_for_zone(id)
    html = get_zone_html(id)

    return {
      :zones => get_zones(html),
      :sources => get_sources(html),
      :keypad => {
        :label => get_keypad_label(html),
        :enabled => get_keypad_status(html),
        :volume => get_keypad_volume(html),
        :source => get_keypad_source(html),
        :muted => get_keypad_muted(html)
      }
    }
  end

  def get_detail_for_source(id)
  end

  def set_zone_volume(id, volume)
    return update_zone(id, {:VolDropDown => volume})
  end

  def enable_zone(id)
    return update_zone(id, {:BtnPwrOn => true})
  end

  def disable_zone(id)
    return update_zone id, {:BtnPwrOff => true}
  end

  def mute_zone(id)
  end

  def unmute_zone(id)
  end

  def set_zone_source(id, srcid)
    return update_zone(id, {:SrcDropDown => srcid})
  end

  private
  def get_zone_html(id)
    button_id = 'BtnZ'+id

    params = {
      button_id.to_sym => true
    }
    return post_keypad(params)
  end

  def get_keypad_html
    return Nokogiri::HTML(open(KEYPAD_URL))
  end

  def post_keypad(params)
    return Nokogiri::HTML(Net::HTTP.post_form(URI.parse(KEYPAD_URL), params).body)
  end

  def get_setup_html
    return Nokogiri::HTML(open(SETUP_URL))
  end

  def post_setup
    return Nokogiri::HTML(Net::HTTP.post_form(URI.parse(SETUP_URL), params).body)
  end

  def update_zone(id, params)
    params[:_cznum] = id.to_i - 1
    logger.debug(params)
    return post_keypad params
  end

  def update_source(id, params)
  end

  def get_zones(html)
    return [
      get_zone_info(html, 1),
      get_zone_info(html, 2),
      get_zone_info(html, 3),
      get_zone_info(html, 4),
      get_zone_info(html, 5),
      get_zone_info(html, 6)
    ]
  end

  def get_zone_info(html, id)
    node = html.at_css("input[name='BtnZ"+id.to_s+"']")

    return {
      :id => id,
      :label => node.attr('value'),
      :enabled => ['gon', 'ngo'].include?(node.parent.attr('class'))
    }
  end

  def get_sources(html)
    sources = Array.new

    html.css("select[name='SrcDropDown'] option").each do |d|
      sources.push d.text
    end

    return sources
  end

  def get_cznum(html)
    return html.at_css("input[name='_cznum']").attr('value')
  end

  def get_isgrp(html)
    return html.at_css("input[name='_isgrp']").attr('value')
  end

  def get_grpmsk(html)
    return html.at_css("input[name='_grpmsk']").attr('value')
  end

  def get_grpsrc(html)
    return html.at_css("input[name='_grpsrc']").attr('value')
  end

  def get_zsrc(html)
    return html.at_css("input[name='_zsrc']").attr('value')
  end

  def get_keypad_label(html)
    return html.at_css("label#LblZone").text
  end

  def get_keypad_muted(html)
    return (html.at_css("input[name='BtnMute'].mo") != nil)
  end

  def get_keypad_status(html)
    return (html.at_css("input[name='BtnPwrOn'].pon") != nil)
  end

  def get_keypad_source(html)
    return html.at_css("select[name='SrcDropDown'] option[@selected='selected']").attr('value')
  end

  def get_keypad_volume(html)
    return html.at_css("select[name='VolDropDown'] option[@selected='selected']").attr('value')
  end
end
