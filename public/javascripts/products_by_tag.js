var AmvProducts = ( function() {
    var logging_enabled = false;
    var server_url = "http://amv-api.herokuapp.com"     //without the ending '/ '


    function enable_logging(){
        logging_enabled = true;
        log("logging has been enabled")
    }

    function log(message) {
        if (logging_enabled) {
            console.log(message)
        }
    }

    function show_spinner(widget)  {
        var spinner =  new Element('img', {class: 'spinner', src: (server_url+'/images/ajax-loader.gif') })
        widget.select(".products").first().update(spinner)
    }

    function init() {

        document.observe("dom:loaded", function() {
            widgets  = $$('.products-by-tag');

            if (widgets){
                widgets.each( function(widget) {
                     q = widget.select(".input .q").first().innerHTML;


                    new Ajax.Request( server_url + "/products/by_tag" , {
                        parameters: {q: q},
                        onLoading: function(transport) {
                            show_spinner(widget)
                        },

                        onFailure: function(transport) {
                            widget.hide();
                        },

                        onSuccess: function(transport) {

                            if (transport.responseJSON.length == 0) {
                                widget.hide();
                            } else {

                                widget.select(".products").first().update(JSON.stringify(transport.responseJSON));
                                log("search with " + JSON.stringify(transport.request.parameters) + " returned " + transport.responseJSON.length + " results")

                            }

                        }
                    })


                });
            }

            log("AmvProdutcs has been initiated")
        });

    }

    return {
        'init' : init,
        'enable_logging' : enable_logging
    };
})();


AmvProducts.enable_logging();
AmvProducts.init();

