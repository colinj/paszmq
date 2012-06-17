unit uServerThread;

interface

uses
  SysUtils,
  Classes;

type
  TServerThread = class(TThread)
  private
    FPort: Integer;
  protected
    procedure Execute; override;
  public
    constructor Create(aCreateSuspended: Boolean; const aPort: Integer = 5555); overload;
    property Port: Integer read FPort write FPort;
  end;

implementation

uses
  fmServer,
  zmq, zhelper;

{ TServerThread }

constructor TServerThread.Create(aCreateSuspended: Boolean; const aPort: Integer);
begin
  FPort := aPort;
  FreeOnTerminate := True;
  inherited Create(aCreateSuspended);
end;

procedure TServerThread.Execute;
var
  Context: Pointer;
  Responder: Pointer;
  Msg: string;
  TimeOut: Integer;
  Location: AnsiString;
begin
  Synchronize(
    procedure
    begin
      frmServer.Memo1.Lines.Add('Server started.');
    end);

  TimeOut := 1000;
  Context := zmq_init(1);

  //  Socket to talk to clients

  Location := 'tcp://*:' + AnsiString(IntToStr(FPort));

  Responder := zmq_socket(context, ZMQ_REP);
  try
    zmq_setsockopt(Responder, ZMQ_RCVTIMEO, @TimeOut, SizeOf(Integer));
    zmq_bind(responder, PAnsiChar(Location));

    while not Terminated do
    begin
      //  Wait for next request from client
      Msg := s_recv(responder);

      if Msg <> '' then
      begin
        Synchronize(
          procedure
          begin
            frmServer.Memo1.Lines.Add('Received: ' + Msg);
          end);
      end;

      //  Do some 'work'
      Sleep (10);

      //  Send reply back to client
      s_send(Responder, 'World');
    end;
  finally
    //  Close connection
    zmq_close(Responder);
    zmq_term(Context);

    Synchronize(
      procedure
      begin
        frmServer.Memo1.Lines.Add('Server stopped.');
      end);
  end;
end;

end.
