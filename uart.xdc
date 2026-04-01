#create_clock -period 10 [get_ports wr_clk]
#create_clock -period 20 [get_ports rd_clk]

#set_clock_groups -asynchronous \
#-group [get_clocks wr_clk] \
#-group [get_clocks rd_clk]

## Switches
#set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports {data_in[0]}]
#set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports {data_in[1]}]
#set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33 } [get_ports {data_in[2]}]
#set_property -dict { PACKAGE_PIN W17   IOSTANDARD LVCMOS33 } [get_ports {data_in[3]}]
#set_property -dict { PACKAGE_PIN W15   IOSTANDARD LVCMOS33 } [get_ports {data_in[4]}]
#set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports {data_in[5]}]
#set_property -dict { PACKAGE_PIN W14   IOSTANDARD LVCMOS33 } [get_ports {data_in[6]}]
#set_property -dict { PACKAGE_PIN W13   IOSTANDARD LVCMOS33 } [get_ports {data_in[7]}]

#set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports wr_enb]
#set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports rd_enb]

## LEDs
#set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports {data_out[0]}]
#set_property -dict { PACKAGE_PIN E19   IOSTANDARD LVCMOS33 } [get_ports {data_out[1]}]
#set_property -dict { PACKAGE_PIN U19   IOSTANDARD LVCMOS33 } [get_ports {data_out[2]}]
#set_property -dict { PACKAGE_PIN V19   IOSTANDARD LVCMOS33 } [get_ports {data_out[3]}]
#set_property -dict { PACKAGE_PIN W18   IOSTANDARD LVCMOS33 } [get_ports {data_out[4]}]
#set_property -dict { PACKAGE_PIN U15   IOSTANDARD LVCMOS33 } [get_ports {data_out[5]}]
#set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports {data_out[6]}]
#set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports {data_out[7]}]

##status
#set_property -dict { PACKAGE_PIN V13   IOSTANDARD LVCMOS33 } [get_ports {full}]
#set_property -dict { PACKAGE_PIN V3    IOSTANDARD LVCMOS33 } [get_ports {empty}]

# --- Board clock (100 MHz on Basys3) ---
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
#create_clock -period 10.000 -name sys_clk [get_ports clk]

# --- Reset (Centre button on Basys3) ---
set_property PACKAGE_PIN U18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

# --- Inputs (Switches) ---
set_property PACKAGE_PIN V17 [get_ports {data_in[0]}]
set_property PACKAGE_PIN V16 [get_ports {data_in[1]}]
set_property PACKAGE_PIN W16 [get_ports {data_in[2]}]
set_property PACKAGE_PIN W17 [get_ports {data_in[3]}]
set_property PACKAGE_PIN W15 [get_ports {data_in[4]}]
set_property PACKAGE_PIN V15 [get_ports {data_in[5]}]
set_property PACKAGE_PIN W14 [get_ports {data_in[6]}]
set_property PACKAGE_PIN W13 [get_ports {data_in[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[*]}]

# --- wr_enb (Button Left) ---
set_property PACKAGE_PIN W19 [get_ports wr_enb]
set_property IOSTANDARD LVCMOS33 [get_ports wr_enb]

# --- rd_enb (Button Right) ---
set_property PACKAGE_PIN T17 [get_ports rd_enb]
set_property IOSTANDARD LVCMOS33 [get_ports rd_enb]

# --- Outputs (LEDs) ---
set_property PACKAGE_PIN U16 [get_ports {data_out[0]}]
set_property PACKAGE_PIN E19 [get_ports {data_out[1]}]
set_property PACKAGE_PIN U19 [get_ports {data_out[2]}]
set_property PACKAGE_PIN V19 [get_ports {data_out[3]}]
set_property PACKAGE_PIN W18 [get_ports {data_out[4]}]
set_property PACKAGE_PIN U15 [get_ports {data_out[5]}]
set_property PACKAGE_PIN U14 [get_ports {data_out[6]}]
set_property PACKAGE_PIN V14 [get_ports {data_out[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_out[*]}]

# --- full LED ---
set_property PACKAGE_PIN V13 [get_ports full]
set_property IOSTANDARD LVCMOS33 [get_ports full]

# --- empty LED ---
set_property PACKAGE_PIN V3  [get_ports empty]
set_property IOSTANDARD LVCMOS33 [get_ports empty]

# --- clk_wiz_0 handles wr_clk and rd_clk internally ---
# DO NOT add create_clock for wr_clk or rd_clk here