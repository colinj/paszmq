object frmClient: TfrmClient
  Left = 0
  Top = 0
  Caption = 'Hello World Client - Demo 4'
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
  DesignSize = (
    416
    244)
  PixelsPerInch = 96
  TextHeight = 13
  object btnDemo1: TButton
    Left = 16
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Demo 1'
    TabOrder = 0
    OnClick = btnDemo1Click
  end
  object Memo1: TMemo
    Left = 120
    Top = 16
    Width = 281
    Height = 220
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object edtName: TLabeledEdit
    Left = 16
    Top = 32
    Width = 75
    Height = 21
    EditLabel.Width = 27
    EditLabel.Height = 13
    EditLabel.Caption = 'Name'
    TabOrder = 2
    Text = 'Fred'
  end
end
