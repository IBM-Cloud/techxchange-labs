import os, datetime, hashlib, hmac, requests
from http.server import HTTPServer, BaseHTTPRequestHandler

# Env vars
AK = os.getenv("COS_ACCESS_KEY_ID")
SK = os.getenv("COS_SECRET_ACCESS_KEY")
BUCKET = os.getenv("COS_BUCKET_NAME")
OBJ = os.getenv("COS_OBJECT_KEY", "index.html")

if not all([AK, SK, BUCKET, OBJ]):
    raise EnvironmentError("Missing required environment variables.")

# COS config
HOST = "s3.direct.us-south.cloud-object-storage.appdomain.cloud"
ENDPOINT = "https://10.10.0.5"
REGION = "us-south"

# Signing helpers
def sign(key, msg): return hmac.new(key, msg.encode(), hashlib.sha256).digest()
def sig_key(k, date, region, svc):
    return sign(sign(sign(sign(("AWS4" + k).encode(), date), region), svc), "aws4_request")

# Timestamps
now = datetime.datetime.utcnow()
TS = now.strftime("%Y%m%dT%H%M%SZ")
DATE = now.strftime("%Y%m%d")

# Canonical request
RES = f"/{BUCKET}/{OBJ}"
HDRS = f"host:{HOST}\nx-amz-date:{TS}\n"
SIGNED = "host;x-amz-date"
HASH = hashlib.sha256(b"").hexdigest()
CANON = f"GET\n{RES}\n\n{HDRS}\n{SIGNED}\n{HASH}".encode()

# String-to-sign
SCOPE = f"{DATE}/{REGION}/s3/aws4_request"
STS = f"AWS4-HMAC-SHA256\n{TS}\n{SCOPE}\n{hashlib.sha256(CANON).hexdigest()}"

# Signature
SIG = hmac.new(sig_key(SK, DATE, REGION, "s3"), STS.encode(), hashlib.sha256).hexdigest()
AUTH = f"AWS4-HMAC-SHA256 Credential={AK}/{SCOPE}, SignedHeaders={SIGNED}, Signature={SIG}"

# Request
HDR = {"x-amz-date": TS, "Authorization": AUTH, "Host": HOST}
URL = ENDPOINT + RES

print("Fetching:", URL)
resp = requests.get(URL, headers=HDR, verify=False)
if resp.status_code != 200:
    raise Exception(f"Error {resp.status_code}: {resp.text}")
CONTENT = resp.text.encode()

# Web server
class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/":
            self.send_response(200)
            self.send_header("Content-type", "text/html")
            self.end_headers()
            self.wfile.write(CONTENT)
        else:
            self.send_response(404)
            self.end_headers()
            self.wfile.write(b"404 Not Found")

if __name__ == "__main__":
    print(f"Serving {OBJ} from {BUCKET} on port 8080...")
    HTTPServer(("", 8080), Handler).serve_forever()
