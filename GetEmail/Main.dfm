object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 205
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object BitBtn1: TBitBtn
    Left = 160
    Top = 136
    Width = 75
    Height = 25
    Caption = 'BitBtn1'
    TabOrder = 0
    OnClick = BitBtn1Click
  end
  object IdPOP3: TIdPOP3
    AutoLogin = True
    SASLMechanisms = <>
    Left = 224
    Top = 48
  end
  object IdMessage: TIdMessage
    AttachmentEncoding = 'UUE'
    BccList = <>
    CCList = <>
    Encoding = meDefault
    FromList = <
      item
      end>
    Recipients = <>
    ReplyTo = <>
    ConvertPreamble = True
    Left = 120
    Top = 40
  end
end
