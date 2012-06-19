//
//  Pubsub envelope publisher
//  Note that the zhelper.pas file also provides s_sendmore
//
//  Translated from the original C code from the ZeroMQ Guide.
//
program zpublisher;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  zmq,
  zhelper;

var
  Context: Pointer;
  Publisher: Pointer;
  Msg: string;
  Counter: Integer;
begin
  Counter := 0;
  Context := zmq_init(1);

  //  Socket to publish from
  Publisher := zmq_socket(Context, ZMQ_PUB);
  zmq_bind(Publisher, 'tcp://*:5563');

  // Add a pause, in order to allow subscribers time to establish connection with the publisher
  // otherwise early messages will be lost before subscribers have a chance to receive them.
  Sleep(1000);

  while True do
  begin
    Inc(Counter);
    s_sendmore(Publisher, 'A');
    s_send(Publisher, 'Only subscribers of ''A'' will see this. #' + IntToStr(Counter));

    Inc(Counter);
    s_sendmore(Publisher, 'B');
    s_send (Publisher, 'If you subscribe to ''B'' you will see this. #' + IntToStr(Counter));

    Sleep(100);
  end;

  //  We never get here but if we did, this would be how we end
  zmq_close(Publisher);
  zmq_term(Context);
end.
