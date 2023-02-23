alias CanvasChamp.HttpClient

Hammox.defmock(HttpClientImplMock, for: HttpClient)
Application.put_env(:canvas_champ, HttpClient, HttpClientImplMock)

ExUnit.start()
