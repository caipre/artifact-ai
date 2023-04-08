defmodule ArtifactAi.Emails do
  @moduledoc false
  import Swoosh.Email

  alias ArtifactAi.Accounts.User
  alias ArtifactAi.Orders.Order

  def send_confirmation_email(%User{} = user, %Order{} = order) do
    new()
    |> to(user.email)
    |> from({"ArtifactAi", "noreply@artifact-ai.fly.dev"})
    |> subject("ArtifactAi Order #{shortid(order.id)} Received")
    |> html_body(
      "<html><head><style>body { max-width: 500px; margin: 0 auto; }</style></head><body><h1>Order #{order.id}</h1></body>"
    )
    |> ArtifactAi.Mailer.deliver()
  end

  defp shortid(id), do: id |> String.split("-") |> List.first()
end
