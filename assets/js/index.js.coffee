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
          nodes = $.map(data, (elem) -> 'id': elem, 'text': elem, 'children': true)
          cb.call this, nodes
      else if node.parent == '#'
        $.getJSON "/#{node.text}", (data) ->
          nodes = $.map(data.boxes, (elem) -> 
            'id': "#{node.text}/#{elem}",
            'text': elem,
            'children': true)
          cb.call this, nodes
      else
        $.getJSON "/#{node.parent}/#{node.text}", (data) ->
          nodes = $.map(data.versions, (elem) ->
            'id': "#{node.parent}/#{node.text}/#{elem.version}",
            'text': elem.version,
            'children': $.map(elem.providers, (provider) ->
               'id': "#{node.parent}/#{node.text}/version/#{elem.version}/provider/#{provider.name}"
               'text': provider.name))
          cb.call this, nodes
  'themes':
    'name': 'proton',
    'responsive': true

$('#vagrancy-tree').jstree tree_params
