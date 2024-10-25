inherited DialogMsgForm: TDialogMsgForm
  Caption = #1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077
  ClientHeight = 90
  ClientWidth = 433
  OldCreateOrder = True
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  ExplicitWidth = 449
  ExplicitHeight = 129
  PixelsPerInch = 96
  TextHeight = 14
  inherited bbPanel: TPanel
    Top = 49
    Width = 433
    ExplicitTop = 49
    ExplicitWidth = 433
    inherited bbOk: TBitBtn
      Left = 35
      Default = False
      ExplicitLeft = 35
    end
    inherited bbCancel: TBitBtn
      Left = 148
      Default = True
      Kind = bkCustom
      ExplicitLeft = 148
    end
  end
  object PanelMsg: TPanel
    Left = 0
    Top = 0
    Width = 433
    Height = 49
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 6
    object MemoMsg: TMemo
      Left = 0
      Top = 0
      Width = 433
      Height = 49
      Align = alClient
      Alignment = taCenter
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      Lines.Strings = (
        'MemoMsg')
      ReadOnly = True
      TabOrder = 0
      ExplicitTop = 6
    end
  end
end
