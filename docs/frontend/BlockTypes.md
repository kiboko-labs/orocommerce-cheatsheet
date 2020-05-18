BlockTypes
=====================================

Some usage examples
----------------

```
layout:
    actions:
        - '@add':
            id: style_calendar
            parentId: head_style
            blockType: style
            options:
                src: 'js/calendar/calendar.css'
        - '@add':
            id: script_prototype
            parentId: head_script
            blockType: script
            options:
                src: 'js/prototype/prototype.js'
                
        - '@add':
            id: meta_description
            parentId: head
            blockType: meta
            options:
                name: 'description'
                content: '=data["product"].getDescription()'
            siblingId: meta
            
        - '@add':
            id : logo
            blockType: link
            options:
                image: logo.png
                path: /
                attr:
                    class: logo
                vars:
                    image_class: large
                    image_alt: Madison Island
            siblingId: navigation
            prepend: true
            
        - '@add':
            id : breadcrumbs_product
            parentId: breadcrumbs
            blockType: text
            options:
                text: '=data["product"].getName()'
    
```



Commands
----------------

To have a list of block type :

`bin/console debug:container --show-private --tag layout.block_type`

And to have the data providers :

`bin/console debug:container --show-private --tag layout.data_provider`
