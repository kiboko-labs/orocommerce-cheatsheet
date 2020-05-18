List of Ui element present in OroUIBundle::macros.html.twig
=====================================

Buttons
----------------

- button(parameters)
- dropdownButton(parameters)
- dropdownItem(parameters)
- pinnedDropdownButton(parameters)
- dropdownSaveButton(parameters)
- cancelButton(path, label)
- editButton(parameters)
- addButton(parameters)
- deleteButton(parameters)
- deleteLink(parameters)
- clientLink(parameters)
- clientButton(parameters)
- ajaxButton(parameters)
- dropdownClientItem(parameters)
- saveAndCloseButton(parametersOrLabel)
- saveAndStayButton(parametersOrLabel)
- saveAndNewButton(parameters)
- saveActionButton(parameters)
- buttonType(parameters)
- buttonSeparator()

Others
----------------
- collection_prototype(widget)
- tooltip(tooltip_raw, tooltip_parameters, tooltip_placement, details_enabled, details_link, details_anchor)
- attibuteRow(title, value, additionalData)

<details><summary>Details</summary>
<p>

    Render attribute row
           Parameters:
               title - attribute title
               value - attribute value
               additionalData - array with additional data")
</p>
</details>


 - renderAttribute(title, data, options)
 
 <details><summary>Details</summary>
 <p>
 
    Render attribute row
    Parameters:
        title - attribute title
        value - attribute value
        additionalData - array with additional data
 </p>
 </details>
       

- renderControlGroup(title, data)

 <details><summary>Details</summary>
 <p>
 
    Render attribute row with custom data block
    Parameters:
        title - row title
        data - row data
 </p>
 </details>
 
 - renderProperty(title, data, entity = null, fieldName = null, options = {})
 
  <details><summary>Details</summary>
  <p>
  
    Render property block
    Parameters:
        title - property title
        data  - property data
        entity - the entitty instance on wich Field ACL should be checked
        fieldName - the name of field on wich Field ACL should be checked
        options - addtional options for property
  </p>
  </details>
 
 - renderHtmlProperty(title, data, entity = null, fieldName = null, options = {})
 
 - renderPropertyControlGroup(title, data, entity = null, fieldName = null)
 
 - renderHtmlPropertyControlGroup(title, data, entity = null, fieldName = null)
 
 - renderCollapsibleHtmlProperty(title, data, entity, fieldName, moreText = 'Show more', lessText = 'Show less')
 
 - renderSwitchableHtmlProperty(title, data)
 
 - renderColorProperty(title, data, empty)
 
 - link(parameters)
 
 - renderPageComponentAttributes(pageComponent)
 
 - renderWidgetAttributes(options)
 
 - renderWidgetDataAttributes(options)
 
 - renderAttributes(options, prefix)
 
 - ajaxLink(parameters)
 - scrollSubblock(title, data, isForm, useSpan, spanClass)
 - scrollBlock(blockId, title, subblocks, isForm, contentAttributes, useSubBlockDivider, headerLinkContent = '')
 - scrollData(dataTarget, data, entity, form = null)
 - collectionField(field, label, buttonCaption, tooltipText = null)
 - attributes(attr, excludes)
 - entityOwnerLink(entity, renderLabel = true)
 - renderUrl(url, text, class, title, attributes)
 - renderUrlWithActions(parameters, entity)
 - renderPhone(phone, title)
 - renderPhoneWithActions(phone, entity)
 - getApplicableForUnderscore(str)
 - renderList(elements)
 - renderTable(titles, rows, style)
 - entityViewLink(entity, label, route, permission)
 - entityViewLinks(entities, labelProperty, route, permission)
 - renderDisabledLabel(labelText)
 - renderEntityViewLabel(entity, fieldName, entityLabelIfNotGranted = null
 - renderJsTree(data, actions)
 - app_logo(organization_name)
 - insertIcon(classNames)