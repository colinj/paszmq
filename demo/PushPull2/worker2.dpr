//
//  Task worker - Design 2
//  Connects PULL socket to tcp://localhost:5557
//  Collects workloads from ventilator via that socket
//  Connects PUSH socket to tcp://localhost:5558
//  Sends results to sink via that socket
//
//  Adds pub-sub flow to receive and respond to kill signal
//
//  Translated from the original C code from the ZeroMQ Guide.
//
program worker2;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  zmq,
  zhelper;

var
  Context: Pointer;
  Receiver: Pointer;
  Sender: Pointer;
  Controller: Pointer;
  Msg: string;
  Items: array[0..1] of zmq_pollitem_t;

begin
  Context := zmq_init(1);

  //  Socket to receive messages on
  Receiver := zmq_socket(Context, ZMQ_PULL);
  zmq_connect(Receiver, 'tcp://localhost:5557');

  //  Socket to send messages to
  Sender := zmq_socket(Context, ZMQ_PUSH);
  zmq_connect(Sender, 'tcp://localhost:5558');

  //  Socket for control input
  Controller := zmq_socket(Context, ZMQ_SUB);
  zmq_connect(Controller, 'tcp://localhost:5559');
  zmq_setsockopt(Controller, ZMQ_SUBSCRIBE, PAnsiChar(''), 0);

  //  Process messages from receiver and controller
  Items[0].socket := Receiver;
  Items[0].fd := 0;
  Items[0].events := ZMQ_POLLIN;
  Items[0].revents := 0;

  Items[1].socket := Controller;
  Items[1].fd := 0;
  Items[1].events := ZMQ_POLLIN;
  Items[1].revents := 0;

  //  Process messages from both sockets
  while True do
  begin
    zmq_poll(@Items[0], 2, -1);

    if (Items[0].revents and ZMQ_POLLIN) <> 0 then
    begin
      Msg := s_recv(Receiver);

      // Do the work
      Sleep(StrToInt(Msg));

      // Send result to sink
      s_send(Sender, '');

      //  Simple progress indicator for the viewer
      Write('.');
    end;

    //  Any waiting controller command acts as 'KILL'
    if (Items[1].revents and ZMQ_POLLIN) <> 0 then
      Break; // Exit loop
  end;

  Writeln;
  Writeln('Worker stopped.');

  // Finished.
  zmq_close(Receiver);
  zmq_close(Sender);
  zmq_close(Controller);
  zmq_term(Context);
end.
