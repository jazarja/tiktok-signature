TikTok Signature API
--------------------

TikTok signed request signature calculator API.

e.g: 

Trending Url: https://www.tiktok.com/share/item/list?secUid=&id=&type=5&count=30&minCursor=0&maxCursor=0&shareUid=&lang=en

to be successfully send that request, we must calculate 'request signature' and append it to 'signature' field.

https://www.tiktok.com/share/item/list?secUid=&id=&type=5&count=30&minCursor=0&maxCursor=0&shareUid=&lang=en&signature=SIGNATURE_HERE

Based on: https://github.com/carcabot/tiktok-signature/

## Installation

1. Clone this repository
2. Install Docker (if needed)
3. Build docker image
```bash
docker build -t tiktok-signature .
```
4. Run docker
```bash
docker run -p 9999:8080 -d tiktok-signature
```

## API

```bash
curl --location --request POST 'http://IP_SERVER:9999/sign' \
--header 'Content-Type: application/javascript' \
--data-raw '{
	"url" : "https://m.tiktok.com/share/item/list?secUid=&id=&type=5&count=30&minCursor=0&maxCursor=0&shareUid="
}'
```

## NodeJs
```
const rp = require('request-promise');

const calculateSignature =  async (url) => {
    let options = {
        uri: `${process.env.TIKTOK_SIGNATURE_ENDPOINT || "http://IP_SERVER:9999/sign"}`,
        method: 'POST',
        body: {
            url : url
        },
        json:true,
        gzip: true,
    };

    return await rp(options);
};
```
## Note

It's very important that the userAgent be the same when generate and when request for response.
("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36")

---

