//
//  Simple message queuing broker
//  Same as request-reply broker but using QUEUE device
//
//  Translated from the original C code from the ZeroMQ Guide.
//
program rrBroker;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  zmq;

var
  Context: Pointer;
  FrontSocket: Pointer;
  BackSocket: Pointer;
  FrontEnd: AnsiString;
  BackEnd: AnsiString;

begin
  if ParamStr(1) = '' then
    FrontEnd := '5559'
  else
    FrontEnd := AnsiString(ParamStr(1));

  if ParamStr(2) = '' then
    BackEnd := '5560'
  else
    BackEnd := AnsiString(ParamStr(2));

  FrontEnd := 'tcp://127.0.0.1:' + FrontEnd;
  BackEnd := 'tcp://127.0.0.1:' + BackEnd;

  Context := zmq_init(1);

  // Socket facing clients
  FrontSocket := zmq_socket(Context, ZMQ_ROUTER);
  zmq_bind(FrontSocket, PAnsiChar(FrontEnd));

  // Socket facing services
  BackSocket := zmq_socket(Context, ZMQ_DEALER);
  zmq_bind(BackSocket, PAnsiChar(BackEnd));

  // Start built-in device
  zmq_device(ZMQ_QUEUE, FrontSocket, BackSocket);

  //  Close connection (we never get here).
  zmq_close(FrontSocket);
  zmq_close(BackSocket);
  zmq_term(Context);
end.
