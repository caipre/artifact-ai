defmodule Box do
  # https://gist.github.com/teamon/b90a2ddca4965848559a96aff49ed9bb/
  @moduledoc false

  defmacro __using__(_env) do
    quote do
      import Box
    end
  end

  @doc """
  Define module with struct and typespec, in single line
  Example:
      use Box
      defbox User,  id:   integer,
                    name: String.t
  is the same as
      defmodule User do
        @type t :: %__MODULE__{
          id:   integer,
          name: String.t
        }
        @enforce_keys [:id, :name]
        defstruct [:id, :name]
      end
  """
  defmacro defbox(name, attrs \\ []) do
    keys = Keyword.keys(attrs)

    quote do
      defmodule unquote(name) do
        @enforce_keys unquote(keys)
        defstruct unquote(keys)

        @type t :: %__MODULE__{
                unquote_splicing(attrs)
              }
      end
    end
  end
end
