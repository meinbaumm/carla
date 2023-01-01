defmodule Carla do
  @moduledoc """
  A module for quickly renaming files by converting them to camel_case and removing unnecessary characters.

  # How to
  1. Rename files in current directory: `ex_rename_files . .txt`
  2. Rename all files in all directories: `for d in */ ; do ex_rename_files $d .pdf .epub .txt; done`.
  """

  # TODO: Set case stile for renaming
  # TODO: Create function for reading flags
  # TODO: On calling ex_rename_files print info and maybe logo and som flags info as in other cli applications.
  # TODO: Create is_valid format function which return bool and next format if its needed.

  defp list_files(extension) do
    case extension do
      "*" ->
        File.ls!()

      _ ->
        Stream.filter(File.ls!(), fn file -> String.contains?(file, extension) end)
    end
  end

  defp format_file_name(file_name) do
    formatted =
      file_name
      |> String.replace(" ", "_")
      |> String.replace("-", "_")
      |> String.replace(["(", ")"], "")
      |> String.replace(["’", "!", ","], "")
      |> String.replace("___", "_")
      |> String.replace("__", "_")
      |> String.replace(".com", "")
      |> String.replace("._", "")
      |> String.replace("_.", "")
      |> String.replace(["[", "]"], "")
      |> String.replace(["{", "}"], "")
      |> String.replace("?", "")
      |> String.downcase()

    {file_name, formatted}
  end

  defp format(list_files) do
    Stream.map(list_files, fn file -> format_file_name(file) end)
  end

  defp rename(list_files) do
    Stream.map(list_files, fn {from_name, to_name} -> File.rename!(from_name, to_name) end)
  end

  defp format_and_rename(file_extension) do
    file_extension
    |> list_files()
    |> format()
    |> rename()
    |> Enum.to_list()
    |> case do
      [] -> IO.puts("No files in #{File.cwd!()} with extension #{file_extension}.")
      _ -> IO.puts("All files in #{File.cwd!()} with extension #{file_extension} was formatted.")
    end
  end

  defp get_args do
    case System.argv() do
      [] -> {:error, :no_arguments}
      arguments -> {:ok, arguments}
    end
  end

  defp change_directory(path) do
    case File.cd(path) do
      :ok -> :ok
      {:error, :enoent} -> {:error, "Invalid path #{path}."}
    end
  end

  def rename_files do
    with {:ok, [path | extensions]} <- get_args(),
         :ok <- change_directory(path) do
      Enum.map(extensions, fn file_extension -> format_and_rename(file_extension) end)
    else
      {:error, :no_arguments} -> IO.puts("No arguments.")
      {:error, message} -> IO.puts("#{message}")
    end
  end
end
