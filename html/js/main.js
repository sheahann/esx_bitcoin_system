$(document).ready(function() {
    $(document).on("click", "#check", function() {
        if ($(this).prop("checked") == true) {
            $("#test").fadeIn();
        } else {
            $("#test").fadeOut();
        }
    })
});

$(function() {
    function display(bool) {
        if (bool) {
            $("#main").slideDown();
        } else {
            $("#main").slideUp();
        }
    }

    function luaAction(type, value) {
        $.post('http://esx_bitcoin/esx_bitcoin:jsAction', JSON.stringify({ type: type, value: value }));
    }

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.enable == true) {
            display(true)
            $("#status span").text(item.bitcoin + 'B');
            $("#status_id span").text(item.id);
        } else {
            display(false)
        }
    })

    // Custom values

    $(".customBuy").click(function() {
        var data = $(".custom-input").val();
        luaAction('buy', data)
    })

    $(".customSell").click(function() {
        var data = $(".custom-input").val();
        luaAction('sell', data)
    })

    // Absolute values

    $(".100Buy").click(function() {
        luaAction('buy', 0.01)
    })

    $(".100Sell").click(function() {
        luaAction('sell', 0.01)
    })



    $(".500Buy").click(function() {
        luaAction('buy', 0.05)
    })

    $(".500Sell").click(function() {
        luaAction('sell', 0.05)
    })



    $(".1000Buy").click(function() {
        luaAction('buy', 0.1)
    })

    $(".1000Sell").click(function() {
        luaAction('sell', 0.1)
    })



    $(".2000Buy").click(function() {
        luaAction('buy', 0.2)
    })

    $(".2000Sell").click(function() {
        luaAction('sell', 0.2)
    })

    document.onkeyup = function(data) {
        if (data.which == 27) {
            $.post('http://esx_bitcoin/close', JSON.stringify({}));
            return
        }
    };
});