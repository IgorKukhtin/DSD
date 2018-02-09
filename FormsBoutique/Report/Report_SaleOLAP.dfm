object Report_SaleOLAPForm: TReport_SaleOLAPForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' ('#1054#1051#1040#1055')'
  ClientHeight = 440
  ClientWidth = 1366
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1366
    Height = 55
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 1434
    object deStart: TcxDateEdit
      Left = 79
      Top = 5
      EditValue = 43101d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 79
      Top = 30
      EditValue = 43101d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 85
    end
    object cxLabel1: TcxLabel
      Left = 12
      Top = 6
      Caption = #1055#1077#1088#1080#1086#1076' '#1089' ...'
    end
    object cxLabel2: TcxLabel
      Left = 5
      Top = 31
      AutoSize = False
      Caption = #1055#1077#1088#1080#1086#1076' '#1087#1086' ...'
      Height = 17
      Width = 72
    end
    object cxLabel4: TcxLabel
      Left = 275
      Top = 32
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082':'
    end
    object edPartner: TcxButtonEdit
      Left = 342
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 5
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
      Width = 200
    end
    object cxLabel3: TcxLabel
      Left = 549
      Top = 6
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072':'
    end
    object edBrand: TcxButtonEdit
      Left = 643
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1058#1086#1088#1075#1086#1074#1091#1102' '#1084#1072#1088#1082#1091'>'
      Width = 155
    end
    object cxLabel5: TcxLabel
      Left = 600
      Top = 31
      Caption = #1057#1077#1079#1086#1085' :'
    end
    object edPeriod: TcxButtonEdit
      Left = 644
      Top = 31
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1057#1077#1079#1086#1085'>'
      Width = 155
    end
    object cxLabel6: TcxLabel
      Left = 812
      Top = 6
      Caption = #1043#1086#1076' '#1089' ...'
    end
    object edStartYear: TcxCurrencyEdit
      Left = 860
      Top = 5
      EditValue = 2018.000000000000000000
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 40
    end
    object cxLabel8: TcxLabel
      Left = 805
      Top = 31
      Caption = #1043#1086#1076' '#1087#1086' ...'
    end
    object edEndYear: TcxCurrencyEdit
      Left = 860
      Top = 30
      EditValue = 2018.000000000000000000
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 40
    end
    object cbSize: TcxCheckBox
      Left = 1055
      Top = 30
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1056#1072#1079#1084#1077#1088#1099' ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1056#1072#1079#1084#1077#1088#1099
      ParentShowHint = False
      ShowHint = True
      TabOrder = 14
      Width = 75
    end
    object cbGoods: TcxCheckBox
      Left = 1055
      Top = 5
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1058#1086#1074#1072#1088#1099' ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1058#1086#1074#1072#1088#1099
      ParentShowHint = False
      ShowHint = True
      TabOrder = 15
      Width = 75
    end
    object cxLabel7: TcxLabel
      Left = 206
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' / '#1043#1088#1091#1087#1087#1072':'
    end
    object edUnit: TcxButtonEdit
      Left = 342
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 17
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Width = 200
    end
    object cbOperPrice: TcxCheckBox
      Left = 1140
      Top = 30
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1062#1077#1085#1072' '#1074#1093'. '#1074' '#1074#1072#1083'. ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1062#1077#1085#1072' '#1074#1093'.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 18
      Width = 70
    end
    object cbYear: TcxCheckBox
      Left = 900
      Top = 30
      Hint = #1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1043#1086#1076' '#1058#1052' ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1043#1086#1076' '#1058#1052
      ParentShowHint = False
      ShowHint = True
      State = cbsChecked
      TabOrder = 19
      Width = 130
    end
    object cbPeriodAll: TcxCheckBox
      Left = 168
      Top = 30
      Hint = #1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1079#1072' '#1042#1077#1089#1100' '#1087#1077#1088#1080#1086#1076' ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1079#1072' '#1042#1077#1089#1100' '#1087#1077#1088#1080#1086#1076
      ParentShowHint = False
      Properties.ReadOnly = False
      ShowHint = True
      State = cbsChecked
      TabOrder = 20
      Width = 105
    end
    object cbClient_doc: TcxCheckBox
      Left = 1140
      Top = 5
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103' ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
      ParentShowHint = False
      ShowHint = True
      TabOrder = 21
      Width = 85
    end
    object cbOperDate_doc: TcxCheckBox
      Left = 1250
      Top = 5
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1043#1086#1076' / '#1052#1077#1089#1103#1094' '#1055#1088#1086#1076#1072#1078#1080' ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1043#1086#1076' / '#1052#1077#1089#1103#1094
      ParentShowHint = False
      ShowHint = True
      TabOrder = 22
      Width = 100
    end
    object cbDay_doc: TcxCheckBox
      Left = 1250
      Top = 30
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080' '#1055#1088#1086#1076#1072#1078#1080' ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080
      ParentShowHint = False
      ShowHint = True
      TabOrder = 23
      Width = 100
    end
  end
  object cxDBPivotGrid: TcxDBPivotGrid
    Left = 0
    Top = 81
    Width = 1366
    Height = 359
    Align = alClient
    DataSource = DataSource
    Groups = <>
    OptionsView.RowGrandTotalWidth = 232
    TabOrder = 1
    ExplicitWidth = 1234
    object pvLabelName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077
      DataBinding.FieldName = 'LabelName'
      MinWidth = 40
      Visible = True
      Width = 250
      UniqueName = #1040'-'#1055
    end
    object pvGoodsGroupName: TcxDBPivotGridField
      AreaIndex = 7
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' ('#1090#1086#1074'.)'
      DataBinding.FieldName = 'GoodsGroupName'
      UniqueName = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object pvGroupsName1: TcxDBPivotGridField
      AreaIndex = 13
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' 1'
      DataBinding.FieldName = 'GroupsName1'
      Visible = True
      UniqueName = #1043#1088#1091#1087#1087#1072' 1'
    end
    object pvGroupsName2: TcxDBPivotGridField
      AreaIndex = 14
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' 2'
      DataBinding.FieldName = 'GroupsName2'
      Visible = True
      UniqueName = #1043#1088#1091#1087#1087#1072' 2'
    end
    object pvGroupsName3: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' 3'
      DataBinding.FieldName = 'GroupsName3'
      Visible = True
      Width = 200
      UniqueName = #1043#1088#1091#1087#1087#1072' 3'
    end
    object pvGroupsName4: TcxDBPivotGridField
      AreaIndex = 15
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' 4'
      DataBinding.FieldName = 'GroupsName4'
      Visible = True
      UniqueName = #1043#1088#1091#1087#1087#1072' 4'
    end
    object pvBrandName: TcxDBPivotGridField
      AreaIndex = 4
      IsCaptionAssigned = True
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
      DataBinding.FieldName = 'BrandName'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvPeriodName: TcxDBPivotGridField
      AreaIndex = 5
      IsCaptionAssigned = True
      Caption = #1057#1077#1079#1086#1085
      DataBinding.FieldName = 'PeriodName'
      Visible = True
      UniqueName = #1069#1083#1077#1084#1077#1085#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1103
    end
    object pvPeriodYear: TcxDBPivotGridField
      AreaIndex = 6
      IsCaptionAssigned = True
      Caption = #1043#1086#1076
      DataBinding.FieldName = 'PeriodYear'
      Visible = True
      UniqueName = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object pvPartnerName: TcxDBPivotGridField
      AreaIndex = 3
      IsCaptionAssigned = True
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
      DataBinding.FieldName = 'PartnerName'
      UniqueName = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object pvGoodsCode: TcxDBPivotGridField
      AreaIndex = 8
      IsCaptionAssigned = True
      Caption = #1050#1086#1076
      DataBinding.FieldName = 'GoodsCode'
      UniqueName = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object pvGoodsName: TcxDBPivotGridField
      AreaIndex = 9
      IsCaptionAssigned = True
      Caption = #1040#1088#1090#1080#1082#1091#1083
      DataBinding.FieldName = 'GoodsName'
      UniqueName = #1057#1095#1077#1090'-'#1075#1088#1091#1087#1087#1072
    end
    object pvGoodsSizeName: TcxDBPivotGridField
      AreaIndex = 10
      IsCaptionAssigned = True
      Caption = #1056#1072#1079#1084#1077#1088
      DataBinding.FieldName = 'GoodsSizeName'
      UniqueName = #1057#1095#1077#1090' - '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
    end
    object pvUnitName: TcxDBPivotGridField
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      DataBinding.FieldName = 'UnitName'
      UniqueName = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object pvClientName: TcxDBPivotGridField
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
      DataBinding.FieldName = 'ClientName'
      UniqueName = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
    end
    object pvUnitName_In: TcxDBPivotGridField
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1087#1088#1080#1093#1086#1076#1072
      DataBinding.FieldName = 'UnitName_In'
      UniqueName = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object pvCurrencyName: TcxDBPivotGridField
      AreaIndex = 11
      IsCaptionAssigned = True
      Caption = #1042#1072#1083'.'
      DataBinding.FieldName = 'CurrencyName'
      UniqueName = #1042#1072#1083'.'
    end
    object pvOperPrice: TcxDBPivotGridField
      AreaIndex = 12
      IsCaptionAssigned = True
      Caption = #1062#1077#1085#1072' '#1074#1093'.'
      DataBinding.FieldName = 'OperPrice'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      UniqueName = #1062#1077#1085#1072' '#1074#1093'.'
    end
    object pvIncome_Amount: TcxDBPivotGridField
      Area = faData
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1050#1086#1083'. '#1087#1088#1080#1093#1086#1076
      DataBinding.FieldName = 'Income_Amount'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvDebt_Amount: TcxDBPivotGridField
      Area = faData
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
      DataBinding.FieldName = 'Debt_Amount'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Visible = True
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvResult_Amount: TcxDBPivotGridField
      Area = faData
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1050#1086#1083'. '#1048#1090#1086#1075
      DataBinding.FieldName = 'Result_Amount'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      UniqueName = #1055#1072#1089#1089#1080#1074#1099' '#1085#1072' '#1082#1086#1085#1077#1094
    end
    object pvResult_Summ: TcxDBPivotGridField
      Area = faData
      AreaIndex = 14
      IsCaptionAssigned = True
      Caption = #1057#1091#1084#1084#1072' '#1048#1090#1086#1075
      DataBinding.FieldName = 'Result_Summ'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      UniqueName = #1055#1072#1089#1089#1080#1074#1099' '#1085#1072' '#1082#1086#1085#1077#1094
    end
    object pvResult_SummCost: TcxDBPivotGridField
      Area = faData
      AreaIndex = 15
      IsCaptionAssigned = True
      Caption = #1057'\'#1089' '#1048#1090#1086#1075
      DataBinding.FieldName = 'Result_SummCost'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      UniqueName = #1055#1072#1089#1089#1080#1074#1099' '#1085#1072' '#1082#1086#1085#1077#1094
    end
    object pvResult_Summ_10200: TcxDBPivotGridField
      Area = faData
      AreaIndex = 16
      IsCaptionAssigned = True
      Caption = #1057#1082#1080#1076#1082#1072' '#1048#1090#1086#1075
      DataBinding.FieldName = 'Result_Summ_10200'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      UniqueName = #1055#1072#1089#1089#1080#1074#1099' '#1085#1072' '#1082#1086#1085#1077#1094
    end
    object pvSale_Amount: TcxDBPivotGridField
      Area = faData
      AreaIndex = 3
      IsCaptionAssigned = True
      Caption = #1050#1086#1083'. '#1087#1088#1086#1076#1072#1078#1072
      DataBinding.FieldName = 'Sale_Amount'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = 'AmountDebetStart'
    end
    object pvSale_Summ: TcxDBPivotGridField
      Area = faData
      AreaIndex = 5
      IsCaptionAssigned = True
      Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1072
      DataBinding.FieldName = 'Sale_Summ'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = 'AmountKreditStart'
    end
    object pvSale_SummCost: TcxDBPivotGridField
      Area = faData
      AreaIndex = 6
      IsCaptionAssigned = True
      Caption = #1057'\'#1089' '#1087#1088#1086#1076#1072#1078#1072
      DataBinding.FieldName = 'Sale_SummCost'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      UniqueName = #1055#1072#1089#1089#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvSale_Summ_10100: TcxDBPivotGridField
      Area = faData
      AreaIndex = 7
      IsCaptionAssigned = True
      Caption = #1057#1091#1084#1084#1072' '#1055#1088#1072#1081#1089
      DataBinding.FieldName = 'Sale_Summ_10100'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxSelection
      UniqueName = #1044#1077#1073#1077#1090' '#1086#1073#1086#1088#1086#1090
    end
    object pvSale_Summ_10201: TcxDBPivotGridField
      Area = faData
      AreaIndex = 8
      IsCaptionAssigned = True
      Caption = #1057#1077#1079#1086#1085#1085#1072#1103' '#1089#1082#1080#1076#1082#1072
      DataBinding.FieldName = 'Sale_Summ_10201'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxSelection
      UniqueName = #1050#1088#1077#1076#1080#1090' '#1086#1073#1086#1088#1086#1090
    end
    object pvSale_Summ_10202: TcxDBPivotGridField
      Area = faData
      AreaIndex = 17
      IsCaptionAssigned = True
      Caption = #1057#1082#1080#1076#1082#1072' outlet'
      DataBinding.FieldName = 'Sale_Summ_10202'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = 'AmountDebetEnd'
    end
    object pvSale_Summ_10203: TcxDBPivotGridField
      Area = faData
      AreaIndex = 18
      IsCaptionAssigned = True
      Caption = #1057#1082#1080#1076#1082#1072' '#1082#1083#1080#1077#1085#1090#1072
      DataBinding.FieldName = 'Sale_Summ_10203'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = 'AmountKreditEnd'
    end
    object pvSale_Summ_10204: TcxDBPivotGridField
      Area = faData
      AreaIndex = 9
      IsCaptionAssigned = True
      Caption = #1057#1082#1080#1076#1082#1072' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103
      DataBinding.FieldName = 'Sale_Summ_10204'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1082#1086#1085#1077#1094
    end
    object pvSale_Summ_10200: TcxDBPivotGridField
      Area = faData
      AreaIndex = 10
      IsCaptionAssigned = True
      Caption = #1057#1082#1080#1076#1082#1072' '#1048#1058#1054#1043#1054
      DataBinding.FieldName = 'Sale_Summ_10200'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      UniqueName = #1055#1072#1089#1089#1080#1074#1099' '#1085#1072' '#1082#1086#1085#1077#1094
    end
    object pvReturn_Amount: TcxDBPivotGridField
      Area = faData
      AreaIndex = 4
      IsCaptionAssigned = True
      Caption = #1050#1086#1083'. '#1074#1086#1079#1074#1088#1072#1090
      DataBinding.FieldName = 'Return_Amount'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      UniqueName = #1055#1072#1089#1089#1080#1074#1099' '#1085#1072' '#1082#1086#1085#1077#1094
    end
    object pvReturn_Summ: TcxDBPivotGridField
      Area = faData
      AreaIndex = 11
      IsCaptionAssigned = True
      Caption = #1057#1091#1084#1084#1072' '#1074#1086#1079#1074#1088#1072#1090
      DataBinding.FieldName = 'Return_Summ'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      UniqueName = #1055#1072#1089#1089#1080#1074#1099' '#1085#1072' '#1082#1086#1085#1077#1094
    end
    object pvReturn_SummCost: TcxDBPivotGridField
      Area = faData
      AreaIndex = 12
      IsCaptionAssigned = True
      Caption = #1057'\'#1089' '#1074#1086#1079#1074#1088#1072#1090
      DataBinding.FieldName = 'Return_SummCost'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      UniqueName = #1055#1072#1089#1089#1080#1074#1099' '#1085#1072' '#1082#1086#1085#1077#1094
    end
    object pvReturn_Summ_10200: TcxDBPivotGridField
      Area = faData
      AreaIndex = 13
      IsCaptionAssigned = True
      Caption = #1057#1082#1080#1076#1082#1072' '#1074#1086#1079#1074#1088#1072#1090
      DataBinding.FieldName = 'Return_Summ_10200'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      UniqueName = #1055#1072#1089#1089#1080#1074#1099' '#1085#1072' '#1082#1086#1085#1077#1094
    end
    object PeriodName_doc: TcxDBPivotGridField
      AreaIndex = 16
      IsCaptionAssigned = True
      Caption = #1044#1072#1090#1072' ('#1087#1088#1086#1076'.)'
      DataBinding.FieldName = 'PeriodName_doc'
      UniqueName = #1044#1072#1090#1072' ('#1087#1088#1086#1076'.)'
    end
    object PeriodYear_doc: TcxDBPivotGridField
      AreaIndex = 17
      IsCaptionAssigned = True
      Caption = #1043#1086#1076' ('#1087#1088#1086#1076'.)'
      DataBinding.FieldName = 'PeriodYear_doc'
      UniqueName = #1043#1086#1076' ('#1087#1088#1086#1076'.)'
    end
    object MonthName_doc: TcxDBPivotGridField
      AreaIndex = 18
      IsCaptionAssigned = True
      Caption = #1052#1077#1089#1103#1094' ('#1087#1088#1086#1076'.)'
      DataBinding.FieldName = 'MonthName_doc'
      UniqueName = #1052#1077#1089#1103#1094' ('#1087#1088#1086#1076'.)'
    end
    object DayName_doc: TcxDBPivotGridField
      AreaIndex = 19
      IsCaptionAssigned = True
      Caption = #1044#1077#1085#1100' ('#1087#1088#1086#1076'.)'
      DataBinding.FieldName = 'DayName_doc'
      UniqueName = #1044#1077#1085#1100' ('#1087#1088#1086#1076'.)'
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
        Component = edEndYear
        Properties.Strings = (
          'Value')
      end
      item
        Component = edStartYear
        Properties.Strings = (
          'Value')
      end
      item
        Component = GuidesBrand
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesPartner
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesPeriod
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
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
      FormName = 'TReport_SaleOLAPDialogForm'
      FormNameParam.Value = 'TReport_SaleOLAPDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41579d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41608d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerId'
          Value = Null
          Component = GuidesPartner
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = Null
          Component = GuidesPartner
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BrandId'
          Value = Null
          Component = GuidesBrand
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BrandName'
          Value = Null
          Component = GuidesBrand
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodId'
          Value = Null
          Component = GuidesPeriod
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodName'
          Value = Null
          Component = GuidesPeriod
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartYear'
          Value = Null
          Component = edStartYear
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndYear'
          Value = Null
          Component = edEndYear
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isYear'
          Value = Null
          Component = cbYear
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPeriodAll'
          Value = Null
          Component = cbPeriodAll
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoods'
          Value = Null
          Component = cbGoods
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isSize'
          Value = Null
          Component = cbSize
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isClient_doc'
          Value = Null
          Component = cbClient_doc
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isOperDate_doc'
          Value = Null
          Component = cbOperDate_doc
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDay_doc'
          Value = Null
          Component = cbDay_doc
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isOperPrice'
          Value = Null
          Component = cbOperPrice
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  object spReport: TdsdStoredProc
    StoredProcName = 'gpReport_SaleOLAP'
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
        Name = 'inPartnerId'
        Value = Null
        Component = GuidesPartner
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBrandId'
        Value = Null
        Component = GuidesBrand
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriodId'
        Value = Null
        Component = GuidesPeriod
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartYear'
        Value = Null
        Component = edStartYear
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndYear'
        Value = Null
        Component = edEndYear
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsYear'
        Value = Null
        Component = cbYear
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPeriodAll'
        Value = Null
        Component = cbPeriodAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoods'
        Value = Null
        Component = cbGoods
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSize'
        Value = Null
        Component = cbSize
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsClient_doc'
        Value = Null
        Component = cbClient_doc
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsOperDate_doc'
        Value = Null
        Component = cbOperDate_doc
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDay_doc'
        Value = Null
        Component = cbDay_doc
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsOperPrice'
        Value = Null
        Component = cbOperPrice
        DataType = ftBoolean
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
    Left = 808
    Top = 144
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesPartner
      end
      item
        Component = GuidesBrand
      end
      item
        Component = GuidesPeriod
      end
      item
        Component = cbYear
      end
      item
        Component = cbPeriodAll
      end
      item
        Component = cbGoods
      end
      item
        Component = cbSize
      end
      item
        Component = cbClient_doc
      end
      item
        Component = cbOperDate_doc
      end
      item
        Component = cbDay_doc
      end
      item
        Component = cbOperPrice
      end>
    Left = 496
    Top = 224
  end
  object PivotAddOn: TPivotAddOn
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
  object GuidesPartner: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartner
    FormNameParam.Value = 'TPartnerForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartnerForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 488
    Top = 32
  end
  object GuidesBrand: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBrand
    Key = '0'
    FormNameParam.Value = 'TBrandForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBrandForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesBrand
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBrand
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 726
    Top = 65534
  end
  object GuidesPeriod: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPeriod
    Key = '0'
    FormNameParam.Value = 'TPeriodForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPeriodForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesPeriod
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPeriod
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 662
    Top = 34
  end
end
