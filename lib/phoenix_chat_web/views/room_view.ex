defmodule PhoenixChatWeb.RoomView do
  use PhoenixChatWeb, :view

  def user_joined_room?(room, user_rooms) do
    case Enum.filter(user_rooms, &(&1.id==room.id)) do
      [] -> false
      _ -> true
    end
  end
end
