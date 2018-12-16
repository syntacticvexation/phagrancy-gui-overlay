# function from https://stackoverflow.com/questions/6832596/how-to-compare-software-version-number-using-js-only-number
compareVersions = (v1, v2) ->
  v1Parts = v1.version.split('.')
  v2Parts = v2.version.split('.')
  minLength = Math.min(v1Parts.length, v2Parts.length)
  if minLength > 0
    for idx in [0..minLength - 1]
      diff = Number(v1Parts[idx]) - Number(v2Parts[idx])
      return diff unless diff is 0
  return v1Parts.length - v2Parts.length

compareProviders = (p1, p2) ->
  p1.name > p2.name

tree_params = 
  'plugins': ['contextmenu']
  "contextmenu":        
    "items": (node) ->
      tree = $("#vagrancy-tree").jstree true

      # disabled = (node.text != "virtualbox")
      if node.text == "virtualbox"
        "Delete":
          "separator_before": false,
          "separator_after": false,
          "label": "Delete",
          shortcut: 46,
          shortcut_label: 'Del'
          "action": (item) ->
            alert node.id
            $.ajax "/api/v1/box/#{node.id}",
              type: 'DELETE'
            tree.refresh()
  'core':
    'check_callback': true,
    'data': (node, cb) -> 
      if node.id == "#"
        # get box list
        $.getJSON "/scopes", (data) ->
          nodes = $.map(data.sort(), (elem) -> 'id': elem, 'text': elem, 'children': true)
          cb.call this, nodes
      else if node.parent == '#'
        $.getJSON "/#{node.text}", (data) ->
          nodes = $.map(data.boxes.sort(), (elem) -> 
            'id': "#{node.text}/#{elem}",
            'text': elem,
            'children': true)
          cb.call this, nodes
      else
        $.getJSON "/#{node.parent}/#{node.text}", (data) ->
          nodes = $.map(data.versions.sort(compareVersions), (elem) ->
            'id': "#{node.parent}/#{node.text}/#{elem.version}",
            'text': elem.version,
            'children': $.map(elem.providers.sort(compareProviders), (provider) ->
               'id': "#{node.parent}/#{node.text}/version/#{elem.version}/provider/#{provider.name}"
               'text': provider.name))
          cb.call this, nodes
  'themes':
    'name': 'proton',
    'responsive': true

$('#vagrancy-tree').jstree tree_params
