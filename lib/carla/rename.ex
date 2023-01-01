defmodule Carla.Rename do
  @valid_style_formats ~w(snake camel kebab)

  def is_valid_style_format(format) do
    if format in @valid_style_formats do
      {:ok, format}
    else
      {:error, :invalid_style_format}
    end
  end

  defp list_files(extension) do
    case extension do
      "*" ->
        File.ls!()

      _ ->
        Stream.filter(File.ls!(), fn file -> String.contains?(file, extension) end)
    end
  end

  def format_file_name(file_name, "snake") do
    formatted =
      file_name
      |> String.replace([" ", "-", "__", "___", ","], "_")
      |> String.replace(["(", ")", "’", "!", ".com", "._", "_.", "[", "]", "{", "}", "?"], "")
      |> String.downcase()

    {file_name, formatted}
  end

  def format_file_name(file_name, "kebab") do
    formatted =
      file_name
      |> String.replace([" ", "_", "__", "___", ","], "-")
      |> String.replace(["(", ")", "’", "!", ".com", "._", "_.", "[", "]", "{", "}", "?"], "")
      |> String.downcase()

    {file_name, formatted}
  end

  def format_file_name(file_name, "camel") do
    formatted =
      file_name
      |> String.replace(["(", ")", "’", "!"], "")
      |> String.split([" ", ",", "_"])
      |> then(fn [first_word | others] ->
        Enum.reduce(others, String.downcase(first_word), fn others, acc ->
          acc <> String.capitalize(others)
        end)
      end)
      |> String.replace(
        [" ", "-", "__", "___", ".com", "._", "_.", "[", "]", ",", "{", "}", "?"],
        ""
      )

    {file_name, formatted}
  end

  defp format(list_files, rename_style) do
    Stream.map(list_files, fn file -> format_file_name(file, rename_style) end)
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
      {:error, :enoent} -> {:error, "Invalid path #{path}."}
    end
  end

  def rename_files(args) do
    with {:ok, [rename_style | [path | extensions]]} <- get_args(args),
         {:ok, valid_style_format} <- is_valid_style_format(rename_style),
         :ok <- change_directory(path) do
      Enum.map(extensions, fn file_extension ->
        format_and_rename(file_extension, valid_style_format)
      end)
    else
      {:error, :no_arguments} ->
        IO.puts("No arguments.")

      {:error, :invalid_style_format} ->
        IO.puts(
          "Invalid style format. Available styles are #{Enum.join(@valid_style_formats, ", ")}"
        )

      {:error, message} ->
        IO.puts("#{message}")
    end
  end
end
