unit zhelper;

interface

uses
  SysUtils, Classes, zmq;

function s_recv(aSocket: Pointer): string;
function s_send(aSocket: Pointer; s: string): Integer;
function s_sendmore(aSocket: Pointer; s: string): Integer;

implementation

//  Receive 0MQ string from socket and convert into Delphi string
//  Returns empty string if the context is being terminated.
function s_recv(aSocket: Pointer): string;
var
  Msg: zmq_msg_t;
  MsgSize: Integer;
  MsgData: Pointer;
  LBytes: TBytes;
begin
  zmq_msg_init(Msg);

  if zmq_recv(aSocket, Msg, 0) < 0 then
  begin
    Result := '';
  end
  else
  begin
    MsgSize := zmq_msg_size(Msg);
    MsgData := zmq_msg_data(Msg);
    SetLength(LBytes, MsgSize);
    System.Move(MsgData^, LBytes[0], MsgSize);
    Result := TEncoding.UTF8.GetString(LBytes, 0, MsgSize);
  end;
  zmq_msg_close(Msg);
end;

//  Convert string to 0MQ string and send to socket
function s_send(aSocket: Pointer; s: string): Integer;
var
  Msg: zmq_msg_t;
  MsgData: Pointer;
  LBytes: TBytes;
begin
  LBytes := TEncoding.UTF8.GetBytes(s);
  zmq_msg_init_size(Msg, Length(LBytes));
  MsgData := zmq_msg_data(Msg);
  System.Move(LBytes[0], MsgData^, Length(LBytes));
  Result := zmq_send(aSocket, Msg, 0);
  zmq_msg_close(Msg);
end;

//  Sends string as 0MQ string, as multipart non-terminal
function s_sendmore(aSocket: Pointer; s: string): Integer;
var
  Msg: zmq_msg_t;
  MsgData: Pointer;
  LBytes: TBytes;
begin
  LBytes := TEncoding.UTF8.GetBytes(s);
  zmq_msg_init_size(Msg, Length(LBytes));
  MsgData := zmq_msg_data(Msg);
  System.Move(LBytes[0], MsgData^, Length(LBytes));
  Result := zmq_send(aSocket, Msg, ZMQ_SNDMORE);
  zmq_msg_close(Msg);
end;

end.
