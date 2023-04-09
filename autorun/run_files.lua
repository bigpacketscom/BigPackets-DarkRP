--
-- Copyright (c) 2016 by Aegis Computing. All Rights Reserved.
--

if SERVER then
  include("playerjoined/sv_init.lua")
else
  include("playerjoined/cl_init.lua")
end
