$(function() {
    $(document).on("click", "#check", function() {
        if ($(this).prop("checked") == true) {
            $("#test").fadeIn();
        } else {
            $("#test").fadeOut();
        }
    })

    function display(bool) {
        if (bool) {
            $("#main").slideDown();
        } else {
            $("#main").slideUp();
        }

        function luaAction(type, value) {
            $.post('http://esx_bitcoin/esx_bitcoin:jsAction', JSON.stringify({ type: type, value: value }));
        }

        window.addEventListener('message', function(event) {
            var item = event.data;
            if (item.enable == true) {
                display(true);
                $("#status span").text(item.bitcoin + 'B');
                $("#status_id span").text(item.id);
            } else {
                display(false);
            }
        })

        // Custom values

        $(".customBuy").click(function() {
            var data = $(".custom-input").val();
            luaAction('buy', data);
        })

        $(".customSell").click(function() {
            var data = $(".custom-input").val();
            luaAction('sell', data);
        })

        // Absolute values

        $(".Buy100").click(function() {
            luaAction('buy', 0.01);
        })

        $(".Sell100").click(function() {
            luaAction('sell', 0.01);
        })



        $(".Buy500").click(function() {
            luaAction('buy', 0.05);
        })

        $(".Sell500").click(function() {
            luaAction('sell', 0.05);
        })



        $(".Buy1000").click(function() {
            luaAction('buy', 0.1);
        })

        $(".Sell1000").click(function() {
            luaAction('sell', 0.1);
        })



        $(".Buy2000").click(function() {
            luaAction('buy', 0.2);
        })

        $(".Sell2000").click(function() {
            luaAction('sell', 0.2);
        })

        document.onkeyup = function(data) {
            if (data.which == 27) {
                $.post('http://esx_bitcoin/close', JSON.stringify({}));
            }
        };
    };
});
