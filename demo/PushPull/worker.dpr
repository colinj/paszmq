//
//  Task worker
//  Connects PULL socket to tcp://localhost:5557
//  Collects workloads from ventilator via that socket
//  Connects PUSH socket to tcp://localhost:5558
//  Sends results to sink via that socket
//
//  Translated from the original C code from the ZeroMQ Guide.
//
program worker;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  zmq,
  zhelper;

var
  Context: Pointer;
  Receiver: Pointer;
  Sender: Pointer;
  Msg: string;

begin
  Context := zmq_init(1);

  //  Socket to receive messages on
  Receiver := zmq_socket(Context, ZMQ_PULL);
  zmq_connect(Receiver, 'tcp://localhost:5557');

  //  Socket to send messages to
  Sender := zmq_socket(Context, ZMQ_PUSH);
  zmq_connect(Sender, 'tcp://localhost:5558');

  //  Process tasks forever
  while True do
  begin
    Msg := s_recv(Receiver);

    //  Simple progress indicator for the viewer
    Writeln(Msg);

    // Do the work
    Sleep(StrToInt(Msg));

    // Send result to sink
    s_send(Sender, '1');
  end;

  zmq_close(Receiver);
  zmq_close(Sender);
  zmq_term(Context);
end.
