function onLoad(e) {
    var d = new Date();
    var d2 = new Date();
    if ($(this).find(".clientFormattedDate").length > 0) {
        $(this).find(".clientFormattedDate").each(function () {
            var $cell = $(this);
            //   var formattedDate = new Date($cell.text());
            var formattedDate = new Date($cell.text() + ' MST').toLocaleString();
            //    formattedDate.setHours(d.getHours() - 2); 
            if (formattedDate != 'Invalid Date')
                $cell.text(formattedDate);
        });
    }
    $(this).find(".clientFormattedDate1").each(function () {
        var $cell = $(this);
      // var formattedDate = new Date($cell.text());
        var formattedDate = new Date($cell.text() + ' MST').toLocaleString();
        if (formattedDate != 'Invalid Date')
            $cell.text(formattedDate);
    });
}
