object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1087#1088#1072#1074#1082#1072' '#1092#1072#1081#1083#1086#1074' '#1074' '#1087#1072#1087#1082#1091' DropBox'
  ClientHeight = 193
  ClientWidth = 984
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object BtnStart: TBitBtn
    Left = 266
    Top = 145
    Width = 75
    Height = 25
    Caption = 'Start !!!'
    TabOrder = 0
    OnClick = BtnStartClick
  end
  object PanelCopyFile: TPanel
    Left = 0
    Top = 48
    Width = 984
    Height = 70
    Align = alTop
    Caption = 'Copy file : '
    TabOrder = 1
    ExplicitTop = 54
    object GaugeCopyFile: TGauge
      Left = 1
      Top = 50
      Width = 982
      Height = 19
      Align = alBottom
      Progress = 50
      ExplicitLeft = 2
    end
  end
  object cbTimer: TCheckBox
    Left = 360
    Top = 149
    Width = 400
    Height = 17
    Caption = 'Timer ON '
    TabOrder = 2
    OnClick = cbTimerClick
  end
  object PanelError: TPanel
    Left = 0
    Top = 0
    Width = 984
    Height = 24
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
  object PanelInfo: TPanel
    Left = 0
    Top = 24
    Width = 984
    Height = 24
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
  object spSelect: TdsdStoredProc
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <>
    PackSize = 1
    Left = 40
    Top = 32
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 136
    Top = 42
  end
  object Timer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerTimer
    Left = 544
    Top = 24
  end
  object spInsertUpdate_Invoice: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Invoice_LoadMail'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSubject'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 264
    Top = 40
  end
  object spInsertUpdate_InvoicePdf: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_InvoicePdf'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPhotoName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovmentId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvoicePdfData'
        Value = Null
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 392
    Top = 40
  end
end
