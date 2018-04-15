defmodule PhoenixChatWeb.RoomView do
  use PhoenixChatWeb, :view


  def user_created_room?(user, room) do
    user.id == room.creator_id
  end

  def user_joined_room?(room, user_rooms) do
    case Enum.filter(user_rooms, &(&1.id==room.id)) do
      [] -> false
      _ -> true
    end
  end

  def joined_users(room) do
    room.users |> Enum.map(&(&1))
  end
end
