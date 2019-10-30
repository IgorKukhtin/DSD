object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1076#1083#1103' Helsi'
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
    Top = 193
    Width = 909
    Height = 331
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
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' FTP'
      TabOrder = 5
      OnClick = btnSendFTPClick
    end
    object btnExport: TButton
      Left = 711
      Top = 0
      Width = 58
      Height = 25
      Caption = #1069#1082#1089#1087#1086#1088#1090
      TabOrder = 4
      OnClick = btnExportClick
    end
    object btnExecute: TButton
      Left = 575
      Top = 0
      Width = 114
      Height = 25
      Caption = #1054#1089#1090#1072#1090#1082#1080' '#1087#1086' '#1072#1087#1090#1077#1082#1077
      TabOrder = 3
      OnClick = btnExecuteClick
    end
    object btnAll: TButton
      Left = 16
      Top = 0
      Width = 97
      Height = 25
      Caption = #1042#1089#1105' '#1087#1086' '#1074#1089#1077#1084'!'
      TabOrder = 6
      OnClick = btnAllClick
    end
    object btnAllUnit: TButton
      Left = 279
      Top = 0
      Width = 129
      Height = 25
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1072#1087#1090#1077#1082
      TabOrder = 1
      OnClick = btnAllUnitClick
    end
    object btnGoods: TButton
      Left = 424
      Top = 0
      Width = 129
      Height = 25
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1090#1086#1074#1072#1088#1086#1074
      TabOrder = 2
      OnClick = btnGoodsClick
    end
    object btnJuridical: TButton
      Left = 128
      Top = 0
      Width = 129
      Height = 25
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1102#1088'. '#1083#1080#1094
      TabOrder = 0
      OnClick = btnJuridicalClick
    end
  end
  object cxGrid: TcxGrid
    Left = 0
    Top = 31
    Width = 909
    Height = 162
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
      OptionsBehavior.IncSearchItem = JuridicalName
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
        DataBinding.FieldName = 'UnitCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 42
      end
      object UnitName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1088#1075#1086#1074#1086#1081' '#1090#1086#1095#1082#1080
        DataBinding.FieldName = 'UnitName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 198
      end
      object JuridicalCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1102#1088'.'#1083#1080#1094#1072
        DataBinding.FieldName = 'JuridicalCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 88
      end
      object JuridicalName: TcxGridDBColumn
        Caption = #1070#1088'.'#1083#1080#1094
        DataBinding.FieldName = 'JuridicalName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 177
      end
      object Address: TcxGridDBColumn
        Caption = #1040#1076#1088#1077#1089' '#1090#1086#1088#1075#1086#1074#1086#1081' '#1090#1086#1095#1082#1080
        DataBinding.FieldName = 'Address'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 318
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object ZConnection1: TZConnection
    ControlsCodePage = cCP_UTF16
    Port = 5432
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
  object qryUnit: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      ' SELECT * FROM gpSelect_Object_Unit_ExportPriceForHelsi ('#39'3'#39')')
    Params = <>
    Left = 88
    Top = 384
  end
  object dsUnit: TDataSource
    DataSet = qryUnit
    Left = 152
    Top = 386
  end
  object qryReport_Upload: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      
        ' SELECT * FROM gpSelect_GoodsOnUnitRemains_ForGeoApteka (:UnitId' +
        ', '#39'3'#39')')
    Params = <
      item
        DataType = ftUnknown
        Name = 'UnitId'
        ParamType = ptUnknown
      end>
    Left = 524
    Top = 376
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'UnitId'
        ParamType = ptUnknown
      end>
  end
  object dsReport_Upload: TDataSource
    DataSet = qryReport_Upload
    Left = 648
    Top = 376
  end
  object IdFTP1: TIdFTP
    IPVersion = Id_IPv4
    Host = 'ftp:\\ooobadm.dp.ua'
    Passive = True
    Password = 'FsT3469Dv'
    Username = 'K_shapiro'
    NATKeepAlive.UseKeepAlive = False
    NATKeepAlive.IdleTimeMS = 0
    NATKeepAlive.IntervalMS = 0
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    ServerHOST = 'ftp:\\ooobadm.dp.ua'
    Left = 304
    Top = 144
  end
end
