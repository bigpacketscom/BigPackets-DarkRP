net.Receive("playerjoinedAddChat", function()
  chat.AddText(unpack(net.ReadTable()))
end)

net.Receive("playerjoinedAddConsole", function()
  MsgC(unpack(net.ReadTable()))
  MsgN()
end)
