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
  zmq,
  zhelper;

var
  context: Pointer;
  requester: Pointer;
  request_nbr: Integer;
  msg: string;

begin
  context := zmq_init(1);

  //  Socket to talk to server
  Writeln('Connecting to hello world server');
  requester := zmq_socket(context, ZMQ_REQ);
  zmq_connect(requester, 'tcp://localhost:5555');

  for request_nbr := 0 to 20 do
  begin
    msg := Format('Hello %d from %s', [request_nbr, ParamStr(1)]);
    Writeln('Sending... ', msg);
    s_send(requester, msg);

    msg := s_recv(requester);
    Writeln('Received ', request_nbr, msg);
    Sleep(200);
  end;

  zmq_close (requester);
  zmq_term (context);
end.
