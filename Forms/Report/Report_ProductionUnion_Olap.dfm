object Report_ProductionUnion_OlapForm: TReport_ProductionUnion_OlapForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1091' ('#1054#1051#1040#1055')'
  ClientHeight = 448
  ClientWidth = 1362
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
    Width = 1362
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
      Left = 331
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1086#1090' '#1082#1086#1075#1086'):'
    end
    object cxLabel5: TcxLabel
      Left = 345
      Top = 30
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1082#1086#1084#1091'):'
    end
    object edToGroup: TcxButtonEdit
      Left = 465
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 169
    end
    object edFromGroup: TcxButtonEdit
      Left = 465
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 169
    end
    object cxLabel4: TcxLabel
      Left = 638
      Top = 6
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074'.'#1087#1088#1080#1093'.:'
    end
    object cxLabel6: TcxLabel
      Left = 638
      Top = 32
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074'.'#1088#1072#1089#1093':'
    end
    object edGoodsGroup: TcxButtonEdit
      Left = 733
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 10
      Width = 147
    end
    object edChildGoodsGroup: TcxButtonEdit
      Left = 733
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 11
      Width = 147
    end
    object cxLabel8: TcxLabel
      Left = 884
      Top = 6
      Caption = #1058#1086#1074#1072#1088' '#1087#1088#1080#1093':'
    end
    object edChildGoods: TcxButtonEdit
      Left = 949
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 148
    end
    object edGoods: TcxButtonEdit
      Left = 949
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 14
      Width = 148
    end
    object cbIsMovement: TcxCheckBox
      Left = 1101
      Top = 5
      Caption = #1055#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
      TabOrder = 15
      Width = 105
    end
    object cbisPartion: TcxCheckBox
      Left = 1101
      Top = 29
      Caption = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      TabOrder = 16
      Width = 105
    end
  end
  object cxDBPivotGrid: TcxDBPivotGrid
    Left = 0
    Top = 81
    Width = 1362
    Height = 367
    Align = alClient
    DataSource = DataSource
    Groups = <>
    OptionsView.RowGrandTotalWidth = 336
    TabOrder = 1
    object pvMonthDate: TcxDBPivotGridField
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1052#1077#1089#1103#1094
      DataBinding.FieldName = 'MonthDate'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvInvNumber: TcxDBPivotGridField
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #8470' '#1076#1086#1082'.'
      DataBinding.FieldName = 'InvNumber'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvOperDate: TcxDBPivotGridField
      AreaIndex = 16
      IsCaptionAssigned = True
      Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
      DataBinding.FieldName = 'OperDate'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvDocumentKindName: TcxDBPivotGridField
      AreaIndex = 17
      IsCaptionAssigned = True
      Caption = #1058#1080#1087' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      DataBinding.FieldName = 'DocumentKindName'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvReceiptName: TcxDBPivotGridField
      AreaIndex = 18
      IsCaptionAssigned = True
      Caption = #1056#1077#1094#1077#1087#1090#1091#1088#1072
      DataBinding.FieldName = 'ReceiptName'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvisPeresort: TcxDBPivotGridField
      AreaIndex = 24
      IsCaptionAssigned = True
      Caption = #1055#1077#1088#1077#1089#1086#1088#1090'.'
      DataBinding.FieldName = 'isPeresort'
      Visible = True
      Width = 55
      UniqueName = #1057#1095#1077#1090' - '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
    end
    object pvGoodsGroupName: TcxDBPivotGridField
      AreaIndex = 22
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072' ('#1087#1088#1080#1093#1086#1076')'
      DataBinding.FieldName = 'GoodsGroupName'
      UniqueName = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object pvGoodsCode: TcxDBPivotGridField
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1050#1086#1076' '#1090#1086#1074'. ('#1087#1088#1080#1093#1086#1076')'
      DataBinding.FieldName = 'GoodsCode'
      Width = 50
      UniqueName = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object pvGoodsName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1058#1086#1074#1072#1088' ('#1087#1088#1080#1093#1086#1076')'
      DataBinding.FieldName = 'GoodsName'
      Visible = True
      Width = 55
      UniqueName = #1057#1095#1077#1090'-'#1075#1088#1091#1087#1087#1072
    end
    object pvGoodsKindName: TcxDBPivotGridField
      AreaIndex = 5
      IsCaptionAssigned = True
      Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1087#1088#1080#1093#1086#1076')'
      DataBinding.FieldName = 'GoodsKindName'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvGoodsKindName_complete: TcxDBPivotGridField
      AreaIndex = 15
      IsCaptionAssigned = True
      Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' '#1043#1055' ('#1087#1088#1080#1093#1086#1076')'
      DataBinding.FieldName = 'GoodsKindName_complete'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvMeasureName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1045#1076'. '#1080#1079#1084'. ('#1087#1088#1080#1093#1086#1076')'
      DataBinding.FieldName = 'MeasureName'
      Visible = True
      Width = 55
      UniqueName = #1057#1095#1077#1090'-'#1075#1088#1091#1087#1087#1072
    end
    object pvGoodsGroupNameFull: TcxDBPivotGridField
      AreaIndex = 36
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077') ('#1087#1088#1080#1093#1086#1076')'
      DataBinding.FieldName = 'GoodsGroupNameFull'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvGoodsGroupAnalystName: TcxDBPivotGridField
      AreaIndex = 6
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' '#1072#1085#1072#1083#1080#1090#1080#1082#1080' ('#1087#1088#1080#1093#1086#1076')'
      DataBinding.FieldName = 'GoodsGroupAnalystName'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvTradeMarkName: TcxDBPivotGridField
      AreaIndex = 7
      IsCaptionAssigned = True
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072' ('#1087#1088#1080#1093#1086#1076')'
      DataBinding.FieldName = 'TradeMarkName'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvGoodsTagName: TcxDBPivotGridField
      AreaIndex = 8
      IsCaptionAssigned = True
      Caption = #1055#1088#1080#1079#1085#1072#1082' '#1090#1086#1074#1072#1088#1072' ('#1087#1088#1080#1093#1086#1076')'
      DataBinding.FieldName = 'GoodsTagName'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvGoodsPlatformName: TcxDBPivotGridField
      AreaIndex = 9
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1077#1085#1085#1072#1103' '#1087#1083#1086#1097#1072#1076#1082#1072' ('#1087#1088#1080#1093#1086#1076')'
      DataBinding.FieldName = 'GoodsPlatformName'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvPartionGoods: TcxDBPivotGridField
      AreaIndex = 19
      IsCaptionAssigned = True
      Caption = #1055#1072#1088#1090#1080#1103' ('#1087#1088#1080#1093#1086#1076')'
      DataBinding.FieldName = 'PartionGoods'
      UniqueName = #1043#1088#1091#1087#1087#1072' 2'
    end
    object pvPartionGoods_Date: TcxDBPivotGridField
      AreaIndex = 20
      IsCaptionAssigned = True
      Caption = #1044#1072#1090#1072' '#1087#1072#1088#1090#1080#1080' ('#1087#1088#1080#1093#1086#1076')'
      DataBinding.FieldName = 'PartionGoods_Date'
      UniqueName = #1043#1088#1091#1087#1087#1072' 2'
    end
    object pvAmount: TcxDBPivotGridField
      Area = faData
      AreaIndex = 0
      AllowedAreas = [faFilter, faData]
      IsCaptionAssigned = True
      Caption = #1050#1086#1083'-'#1074#1086' ('#1087#1088#1080#1093#1086#1076')'
      DataBinding.FieldName = 'Amount'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvAmount_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 1
      AllowedAreas = [faFilter, faData]
      IsCaptionAssigned = True
      Caption = #1050#1086#1083'-'#1074#1086' ('#1087#1088#1080#1093#1086#1076') '#1074#1077#1089
      DataBinding.FieldName = 'Amount_Weight'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvCuterCount: TcxDBPivotGridField
      Area = faData
      AreaIndex = 2
      AllowedAreas = [faFilter, faData]
      IsCaptionAssigned = True
      Caption = #1050#1091#1090#1090#1077#1088#1086#1074' ('#1087#1088#1080#1093#1086#1076')'
      DataBinding.FieldName = 'CuterCount'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvMainPrice_Calc: TcxDBPivotGridField
      Area = faData
      AreaIndex = 19
      AllowedAreas = [faFilter, faData]
      IsCaptionAssigned = True
      Caption = #1062#1077#1085#1072' c/c ('#1087#1088#1080#1093#1086#1076')'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvMainPrice_W: TcxDBPivotGridField
      Area = faData
      AreaIndex = 20
      AllowedAreas = [faFilter, faData]
      IsCaptionAssigned = True
      Caption = #1062#1077#1085#1072' c/c ('#1087#1088#1080#1093#1086#1076') / '#1082#1075
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvSumm: TcxDBPivotGridField
      Area = faData
      AreaIndex = 21
      AllowedAreas = [faFilter, faData]
      IsCaptionAssigned = True
      Caption = #1057#1091#1084#1084#1072' c/c ('#1087#1088#1080#1093#1086#1076')'
      DataBinding.FieldName = 'Summ'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvChildAmount: TcxDBPivotGridField
      Area = faData
      AreaIndex = 13
      AllowedAreas = [faFilter, faData]
      IsCaptionAssigned = True
      Caption = #1050#1086#1083'-'#1074#1086' ('#1088#1072#1089#1093#1086#1076')'
      DataBinding.FieldName = 'ChildAmount'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1044#1086#1083#1075' '#1057'/'#1057
    end
    object pvChildAmount_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 14
      AllowedAreas = [faFilter, faData]
      IsCaptionAssigned = True
      Caption = #1050#1086#1083'-'#1074#1086' ('#1088#1072#1089#1093#1086#1076') '#1074#1077#1089
      DataBinding.FieldName = 'ChildAmount_Weight'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1044#1086#1083#1075' '#1057'/'#1057
    end
    object pvChildPrice_Calc: TcxDBPivotGridField
      Area = faData
      AreaIndex = 3
      AllowedAreas = [faFilter, faData]
      IsCaptionAssigned = True
      Caption = #1062#1077#1085#1072' c/c  ('#1088#1072#1089#1093#1086#1076')'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = #1062#1077#1085#1072' c/c  ('#1088#1072#1089#1093#1086#1076') '#1088#1072#1089#1095'.'
    end
    object pvChildPrice_w: TcxDBPivotGridField
      Area = faData
      AreaIndex = 4
      AllowedAreas = [faFilter, faData]
      IsCaptionAssigned = True
      Caption = #1062#1077#1085#1072' c/c  ('#1088#1072#1089#1093#1086#1076') / '#1082#1075
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = #1062#1077#1085#1072' c/c  ('#1088#1072#1089#1093#1086#1076') '#1088#1072#1089#1095'.'
    end
    object pvPercentOut: TcxDBPivotGridField
      Area = faData
      AreaIndex = 5
      AllowedAreas = [faFilter, faData]
      IsCaptionAssigned = True
      Caption = '% '#1074#1099#1093#1086#1076#1072
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = #1062#1077#1085#1072' c/c  ('#1088#1072#1089#1093#1086#1076') '#1088#1072#1089#1095'.'
    end
    object pvChildSumm: TcxDBPivotGridField
      Area = faData
      AreaIndex = 10
      AllowedAreas = [faFilter, faData]
      IsCaptionAssigned = True
      Caption = #1057#1091#1084#1084#1072' c/c ('#1088#1072#1089#1093#1086#1076')'
      DataBinding.FieldName = 'ChildSumm'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = 'AmountDebetStart'
    end
    object pvChildAmountReceipt: TcxDBPivotGridField
      Area = faData
      AreaIndex = 18
      AllowedAreas = [faFilter, faData]
      IsCaptionAssigned = True
      Caption = #1053#1086#1088#1084#1072' ('#1088#1072#1089#1093#1086#1076')'
      DataBinding.FieldName = 'ChildAmountReceipt'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1044#1086#1083#1075' '#1057'/'#1057
    end
    object pvChildAmountReceipt_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 15
      AllowedAreas = [faFilter, faData]
      IsCaptionAssigned = True
      Caption = #1053#1086#1088#1084#1072' ('#1088#1072#1089#1093#1086#1076') / '#1082#1075
      DataBinding.FieldName = 'ChildAmountReceipt_Weight'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1044#1086#1083#1075' '#1057'/'#1057
    end
    object pvChildSummReceipt: TcxDBPivotGridField
      Area = faData
      AreaIndex = 11
      AllowedAreas = [faFilter, faData]
      IsCaptionAssigned = True
      Caption = #1057#1091#1084#1084#1072' '#1085#1086#1088#1084#1072' ('#1088#1072#1089#1093#1086#1076')'
      DataBinding.FieldName = 'ChildSummReceipt'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = #1057#1091#1084#1084#1072' '#1085#1086#1088#1084#1072' ('#1088#1072#1089#1093#1086#1076')'
    end
    object pvChildSummCalc: TcxDBPivotGridField
      Area = faData
      AreaIndex = 12
      AllowedAreas = [faFilter, faData]
      IsCaptionAssigned = True
      Caption = #1057#1091#1084#1084#1072' '#1088#1072#1089#1095#1077#1090' ('#1088#1072#1089#1093#1086#1076')'
      DataBinding.FieldName = 'ChildSummCalc'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = 'AmountDebetStart'
    end
    object pvChildAmountCalc: TcxDBPivotGridField
      Area = faData
      AreaIndex = 16
      AllowedAreas = [faFilter, faData]
      IsCaptionAssigned = True
      Caption = #1050#1086#1083'-'#1074#1086' '#1088#1072#1089#1095#1077#1090' ('#1088#1072#1089#1093#1086#1076')'
      DataBinding.FieldName = 'ChildAmountCalc'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1044#1086#1083#1075' '#1057'/'#1057
    end
    object pvChildAmountCalc_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 17
      AllowedAreas = [faFilter, faData]
      IsCaptionAssigned = True
      Caption = #1050#1086#1083'-'#1074#1086' '#1088#1072#1089#1095#1077#1090' ('#1088#1072#1089#1093#1086#1076') '#1074#1077#1089
      DataBinding.FieldName = 'ChildAmountCalc_Weight'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1044#1086#1083#1075' '#1057'/'#1057
    end
    object pvPrice_Calc: TcxDBPivotGridField
      Area = faData
      AreaIndex = 6
      AllowedAreas = [faFilter, faData]
      IsCaptionAssigned = True
      Caption = #1062#1077#1085#1072' c/c ('#1088#1072#1089#1093#1086#1076') '#1076#1083#1103' '#1082#1086#1083'-'#1074#1086' '#1088#1072#1089#1095#1077#1090
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = #1062#1077#1085#1072' c/c ('#1088#1072#1089#1093#1086#1076') '#1076#1083#1103' '#1082#1086#1083'-'#1074#1086' '#1088#1072#1089#1095#1077#1090
    end
    object pvPrice_w: TcxDBPivotGridField
      Area = faData
      AreaIndex = 7
      AllowedAreas = [faFilter, faData]
      IsCaptionAssigned = True
      Caption = #1062#1077#1085#1072' c/c ('#1088#1072#1089#1093#1086#1076') '#1076#1083#1103' '#1082#1086#1083'-'#1074#1086' '#1088#1072#1089#1095#1077#1090' / '#1082#1075
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = #1062#1077#1085#1072' c/c ('#1088#1072#1089#1093#1086#1076') '#1076#1083#1103' '#1082#1086#1083'-'#1074#1086' '#1088#1072#1089#1095#1077#1090
    end
    object pvReceiptPrice_Calc: TcxDBPivotGridField
      Area = faData
      AreaIndex = 8
      AllowedAreas = [faFilter, faData]
      IsCaptionAssigned = True
      Caption = #1062#1077#1085#1072' c/c ('#1088#1072#1089#1093#1086#1076') '#1076#1083#1103' '#1082#1086#1083'-'#1074#1086' '#1088#1072#1089#1095#1077#1090
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = #1062#1077#1085#1072' c/c ('#1088#1072#1089#1093#1086#1076') '#1076#1083#1103' '#1082#1086#1083'-'#1074#1086' '#1088#1072#1089#1095#1077#1090
    end
    object pvReceiptPrice_w: TcxDBPivotGridField
      Area = faData
      AreaIndex = 9
      AllowedAreas = [faFilter, faData]
      IsCaptionAssigned = True
      Caption = #1062#1077#1085#1072' c/c ('#1088#1072#1089#1093#1086#1076') '#1076#1083#1103' '#1082#1086#1083'-'#1074#1086' '#1088#1072#1089#1095#1077#1090' / '#1082#1075
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = #1062#1077#1085#1072' c/c ('#1088#1072#1089#1093#1086#1076') '#1076#1083#1103' '#1082#1086#1083'-'#1074#1086' '#1088#1072#1089#1095#1077#1090
    end
    object pvChildGoodsGroupName: TcxDBPivotGridField
      AreaIndex = 21
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072' ('#1088#1072#1089#1093#1086#1076')'
      DataBinding.FieldName = 'ChildGoodsGroupName'
      UniqueName = #1043#1088#1091#1087#1087#1072' 1'
    end
    object pvChildGoodsCode: TcxDBPivotGridField
      AreaIndex = 23
      IsCaptionAssigned = True
      Caption = #1050#1086#1076' '#1090#1086#1074'. ('#1088#1072#1089#1093#1086#1076')'
      DataBinding.FieldName = 'ChildGoodsCode'
      UniqueName = #1043#1088#1091#1087#1087#1072' 4'
    end
    object pvChildGoodsName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1058#1086#1074#1072#1088' ('#1088#1072#1089#1093#1086#1076')'
      DataBinding.FieldName = 'ChildGoodsName'
      Visible = True
      UniqueName = #1054#1087#1080#1089#1072#1085#1080#1077
    end
    object pvChildGoodsKindName: TcxDBPivotGridField
      AreaIndex = 25
      IsCaptionAssigned = True
      Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1088#1072#1089#1093#1086#1076')'
      DataBinding.FieldName = 'ChildGoodsKindName'
      UniqueName = #1051#1080#1085#1080#1103
    end
    object pvChildMeasureName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 3
      IsCaptionAssigned = True
      Caption = #1045#1076'. '#1080#1079#1084'. ('#1088#1072#1089#1093#1086#1076')'
      DataBinding.FieldName = 'ChildMeasureName'
      Visible = True
      Width = 55
      UniqueName = #1057#1095#1077#1090'-'#1075#1088#1091#1087#1087#1072
    end
    object pvChildGoodsGroupNameFull: TcxDBPivotGridField
      AreaIndex = 10
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077') ('#1088#1072#1089#1093#1086#1076')'
      DataBinding.FieldName = 'ChildGoodsGroupNameFull'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvChildGoodsGroupAnalystName: TcxDBPivotGridField
      AreaIndex = 11
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' '#1072#1085#1072#1083#1080#1090#1080#1082#1080' ('#1088#1072#1089#1093#1086#1076')'
      DataBinding.FieldName = 'ChildGoodsGroupAnalystName'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvChildTradeMarkName: TcxDBPivotGridField
      AreaIndex = 12
      IsCaptionAssigned = True
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072' ('#1088#1072#1089#1093#1086#1076')'
      DataBinding.FieldName = 'ChildTradeMarkName'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvChildGoodsTagName: TcxDBPivotGridField
      AreaIndex = 13
      IsCaptionAssigned = True
      Caption = #1055#1088#1080#1079#1085#1072#1082' '#1090#1086#1074#1072#1088#1072' ('#1088#1072#1089#1093#1086#1076')'
      DataBinding.FieldName = 'ChildGoodsTagName'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvChildGoodsPlatformName: TcxDBPivotGridField
      AreaIndex = 14
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1077#1085#1085#1072#1103' '#1087#1083#1086#1097#1072#1076#1082#1072' ('#1088#1072#1089#1093#1086#1076')'
      DataBinding.FieldName = 'ChildGoodsPlatformName'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvChildPartionGoods: TcxDBPivotGridField
      AreaIndex = 3
      IsCaptionAssigned = True
      Caption = #1055#1072#1088#1090#1080#1103' ('#1088#1072#1089#1093#1086#1076')'
      DataBinding.FieldName = 'ChildPartionGoods'
      Width = 200
      UniqueName = #1043#1088#1091#1087#1087#1072' 3'
    end
    object pvChildPartionGoods_Date: TcxDBPivotGridField
      AreaIndex = 4
      IsCaptionAssigned = True
      Caption = #1044#1072#1090#1072' '#1087#1072#1088#1090#1080#1080' ('#1088#1072#1089#1093#1086#1076')'
      DataBinding.FieldName = 'ChildPartionGoods_Date'
      Width = 200
      UniqueName = #1043#1088#1091#1087#1087#1072' 3'
    end
    object pvInfoMoneyCode: TcxDBPivotGridField
      AreaIndex = 26
      IsCaptionAssigned = True
      Caption = #1050#1086#1076' '#1059#1055
      DataBinding.FieldName = 'InfoMoneyCode'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvInfoMoneyGroupName: TcxDBPivotGridField
      AreaIndex = 27
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      DataBinding.FieldName = 'InfoMoneyGroupName'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvInfoMoneyDestinationName: TcxDBPivotGridField
      AreaIndex = 28
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
      DataBinding.FieldName = 'InfoMoneyDestinationName'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvInfoMoneyName: TcxDBPivotGridField
      AreaIndex = 29
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      DataBinding.FieldName = 'InfoMoneyName'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvInfoMoneyName_all: TcxDBPivotGridField
      AreaIndex = 30
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103
      DataBinding.FieldName = 'InfoMoneyName_all'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvInfoMoneyCode_Detail: TcxDBPivotGridField
      AreaIndex = 31
      IsCaptionAssigned = True
      Caption = #1050#1086#1076' '#1059#1055' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      DataBinding.FieldName = 'InfoMoneyCode_Detail'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvInfoMoneyGroupName_Detail: TcxDBPivotGridField
      AreaIndex = 32
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103'  ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      DataBinding.FieldName = 'InfoMoneyGroupName_Detail'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvInfoMoneyDestinationName_Detail: TcxDBPivotGridField
      AreaIndex = 33
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077'  ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      DataBinding.FieldName = 'InfoMoneyDestinationName_Detail'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvInfoMoneyName_Detail: TcxDBPivotGridField
      AreaIndex = 34
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103'  ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      DataBinding.FieldName = 'InfoMoneyName_Detail'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvInfoMoneyName_all_Detail: TcxDBPivotGridField
      AreaIndex = 35
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
    TabOrder = 9
    Width = 79
  end
  object cxLabel10: TcxLabel
    Left = 885
    Top = 32
    Caption = #1058#1086#1074#1072#1088' '#1088#1072#1089#1093':'
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
        Component = GuidesChildGoods
        Properties.Strings = (
          'key'
          'TextValue')
      end
      item
        Component = GuidesChildGoodsGroup
        Properties.Strings = (
          'key'
          'TextValue')
      end
      item
        Component = GuidesFromGroup
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
      end
      item
        Component = GuidesToGroup
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
      FormName = 'TReport_ProductionUnion_OlapDialogForm'
      FormNameParam.Value = 'TReport_ProductionUnion_OlapDialogForm'
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
          Component = GuidesFromGroup
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromGroupName'
          Value = ''
          Component = GuidesFromGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToGroupId'
          Value = ''
          Component = GuidesToGroup
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToGroupName'
          Value = ''
          Component = GuidesToGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = ''
          Component = GuidesChildGoodsGroup
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GuidesChildGoodsGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ChildGoodsGroupId'
          Value = ''
          Component = GuidesGoodsGroup
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ChildGoodsGroupName'
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
          Component = GuidesChildGoods
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GuidesChildGoods
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ChildGoodsId'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ChildGoodsName'
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
    StoredProcName = 'gpReport_ProductionUnion_Olap'
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
        Name = 'inChildGoodsGroupId'
        Value = Null
        Component = GuidesChildGoodsGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChildGoodsId'
        Value = Null
        Component = GuidesChildGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = Null
        Component = GuidesFromGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        Component = GuidesToGroup
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
    Left = 392
    Top = 272
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 360
    Top = 184
  end
  object GuidesFromGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFromGroup
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
        Component = GuidesFromGroup
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesFromGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 520
    Top = 8
  end
  object GuidesToGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edToGroup
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
        Component = GuidesToGroup
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesToGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 560
    Top = 24
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
  object GuidesChildGoodsGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edChildGoodsGroup
    FormNameParam.Value = 'TGoodsGroup_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroup_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesChildGoodsGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesChildGoodsGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 808
    Top = 32
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
    Left = 992
    Top = 65531
  end
  object GuidesChildGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edChildGoods
    FormNameParam.Value = 'TGoodsFuel_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsFuel_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesChildGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesChildGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 1008
    Top = 27
  end
  object PeriodChoice2: TPeriodChoice
    DateStart = deStart2
    DateEnd = deEnd2
    Left = 520
    Top = 328
  end
  object cfMainPrice_Calc: TdsdPivotGridCalcFields
    PivotGrid = cxDBPivotGrid
    CalcField = pvMainPrice_Calc
    GridFields = <
      item
        Field = pvSumm
      end
      item
        Field = pvAmount
      end>
    CalcFieldsType = cfDivision
    Left = 752
    Top = 192
  end
  object cfChildPrice_Calc: TdsdPivotGridCalcFields
    PivotGrid = cxDBPivotGrid
    CalcField = pvChildPrice_Calc
    GridFields = <
      item
        Field = pvChildSumm
      end
      item
        Field = pvChildAmount
      end>
    CalcFieldsType = cfDivision
    Left = 744
    Top = 248
  end
  object cfPrice_Calc: TdsdPivotGridCalcFields
    PivotGrid = cxDBPivotGrid
    CalcField = pvPrice_Calc
    GridFields = <
      item
        Field = pvChildSummCalc
      end
      item
        Field = pvChildAmountCalc
      end>
    CalcFieldsType = cfDivision
    Left = 744
    Top = 296
  end
  object cfPercentOut: TdsdPivotGridCalcFields
    PivotGrid = cxDBPivotGrid
    CalcField = pvPercentOut
    GridFields = <
      item
        Field = pvAmount_Weight
      end
      item
        Field = pvCuterCount
      end>
    CalcFieldsType = cfDivision
    Left = 872
    Top = 216
  end
  object cfMainPrice_CalcW: TdsdPivotGridCalcFields
    PivotGrid = cxDBPivotGrid
    CalcField = pvMainPrice_W
    GridFields = <
      item
        Field = pvSumm
      end
      item
        Field = pvAmount_Weight
      end>
    CalcFieldsType = cfDivision
    Left = 657
    Top = 208
  end
  object cfChildPrice_w: TdsdPivotGridCalcFields
    PivotGrid = cxDBPivotGrid
    CalcField = pvChildPrice_w
    GridFields = <
      item
        Field = pvChildSumm
      end
      item
        Field = pvChildAmount_Weight
      end>
    CalcFieldsType = cfDivision
    Left = 648
    Top = 256
  end
  object cfPrice_Calcw: TdsdPivotGridCalcFields
    PivotGrid = cxDBPivotGrid
    CalcField = pvPrice_w
    GridFields = <
      item
        Field = pvChildSummCalc
      end
      item
        Field = pvChildAmountCalc_Weight
      end>
    CalcFieldsType = cfDivision
    Left = 664
    Top = 312
  end
  object cfReceiptPrice_Calc: TdsdPivotGridCalcFields
    PivotGrid = cxDBPivotGrid
    CalcField = pvReceiptPrice_Calc
    GridFields = <
      item
        Field = pvChildSummReceipt
      end
      item
        Field = pvChildAmountReceipt
      end>
    CalcFieldsType = cfDivision
    Left = 760
    Top = 360
  end
  object cfReceiptPrice_w: TdsdPivotGridCalcFields
    PivotGrid = cxDBPivotGrid
    CalcField = pvReceiptPrice_w
    GridFields = <
      item
        Field = pvChildSummReceipt
      end
      item
        Field = pvChildAmountReceipt_Weight
      end>
    CalcFieldsType = cfDivision
    Left = 664
    Top = 360
  end
end
