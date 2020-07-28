object MainForm: TMainForm
  Left = 0
  Top = 0
  AutoSize = True
  Caption = #1069#1082#1089#1087#1086#1088#1090' '#1086#1090#1095#1077#1090#1086#1074' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084
  ClientHeight = 566
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
  object grReport: TcxGrid
    Left = 0
    Top = 235
    Width = 909
    Height = 331
    Align = alClient
    TabOrder = 1
    object grtvReport: TcxGridDBTableView
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
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
    end
    object grReportLevel1: TcxGridLevel
      GridView = grtvReport
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 909
    Height = 31
    Align = alTop
    TabOrder = 0
    object btnSendMail: TButton
      Left = 775
      Top = 0
      Width = 113
      Height = 25
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' Email'
      TabOrder = 3
      OnClick = btnSendMailClick
    end
    object btnExport: TButton
      Left = 711
      Top = 0
      Width = 58
      Height = 25
      Caption = #1069#1082#1089#1087#1086#1088#1090
      TabOrder = 2
      OnClick = btnExportClick
    end
    object btnExecute: TButton
      Left = 615
      Top = 0
      Width = 90
      Height = 25
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100
      TabOrder = 1
      OnClick = btnExecuteClick
    end
    object btnAll: TButton
      Left = 16
      Top = 0
      Width = 97
      Height = 25
      Caption = #1042#1089#1105' '#1087#1086' '#1074#1089#1077#1084'!'
      TabOrder = 4
      OnClick = btnAllClick
    end
    object btnAllLine: TButton
      Left = 480
      Top = 0
      Width = 129
      Height = 25
      Caption = #1042#1089#1105' '#1087#1086' '#1089#1090#1088#1086#1082#1077
      TabOrder = 0
      OnClick = btnAllLineClick
    end
    object btnSaveSchedulerCDS: TButton
      Left = 176
      Top = 0
      Width = 137
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1084#1080#1090' '#1085#1072#1089#1090#1088#1086#1081#1082#1080
      TabOrder = 5
      OnClick = btnSaveSchedulerCDSClick
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
      DataController.DataSource = SchedulerDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = Name
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.IncSearch = True
      OptionsBehavior.IncSearchItem = Name
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsSelection.InvertSelect = False
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 60
      OptionsView.Indicator = True
      object Id: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Id'
        HeaderAlignmentHorz = taCenter
        Width = 42
      end
      object Name: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1086#1090#1095#1077#1090#1072
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 168
      end
      object DateRun: TcxGridDBColumn
        Caption = #1050#1086#1075#1076#1072' '#1087#1083#1072#1085#1080#1088#1091#1077#1084' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' ('#1076#1072#1090#1072'/'#1074#1088#1077#1084#1103')'
        DataBinding.FieldName = 'DateRun'
        PropertiesClassName = 'TcxDateEditProperties'
        Properties.Kind = ckDateTime
        HeaderAlignmentHorz = taCenter
        HeaderHint = #1050#1086#1075#1076#1072' '#1087#1083#1072#1085#1080#1088#1091#1077#1084' '#1086#1090#1087#1088#1072#1074#1080#1090#1100'('#1076#1072#1090#1072'/'#1074#1088#1077#1084#1103')'
        Width = 85
      end
      object Mail: TcxGridDBColumn
        Caption = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1072#1103' '#1087#1086#1095#1090#1072
        DataBinding.FieldName = 'Mail'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 122
      end
      object Interval: TcxGridDBColumn
        Caption = #1055#1077#1088#1080#1086#1076'.  '#1076#1085#1077#1081
        DataBinding.FieldName = 'Interval'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderHint = #1055#1077#1088#1080#1086#1076#1080#1095#1085#1086#1089#1090#1100' '#1086#1090#1087#1088#1072#1074#1082#1080'  '#1074' 1..29 '#1076#1085#1080' 30 '#1087#1086#1084#1077#1089#1103#1095#1085#1086
        Width = 53
      end
      object Proceure: TcxGridDBColumn
        Caption = #1055#1088#1086#1094#1077#1076#1091#1088#1072
        DataBinding.FieldName = 'Proceure'
        HeaderAlignmentHorz = taCenter
        Width = 411
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
    Left = 40
    Top = 144
  end
  object SchedulerDS: TDataSource
    DataSet = SchedulerCDS
    Left = 224
    Top = 384
  end
  object qryMailParam: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      'SELECT'
      '    zc_Mail_From() AS Mail_From,'
      '    zc_Mail_Host() AS Mail_Host,'
      '    zc_Mail_Port() AS Mail_Port,'
      '    zc_Mail_User() AS Mail_User,'
      '    zc_Mail_Password() AS Mail_Password')
    Params = <>
    Left = 144
    Top = 328
  end
  object qryReport_Upload: TZQuery
    Connection = ZConnection1
    Params = <>
    Left = 556
    Top = 336
  end
  object dsReport_Upload: TDataSource
    DataSet = qryReport_Upload
    Left = 680
    Top = 336
  end
  object SchedulerCDS: TClientDataSet
    PersistDataPacket.Data = {
      C00000009619E0BD010000001800000006000000000003000000C00002494404
      0001000200010007535542545950450200490008004175746F696E6300044E61
      6D650100490000000100055749445448020002003C00074461746552756E0800
      08000000000008496E74657276616C04000100000000000850726F6365757265
      020049000000010005574944544802000200F401044D61696C01004900000001
      0005574944544802000200FA0001000C4155544F494E4356414C554504000100
      01000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'ID'
        Attributes = [faReadonly]
        DataType = ftAutoInc
      end
      item
        Name = 'Name'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'DateRun'
        DataType = ftDateTime
      end
      item
        Name = 'Interval'
        DataType = ftInteger
      end
      item
        Name = 'Proceure'
        DataType = ftString
        Size = 500
      end
      item
        Name = 'Mail'
        DataType = ftString
        Size = 250
      end>
    IndexDefs = <
      item
        Name = 'DEFAULT_ORDER'
      end
      item
        Name = 'CHANGEINDEX'
      end>
    IndexFieldNames = 'Id'
    Params = <>
    StoreDefs = True
    Left = 144
    Top = 384
    object SchedulerCDSID: TAutoIncField
      FieldName = 'ID'
      ReadOnly = True
    end
    object SchedulerCDSName: TStringField
      FieldName = 'Name'
      Size = 60
    end
    object SchedulerCDSDateRun: TDateTimeField
      FieldName = 'DateRun'
    end
    object SchedulerCDSInterval: TIntegerField
      FieldName = 'Interval'
    end
    object SchedulerCDSProceure: TStringField
      FieldName = 'Proceure'
      Size = 500
    end
    object SchedulerCDSMail: TStringField
      FieldName = 'Mail'
      Size = 250
    end
  end
end
