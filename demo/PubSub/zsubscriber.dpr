//
//  Pubsub envelope subscriber
//
//  Translated from the original C code from the ZeroMQ Guide.
//
program zsubscriber;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  zmq,
  zhelper;

var
  Context: Pointer;
  Subscriber: Pointer;
  Key: AnsiString;
  Topic: string;
  Msg: string;

begin
  Key := AnsiString(ParamStr(1));

  Context := zmq_init(1);

  //  Socket to talk to server
  Writeln('Connecting to hello world server');
  Subscriber := zmq_socket(Context, ZMQ_SUB);
  zmq_connect(Subscriber, 'tcp://localhost:5563');
  zmq_setsockopt(Subscriber, ZMQ_SUBSCRIBE, PAnsiChar(Key), Length(Key));

  while True do
  begin
    // Read the message topic.
    Topic := s_recv(Subscriber);

    // Read the content of the message.
    Msg := s_recv(Subscriber);

    Writeln(Format('%s - %s', [Topic, Msg]));
  end;

  zmq_close(Subscriber);
  zmq_term(Context);
end.
