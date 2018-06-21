defmodule PhoenixChat.Temporary do
  @moduledoc """
  The Temporary context.
  """

  import Ecto.Query, warn: false
  alias PhoenixChat.Repo

  alias PhoenixChat.Temporary.TempRoom

  @doc """
  Returns the list of temp_rooms.

  ## Examples

      iex> list_temp_rooms()
      [%TempRoom{}, ...]

  """
  def list_temp_rooms do
    Repo.all(TempRoom)
  end

  @doc """
  Gets a single temp_room.

  Raises `Ecto.NoResultsError` if the Temp room does not exist.

  ## Examples

      iex> get_temp_room!(123)
      %TempRoom{}

      iex> get_temp_room!(456)
      ** (Ecto.NoResultsError)

  """
  def get_temp_room!(id), do: Repo.get!(TempRoom, id)

  @doc """
  Creates a temp_room.

  ## Examples

      iex> create_temp_room(%{field: value})
      {:ok, %TempRoom{}}

      iex> create_temp_room(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_temp_room(attrs \\ %{}) do
    %TempRoom{}
    |> TempRoom.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a temp_room.

  ## Examples

      iex> update_temp_room(temp_room, %{field: new_value})
      {:ok, %TempRoom{}}

      iex> update_temp_room(temp_room, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_temp_room(%TempRoom{} = temp_room, attrs) do
    temp_room
    |> TempRoom.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a TempRoom.

  ## Examples

      iex> delete_temp_room(temp_room)
      {:ok, %TempRoom{}}

      iex> delete_temp_room(temp_room)
      {:error, %Ecto.Changeset{}}

  """
  def delete_temp_room(%TempRoom{} = temp_room) do
    Repo.delete(temp_room)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking temp_room changes.

  ## Examples

      iex> change_temp_room(temp_room)
      %Ecto.Changeset{source: %TempRoom{}}

  """
  def change_temp_room(%TempRoom{} = temp_room) do
    TempRoom.changeset(temp_room, %{})
  end

  alias PhoenixChat.Temporary.TempMessage

  @doc """
  Returns the list of temp_messages.

  ## Examples

      iex> list_temp_messages()
      [%TempMessage{}, ...]

  """
  def list_temp_messages do
    Repo.all(TempMessage)
  end
 
  @doc """
  Returns the list of temp_messages for a specified temp_room_id.

  ## Examples

      iex> list_messages_for_room(123)
      [%TempMessage{}, ...]

  """
  def list_messages_for_room(temp_room_id) do
    query = from m in TempMessage,
            where: m.temp_room_id == ^temp_room_id,
            select: m
    Repo.all(query)
  end

  @doc """
  Gets a single temp_message.

  Raises `Ecto.NoResultsError` if the Temp message does not exist.

  ## Examples

      iex> get_temp_message!(123)
      %TempMessage{}

      iex> get_temp_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_temp_message!(id), do: Repo.get!(TempMessage, id)

  @doc """
  Creates a temp_message.

  ## Examples

      iex> create_temp_message(%{field: value})
      {:ok, %TempMessage{}}

      iex> create_temp_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_temp_message(attrs \\ %{}) do
    %TempMessage{}
    |> TempMessage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a temp_message.

  ## Examples

      iex> update_temp_message(temp_message, %{field: new_value})
      {:ok, %TempMessage{}}

      iex> update_temp_message(temp_message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_temp_message(%TempMessage{} = temp_message, attrs) do
    temp_message
    |> TempMessage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a TempMessage.

  ## Examples

      iex> delete_temp_message(temp_message)
      {:ok, %TempMessage{}}

      iex> delete_temp_message(temp_message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_temp_message(%TempMessage{} = temp_message) do
    Repo.delete(temp_message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking temp_message changes.

  ## Examples

      iex> change_temp_message(temp_message)
      %Ecto.Changeset{source: %TempMessage{}}

  """
  def change_temp_message(%TempMessage{} = temp_message) do
    TempMessage.changeset(temp_message, %{})
  end
end
