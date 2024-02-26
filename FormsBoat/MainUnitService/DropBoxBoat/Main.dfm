object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1087#1088#1072#1074#1082#1072' '#1092#1072#1081#1083#1086#1074' '#1074' '#1087#1072#1087#1082#1091' DropBox'
  ClientHeight = 193
  ClientWidth = 822
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
  object BtnStart: TBitBtn
    Left = 232
    Top = 129
    Width = 109
    Height = 25
    Caption = 'Start !!!'
    TabOrder = 0
    OnClick = BtnStartClick
  end
  object PanelCopyFile: TPanel
    Left = 0
    Top = 48
    Width = 822
    Height = 70
    Align = alTop
    Caption = 'Copy file : '
    TabOrder = 1
    ExplicitTop = 53
    ExplicitWidth = 984
    object GaugeCopyFile: TGauge
      Left = 1
      Top = 50
      Width = 820
      Height = 19
      Align = alBottom
      Progress = 50
      ExplicitLeft = 2
      ExplicitWidth = 982
    end
  end
  object cbTimer: TCheckBox
    Left = 360
    Top = 133
    Width = 400
    Height = 17
    Caption = 'Timer ON '
    TabOrder = 2
    OnClick = cbTimerClick
  end
  object PanelError: TPanel
    Left = 0
    Top = 0
    Width = 822
    Height = 24
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    ExplicitWidth = 984
  end
  object PanelInfo: TPanel
    Left = 0
    Top = 24
    Width = 822
    Height = 24
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    ExplicitWidth = 984
  end
  object BitSendUnscheduled: TBitBtn
    Left = 232
    Top = 160
    Width = 109
    Height = 25
    Caption = 'Send unscheduled'
    TabOrder = 5
    OnClick = BitSendUnscheduledClick
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Invoice_DropBox'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 40
    Top = 48
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 136
    Top = 50
  end
  object Timer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerTimer
    Left = 552
    Top = 48
  end
  object Document: TDocument
    GetBlobProcedure = spGetDocument
    Left = 656
    Top = 48
  end
  object spGetDocument: TdsdStoredProc
    StoredProcName = 'gpGet_Object_InvoicePdf'
    DataSets = <>
    OutputType = otBlob
    Params = <
      item
        Name = 'inInvoicePdfId'
        Value = Null
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 736
    Top = 48
  end
  object spInvoicePdf_DateUnloading: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_InvoicePdf_DateUnloading'
    DataSets = <>
    OutputType = otBlob
    Params = <
      item
        Name = 'inId'
        Value = Null
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 552
    Top = 144
  end
  object spDelete_FilesNotUploaded: TdsdStoredProc
    StoredProcName = 'gpDelete_Movement_Invoice_FilesNotUploaded'
    DataSets = <>
    OutputType = otBlob
    Params = <
      item
        Name = 'inId'
        Value = Null
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 728
    Top = 144
  end
end
