   /* Magic Mirror Config Sample
 *
 * By Michael Teeuw http://michaelteeuw.nl
 * MIT Licensed.
 */

var config = {
        port: 8080,
        ipWhitelist: [], // Set [] to allow all IP addresses.                       

        language: "en",
        timeFormat: 24,
        units: "metric",

        modules: [
                {
                        module: "clock",
                        position: "top_left"
                }

        ]

};

/*************** DO NOT EDIT THE LINE BELOW ***************/
if (typeof module !== "undefined") {module.exports = config;}


