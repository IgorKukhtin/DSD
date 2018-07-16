object MainForm: TMainForm
  Left = 202
  Top = 180
  Caption = 'Load_Repl - MainForm'
  ClientHeight = 635
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
    Height = 580
    Align = alRight
    ExplicitLeft = 683
    ExplicitTop = 32
    ExplicitHeight = 409
  end
  object PanelGrid: TPanel
    Left = 0
    Top = 0
    Width = 581
    Height = 580
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object PanelGridObject: TPanel
      Left = 0
      Top = 0
      Width = 581
      Height = 180
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object DBGridObject: TDBGrid
        Left = 0
        Top = 41
        Width = 508
        Height = 139
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
          Left = 384
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
        Height = 139
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
        end
      end
    end
    object PanelGridObjectString: TPanel
      Left = 0
      Top = 180
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
      Top = 260
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
      Top = 340
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
      Top = 420
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
      Top = 500
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
    Top = 580
    Width = 1025
    Height = 55
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
      Top = 26
      Width = 88
      Height = 25
      Caption = #1047#1072#1087#1091#1089#1090#1080#1090#1100
      TabOrder = 0
      OnClick = OKGuideButtonClick
    end
    object StopButton: TButton
      Left = 252
      Top = 26
      Width = 88
      Height = 25
      Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100
      TabOrder = 1
      OnClick = StopButtonClick
    end
    object CloseButton: TButton
      Left = 346
      Top = 26
      Width = 88
      Height = 25
      Caption = #1042#1099#1093#1086#1076
      TabOrder = 2
      OnClick = CloseButtonClick
    end
    object cbOnlyOpen: TCheckBox
      Left = 16
      Top = 30
      Width = 97
      Height = 17
      Caption = #1090#1086#1083#1100#1082#1086' OPEN'
      TabOrder = 3
    end
    object cbDesc: TCheckBox
      Left = 448
      Top = 30
      Width = 86
      Height = 17
      Caption = #1090#1086#1083#1100#1082#1086' Desc'
      TabOrder = 4
    end
    object cbClientDataSet: TCheckBox
      Left = 621
      Top = 30
      Width = 126
      Height = 17
      Caption = 'CDS - '#1076#1083#1103' '#1073#1072#1079#1099' From '
      TabOrder = 5
    end
    object cbShowGrid: TCheckBox
      Left = 755
      Top = 30
      Width = 168
      Height = 17
      Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1074' '#1043#1056#1048#1044#1077
      TabOrder = 6
    end
    object cbProc: TCheckBox
      Left = 536
      Top = 30
      Width = 81
      Height = 17
      Caption = #1090#1086#1083#1100#1082#1086' Proc'
      TabOrder = 7
    end
  end
  object PageControl: TPageControl
    Left = 584
    Top = 0
    Width = 441
    Height = 580
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
      object PanelError: TPanel
        Left = 0
        Top = 161
        Width = 433
        Height = 391
        Align = alClient
        TabOrder = 1
        object MemoMsg: TMemo
          Left = 1
          Top = 1
          Width = 431
          Height = 389
          Align = alClient
          Lines.Strings = (
            'MemoMsg')
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
    DataSet = fQueryObject
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
  object spSelect_ReplObject_old: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplObject_old'
    DataSet = ObjectCDS
    DataSets = <
      item
        DataSet = ObjectCDS
      end>
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
  object spSelect_ReplServer_load_old: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplServer_load_old'
    DataSet = ReplServerCDS
    DataSets = <
      item
        DataSet = ReplServerCDS
      end>
    Params = <>
    PackSize = 1
    Left = 176
    Top = 80
  end
  object ReplServerCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 176
    Top = 136
  end
  object ObjectStringCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 464
    Top = 144
  end
  object ObjectStringDS: TDataSource
    DataSet = fQueryObjectString
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
    DataSet = fQueryObjectFloat
    Left = 408
    Top = 240
  end
  object ObjectDateDS: TDataSource
    DataSet = fQueryObjectDate
    Left = 400
    Top = 312
  end
  object ObjectDateCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 456
    Top = 296
  end
  object ObjectBooleanDS: TDataSource
    DataSet = fQueryObjectBoolean
    Left = 408
    Top = 384
  end
  object ObjectBooleanCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 464
    Top = 368
  end
  object ObjectLinkDS: TDataSource
    DataSet = fQueryObjectLink
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
  object spInsert_ReplObject_old: TdsdStoredProc
    StoredProcName = 'gpInsert_ReplObject_old'
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
    Left = 264
    Top = 64
  end
  object fromZConnection: TZConnection
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
    Top = 96
  end
  object fromSqlQuery: TZQuery
    Connection = fromZConnection
    SQL.Strings = (
      'select  * from Object')
    Params = <>
    Properties.Strings = (
      'select * from Object order by 1 desc')
    Left = 56
    Top = 152
  end
  object fQueryObject: TZQuery
    Connection = fromZConnection
    SQL.Strings = (
      'select  * from Object')
    Params = <>
    Properties.Strings = (
      'select * from Object order by 1 desc')
    Left = 344
    Top = 104
  end
  object fQueryObjectString: TZQuery
    Connection = fromZConnection
    SQL.Strings = (
      'select  * from Object')
    Params = <>
    Properties.Strings = (
      'select * from Object order by 1 desc')
    Left = 336
    Top = 184
  end
  object fQueryObjectFloat: TZQuery
    Connection = fromZConnection
    SQL.Strings = (
      'select  * from Object')
    Params = <>
    Properties.Strings = (
      'select * from Object order by 1 desc')
    Left = 336
    Top = 256
  end
  object fQueryObjectDate: TZQuery
    Connection = fromZConnection
    SQL.Strings = (
      'select  * from Object')
    Params = <>
    Properties.Strings = (
      'select * from Object order by 1 desc')
    Left = 344
    Top = 328
  end
  object fQueryObjectBoolean: TZQuery
    Connection = fromZConnection
    SQL.Strings = (
      'select  * from Object')
    Params = <>
    Properties.Strings = (
      'select * from Object order by 1 desc')
    Left = 328
    Top = 392
  end
  object fQueryObjectLink: TZQuery
    Connection = fromZConnection
    SQL.Strings = (
      'select  * from Object')
    Params = <>
    Properties.Strings = (
      'select * from Object order by 1 desc')
    Left = 336
    Top = 472
  end
  object spSelect_ReplObjectString_old: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplObjectString_old'
    DataSet = ObjectStringCDS
    DataSets = <
      item
        DataSet = ObjectStringCDS
      end>
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
    Left = 464
    Top = 176
  end
  object spSelect_ReplObjectFloat_old: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplObjectFloat_old'
    DataSet = ObjectFloatCDS
    DataSets = <
      item
        DataSet = ObjectFloatCDS
      end>
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
    Left = 464
    Top = 248
  end
  object spSelect_ReplObjectDate_old: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplObjectDate_old'
    DataSet = ObjectDateCDS
    DataSets = <
      item
        DataSet = ObjectDateCDS
      end>
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
    Left = 472
    Top = 312
  end
  object spSelect_ReplObjectBoolean_old: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplObjectBoolean_old'
    DataSet = ObjectBooleanCDS
    DataSets = <
      item
        DataSet = ObjectBooleanCDS
      end>
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
    Left = 488
    Top = 368
  end
  object spSelect_ReplObjectLink_old: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplObjectLink_old'
    DataSet = ObjectLinkCDS
    DataSets = <
      item
        DataSet = ObjectLinkCDS
      end>
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
    Left = 472
    Top = 424
  end
  object tmpCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 208
    Top = 344
  end
  object spExecSql: TdsdStoredProc
    StoredProcName = 'gpExecSql'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inSqlText'
        Value = Null
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 192
    Top = 200
  end
  object fromSqlQuery_two: TZQuery
    Connection = fromZConnection
    SQL.Strings = (
      'select  * from Object')
    Params = <>
    Properties.Strings = (
      'select * from Object order by 1 desc')
    Left = 56
    Top = 200
  end
end
