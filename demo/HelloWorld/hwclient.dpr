//
//  Hello World client in Delphi
//  Connects REQ socket to tcp://localhost:5555
//  Sends "Hello" to server, expect replies with "World"
//
//  Translated from the original C code from the ZeroMQ Guide.
//
program hwclient;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  zmq;

var
  Context: Pointer;
  Requestor: Pointer;
  I: Integer;
  Request: zmq_msg_t;
  Reply: zmq_msg_t;

begin
  Context := zmq_init(1);

  //  Socket to talk to server
  Writeln('Connecting to hello world server');
  Requestor := zmq_socket(Context, ZMQ_REQ);
  zmq_connect(Requestor, 'tcp://localhost:5555');

  for I := 0 to 9 do
  begin
    zmq_msg_init_size(Request, 5);
    StrLCopy(zmq_msg_data(Request), 'Hello', 5);
    Writeln('Sending Hello ', I);
    zmq_send(Requestor, Request, 0);
    zmq_msg_close(Request);

    zmq_msg_init(Reply);
    zmq_recv(Requestor, Reply, 0);
    Writeln('Received World ', I);
    zmq_msg_close(Reply);
  end;

  zmq_close(Requestor);
  zmq_term(Context);
end.
