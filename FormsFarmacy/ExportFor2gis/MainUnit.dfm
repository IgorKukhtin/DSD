object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1069#1082#1089#1087#1086#1088#1090' '#1085#1072' 2gis'
  ClientHeight = 524
  ClientWidth = 909
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object grReportUnit: TcxGrid
    Left = 0
    Top = 235
    Width = 909
    Height = 289
    Align = alClient
    TabOrder = 1
    object grtvUnit: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = dsReport_Upload
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.CellTextMaxLineCount = 100
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      object ProductName: TcxGridDBColumn
        Caption = 'name'
        DataBinding.FieldName = 'ProductName'
        Options.Editing = False
        Width = 212
      end
      object Price: TcxGridDBColumn
        Caption = 'price'
        DataBinding.FieldName = 'Price'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00'
        Options.Editing = False
        Width = 93
      end
      object Producer: TcxGridDBColumn
        Caption = 'vendor'
        DataBinding.FieldName = 'Producer'
        Width = 152
      end
    end
    object grReportUnitLevel1: TcxGridLevel
      GridView = grtvUnit
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 909
    Height = 31
    Align = alTop
    TabOrder = 0
    object btnSendFTP: TButton
      Left = 775
      Top = 0
      Width = 113
      Height = 25
      Caption = #1055#1086#1089#1083#1072#1090#1100' '#1085#1072' FTP'
      TabOrder = 2
      OnClick = btnSendFTPClick
    end
    object btnExport: TButton
      Left = 711
      Top = 0
      Width = 58
      Height = 25
      Caption = #1069#1082#1089#1087#1086#1088#1090
      TabOrder = 1
      OnClick = btnExportClick
    end
    object btnExecute: TButton
      Left = 615
      Top = 0
      Width = 90
      Height = 25
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100
      TabOrder = 0
      OnClick = btnExecuteClick
    end
    object btnAll: TButton
      Left = 16
      Top = 0
      Width = 97
      Height = 25
      Caption = #1042#1089#1105' '#1087#1086' '#1074#1089#1077#1084'!'
      TabOrder = 3
      OnClick = btnAllClick
    end
    object btnAllUnit: TButton
      Left = 480
      Top = 0
      Width = 129
      Height = 25
      Caption = #1042#1089#1105' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1102
      TabOrder = 4
      OnClick = btnAllUnitClick
    end
  end
  object cxGrid: TcxGrid
    Left = 0
    Top = 31
    Width = 909
    Height = 204
    Align = alTop
    TabOrder = 2
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    LookAndFeel.SkinName = ''
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = dsUnit
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.IncSearch = True
      OptionsBehavior.IncSearchItem = UnitName
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsSelection.InvertSelect = False
      OptionsView.GroupByBox = False
      OptionsView.Indicator = True
      object UnitCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Id'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 66
      end
      object UnitName: TcxGridDBColumn
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 385
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object ZConnection1: TZConnection
    ControlsCodePage = cCP_UTF16
    Catalog = ''
    HostName = ''
    Port = 5432
    Database = ''
    User = ''
    Password = ''
    Protocol = 'postgresql-9'
    Left = 136
    Top = 136
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 48
    Top = 136
  end
  object qryReport_Upload: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      ' SELECT * FROM gpSelect_GoodsOnRemains_For2gis (:UnitID, '#39'3'#39')')
    Params = <
      item
        DataType = ftUnknown
        Name = 'UnitID'
        ParamType = ptUnknown
      end>
    Left = 412
    Top = 328
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'UnitID'
        ParamType = ptUnknown
      end>
  end
  object dsReport_Upload: TDataSource
    DataSet = qryReport_Upload
    Left = 624
    Top = 320
  end
  object IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 784
    Top = 56
  end
  object IdHTTP: TIdHTTP
    IOHandler = IdSSLIOHandlerSocketOpenSSL1
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 672
    Top = 56
  end
  object IdFTP1: TIdFTP
    IPVersion = Id_IPv4
    Host = 'ftp:\\ooobadm.dp.ua'
    Passive = True
    ConnectTimeout = 0
    TransferType = ftBinary
    NATKeepAlive.UseKeepAlive = False
    NATKeepAlive.IdleTimeMS = 0
    NATKeepAlive.IntervalMS = 0
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    Left = 608
    Top = 56
  end
  object dsUnit: TDataSource
    DataSet = qryUnit
    Left = 224
    Top = 328
  end
  object qryUnit: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      ' SELECT * FROM gpSelect_Object_Unit_For2gis ('#39'3'#39')')
    Params = <>
    Left = 144
    Top = 328
  end
end
