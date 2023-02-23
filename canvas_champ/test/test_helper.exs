alias CanvasChamp.HttpClient

Hammox.defmock(HttpClientMock, for: HttpClient)
Application.put_env(:canvas_champ, HttpClient, HttpClientMock)

ExUnit.start()
