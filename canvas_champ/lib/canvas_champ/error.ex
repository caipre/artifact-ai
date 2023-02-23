defmodule CanvasChamp.Error do
  @moduledoc false
  @type t :: %__MODULE__{message: String.t()}
  @enforce_keys [:message]
  defstruct [:message]
end
