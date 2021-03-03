object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1076#1083#1103' '#1060#1072#1088#1084#1072#1082' '
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
      object PharmacyId: TcxGridDBColumn
        DataBinding.FieldName = 'PharmacyId'
        Options.Editing = False
        Width = 60
      end
      object ProductId: TcxGridDBColumn
        DataBinding.FieldName = 'ProductId'
        Options.Editing = False
        Width = 60
      end
      object ProductName: TcxGridDBColumn
        DataBinding.FieldName = 'ProductName'
        Options.Editing = False
        Width = 60
      end
      object Producer: TcxGridDBColumn
        DataBinding.FieldName = 'Producer'
        Options.Editing = False
        Width = 60
      end
      object Morion: TcxGridDBColumn
        DataBinding.FieldName = 'Morion'
        Options.Editing = False
        Width = 60
      end
      object Barcode: TcxGridDBColumn
        DataBinding.FieldName = 'Barcode'
        Width = 60
      end
      object RegistrationNumber: TcxGridDBColumn
        DataBinding.FieldName = 'RegistrationNumber'
        Options.Editing = False
        Width = 60
      end
      object Optima: TcxGridDBColumn
        DataBinding.FieldName = 'Optima'
        Options.Editing = False
        Width = 60
      end
      object Badm: TcxGridDBColumn
        DataBinding.FieldName = 'Badm'
        Options.Editing = False
        Width = 60
      end
      object Quantity: TcxGridDBColumn
        DataBinding.FieldName = 'Quantity'
        Options.Editing = False
        Width = 60
      end
      object Price: TcxGridDBColumn
        DataBinding.FieldName = 'Price'
        Options.Editing = False
        Width = 60
      end
      object OfflinePrice: TcxGridDBColumn
        DataBinding.FieldName = 'OfflinePrice'
        Options.Editing = False
        Width = 60
      end
      object PickupPrice: TcxGridDBColumn
        DataBinding.FieldName = 'PickupPrice'
        Options.Editing = False
        Width = 60
      end
      object i10000001: TcxGridDBColumn
        DataBinding.FieldName = '10000001 - insurance company #1 id'
        Options.Editing = False
        Width = 60
      end
      object i10000002: TcxGridDBColumn
        DataBinding.FieldName = '10000002 - insurance company #2 id'
        Options.Editing = False
        Width = 60
      end
      object Vat: TcxGridDBColumn
        DataBinding.FieldName = 'Vat'
        Options.Editing = False
        Width = 60
      end
      object PackSize: TcxGridDBColumn
        DataBinding.FieldName = 'PackSize'
        Options.Editing = False
        Width = 60
      end
      object PackDivisor: TcxGridDBColumn
        DataBinding.FieldName = 'PackDivisor'
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
    object btnSendEmail: TButton
      Left = 775
      Top = 0
      Width = 113
      Height = 25
      Caption = #1055#1086#1089#1083#1072#1090#1100' '#1085#1072' EMAIL'
      TabOrder = 3
      OnClick = btnSendEmailClick
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
    object btnExecuteUnit: TButton
      Left = 167
      Top = 0
      Width = 106
      Height = 25
      Caption = #1069#1082#1089#1087#1086#1088#1090' '#1072#1087#1090#1077#1082
      TabOrder = 5
      OnClick = btnExecuteUnitClick
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
        DataBinding.FieldName = 'PharmacyId'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 86
      end
      object Phones: TcxGridDBColumn
        DataBinding.FieldName = 'CompanyId'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 90
      end
      object UnitName: TcxGridDBColumn
        DataBinding.FieldName = 'PharmacyName'
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 168
      end
      object Address: TcxGridDBColumn
        DataBinding.FieldName = 'PharmacyAddress'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 251
      end
      object PharmacistId: TcxGridDBColumn
        DataBinding.FieldName = 'PharmacistId'
        Options.Editing = False
      end
      object PharmacistName: TcxGridDBColumn
        DataBinding.FieldName = 'PharmacistName'
        Options.Editing = False
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
      ' SELECT * FROM gpSelect_Farmak_CRMPharmacy('#39'3'#39')')
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
      
        ' SELECT * FROM gpSelect_GoodsOnUnitRemains_ForLiki24 (:UnitId, '#39 +
        '3'#39')')
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
