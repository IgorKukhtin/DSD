object Report_Sale_OlapForm: TReport_Sale_OlapForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' ('#1054#1051#1040#1055')'
  ClientHeight = 448
  ClientWidth = 977
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object PanelHead: TPanel
    Left = 0
    Top = 0
    Width = 977
    Height = 55
    Align = alTop
    TabOrder = 0
    object deStart: TcxDateEdit
      Left = 83
      Top = 5
      EditValue = 43101d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 79
    end
    object deEnd: TcxDateEdit
      Left = 83
      Top = 29
      EditValue = 43101d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 79
    end
    object cxLabel1: TcxLabel
      Left = 12
      Top = 6
      Caption = #1055#1077#1088#1080#1086#1076'1 '#1089' ...'
    end
    object cxLabel2: TcxLabel
      Left = 5
      Top = 30
      AutoSize = False
      Caption = #1055#1077#1088#1080#1086#1076'1 '#1087#1086' ...'
      Height = 17
      Width = 76
    end
    object cxLabel3: TcxLabel
      Left = 327
      Top = 7
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edUnitGroup: TcxButtonEdit
      Left = 415
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 195
    end
    object cxLabel4: TcxLabel
      Left = 614
      Top = 6
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074':'
    end
    object edGoodsGroup: TcxButtonEdit
      Left = 709
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 236
    end
    object cxLabel8: TcxLabel
      Left = 665
      Top = 30
      Caption = #1058#1086#1074#1072#1088':'
    end
    object edGoods: TcxButtonEdit
      Left = 709
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 236
    end
    object cbIsMovement: TcxCheckBox
      Left = 341
      Top = 29
      Caption = #1055#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
      TabOrder = 10
      Width = 105
    end
    object cbisPartion: TcxCheckBox
      Left = 477
      Top = 29
      Caption = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      TabOrder = 11
      Width = 105
    end
  end
  object cxDBPivotGrid: TcxDBPivotGrid
    Left = 0
    Top = 81
    Width = 977
    Height = 367
    Align = alClient
    DataSource = DataSource
    Groups = <>
    OptionsView.RowGrandTotalWidth = 336
    TabOrder = 1
    object pvMonthDate: TcxDBPivotGridField
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1052#1077#1089#1103#1094
      DataBinding.FieldName = 'MonthDate'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvPeriodName: TcxDBPivotGridField
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1055#1077#1088#1080#1086#1076
      DataBinding.FieldName = 'PeriodName'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvInvNumber: TcxDBPivotGridField
      AreaIndex = 3
      IsCaptionAssigned = True
      Caption = #8470' '#1076#1086#1082'.'
      DataBinding.FieldName = 'InvNumber'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvOperDate: TcxDBPivotGridField
      AreaIndex = 10
      IsCaptionAssigned = True
      Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
      DataBinding.FieldName = 'OperDate'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvGoodsGroupName: TcxDBPivotGridField
      AreaIndex = 13
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
      DataBinding.FieldName = 'GoodsGroupName'
      UniqueName = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object pvGoodsCode: TcxDBPivotGridField
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1050#1086#1076' '#1090#1086#1074'.'
      DataBinding.FieldName = 'GoodsCode'
      Width = 50
      UniqueName = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object pvGoodsName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1058#1086#1074#1072#1088
      DataBinding.FieldName = 'GoodsName'
      Visible = True
      Width = 90
      UniqueName = #1057#1095#1077#1090'-'#1075#1088#1091#1087#1087#1072
    end
    object pvGoodsKindName: TcxDBPivotGridField
      AreaIndex = 4
      IsCaptionAssigned = True
      Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
      DataBinding.FieldName = 'GoodsKindName'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvGoodsGroupNameFull: TcxDBPivotGridField
      AreaIndex = 5
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
      DataBinding.FieldName = 'GoodsGroupNameFull'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvGoodsGroupAnalystName: TcxDBPivotGridField
      AreaIndex = 6
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' '#1072#1085#1072#1083#1080#1090#1080#1082#1080
      DataBinding.FieldName = 'GoodsGroupAnalystName'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvTradeMarkName: TcxDBPivotGridField
      AreaIndex = 7
      IsCaptionAssigned = True
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
      DataBinding.FieldName = 'TradeMarkName'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvGoodsTagName: TcxDBPivotGridField
      AreaIndex = 8
      IsCaptionAssigned = True
      Caption = #1055#1088#1080#1079#1085#1072#1082' '#1090#1086#1074#1072#1088#1072
      DataBinding.FieldName = 'GoodsTagName'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvGoodsPlatformName: TcxDBPivotGridField
      AreaIndex = 9
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1077#1085#1085#1072#1103' '#1087#1083#1086#1097#1072#1076#1082#1072
      DataBinding.FieldName = 'GoodsPlatformName'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvPartionGoods: TcxDBPivotGridField
      AreaIndex = 11
      IsCaptionAssigned = True
      Caption = #1055#1072#1088#1090#1080#1103
      DataBinding.FieldName = 'PartionGoods'
      UniqueName = #1043#1088#1091#1087#1087#1072' 2'
    end
    object pvPartionGoods_Date: TcxDBPivotGridField
      AreaIndex = 12
      IsCaptionAssigned = True
      Caption = #1044#1072#1090#1072' '#1087#1072#1088#1090#1080#1080
      DataBinding.FieldName = 'PartionGoods_Date'
      UniqueName = #1043#1088#1091#1087#1087#1072' 2'
    end
    object pvCountSale: TcxDBPivotGridField
      Area = faData
      AreaIndex = 5
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1082#1086#1083'.'
      DataBinding.FieldName = 'CountSale'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvCountSale_10500: TcxDBPivotGridField
      Area = faData
      AreaIndex = 6
      IsCaptionAssigned = True
      Caption = #1057#1082#1080#1076#1082#1072', '#1082#1086#1083'.'
      DataBinding.FieldName = 'CountSale_10500'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvCountSale_40208: TcxDBPivotGridField
      Area = faData
      AreaIndex = 7
      IsCaptionAssigned = True
      Caption = '(-)'#1055#1086#1090#1077#1088#1080' (+)'#1069#1082#1086#1085#1086#1084' '#1082#1086#1083'.'
      DataBinding.FieldName = 'CountSale_40208'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvCountSaleReal: TcxDBPivotGridField
      Area = faData
      AreaIndex = 8
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1082#1086#1083'. ('#1087#1086#1082'.)'
      DataBinding.FieldName = 'CountSaleReal'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvCountSendOnPriceIn: TcxDBPivotGridField
      Area = faData
      AreaIndex = 9
      IsCaptionAssigned = True
      Caption = #1055#1077#1088#1077#1084'. '#1092#1080#1083'. '#1087#1088#1080#1093'. '#1082#1086#1083'.'
      DataBinding.FieldName = 'CountSendOnPriceIn'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvCountSendOnPrice_10500: TcxDBPivotGridField
      Area = faData
      AreaIndex = 10
      IsCaptionAssigned = True
      Caption = #1057#1082#1080#1076#1082#1072' '#1082#1086#1083'. ('#1087#1088#1080' '#1087#1077#1088#1077#1084'. '#1085#1072' '#1092#1080#1083'.)'
      DataBinding.FieldName = 'CountSendOnPrice_10500'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvCountSendOnPrice_40200: TcxDBPivotGridField
      Area = faData
      AreaIndex = 11
      IsCaptionAssigned = True
      Caption = '(-)'#1055#1086#1090#1077#1088#1080' (+)'#1069#1082#1086#1085#1086#1084' '#1082#1086#1083'. ('#1087#1088#1080' '#1087#1077#1088#1077#1084'. '#1085#1072' '#1092#1080#1083'.)'
      DataBinding.FieldName = 'CountSendOnPrice_40200'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvCountSendOnPriceOut: TcxDBPivotGridField
      Area = faData
      AreaIndex = 12
      IsCaptionAssigned = True
      Caption = #1055#1077#1088#1077#1084'. '#1092#1080#1083'. '#1088#1072#1089#1093'. '#1082#1086#1083'.'
      DataBinding.FieldName = 'CountSendOnPriceOut'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvSumm: TcxDBPivotGridField
      Area = faData
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080
      DataBinding.FieldName = 'Summ'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Visible = True
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvPrice: TcxDBPivotGridField
      Area = faData
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Visible = True
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvPriceSale: TcxDBPivotGridField
      Area = faData
      AreaIndex = 3
      IsCaptionAssigned = True
      Caption = #1062#1077#1085#1072' '#1089'/'#1089' '#1087#1088#1086#1076'.'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Visible = True
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvPriceSaleReal: TcxDBPivotGridField
      Area = faData
      AreaIndex = 4
      IsCaptionAssigned = True
      Caption = #1062#1077#1085#1072' '#1089'/'#1089' '#1087#1088#1086#1076'. ('#1082#1086#1083'. '#1087#1086#1082#1091#1087'.)'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Visible = True
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvPrice_sumSale: TcxDBPivotGridField
      Area = faData
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080', '#1075#1088#1085' ('#1087#1086#1082#1091#1087')'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Visible = True
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvSummSale: TcxDBPivotGridField
      AreaIndex = 14
      IsCaptionAssigned = True
      Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' '#1087#1088#1086#1076'.'
      DataBinding.FieldName = 'SummSale'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvSale_Summ: TcxDBPivotGridField
      AreaIndex = 15
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076', '#1075#1088#1085' ('#1087#1086#1082#1091#1087')'
      DataBinding.FieldName = 'Sale_Summ'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvSummSale_10500: TcxDBPivotGridField
      AreaIndex = 16
      IsCaptionAssigned = True
      Caption = #1057#1082#1080#1076#1082#1072' '#1089#1091#1084#1084#1072
      DataBinding.FieldName = 'SummSale_10500'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvSummSale_10250: TcxDBPivotGridField
      AreaIndex = 17
      IsCaptionAssigned = True
      Caption = #1057#1082#1080#1076#1082#1072' '#1040#1082#1094#1080#1080', '#1075#1088#1085' ('#1087#1088#1080' '#1087#1088#1086#1076'.)'
      DataBinding.FieldName = 'SummSale_10250'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvSummSale_10300: TcxDBPivotGridField
      AreaIndex = 18
      IsCaptionAssigned = True
      Caption = #1057#1082#1080#1076#1082#1072', '#1075#1088#1085' ('#1087#1088#1080' '#1087#1088#1086#1076'.)'
      DataBinding.FieldName = 'SummSale_10300'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvSummSale_40208: TcxDBPivotGridField
      AreaIndex = 19
      IsCaptionAssigned = True
      Caption = '(-)'#1055#1086#1090#1077#1088#1080' (+)'#1069#1082#1086#1085#1086#1084' '#1089#1091#1084#1084#1072
      DataBinding.FieldName = 'SummSale_40208'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvSummSendOnPriceIn: TcxDBPivotGridField
      AreaIndex = 20
      IsCaptionAssigned = True
      Caption = #1055#1077#1088#1077#1084'. '#1092#1080#1083'. '#1087#1088#1080#1093'. '#1089#1091#1084#1084#1072
      DataBinding.FieldName = 'SummSendOnPriceIn'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvSummSendOnPrice_10500: TcxDBPivotGridField
      AreaIndex = 21
      IsCaptionAssigned = True
      Caption = #1057#1082#1080#1076#1082#1072' '#1089#1091#1084#1084#1072' ('#1087#1088#1080' '#1087#1077#1088#1077#1084'. '#1085#1072' '#1092#1080#1083'.)'
      DataBinding.FieldName = 'SummSendOnPrice_10500'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvSummSendOnPrice_40200: TcxDBPivotGridField
      AreaIndex = 22
      IsCaptionAssigned = True
      Caption = '(-)'#1055#1086#1090#1077#1088#1080' (+)'#1069#1082#1086#1085#1086#1084' '#1089#1091#1084#1084#1072'  ('#1087#1088#1080' '#1087#1077#1088#1077#1084'. '#1085#1072' '#1092#1080#1083'.)'
      DataBinding.FieldName = 'SummSendOnPrice_40200'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvSummSendOnPriceOut: TcxDBPivotGridField
      AreaIndex = 23
      IsCaptionAssigned = True
      Caption = #1055#1077#1088#1077#1084'. '#1092#1080#1083'. '#1088#1072#1089#1093'. '#1089#1091#1084#1084#1072
      DataBinding.FieldName = 'SummSendOnPriceOut'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvInfoMoneyCode: TcxDBPivotGridField
      AreaIndex = 24
      IsCaptionAssigned = True
      Caption = #1050#1086#1076' '#1059#1055
      DataBinding.FieldName = 'InfoMoneyCode'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvInfoMoneyGroupName: TcxDBPivotGridField
      AreaIndex = 25
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      DataBinding.FieldName = 'InfoMoneyGroupName'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvInfoMoneyDestinationName: TcxDBPivotGridField
      AreaIndex = 26
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
      DataBinding.FieldName = 'InfoMoneyDestinationName'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvInfoMoneyName: TcxDBPivotGridField
      AreaIndex = 27
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      DataBinding.FieldName = 'InfoMoneyName'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvInfoMoneyName_all: TcxDBPivotGridField
      AreaIndex = 28
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103
      DataBinding.FieldName = 'InfoMoneyName_all'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvInfoMoneyCode_Detail: TcxDBPivotGridField
      AreaIndex = 29
      IsCaptionAssigned = True
      Caption = #1050#1086#1076' '#1059#1055' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      DataBinding.FieldName = 'InfoMoneyCode_Detail'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvInfoMoneyGroupName_Detail: TcxDBPivotGridField
      AreaIndex = 30
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103'  ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      DataBinding.FieldName = 'InfoMoneyGroupName_Detail'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvInfoMoneyDestinationName_Detail: TcxDBPivotGridField
      AreaIndex = 31
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077'  ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      DataBinding.FieldName = 'InfoMoneyDestinationName_Detail'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvInfoMoneyName_Detail: TcxDBPivotGridField
      AreaIndex = 32
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103'  ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      DataBinding.FieldName = 'InfoMoneyName_Detail'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvInfoMoneyName_all_Detail: TcxDBPivotGridField
      AreaIndex = 33
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      DataBinding.FieldName = 'InfoMoneyName_all_Detail'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
  end
  object cxLabel7: TcxLabel
    Left = 172
    Top = 6
    Caption = #1055#1077#1088#1080#1086#1076'2 '#1089' ...'
  end
  object deStart2: TcxDateEdit
    Left = 242
    Top = 5
    EditValue = 43101d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 4
    Width = 79
  end
  object cxLabel9: TcxLabel
    Left = 165
    Top = 30
    AutoSize = False
    Caption = #1055#1077#1088#1080#1086#1076'2 '#1087#1086' ...'
    Height = 17
    Width = 76
  end
  object deEnd2: TcxDateEdit
    Left = 242
    Top = 29
    EditValue = 43101d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 8
    Width = 79
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 120
    Top = 208
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 80
    Top = 208
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end
      item
        Component = deEnd2
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart2
        Properties.Strings = (
          'Date')
      end
      item
        Component = GuidesUnitGroup
        Properties.Strings = (
          'key'
          'TextValue')
      end
      item
        Component = GuidesGoods
        Properties.Strings = (
          'key'
          'TextValue')
      end
      item
        Component = GuidesGoodsGroup
        Properties.Strings = (
          'key'
          'TextValue')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 256
    Top = 200
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 176
    Top = 216
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar1: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbExecuteDialog'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object bbToExcel: TdxBarButton
      Action = actExportToExcel
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 40
    Top = 200
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actExportToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxDBPivotGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_Sale_OlapDialogForm'
      FormNameParam.Value = 'TReport_Sale_OlapDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartDate2'
          Value = 'NULL'
          Component = deStart2
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate2'
          Value = 'NULL'
          Component = deEnd2
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromGroupId'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromGroupName'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = ''
          Component = GuidesGoodsGroup
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GuidesGoodsGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isMovement'
          Value = 'False'
          Component = cbIsMovement
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartion'
          Value = 'False'
          Component = cbisPartion
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  object spReport: TdsdStoredProc
    StoredProcName = 'gpReport_Sale_Olap'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate2'
        Value = 'NULL'
        Component = deStart2
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 'NULL'
        Component = deEnd2
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsMovement'
        Value = Null
        Component = cbIsMovement
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartion'
        Value = Null
        Component = cbisPartion
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupId'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = Null
        Component = GuidesUnitGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 208
    Top = 288
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 544
    Top = 280
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 448
    Top = 336
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = deStart
      end
      item
        Component = deEnd
      end
      item
        Component = PeriodChoice
      end
      item
        Component = PeriodChoice2
      end>
    Left = 472
    Top = 248
  end
  object PivotAddOn: TPivotAddOn
    ErasedFieldName = 'isErased'
    PivotGrid = cxDBPivotGrid
    OnDblClickActionList = <>
    ActionItemList = <>
    ColorRuleList = <>
    SummaryList = <>
    Left = 392
    Top = 272
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 360
    Top = 184
  end
  object GuidesUnitGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitGroup
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'TreeDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnitGroup
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnitGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 496
    Top = 65528
  end
  object GuidesGoodsGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroup
    FormNameParam.Value = 'TGoodsGroup_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroup_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 760
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsFuel_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsFuel_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 720
    Top = 11
  end
  object PeriodChoice2: TPeriodChoice
    DateStart = deStart2
    DateEnd = deEnd2
    Left = 520
    Top = 328
  end
  object cfPrice: TdsdPivotGridCalcFields
    PivotGrid = cxDBPivotGrid
    CalcField = pvPrice
    GridFields = <
      item
        Field = pvSumm
      end
      item
        Field = pvCountSale
      end>
    CalcFieldsType = cfDivision
    Left = 656
    Top = 208
  end
  object cfPriceSale: TdsdPivotGridCalcFields
    PivotGrid = cxDBPivotGrid
    CalcField = pvPriceSale
    GridFields = <
      item
        Field = pvSummSale
      end
      item
        Field = pvCountSale
      end>
    CalcFieldsType = cfDivision
    Left = 656
    Top = 256
  end
  object cfPriceSaleReal: TdsdPivotGridCalcFields
    PivotGrid = cxDBPivotGrid
    CalcField = pvPriceSaleReal
    GridFields = <
      item
        Field = pvSummSale
      end
      item
        Field = pvCountSaleReal
      end>
    CalcFieldsType = cfDivision
    Left = 656
    Top = 312
  end
  object cfPriceSumSale: TdsdPivotGridCalcFields
    PivotGrid = cxDBPivotGrid
    CalcField = pvPrice_sumSale
    GridFields = <
      item
        Field = pvSale_Summ
      end
      item
        Field = pvCountSale
      end>
    CalcFieldsType = cfDivision
    Left = 744
    Top = 200
  end
end
