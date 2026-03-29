defmodule PhoenixChat.SlugGenerator do
  @moduledoc """
  Generates human-readable mnemonic slugs.
  Replaces the mnemonic_slugs dependency.
  """

  @adjectives ~w(
    brave bright calm cool daring eager fancy gentle happy jolly keen lively merry noble polite
    proud quick sharp smart swift witty bold bright clear crisp fresh grand great keen light
    neat prime rapid ready rich safe sound steady strong sure true vivid warm wise young zesty
    amber azure coral crimson golden ivory jade marble onyx pearl ruby scarlet silver violet
  )

  @nouns ~w(
    falcon eagle hawk raven phoenix dragon tiger lion wolf bear fox deer elk moose crane heron
    cedar maple oak pine birch willow river stream brook creek lake meadow valley ridge summit
    crystal ember flame frost spark storm thunder breeze dawn dusk shadow moon star cloud rain
    anvil beacon crown forge harbor jewel lantern marble quartz shield temple tower anchor arch
  )

  @doc """
  Generates a mnemonic slug with the given number of words.

  ## Examples

      iex> PhoenixChat.SlugGenerator.generate_slug(1)
      "falcon"

      iex> PhoenixChat.SlugGenerator.generate_slug(2)
      "brave-falcon"
  """
  def generate_slug(1) do
    Enum.random(@nouns)
  end

  def generate_slug(2) do
    adjective = Enum.random(@adjectives)
    noun = Enum.random(@nouns)
    "#{adjective}-#{noun}"
  end

  def generate_slug(count) when count > 2 do
    adjectives = for _ <- 1..(count - 1), do: Enum.random(@adjectives)
    noun = Enum.random(@nouns)
    Enum.join(adjectives ++ [noun], "-")
  end
end
