{

  Hello World server in Delphi
  Binds REP socket to tcp://*:5555
  Expects "Hello" from client, replies with "World"

  Translated from the original C code from the ZeroMQ Guide.

}
program hwclient;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  zmq;

var
  context: Pointer;
  requester: Pointer;
  request_nbr: Integer;
  request: zmq_msg_t;
  reply: zmq_msg_t;

begin
  context := zmq_init(1);

  //  Socket to talk to server
  Writeln('Connecting to hello world server');
  requester := zmq_socket(context, ZMQ_REQ);
  zmq_connect(requester, 'tcp://localhost:5555');

  for request_nbr := 0 to 9 do
  begin
    zmq_msg_init_size(request, 5);
    StrLCopy(zmq_msg_data(request), 'Hello', 5);
    Writeln('Sending Hello ', request_nbr);
    zmq_send(requester, request, 0);
    zmq_msg_close(request);

    zmq_msg_init(reply);
    zmq_recv(requester, reply, 0);
    Writeln('Received World ', request_nbr);
    zmq_msg_close(reply);
  end;

  zmq_close (requester);
  zmq_term (context);
end.
