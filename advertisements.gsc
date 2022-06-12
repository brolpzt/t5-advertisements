#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
   
	if (!isDefined(game["mc_current_msg"]))
		game["mc_current_msg"] = 1;
		       
    thread messages();
    level thread onplayerconnect();
}

onplayerconnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onplayerspawned();
    }
}

onplayerspawned()
{
    self welcome();
}

welcome()
{
	self endon("disconnect");
    self waittill("spawned_player");
    
	if (!isDefined(getDvarInt("sv_welcome")) || getDvarInt("sv_welcome") != 1)
		return;
		
	if (isDefined(self.pers["welcomed"]))
		return;
        
	wait 0.05;
    
	for (i=1; i<4; i++)
	{	
		message = getDvar("sv_welcomemessage" + i);
		self iprintlnbold(message);
        wait 3;
	}
	self.pers["welcomed"] = 1;
}

messages() 
{
	first_message = true;
    
    if(getdvar("sv_messagesdelay") == "")
    	setdvar("sv_messagesdelay", "20");
    generic_delay = 20;
    
    if (getdvar("sv_maxmessages") == "")
		setdvar("sv_maxmessages" , 20);
    
    message_start = game["mc_current_msg"];
    while (1) {
    	max = getdvarint("sv_maxmessages") + 1;
        for (i=message_start;i<max;i++) {
        	game["sv_current_msg"] = i;
            if (getdvar("sv_message" + i) == "") {
				wait 0.05;
				continue;
			} else {
            	message = getdvar("sv_message" + i);
                if (getdvar("sv_messagesdelay" + i) == "") {
                	if (generic_delay != getdvarint("sv_messagesdelay")) {
                    	generic_delay = getdvarint("sv_messagesdelay");
                        
                        if (generic_delay < 5) {
                        	setdvar("sv_messagesdelay" , 5);
                            generic_delay = 5;
                        }
                    }
                    delay = generic_delay;
                } else {
                	delay = getdvarint("sv_messagesdelay" + i);
                    if (delay < 0)
                    	delay = 0;
                }
                
                if (!isDefined(message)) {
                	wait 0.05;
					continue;
                }
                
                if (!first_message)
					wait delay;
				else
					first_message = false;
                    
				iprintln(message);
            }
        }
        
        message_start = 1;
		game["mc_current_msg"] = 1;

		loopdelay = getdvarint("sv_messagesdelay");
		if (loopdelay < 5)
		{
			setdvar("sv_messagesdelay" , 5);
			loopdelay = 5;
		}
		wait loopdelay;
    }
}
