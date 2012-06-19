unit uBrokerThread;

interface

uses
  SysUtils,
  Classes;

type
  TBrokerThread = class(TThread)
  private
    FFrontEnd: Integer;
    FBackEnd: Integer;
  protected
    procedure Execute; override;
  public
    constructor Create(aCreateSuspended: Boolean; const aFront, aBack: Integer); overload;
    property FrontEnd: Integer read FFrontEnd write FFrontEnd;
    property BackEnd: Integer read FBackEnd write FBackEnd;
  end;

implementation

uses
  zmq;

{ TServerThread }

constructor TBrokerThread.Create(aCreateSuspended: Boolean; const aFront, aBack: Integer);
begin
  FFrontEnd := aFront;
  FBackEnd := aBack;
  FreeOnTerminate := True;
  inherited Create(aCreateSuspended);
end;

procedure TBrokerThread.Execute;
var
  Context: Pointer;
  FrontSocket: Pointer;
  BackSocket: Pointer;
  FrontLoc: AnsiString;
  BackLoc: AnsiString;
begin
  FrontLoc := 'tcp://*:' + AnsiString(IntToStr(FFrontEnd));
  BackLoc := 'tcp://*:' + AnsiString(IntToStr(FBackEnd));

  Context := zmq_init(1);

  // Socket facing clients
  FrontSocket := zmq_socket(Context, ZMQ_ROUTER);
  zmq_bind(FrontSocket, PAnsiChar(FrontLoc));

  // Socket facing services
  BackSocket := zmq_socket(Context, ZMQ_DEALER);
  zmq_bind(BackSocket, PAnsiChar(BackLoc));

  // Start built-in device
  zmq_device(ZMQ_QUEUE, FrontSocket, BackSocket);

  //  Close connection (we never get here).
  zmq_close(FrontSocket);
  zmq_close(BackSocket);
  zmq_term(Context);
end;

end.
