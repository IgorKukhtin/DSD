object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1040#1074#1090#1086'-'#1079#1072#1075#1088#1091#1079#1082#1072' '#1087#1086#1095#1090#1099
  ClientHeight = 442
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
    Left = 258
    Top = 409
    Width = 75
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
      ExplicitLeft = 0
      ExplicitTop = -6
      ExplicitWidth = 666
    end
  end
  object PanelLoadFile: TPanel
    Left = 0
    Top = 258
    Width = 984
    Height = 70
    Align = alTop
    Caption = 'Load File: '
    TabOrder = 4
    ExplicitLeft = 1
    ExplicitTop = 263
    object GaugeLoadXLS: TGauge
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
  object PanelMove: TPanel
    Left = 0
    Top = 328
    Width = 984
    Height = 70
    Align = alTop
    Caption = 'Move : '
    TabOrder = 5
    object GaugeMove: TGauge
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
    Left = 352
    Top = 413
    Width = 400
    Height = 17
    Caption = 'Timer ON '
    TabOrder = 6
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
    TabOrder = 7
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
    TabOrder = 8
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
  object ActionList: TActionList
    Left = 816
    Top = 264
    object actExecuteImportSettings: TExecuteImportSettingsAction
      Category = 'Load'
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = ClientDataSet
      ImportSettingsId.ComponentItem = 'Id'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inAreaId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'Directory_add'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isNext_aftErr'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'outMsgText'
          Value = ''
          DataType = ftString
          MultiSelectSeparator = ','
        end>
    end
    object actMovePriceList: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateGoods
      StoredProcList = <
        item
          StoredProc = spUpdateGoods
        end
        item
          StoredProc = spLoadPriceList
        end>
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1074' '#1087#1088#1072#1081#1089#1099
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1074' '#1087#1088#1072#1081#1089#1099
      ImageIndex = 27
    end
    object actProtocol: TdsdExecStoredProc
      Category = 'Load'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Protocol_LoadPriceList
      StoredProcList = <
        item
          StoredProc = spUpdate_Protocol_LoadPriceList
        end>
      Caption = 'actProtocol'
    end
    object mactExecuteImportSettings: TMultiAction
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecuteImportSettings
        end
        item
          Action = actProtocol
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072
    end
    object actSendEmail: TdsdSMTPFileAction
      Category = 'Send'
      MoveParams = <>
      Host.Value = '0'
      Host.Component = ExportSettingsCDS
      Host.ComponentItem = 'Host'
      Host.DataType = ftString
      Host.MultiSelectSeparator = ','
      Port.Value = '0'
      Port.Component = ExportSettingsCDS
      Port.ComponentItem = 'Port'
      Port.MultiSelectSeparator = ','
      UserName.Value = '0'
      UserName.Component = ExportSettingsCDS
      UserName.ComponentItem = 'UserName'
      UserName.DataType = ftString
      UserName.MultiSelectSeparator = ','
      Password.Value = '0'
      Password.Component = ExportSettingsCDS
      Password.ComponentItem = 'PasswordValue'
      Password.DataType = ftString
      Password.MultiSelectSeparator = ','
      Body.Value = '0'
      Body.Component = ExportSettingsCDS
      Body.ComponentItem = 'Body'
      Body.DataType = ftString
      Body.MultiSelectSeparator = ','
      Subject.Value = '0'
      Subject.Component = ExportSettingsCDS
      Subject.ComponentItem = 'Subject'
      Subject.DataType = ftString
      Subject.MultiSelectSeparator = ','
      FromAddress.Value = '0'
      FromAddress.Component = ExportSettingsCDS
      FromAddress.ComponentItem = 'MailFrom'
      FromAddress.DataType = ftString
      FromAddress.MultiSelectSeparator = ','
      ToAddress.Value = '0'
      ToAddress.Component = ExportSettingsCDS
      ToAddress.ComponentItem = 'MailTo'
      ToAddress.DataType = ftString
      ToAddress.MultiSelectSeparator = ','
    end
    object actRefreshMovementItemLastPriceList_View: TdsdExecStoredProc
      Category = 'Load'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spRefreshMovementItemLastPriceList_View
      StoredProcList = <
        item
          StoredProc = spRefreshMovementItemLastPriceList_View
        end>
      Caption = 'actRefreshMovementItemLastPriceList_View'
    end
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 368
    Top = 288
  end
  object spSelectMove: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_LoadPriceList'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Params = <>
    PackSize = 1
    Left = 560
    Top = 288
  end
  object spUpdateGoods: TdsdStoredProc
    StoredProcName = 'gpUpdatePartnerGoods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 544
    Top = 360
  end
  object spLoadPriceList: TdsdStoredProc
    StoredProcName = 'gpLoadPriceList'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 376
    Top = 344
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
  object spGet_LoadPriceList: TdsdStoredProc
    StoredProcName = 'gpGet_LoadPriceList'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAreaId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 736
    Top = 208
  end
  object spUpdate_Protocol_LoadPriceList: TdsdStoredProc
    StoredProcName = 'gpUpdate_Protocol_LoadPriceList'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inImportSettingsId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 792
    Top = 336
  end
  object spExportSettings_Email: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ExportSettings_Email'
    DataSet = ExportSettingsCDS
    DataSets = <
      item
        DataSet = ExportSettingsCDS
      end>
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContactPersonId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inByDate'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inByMail'
        Value = Null
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inByFileName'
        Value = Null
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 408
    Top = 208
  end
  object ExportSettingsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 544
    Top = 128
  end
  object spRefreshMovementItemLastPriceList_View: TdsdStoredProc
    StoredProcName = 'lpRefreshMovementItemLastPriceList_View'
    DataSets = <>
    OutputType = otResult
    Params = <>
    PackSize = 1
    Left = 736
    Top = 136
  end
end
