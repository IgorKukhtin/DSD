object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1040#1074#1090#1086'-'#1079#1072#1075#1088#1091#1079#1082#1072' '#1087#1086#1095#1090#1099
  ClientHeight = 428
  ClientWidth = 666
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
    Left = 280
    Top = 395
    Width = 75
    Height = 25
    Caption = 'Start !!!'
    TabOrder = 0
    OnClick = BtnStartClick
  end
  object PanelHost: TPanel
    Left = 0
    Top = 0
    Width = 666
    Height = 78
    Align = alTop
    Caption = 'Host : '
    TabOrder = 1
    object GaugeHost: TGauge
      Left = 1
      Top = 58
      Width = 664
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
    Top = 78
    Width = 666
    Height = 78
    Align = alTop
    Caption = 'Mail From : '
    TabOrder = 2
    object GaugeMailFrom: TGauge
      Left = 1
      Top = 58
      Width = 664
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
    Top = 156
    Width = 666
    Height = 78
    Align = alTop
    Caption = 'Parts : '
    TabOrder = 3
    object GaugeParts: TGauge
      Left = 1
      Top = 58
      Width = 664
      Height = 19
      Align = alBottom
      Progress = 50
      ExplicitLeft = 0
      ExplicitTop = -6
      ExplicitWidth = 666
    end
  end
  object PanelLoadXLS: TPanel
    Left = 0
    Top = 234
    Width = 666
    Height = 78
    Align = alTop
    Caption = 'Load XLS : '
    TabOrder = 4
    ExplicitTop = 164
    object GaugeLoadXLS: TGauge
      Left = 1
      Top = 58
      Width = 664
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
    Top = 312
    Width = 666
    Height = 78
    Align = alTop
    Caption = 'Move : '
    TabOrder = 5
    ExplicitTop = 242
    object GaugeMove: TGauge
      Left = 1
      Top = 58
      Width = 664
      Height = 19
      Align = alBottom
      Progress = 50
      ExplicitLeft = 0
      ExplicitTop = -6
      ExplicitWidth = 666
    end
  end
  object cbTimer: TCheckBox
    Left = 440
    Top = 399
    Width = 177
    Height = 17
    Caption = 'Timer ON '
    TabOrder = 6
    OnClick = cbTimerClick
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
  object spSelect: TdsdStoredProc
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <>
    PackSize = 1
    Left = 40
    Top = 8
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 88
    Top = 152
  end
  object ActionList: TActionList
    Left = 392
    Top = 256
    object actExecuteImportSettings: TExecuteImportSettingsAction
      Category = 'Load'
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = ClientDataSet
      ImportSettingsId.ComponentItem = 'Id'
      ExternalParams = <>
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
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 104
    Top = 304
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
    Left = 200
    Top = 312
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
      end>
    PackSize = 1
    Left = 192
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
      end>
    PackSize = 1
    Left = 144
    Top = 384
  end
  object Timer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerTimer
    Left = 480
    Top = 320
  end
end
