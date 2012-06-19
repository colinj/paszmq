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
  Context: Pointer;
  Responder: Pointer;
  Request: zmq_msg_t;
  Reply: zmq_msg_t;

begin
  Context := zmq_init(1);

  //  Socket to talk to clients

  Responder := zmq_socket(Context, ZMQ_REP);
  zmq_bind(Responder, 'tcp://*:5555');

  while True do
  begin
    //  Wait for next Request from client
    zmq_msg_init(Request);
    zmq_recv(Responder, Request, 0);
    Writeln('Received Hello');
    zmq_msg_close(Request);

    //  Do some 'work'
    Sleep (1);

    //  Send Reply back to client
    zmq_msg_init_size(Reply, 5);
    StrLCopy(zmq_msg_data(Reply), 'World', 5);
    zmq_send(Responder, Reply, 0);
    zmq_msg_close(Reply);
  end;

  //  We never get here but if we did, this would be how we end
  zmq_close(Responder);
  zmq_term(Context);
end.
