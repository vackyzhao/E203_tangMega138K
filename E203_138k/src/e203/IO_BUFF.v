module IOBUF (
    output  O,   //Buffer output

    inout   IO,  //Buffer inout port

    input   I,   //Buffer input

    input   T    //3-state enable input, high=input, low=output
);

// low     I  ----> IO
// hight   IO ----> O


assign O  = (T) ? IO : 1'bz;
assign IO = (~T)? I  : 1'bz;

endmodule