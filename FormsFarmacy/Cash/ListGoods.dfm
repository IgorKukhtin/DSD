inherited ListGoodsForm: TListGoodsForm
  BorderIcons = [biSystemMenu]
  Caption = #1055#1086#1076#1073#1086#1088' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1086#1074
  ClientHeight = 365
  ClientWidth = 528
  OnCreate = ParentFormCreate
  OnKeyDown = ParentFormKeyDown
  ExplicitWidth = 544
  ExplicitHeight = 404
  PixelsPerInch = 96
  TextHeight = 13
  object ListGoodsGrid: TcxGrid [0]
    Left = 0
    Top = 25
    Width = 528
    Height = 340
    Align = alClient
    TabOrder = 1
    object ListGoodsGridDBTableView: TcxGridDBTableView
      OnDblClick = ListGoodsGridDBTableViewDblClick
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = ListGoodsDS
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.GridLineColor = clBtnFace
      OptionsView.GroupByBox = False
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object colGoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
      end
      object colGoodsName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'GoodsName'
        OnCustomDrawCell = colGoodsNameCustomDrawCell
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 328
      end
      object colPrice: TcxGridDBColumn
        Caption = #1062#1077#1085#1072
        DataBinding.FieldName = 'Price'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 86
      end
    end
    object ListGoodsGridLevel: TcxGridLevel
      Caption = #1040#1083#1100#1090' (24 '#1087#1086#1079') "*"'
      GridView = ListGoodsGridDBTableView
    end
  end
  object pnl1: TPanel [1]
    Left = 0
    Top = 0
    Width = 528
    Height = 25
    Align = alTop
    TabOrder = 0
    object edt1: TEdit
      Left = 1
      Top = 1
      Width = 526
      Height = 23
      Align = alClient
      AutoSelect = False
      TabOrder = 0
      OnChange = edt1Change
      OnExit = edt1Exit
      ExplicitHeight = 21
    end
    object ProgressBar1: TProgressBar
      Left = 459
      Top = 13
      Width = 57
      Height = 9
      BarColor = clMedGray
      TabOrder = 1
      Visible = False
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 304
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 248
    Top = 304
  end
  inherited ActionList: TActionList
    Left = 183
    Top = 303
    object actListDiffAddGoods: TAction
      Category = 'DSDLib'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1088#1077#1087#1072#1088#1072#1090' '#1074' '#1083#1080#1089#1090' '#1086#1090#1082#1072#1079#1086#1074
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1088#1077#1087#1072#1088#1072#1090' '#1085#1072' '#1082#1086#1090#1086#1088#1086#1084' '#1095#1090#1086#1080#1090' '#1082#1091#1088#1089#1086#1088' '#1074' '#1083#1080#1089#1090' '#1086#1090#1082#1072#1079#1086#1074
      OnExecute = actListDiffAddGoodsExecute
    end
  end
  object ListGoodsDS: TDataSource
    DataSet = ListGoodsCDS
    Left = 432
    Top = 136
  end
  object ListGoodsCDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    IndexFieldNames = 'GoodsName'
    Params = <>
    StoreDefs = True
    Left = 360
    Top = 136
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer1Timer
    Left = 432
    Top = 80
  end
end
