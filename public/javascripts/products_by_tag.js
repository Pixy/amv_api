var AmvProducts = ( function() {
    var logging_enabled = false;
    var server_url = "http://amv-api.dev"     //without the ending '/ '
   // var server_url = "http://amv-api.herokuapp.com"     //without the ending '/ '


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


    function get_products(widget){

        inputs = widget.select(".input .q")

        if (inputs.length == 0) {
           log("no input found")
        } else if (inputs.length == 1)   {
            input = inputs.first()
            q = input.innerHTML;
            if (input.hasClassName("by-tag")) {
                url = server_url +  "/products/by_tag"
                fetch_products_from_remote(url, widget)
            } else if (input.hasClassName("by-skus")) {
                url = server_url +  "/products/by_skus"
                fetch_products_from_remote(url, widget)
            } else {
                log("unable to detect the input type")
            }
        } else {
            log("multiple inputs found")
        }

    }


    function  fetch_products_from_remote(url, widget) {

        new Ajax.Request( url , {
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
                }

                log("search with " + JSON.stringify(transport.request.parameters) + " returned " + transport.responseJSON.length + " results")

            }
        })
    }

    function init() {

        document.observe("dom:loaded", function() {
            widgets  = $$('.amv-products');

            if (widgets){
                widgets.each(get_products);
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

