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
    constructor Create(aCreateSuspended: Boolean; const aPort: Integer = 5560); overload;
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
  Location: string;
  rc: Integer;
begin
  Synchronize(
    procedure
    begin
      frmServer.Memo1.Lines.Add('Server started.');
    end);

  TimeOut := 50;
  Context := zmq_init(1);

  //  Socket to talk to clients

  Location := 'tcp://localhost:' + IntToStr(FPort);

  Responder := zmq_socket(context, ZMQ_REP);
  try
    zmq_setsockopt(Responder, ZMQ_RCVTIMEO, @TimeOut, SizeOf(Integer));
    rc := zmq_connect(Responder, PAnsiChar(AnsiString(Location)));
        Synchronize(
          procedure
          begin
            frmServer.Memo1.Lines.Add('Return value: ' + IntToStr(rc));
          end);

    while not Terminated do
    begin
      //  Wait for next request from client
      Msg := s_recv(Responder);

      if Msg <> '' then
      begin
        Synchronize(
          procedure
          begin
            frmServer.Memo1.Lines.Add('Received: ' + Msg);
          end);

        //  Do some 'work'
        Sleep (500);

        //  Send reply back to client
        s_send(Responder, 'World');
      end;
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
