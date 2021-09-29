defmodule FlyMultiRegion do
  @moduledoc """
  Documentation for `FlyMultiRegion`.
  """
  use Supervisor

  alias __MODULE__.Repo

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(_opts) do
    Supervisor.init(replicas(), strategy: :one_for_one)
  end

  @doc false
  def replicas do
    Enum.map(regions(), fn region ->
      {_, module, _, _} = Repo.new(region)
      {module, region: region}
    end)
  end

  @doc false
  def regions, do: Application.get_env(:fly_multi_region, :regions) || []

  @doc """
  Returns replica Repo module name
  """
  def repo_module(region) do
    Module.concat(FlyMultiRegion.Repo, String.capitalize(region))
  end
end
