// vim: ts=2 sw=2 expandtab:
//// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


$(document).ready(function()
{
  $('.commenttitle').each(function(){
    $(this).click(function(){
      if($(this).hasClass('closed')){
        $(this).parent().find("ul").eq(0).slideDown(400);
        $(this).removeClass('closed');
      }else{
        $(this).parent().find("ul").eq(0).slideUp(400);
        $(this).addClass('closed');
      }
      return false;
    });
  });
});
