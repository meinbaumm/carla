defmodule Carla.CliMessages do
  @moduledoc """
  Module for keeping cli messages.
  """
  alias Carla.Rename

  def greeting do
    """
    Carla 1.0.0
    Maxim Petrenko <meinbaumm@gmail.com>

    USAGE:
      carla [ACTION] <SUBCOMMAND>

    ACTIONS:
      rename-files     rename files with given extension or all files in given directory
      rename-string    rename string into chosen style
    """
    |> IO.puts()
  end

  def rename_files_help do
    """
    carla rename-files
    rename files with given extension or all files in given directory

    USAGE:
      carla rename-files [STYLE] [DIRECTORY] [FILE_FORMATS]

    STYLES:
      #{Rename.available_valid_style_formats()}

    Example FILE_FORMATS:
      .pdf, .txt, .epub, etc.
    """
    |> IO.puts()
  end

  def rename_string_help do
    """
    carla rename-string
    rename string into chosen style

    USAGE:
      carla rename-string [string in quotes] [style]

    STYLES:
      #{Rename.available_valid_style_formats()}
    """
    |> IO.puts()
  end
end
