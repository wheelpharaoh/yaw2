"""
yaw
~~~~~~

The yaw package - Yet another webserver.
"""

from http.server import BaseHTTPRequestHandler
from urllib.parse import urlparse, parse_qs

from . import logger
log = logger.setup_applevel_logger()


class Routes(BaseHTTPRequestHandler):

    def do_get_html(self, msg: str) -> None:
        """
        Respond to an HTTP request with 200 status code & html content.


        Parameters
        ----------
        msg: str
            The desired http response body content 
        """
        self.send_response(200)
        self.send_header('Content-type','text/html')
        self.end_headers()
        self.wfile.write(bytes(msg, "UTF-8"))
        return

    def do_GET(self):
        query = urlparse(self.path).query
        params = parse_qs(query)

        log.debug('query={}'.format(query))
        log.debug('path={}'.format(self.path))

        if self.path == '/api/health':
            self.send_response(200)
        else:
            self.do_get_html('Hello World\n')
        return

def main():
    from http.server import HTTPServer

    httpd = HTTPServer(("", 8000), Routes)
    httpd.serve_forever()

if __name__ == "__main__":
    main()
