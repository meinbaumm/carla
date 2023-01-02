defmodule Carla do
  @moduledoc """
  A module for quickly renaming files by converting them to camel_case and removing unnecessary characters.

  # How to
  1. Rename all files in all directories: `for d in */ ; do ex_rename_files $d .pdf .epub .txt; done`.
  """

  # TODO: Create function for reading flags
  # TODO: On calling carla print info and maybe logo and som flags info as in other cli applications.

  alias Carla.Rename

  def greeting_message do
    """
    Hi! I am Carla, your personal helper.

    Just call me `carla [action] [style] [directory] [file-formats]`
    """
    |> IO.puts()
  end

  def main(arguments) do
    case arguments do
      ["rename" | args_for_rename] -> Rename.rename_files(args_for_rename)
      [] -> greeting_message()
    end
  end
end
