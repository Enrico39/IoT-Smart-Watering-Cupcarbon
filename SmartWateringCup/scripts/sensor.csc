# --- SENSOR LOGIC ---

# Activation Thresholds Variables
# T > 28°C triggers irrigation, P < 5mm/h allows irrigation
set th_T 28
set th_P 5

# State Variable: Tracks the last sent command (0 or 1)
# Prevents sending redundant messages and saves battery
set lastDecision 0

loop
    # Sensing 
    areadsensor raw
    print raw    

    # Initialize local variables to a control value (99) 
    # This helps detect if a specific sensor reading failed
    set my_temp 99
    set my_rain 99
    
    if(raw != "X")
        rdata raw type id1 v1 id2 v2
        # Mapping GAS ID 
        if(id1 == 0)
            set my_temp v1
        end
        if(id1 == 1)
            set my_rain v1
        end
        if(id2 == 0)
            set my_temp v2
        end
        if(id2 == 1)
            set my_rain v2
        end

        # Check validity: Proceed only if both sensors responded (value != 99)
        if((my_temp != 99) && (my_rain != 99))
            
            # LOGIC: High Temperature AND Low Rain required to Water
            if((my_temp > th_T) && (my_rain < th_P))
                data msg 1
                cprint "Decision: WATER ON (T:" my_temp ", P:" my_rain ")"
            else
                data msg  0
                cprint "Decision: WATER OFF (T:" my_temp ", P:" my_rain ")"
            end
            
            # Send command ONLY if the state has changed
	    if (lastDecision != msg)
                set lastDecision msg	
                send msg 
                cprint " - Decision sent"
            else
                cprint " - Decision NOT sent."
	    end
         else
            cprint "T or P are missing (T:" my_temp ", P:" my_rain ")"  
        end
    end

    delay 5000
