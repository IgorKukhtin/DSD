object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1069#1082#1089#1087#1086#1088#1090' '#1086#1089#1090#1072#1090#1082#1086#1074' '#1085#1072' '#1041#1072#1081#1077#1088
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
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object grReportUnit: TcxGrid
    Left = 0
    Top = 177
    Width = 909
    Height = 347
    Align = alClient
    TabOrder = 1
    ExplicitTop = 235
    ExplicitHeight = 289
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
      object UnitName: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
        DataBinding.FieldName = 'UnitName'
        Options.Editing = False
        Width = 212
      end
      object GoodsName: TcxGridDBColumn
        Caption = #1058#1086#1074#1072#1088
        DataBinding.FieldName = 'GoodsName'
        Options.Editing = False
        Width = 204
      end
      object Barcode: TcxGridDBColumn
        DataBinding.FieldName = 'Barcode'
        Options.Editing = False
        Width = 117
      end
      object CodeRazom: TcxGridDBColumn
        Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
        DataBinding.FieldName = 'CodeRazom'
        Width = 72
      end
      object Amount: TcxGridDBColumn
        Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
        DataBinding.FieldName = 'Amount'
        Options.Editing = False
        Width = 75
      end
      object Token: TcxGridDBColumn
        Caption = #1058#1086#1082#1077#1085
        DataBinding.FieldName = 'Token'
        Options.Editing = False
        Width = 192
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
    object btnSendHTTPS: TButton
      Left = 775
      Top = 0
      Width = 113
      Height = 25
      Caption = #1055#1086#1089#1083#1072#1090#1100' '#1085#1072' HTTPS'
      TabOrder = 1
      OnClick = btnSendHTTPSClick
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
      TabOrder = 2
      OnClick = btnAllClick
    end
  end
  object cxGrid: TcxGrid
    Left = 0
    Top = 31
    Width = 909
    Height = 146
    Align = alTop
    TabOrder = 2
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    LookAndFeel.SkinName = ''
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = sdGoods
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.IncSearch = True
      OptionsBehavior.IncSearchItem = goodsDrugName
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsSelection.InvertSelect = False
      OptionsView.GroupByBox = False
      OptionsView.Indicator = True
      object goodsID: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'ID'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 66
      end
      object goodsDrugName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'DrugName'
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 385
      end
      object goodsDrugBarcode: TcxGridDBColumn
        Caption = #1064#1090#1088#1080#1093#1082#1086#1076
        DataBinding.FieldName = 'DrugBarcode'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 114
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
      ' SELECT * FROM gpSelect_GoodsOnRemains_Bayer ('#39'3'#39')')
    Params = <>
    Left = 108
    Top = 312
  end
  object dsReport_Upload: TDataSource
    DataSet = qryReport_Upload
    Left = 248
    Top = 312
  end
  object sdGoods: TDataSource
    Left = 488
    Top = 112
  end
end
