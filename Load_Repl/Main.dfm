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
      Height = 201
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object DBGridObject: TDBGrid
        Left = 0
        Top = 41
        Width = 471
        Height = 160
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
          Left = 243
          Top = 17
          Width = 159
          Height = 13
          Caption = #1054#1076#1080#1085' '#1080#1083#1080' '#1042#1057#1045' '#1089#1087#1088#1072#1074', DescId =  '
        end
        object cbProtocol: TCheckBox
          Left = 6
          Top = 16
          Width = 217
          Height = 17
          Caption = #1055#1086' '#1076#1072#1085#1085#1099#1084' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' ('#1076#1072') / '#1080#1085#1072#1095#1077' '#1042#1057#1045
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object EditObjectDescId: TEdit
          Left = 406
          Top = 11
          Width = 99
          Height = 21
          TabOrder = 1
        end
        object cbGUID: TCheckBox
          Left = 508
          Top = 13
          Width = 71
          Height = 17
          Caption = 'Find GUID'
          TabOrder = 2
        end
      end
      object PanelInfoObject: TPanel
        Left = 471
        Top = 41
        Width = 110
        Height = 160
        Align = alRight
        TabOrder = 2
        object EditCountIterationObject: TEdit
          Left = 1
          Top = 96
          Width = 108
          Height = 21
          Align = alBottom
          TabOrder = 0
        end
        object cbProc: TCheckBox
          Left = 3
          Top = 26
          Width = 42
          Height = 17
          Caption = 'Proc'
          TabOrder = 1
        end
        object cbDesc: TCheckBox
          Left = 63
          Top = 26
          Width = 45
          Height = 17
          Caption = 'Desc'
          TabOrder = 2
        end
        object cbObject: TCheckBox
          Left = 3
          Top = 62
          Width = 48
          Height = 17
          Caption = 'Object'
          Checked = True
          State = cbChecked
          TabOrder = 3
        end
        object cbObjectHistory: TCheckBox
          Left = 3
          Top = 77
          Width = 56
          Height = 17
          Caption = 'OHistory'
          Checked = True
          State = cbChecked
          TabOrder = 4
        end
        object EditMaxIdObject: TEdit
          Left = 1
          Top = 117
          Width = 108
          Height = 21
          Align = alBottom
          TabOrder = 5
        end
        object EditMinIdObject: TEdit
          Left = 1
          Top = 138
          Width = 108
          Height = 21
          Align = alBottom
          TabOrder = 6
        end
        object EditCountObject: TEdit
          Left = 1
          Top = 1
          Width = 108
          Height = 21
          Align = alTop
          TabOrder = 7
        end
        object cbMovement: TCheckBox
          Left = 63
          Top = 62
          Width = 42
          Height = 17
          Caption = 'Mov'
          Checked = True
          State = cbChecked
          TabOrder = 8
        end
        object cbMI: TCheckBox
          Left = 63
          Top = 77
          Width = 42
          Height = 17
          Caption = 'MI'
          Checked = True
          State = cbChecked
          TabOrder = 9
        end
        object cbForms: TCheckBox
          Left = 3
          Top = 42
          Width = 56
          Height = 17
          Caption = 'Forms'
          TabOrder = 10
        end
      end
    end
    object PanelGridObjectString: TPanel
      Left = 0
      Top = 201
      Width = 581
      Height = 80
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object DBGridObjectString: TDBGrid
        Left = 0
        Top = 0
        Width = 471
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
        Left = 471
        Top = 0
        Width = 110
        Height = 80
        Align = alRight
        TabOrder = 1
        object LabelObjectString: TLabel
          Left = 1
          Top = 1
          Width = 108
          Height = 13
          Align = alTop
          Alignment = taCenter
          Caption = 'ObjectString'
          ExplicitWidth = 58
        end
        object EditCountStringObject: TEdit
          Left = 1
          Top = 14
          Width = 108
          Height = 21
          Align = alTop
          TabOrder = 0
          Text = '5432'
        end
      end
    end
    object PanelGridObjectFloat: TPanel
      Left = 0
      Top = 281
      Width = 581
      Height = 80
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      object DBGridObjectFloat: TDBGrid
        Left = 0
        Top = 0
        Width = 471
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
        Left = 471
        Top = 0
        Width = 110
        Height = 80
        Align = alRight
        TabOrder = 1
        object LabelObjectFloat: TLabel
          Left = 1
          Top = 1
          Width = 108
          Height = 13
          Align = alTop
          Alignment = taCenter
          Caption = 'ObjectFloat'
          ExplicitWidth = 54
        end
        object EditCountFloatObject: TEdit
          Left = 1
          Top = 14
          Width = 108
          Height = 21
          Align = alTop
          TabOrder = 0
          Text = 'sqoII5szOnrcZxJVF1BL'
        end
      end
    end
    object PanelGridObjectDate: TPanel
      Left = 0
      Top = 361
      Width = 581
      Height = 67
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 3
      object DBGridObjectDate: TDBGrid
        Left = 0
        Top = 0
        Width = 471
        Height = 67
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
        Left = 471
        Top = 0
        Width = 110
        Height = 67
        Align = alRight
        TabOrder = 1
        object LabelObjectDate: TLabel
          Left = 1
          Top = 1
          Width = 108
          Height = 13
          Align = alTop
          Alignment = taCenter
          Caption = 'ObjectDate'
          ExplicitWidth = 54
        end
        object EditCountDateObject: TEdit
          Left = 1
          Top = 45
          Width = 108
          Height = 21
          Align = alBottom
          TabOrder = 0
          Text = 'project'
        end
      end
    end
    object PanelGridObjectBoolean: TPanel
      Left = 0
      Top = 428
      Width = 581
      Height = 72
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 4
      object DBGridObjectBoolean: TDBGrid
        Left = 0
        Top = 0
        Width = 471
        Height = 72
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
        Left = 471
        Top = 0
        Width = 110
        Height = 72
        Align = alRight
        TabOrder = 1
        object LabelObjectBoolean: TLabel
          Left = 1
          Top = 1
          Width = 108
          Height = 13
          Align = alTop
          Alignment = taCenter
          Caption = 'ObjectBoolean'
          ExplicitWidth = 70
        end
        object EditCountBooleanObject: TEdit
          Left = 1
          Top = 14
          Width = 108
          Height = 21
          Align = alTop
          TabOrder = 0
          Text = 'project'
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
        Width = 471
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
        Left = 471
        Top = 0
        Width = 110
        Height = 80
        Align = alRight
        TabOrder = 1
        object LabelObjectLink: TLabel
          Left = 1
          Top = 1
          Width = 108
          Height = 13
          Align = alTop
          Alignment = taCenter
          Caption = 'ObjectLink'
          ExplicitWidth = 51
        end
        object EditCountLinkObject: TEdit
          Left = 1
          Top = 14
          Width = 108
          Height = 21
          Align = alTop
          TabOrder = 0
          Text = 'integer-srv.alan.dp.ua'
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
    object btnOKMain_toChild: TButton
      Left = 111
      Top = 25
      Width = 97
      Height = 25
      Caption = 'GO Main -> Child'
      TabOrder = 0
      OnClick = btnOKMain_toChildClick
    end
    object btnStop: TButton
      Left = 217
      Top = 26
      Width = 70
      Height = 25
      Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100
      TabOrder = 1
      OnClick = btnStopClick
    end
    object CloseButton: TButton
      Left = 406
      Top = 26
      Width = 70
      Height = 25
      Caption = #1042#1099#1093#1086#1076
      TabOrder = 2
      OnClick = CloseButtonClick
    end
    object cbOnlyOpen: TCheckBox
      Left = 16
      Top = 30
      Width = 89
      Height = 17
      Caption = #1090#1086#1083#1100#1082#1086' OPEN'
      TabOrder = 3
    end
    object cbClientDataSet: TCheckBox
      Left = 484
      Top = 30
      Width = 126
      Height = 17
      Caption = 'CDS - '#1076#1083#1103' '#1073#1072#1079#1099' From '
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
    object cbShowGrid: TCheckBox
      Left = 616
      Top = 30
      Width = 158
      Height = 17
      Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1074' '#1043#1056#1048#1044#1077
      TabOrder = 5
    end
    object btnOKChild_toMain: TButton
      Left = 298
      Top = 26
      Width = 97
      Height = 25
      Caption = 'GO Child -> Main'
      TabOrder = 6
      OnClick = btnOKChild_toMainClick
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
    end
  end
  object ObjectDS: TDataSource
    DataSet = fQueryObject
    Left = 312
    Top = 144
  end
  object toSqlQuery: TZQuery
    Connection = childZConnection
    SQL.Strings = (
      'select  * from Object')
    Params = <>
    Properties.Strings = (
      'select * from Object order by 1 desc')
    Left = 72
    Top = 272
  end
  object spSelect_ReplObject: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplObject'
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
      end
      item
        Name = 'gConnectHost'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 247
    Top = 119
  end
  object childZConnection: TZConnection
    ControlsCodePage = cCP_UTF16
    UTF8StringsAsWideField = True
    HostName = '192.168.0.194'
    Port = 5432
    Database = 'project'
    User = 'postgres'
    Password = 'sqoII5szOnrcZxJVF1BL'
    Protocol = 'postgresql'
    Left = 24
    Top = 256
  end
  object toSqlQuery_two: TZQuery
    Connection = childZConnection
    SQL.Strings = (
      'select  * from Object')
    Params = <>
    Properties.Strings = (
      'select * from Object order by 1 desc')
    Left = 40
    Top = 304
  end
  object ObjectCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 300
    Top = 104
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 26
    Top = 78
  end
  object spSelect_ReplServer_load: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplServer_load'
    DataSet = ReplServerCDS
    DataSets = <
      item
        DataSet = ReplServerCDS
      end>
    Params = <
      item
        Name = 'gConnectHost'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 112
    Top = 54
  end
  object ReplServerCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 156
    Top = 36
  end
  object ObjectStringCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 312
    Top = 184
  end
  object ObjectStringDS: TDataSource
    DataSet = fQueryObjectString
    Left = 312
    Top = 208
  end
  object ObjectFloatCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 296
    Top = 253
  end
  object ObjectFloatDS: TDataSource
    DataSet = fQueryObjectFloat
    Left = 304
    Top = 277
  end
  object ObjectDateDS: TDataSource
    DataSet = fQueryObjectDate
    Left = 312
    Top = 384
  end
  object ObjectDateCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 290
    Top = 349
  end
  object ObjectBooleanDS: TDataSource
    DataSet = fQueryObjectBoolean
    Left = 312
    Top = 456
  end
  object ObjectBooleanCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 288
    Top = 424
  end
  object ObjectLinkDS: TDataSource
    DataSet = fQueryObjectLink
    Left = 307
    Top = 530
  end
  object ObjectLinkCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 272
    Top = 508
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
        Name = 'inSessionGUID_mov'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate'
        Value = Null
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
        Name = 'inDataBaseId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCount'
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
        Name = 'outCountHistory'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountHistoryString'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountHistoryFloat'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountHistoryDate'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountHistoryLink'
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
        Name = 'outCountIteration'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountPack'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'gConnectHost'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 128
    Top = 83
  end
  object mainZConnection: TZConnection
    ControlsCodePage = cCP_UTF16
    UTF8StringsAsWideField = True
    Catalog = 'public'
    DesignConnection = True
    HostName = 'localhost'
    Port = 5432
    Database = 'project'
    User = 'postgres'
    Password = 'postgres'
    Protocol = 'postgresql'
    Left = 29
    Top = 140
  end
  object fromSqlQuery: TZQuery
    Connection = mainZConnection
    SQL.Strings = (
      'select  * from Object')
    Params = <>
    Properties.Strings = (
      'select * from Object order by 1 desc')
    Left = 77
    Top = 127
  end
  object fQueryObject: TZQuery
    Connection = mainZConnection
    SQL.Strings = (
      'select  * from Object')
    Params = <>
    Left = 247
    Top = 92
  end
  object fQueryObjectString: TZQuery
    Connection = mainZConnection
    SQL.Strings = (
      'select  * from Object')
    Params = <>
    Left = 240
    Top = 168
  end
  object fQueryObjectFloat: TZQuery
    Connection = mainZConnection
    SQL.Strings = (
      'select  * from Object')
    Params = <>
    Left = 232
    Top = 268
  end
  object fQueryObjectDate: TZQuery
    Connection = mainZConnection
    SQL.Strings = (
      'select  * from Object')
    Params = <>
    Left = 224
    Top = 336
  end
  object fQueryObjectBoolean: TZQuery
    Connection = mainZConnection
    SQL.Strings = (
      'select  * from Object')
    Params = <>
    Left = 224
    Top = 408
  end
  object fQueryObjectLink: TZQuery
    Connection = mainZConnection
    SQL.Strings = (
      'select  * from Object')
    Params = <>
    Left = 216
    Top = 496
  end
  object spSelect_ReplObjectString: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplObjectString'
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
      end
      item
        Name = 'gConnectHost'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 240
    Top = 200
  end
  object spSelect_ReplObjectFloat: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplObjectFloat'
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
      end
      item
        Name = 'gConnectHost'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 232
    Top = 296
  end
  object spSelect_ReplObjectDate: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplObjectDate'
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
      end
      item
        Name = 'gConnectHost'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 224
    Top = 360
  end
  object spSelect_ReplObjectBoolean: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplObjectBoolean'
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
      end
      item
        Name = 'gConnectHost'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 224
    Top = 440
  end
  object spSelect_ReplObjectLink: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplObjectLink'
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
      end
      item
        Name = 'gConnectHost'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 216
    Top = 520
  end
  object spExecSql_repl_to: TdsdStoredProc
    StoredProcName = 'gpExecSql_repl'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inSqlText'
        Value = Null
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gConnectHost'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 120
    Top = 216
  end
  object fromSqlQuery_two: TZQuery
    Connection = mainZConnection
    SQL.Strings = (
      'select  * from Object')
    Params = <>
    Properties.Strings = (
      'select * from Object order by 1 desc')
    Left = 64
    Top = 168
  end
  object spSelect_ReplMovement: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplMovement'
    DataSet = MovementCDS
    DataSets = <
      item
        DataSet = MovementCDS
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
      end
      item
        Name = 'gConnectHost'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 695
    Top = 173
  end
  object fQueryMovement: TZQuery
    Connection = mainZConnection
    Params = <>
    Properties.Strings = (
      'select * from Object order by 1 desc')
    Left = 695
    Top = 152
  end
  object MovementCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 757
    Top = 163
  end
  object spInsert_ReplMovement: TdsdStoredProc
    StoredProcName = 'gpInsert_ReplMovement'
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
        Value = Null
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
        Name = 'inDataBaseId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCount'
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
        Name = 'outCountLinkM'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountMI'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountMIString'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountMIFloat'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountMIDate'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountMIBoolean'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountMILink'
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
        Name = 'outCountIteration'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountPack'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'gConnectHost'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 680
    Top = 83
  end
  object fQueryMS: TZQuery
    Connection = mainZConnection
    Params = <>
    Properties.Strings = (
      'select * from Object order by 1 desc')
    Left = 695
    Top = 216
  end
  object spSelect_ReplMS: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplMS'
    DataSet = MSCDS
    DataSets = <
      item
        DataSet = MSCDS
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
      end
      item
        Name = 'gConnectHost'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 695
    Top = 237
  end
  object MSCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 745
    Top = 225
  end
  object fQueryMF: TZQuery
    Connection = mainZConnection
    Params = <>
    Properties.Strings = (
      'select * from Object order by 1 desc')
    Left = 695
    Top = 280
  end
  object spSelect_ReplMF: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplMF'
    DataSet = MFCDS
    DataSets = <
      item
        DataSet = MFCDS
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
      end
      item
        Name = 'gConnectHost'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 695
    Top = 298
  end
  object MFCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 748
    Top = 284
  end
  object spSelect_ReplMD: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplMD'
    DataSet = MDCDS
    DataSets = <
      item
        DataSet = MDCDS
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
      end
      item
        Name = 'gConnectHost'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 695
    Top = 360
  end
  object MDCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 749
    Top = 353
  end
  object fQueryMD: TZQuery
    Connection = mainZConnection
    Params = <>
    Properties.Strings = (
      'select * from Object order by 1 desc')
    Left = 695
    Top = 342
  end
  object fQueryMB: TZQuery
    Connection = mainZConnection
    Params = <>
    Properties.Strings = (
      'select * from Object order by 1 desc')
    Left = 699
    Top = 404
  end
  object MBCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 752
    Top = 409
  end
  object spSelect_ReplMB: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplMB'
    DataSet = MBCDS
    DataSets = <
      item
        DataSet = MBCDS
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
      end
      item
        Name = 'gConnectHost'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 699
    Top = 424
  end
  object fQueryMLO: TZQuery
    Connection = mainZConnection
    Params = <>
    Properties.Strings = (
      'select * from Object order by 1 desc')
    Left = 699
    Top = 468
  end
  object spSelect_ReplMLO: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplMLO'
    DataSet = MLOCDS
    DataSets = <
      item
        DataSet = MLOCDS
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
      end
      item
        Name = 'gConnectHost'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 699
    Top = 488
  end
  object MLOCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 752
    Top = 475
  end
  object fQueryMLM: TZQuery
    Connection = mainZConnection
    Params = <>
    Properties.Strings = (
      'select * from Object order by 1 desc')
    Left = 702
    Top = 530
  end
  object spSelect_ReplMLM: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplMLM'
    DataSet = MLMCDS
    DataSets = <
      item
        DataSet = MLMCDS
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
      end
      item
        Name = 'gConnectHost'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 702
    Top = 550
  end
  object MLMCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 755
    Top = 537
  end
  object spExecForm_repl_to: TdsdStoredProc
    StoredProcName = 'gpExecForm_repl'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inFormName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFormData'
        Value = Null
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gConnectHost'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 136
    Top = 283
  end
  object spInsert_ReplMovement_fromChild: TdsdStoredProc
    StoredProcName = 'gpInsert_ReplMovement_fromChild'
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
        Value = Null
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
        Name = 'inDataBaseId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCount'
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
        Name = 'outCountLinkM'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountMI'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountMIString'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountMIFloat'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountMIDate'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountMIBoolean'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountMILink'
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
        Name = 'outCountIteration'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountPack'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'gConnectHost'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 872
    Top = 75
  end
  object spSelect_ReplMovement_Child: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplMovement'
    DataSet = Movement_ChildCDS
    DataSets = <
      item
        DataSet = Movement_ChildCDS
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
      end
      item
        Name = 'gConnectHost'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 879
    Top = 117
  end
  object Movement_ChildCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 965
    Top = 139
  end
  object spSelect_ReplMS1: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplMS'
    DataSet = MSCDS1
    DataSets = <
      item
        DataSet = MSCDS1
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
      end
      item
        Name = 'gConnectHost'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 903
    Top = 213
  end
  object MSCDS1: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 953
    Top = 201
  end
  object spSelect_ReplMF1: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplMF'
    DataSet = MFCDS1
    DataSets = <
      item
        DataSet = MFCDS1
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
      end
      item
        Name = 'gConnectHost'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 903
    Top = 274
  end
  object MFCDS1: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 956
    Top = 260
  end
  object spSelect_ReplMD1: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplMD'
    DataSet = MDCDS1
    DataSets = <
      item
        DataSet = MDCDS1
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
      end
      item
        Name = 'gConnectHost'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 903
    Top = 336
  end
  object MDCDS1: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 957
    Top = 321
  end
  object spSelect_ReplMB1: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplMB'
    DataSet = MBCDS1
    DataSets = <
      item
        DataSet = MBCDS1
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
      end
      item
        Name = 'gConnectHost'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 907
    Top = 400
  end
  object MBCDS1: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 960
    Top = 385
  end
  object spSelect_ReplMLO1: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplMLO'
    DataSet = MLOCDS1
    DataSets = <
      item
        DataSet = MLOCDS1
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
      end
      item
        Name = 'gConnectHost'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 907
    Top = 464
  end
  object MLOCDS1: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 960
    Top = 451
  end
  object spSelect_ReplMLM1: TdsdStoredProc
    StoredProcName = 'gpSelect_ReplMLM'
    DataSet = MLMCDS1
    DataSets = <
      item
        DataSet = MLMCDS1
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
      end
      item
        Name = 'gConnectHost'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 910
    Top = 526
  end
  object MLMCDS1: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 971
    Top = 513
  end
end
