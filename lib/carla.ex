defmodule Carla do
  @moduledoc """
  A module for quickly renaming files by converting them to any style case and removing unnecessary characters.

  # How to
  1. Rename all files in all directories: `for d in */ ; do carla rename snake $d --all; done`.
  """

  # TODO: Do not rename directories without flag File.lstat(file_name)

  alias Carla.{Rename, CliMessages}

  def main(arguments) do
    case arguments do
      ["rename-files" | ["--help"]] ->
        CliMessages.rename_files_help()

      ["rename-string" | ["--help"]] ->
        CliMessages.rename_string_help()

      ["rename-files" | args_for_rename] ->
        Rename.rename_files(args_for_rename)

      ["rename-string" | args_for_rename] ->
        Rename.rename_string(args_for_rename)

      [] ->
        CliMessages.greeting()
    end
  end
end
