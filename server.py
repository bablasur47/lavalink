import os, json, socket, subprocess, threading, time

PORT = int(os.environ.get("PORT", 10000))
LAVALINK_PORT = 10001

subprocess.Popen(["java", "-jar", "/opt/Lavalink/Lavalink.jar"])

time.sleep(5)

HTML = b"""<!DOCTYPE html><html><head><title>Lavalink</title><style>body{background:#0d1117;color:#c9d1d9;font-family:sans-serif;display:flex;justify-content:center;align-items:center;min-height:100vh;margin:0}.c{text-align:center;padding:40px}h1{color:#58a6ff}.s{color:#3fb950}</style></head><body><div class="c"><h1>Lavalink</h1><p class="s">Server Active</p><p style="color:#8b949e;font-size:13px">Auto-ping enabled</p></div></body></html>"""

def handle(c):
    try:
        d = c.recv(4096)
        if not d: c.close(); return
        if d.startswith(b"GET / ") or d.startswith(b"GET /health "):
            c.sendall(b"HTTP/1.1 200 OK\r\nContent-Length: 2\r\nConnection: close\r\n\r\nOK")
            c.close(); return
        l = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        l.settimeout(30)
        try: l.connect(("127.0.0.1", LAVALINK_PORT)); l.sendall(d)
        except: c.close(); l.close(); return
        c.settimeout(30)
        def f(s, d):
            try:
                while True:
                    b = s.recv(4096)
                    if not b: break
                    d.sendall(b)
            except: pass
            finally:
                for x in (s, d):
                    try: x.close()
                    except: pass
        t1 = threading.Thread(target=f, args=(l, c), daemon=True)
        t2 = threading.Thread(target=f, args=(c, l), daemon=True)
        t1.start(); t2.start(); t1.join()
    except:
        try: c.close()
        except: pass

def ping():
    while True:
        try:
            ur = os.environ.get("RENDER_EXTERNAL_URL", f"http://127.0.0.1:{PORT}")
            import urllib.request
            urllib.request.urlopen(f"{ur}/health", timeout=10)
        except: pass
        time.sleep(240)

threading.Thread(target=ping, daemon=True).start()

s = socket.socket()
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
s.bind(("0.0.0.0", PORT))
s.listen(100)
print(f"Server on {PORT}")

while True:
    c, _ = s.accept()
    threading.Thread(target=handle, args=(c,), daemon=True).start()
