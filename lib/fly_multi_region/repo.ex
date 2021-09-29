defmodule FlyMultiRegion.Repo do
  import FlyMultiRegion

  @doc false
  defmacro __using__(_) do
    quote do
      import FlyMultiRegion

      @type region() :: String.t() | nil
      @type replica() :: module()

      @doc """
      Returns a Repo for the current region
      """
      @spec replica() :: module()
      def replica() do
        FlyMultiRegion.Region.current()
        |> replica()
      end

      @doc """
      Returns a Repo for the a given region, returns primary Repo as a default
      """
      @spec replica(region()) :: module()
      def replica(region) do
        if Enum.member?(regions(), region) do
          repo_module(region)
        else
          __MODULE__
        end
      end
    end
  end

  @doc """
  Dynamically creates Repo module for region
  """
  def new(region) do
    defmodule repo_module(region) do
      use Ecto.Repo,
        otp_app: :fly_multi_region,
        adapter: Ecto.Adapters.Postgres,
        read_only: true

      def init(context, config) do
        {region, config} = Keyword.pop!(config, :region)
        database_url = Application.get_env(:fly_multi_region, :url)
        opts = Application.get_env(:fly_multi_region, :opts)

        # Append region to the host name
        {_, url_config} =
          Ecto.Repo.Supervisor.parse_url(database_url)
          |> Keyword.get_and_update!(:hostname, fn hostname ->
            {hostname, "#{region}.#{hostname}"}
          end)

        config = config ++ url_config ++ opts

        # Replica's use the port 5433
        config = Keyword.replace!(config, :port, 5433)

        {:ok, config}
      end
    end
  end
end
