object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1040#1074#1090#1086'-'#1079#1072#1075#1088#1091#1079#1082#1072' '#1087#1086#1095#1090#1099
  ClientHeight = 408
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
    Left = 216
    Top = 344
    Width = 109
    Height = 25
    Caption = 'Start !!!'
    TabOrder = 0
    OnClick = BtnStartClick
  end
  object PanelHost: TPanel
    Left = 0
    Top = 48
    Width = 984
    Height = 70
    Align = alTop
    Caption = 'Host : '
    TabOrder = 1
    object GaugeHost: TGauge
      Left = 1
      Top = 50
      Width = 982
      Height = 19
      Align = alBottom
      Progress = 50
      ExplicitLeft = 0
      ExplicitTop = -6
      ExplicitWidth = 666
    end
  end
  object PanelMailFrom: TPanel
    Left = 0
    Top = 118
    Width = 984
    Height = 70
    Align = alTop
    Caption = 'Mail From : '
    TabOrder = 2
    object GaugeMailFrom: TGauge
      Left = 1
      Top = 50
      Width = 982
      Height = 19
      Align = alBottom
      Progress = 50
      ExplicitLeft = 0
      ExplicitTop = -6
      ExplicitWidth = 666
    end
  end
  object PanelParts: TPanel
    Left = 0
    Top = 188
    Width = 984
    Height = 70
    Align = alTop
    Caption = 'Parts : '
    TabOrder = 3
    object GaugeParts: TGauge
      Left = 1
      Top = 50
      Width = 982
      Height = 19
      Align = alBottom
      Progress = 50
      ExplicitTop = 45
    end
  end
  object PanelLoadFile: TPanel
    Left = 0
    Top = 258
    Width = 984
    Height = 70
    Align = alTop
    Caption = 'Add File: '
    TabOrder = 4
    object GaugeLoadFile: TGauge
      Left = 1
      Top = 50
      Width = 982
      Height = 19
      Align = alBottom
      Progress = 50
      ExplicitLeft = 0
      ExplicitTop = -6
      ExplicitWidth = 666
    end
  end
  object cbTimer: TCheckBox
    Left = 344
    Top = 348
    Width = 400
    Height = 17
    Caption = 'Timer ON '
    TabOrder = 5
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
    TabOrder = 6
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
    TabOrder = 7
  end
  object BtnLoadUnscheduled: TBitBtn
    Left = 216
    Top = 375
    Width = 109
    Height = 25
    Caption = 'Losd unscheduled'
    TabOrder = 8
    OnClick = BtnLoadUnscheduledClick
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
    Left = 440
    Top = 24
  end
  object spSelect: TdsdStoredProc
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <>
    PackSize = 1
    Left = 32
    Top = 128
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 112
    Top = 130
  end
  object Timer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerTimer
    Left = 544
    Top = 24
  end
  object IdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL
    Destination = ':143'
    MaxLineAction = maException
    Port = 143
    DefaultPort = 0
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 328
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
    Left = 112
    Top = 216
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
    Left = 296
    Top = 216
  end
end
