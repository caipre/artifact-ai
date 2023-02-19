defmodule ArtifactAiWeb.AuthController do
  use ArtifactAiWeb, :controller

  alias ArtifactAi.Accounts
  alias ArtifactAiWeb.UserAuth

  plug Ueberauth

  @rand_password_length 32

  @doc """
  Handles authentication from an oauth provider.
    https://hexdocs.pm/ueberauth/Ueberauth.Auth.html
  """
  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    %{credentials: %{token: token}, info: %{email: email, image: image}, provider: provider} =
      auth

    case Accounts.get_user_by_email(email) do
      nil ->
        case Accounts.register_user(%{
               email: email,
               password: gen_rand_password()
             }) do
          {:ok, user} ->
            UserAuth.log_in_user(conn, user)

          {:error, error} ->
            conn
            |> put_flash(:error, "Authentication failed: #{error}")
            |> redirect(to: ~p"/")
        end

      user ->
        UserAuth.log_in_user(conn, user)
    end
  end

  @doc """
  Handles authentication failure.
    https://hexdocs.pm/ueberauth/Ueberauth.Failure.html
  """
  def callback(%{assigns: %{ueberauth_failure: failure}} = conn, _params) do
    %{errors: [%{message: message}]} = failure

    conn
    |> put_flash(:error, "Authentication failed: #{message}.")
    |> redirect(to: ~p"/")
  end

  defp gen_rand_password() do
    :crypto.strong_rand_bytes(@rand_password_length)
    |> Base.encode64()
  end
end
