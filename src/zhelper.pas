unit zhelper;

interface

uses
  SysUtils, Classes, zmq;

function s_recv(socket: Pointer): string;
function s_send(socket: Pointer; s: string): Integer;

implementation

function s_recv(socket: Pointer): string;
var
  msg: zmq_msg_t;
  msg_size: Integer;
  msg_data: Pointer;
  LBytes: TBytes;
begin
  zmq_msg_init(msg);

  if zmq_recv(socket, msg, 0) < 0 then
  begin
    Result := '';
  end
  else
  begin
    msg_size := zmq_msg_size(msg);
    msg_data := zmq_msg_data(msg);
    SetLength(LBytes, msg_size);
    System.Move(msg_data^, LBytes[0], msg_size);
    Result := TEncoding.Unicode.GetString(LBytes, 0, msg_size);
  end;
  zmq_msg_close(msg);
end;

function s_send(socket: Pointer; s: string): Integer;
var
  msg: zmq_msg_t;
  msg_data: Pointer;
  LBytes: TBytes;
begin
  LBytes := TEncoding.Unicode.GetBytes(s);
  zmq_msg_init_size(msg, Length(LBytes));
  msg_data := zmq_msg_data(msg);
  System.Move(LBytes[0], msg_data^, Length(LBytes));
  Result := zmq_send(socket, msg, 0);
  zmq_msg_close(msg);
end;

end.
