# --- SPRINKLER NODE ---

# variables for console printing
atget id myid
set last_cmd 3
loop
    # Check messages and extract the Command Value
    receive msg    
    rdata msg cmd 
    
    # ON/OFF Control Logic
    if(cmd != "X")
	if(cmd != last_cmd)
            set last_cmd cmd
	    # CASE: OPEN VALVE (Water ON)
            if(cmd == 1)
           	mark 1
            	cprint ">>>Sprinkler " myid ": IRRIGATION ON <<<"
            end
        
	    # CASE: CLOSE VALVE (Water OFF)
            if(cmd == 0)
            	mark 0
            	cprint ">>>Sprinkler " myid ": IRRIGATION OFF <<<"
            end
	end
    else
        # Error handling for empty or corrupted packets
        cprint "ERRORE: Empty Variable!"
    end
delay 200