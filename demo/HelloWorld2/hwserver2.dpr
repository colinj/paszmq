//
//  Hello World server in Delphi
//  Binds REP socket to tcp://*:5555
//  Expects "Hello" from client, replies with "World"
//
//  Translated from the original C code from the ZeroMQ Guide.
//
program hwserver2;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  zmq,
  zhelper;

var
  Context: Pointer;
  Responder: Pointer;
  Msg: string;

begin
  Context := zmq_init(1);

  //  Socket to talk to clients
  Responder := zmq_socket(Context, ZMQ_REP);
  zmq_bind(Responder, 'tcp://*:5555');

  while True do
  begin
    //  Wait for next request from client
    Msg := s_recv(Responder);
    Writeln('Received: ', Msg);

    //  Do some 'work'
    Sleep (1);

    //  Send reply back to client
    s_send(Responder, 'World');
  end;

  //  We never get here but if we did, this would be how we end
  zmq_close(Responder);
  zmq_term(Context);
end.
