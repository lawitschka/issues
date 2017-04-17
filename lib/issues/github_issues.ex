defmodule Issues.GithubIssues do
  @moduledoc """
  Fetch issues from Github and transform JSON data into Elixir data structures.
  """

  @user_agent [{ "User-Agent", "Programming Elixir me@moritzlawitschka.de" }]

  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(user, project) do
    "https://api.github.com/repos/#{user}/#{project}/issues"
  end

  def handle_response({ :ok, %{status_code: 200, body: body}}) do
    { :ok, Poison.Parser.parse!(body) }
  end

  def handle_response({ _, %{status_code: _, body: body}}) do
    { :error, Poison.Parser.parse!(body) }
  end
end
