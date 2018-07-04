object MainForm: TMainForm
  Left = 202
  Top = 180
  Caption = 'Load_Repl - MainForm'
  ClientHeight = 627
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
    Height = 575
    Align = alRight
    ExplicitLeft = 683
    ExplicitTop = 32
    ExplicitHeight = 409
  end
  object PanelGrid: TPanel
    Left = 0
    Top = 0
    Width = 581
    Height = 575
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object PanelGridObject: TPanel
      Left = 0
      Top = 0
      Width = 581
      Height = 175
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object DBGridObject: TDBGrid
        Left = 0
        Top = 41
        Width = 508
        Height = 134
        Align = alClient
        DataSource = ObjectDS
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
        object EditObjectDescId: TEdit
          Left = 381
          Top = 11
          Width = 121
          Height = 21
          TabOrder = 1
        end
        object cbGUID: TCheckBox
          Left = 511
          Top = 13
          Width = 98
          Height = 17
          Caption = 'Find GUID'
          TabOrder = 2
        end
      end
      object PanelInfoObject: TPanel
        Left = 508
        Top = 41
        Width = 73
        Height = 134
        Align = alRight
        TabOrder = 2
        object LabelObject: TLabel
          Left = 1
          Top = 1
          Width = 31
          Height = 13
          Align = alTop
          Alignment = taCenter
          Caption = 'Object'
        end
        object EditCountObject: TcxCurrencyEdit
          Left = 1
          Top = 14
          Align = alTop
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.DecimalPlaces = 0
          Properties.DisplayFormat = ',0.'
          Properties.EditFormat = ',0.'
          Properties.ReadOnly = True
          TabOrder = 0
          Width = 71
        end
        object EditMinIdObject: TcxCurrencyEdit
          Left = 1
          Top = 35
          Align = alTop
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.DecimalPlaces = 0
          Properties.DisplayFormat = ',0.'
          Properties.EditFormat = ',0.'
          Properties.ReadOnly = True
          TabOrder = 1
          Width = 71
        end
        object EditMaxIdObject: TcxCurrencyEdit
          Left = 1
          Top = 56
          Align = alTop
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.DecimalPlaces = 0
          Properties.DisplayFormat = ',0.'
          Properties.EditFormat = ',0.'
          Properties.ReadOnly = True
          TabOrder = 2
          Width = 71
        end
        object EditCountIterationObject: TEdit
          Left = 1
          Top = 77
          Width = 71
          Height = 21
          Align = alTop
          TabOrder = 3
          ExplicitWidth = 70
        end
      end
    end
    object PanelGridObjectString: TPanel
      Left = 0
      Top = 175
      Width = 581
      Height = 80
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object DBGridObjectString: TDBGrid
        Left = 0
        Top = 0
        Width = 508
        Height = 80
        Align = alClient
        DataSource = ObjectStringDS
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
      end
      object PanelInfoObjectString: TPanel
        Left = 508
        Top = 0
        Width = 73
        Height = 80
        Align = alRight
        TabOrder = 1
        object LabelObjectString: TLabel
          Left = 1
          Top = 1
          Width = 58
          Height = 13
          Align = alTop
          Alignment = taCenter
          Caption = 'ObjectString'
        end
        object EditCountStringObject: TcxCurrencyEdit
          Left = 1
          Top = 14
          Align = alTop
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.DecimalPlaces = 0
          Properties.DisplayFormat = ',0.'
          Properties.EditFormat = ',0.'
          Properties.ReadOnly = True
          TabOrder = 0
          Width = 71
        end
      end
    end
    object PanelGridObjectFloat: TPanel
      Left = 0
      Top = 255
      Width = 581
      Height = 80
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      object DBGridObjectFloat: TDBGrid
        Left = 0
        Top = 0
        Width = 508
        Height = 80
        Align = alClient
        DataSource = ObjectFloatDS
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
      end
      object PanelInfoObjectFloat: TPanel
        Left = 508
        Top = 0
        Width = 73
        Height = 80
        Align = alRight
        TabOrder = 1
        object LabelObjectFloat: TLabel
          Left = 1
          Top = 1
          Width = 54
          Height = 13
          Align = alTop
          Alignment = taCenter
          Caption = 'ObjectFloat'
        end
        object EditCountFloatObject: TcxCurrencyEdit
          Left = 1
          Top = 14
          Align = alTop
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.DecimalPlaces = 0
          Properties.DisplayFormat = ',0.'
          Properties.EditFormat = ',0.'
          Properties.ReadOnly = True
          TabOrder = 0
          Width = 71
        end
      end
    end
    object PanelGridObjectDate: TPanel
      Left = 0
      Top = 335
      Width = 581
      Height = 80
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 3
      object DBGridObjectDate: TDBGrid
        Left = 0
        Top = 0
        Width = 508
        Height = 80
        Align = alClient
        DataSource = ObjectDateDS
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
      end
      object PanelInfoObjectDate: TPanel
        Left = 508
        Top = 0
        Width = 73
        Height = 80
        Align = alRight
        TabOrder = 1
        object LabelObjectDate: TLabel
          Left = 1
          Top = 1
          Width = 54
          Height = 13
          Align = alTop
          Alignment = taCenter
          Caption = 'ObjectDate'
        end
        object EditCountDateObject: TcxCurrencyEdit
          Left = 1
          Top = 14
          Align = alTop
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.DecimalPlaces = 0
          Properties.DisplayFormat = ',0.'
          Properties.EditFormat = ',0.'
          Properties.ReadOnly = True
          TabOrder = 0
          Width = 71
        end
      end
    end
    object PanelGridObjectBoolean: TPanel
      Left = 0
      Top = 415
      Width = 581
      Height = 80
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 4
      object DBGridObjectBoolean: TDBGrid
        Left = 0
        Top = 0
        Width = 508
        Height = 80
        Align = alClient
        DataSource = ObjectBooleanDS
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
      end
      object PanelInfoObjectBoolean: TPanel
        Left = 508
        Top = 0
        Width = 73
        Height = 80
        Align = alRight
        TabOrder = 1
        object LabelObjectBoolean: TLabel
          Left = 1
          Top = 1
          Width = 70
          Height = 13
          Align = alTop
          Alignment = taCenter
          Caption = 'ObjectBoolean'
        end
        object EditCountBooleanObject: TcxCurrencyEdit
          Left = 1
          Top = 14
          Align = alTop
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.DecimalPlaces = 0
          Properties.DisplayFormat = ',0.'
          Properties.EditFormat = ',0.'
          Properties.ReadOnly = True
          TabOrder = 0
          Width = 71
        end
      end
    end
    object PanelGridObjectLink: TPanel
      Left = 0
      Top = 495
      Width = 581
      Height = 80
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 5
      object DBGridObjectLink: TDBGrid
        Left = 0
        Top = 0
        Width = 508
        Height = 80
        Align = alClient
        DataSource = ObjectLinkDS
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
      end
      object PanelInfoObjectLink: TPanel
        Left = 508
        Top = 0
        Width = 73
        Height = 80
        Align = alRight
        TabOrder = 1
        object LabelObjectLink: TLabel
          Left = 1
          Top = 1
          Width = 51
          Height = 13
          Align = alTop
          Alignment = taCenter
          Caption = 'ObjectLink'
        end
        object EditCountLinkObject: TcxCurrencyEdit
          Left = 1
          Top = 14
          Align = alTop
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.DecimalPlaces = 0
          Properties.DisplayFormat = ',0.'
          Properties.EditFormat = ',0.'
          Properties.ReadOnly = True
          TabOrder = 0
          Width = 71
        end
      end
    end
  end
  object ButtonPanel: TPanel
    Left = 0
    Top = 575
    Width = 1025
    Height = 52
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
      Left = 159
      Top = 23
      Width = 88
      Height = 25
      Caption = #1047#1072#1087#1091#1089#1090#1080#1090#1100
      TabOrder = 0
      OnClick = OKGuideButtonClick
    end
    object StopButton: TButton
      Left = 252
      Top = 23
      Width = 88
      Height = 25
      Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100
      TabOrder = 1
      OnClick = StopButtonClick
    end
    object CloseButton: TButton
      Left = 346
      Top = 23
      Width = 88
      Height = 25
      Caption = #1042#1099#1093#1086#1076
      TabOrder = 2
      OnClick = CloseButtonClick
    end
    object cbOnlyOpen: TCheckBox
      Left = 16
      Top = 27
      Width = 97
      Height = 17
      Caption = #1090#1086#1083#1100#1082#1086' OPEN'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
  end
  object PageControl: TPageControl
    Left = 584
    Top = 0
    Width = 441
    Height = 575
    ActivePage = TabSheet1
    Align = alRight
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080' - '#1044#1086#1082#1091#1084#1077#1085#1090#1099
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object PanelReplServer: TPanel
        Left = 0
        Top = 0
        Width = 433
        Height = 161
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object rgReplServer: TRadioGroup
          Left = 0
          Top = 0
          Width = 433
          Height = 161
          Align = alClient
          Caption = #1057#1077#1088#1074#1077#1088#1099
          Items.Strings = (
            '1. integer-srv.alan.dp.ua'
            '2. project-vds.vds.colocall.com')
          TabOrder = 0
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1080#1079' '#1092#1072#1081#1083#1086#1074
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
  end
  object ObjectDS: TDataSource
    DataSet = ObjectCDS
    Left = 400
    Top = 88
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
  object spSelect_ReplObject: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplObject'
    DataSet = ObjectCDS
    DataSets = <
      item
        DataSet = ObjectCDS
      end
      item
        DataSet = ObjectStringCDS
      end
      item
        DataSet = ObjectFloatCDS
      end
      item
        DataSet = ObjectDateCDS
      end
      item
        DataSet = ObjectBooleanCDS
      end
      item
        DataSet = ObjectLinkCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inSessionGUID'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartId'
        Value = 'NULL'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDataBaseId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 368
    Top = 40
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
    Left = 242
    Top = 121
  end
  object fromSqlQuery: TQuery
    DatabaseName = 'tProfiManagerDS'
    SessionName = 'Default'
    Left = 194
    Top = 83
  end
  object fromQuery_two: TQuery
    DatabaseName = 'tProfiManagerDS'
    SessionName = 'Default'
    Left = 196
    Top = 136
  end
  object ObjectCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 456
    Top = 72
  end
  object FormParams: TdsdFormParams
    Params = <>
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
  object ObjectStringCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 464
    Top = 144
  end
  object ObjectStringDS: TDataSource
    DataSet = ObjectStringCDS
    Left = 408
    Top = 160
  end
  object ObjectFloatCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 464
    Top = 224
  end
  object ObjectFloatDS: TDataSource
    DataSet = ObjectFloatCDS
    Left = 408
    Top = 240
  end
  object ObjectDateDS: TDataSource
    DataSet = ObjectDateCDS
    Left = 400
    Top = 320
  end
  object ObjectDateCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 456
    Top = 304
  end
  object ObjectBooleanDS: TDataSource
    DataSet = ObjectBooleanCDS
    Left = 408
    Top = 400
  end
  object ObjectBooleanCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 464
    Top = 384
  end
  object ObjectLinkDS: TDataSource
    DataSet = ObjectLinkCDS
    Left = 400
    Top = 480
  end
  object ObjectLinkCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 456
    Top = 464
  end
  object spInsert_ReplObject: TdsdStoredProc
    StoredProcName = 'gpInsert_ReplObject'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inSessionGUID'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate'
        Value = 'NULL'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescCode'
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
      end
      item
        Name = 'outCount'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMinId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMaxId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountString'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountFloat'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountDate'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountBoolean'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountLink'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountIteration'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountPack'
        Value = Null
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 280
    Top = 56
  end
end
