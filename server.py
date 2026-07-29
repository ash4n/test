import http.server
import os

class NoIndexHandler(http.server.SimpleHTTPRequestHandler):
    def list_directory(self, path):
        self.send_error(403, "Directory listing forbidden")

class NoCacheHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def send_response_only(self, code, message=None):
        super().send_response_only(code, message)
        # Запрещаем браузеру кэшировать файлы
        self.send_header('Cache-Control', 'no-store, must-revalidate')
        self.send_header('Expires', '0')
if __name__ == "__main__":
    os.chdir(r"C:\Users\1\Desktop\coruna-duy-decompile")
    server = http.server.HTTPServer(("0.0.0.0", 80), NoIndexHandler, NoCacheHTTPRequestHandler)
    print("Serving on port 80 (no directory listing)...")
    server.serve_forever()