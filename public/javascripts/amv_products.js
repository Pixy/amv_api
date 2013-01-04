var AmvProducts = ( function() {
    var logging_enabled = false;
    //var server_url = "http://amv-api.dev"     //without the ending '/ '
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


    function get_products(widget){

        inputs = widget.select(".input .q")

        if (inputs.length == 0) {
           log("no input found")
        } else if (inputs.length == 1)   {
            input = inputs.first()
            q = input.innerHTML;
            if (input.hasClassName("by-tag")) {
                url = server_url +  "/products/by_tag"
                fetch_products_from_remote(url, q, widget)
            } else if (input.hasClassName("by-skus")) {
                url = server_url +  "/products/by_skus"
                fetch_products_from_remote(url, q, widget)
            } else {
                log("unable to detect the input type")
            }
        } else {
            log("multiple inputs found")
        }

    }


    function  fetch_products_from_remote(url, q, widget) {

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
                    var container = widget.select('.products').first();

                    // Adding new container and classes for the slide widget
                    container.update('<div class="ipl_widget sliding_panel"></div>');
                    pcontainer = container.down('.ipl_widget.sliding_panel');
                    pcontainer.update(JSON.stringify(transport.responseJSON));

                    // Call the update content function
                    updateContent(pcontainer, transport.responseJSON);
                }

                log("search with " + JSON.stringify(transport.request.parameters) + " returned " + transport.responseJSON.length + " results")

            }
        })
    }

    // Update the content of the widget with the JSON
    function updateContent(container, content) {
        var customContent = '';
        customContent = '<div class="module">'
        customContent += '<div class="bd"><div class="t"><h2> Boutique </h2></div>';
        customContent += '<div class="b">';
        customContent += '<ul class="widget-items">';
        for (var i = 0; i < content.length; i++) {
            customContent += '<li><div><a href="' + content[i].url + '"> <img src="' + content[i].visuel + '" /> </a></div>';
            customContent += '<div><h3>' + content[i].libelle + '</h3><p class="marque">' + content[i].marque + '</p></div>';
            customContent += '<div><p class="prix">' + content[i].prix + '</p></div></li>';
        }
        customContent += '</ul>';
        customContent += '<div class="sliding_panel_controls total_entries_'+ content.length +'"> <a class="previous" href="?" title="Précédent"><span>Précédent</span></a><a class="next" href="?" title="Suivant"><span>Suivant</span></a></div>';
        customContent += '</div></div>';
        customContent += '</div>'; // .module
        container.update(customContent);
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

