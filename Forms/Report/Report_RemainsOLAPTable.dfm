object Report_RemainsOLAPTableForm: TReport_RemainsOLAPTableForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' <'#1044#1074#1080#1078#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1086#1074'> ('#1054#1051#1040#1055')'
  ClientHeight = 448
  ClientWidth = 990
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
    Width = 990
    Height = 55
    Align = alTop
    TabOrder = 0
    object deStart: TcxDateEdit
      Left = 83
      Top = 5
      EditValue = 43831d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 79
    end
    object deEnd: TcxDateEdit
      Left = 83
      Top = 29
      EditValue = 43831d
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
      Left = 176
      Top = 7
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edUnitGroup: TcxButtonEdit
      Left = 264
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
      Left = 463
      Top = 6
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074':'
    end
    object edGoodsGroup: TcxButtonEdit
      Left = 558
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
      Left = 514
      Top = 30
      Caption = #1058#1086#1074#1072#1088':'
    end
    object edGoods: TcxButtonEdit
      Left = 558
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
    object cbIsDay: TcxCheckBox
      Left = 190
      Top = 29
      Action = actRefreshDay
      TabOrder = 10
      Width = 123
    end
    object cbisMonth: TcxCheckBox
      Left = 327
      Top = 29
      Action = actRefreshMonth
      TabOrder = 11
      Width = 130
    end
  end
  object cxDBPivotGrid: TcxDBPivotGrid
    Left = 0
    Top = 81
    Width = 990
    Height = 367
    Align = alClient
    DataSource = DataSource
    Groups = <>
    OptionsView.RowGrandTotalWidth = 421
    TabOrder = 1
    object pvOperDate: TcxDBPivotGridField
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1044#1072#1090#1072
      DataBinding.FieldName = 'OperDate'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvMonthName: TcxDBPivotGridField
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1052#1077#1089#1103#1094
      DataBinding.FieldName = 'MonthName'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvDayOfWeekName: TcxDBPivotGridField
      AreaIndex = 4
      IsCaptionAssigned = True
      Caption = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080
      DataBinding.FieldName = 'DayOfWeekName'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvYear: TcxDBPivotGridField
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1043#1086#1076
      DataBinding.FieldName = 'Year'
      PropertiesClassName = 'TcxDateEditProperties'
      Properties.DisplayFormat = 'YYYY'
      Visible = True
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvGoodsGroupName: TcxDBPivotGridField
      AreaIndex = 12
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
      DataBinding.FieldName = 'GoodsGroupName'
      Visible = True
      UniqueName = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object pvGoodsCode: TcxDBPivotGridField
      AreaIndex = 3
      IsCaptionAssigned = True
      Caption = #1050#1086#1076' '#1090#1086#1074'.'
      DataBinding.FieldName = 'GoodsCode'
      Visible = True
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
      Width = 300
      UniqueName = #1057#1095#1077#1090'-'#1075#1088#1091#1087#1087#1072
    end
    object pvGoodsKindName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
      DataBinding.FieldName = 'GoodsKindName'
      Visible = True
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvMeasureName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1045#1076'.'#1048#1079#1084'.'
      DataBinding.FieldName = 'MeasureName'
      Visible = True
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvGoodsGroupNameFull: TcxDBPivotGridField
      AreaIndex = 5
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
      DataBinding.FieldName = 'GoodsGroupNameFull'
      Visible = True
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvGoodsGroupAnalystName: TcxDBPivotGridField
      AreaIndex = 6
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' '#1072#1085#1072#1083#1080#1090#1080#1082#1080
      DataBinding.FieldName = 'GoodsGroupAnalystName'
      Visible = True
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvTradeMarkName: TcxDBPivotGridField
      AreaIndex = 7
      IsCaptionAssigned = True
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
      DataBinding.FieldName = 'TradeMarkName'
      Visible = True
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
      Visible = True
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvGoodsName_basis: TcxDBPivotGridField
      AreaIndex = 10
      IsCaptionAssigned = True
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1094#1077#1093')'
      DataBinding.FieldName = 'GoodsName_basis'
      UniqueName = #1043#1088#1091#1087#1087#1072' 2'
    end
    object pvGoodsName_main: TcxDBPivotGridField
      AreaIndex = 11
      IsCaptionAssigned = True
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1085#1072' '#1091#1087#1072#1082'.)'
      DataBinding.FieldName = 'GoodsName_main'
      UniqueName = #1043#1088#1091#1087#1087#1072' 2'
    end
    object pvAmountSale: TcxDBPivotGridField
      Area = faData
      AreaIndex = 11
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1082#1086#1083'.'
      DataBinding.FieldName = 'AmountSale'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvAmountSale_10500: TcxDBPivotGridField
      Area = faData
      AreaIndex = 13
      IsCaptionAssigned = True
      Caption = #1057#1082#1080#1076#1082#1072', '#1082#1086#1083'.'
      DataBinding.FieldName = 'AmountSale_10500'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvAmountSale_40208: TcxDBPivotGridField
      Area = faData
      AreaIndex = 15
      IsCaptionAssigned = True
      Caption = '(-)'#1055#1086#1090#1077#1088#1080' (+)'#1069#1082#1086#1085#1086#1084' '#1082#1086#1083'.'
      DataBinding.FieldName = 'AmountSale_40208'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvAmountSaleReal: TcxDBPivotGridField
      Area = faData
      AreaIndex = 17
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1082#1086#1083'. ('#1087#1086#1082'.)'
      DataBinding.FieldName = 'AmountSaleReal'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvAmountSaleReal_10500: TcxDBPivotGridField
      Area = faData
      AreaIndex = 51
      IsCaptionAssigned = True
      Caption = #1057#1082#1080#1076#1082#1072' '#1082#1086#1083'. ('#1087#1086#1082'.)'
      DataBinding.FieldName = 'AmountSaleReal_10500'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvAmountSaleReal_40208: TcxDBPivotGridField
      Area = faData
      AreaIndex = 37
      IsCaptionAssigned = True
      Caption = '(-)'#1055#1086#1090#1077#1088#1080' (+)'#1069#1082#1086#1085#1086#1084' '#1082#1086#1083'. ('#1087#1086#1082'.)'
      DataBinding.FieldName = 'AmountSaleReal_40208'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvAmountSendOnPriceIn: TcxDBPivotGridField
      Area = faData
      AreaIndex = 19
      IsCaptionAssigned = True
      Caption = #1055#1077#1088#1077#1084'. '#1092#1080#1083'. '#1087#1088#1080#1093'. '#1082#1086#1083'.'
      DataBinding.FieldName = 'AmountSendOnPriceIn'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvAmountSendOnPrice_10500: TcxDBPivotGridField
      Area = faData
      AreaIndex = 21
      IsCaptionAssigned = True
      Caption = #1057#1082#1080#1076#1082#1072' '#1082#1086#1083'. ('#1087#1088#1080' '#1087#1077#1088#1077#1084'. '#1085#1072' '#1092#1080#1083'.)'
      DataBinding.FieldName = 'AmountSendOnPrice_10500'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvAmountSendOnPrice_40200: TcxDBPivotGridField
      Area = faData
      AreaIndex = 23
      IsCaptionAssigned = True
      Caption = '(-)'#1055#1086#1090#1077#1088#1080' (+)'#1069#1082#1086#1085#1086#1084' '#1082#1086#1083'. ('#1087#1088#1080' '#1087#1077#1088#1077#1084'. '#1085#1072' '#1092#1080#1083'.)'
      DataBinding.FieldName = 'AmountSendOnPrice_40200'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvAmountSendOnPriceOut: TcxDBPivotGridField
      Area = faData
      AreaIndex = 27
      IsCaptionAssigned = True
      Caption = #1055#1077#1088#1077#1084'. '#1092#1080#1083'. '#1088#1072#1089#1093'. '#1082#1086#1083'.'
      DataBinding.FieldName = 'AmountSendOnPriceOut'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvAmountStart: TcxDBPivotGridField
      Area = faData
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1082#1086#1083'.'
      DataBinding.FieldName = 'AmountStart'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Visible = True
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvAmountEnd: TcxDBPivotGridField
      Area = faData
      AreaIndex = 4
      IsCaptionAssigned = True
      Caption = #1054#1089#1090'. '#1082#1086#1085#1077#1095'. '#1082#1086#1083'.'
      DataBinding.FieldName = 'AmountEnd'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Visible = True
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvAmountTotalIn_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 45
      IsCaptionAssigned = True
      Caption = #1048#1090#1086#1075#1086' '#1087#1088#1080#1093#1086#1076' '#1074#1077#1089
      DataBinding.FieldName = 'AmountTotalIn_Weight'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvAmountTotalOut_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 46
      IsCaptionAssigned = True
      Caption = #1048#1090#1086#1075#1086' '#1088#1072#1089#1093#1086#1076' '#1074#1077#1089
      DataBinding.FieldName = 'AmountTotalOut_Weight'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvAmountTotalIn: TcxDBPivotGridField
      Area = faData
      AreaIndex = 47
      IsCaptionAssigned = True
      Caption = #1048#1090#1086#1075#1086' '#1087#1088#1080#1093#1086#1076' '#1082#1086#1083'.'
      DataBinding.FieldName = 'AmountTotalIn'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvAmountTotalOut: TcxDBPivotGridField
      Area = faData
      AreaIndex = 48
      IsCaptionAssigned = True
      Caption = #1048#1090#1086#1075#1086' '#1088#1072#1089#1093#1086#1076' '#1082#1086#1083'.'
      DataBinding.FieldName = 'AmountTotalOut'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvAmountIncome: TcxDBPivotGridField
      Area = faData
      AreaIndex = 49
      IsCaptionAssigned = True
      Caption = #1055#1086#1089#1090#1072#1074#1097'. '#1082#1086#1083'.'
      DataBinding.FieldName = 'AmountIncome'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvAmountReturnOut: TcxDBPivotGridField
      Area = faData
      AreaIndex = 39
      IsCaptionAssigned = True
      Caption = #1042#1086#1079#1074#1088'. '#1087#1086#1089#1090'. '#1082#1086#1083'.'
      DataBinding.FieldName = 'AmountReturnOut'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvAmountSendIn: TcxDBPivotGridField
      Area = faData
      AreaIndex = 43
      IsCaptionAssigned = True
      Caption = #1055#1077#1088#1077#1084'. '#1087#1088#1080#1093'. '#1082#1086#1083'.'
      DataBinding.FieldName = 'AmountSendIn'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvAmountSendOut: TcxDBPivotGridField
      Area = faData
      AreaIndex = 53
      IsCaptionAssigned = True
      Caption = #1055#1077#1088#1077#1084'. '#1088#1072#1089#1093'. '#1082#1086#1083'.'
      DataBinding.FieldName = 'AmountSendOut'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvAmountSendOnPriceOut_10900: TcxDBPivotGridField
      Area = faData
      AreaIndex = 57
      IsCaptionAssigned = True
      Caption = #1055#1077#1088#1077#1084'. '#1092#1080#1083'. '#1088#1072#1089#1093'. '#1082#1086#1083'. ('#1091#1090#1080#1083#1100')'
      DataBinding.FieldName = 'AmountSendOnPriceOut_10900'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvAmountReturnIn: TcxDBPivotGridField
      Area = faData
      AreaIndex = 41
      IsCaptionAssigned = True
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1082'. '#1082#1086#1083'.'
      DataBinding.FieldName = 'AmountReturnIn'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvAmountReturnIn_40208: TcxDBPivotGridField
      Area = faData
      AreaIndex = 29
      IsCaptionAssigned = True
      Caption = '(-)'#1055#1086#1090#1077#1088#1080' (+)'#1069#1082#1086#1085#1086#1084' '#1082#1086#1083'. ('#1087#1088#1080' '#1074'.'#1087#1086#1082'.)'
      DataBinding.FieldName = 'AmountReturnIn_40208'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvAmountReturnInReal: TcxDBPivotGridField
      Area = faData
      AreaIndex = 25
      IsCaptionAssigned = True
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1082'. '#1082#1086#1083'. ('#1087#1086#1082'.)'
      DataBinding.FieldName = 'AmountReturnInReal'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvAmountReturnInReal_40208: TcxDBPivotGridField
      Area = faData
      AreaIndex = 31
      IsCaptionAssigned = True
      Caption = '(-)'#1055#1086#1090#1077#1088#1080' (+)'#1069#1082#1086#1085#1086#1084' '#1082#1086#1083'. ('#1087#1088#1080' '#1074'.'#1087#1086#1082'.) ('#1087#1086#1082'.)'
      DataBinding.FieldName = 'AmountReturnInReal_40208'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvAmountLoss: TcxDBPivotGridField
      Area = faData
      AreaIndex = 55
      IsCaptionAssigned = True
      Caption = #1057#1087#1080#1089#1072#1085#1080#1077' '#1082#1086#1083'.'
      DataBinding.FieldName = 'AmountLoss'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvAmountInventory: TcxDBPivotGridField
      Area = faData
      AreaIndex = 35
      IsCaptionAssigned = True
      Caption = #1050#1086#1083'. (-)'#1091#1073#1099#1083#1100' (+)'#1101#1082#1086#1085#1086#1084'.'
      DataBinding.FieldName = 'AmountInventory'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvAmountProductionIn: TcxDBPivotGridField
      Area = faData
      AreaIndex = 33
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1080#1079#1074'. '#1087#1088#1080#1093'. '#1082#1086#1083'.'
      DataBinding.FieldName = 'AmountProductionIn'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvAmountProductionOut: TcxDBPivotGridField
      Area = faData
      AreaIndex = 59
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1080#1079#1074'. '#1088#1072#1089#1093'. '#1082#1086#1083'.'
      DataBinding.FieldName = 'AmountProductionOut'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvAmountSale_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 12
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1074#1077#1089
      DataBinding.FieldName = 'AmountSale_Weight'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvAmountSale_10500_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 14
      IsCaptionAssigned = True
      Caption = #1057#1082#1080#1076#1082#1072', '#1074#1077#1089
      DataBinding.FieldName = 'AmountSale_10500_Weight'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvAmountSale_40208_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 16
      IsCaptionAssigned = True
      Caption = '(-)'#1055#1086#1090#1077#1088#1080' (+)'#1069#1082#1086#1085#1086#1084' '#1074#1077#1089
      DataBinding.FieldName = 'AmountSale_40208_Weight'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvAmountSaleReal_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 18
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1074#1077#1089' ('#1087#1086#1082'.)'
      DataBinding.FieldName = 'AmountSaleReal_Weight'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvAmountSaleReal_10500_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 52
      IsCaptionAssigned = True
      Caption = #1057#1082#1080#1076#1082#1072' '#1074#1077#1089' ('#1087#1086#1082'.)'
      DataBinding.FieldName = 'AmountSaleReal_10500_Weight'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvAmountSaleReal_40208_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 38
      IsCaptionAssigned = True
      Caption = '(-)'#1055#1086#1090#1077#1088#1080' (+)'#1069#1082#1086#1085#1086#1084' '#1074#1077#1089' ('#1087#1086#1082'.)'
      DataBinding.FieldName = 'AmountSaleReal_40208_Weight'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvAmountSendOnPriceIn_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 20
      IsCaptionAssigned = True
      Caption = #1055#1077#1088#1077#1084'. '#1092#1080#1083'. '#1087#1088#1080#1093'. '#1074#1077#1089
      DataBinding.FieldName = 'AmountSendOnPriceIn_Weight'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvAmountSendOnPrice_10500_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 22
      IsCaptionAssigned = True
      Caption = #1057#1082#1080#1076#1082#1072' '#1074#1077#1089' ('#1087#1088#1080' '#1087#1077#1088#1077#1084'. '#1085#1072' '#1092#1080#1083'.)'
      DataBinding.FieldName = 'AmountSendOnPrice_10500_Weight'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvAmountSendOnPrice_40200_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 24
      IsCaptionAssigned = True
      Caption = '(-)'#1055#1086#1090#1077#1088#1080' (+)'#1069#1082#1086#1085#1086#1084' '#1074#1077#1089' ('#1087#1088#1080' '#1087#1077#1088#1077#1084'. '#1085#1072' '#1092#1080#1083'.)'
      DataBinding.FieldName = 'AmountSendOnPrice_40200_Weight'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvAmountSendOnPriceOut_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 28
      IsCaptionAssigned = True
      Caption = #1055#1077#1088#1077#1084'. '#1092#1080#1083'. '#1088#1072#1089#1093'. '#1074#1077#1089
      DataBinding.FieldName = 'AmountSendOnPriceOut_Weight'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvAmountStart_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1054#1089#1090'. '#1085#1072' '#1085#1072#1095'. '#1087#1077#1088#1080#1086#1076#1072', '#1074#1077#1089
      DataBinding.FieldName = 'AmountStart_Weight'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Visible = True
      Width = 104
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvAmountEnd_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 5
      IsCaptionAssigned = True
      Caption = #1054#1089#1090'. '#1085#1072' '#1086#1082#1086#1085#1095'. '#1087#1077#1088#1080#1086#1076#1072', '#1074#1077#1089
      DataBinding.FieldName = 'AmountEnd_Weight'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Visible = True
      Width = 112
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvAmountStart_sh: TcxDBPivotGridField
      Area = faData
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1054#1089#1090'. '#1085#1072' '#1085#1072#1095'. '#1087#1077#1088#1080#1086#1076#1072', '#1096#1090
      DataBinding.FieldName = 'AmountStart_sh'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Visible = True
      Width = 104
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvAmountEnd_sh: TcxDBPivotGridField
      Area = faData
      AreaIndex = 6
      IsCaptionAssigned = True
      Caption = #1054#1089#1090'. '#1085#1072' '#1086#1082#1086#1085#1095'. '#1087#1077#1088#1080#1086#1076#1072', '#1096#1090
      DataBinding.FieldName = 'AmountEnd_sh'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Visible = True
      Width = 112
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvCountDays: TcxDBPivotGridField
      Area = faData
      AreaIndex = 8
      IsCaptionAssigned = True
      Caption = #1044#1085#1077#1081' '#1087#1077#1088#1080#1086#1076#1072
      DataBinding.FieldName = 'CountDays'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvAmountStart_Weight_sum: TcxDBPivotGridField
      Area = faData
      AreaIndex = 3
      IsCaptionAssigned = True
      Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1074#1077#1089' ('#1091#1089#1088#1077#1076#1085'.)'
      DataBinding.FieldName = 'AmountStart_Weight_sum'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvAmountStart_Weight_avg: TcxDBPivotGridField
      Area = faData
      AreaIndex = 7
      IsCaptionAssigned = True
      Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1074#1077#1089' ('#1091#1089#1088#1077#1076#1085'.)'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Visible = True
      Width = 103
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvAmountEnd_Weight_sum: TcxDBPivotGridField
      Area = faData
      AreaIndex = 9
      IsCaptionAssigned = True
      Caption = #1054#1089#1090'. '#1082#1086#1085#1077#1095'. '#1074#1077#1089' ('#1091#1089#1088#1077#1076#1085'.)'
      DataBinding.FieldName = 'AmountEnd_Weight_sum'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvAmountEnd_Weight_avg: TcxDBPivotGridField
      Area = faData
      AreaIndex = 10
      IsCaptionAssigned = True
      Caption = #1054#1089#1090'. '#1082#1086#1085#1077#1095'. '#1074#1077#1089' ('#1091#1089#1088#1077#1076#1085'.)'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Visible = True
      Width = 107
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvCostStart: TcxDBPivotGridField
      AreaIndex = 13
      IsCaptionAssigned = True
      Caption = #1057'/c '#1086#1089#1090'. '#1085#1072#1095'., '#1075#1088#1085
      DataBinding.FieldName = 'CostStart'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Visible = True
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvCostEnd: TcxDBPivotGridField
      AreaIndex = 14
      IsCaptionAssigned = True
      Caption = #1057'/c '#1086#1089#1090'. '#1082#1086#1085#1077#1095#1085'., '#1075#1088#1085
      DataBinding.FieldName = 'CostEnd'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Visible = True
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvAmountIncome_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 50
      IsCaptionAssigned = True
      Caption = #1055#1086#1089#1090#1072#1074#1097'. '#1074#1077#1089
      DataBinding.FieldName = 'AmountIncome_Weight'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Visible = True
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvAmountReturnOut_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 40
      IsCaptionAssigned = True
      Caption = #1042#1086#1079#1074#1088'. '#1087#1086#1089#1090'. '#1074#1077#1089
      DataBinding.FieldName = 'AmountReturnOut_Weight'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Visible = True
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvAmountSendIn_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 44
      IsCaptionAssigned = True
      Caption = #1055#1077#1088#1077#1084'. '#1087#1088#1080#1093'. '#1074#1077#1089
      DataBinding.FieldName = 'AmountSendIn_Weight'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvAmountSendOut_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 54
      IsCaptionAssigned = True
      Caption = #1055#1077#1088#1077#1084'. '#1088#1072#1089#1093'. '#1074#1077#1089
      DataBinding.FieldName = 'AmountSendOut_Weight'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvAmountSendOnPriceOut_10900_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 58
      IsCaptionAssigned = True
      Caption = #1055#1077#1088#1077#1084'. '#1092#1080#1083'. '#1088#1072#1089#1093'. '#1074#1077#1089' ('#1091#1090#1080#1083#1100')'
      DataBinding.FieldName = 'AmountSendOnPriceOut_10900_Weight'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvAmountReturnIn_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 42
      IsCaptionAssigned = True
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1082'. '#1074#1077#1089
      DataBinding.FieldName = 'AmountReturnIn_Weight'
      Visible = True
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvAmountReturnIn_40208_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 30
      IsCaptionAssigned = True
      Caption = '(-)'#1055#1086#1090#1077#1088#1080' (+)'#1069#1082#1086#1085#1086#1084' '#1074#1077#1089' ('#1087#1088#1080' '#1074'.'#1087#1086#1082'.)'
      DataBinding.FieldName = 'AmountReturnIn_40208_Weight'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvAmountReturnInReal_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 26
      IsCaptionAssigned = True
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1082'. '#1074#1077#1089' ('#1087#1086#1082'.)'
      DataBinding.FieldName = 'AmountReturnInReal_Weight'
      Visible = True
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvAmountReturnInReal_40208_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 32
      IsCaptionAssigned = True
      Caption = '(-)'#1055#1086#1090#1077#1088#1080' (+)'#1069#1082#1086#1085#1086#1084' '#1074#1077#1089' ('#1087#1088#1080' '#1074'.'#1087#1086#1082'.) ('#1087#1086#1082'.)'
      DataBinding.FieldName = 'AmountReturnInReal_40208_Weight'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvAmountLoss_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 56
      IsCaptionAssigned = True
      Caption = #1057#1087#1080#1089#1072#1085#1080#1077' '#1074#1077#1089
      DataBinding.FieldName = 'AmountLoss_Weight'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvAmountInventory_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 36
      IsCaptionAssigned = True
      Caption = '(-)'#1091#1073#1099#1083#1100' (+)'#1101#1082#1086#1085#1086#1084'. '#1074#1077#1089
      DataBinding.FieldName = 'AmountInventory_Weight'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvAmountProductionIn_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 34
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1080#1079#1074'. '#1087#1088#1080#1093'. '#1074#1077#1089
      DataBinding.FieldName = 'AmountProductionIn_Weight'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvAmountProductionOut_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 60
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1080#1079#1074'. '#1088#1072#1089#1093'. '#1074#1077#1089
      DataBinding.FieldName = 'AmountProductionOut_Weight'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
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
    Left = 272
    Top = 248
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
          ItemName = 'bb'
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
    object bb: TdxBarButton
      Action = actReport_Insert_RemainsOLAPTable
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 40
    Top = 200
    object actRefreshMonth: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = #1055#1086' '#1084#1077#1089#1103#1094#1072#1084' '#1044#1072' / '#1053#1077#1090
      Hint = #1055#1086' '#1084#1077#1089#1103#1094#1072#1084' '#1044#1072' / '#1053#1077#1090
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshDay: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = #1055#1086' '#1076#1085#1103#1084' '#1044#1072' / '#1053#1077#1090
      Hint = #1055#1086' '#1076#1085#1103#1084' '#1044#1072' / '#1053#1077#1090
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
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
      FormName = 'TReport_RemainsOLAPTableDialogForm'
      FormNameParam.Value = 'TReport_RemainsOLAPTableDialogForm'
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
          Name = 'UnitId'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
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
          Name = 'isDay'
          Value = False
          Component = cbIsDay
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actReport_Insert_RemainsOLAPTable: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1090#1072#1073#1083#1080#1094#1091' '#1086#1089#1090#1072#1090#1082#1086#1074
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1090#1072#1073#1083#1080#1094#1091' '#1086#1089#1090#1072#1090#1082#1086#1074
      ImageIndex = 74
      FormName = 'TReport_Insert_RemainsOLAPTableForm'
      FormNameParam.Value = 'TReport_Insert_RemainsOLAPTableForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
  end
  object spReport: TdsdStoredProc
    StoredProcName = 'gpReport_RemainsOLAPTable'
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
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnitGroup
        ComponentItem = 'Key'
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
        Name = 'inIsDay'
        Value = Null
        Component = cbIsDay
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMonth'
        Value = False
        Component = cbisMonth
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 208
    Top = 288
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 704
    Top = 256
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
        Component = GuidesGoods
      end
      item
        Component = GuidesGoodsGroup
      end
      item
        Component = GuidesUnitGroup
      end>
    Left = 472
    Top = 248
  end
  object PivotAddOn: TPivotAddOn
    ErasedFieldName = 'isErased'
    PivotGrid = cxDBPivotGrid
    OnDblClickActionList = <>
    ActionItemList = <>
    ExpandRow = 4
    ExpandColumn = 3
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
    Left = 376
    Top = 64
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
    Left = 688
    Top = 8
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
    Left = 616
    Top = 19
  end
  object cfAmountStart_Weight_avg: TdsdPivotGridCalcFields
    PivotGrid = cxDBPivotGrid
    CalcField = pvAmountStart_Weight_avg
    GridFields = <
      item
        Field = pvAmountStart_Weight_sum
      end
      item
        Field = pvCountDays
      end>
    CalcFieldsType = cfDivision
    Left = 616
    Top = 376
  end
  object cfAmountEnd_Weight_avg: TdsdPivotGridCalcFields
    PivotGrid = cxDBPivotGrid
    CalcField = pvAmountEnd_Weight_avg
    GridFields = <
      item
        Field = pvAmountEnd_Weight_sum
      end
      item
        Field = pvCountDays
      end>
    CalcFieldsType = cfDivision
    Left = 760
    Top = 376
  end
end
