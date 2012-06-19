//
//  Task sink - Design 2
//  Binds PULL socket to tcp://localhost:5558
//  Collects results from workers via that socket
//
//  Adds pub-sub flow to send kill signal to workers when
//  all tasks are complete.
//
//  Translated from the original C code from the ZeroMQ Guide.
//
program sink2;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Windows,
  zmq,
  zhelper;

var
  Context: Pointer;
  Receiver: Pointer;
  Controller: Pointer;
  Msg: string;
  I: Integer;
  StartTime: Cardinal;
  StopTime: Cardinal;

begin
  Context := zmq_init(1);

  //  Socket to receive messages on
  Receiver := zmq_socket(Context, ZMQ_PULL);
  zmq_bind(Receiver, 'tcp://*:5558');

  //  Socket for worker control
  Controller := zmq_socket(Context, ZMQ_PUB);
  zmq_bind(Controller, 'tcp://*:5559');

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

  //  Send kill signal to workers
  s_send(Controller, 'KILL');

  //  Finished
  sleep (100); //  Give 0MQ time to deliver

  zmq_close(Receiver);
  zmq_close(Controller);
  zmq_term(Context);
end.
