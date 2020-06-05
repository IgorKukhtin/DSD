object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1076#1083#1103' Doc.UA'
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
      object MedicineId: TcxGridDBColumn
        DataBinding.FieldName = 'Id'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 60
      end
      object Name_ru: TcxGridDBColumn
        DataBinding.FieldName = 'Name_ru'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 213
      end
      object Name_ua: TcxGridDBColumn
        DataBinding.FieldName = 'Name_ua'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 274
      end
      object Marion_Code: TcxGridDBColumn
        DataBinding.FieldName = 'Marion_Code'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 82
      end
      object Badm_Code: TcxGridDBColumn
        DataBinding.FieldName = 'Badm_Code'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 91
      end
      object Description: TcxGridDBColumn
        DataBinding.FieldName = 'Description'
        HeaderAlignmentHorz = taCenter
        Width = 60
      end
      object Price: TcxGridDBColumn
        DataBinding.FieldName = 'Price'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 60
      end
      object Quantity: TcxGridDBColumn
        DataBinding.FieldName = 'Quantity'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 60
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
    object btnSendSFTP: TButton
      Left = 775
      Top = 0
      Width = 113
      Height = 25
      Caption = #1055#1086#1089#1083#1072#1090#1100' '#1085#1072' SFTP'
      TabOrder = 3
      OnClick = btnSendSFTPClick
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
    object btnAllUnit: TButton
      Left = 480
      Top = 0
      Width = 129
      Height = 25
      Caption = #1042#1089#1105' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1102
      TabOrder = 0
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
      object UnitId: TcxGridDBColumn
        DataBinding.FieldName = 'Id'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 42
      end
      object Head: TcxGridDBColumn
        DataBinding.FieldName = 'Head'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 120
      end
      object UnitName: TcxGridDBColumn
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 168
      end
      object Addr: TcxGridDBColumn
        DataBinding.FieldName = 'Addr'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 251
      end
      object Agent: TcxGridDBColumn
        DataBinding.FieldName = 'Agent'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 120
      end
      object UnitCity: TcxGridDBColumn
        DataBinding.FieldName = 'City'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 120
      end
      object Branch_location_lat: TcxGridDBColumn
        DataBinding.FieldName = 'Branch_location_lat'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 120
      end
      object Branch_location_lng: TcxGridDBColumn
        DataBinding.FieldName = 'Branch_location_lng'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 120
      end
      object Phones: TcxGridDBColumn
        DataBinding.FieldName = 'Phones'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 170
      end
      object Schedule: TcxGridDBColumn
        DataBinding.FieldName = 'Schedule'
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 120
      end
      object Reservation_time: TcxGridDBColumn
        DataBinding.FieldName = 'Reservation_time'
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 120
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
  object qryUnit: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      ' SELECT * FROM gpSelect_Object_Unit_ExportPriceForDocUA('#39'3'#39')')
    Params = <>
    Left = 144
    Top = 384
  end
  object dsUnit: TDataSource
    DataSet = qryUnit
    Left = 224
    Top = 384
  end
  object qryReport_Upload: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      
        ' SELECT * FROM gpSelect_GoodsOnUnitRemains_ForDocUA (:UnitId, '#39'3' +
        #39')')
    Params = <
      item
        DataType = ftUnknown
        Name = 'UnitId'
        ParamType = ptUnknown
      end>
    Left = 556
    Top = 336
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'UnitId'
        ParamType = ptUnknown
      end>
  end
  object dsReport_Upload: TDataSource
    DataSet = qryReport_Upload
    Left = 680
    Top = 336
  end
end
