var AmvProducts = ( function() {
    var logging_enabled = false;


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

        log("AmvProdutcs has been initiated")
    }

    return {
        'init' : init,
        'enable_logging' : enable_logging
    };
})();


AmvProducts.enable_logging();
AmvProducts.init();

