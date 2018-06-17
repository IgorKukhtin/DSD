object MainForm: TMainForm
  Left = 202
  Top = 180
  Caption = 'Load_Repl - MainForm'
  ClientHeight = 585
  ClientWidth = 1025
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 442
    Top = 0
    Height = 521
    Align = alRight
    ExplicitLeft = 683
    ExplicitTop = 32
    ExplicitHeight = 409
  end
  object DBGrid: TDBGrid
    Left = 0
    Top = 0
    Width = 442
    Height = 521
    Align = alClient
    DataSource = DataSource
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object ButtonPanel: TPanel
    Left = 0
    Top = 521
    Width = 1025
    Height = 64
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    OnDblClick = ButtonPanelDblClick
    object Gauge: TGauge
      Left = 0
      Top = 0
      Width = 1025
      Height = 19
      Align = alTop
      Progress = 50
      ExplicitWidth = 1307
    end
    object OKGuideButton: TButton
      Left = 56
      Top = 25
      Width = 88
      Height = 25
      Caption = #1047#1072#1087#1091#1089#1090#1080#1090#1100
      TabOrder = 0
      OnClick = OKGuideButtonClick
    end
    object StopButton: TButton
      Left = 149
      Top = 25
      Width = 88
      Height = 25
      Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100
      TabOrder = 1
      OnClick = StopButtonClick
    end
    object CloseButton: TButton
      Left = 243
      Top = 25
      Width = 88
      Height = 25
      Caption = #1042#1099#1093#1086#1076
      TabOrder = 2
      OnClick = CloseButtonClick
    end
  end
  object PageControl: TPageControl
    Left = 445
    Top = 0
    Width = 580
    Height = 521
    ActivePage = TabSheet1
    Align = alRight
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080' - '#1044#1086#1082#1091#1084#1077#1085#1090#1099
      object PanelReplServer: TPanel
        Left = 0
        Top = 0
        Width = 572
        Height = 161
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object rgReplServer: TRadioGroup
          Left = 0
          Top = 0
          Width = 572
          Height = 161
          Align = alClient
          Caption = #1057#1077#1088#1074#1077#1088#1099
          Items.Strings = (
            '1. integer-srv.alan.dp.ua admin vas6ok 5432 project'
            '2. localhost postgres postgres 5432 project')
          TabOrder = 0
          ExplicitLeft = 48
          ExplicitTop = 56
          ExplicitWidth = 185
          ExplicitHeight = 105
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1080#1079' '#1092#1072#1081#1083#1086#1074
      ImageIndex = 1
    end
  end
  object DataSource: TDataSource
    Left = 24
    Top = 48
  end
  object toSqlQuery: TZQuery
    Connection = toZConnection
    SQL.Strings = (
      'select  * from Object')
    Params = <>
    Properties.Strings = (
      'select * from Object order by 1 desc')
    Left = 56
    Top = 320
  end
  object toStoredProc: TdsdStoredProc
    DataSets = <>
    Params = <>
    PackSize = 1
    Left = 24
    Top = 208
  end
  object toStoredProc_two: TdsdStoredProc
    DataSets = <>
    Params = <>
    PackSize = 1
    Left = 24
    Top = 152
  end
  object toZConnection: TZConnection
    ControlsCodePage = cCP_UTF16
    UTF8StringsAsWideField = True
    Catalog = 'public'
    DesignConnection = True
    HostName = 'localhost'
    Port = 5432
    Database = 'project'
    User = 'postgres'
    Password = 'postgres'
    Protocol = 'postgresql-9'
    Left = 56
    Top = 272
  end
  object toStoredProc_three: TdsdStoredProc
    DataSets = <>
    Params = <>
    PackSize = 1
    Left = 24
    Top = 104
  end
  object toSqlQuery_two: TZQuery
    Connection = toZConnection
    SQL.Strings = (
      'select  * from Object')
    Params = <>
    Properties.Strings = (
      'select * from Object order by 1 desc')
    Left = 56
    Top = 368
  end
  object DatabaseSybase: TDatabase
    AliasName = 'tProfiManagerDS'
    DatabaseName = 'tProfiManagerDS'
    KeepConnection = False
    LoginPrompt = False
    SessionName = 'Default'
    Left = 175
    Top = 31
  end
  object fromQuery: TQuery
    DatabaseName = 'tProfiManagerDS'
    SessionName = 'Default'
    Left = 194
    Top = 169
  end
  object fromSqlQuery: TQuery
    DatabaseName = 'tProfiManagerDS'
    SessionName = 'Default'
    Left = 306
    Top = 171
  end
  object fromQuery_two: TQuery
    DatabaseName = 'tProfiManagerDS'
    SessionName = 'Default'
    Left = 196
    Top = 232
  end
end
