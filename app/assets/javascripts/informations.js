/**
 * Created by ss on 03.03.17.
 */

$("body").addClass("nohover");
$("td, th").attr("tabindex", "1").on("touchstart", function() {
  $(this).focus();
});

$(document).ready(function () {
  $('.table thead tr th').on('click', function () {
    let gene_id = $(this).html();

    console.log(gene_id);
    // $.ajax({
    //   type: 'post',
    //   data: { information: { gene: gene_id } },
    //   url: gon.global.information_show_path,
    //   dataType: 'html'
    // })
  });
});
