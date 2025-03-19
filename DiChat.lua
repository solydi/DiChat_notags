script_name("{ff7e14}DiChat")
script_author("{ff7e14}solodi")
script_version("1.9.9")

local encoding = require 'encoding'

encoding.default = 'cp1251'
local u8 = encoding.UTF8
local function recode(u8) return encoding.UTF8:decode(u8) end

local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'���������� ����������. ������� ���������� c '..thisScript().version..' �� '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('��������� %d �� %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('�������� ���������� ���������.')sampAddChatMessage(b..'���������� ���������!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'���������� ������ ��������. �������� ���������� ������..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': ���������� �� ���������!')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': �� ���� ��������� ����������. ��������� ��� ��������� �������������� �� '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, ������� �� �������� �������� ����������. ��������� ��� ��������� �������������� �� '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://raw.githubusercontent.com/solydi/DiChat_notags/main/version.json?" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://github.com/solydi/DiChat_notags"
        end
    end
end

local se = require("samp.events")
local memory = require "memory"
local ini = require "inicfg"

local actual = {
	time = memory.getint8(0xB70153),
	weather = memory.getint16(0xC81320)
}

local cfg = ini.load({
	time = {
		value = 12,
		lock = false
	},
	weather = {
		value = 1,
		lock = false
	}
}, "DiClimate.ini")

local skip = [[

[���������] {DC4747}�� ������� ���� ���������, ����������� ������� Y ��� ������ � ���
[���������] {DC4747}�� ������ ������ ������ � ���� ����������� ��������� /report
� ����� �������� �� ������ ���������� ������ ���������� ������� ����� � ���������
�� �� �������� ����� {FFFFFF}������, ���, ���������{6495ED} ��� �� ������� �����-������ ����������
������ �� �������� {FFFFFF}VIP{6495ED} ����� ������ ������������, ��������� /help [������������ VIP]
������ �� �������� {FFFFFF}VIP{6495ED} ����� ������� �����������, ��������� /help [������������ VIP]
� �������� ����� ����� ���������� ������ {FFFFFF}����������, ����������, ��������� ����
� �������� ���-�� ����� ���������� ������ {FFFFFF}����������, ����������, ��������� ����
��������, ������� ������� ���� �� �����! ��� ����: {FFFFFF}arizona-rp.com
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- �������� ������� �������: /menu /help /gps /settings
- �������� ����� � ������ ����� � ������� $300 000!
- �������� ����� � ������ ����� � ������� $1 000 000 + 4 ��������� �����!
- ��� ����: arizona-rp.com (������ �������/�����)
[�������� ��� ������] {ffffff}��������� ������ �����, ������� ������� ������� �� ����: ��� ������ � ���� ����
[�������� ��� ������] {ffffff}���������: {FF6666}/help � ������� � ����� Vice City
[�������� ���� ����] {ffffff}��������� ������ �����, ������� ������� ������� �� ����: ���� ���� � ��� ������
[������ Vice City] {ffffff}��������! �� ������� Vice City ��������� �����
[���������] �� ������ ������ ��������� ��������� /gps - ��������� ���������
���� ��� ������������ ����� �������� ��������� �� ���� � �� ���� �� ����� �������
����� ������� �� ������ ������� ��� ���������, ���� ���� ��� �������
[���������] � ������� �������� ����� �������� �����. ������� ����� �������� - 2 ������!
[���������] {FFFFFF}������ ��������� ��������������� �����:
{FFFFFF}1.{6495ED} 111 - {FFFFFF}��������� ������ ��������
{FFFFFF}2.{6495ED} 060 - {FFFFFF}������ ������� �������
{FFFFFF}3.{6495ED} 911 - {FFFFFF}����������� �������
{FFFFFF}4.{6495ED} 912 - {FFFFFF}������ ������
{FFFFFF}5.{6495ED} 914 - {FFFFFF}�������
{FFFFFF}6.{6495ED} 8828 - {FFFFFF}���������� ������������ �����
{FFFFFF}7.{6495ED} 997 - {FFFFFF}������ �� �������� ����� ������������ (������ ��������� ����)
{DFCFCF}[���������] {DC4747}��������� ���� � ����������� ����: {DFCFCF}(�������: 2)
{DFCFCF}[���������] {DC4747}����������� ����� ���� � ����������� ����: {DFCFCF}�������: 3 ��� /style
��� ������� �������� � ������� Vice City, �������� � ������ ������� ������ ������������.
[����������] {ffffff}���� �� ����������� � ����, �� ������� ������������ ����� �� Vice City ������.
[���������] {ffffff}��������� �� �������� ������� ���������, ����� �������� ������������ ������.
{DFCFCF}[���������] {DC4747}����� ������� ��������� ������� {DFCFCF}/engine{DC4747} ��� ������� {DFCFCF}N
����� ������� �������� ���� ��� ���������� �����������
{DFCFCF}[���������] {DC4747}����� �������� ����� ����������� ������ {DFCFCF}CTRL (/radio)
{DFCFCF}[���������] {DC4747}��� ���������� ������������� ����������� �������: {DFCFCF}(Q/E)
[Vice City News] �� ������ ��������� ��� ����������. ����������� /ad, ����� ���������������� ���� ������ ��� ���� ������.
[���������] {ffffff}�������������� �������� ������� ����� ��������� (/wbook) ��� ��������� �� ��������� �������� �� �������.
[���������] {FFFFFF}��������� ������, �� ��������� � /park ��� �������� ����������.
[���������] {ffffff}��������! �� ���� ������������ �������� �� ���������� �������� ����. 
[���������] {ffffff}� ����� � ���� ��� ���������� ��������� ������� ����������! {CCCCCC}(/help - ����������� �� ���� ��� �������)
[���������] {ffffff}�������� ���������� �� ������� ������ ������� ����!
[���������] {ffffff}��� ������������� Twin Turbo � ����������� ����������� - ����������� ������ �������������� �� ����.
[Battle Pass]{ffffff} �������� ����� BattlePass - '����������� �����', ������� �������� ���������� ������� ����� �� ������!
[Battle Pass]{ffffff} ��� ��������� ����������� ������� 'B'
[���������] {ffffff}��� �������� ������� � ���� ��������, ����������� {ff6666}������� U
[���������] ����� ����������� ������ 3 ����.
[���������] {ffffff}��� ������� ������� ���� 20%, ������ �� �� ������ ������ ������.
[������] {ffffff}��� ������� ������� ���� 20%, ������� �� �� ������ ������ ������.
����������� /olock ����� ������� ��������������� ���������.
����������� ������� '2', ����� ������������ �������� ���������.
������ ���������� ������ ����� � ������� ������� ������ ����� ��� � ����� ����������! (/GPS - ����������� - ����������)
[���������] {ffffff}�� ��������� � 2 ���� ������ �������� ������� ��-�� ���������� ADD VIP.
[���������] {ffffff}���� �� ������ ������������� �� ���� ����� 3 �����, ��������� ����� ��������� � �������� �������.
[���������] {ffffff}�������� ������ ����� ����� ���� ������������� ���������� (/cars)
[���������] {FFFFFF}��� ����� � ���� � ��� ������� ������. ������� ������� ��� ������ �������!
[����������] {FFFFFF}�� ���������� �������� ������
[����������] {FFFFFF}����� ���������� �� ������ [/unrentcar]
[����������] {FFFFFF}����� ������� ���������� ����������� [/jlock]
[����������] {FFFFFF}� ��� ���� 2 ������ ����� ��������� ������� � ���������.
[���������] {FFFFFF}��� ���� ����� ��������� ��� �������, ��� ���������� ����� ���� �� ���������� �����,
� ��������� ���������� �� ��������� ����� �� ������ �� �� ����� �����.
[���������] {FFFFFF}��� ���� ����� ��������� ��� �������, ��� ���������� ����������� � ���,
����� ��� 3 ����� � ���������� ��. ����� ��������� � �������� �� ��������!
[���������] {FFFFFF}������������� � �������� ����, ����� �������� �� ���������
������� ��������. ���������� ������� � ���� 1000 ����! ����� ��������� � ������!
���� ��������� ����������� ����� 'Dillinger', ��������� ������: 0$ � 1 ������ (� ����������� �����)
�����! ���� ���� ����� ��������� � Arizona Tower, �� �������� ����� ������� �� ����������� �������� Arizona Tower �� ������!
[���������] {FFFFFF}����������� /house ��� ���������� �����.
[�������] {ffffff}��������! � �������� ��� �������� �� ������ ����� � �������� ��������.
[���� �������� � ������ ���� ����] {ffffff}��������! � ������� �� ���� ���� ����� �������� �� ������� � ������� 1 �������.
[���� �������� � ������ ���� ����] {ffffff}������ ����� ��������� �� ����������� ����� � ���������� ������.
[���������] {ffffff}����������� ��������� ������� ������� �� ��������� ���������! {CCCCCC}( /help � ����� ����� )
[���������] {ffffff}�������������� �������� ������� ����� ��������� (/wbook) ��� ��������� �� ��������� �������� �� �������.
[���������] {ffffff}��������� � ����������� ��������: {ff6666}/wbook {ffffff}��� {ff6666}/cbook
{FFFFFF} ����������� /phone - ��������� - ��������� �������� - ���������� �����������, ����� ����� ������ �����������.
{ffffff}��������! �� ���� ������������ �������� �� ���������� �������� ����. 
{ffffff}� ����� � ���� ��� ���������� ��������� ������� ����������! {CCCCCC}(/help - ����������� �� ���� ��� �������)
{ffffff}����� ���������� ������ �� ���������, ���������� � {ff6666}��������� ������� Los Santos{ffffff}.
[���������] {ffffff}��� �������� ������� � ���� ��������, ����������� {ff6666}������� U
[���������] {ffffff}��� ������������� Twin Turbo � ����������� ����������� - ����������� ������ �������������� �� ����.
[���������] {ffffff}�� ������ � ���� ������� ��������. ����� ������ �� ��������. ����������� ��������� � ��������� �����.
[���������] {ffffff}�� ������� �������� ��� ��������� ����� ���������� � ������������ � ��� ����� �� ������ ������.
[���������] {ffffff}�� ����� � ���� �������.
[���������] {ffffff}�� ������ ����� �������� ��� ������� �� {ff0000}���������� ������{ffffff}.
[���������] {ffffff}�� �������� ���� �������.
� ��� ������� ������� '������ x4 ���������� ����� (24 ����)', ������� ����� ������������.
�������� ��������! �� ������ �������� ���� �������������� �� ���� �����, ����� ��������� ����������� ���������� �� ������ � Las Venturas.
��������� ���������� �� 4 ���� ���� ������ ��������� +38 ��. ������, +7 ��. � �����, +10 ��. � �����, � ����� +50 ����. HP � +40 ����. �����.
����� ����� ����� � ������� /GPS - ������ - ����� ��������� ������������.
[����������] �������� � ������� ������������� ������ � ���-����� � ��� ���������! /GPS - ������ - ����� ������������� ������� � ���-����.
[����������] {FFFFFF}����������� ������ ����� ������� ��� ������� � ��� ���-��
[����������] {FFFFFF}�� ������ ��������� ������ ��� - ����� �� ��������� �������
{9ACD32}[���������]{FFFFFF} ����� ����? ��������� ����� � ����� �� ������ �����!
{9ACD32}[���������]{FFFFFF} �������� � �����, �� ��������� ��������� �������, ������� �������� ���� ����
{9ACD32}[���������]{FFFFFF} ���������: {9ACD32}/hotel
[Battle Pass]{ffffff} �������� ������ ����� � �������� ARIZONA GAMES ��� ARIZONA MOBILE!
[���������] {ffffff}�� ������ ��������� ������ ������� � {ff6666}/settings - ��������� ���������{ffffff}.
����� ������ ���������
������� ���������� ����� ���������� � ������� �������� � ����������� ������ ������ ����������
(/GPS - ������ - ����� ������ ����������)
������ ����� ����� � ���� ���-������, ����������� ������������� ������ ����� ����� ��.
��� ���������� ������� ��� ����� ���������� �� ������ ����������� ��������� � ��������� 3 ����� ������.
�������� ��������! ���������� �� ������ ����� � ������ ���������: {FFA500}/GPS - ������ ����� - ����� ���������.
���� �� ��� �������� �� ������, ����� ��� ����� ����������� �� ������� ����������� � ���������� ��� ������� ���������.
/GPS - �� ������ - ���� ����������� ���������
[���������] {FFFFFF}������ �� �����, ���� ������!
[����������] �� �������� ����������� �������� ���������� �����
�� ������� GPS ����������, ����� ��� ����� ������� - ����� ��������� � ������
]]

-- ������
function se.onSetWeather(id)
	actual.weather = id
	if cfg.weather.lock then
		return false
	end
end

function se.onSetPlayerTime(hour, min)
	actual.time = hour
	if cfg.time.lock then
		return false
	end
end

function se.onSetWorldTime(hour)
	actual.time = hour
	if cfg.time.lock then
		return false
	end
end

function se.onSetInterior(id)
	local result = isPlayerInWorld(id)
	if cfg.time.lock then
		setWorldTime(result and cfg.time.value or actual.time, true) 
	end
	if cfg.weather.lock then 
		setWorldWeather(result and cfg.weather.value or actual.weather, true)
	end
end

function main()
	-- ������������� ���������, ��� ������ ��������
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end
	sampAddChatMessage('{F48B8C}[INFO] {ffffff}������ {ff7e14}"DiChat" {ffffff}����� � ������! �����: {ff7e14}solodi {ffffff}| ������: ' .. thisScript().version,-1)

	while not isSampAvailable() do
        wait(100)
    end

	if autoupdate_loaded and enable_autoupdate and Update then
        pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end

	-- ������� ����� ������
	sampRegisterChatCommand("st", setWorldTime)
	sampRegisterChatCommand("sw", setWorldWeather)
	-- �������� ���������� �������� � ������� �������� ���/����
	sampRegisterChatCommand("bt", toggleFreezeTime)
	sampRegisterChatCommand("bw", toggleFreezeWeather)
	wait(-1)
end

-- ���������� ������ ����������� ������
require('memory').fill(0x4A125D, 0x90, 8, true)
writeMemory(0x539F00, 4, 0x0024C2, true)

-- ���������� ��������� � ������ �� ��
function onReceivePacket(id, bs)
    if id == 220 then
        raknetBitStreamIgnoreBits(bs, 8)
        if raknetBitStreamReadInt8(bs) == 12 then
            return false
        end
    end
end

function setWorldTime(hour, no_save)
	if tostring(hour):lower() == "off" then
		hour = actual.time
	end
	hour = tonumber(hour)
	if hour ~= nil and (hour >= 0 and hour <= 23) then
		local bs = raknetNewBitStream()
		raknetBitStreamWriteInt8(bs, hour)
		raknetEmulRpcReceiveBitStream(94, bs)
		raknetDeleteBitStream(bs)
		if no_save == nil then
			cfg.time.value = hour
			ini.save(cfg, "DiClimate.ini")
		end
		return nil
	end
	sampAddChatMessage("�����������: {EEEEEE}/st [0 - 23 ��� OFF]", 0xFFDD90)
end

function setWorldWeather(id, no_save)
	if tostring(id):lower() == "off" then
		id = actual.weather
	end
	id = tonumber(id)
	if id ~= nil and (id >= 0 and id <= 45) then
		local bs = raknetNewBitStream()
		raknetBitStreamWriteInt8(bs, id)
		raknetEmulRpcReceiveBitStream(152, bs)
		raknetDeleteBitStream(bs)
		if no_save == nil then
			cfg.weather.value = id
			ini.save(cfg, "DiClimate.ini")
		end
		return nil
	end
	sampAddChatMessage("�����������: {EEEEEE}/sw [0 - 45 ��� OFF]", 0xFFDD90)
end

function toggleFreezeTime()
	cfg.time.lock = not cfg.time.lock
	if ini.save(cfg, "DiClimate.ini") then
		local state = (cfg.time.lock and "�� ������" or "����� �����")
		sampAddChatMessage("������ ������ " .. state .. " �������� �����!", 0xFFDD90)
	end
end

function toggleFreezeWeather()
	cfg.weather.lock = not cfg.weather.lock
	if ini.save(cfg, "DiClimate.ini") then
		local state = (cfg.weather.lock and "�� ������" or "����� �����")
		sampAddChatMessage("������ ������ " .. state .. " �������� ������!", 0xFFDD90)
	end
end

function isPlayerInWorld(interior_id)
	local ip, port = sampGetCurrentServerAddress()
	local address = ("%s:%s"):format(ip, port)
	if address == "80.66.82.147:7777" then -- Vice City
		return (interior_id == 20)
	end
	return (interior_id == 0)
end

function se.onShowDialog(id, style, title, button1, button2, text)
    -- ������� ��������
    local dialogSkip = {
		[15220] = 1, -- ���� ��� ��������
		[25475] = 1, -- ����� ����
        [26612] = 0, -- ����� ������� ������ R
        [25194] = 1, -- ������� ��� �����
		[15222] = 1, -- ������ ��� ����������
        --[7551] = 1,   -- ����������� ��� �����
        --[581] = 1,    -- ����������� ��� �����
        [15330] = 0, -- ���� ����� �4
        [25191] = 1, -- ��� ���� ������
        [15531] = 1,  -- ������ ������� � Metall Bank Card
		[26016] = 1, -- vc fam avto
		[25824] = 1 -- ����������� ��
    }

    -- �������� �� id
    if dialogSkip[id] ~= nil then
        sampSendDialogResponse(id, dialogSkip[id])
        return false
    end

    -- ������ ��� �����
    local textSkip = {
        ["�����! ��� ������������� ������� � ��������"] = false,
        ["�����! ��� ������������� ����������� ������� � ��������"] = false,
		-- �������� ������
        ["������� � ��� ����� ��������� ���������� ������� ��������."] = "{73B461}[����������] {ffffff}�� ������� �������� ����� {ff7e14}'��������� ��������'{ffffff}.",
        ["�� ��������� ��������� ������������� ������ ����!"] = "{73B461}[����������] {ffffff}�� ������� �������� ����� {ff7e14}'����� ����'{ffffff}.",
        ["��� ������ ����� ���� ������� ����� ���������� ������!"] = "{73B461}[����������] {ffffff}�� ������� �������� ����� {ff7e14}'��������'{ffffff}.",
		["��� �� �������� ������ � ��� � ����� ���� 5 ����."] = "{73B461}[����������] {ffffff}�� ������� �������� ����� {ff7e14}'������� �����'{ffffff}.",
		["������� �� ����� � ��������� ����� ����� �����."] = "{73B461}[����������] {ffffff}�� ������� �������� ����� {ff7e14}'������������� ������'{ffffff}.",
		["�� �� ������ ��� � ��� �� ����� ����� ����� ������?"] = "{73B461}[����������] {ffffff}�� ������� �������� ����� {ff7e14}'������������� ������'{ffffff}.",
		["� ��������� ����� ������������� ����������� � ����� ��������� ��� ��������������� ��������� ���������,"] = "{73B461}[����������] {ffffff}�� ������� �������� ����� {ff7e14}'��������� ��������'{ffffff}.",
		-- �������� ����
		-- ���������
		-- � ����������		
		["���� ��� � ���� ���� ����, ���������."] = "{73B461}[����������] {ffffff}�� ������� �������� ����� {ff7e14}'������� �������'{ffffff}.",
		-- ����� ����� �����
        ["��� ��������, ���� �� ����� ������� �� ����� ������� ������."] = false,
		-- ���� ����� �� VICE CITY
        ["�� ���� ������ ��� �� �������"] = false
    }

    -- �������� �� ������
    for key, message in pairs(textSkip) do
        if text:find(key) then
            sampSendDialogResponse(id, 1, 0, false)
            if message then
                sampAddChatMessage(message, -1)
            end
            return false
        end
    end
end

function se.onServerMessage(color, text)
	if text:match("^%s*$") then
        return false
    end

	-- ���� ������ ����� ��������
	for line in string.gmatch(skip, "[^\n]+") do
		if string.find(text, line, 1, true) then
			return false
		end
	end
	-- �������� ������
	local messages = {
		["��� ���������� ������� ��� ����� ��������� ���� �� ��������� �����."] = false,
		["�� ������� ��������� ���� �� ����������, ������ ��� ����� ������� ��� � ���������� �� ��������� �����."] = "{73B461}[����������] {ffffff}�� ��������� ���� � ������ ��������� ��� � ���������� ����� �� ���������.",
		["�� ������ ���������� ���� �� ����� ���������� �� ������ ������ ����� ������ �� ��������� ������� �����"] = "{73B461}[����������] {ffffff}�� ���� ������ �� ������� ����� ������, � ��� ������ �� ���� ��� ��������� � �������� ������� �������� ������ ������.",
		["���� �� �������� ���� ��� �������� � ��������, ���������� ������� �������� ������ ������."] = false,
		["��� ���������� ������� ��� ����� ����������� �� ����������"] = false,
		["�������������� ����� � ������ ��� ������ �������� �� ���������."] = "{73B461}[����������] {ffffff}��� ���������� ������� ����������� �� DFT-30 � ���� ���-������� (������� �� ���������), ����� ������� � ��������� ������ ����.",
		["�������� ��������! �� ������ �������������� ����������� �� ������� � ������� ����"] = false,
		["��� ���������� ������� ��� ����� ������� �������� 20 ����� ���."] = "{73B461}[����������] {ffffff}�������� ��� ������ ���� � ������� � �������� �������� 20 ���.",
		["��� ���������� ������� ��� ����� ����� 3 ������."] = "{73B461}[����������] {ffffff}����� ��������� �������, ������ 3 ������.",
		["��� ���������� ������� ��� ����� ����������� �� ���� �� 5 ���� � ��������� ��� 30 ����� ��������."] = "{73B461}[����������] {ffffff}��� ���������� ������� ����������� �� ������� ����� � ��������� 30 ����� ��������.",
		["��� ���������� ������� ��� ����� ���������� �� ������ ����������� ��������� � ��������� 3 ����� ������."] = "{73B461}[����������] {ffffff}����� ��������� �������, ���������� ����������� ��������� � ��������� 3 ����� ������.",
		["��� ���������� ������� ��� ����� ���������� �� ������ ��������� ������ � ��������� 3 �����!"] = "{73B461}[����������] {ffffff}��� ���������� ������� ���������� ���������� ������ � ��������� 3 �����.",
		["��� ���������� ������� ��� ����� ���������� �� ������ �������� �������� � �������� 300 ���������� �� ����� ��������."] = "{73B461}[����������] {ffffff}����� ��������� �������, ���������� ��������� �������� � �������� 300 ���������� �� ����� ��������.",
		-- �������� ����
		-- ���������
		-- � ����������
		["��� ���������� ������� ��� ����� ������� � ������ � ����� ����������� ������ �� �������� ����� ��."] = false,
		["�������������� ������ �������� �� ���������."] = "{73B461}[����������] {ffffff}��������� � ������ (������� �� ���������) � �������� ����������� ������ �� �������� ����� ��.",
		["��� ���������� ������� ��� ����� ��������� ������ ������� ����� ������� ������� ���� ������."] = "{73B461}[����������] {ffffff}��������� ������ ������� ����� ������� � ������� ���� ������ (�������������� �������� �� ���������).",
		["�������������� ��������� ������ ��� �������� �������� �� ���������."] = false,
		["�� ������� ��������� ������ �������."] = false,
		["�������� ������� ������: 1."] = "{73B461}[����������] {ffffff}�������� ������� ������: {00FFFF}1{ffffff}.",
		["��� ���������� ������� ��� ����� ����� ��������� ������ ������� ����� ������� ������� ���� ������."] = false,
		["������ ��� ����� ������� ����� � ����� ��������� ����� ����� � ������ ��� ������ � ��������� ��� ���."] = "{73B461}[����������] {ffffff}��������� ������ �� ������� ����� ����� � ��� ������ ��� ��������.", 
		["�� ������� ���������� �� ������!"] = "{73B461}[����������] {ffffff}�� ������� ���������� �� ������.",
		["����� ����������� �� ���������� ����� �����"] = "{73B461}[����������] {ffffff}����� ����������� �� ���� �������� ����������.",
		["����� ����������� �� ����� ����� ��/���� ����� �����"] = "{73B461}[����������] {ffffff}����� ����������� �� �� ����� �����.",
		["������ �� �� ����� ���������� ����� ����� ��� ��������, ������� ����� ���� �� �������."] = "{73B461}[����������] {ffffff}������ �� �������� ���������� � ���������."
    }

	for msg, chatMsg in pairs(messages) do
        if text:find(msg) then
            sampSendDialogResponse(id, 1, 0, false)
            if chatMsg then
                sampAddChatMessage(chatMsg, -1)
            end
            return false
        end
    end

	-- ����� � �������
	local deerLeft = string.match(text, "%[�����] �������� ���������� ������: (%d+) ��.")
	if deerLeft then
		return { 0x73B461FF, string.format("{73B461}[����������] {ffffff}�������� ���������� ������: {FFA500}%s {ffffff}��.", deerLeft) }
	end

	-- ����� � ���������� �� �����
	local actionsLeft = string.match(text, "%[�����] �������� ��������� �������� �� �����: (%d+)")
	if actionsLeft then
    	return { 0x31B404FF, string.format("{31B404}[����������] {ffffff}�������� ��������� �������� �� �����: {FFA500}%s {ffffff}��.", actionsLeft) }
	end

	-- ����� � ���������
	local jobLeft = string.match(text, "%[�����] �� ������� ������� 1 �����%(�%), ��� ���������� ������� ��� �������� ������� ��� (%d+) �����%(�%)%.")
	if jobLeft then
    	return { 0x73B461FF, string.format("{73B461}[����������] {ffffff}�� ������� ������� 1 �����, ��� ���������� ������� ��� �������� ������� ��� {FFA500}%s {ffffff}�����(�).", jobLeft) }
	end

    -- ���� ������ �� ���
    if color == 0x73B461FF and string.find(text, "^%[ News .. %]") then
		return false
	end

	-- ���� ��� �� ������
	if string.match(text, "> ����� .+_.+%(.+%) ����� ��� ������� �������� ������ � ��� �������!") then
		return false
	end

    -- /ad ��� �������
    if color == 0x73B461FF then
        if string.find(text, "�������������� ���������") then
            return false
        end

		local keywords = {
			"�������", "�������", "�������", "�������", "�������",
			"�������", "�������", "�������", "�������", "�������",
			"������", "������", "��������", "��������", "�������",
			"�������", "�������", "��������", "���", "���" }

		-- �������� �� ������� �������� ����
		for _, keyword in ipairs(keywords) do
			if string.find(text, keyword) then
				return false
			end
		end

        local patterns = {
            {pattern = "����������: (.+)%. (.+_.+)%(���%)", prefix = "{87b650}OFF AD: {ffeadb}", suffix = "{ff9a76} "},
            {pattern = "����������: (.+)%. (.+_.+)%[.+] ���%. (.+)", prefix = "{87b650}AD: {ffeadb}", suffix = "{ff9a76} T: "},
            {pattern = "����������: (.+)%. (.+_.+) %[.+]%. ���: (.+)", prefix = "{87b650}AD: {ffeadb}", suffix = "{ff9a76} T: "},
            {pattern = "%[VIP]����������: (.+)%. (.+_.+)%[.+] ���%. (.+)", prefix = "{FCAA4D}VIP AD: {ffeadb}", suffix = "{ff9a76} T: "},
			{pattern = "%[������� �������] (.+)%. ��������: (.+_.+)%[.+]", prefix = "{FCAA4D}AD BIZ: {ffeadb}", suffix = "{ff9a76} "}
        }

		for _, p in ipairs(patterns) do
			local ad, sender, tel = string.match(text, p.pattern)
			if ad and sender then
				local message = p.prefix .. ad .. "." .. p.suffix .. (tel and tel .. ". " or "") .. sender
				sampAddChatMessage(message, -1)
				return false
			end
		end
	end

	--������������ � ���� ������ � ����
	if text:find("%[������� �����]{FFFFFF} ���� �����: .+_.+%[.+] ������ .+ ������%. � ����� �������� ����%.") then
		lua_thread.create(function()
		  wait(1000)
		  sampSendChat("/fam � ��� ��������!")
		  end)
		return text
   end

   --����������� � �����
	if text:find("%[����� %(�������%)] .+_.+%[.+]:{B9C1B8} ��������� � ����� ������ �����: .+_.+%[.+]!") then
        lua_thread.create(function()
			wait(1000)
			sampSendChat("/fam ����� ����������)")
			end)
		  return text
    end

	do -- �������� ������� ��������, ����
		local keywords = {
			"�������", "�������", "�������", "�������", "�������",
			"�������", "�������", "�������", "�������", "�������",
			"������", "������", "��������", "��������", "�������",
			"�������", "�������", "��������", "���", "���" }

		if string.find(text, "%[VIP ADV]") then
			for _, keyword in ipairs(keywords) do
				if string.find(text, keyword) then
					return false
				end
			end
			return { 0xff033eFF, text }
		end

		if string.find(text, "%[ADMIN]") then
			for _, keyword in ipairs(keywords) do
				if string.find(text, keyword) then
					return false
				end
			end
			return { 0xff033eFF, text }
		end
    end

	do -- ������������� ��������� � ��� ��� ������� ���
		local sec = string.match(text, "^�� ���������. ���������� ����� �������� (%d+) ������")
		if sec ~= nil then
			local end_mute = os.time() + tonumber(sec)
			local get = function(count)
				local normal = count + (86400 - os.date("%H", 0) * 3600)
				if count < 3600 then
					return os.date("%M:%S", normal)
				else
				    return os.date("%H:%M:%S", normal)
				end
			end
			text = string.gsub(text, "%d+ ������", get(end_mute - os.time()) .. " (�� " .. os.date("%H:%M:%S", end_mute) .. ")")
			return { color, text }
		end
	end

	do -- ����������� ����� ��� ��������� � ���� ������
		local id, message = string.match(text, "^[A-z0-9_]+%[(%d+)%] �������:{B7AFAF} (.+)")
		if id ~= nil then
			local clist = sampGetPlayerColor(tonumber(id))
			local a, r, g, b = explode_argb(clist)
			return { join_argb(r, g, b, a), text }
		end
	end

	do -- OOC ��� ��� ������� (/b)
		local id, message = string.match(text, "^%(%( .+%[(%d+)%]: {B7AFAF}(.+){FFFFFF} %)%)$")
		id = tonumber(id)
		if id ~= nil and select(1, sampGetCharHandleBySampPlayerId(id)) then
			message = string.format("(( {B7AFAF}%s{FFFFFF} ))", message)
			if #message > 128 then message = "(( {B7AFAF}...{FFFFFF} ))" end
			setPlayerChatBubble(id, -1, 15, 6000, message)
		end
	end
end

function setPlayerChatBubble(playerId, color, dist, duration, message)
	local bs = raknetNewBitStream()
	raknetBitStreamWriteInt16(bs, playerId)
	raknetBitStreamWriteInt32(bs, color)
	raknetBitStreamWriteFloat(bs, dist)
	raknetBitStreamWriteInt32(bs, duration)
	raknetBitStreamWriteInt8(bs, #message)
	raknetBitStreamWriteString(bs, message)
    raknetEmulRpcReceiveBitStream(59, bs)
    raknetDeleteBitStream(bs)
end

function explode_argb(argb)
	local a = bit.band(bit.rshift(argb, 24), 0xFF)
	local r = bit.band(bit.rshift(argb, 16), 0xFF)
	local g = bit.band(bit.rshift(argb, 8), 0xFF)
	local b = bit.band(argb, 0xFF)
	return a, r, g, b
end

function join_argb(a, r, g, b)
    local argb = b
    argb = bit.bor(argb, bit.lshift(g, 8))
    argb = bit.bor(argb, bit.lshift(r, 16))
    argb = bit.bor(argb, bit.lshift(a, 24))
    return argb
end