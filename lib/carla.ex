defmodule Carla do
  @moduledoc """
  A module for quickly renaming files by converting them to camel_case and removing unnecessary characters.

  # How to
  1. Rename all files in all directories: `for d in */ ; do carla rename snake $d --all; done`.
  """

  # TODO: Create function for reading flags
  # TODO: On calling carla print info and maybe logo and som flags info as in other cli applications.
  # TODO: Do not rename directories without flag File.lstat(file_name)

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
      ["rename-files" | args_for_rename] -> Rename.rename_files(args_for_rename)
      ["rename-string" | args_for_rename] -> Rename.rename_string(args_for_rename)
      # ["fuck"] -> Rename.fuck() |> IO.inspect()
      [] -> greeting_message()
    end
  end
end
