defmodule Carla.Rename do
  @moduledoc """
  Rename is a collection of functions for renaming file names with a given extension from one style to another.
  """

  def valid_style_formats do
    ~w(snake camel kebab pascal dot title path header constant name sentence)
  end

  def available_valid_style_formats do
    valid_style_formats()
    |> Enum.sort()
    |> Enum.join(", ")
  end

  def is_valid_style_format(format) do
    if format in valid_style_formats() do
      {:ok, format}
    else
      {:error, :invalid_style_format,
       "Error: invalid style format #{format}. Available styles are: #{available_valid_style_formats()}"}
    end
  end

  def is_extension(extensions) do
    case extensions do
      "--all" ->
        "--all"

      [] ->
        {:error, :no_extension, "Error: no file extension or --all flag passed."}

      _ ->
        {:ok, extensions}
    end
  end

  defp list_files(extension) do
    case extension do
      "--all" ->
        File.ls!()

      _ ->
        Stream.filter(File.ls!(), fn file -> String.contains?(file, extension) end)
    end
  end

  def process_string(file_name) do
    file_name
    |> String.replace([" ", "-", "__", "___", ","], " ")
    |> String.replace(["(", ")", "’", "!", ".com", "._", "_.", "[", "]", "{", "}", "?"], "")
  end

  def recase(file_name, case_style) do
    case case_style do
      "snake" -> Recase.to_snake(file_name)
      "camel" -> Recase.to_camel(file_name)
      "kebab" -> Recase.to_kebab(file_name)
      "pascal" -> Recase.to_pascal(file_name)
      "dot" -> Recase.to_dot(file_name)
      "title" -> Recase.to_title(file_name)
      "path" -> Recase.to_path(file_name)
      "header" -> Recase.to_header(file_name)
      "constant" -> Recase.to_constant(file_name)
      "name" -> Recase.to_name(file_name)
      "sentence" -> Recase.to_sentence(file_name)
    end
  end

  defp format(list_files, rename_style) do
    Stream.map(list_files, fn file ->
      formatted_file =
        file
        |> process_string()
        |> recase(rename_style)

      {file, formatted_file}
    end)
  end

  defp rename(list_files) do
    Stream.map(list_files, fn {from_name, to_name} -> File.rename!(from_name, to_name) end)
  end

  defp format_and_rename(file_extension, rename_style) do
    file_extension
    |> list_files()
    |> format(rename_style)
    |> rename()
    |> Enum.to_list()
    |> case do
      [] -> IO.puts("No files in #{File.cwd!()} with extension #{file_extension}.")
      _ -> IO.puts("All files in #{File.cwd!()} with extension #{file_extension} was formatted.")
    end
  end

  defp get_args(args) do
    case args do
      [] -> {:error, :no_arguments}
      arguments -> {:ok, arguments}
    end
  end

  defp change_directory(path) do
    case File.cd(path) do
      :ok -> :ok
      {:error, :enoent} -> {:error, "Error: invalid path #{path}."}
    end
  end

  def rename_files(args) do
    with {:ok, [rename_style | [path | extensions]]} <- get_args(args),
         {:ok, valid_style_format} <- is_valid_style_format(rename_style),
         {:ok, extensions} <- is_extension(extensions),
         :ok <- change_directory(path) do
      Enum.map(extensions, fn file_extension ->
        format_and_rename(file_extension, valid_style_format)
      end)
    else
      {:error, :no_arguments} ->
        IO.puts("No arguments.")

      {:error, :invalid_style_format, message} ->
        IO.puts(message)

      {:error, :no_extension, message} ->
        IO.puts(message)

      {:error, message} ->
        IO.puts(message)
    end
  end
end
