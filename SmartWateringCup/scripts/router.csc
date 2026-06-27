# --- ROUTER NODE ---

# Memory Variable: Stores the last relayed packet
# Initialized to a dummy value (3) 
set last_msg 3

loop    
    receive packet

    # Check: Is this a new message?
    # If not, it's an echo -> DROP IT
    if (packet != last_msg)
       # Forwarding and Updating mamory
       send packet 
       set last_msg packet    
   end

delay 100
