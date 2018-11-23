#include <a_samp>
#include <streamer>
#include <sscanf2>
#include <zcmd>
#include <YSI\y_dialog>
#include <YSI\y_inline>

#define MASTER_PW "Kf-MasterPasswort" //Masterpasswort für erweiterte Rechte

enum pInfo
{
	pKills,
	pDeaths,
	pSkin,
	pTeam,
	pRights,
}
new PlayerInfo[MAX_PLAYERS][pInfo];

COMMAND:ban(playerid, params[])
{
	if(!IsPlayerConnected(playerid))return 1;
	if(PlayerInfo[playerid][pRights] == 0)return SendClientMessage(playerid, -1, "{FF0000}FEHLER: {FFFFFF}Du besitzt nicht die nötigen Rechte dazu (/getrights).");
	new string[128],pID;
	if(sscanf(params,"u",pID))return SendClientMessage(playerid, -1, "{FF0000}FEHLER: {FFFFFF}/ban [playerid]");
	format(string, sizeof(string),"{A634F5}INFO: {FFFFFF}%s hat %s vom Server gebannt.",SpielerName(playerid),SpielerName(pID));
	SendClientMessageToAll(-1, string);
	return Ban(pID);
}

COMMAND:kick(playerid, params[])
{
	if(!IsPlayerConnected(playerid))return 1;
	if(PlayerInfo[playerid][pRights] == 0)return SendClientMessage(playerid, -1, "{FF0000}FEHLER: {FFFFFF}Du besitzt nicht die nötigen Rechte dazu (/getrights).");
	new string[128],pID;
	if(sscanf(params,"u",pID))return SendClientMessage(playerid, -1, "{FF0000}FEHLER: {FFFFFF}/kick [playerid]");
	format(string, sizeof(string),"{A634F5}INFO: {FFFFFF}%s hat %s vom Server gekickt.",SpielerName(playerid),SpielerName(pID));
	SendClientMessageToAll(-1, string);
	return Kick(pID);
}

COMMAND:stopgangwar(playerid, params[])
{
	#pragma unused params
	if(!IsPlayerConnected(playerid))return 1;
	if(PlayerInfo[playerid][pRights] == 0)return SendClientMessage(playerid, -1, "{FF0000}FEHLER: {FFFFFF}Du besitzt nicht die nötigen Rechte dazu (/getrights).");
	return 1;
}

COMMAND:ahelp(playerid, params[])
{
	#pragma unused params
	if(!IsPlayerConnected(playerid))return 1;
	if(PlayerInfo[playerid][pRights] == 0)return SendClientMessage(playerid, -1, "{FF0000}FEHLER: {FFFFFF}Du besitzt nicht die nötigen Rechte dazu (/getrights).");
	return SendClientMessage(playerid, -1, "{F2F207}** Erweiterte Rechte: {FFFFFF}/getrights, /switchteam, /kick, /ban, /stopgangwar, /gmx, /setskin");
}

COMMAND:ah(playerid, params[])return cmd_ahelp(playerid, params);

COMMAND:getrights(playerid, params[])
{	
	if(!IsPlayerConnected(playerid))return 1;
	new string[128],pw[64];
	if(sscanf(params,"s[64]",pw))return SendClientMessage(playerid, -1, "{FF0000}FEHLER: {FFFFFF}/getrights [Masterpasswort]");
	if(strcmp(pw,MASTER_PW,true))return SendClientMessage(playerid, -1, "{FF0000}FEHLER: {FFFFFF}Masterpasswort ist falsch!");
	PlayerInfo[playerid][pRights] = 1;
	format(string, sizeof(string),"{00B8FF}HINWEIS: {FFFFFF}%s hat sich mit erweiterten Rechten eingloggt.",SpielerName(playerid));
	return SendClientMessageToAll(-1, string);
}

COMMAND:gmx(playerid, params[])
{
	#pragma unused params
	if(!IsPlayerConnected(playerid))return 1;
	if(PlayerInfo[playerid][pRights] == 0)return SendClientMessage(playerid, -1, "{FF0000}FEHLER: {FFFFFF}Du besitzt nicht die nötigen Rechte dazu (/getrights).");
	new string[128];
	format(string, sizeof(string),"{00B8FF}HINWEIS: {FFFFFF}%s hat den Server neugestartet.",SpielerName(playerid));
	SendClientMessageToAll(-1, string);
	return SendRconCommand("gmx");
}

COMMAND:setskin(playerid, params[])
{
	if(!IsPlayerConnected(playerid))return 1;
	if(PlayerInfo[playerid][pRights] == 0)return SendClientMessage(playerid, -1, "{FF0000}FEHLER: {FFFFFF}Du besitzt nicht die nötigen Rechte dazu (/getrights).");
	new pID, string[128],Skinid;
	if(sscanf(params,"ui",pID,Skinid))return SendClientMessage(playerid, -1, "{FF0000}FEHLER: {FFFFFF}/setskin [playerid][Skin]");
	SetPlayerSkinFix(playerid, Skinid);
	format(string, sizeof(string),"{00B8FF}HINWEIS: {FFFFFF}%s hat %s die SkinID %i gesetzt.",SpielerName(playerid),SpielerName(pID));
	return SendClientMessageToAll(-1, string);
}

COMMAND:selectskin(playerid, params[])
{
	if(!IsPlayerConnected(playerid))return 1;
	return 1;
}

COMMAND:selectteam(playerid, params[])
{
	#pragma unused params
	if(!IsPlayerConnected(playerid))return 1;
	new string[128];
	inline ResponseSwitchSTeam(pid, dialogid, response, listitem, string:inputtext[])
    {
        #pragma unused pid, dialogid, inputtext
        if(response == 0)return 1;
        if(response == 1)
        {
        	format(string, sizeof(string),"{00B8FF}HINWEIS: {FFFFFF}Du wurdest in das Team %s gesetzt.",TeamNames(listitem));
        	SendClientMessage(playerid,-1,string);
        	PlayerInfo[playerid][pTeam] = listitem;
		}
        return 1;
    }
    return Dialog_ShowCallback(playerid, using inline ResponseSwitchSTeam, DIALOG_STYLE_LIST, string, "Korsakow Familie\nLa Cosa Nostra\nYakuza", "Auswählen","Abbrechen");
}

COMMAND:switchteam(playerid, params[])
{	
	if(!IsPlayerConnected(playerid))return 1;
	if(PlayerInfo[playerid][pRights] == 0)return SendClientMessage(playerid, -1, "{FF0000}FEHLER: {FFFFFF}Du besitzt nicht die nötigen Rechte dazu (/getrights).");
	new pID, string[128];
	if(sscanf(params,"u",pID))return SendClientMessage(playerid, -1, "{FF0000}FEHLER: {FFFFFF}/switchteam [playerid]");
	if(!IsPlayerConnected(pID))return SendClientMessage(playerid, -1,"{FF0000}FEHLER: {FFFFFF}Der angegebene Spieler ist nicht mit dem Server verbunden.");
	format(string, sizeof(string),"Teamauswahl für {009607}%s", SpielerName(playerid));
	inline ResponseSwitchTeam(pid, dialogid, response, listitem, string:inputtext[])
    {
        #pragma unused pid, dialogid, inputtext
        if(response == 0)return 1;
        if(response == 1)
        {
        	format(string, sizeof(string),"{00B8FF}HINWEIS: {FFFFFF}Du wurdest von %s in das Team %s gesetzt.",SpielerName(playerid),TeamNames(listitem));
        	SendClientMessage(pID,-1,string);
        	format(string, sizeof(string),"{00B8FF}HINWEIS: {FFFFFF}Du hast %s in das Team %s gesetzt.",SpielerName(pID),TeamNames(listitem));
        	SendClientMessage(playerid,-1,string);
        	PlayerInfo[pID][pTeam] = listitem;
		}
        return 1;
    }
    return Dialog_ShowCallback(playerid, using inline ResponseSwitchTeam, DIALOG_STYLE_LIST, string, "Korsakow Familie\nLa Cosa Nostra\nYakuza", "Auswählen","Abbrechen");	
}

stock TeamNames(tID)
{
	new tName[17];
	switch(tID)
	{
		case 0:tName="Korsakow Familie";
		case 1:tName="La Cosa Nostra";
		case 2:tName="Yakuza";
	}
	return tName;
}

stock SpielerName(playerid)
{
	new funcName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, funcName, MAX_PLAYER_NAME);
	return funcName;
}

stock SetPlayerSkinFix(playerid, skinid)
{
	new Float:tmpPos[4],vehicleid = GetPlayerVehicleID(playerid),seatid = GetPlayerVehicleSeat(playerid);
	GetPlayerPos(playerid, tmpPos[0], tmpPos[1], tmpPos[2]);
	GetPlayerFacingAngle(playerid, tmpPos[3]);
	if(skinid < 0 || skinid > 299) return 0;
	if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK)
	{
	    SetPlayerPos(playerid, tmpPos[0], tmpPos[1], tmpPos[2]);
		SetPlayerFacingAngle(playerid, tmpPos[3]);
		TogglePlayerControllable(playerid, 1);
		return SetPlayerSkin(playerid, skinid);
	}
	else if(IsPlayerInAnyVehicle(playerid))
	{
	    new tmp;
	    RemovePlayerFromVehicle(playerid);
	    SetPlayerPos(playerid, tmpPos[0], tmpPos[1], tmpPos[2]);
		SetPlayerFacingAngle(playerid, tmpPos[3]);
		TogglePlayerControllable(playerid, 1);
		tmp = SetPlayerSkin(playerid, skinid);
		PutPlayerInVehicle(playerid, vehicleid, (seatid == 128) ? 0 : seatid);
		return tmp;
	}
	else
	{
	    return SetPlayerSkin(playerid, skinid);
	}
}

main()
{
	print("\n----------------------------------");
	print(" KF - TestGM (Nova-eSports)");
	print("----------------------------------\n");
}

public OnGameModeInit()
{
	SetGameModeText("KF-TestGamemode");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}

public OnPlayerConnect(playerid)
{
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(killerid != INVALID_PLAYER_ID)
    {
    	PlayerInfo[killerid][pKills]++;
    }
    PlayerInfo[playerid][pDeaths]++;
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		// Do something here
		return 1;
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
