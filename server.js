const Signer = require("./index");
const http = require("http");
const fs = require("fs");
const url = require('url');

(async function main() {
    try {
        const signer = new Signer();
        const tacToken = await signer.getTac();
        const jsCode = fs.readFileSync("./bytedcode.js").toString();

        if (tacToken) {
            console.log("tac loaded successfully");
        }

        let html = fs.readFileSync("./index.html", "utf8");

        http
            .createServer(async (request, response)  => {
                console.log("Incoming request", request.url);
                if (request.method === "POST" && request.url === "/sign")
                {
                    let data ="";
                    request.on('data', chunk => {
                        data += chunk;
                    });
                    request.on('end', async () => {
                        let payload = JSON.parse(data);

                        console.log("Payload", payload);
                        try {
                            const signer = new Signer();
                            await signer.init();
                            const token = await signer.sign(payload.url);
                            await signer.close();

                            response.writeHeader(200, {"Content-Type": "application/json"});
                            response.write(JSON.stringify({
                                "status": "success",
                                "rawUrl" : payload.url,
                                "signature" : token,
                                "signedUrl" : payload.url+"&signature="+token,
                            }));
                            response.end();
                        } catch (err) {
                            console.error(err);
                        }
                    });

                } else {
                    html = html.replace("<script>TACTOKEN</script>", tacToken);
                    html = html.replace("SIGNATURE_FUNCTION", jsCode);
                    response.writeHeader(200, {"Content-Type": "text/html"});
                    response.write(html);
                    response.end();
                }
            })
            .listen(8080, '0.0.0.0')
            .on("listening", function () {
                console.log("TikTok Signature server started");
            });

        await signer.close();
    } catch (err) {
        console.error(err);
    }
})();
