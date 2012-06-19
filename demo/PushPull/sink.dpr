//
//  Task sink
//  Binds PULL socket to tcp://localhost:5558
//  Collects results from workers via that socket
//
//  Translated from the original C code from the ZeroMQ Guide.
//
program sink;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Windows,
  zmq,
  zhelper;

var
  Context: Pointer;
  Receiver: Pointer;
  Msg: string;
  I: Integer;
  StartTime: Cardinal;
  StopTime: Cardinal;

begin
  Context := zmq_init(1);

  //  Socket to receive messages on
  Receiver := zmq_socket(Context, ZMQ_PULL);
  zmq_bind(Receiver, 'tcp://*:5558');

  //  Wait for start of batch
  Msg := s_recv(Receiver);

  //  Start our clock now
  StartTime := GetTickCount;

  //  Process 100 confirmations
  for I := 1 to 100 do
  begin
    Msg := s_recv(Receiver);

    if (I mod 10) = 0 then
      Write(':')
    else
      Write('.');
  end;
  StopTime := GetTickCount;
  Writeln;

  //  Calculate and report duration of batch
  Writeln(Format('Total elapsed time: %d msec', [StopTime - StartTime]));

  zmq_close(Receiver);
  zmq_term(Context);
end.
