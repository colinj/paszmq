object frmServer: TfrmServer
  Left = 0
  Top = 0
  Caption = 'Hello World Server'
  ClientHeight = 244
  ClientWidth = 416
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    416
    244)
  PixelsPerInch = 96
  TextHeight = 13
  object edtPort: TLabeledEdit
    Left = 16
    Top = 32
    Width = 75
    Height = 21
    EditLabel.Width = 20
    EditLabel.Height = 13
    EditLabel.Caption = 'Port'
    NumbersOnly = True
    TabOrder = 0
    Text = '5555'
  end
  object btnStart: TButton
    Left = 16
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 1
    OnClick = btnStartClick
  end
  object btnStop: TButton
    Left = 16
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 2
    OnClick = btnStopClick
  end
  object Memo1: TMemo
    Left = 120
    Top = 16
    Width = 281
    Height = 220
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssVertical
    TabOrder = 3
  end
end
