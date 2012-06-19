//
//  Task ventilator
//  Binds PUSH socket to tcp://localhost:5557
//  Sends batch of tasks to workers via that socket
//
//  Translated from the original C code from the ZeroMQ Guide.
//
program ventilator;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  zmq,
  zhelper;

var
  Context: Pointer;
  Sender: Pointer;
  Sink: Pointer;
  I: Integer;
  TotalMSec: Integer;
  WorkLoad: Integer;

begin
  Context := zmq_init(1);

  //  Socket to send messages on
  Sender := zmq_socket(Context, ZMQ_PUSH);
  zmq_bind(Sender, 'tcp://*:5557');

  //  Socket to send start of batch message on
  Sink := zmq_socket(Context, ZMQ_PUSH);
  zmq_connect(Sink, 'tcp://localhost:5558');

  Writeln('Press Enter when the workers are ready: ');
  Readln;
  Writeln('Sending tasks to workers…');

  //  The first message is '0' and signals start of batch
  s_send(Sink, '0');

  //  Initialize random number generator
  Randomize;

  //  Send 100 tasks
  TotalMSec := 0;
  for I := 1 to 100 do
  begin
    WorkLoad := Random(100) + 1;
    Inc(TotalMSec, WorkLoad);
    s_send(Sender, IntToStr(WorkLoad));
  end;

  Writeln(Format('Total expected cost: %d msec.', [TotalMSec]));
  Sleep(100);

  zmq_close(Sink);
  zmq_close(Sender);
  zmq_term(Context);
end.
