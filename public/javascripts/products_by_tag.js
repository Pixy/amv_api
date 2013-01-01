var AmvProducts = ( function() {
    var logging_enabled = false;
    //var server_url = "http://amv-api.dev/"


    function enable_logging(){
        logging_enabled = true;
        log("logging has been enabled")
    }

    function log(message) {
        if (logging_enabled) {
            console.log(message)
        }
    }

    function init() {


        document.observe("dom:loaded", function() {
            elements  = $$('.products-by-tag');

            if (elements){
                elements.each( function(element) {
                     q = element.select(".input .q").first().innerHTML;
                     element.select(".products").first().update(q);

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

