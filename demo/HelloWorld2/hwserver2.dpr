{

  Hello World server in Delphi
  Binds REP socket to tcp://*:5555
  Expects "Hello" from client, replies with "World"

  Translated from the original C code from the ZeroMQ Guide.

}
program hwserver2;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  zmq,
  zhelper;

var
  context: Pointer;
  responder: Pointer;
  msg: string;

begin
  context := zmq_init(1);

  //  Socket to talk to clients

  responder := zmq_socket(context, ZMQ_REP);
  zmq_bind(responder, 'tcp://*:5555');

  while True do
  begin
    //  Wait for next request from client
    msg := s_recv(responder);
    Writeln('Received: ', msg);

    //  Do some 'work'
    Sleep (1);

    //  Send reply back to client
    s_send(responder, 'World');
  end;

  //  We never get here but if we did, this would be how we end
  zmq_close(responder);
  zmq_term(context);
end.
