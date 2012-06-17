{

  Hello World server in Delphi
  Binds REP socket to tcp://*:5555
  Expects "Hello" from client, replies with "World"

  Translated from the original C code from the ZeroMQ Guide.

}
program hwserver;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  zmq;

var
  context: Pointer;
  responder: Pointer;
  request: zmq_msg_t;
  reply: zmq_msg_t;

begin
  context := zmq_init(1);

  //  Socket to talk to clients

  responder := zmq_socket(context, ZMQ_REP);
  zmq_bind(responder, 'tcp://*:5555');

  while True do
  begin
    //  Wait for next request from client
    zmq_msg_init(request);
    zmq_recv(responder, request, 0);
    Writeln('Received Hello');
    zmq_msg_close(request);

    //  Do some 'work'
    Sleep (1);

    //  Send reply back to client
    zmq_msg_init_size(reply, 5);
    StrLCopy(zmq_msg_data(reply), 'World', 5);
    zmq_send(responder, reply, 0);
    zmq_msg_close(reply);
  end;

  //  We never get here but if we did, this would be how we end
  zmq_close(responder);
  zmq_term(context);
end.
