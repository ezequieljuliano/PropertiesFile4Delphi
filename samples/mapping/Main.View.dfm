object MainView: TMainView
  Left = 0
  Top = 0
  Caption = 'MainView'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object EdtUsername: TEdit
    Left = 112
    Top = 64
    Width = 177
    Height = 21
    TabOrder = 0
  end
  object EdtPassword: TEdit
    Left = 295
    Top = 64
    Width = 194
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 112
    Top = 91
    Width = 377
    Height = 25
    Caption = 'Login'
    TabOrder = 2
    OnClick = Button1Click
  end
end
