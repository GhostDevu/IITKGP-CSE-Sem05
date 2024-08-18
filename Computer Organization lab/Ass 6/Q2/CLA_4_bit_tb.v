#! /opt/homebrew/Cellar/icarus-verilog/12.0/bin/vvp
:ivl_version "12.0 (stable)";
:ivl_delay_selection "TYPICAL";
:vpi_time_precision - 12;
:vpi_module "/opt/homebrew/Cellar/icarus-verilog/12.0/lib/ivl/system.vpi";
:vpi_module "/opt/homebrew/Cellar/icarus-verilog/12.0/lib/ivl/vhdl_sys.vpi";
:vpi_module "/opt/homebrew/Cellar/icarus-verilog/12.0/lib/ivl/vhdl_textio.vpi";
:vpi_module "/opt/homebrew/Cellar/icarus-verilog/12.0/lib/ivl/v2005_math.vpi";
:vpi_module "/opt/homebrew/Cellar/icarus-verilog/12.0/lib/ivl/va_math.vpi";
S_0x11fe04080 .scope module, "CLA_4_bit_tb" "CLA_4_bit_tb" 2 4;
 .timescale -9 -12;
v0x600002a5aeb0_0 .var "a", 3 0;
v0x600002a5af40_0 .var "b", 3 0;
v0x600002a5afd0_0 .var "cin", 0 0;
v0x600002a5b060_0 .net "cout", 0 0, L_0x60000295d2c0;  1 drivers
v0x600002a5b0f0_0 .net "s", 3 0, L_0x60000295dc20;  1 drivers
S_0x11fe041f0 .scope module, "uut" "CLA_4_bit" 2 13, 3 1 0, S_0x11fe04080;
 .timescale 0 0;
    .port_info 0 /OUTPUT 4 "s";
    .port_info 1 /OUTPUT 1 "cout";
    .port_info 2 /INPUT 1 "cin";
    .port_info 3 /INPUT 4 "a";
    .port_info 4 /INPUT 4 "b";
L_0x6000033580e0 .functor AND 1, L_0x60000295c000, L_0x60000295c0a0, C4<1>, C4<1>;
L_0x600003358150 .functor AND 1, L_0x60000295c140, L_0x60000295c1e0, C4<1>, C4<1>;
L_0x6000033581c0 .functor AND 1, L_0x60000295c280, L_0x60000295c320, C4<1>, C4<1>;
L_0x600003358230 .functor AND 1, L_0x60000295c460, L_0x60000295c500, C4<1>, C4<1>;
L_0x6000033582a0 .functor XOR 1, L_0x60000295c5a0, L_0x60000295c640, C4<0>, C4<0>;
L_0x600003358380 .functor XOR 1, L_0x60000295c6e0, L_0x60000295c780, C4<0>, C4<0>;
L_0x600003358310 .functor XOR 1, L_0x60000295c820, L_0x60000295c8c0, C4<0>, C4<0>;
L_0x6000033583f0 .functor XOR 1, L_0x60000295ca00, L_0x60000295caa0, C4<0>, C4<0>;
L_0x600003358460 .functor AND 1, L_0x60000295cc80, v0x600002a5afd0_0, C4<1>, C4<1>;
L_0x6000033584d0 .functor OR 1, L_0x60000295cb40, L_0x600003358460, C4<0>, C4<0>;
L_0x600003358540 .functor AND 1, L_0x60000295ce60, v0x600002a5afd0_0, C4<1>, C4<1>;
L_0x6000033585b0 .functor OR 1, L_0x60000295cdc0, L_0x600003358540, C4<0>, C4<0>;
L_0x600003358620 .functor AND 1, L_0x60000295cbe0, L_0x6000033585b0, C4<1>, C4<1>;
L_0x600003358700 .functor OR 1, L_0x60000295cd20, L_0x600003358620, C4<0>, C4<0>;
L_0x600003358770 .functor AND 1, L_0x60000295d220, v0x600002a5afd0_0, C4<1>, C4<1>;
L_0x600003358690 .functor OR 1, L_0x60000295d180, L_0x600003358770, C4<0>, C4<0>;
L_0x6000033587e0 .functor AND 1, L_0x60000295d0e0, L_0x600003358690, C4<1>, C4<1>;
L_0x600003358850 .functor OR 1, L_0x60000295d040, L_0x6000033587e0, C4<0>, C4<0>;
L_0x6000033588c0 .functor AND 1, L_0x60000295cfa0, L_0x600003358850, C4<1>, C4<1>;
L_0x600003358930 .functor OR 1, L_0x60000295cf00, L_0x6000033588c0, C4<0>, C4<0>;
L_0x6000033589a0 .functor AND 1, L_0x60000295d860, v0x600002a5afd0_0, C4<1>, C4<1>;
L_0x600003358a10 .functor OR 1, L_0x60000295d7c0, L_0x6000033589a0, C4<0>, C4<0>;
L_0x600003358a80 .functor AND 1, L_0x60000295d720, L_0x600003358a10, C4<1>, C4<1>;
L_0x600003358af0 .functor OR 1, L_0x60000295d680, L_0x600003358a80, C4<0>, C4<0>;
L_0x600003358b60 .functor AND 1, L_0x60000295d5e0, L_0x600003358af0, C4<1>, C4<1>;
L_0x600003358bd0 .functor OR 1, L_0x60000295d540, L_0x600003358b60, C4<0>, C4<0>;
L_0x600003358c40 .functor AND 1, L_0x60000295d4a0, L_0x600003358bd0, C4<1>, C4<1>;
L_0x600003358cb0 .functor OR 1, L_0x60000295d400, L_0x600003358c40, C4<0>, C4<0>;
L_0x600003358d20 .functor XOR 1, L_0x60000295d900, v0x600002a5afd0_0, C4<0>, C4<0>;
L_0x600003358d90 .functor XOR 1, L_0x60000295d9a0, L_0x60000295da40, C4<0>, C4<0>;
L_0x600003358e00 .functor XOR 1, L_0x60000295dae0, L_0x60000295db80, C4<0>, C4<0>;
L_0x600003358e70 .functor XOR 1, L_0x60000295dcc0, L_0x60000295dd60, C4<0>, C4<0>;
v0x600002a58000_0 .net "C", 3 0, L_0x60000295d360;  1 drivers
v0x600002a58090_0 .net "G", 3 0, L_0x60000295c3c0;  1 drivers
v0x600002a58120_0 .net "P", 3 0, L_0x60000295c960;  1 drivers
v0x600002a581b0_0 .net *"_ivl_101", 0 0, L_0x60000295d040;  1 drivers
v0x600002a58240_0 .net *"_ivl_103", 0 0, L_0x60000295d0e0;  1 drivers
v0x600002a582d0_0 .net *"_ivl_105", 0 0, L_0x60000295d180;  1 drivers
v0x600002a58360_0 .net *"_ivl_107", 0 0, L_0x60000295d220;  1 drivers
v0x600002a583f0_0 .net *"_ivl_108", 0 0, L_0x600003358770;  1 drivers
v0x600002a58480_0 .net *"_ivl_11", 0 0, L_0x60000295c140;  1 drivers
v0x600002a58510_0 .net *"_ivl_110", 0 0, L_0x600003358690;  1 drivers
v0x600002a585a0_0 .net *"_ivl_112", 0 0, L_0x6000033587e0;  1 drivers
v0x600002a58630_0 .net *"_ivl_114", 0 0, L_0x600003358850;  1 drivers
v0x600002a586c0_0 .net *"_ivl_116", 0 0, L_0x6000033588c0;  1 drivers
v0x600002a58750_0 .net *"_ivl_118", 0 0, L_0x600003358930;  1 drivers
v0x600002a587e0_0 .net *"_ivl_124", 0 0, L_0x60000295d400;  1 drivers
v0x600002a58870_0 .net *"_ivl_126", 0 0, L_0x60000295d4a0;  1 drivers
v0x600002a58900_0 .net *"_ivl_128", 0 0, L_0x60000295d540;  1 drivers
v0x600002a58990_0 .net *"_ivl_13", 0 0, L_0x60000295c1e0;  1 drivers
v0x600002a58a20_0 .net *"_ivl_130", 0 0, L_0x60000295d5e0;  1 drivers
v0x600002a58ab0_0 .net *"_ivl_132", 0 0, L_0x60000295d680;  1 drivers
v0x600002a58b40_0 .net *"_ivl_134", 0 0, L_0x60000295d720;  1 drivers
v0x600002a58bd0_0 .net *"_ivl_136", 0 0, L_0x60000295d7c0;  1 drivers
v0x600002a58c60_0 .net *"_ivl_138", 0 0, L_0x60000295d860;  1 drivers
v0x600002a58cf0_0 .net *"_ivl_139", 0 0, L_0x6000033589a0;  1 drivers
v0x600002a58d80_0 .net *"_ivl_14", 0 0, L_0x600003358150;  1 drivers
v0x600002a58e10_0 .net *"_ivl_141", 0 0, L_0x600003358a10;  1 drivers
v0x600002a58ea0_0 .net *"_ivl_143", 0 0, L_0x600003358a80;  1 drivers
v0x600002a58f30_0 .net *"_ivl_145", 0 0, L_0x600003358af0;  1 drivers
v0x600002a58fc0_0 .net *"_ivl_147", 0 0, L_0x600003358b60;  1 drivers
v0x600002a59050_0 .net *"_ivl_149", 0 0, L_0x600003358bd0;  1 drivers
v0x600002a590e0_0 .net *"_ivl_151", 0 0, L_0x600003358c40;  1 drivers
v0x600002a59170_0 .net *"_ivl_153", 0 0, L_0x600003358cb0;  1 drivers
v0x600002a59200_0 .net *"_ivl_160", 0 0, L_0x60000295d900;  1 drivers
v0x600002a59290_0 .net *"_ivl_161", 0 0, L_0x600003358d20;  1 drivers
v0x600002a59320_0 .net *"_ivl_166", 0 0, L_0x60000295d9a0;  1 drivers
v0x600002a593b0_0 .net *"_ivl_168", 0 0, L_0x60000295da40;  1 drivers
v0x600002a59440_0 .net *"_ivl_169", 0 0, L_0x600003358d90;  1 drivers
v0x600002a594d0_0 .net *"_ivl_174", 0 0, L_0x60000295dae0;  1 drivers
v0x600002a59560_0 .net *"_ivl_176", 0 0, L_0x60000295db80;  1 drivers
v0x600002a595f0_0 .net *"_ivl_177", 0 0, L_0x600003358e00;  1 drivers
v0x600002a59680_0 .net *"_ivl_183", 0 0, L_0x60000295dcc0;  1 drivers
v0x600002a59710_0 .net *"_ivl_185", 0 0, L_0x60000295dd60;  1 drivers
v0x600002a597a0_0 .net *"_ivl_186", 0 0, L_0x600003358e70;  1 drivers
v0x600002a59830_0 .net *"_ivl_19", 0 0, L_0x60000295c280;  1 drivers
v0x600002a598c0_0 .net *"_ivl_21", 0 0, L_0x60000295c320;  1 drivers
v0x600002a59950_0 .net *"_ivl_22", 0 0, L_0x6000033581c0;  1 drivers
v0x600002a599e0_0 .net *"_ivl_28", 0 0, L_0x60000295c460;  1 drivers
v0x600002a59a70_0 .net *"_ivl_3", 0 0, L_0x60000295c000;  1 drivers
v0x600002a59b00_0 .net *"_ivl_30", 0 0, L_0x60000295c500;  1 drivers
v0x600002a59b90_0 .net *"_ivl_31", 0 0, L_0x600003358230;  1 drivers
v0x600002a59c20_0 .net *"_ivl_36", 0 0, L_0x60000295c5a0;  1 drivers
v0x600002a59cb0_0 .net *"_ivl_38", 0 0, L_0x60000295c640;  1 drivers
v0x600002a59d40_0 .net *"_ivl_39", 0 0, L_0x6000033582a0;  1 drivers
v0x600002a59dd0_0 .net *"_ivl_44", 0 0, L_0x60000295c6e0;  1 drivers
v0x600002a59e60_0 .net *"_ivl_46", 0 0, L_0x60000295c780;  1 drivers
v0x600002a59ef0_0 .net *"_ivl_47", 0 0, L_0x600003358380;  1 drivers
v0x600002a59f80_0 .net *"_ivl_5", 0 0, L_0x60000295c0a0;  1 drivers
v0x600002a5a010_0 .net *"_ivl_52", 0 0, L_0x60000295c820;  1 drivers
v0x600002a5a0a0_0 .net *"_ivl_54", 0 0, L_0x60000295c8c0;  1 drivers
v0x600002a5a130_0 .net *"_ivl_55", 0 0, L_0x600003358310;  1 drivers
v0x600002a5a1c0_0 .net *"_ivl_6", 0 0, L_0x6000033580e0;  1 drivers
v0x600002a5a250_0 .net *"_ivl_61", 0 0, L_0x60000295ca00;  1 drivers
v0x600002a5a2e0_0 .net *"_ivl_63", 0 0, L_0x60000295caa0;  1 drivers
v0x600002a5a370_0 .net *"_ivl_64", 0 0, L_0x6000033583f0;  1 drivers
v0x600002a5a400_0 .net *"_ivl_69", 0 0, L_0x60000295cb40;  1 drivers
v0x600002a5a490_0 .net *"_ivl_71", 0 0, L_0x60000295cc80;  1 drivers
v0x600002a5a520_0 .net *"_ivl_72", 0 0, L_0x600003358460;  1 drivers
v0x600002a5a5b0_0 .net *"_ivl_74", 0 0, L_0x6000033584d0;  1 drivers
v0x600002a5a640_0 .net *"_ivl_79", 0 0, L_0x60000295cd20;  1 drivers
v0x600002a5a6d0_0 .net *"_ivl_81", 0 0, L_0x60000295cbe0;  1 drivers
v0x600002a5a760_0 .net *"_ivl_83", 0 0, L_0x60000295cdc0;  1 drivers
v0x600002a5a7f0_0 .net *"_ivl_85", 0 0, L_0x60000295ce60;  1 drivers
v0x600002a5a880_0 .net *"_ivl_86", 0 0, L_0x600003358540;  1 drivers
v0x600002a5a910_0 .net *"_ivl_88", 0 0, L_0x6000033585b0;  1 drivers
v0x600002a5a9a0_0 .net *"_ivl_90", 0 0, L_0x600003358620;  1 drivers
v0x600002a5aa30_0 .net *"_ivl_92", 0 0, L_0x600003358700;  1 drivers
v0x600002a5aac0_0 .net *"_ivl_97", 0 0, L_0x60000295cf00;  1 drivers
v0x600002a5ab50_0 .net *"_ivl_99", 0 0, L_0x60000295cfa0;  1 drivers
v0x600002a5abe0_0 .net "a", 3 0, v0x600002a5aeb0_0;  1 drivers
v0x600002a5ac70_0 .net "b", 3 0, v0x600002a5af40_0;  1 drivers
v0x600002a5ad00_0 .net "cin", 0 0, v0x600002a5afd0_0;  1 drivers
v0x600002a5ad90_0 .net "cout", 0 0, L_0x60000295d2c0;  alias, 1 drivers
v0x600002a5ae20_0 .net "s", 3 0, L_0x60000295dc20;  alias, 1 drivers
L_0x60000295c000 .part v0x600002a5aeb0_0, 0, 1;
L_0x60000295c0a0 .part v0x600002a5af40_0, 0, 1;
L_0x60000295c140 .part v0x600002a5aeb0_0, 1, 1;
L_0x60000295c1e0 .part v0x600002a5af40_0, 1, 1;
L_0x60000295c280 .part v0x600002a5aeb0_0, 2, 1;
L_0x60000295c320 .part v0x600002a5af40_0, 2, 1;
L_0x60000295c3c0 .concat8 [ 1 1 1 1], L_0x6000033580e0, L_0x600003358150, L_0x6000033581c0, L_0x600003358230;
L_0x60000295c460 .part v0x600002a5aeb0_0, 3, 1;
L_0x60000295c500 .part v0x600002a5af40_0, 3, 1;
L_0x60000295c5a0 .part v0x600002a5aeb0_0, 0, 1;
L_0x60000295c640 .part v0x600002a5af40_0, 0, 1;
L_0x60000295c6e0 .part v0x600002a5aeb0_0, 1, 1;
L_0x60000295c780 .part v0x600002a5af40_0, 1, 1;
L_0x60000295c820 .part v0x600002a5aeb0_0, 2, 1;
L_0x60000295c8c0 .part v0x600002a5af40_0, 2, 1;
L_0x60000295c960 .concat8 [ 1 1 1 1], L_0x6000033582a0, L_0x600003358380, L_0x600003358310, L_0x6000033583f0;
L_0x60000295ca00 .part v0x600002a5aeb0_0, 3, 1;
L_0x60000295caa0 .part v0x600002a5af40_0, 3, 1;
L_0x60000295cb40 .part L_0x60000295c3c0, 0, 1;
L_0x60000295cc80 .part L_0x60000295c960, 0, 1;
L_0x60000295cd20 .part L_0x60000295c3c0, 1, 1;
L_0x60000295cbe0 .part L_0x60000295c960, 1, 1;
L_0x60000295cdc0 .part L_0x60000295c3c0, 0, 1;
L_0x60000295ce60 .part L_0x60000295c960, 0, 1;
L_0x60000295cf00 .part L_0x60000295c3c0, 2, 1;
L_0x60000295cfa0 .part L_0x60000295c960, 2, 1;
L_0x60000295d040 .part L_0x60000295c3c0, 1, 1;
L_0x60000295d0e0 .part L_0x60000295c960, 1, 1;
L_0x60000295d180 .part L_0x60000295c3c0, 0, 1;
L_0x60000295d220 .part L_0x60000295c960, 0, 1;
L_0x60000295d360 .concat8 [ 1 1 1 1], L_0x6000033584d0, L_0x600003358700, L_0x600003358930, L_0x600003358cb0;
L_0x60000295d400 .part L_0x60000295c3c0, 3, 1;
L_0x60000295d4a0 .part L_0x60000295c960, 3, 1;
L_0x60000295d540 .part L_0x60000295c3c0, 2, 1;
L_0x60000295d5e0 .part L_0x60000295c960, 2, 1;
L_0x60000295d680 .part L_0x60000295c3c0, 1, 1;
L_0x60000295d720 .part L_0x60000295c960, 1, 1;
L_0x60000295d7c0 .part L_0x60000295c3c0, 0, 1;
L_0x60000295d860 .part L_0x60000295c960, 0, 1;
L_0x60000295d2c0 .part L_0x60000295d360, 3, 1;
L_0x60000295d900 .part L_0x60000295c960, 0, 1;
L_0x60000295d9a0 .part L_0x60000295c960, 1, 1;
L_0x60000295da40 .part L_0x60000295d360, 0, 1;
L_0x60000295dae0 .part L_0x60000295c960, 2, 1;
L_0x60000295db80 .part L_0x60000295d360, 1, 1;
L_0x60000295dc20 .concat8 [ 1 1 1 1], L_0x600003358d20, L_0x600003358d90, L_0x600003358e00, L_0x600003358e70;
L_0x60000295dcc0 .part L_0x60000295c960, 3, 1;
L_0x60000295dd60 .part L_0x60000295d360, 2, 1;
    .scope S_0x11fe04080;
T_0 ;
    %vpi_call 2 22 "$dumpfile", "CLA_4_bit.vcd" {0 0 0};
    %vpi_call 2 23 "$dumpvars", 32'sb00000000000000000000000000000000, S_0x11fe04080 {0 0 0};
    %vpi_call 2 24 "$monitor", $time, "\011\011a = %d, b = %d, cin = %b, sum = %d, cout = %b \012", v0x600002a5aeb0_0, v0x600002a5af40_0, v0x600002a5afd0_0, v0x600002a5b0f0_0, v0x600002a5b060_0 {0 0 0};
    %pushi/vec4 0, 0, 4;
    %store/vec4 v0x600002a5aeb0_0, 0, 4;
    %pushi/vec4 0, 0, 4;
    %store/vec4 v0x600002a5af40_0, 0, 4;
    %pushi/vec4 0, 0, 1;
    %store/vec4 v0x600002a5afd0_0, 0, 1;
    %delay 100000, 0;
    %pushi/vec4 5, 0, 4;
    %store/vec4 v0x600002a5aeb0_0, 0, 4;
    %pushi/vec4 1, 0, 4;
    %store/vec4 v0x600002a5af40_0, 0, 4;
    %pushi/vec4 0, 0, 1;
    %store/vec4 v0x600002a5afd0_0, 0, 1;
    %delay 100000, 0;
    %pushi/vec4 3, 0, 4;
    %store/vec4 v0x600002a5aeb0_0, 0, 4;
    %pushi/vec4 2, 0, 4;
    %store/vec4 v0x600002a5af40_0, 0, 4;
    %pushi/vec4 1, 0, 1;
    %store/vec4 v0x600002a5afd0_0, 0, 1;
    %delay 100000, 0;
    %pushi/vec4 11, 0, 4;
    %store/vec4 v0x600002a5aeb0_0, 0, 4;
    %pushi/vec4 1, 0, 4;
    %store/vec4 v0x600002a5af40_0, 0, 4;
    %pushi/vec4 0, 0, 1;
    %store/vec4 v0x600002a5afd0_0, 0, 1;
    %delay 100000, 0;
    %pushi/vec4 12, 0, 4;
    %store/vec4 v0x600002a5aeb0_0, 0, 4;
    %pushi/vec4 3, 0, 4;
    %store/vec4 v0x600002a5af40_0, 0, 4;
    %pushi/vec4 0, 0, 1;
    %store/vec4 v0x600002a5afd0_0, 0, 1;
    %delay 100000, 0;
    %pushi/vec4 15, 0, 4;
    %store/vec4 v0x600002a5aeb0_0, 0, 4;
    %pushi/vec4 1, 0, 4;
    %store/vec4 v0x600002a5af40_0, 0, 4;
    %pushi/vec4 0, 0, 1;
    %store/vec4 v0x600002a5afd0_0, 0, 1;
    %delay 100000, 0;
    %pushi/vec4 11, 0, 4;
    %store/vec4 v0x600002a5aeb0_0, 0, 4;
    %pushi/vec4 12, 0, 4;
    %store/vec4 v0x600002a5af40_0, 0, 4;
    %pushi/vec4 0, 0, 1;
    %store/vec4 v0x600002a5afd0_0, 0, 1;
    %delay 100000, 0;
    %end;
    .thread T_0;
# The file index is used to find the file name in the following table.
:file_names 4;
    "N/A";
    "<interactive>";
    "CLA_4_bit_tb.v";
    "./CLA_4_bit.v";
