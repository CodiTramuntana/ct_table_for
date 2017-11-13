// Clickable table rows.
// Set the class 'table-clickable' in table and
// in tr set 'data-link' and (optional) 'data-target'
// in td set 'data-link-enabled' to false for disable in specicif cells
$('table.table-clickable').each(function(index, table){
  $(table).find('tbody tr').each(function(index, trow){
    $(trow).click(function(evnt){
      var link = $(this).attr('data-link');
      var linkTarget = $(this).attr('data-target');
      var linkEnabled = true
      if( $(evnt.target).attr('data-link-enabled') == 'false' ||
        $(evnt.target).parents('td[data-link-enabled="false"]').length > 0 ){
        linkEnabled= false
      }

      if( !linkTarget ){ linkTarget = '_self'; }
      if( link && linkEnabled){ window.open(link, linkTarget); }
    });
  });
});