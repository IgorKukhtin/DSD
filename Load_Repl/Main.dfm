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
    Left = 581
    Top = 0
    Height = 521
    Align = alRight
    ExplicitLeft = 683
    ExplicitTop = 32
    ExplicitHeight = 409
  end
  object PanelGrid: TPanel
    Left = 0
    Top = 0
    Width = 581
    Height = 521
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 442
    object DBGrid: TDBGrid
      Left = 0
      Top = 41
      Width = 581
      Height = 480
      Align = alClient
      DataSource = ObjectGUIDІDS
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
    end
    object PanelCB: TPanel
      Left = 0
      Top = 0
      Width = 581
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitLeft = 201
      ExplicitTop = 48
      ExplicitWidth = 185
      object LabelObjectDescId: TLabel
        Left = 222
        Top = 16
        Width = 159
        Height = 13
        Caption = #1054#1076#1080#1085' '#1080#1083#1080' '#1042#1057#1045' '#1089#1087#1088#1072#1074', DescId =  '
      end
      object cbProtocol: TCheckBox
        Left = 16
        Top = 13
        Width = 209
        Height = 17
        Caption = #1055#1086' '#1076#1072#1085#1085#1099#1084' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' / '#1080#1085#1072#1095#1077' '#1042#1057#1045
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
      object EditObjectDescId: TcxCurrencyEdit
        Left = 383
        Top = 12
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.AssignedValues.DisplayFormat = True
        Properties.DecimalPlaces = 0
        TabOrder = 1
        Width = 52
      end
      object EditRecord: TcxCurrencyEdit
        Left = 512
        Top = 11
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = ',0.'
        Properties.ReadOnly = True
        TabOrder = 2
        Width = 63
      end
    end
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
    Left = 584
    Top = 0
    Width = 441
    Height = 521
    ActivePage = TabSheet1
    Align = alRight
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080' - '#1044#1086#1082#1091#1084#1077#1085#1090#1099
      ExplicitWidth = 572
      object PanelReplServer: TPanel
        Left = 0
        Top = 0
        Width = 433
        Height = 161
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitWidth = 572
        object rgReplServer: TRadioGroup
          Left = 0
          Top = 0
          Width = 433
          Height = 161
          Align = alClient
          Caption = #1057#1077#1088#1074#1077#1088#1099
          Items.Strings = (
            '1. integer-srv.alan.dp.ua admin vas6ok 5432 project'
            '2. localhost postgres postgres 5432 project')
          TabOrder = 0
          ExplicitLeft = -1
          ExplicitWidth = 572
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1080#1079' '#1092#1072#1081#1083#1086#1074
      ImageIndex = 1
      ExplicitWidth = 572
    end
  end
  object ObjectGUIDІDS: TDataSource
    DataSet = ObjectGUIDCDS
    Left = 104
    Top = 168
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
  object spSelect_ObjectGUID: TdsdStoredProc
    StoredProcName = 'gpSelect_ObjectGUID'
    DataSet = ObjectGUIDCDS
    DataSets = <
      item
        DataSet = ObjectGUIDCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 'NULL'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDataBaseId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsProtocol'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsGUID_null'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 48
    Top = 160
  end
  object toStoredProc: TdsdStoredProc
    DataSets = <>
    Params = <>
    PackSize = 1
    Left = 80
    Top = 104
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
  object ObjectGUIDCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 96
    Top = 216
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inStartDate'
        Value = 'NULL'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDataBaseId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescId'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsProtocol'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 16
  end
  object spSelect_ReplServer_load: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplServer_load'
    DataSet = ReplServerCDS
    DataSets = <
      item
        DataSet = ReplServerCDS
      end>
    Params = <>
    PackSize = 1
    Left = 288
    Top = 264
  end
  object ReplServerCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 336
    Top = 320
  end
end
