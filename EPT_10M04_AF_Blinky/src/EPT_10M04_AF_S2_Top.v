//#######################################################################
//#
//#	Copyright 	Earth People Technology Inc. 2017
//#
//#
//# File Name:  EPT_10M04_AF_S2_Top.v
//# Author:     Earth People Technology
//# Date:       January 15, 2017
//# Revision:   A
//#
//# Development: EPT Data Collection Project 
//# Application: Altera MAX10 FPGA
//# Description: This file contains verilog code which access
//#              the I/O's of the FPGA. 
//#               
//#              
//#
//#************************************************************************
//#
//# Revision History:	
//#			DATE		VERSION		DETAILS		
//#			1/15/17 	1			Created
//#
//#									
//#
//#######################################################################


//************************************************************************
//* Module Declaration
//************************************************************************

module EPT_10M04_AF_S2_Top (

	
	input  wire                CLK_50MHZ,
	input  wire                CLK_32KHZ,
	input  wire                RST,
	
	output wire                CLK_50MHZ_ENABLE,
	output wire                CLK_32KHZ_ENABLE,
	
	output wire   [7:0]        XIO_1,       //
	input  wire   [7:0]        XIO_2,       //
    input  wire   [7:0]        XIO_3,       //
	output wire   [8:0]        XIO_4,       //
	
	input wire                 PWR_ENABLE,
	
	
	output reg     [7:0]         LED
	);

   //-----------------------------------------------
   // Parameters
   //-----------------------------------------------
   
   //LED State Machine Parameters
   parameter                   IDLE = 0,
	                           SELECT_MODE = 1,
                               LOAD_REGISTER = 2,
                               LOAD_LEDS = 3,
                               WAIT_FOR_TIMER = 6;

   parameter                   GLOBAL_RESET_COUNT = 12'h9c8;
   
   //Control Register selections for the LED Blinky
   parameter                   RANDOM_NUMBER = 4'h1;
   parameter                   SHIFT_LEFT = 4'h2;
   parameter                   SHIFT_RIGHT = 4'h3;
   parameter                   COUNT_UP = 8'h8;
   parameter                   COUNT_DOWN = 8'h8;
   parameter                   STATIC_VALUE = 6'h6;
   
   //Timer Value Low Limit
   parameter                   TIMER_LOW_LIMIT = 24'h2625a0;
   
//***************************************************************************
//* Internal Signals and Registers Declarations
//***************************************************************************

	//Finite State Machine control registers
	reg 	[6:0]              state, next;

	reg [23:0]                 timer_value;	
	reg [7:0]                  seed_value;
	reg [23:0]                 led_delay_counter;
	reg                        start_blinky;
	reg [7:0]                  static_load_value;
	reg [7:0]                  led_reg;
	
	reg [7:0]                  shift_count_value;

`ifdef SIM
   reg [8*26:1] state_name;
`endif
	


//***************************************************************************
//* 	Signal Assignments	
//***************************************************************************

   //Clock and Reset
   //assign            CLK_50MHZ = aa[1];
   //assign            RST = reset;
   //assign            reset = reset_signal_reg;
   
   //Clock Enables
   assign            CLK_50MHZ_ENABLE  = 1'b1;
   assign            CLK_32KHZ_ENABLE = 1'b0;
   
   
   //Control Register Map
   assign            led_reset = XIO_2[0];
   
   //Test
   assign              XIO_1[0] = CLK_50MHZ;
   assign              XIO_1[1] = RST;
   assign              XIO_1[2] = 1'b0;
   assign              XIO_1[3] = 1'b0;
   assign              XIO_1[4] = 1'b1;
   assign              XIO_1[5] = 1'b0;
   assign              XIO_1[6] = 1'b0;
   assign              XIO_1[7] = 1'b0;
   
   assign              XIO_4[8] = 1'b1;
   assign              XIO_4[7] = 1'b0;
   assign              XIO_4[6] = 1'b0;
   assign              XIO_4[5] = 1'b0;
   assign              XIO_4[4] = 1'b0;
   assign              XIO_4[3] = 1'b0;
   assign              XIO_4[2] = 1'b0;
   assign              XIO_4[1] = 1'b0;
   assign              XIO_4[0] = 1'b0;
   
   //assign            LED[0] = 1'b0;
   //assign            LED[1] = 1'b1;
   //assign            LED[2] = 1'b0;
   //assign            LED[3] = 1'b1;
   
   
//**************************************************
//* 	Reset Signal	
//**************************************************
/*	always @(posedge CLK_50MHZ or negedge RST)
	begin
	  if(!RST)
	  begin
			reset_signal_reg <= 1'b0;
			reset_counter <= 0;
	  end
	  else
	  begin
		if( reset_counter < GLOBAL_RESET_COUNT )
		begin
			reset_signal_reg <= 1'b0;
			reset_counter <= reset_counter + 1'b1;
		end
		else
		begin
			reset_signal_reg <= 1'b1;
		end
	  end
	end
*/
   //-----------------------------------------------
   // Load Timer Value
   //-----------------------------------------------

  always @(posedge CLK_50MHZ or negedge RST)
  begin
    if(!RST)
	     timer_value <= TIMER_LOW_LIMIT;
	else 
	begin
	     //if(XIO_2[4])
	     //    timer_value[15:8] <= 8'h00;
	     //else if(XIO_2[5])
	     //    timer_value[23:16] <= 8'h80;
	end 
  end

   //-----------------------------------------------
   // LED Blinky start 
   //-----------------------------------------------
  always @(posedge CLK_50MHZ or negedge RST)
  begin
    if(!RST)
         start_blinky <= 1'b1;
	else 
	begin
	     start_blinky <= 1'b1;
	    //if(XIO_1[0] == 1'b1)
        //    start_blinky <= 1'b1;
		//else
        //    start_blinky <= 1'b0;		
 	end 
  end
 
   //-----------------------------------------------
   // LED Delay Timer Counter 
   //-----------------------------------------------
  always @(posedge CLK_50MHZ or negedge RST)
  begin
    if(!RST)
	     led_delay_counter <= TIMER_LOW_LIMIT;
	else 
	begin
	     if(state[SELECT_MODE])
		 led_delay_counter <= timer_value;
		 else if(state[WAIT_FOR_TIMER])
	         led_delay_counter <= led_delay_counter - 1'd1;
	end 
  end

   
   //-----------------------------------------------
   // Select the LED Function from the control
   // register bits 7 to 4   
   //-----------------------------------------------
  always @(posedge CLK_50MHZ or negedge RST)
  begin
    if(!RST)
	     led_reg <= 8'h1;
	else 
	begin
        if (state[SELECT_MODE])
	    begin
	         //case(XIO_2[7:4])
		     //  SHIFT_LEFT:
		          led_reg = shift_count_value;
		     //  SHIFT_RIGHT:
		     //     led_reg = shift_count_value;
		     //  COUNT_UP:
		     //     led_reg = shift_count_value;
		     //  COUNT_DOWN:
		     //     led_reg = shift_count_value;
		     //  STATIC_VALUE:
		    //      led_reg = static_load_value;
		    //   default:
		    //      led_reg = shift_count_value;
		    //  endcase 
        end	
    end
  end
  
   //-----------------------------------------------
   // Increment the Shift/Count value from the control
   // register bits 7 to 4   
   //-----------------------------------------------
  always @(posedge CLK_50MHZ or negedge RST)
  begin
    if(!RST)
	     shift_count_value <= 4'h1;
	else 
	begin
		if (state[LOAD_REGISTER])
	    begin
	         //case(XIO_4[7:4])
		     //SHIFT_LEFT:
			 //begin
		        shift_count_value[0] <= led_reg[7];
		        shift_count_value[7] <= led_reg[6];
		        shift_count_value[6] <= led_reg[5];
		        shift_count_value[5] <= led_reg[4];
		        shift_count_value[4] <= led_reg[3];
		        shift_count_value[3] <= led_reg[2];
		        shift_count_value[2] <= led_reg[1];
		        shift_count_value[1] <= led_reg[0];
		    // end
		    // SHIFT_RIGHT:
			// begin
		    //    shift_count_value[0] <= led_reg[1];
		    //    shift_count_value[3] <= led_reg[0];
		    //    shift_count_value[2] <= led_reg[3];
		    //    shift_count_value[1] <= led_reg[2];
		    // end
		    // COUNT_UP:
		    //    shift_count_value <= led_reg + 1'd1;
		    // COUNT_DOWN:
		    //    shift_count_value <= led_reg - 1'd1;
		    // default:
			// begin
		    //    shift_count_value[0] <= led_reg[3];
		    //    shift_count_value[3] <= led_reg[2];
		    //    shift_count_value[2] <= led_reg[1];
		    //    shift_count_value[1] <= led_reg[0];
		    // end
		    //endcase   
         end
	end 
  end

   //-----------------------------------------------
   // Set the LED outputs 
   //-----------------------------------------------
   always @(posedge CLK_50MHZ or negedge RST)
  begin
    if(!RST)
	     LED <= 8'hz;
	else 
	begin
	  //if(led_reset)
	   //  LED <= 4'hz;
	  //else 
	  if(state[LOAD_LEDS])
	  begin
		if ( led_reg[0] )
			LED[0] = 1'b0;
		else 
			LED[0] = 1'bz;
		if ( led_reg[1] )
			LED[1] = 1'b0;
		else 
			LED[1] = 1'bz;
 		if ( led_reg[2] )
			LED[2] = 1'b0;
		else 
			LED[2] = 1'bz;
		if ( led_reg[3] )
			LED[3] = 1'b0;
		else 
			LED[3] = 1'bz;
		if ( led_reg[4] )
			LED[4] = 1'b0;
		else 
			LED[4] = 1'bz;
		if ( led_reg[5] )
			LED[5] = 1'b0;
		else 
			LED[5] = 1'bz;
 		if ( led_reg[6] )
			LED[6] = 1'b0;
		else 
			LED[6] = 1'bz;
		if ( led_reg[7] )
			LED[7] = 1'b0;
		else 
			LED[7] = 1'bz;
	  end
	end
  end
  
    //-----------------------------------------------
   // State Machine: Send Pattern to LEDs 
   //-----------------------------------------------
   // Next State Logic
   always @(posedge CLK_50MHZ or negedge RST)
     begin
	if (!RST)
	  begin
	     state <= 7'h00;
	     state[IDLE] <= 1'b1;
	  end
	else
	  state <= next;
     end

     // State Definitions
   always @ ( state or  start_blinky or
		      led_reg or led_delay_counter or 
			  timer_value or shift_count_value) 
     begin
	     next = 7'h00;

	if (state[IDLE])
	  begin
	     if (start_blinky)
	       next[SELECT_MODE] = 1'b1;
	     else
	       next[IDLE] = 1'b1;
	  end
	
	if (state[SELECT_MODE])
	begin
           next[LOAD_REGISTER] = 1'b1;
	end

	if (state[LOAD_REGISTER])
	begin
        next[LOAD_LEDS] = 1'b1;
    end
		
	if (state[LOAD_LEDS])
	begin
        next[WAIT_FOR_TIMER] = 1'b1;
    end
	
	if (state[WAIT_FOR_TIMER])
		if (led_delay_counter <= timer_value)
			next[WAIT_FOR_TIMER] = 1'b1;
		else 
			next[SELECT_MODE] = 1'b1;

			
`ifdef SIM
 	   if ( state == ( 1 << IDLE ))
		   state_name = "IDLE";
	   else if ( state == ( 1 << SELECT_MODE ))
		   state_name = "SELECT_MODE";
	   else if ( state == ( 1 << LOAD_REGISTER ))
		   state_name = "LOAD_REGISTER";
	   else if ( state == ( 1 << LOAD_LEDS ))
		   state_name = "LOAD_LEDS";
	   else if ( state == ( 1 << WAIT_FOR_TIMER ))
		   state_name = "WAIT_FOR_TIMER";
`endif


	end//end of state machine

   

	
endmodule
