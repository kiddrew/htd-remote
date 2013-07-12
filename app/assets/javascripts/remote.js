htdnet_url = '/htdnet'

$(function() {
  var interval_id;

  $(".zone-tab").click( function() {
    var id = $(this).attr('data-id');
    setZoneStatus(id);
    clearInterval(interval_id);
    interval_id = setInterval( function() {
      setZoneStatus(id);
    }, 10000);
  })

  $(".volume-up").click( function() {
    var zone_id = $(this).closest(".zone-panel").attr("data-id");
    var current_volume = parseInt($(this).closest(".zone-panel").find(".zone-volume").html());
    if(current_volume >= 60) {
      return;
    }
    incrementZoneVolume(zone_id)
  })

  $(".volume-down").click( function() {
    var zone_id = $(this).closest(".zone-panel").attr("data-id");
    var current_volume = parseInt($(this).closest(".zone-panel").find(".zone-volume").html());
    if(current_volume <= 0) {
      return;
    }
    decrementZoneVolume(zone_id)
  })

  $(".enabled-true").click( function() {
    var zone_id = $(this).closest(".zone-panel").attr("data-id");
    enableZone(zone_id);
  })

  $(".enabled-false").click( function() {
    var zone_id = $(this).closest(".zone-panel").attr("data-id");
    disableZone(zone_id);
  })

  $(".mute").click( function() {
    var zone_id = $(this).closest(".zone-panel").attr("data-id");
    alert($("#zone-tab-"+zone_id+" .mute").val());
  })

  $("#zone-tab-1").trigger("click");
  setZoneStatus(2);
  setZoneStatus(3);
  setZoneStatus(4);
  setZoneStatus(5);
  setZoneStatus(6);
})

function enableZone(id) {
  $.ajax({
    url: htdnet_url+'/zones/'+id+'/enable.json',
    type: 'POST'
  })
}

function disableZone(id) {
  $.ajax({
    url: htdnet_url+'/zones/'+id+'/disable.json',
    type: 'POST'
  })
}

function getZoneVolume(id) {
  return parseInt($("#zone-panel-"+id+" .zone-volume").html());
}

function decrementZoneVolume(id) {
  return updateZoneVolume(id, getZoneVolume(id)-1);
}

function incrementZoneVolume(id) {
  return updateZoneVolume(id, getZoneVolume(id)+1);
}

function updateZoneVolume(id, volume) {
  setZoneVolumeDisplay(id, volume);
  $.ajax({
    url: htdnet_url+'/zones/'+id+'/set_volume.json',
    type: 'POST',
    data: {volume: volume},
    success: function(data) {
    },
    error: function() {
    }
  })
}

function setZoneVolumeDisplay(id, val) {
  $("#zone-panel-"+id+" .zone-volume").html(val);
}

function setZoneLabelDisplay(id, val) {
  $("#zone-panel-"+id+" .zone-label").html(val);
}

function setZoneEnabledDisplay(id, val) {
  if(val) {
    $("#zone-panel-"+id+" .enabled-true").addClass('active');
    $("#zone-panel-"+id+" .enabled-false").removeClass('active');
  } else {
    $("#zone-panel-"+id+" .enabled-false").addClass('active');
    $("#zone-panel-"+id+" .enabled-true").removeClass('active');
  }
}

function setZoneMutedDisplay(id, val) {
  btn = $("#zone-panel-"+id+" .muted");
  if(val) {
    btn.addClass('active');
  } else {
    btn.removeClass('active');
  }
}

function setZoneLabelsFromJson(json) {
  for(var i=0; i<6; i++) {
    var label = json[i]['label'];
    $("#zone-tab-"+(i+1)).html(label);
  }
}

function setZoneStatus(id) {
  $.ajax({
    url: htdnet_url+'/zones/'+id+'.json',
    dataType: 'json',
    success: function(data) {
      setZoneLabelDisplay(id, data['keypad']['label']);
      setZoneVolumeDisplay(id, data['keypad']['volume']);
      setZoneEnabledDisplay(id, data['keypad']['enabled']);
      setZoneMutedDisplay(id, data['keypad']['muted']);

      setZoneLabelsFromJson(data['zones']);
    }
  })
}


