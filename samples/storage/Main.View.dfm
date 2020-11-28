object MainView: TMainView
  Left = 0
  Top = 0
  Caption = 'StorageApp'
  ClientHeight = 238
  ClientWidth = 605
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
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
    Width = 177
    Height = 25
    Caption = 'Save'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 295
    Top = 91
    Width = 194
    Height = 25
    Caption = 'Load'
    TabOrder = 3
    OnClick = Button2Click
  end
end
