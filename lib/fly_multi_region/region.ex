defmodule FlyMultiRegion.Region do
  @moduledoc """
  Helper module for Fly Regions

  [Fly Documenation](https://fly.io/docs/reference/regions/)
  """

  def current, do: Application.get_env(:fly_multi_region, :region)
end
