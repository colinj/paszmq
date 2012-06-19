//
//  Hello World client in Delphi
//  Connects REQ socket to tcp://localhost:5555
//  Sends "Hello" to server, expects a reply with "World"
//
//  Translated from the original C code from the ZeroMQ Guide.
//
program hwclient2;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  zmq,
  zhelper;

var
  Context: Pointer;
  Requestor: Pointer;
  Msg: string;
  I: Integer;

begin
  Context := zmq_init(1);

  //  Socket to talk to server
  Writeln('Connecting to hello world server');
  Requestor := zmq_socket(Context, ZMQ_REQ);
  zmq_connect(Requestor, 'tcp://localhost:5555');

  for I := 0 to 20 do
  begin
    Msg := Format('Hello %d from %s', [I, ParamStr(1)]);
    Writeln('Sending... ', Msg);
    s_send(Requestor, Msg);

    Msg := s_recv(Requestor);
    Writeln('Received ', I, Msg);
    Sleep(200);
  end;

  zmq_close (Requestor);
  zmq_term (Context);
end.
