object PriorityPauseForm: TPriorityPauseForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1054#1078#1080#1076#1072#1085#1080#1077' '#1086#1095#1077#1088#1077#1076#1080
  ClientHeight = 263
  ClientWidth = 422
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton: TcxButton
    Left = 144
    Top = 230
    Width = 145
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1086#1087#1077#1088#1072#1094#1080#1102
    Default = True
    ModalResult = 2
    TabOrder = 0
  end
  object cxMemo: TcxMemo
    Left = 8
    Top = 47
    Enabled = False
    Lines.Strings = (
      'cxMemo')
    ParentFont = False
    Properties.Alignment = taCenter
    Style.BorderStyle = ebsNone
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -16
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
    StyleDisabled.TextColor = clWindowText
    TabOrder = 1
    Height = 150
    Width = 406
  end
  object cxCurrencyEdit: TcxCurrencyEdit
    Left = 333
    Top = 8
    Enabled = False
    ParentFont = False
    Properties.Alignment.Horz = taRightJustify
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -21
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
    StyleDisabled.BorderStyle = ebsNone
    StyleDisabled.TextColor = clWindowText
    TabOrder = 2
    Width = 81
  end
  object cxProgressBar: TcxProgressBar
    Left = 8
    Top = 203
    TabOrder = 3
    Width = 406
  end
  object ActionList1: TActionList
    Left = 32
    Top = 16
    object actClose: TAction
      Caption = 'actClose'
      ShortCut = 27
      OnExecute = actCloseExecute
    end
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 32
    Top = 80
  end
  object TimerProgressBar: TTimer
    Enabled = False
    Interval = 50
    OnTimer = TimerProgressBarTimer
    Left = 32
    Top = 136
  end
end
