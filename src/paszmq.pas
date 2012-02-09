{
    Copyright (c) 2007-2011 iMatix Corporation
    Copyright (c) 2007-2011 Other contributors as noted in the AUTHORS file

    This file is part of 0MQ.

    0MQ is free software; you can redistribute it and/or modify it under
    the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation; either version 3 of the License, or
    (at your option) any later version.

    0MQ is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
}
unit paszmq;

interface

uses SysUtils, Classes, zmq;

type
  TFreeProc = zmq_free_fn;

  EZMQException = class(Exception)
  private
    FErrNum: Integer;
  public
    constructor CreateErr;
    property Errnum: Integer read FErrNum;
  end;

  TZMQMessage = class(TObject)
  private
    FMessage: zmq_msg_t;
    function GetData: Pointer;
    function GetSize: Cardinal;
  public
    constructor Create; overload;
    constructor Create(aSize: Cardinal); overload;
    constructor Create(aData: Pointer; aSize: Cardinal; aFreeProc: TFreeProc; const aHint: Pointer); overload;
    destructor Destroy; override;
    procedure Rebuild; overload;
    procedure Rebuild(aSize: Cardinal); overload;
    constructor Rebuild(aData: Pointer; aSize: Cardinal; aFreeProc: TFreeProc; const aHint: Pointer); overload;
    procedure Move(var aMsg: TZMQMessage);
    procedure Copy(var aMsg: TZMQMessage);
    property Data: Pointer read GetData;
    property Size: Cardinal read GetSize;
  end;

  TZMQContext = class(TObject)
  private
    FContext: Pointer;
  public
    constructor Create(aIOThreads: Integer);
    destructor Destroy; override;
    property Ptr: Pointer read FContext;
  end;

  TZMQSocket = class(TObject)
  private
    FSocket: Pointer;
  public
    constructor Create(aContext: TZMQContext; aType: Integer);
    destructor Destroy; override;
    procedure Close;
    procedure SetSocketOpt(aOption: Integer; const aOptVal: Pointer; aOptValLength: Cardinal);
    procedure GetSocketOpt(aOption: Integer; aOptVal: Pointer; var aOptValLength: Cardinal);
    procedure Bind(const aAddr: string);
    procedure Connect(const aAddr: string);
    function Send(aMsg: TZMQMessage; aFlags: Integer): Boolean;
    function Receive(var aMsg: TZMQMessage; aFlags: Integer): Boolean;
    property Ptr: Pointer read FSocket;
  end;

  function ZMQPoll(var aItems: TZmqPollitemT; nItems: Integer; const aTimeout: Integer = -1): Integer;
  procedure ZMQDevice(aDevice: Integer; aInSocket, aOutSocket: TZMQSocket);
  procedure ZMQVersion(var aMajor, aMinor, aPatch: Integer);

implementation

const
// <errno.h>
  EAGAIN = 16;

function ZMQPoll(var aItems: TZmqPollitemT; nItems: Integer; const aTimeout: Integer = -1): Integer;
begin
  Result := zmq_poll(aItems, nItems, aTimeout);

  if Result < 0 then
    raise EZMQException.CreateErr;
end;

procedure ZMQDevice(aDevice: Integer; aInSocket, aOutSocket: TZMQSocket);
begin
  if zmq_device(aDevice, aInSocket.FSocket, aOutSocket.FSocket) <> 0 then
    raise EZMQException.CreateErr;
end;

procedure ZMQVersion(var aMajor, aMinor, aPatch: Integer);
begin
  zmq_version(aMajor, aMinor, aPatch);
end;

{ EZMQError }

constructor EZMQException.CreateErr;
begin
  FErrNum := zmq_errno;

  inherited Create(String(zmq_strerror(FErrNum)));
end;

{ TZMQMessage }

procedure TZMQMessage.Copy(var aMsg: TZMQMessage);
begin
  if zmq_msg_copy(FMessage, aMsg.FMessage) <> 0 then
    raise EZMQException.CreateErr;
end;

constructor TZMQMessage.Create;
begin
  inherited;
  if zmq_msg_init(FMessage) <> 0 then
    raise EZMQException.CreateErr;
end;

constructor TZMQMessage.Create(aData: Pointer; aSize: Cardinal; aFreeProc: TFreeProc; const aHint: Pointer);
begin
  inherited Create;
  if zmq_msg_init_data(FMessage, aData, aSize, aFreeProc, aHint) <> 0 then
    raise EZMQException.CreateErr;
end;

constructor TZMQMessage.Create(aSize: Cardinal);
begin
  inherited Create;
  if zmq_msg_init_size(FMessage, aSize) <> 0 then
    raise EZMQException.CreateErr;
end;

destructor TZMQMessage.Destroy;
var
  rc: Integer;
begin
  rc := zmq_msg_close(FMessage);
  Assert(rc = 0);
  inherited;
end;

function TZMQMessage.GetData: Pointer;
begin
  Result := zmq_msg_data(FMessage);
end;

function TZMQMessage.GetSize: Cardinal;
begin
  Result := zmq_msg_size(FMessage);
end;

procedure TZMQMessage.Move(var aMsg: TZMQMessage);
begin
  if zmq_msg_move(FMessage, aMsg.FMessage) <> 0 then
    raise EZMQException.CreateErr;
end;

constructor TZMQMessage.Rebuild(aData: Pointer; aSize: Cardinal; aFreeProc: TFreeProc; const aHint: Pointer);
begin
  if zmq_msg_close(FMessage) <> 0 then
    raise EZMQException.CreateErr;

  if zmq_msg_init_data(FMessage, aData, aSize, aFreeProc, aHint) <> 0 then
    raise EZMQException.CreateErr;
end;

procedure TZMQMessage.Rebuild;
begin
  if zmq_msg_close(FMessage) <> 0 then
    raise EZMQException.CreateErr;

  if zmq_msg_init(FMessage) <> 0 then
    raise EZMQException.CreateErr;
end;

procedure TZMQMessage.Rebuild(aSize: Cardinal);
begin
  if zmq_msg_close(FMessage) <> 0 then
    raise EZMQException.CreateErr;

  if zmq_msg_init_size(FMessage, aSize) <> 0 then
    raise EZMQException.CreateErr;
end;

{ TZMQContext }

constructor TZMQContext.Create(aIOThreads: Integer);
begin
  inherited Create;
  FContext := zmq_init(aIOThreads);
  if FContext = nil then
    raise EZMQException.CreateErr;
end;

destructor TZMQContext.Destroy;
var
  rc: Integer;
begin
  if FContext <> nil then
  begin
    rc := zmq_term(FContext);
    Assert(rc = 0);
  end;
  inherited;
end;

{ TZMQSocket }

procedure TZMQSocket.Bind(const aAddr: string);
var
  Address: PWideChar;
  StrLength: Integer;
begin
  StrLength := Length(aAddr) + 1;
  GetMem(Address, StrLength);
  StringToWideChar(aAddr, Address, StrLength);

  if zmq_bind(FSocket, Address) <> 0 then
    raise EZMQException.CreateErr;
end;

procedure TZMQSocket.Close;
begin
  if FSocket <> nil then
  begin
    if zmq_close(FSocket) <> 0 then
      raise EZMQException.CreateErr;
    FSocket := nil;
  end;
end;

procedure TZMQSocket.Connect(const aAddr: string);
var
  Address: PWideChar;
  StrLength: Integer;
begin
  StrLength := Length(aAddr) + 1;
  GetMem(Address, StrLength);
  StringToWideChar(aAddr, Address, StrLength);

  if zmq_connect(FSocket, Address) <> 0 then
    raise EZMQException.CreateErr;
end;

constructor TZMQSocket.Create(aContext: TZMQContext; aType: Integer);
begin
  inherited Create;
  FSocket := zmq_socket(aContext.Ptr, aType);
  if FSocket = nil then
    raise EZMQException.CreateErr;
end;

destructor TZMQSocket.Destroy;
begin
  Close;
  inherited;
end;

procedure TZMQSocket.GetSocketOpt(aOption: Integer; aOptVal: Pointer; var aOptValLength: Cardinal);
begin
  if zmq_getsockopt(FSocket, aOption, aOptVal, aOptValLength) <> 0 then
    raise EZMQException.CreateErr;
end;

function TZMQSocket.Receive(var aMsg: TZMQMessage; aFlags: Integer): Boolean;
var
  rc: Integer;
begin
  rc := zmq_recv(FSocket, aMsg.FMessage, aFlags);

  if rc = 0 then
    Result := True
  else
    if (rc = -1) and (zmq_errno = EAGAIN) then
      Result := False
    else
      raise EZMQException.CreateErr;
end;

function TZMQSocket.Send(aMsg: TZMQMessage; aFlags: Integer): Boolean;
var
  rc: Integer;
begin
  rc := zmq_send(FSocket, aMsg.FMessage, aFlags);

  if rc = 0 then
    Result := True
  else
    if (rc = -1) and (zmq_errno = EAGAIN) then
      Result := False
    else
      raise EZMQException.CreateErr;
end;

procedure TZMQSocket.SetSocketOpt(aOption: Integer; const aOptVal: Pointer; aOptValLength: Cardinal);
begin
  if zmq_setsockopt(FSocket, aOption, aOptVal, aOptValLength) <> 0 then
    raise EZMQException.CreateErr;
end;

end.
