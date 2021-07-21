object Report_MotionOLAPForm: TReport_MotionOLAPForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1076#1074#1080#1078#1077#1085#1080#1102' ('#1054#1051#1040#1055')'
  ClientHeight = 423
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
      Left = 75
      Top = 5
      EditValue = 43101d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 75
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
      Left = 261
      Top = 32
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082':'
    end
    object edPartner: TcxButtonEdit
      Left = 328
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
      Left = 531
      Top = 6
      Hint = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
      Caption = #1052#1072#1088#1082#1072':'
      ParentShowHint = False
      ShowHint = True
    end
    object edBrand: TcxButtonEdit
      Left = 570
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
      Left = 530
      Top = 31
      Caption = #1057#1077#1079#1086#1085':'
    end
    object edPeriod: TcxButtonEdit
      Left = 570
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
      Left = 726
      Top = 6
      Caption = #1043#1086#1076' '#1089' ...'
    end
    object cxLabel8: TcxLabel
      Left = 820
      Top = 6
      Caption = #1043#1086#1076' '#1087#1086' ...'
    end
    object cbSize: TcxCheckBox
      Left = 1071
      Top = 30
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1056#1072#1079#1084#1077#1088#1099' ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1056#1072#1079#1084#1077#1088#1099
      ParentShowHint = False
      ShowHint = True
      TabOrder = 12
      Width = 69
    end
    object cbGoods: TcxCheckBox
      Left = 1071
      Top = 5
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1058#1086#1074#1072#1088#1099' ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1058#1086#1074#1072#1088#1099
      ParentShowHint = False
      ShowHint = True
      TabOrder = 13
      Width = 69
    end
    object cxLabel7: TcxLabel
      Left = 192
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' / '#1043#1088#1091#1087#1087#1072':'
    end
    object edUnit: TcxButtonEdit
      Left = 328
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 15
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Width = 200
    end
    object cbOperPrice: TcxCheckBox
      Left = 1138
      Top = 30
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1062#1077#1085#1072' '#1074#1093'. '#1074' '#1074#1072#1083'. ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1062#1077#1085#1072' '#1074#1093'.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 16
      Width = 85
    end
    object cbYear: TcxCheckBox
      Left = 923
      Top = 30
      Hint = #1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1043#1086#1076' '#1058#1052' ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1043#1086#1076' '#1058#1052
      ParentShowHint = False
      ShowHint = True
      TabOrder = 17
      Width = 130
    end
    object cbPeriodAll: TcxCheckBox
      Left = 160
      Top = 30
      Hint = #1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1079#1072' '#1042#1077#1089#1100' '#1087#1077#1088#1080#1086#1076' ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1079#1072' '#1042#1077#1089#1100' '#1087#1077#1088#1080#1086#1076
      ParentShowHint = False
      Properties.ReadOnly = False
      ShowHint = True
      State = cbsChecked
      TabOrder = 18
      Width = 105
    end
    object cbClient_doc: TcxCheckBox
      Left = 1138
      Top = 5
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103' ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
      ParentShowHint = False
      ShowHint = True
      TabOrder = 19
      Width = 85
    end
    object cbOperDate_doc: TcxCheckBox
      Left = 1233
      Top = 5
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1043#1086#1076' / '#1052#1077#1089#1103#1094' '#1055#1088#1086#1076#1072#1078#1080' ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1043#1086#1076' / '#1052#1077#1089#1103#1094
      ParentShowHint = False
      ShowHint = True
      TabOrder = 20
      Width = 92
    end
    object cbDay_doc: TcxCheckBox
      Left = 1233
      Top = 30
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080' '#1055#1088#1086#1076#1072#1078#1080' ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080
      ParentShowHint = False
      ShowHint = True
      TabOrder = 21
      Width = 92
    end
    object cbDiscount: TcxCheckBox
      Left = 923
      Top = 5
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' % '#1089#1082#1080#1076#1082#1080' ('#1044#1072'/'#1053#1077#1090')'
      Caption = '% '#1057#1082#1080#1076'.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 22
      Width = 70
    end
    object edStartYear: TcxButtonEdit
      Left = 769
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 23
      Width = 50
    end
    object edEndYear: TcxButtonEdit
      Left = 871
      Top = 5
      TabStop = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 24
      Width = 50
    end
    object cbMark: TcxCheckBox
      Left = 992
      Top = 5
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1058#1054#1051#1068#1050#1054' '#1076#1083#1103' '#1057#1055#1048#1057#1050#1040' '#1055#1072#1088#1090#1080#1081'/'#1058#1086#1074#1072#1088#1086#1074
      Caption = #1057#1087#1080#1089#1086#1082' '#1055'/'#1058
      ParentShowHint = False
      ShowHint = True
      TabOrder = 25
      Width = 82
    end
    object cxLabel9: TcxLabel
      Left = 728
      Top = 32
      Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072':'
    end
    object edGoodsCode2: TcxCurrencyEdit
      Left = 795
      Top = 30
      EditValue = 0.000000000000000000
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      TabOrder = 27
      Width = 55
    end
    object edGoodsCodeChoice: TcxButtonEdit
      Left = 852
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Properties.ViewStyle = vsButtonsOnly
      TabOrder = 28
      Width = 25
    end
    object cxLabel10: TcxLabel
      Left = 880
      Top = 32
      Caption = 'Enter'
      Style.TextColor = 6118749
    end
  end
  object cxDBPivotGrid: TcxDBPivotGrid
    Left = 0
    Top = 81
    Width = 1362
    Height = 342
    Align = alClient
    DataSource = DataSource
    Groups = <>
    OptionsView.RowGrandTotalWidth = 173
    TabOrder = 1
    object pvLabelName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077
      DataBinding.FieldName = 'LabelName'
      MinWidth = 40
      Visible = True
      Width = 200
      UniqueName = #1040'-'#1055
    end
    object pvGoodsGroupName: TcxDBPivotGridField
      AreaIndex = 10
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' ('#1090#1086#1074'.)'
      DataBinding.FieldName = 'GoodsGroupName'
      UniqueName = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object pvGroupsName3: TcxDBPivotGridField
      AreaIndex = 8
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' 3'
      DataBinding.FieldName = 'GroupsName3'
      Visible = True
      UniqueName = #1043#1088#1091#1087#1087#1072' 1'
    end
    object pvGroupsName2: TcxDBPivotGridField
      AreaIndex = 7
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' 2'
      DataBinding.FieldName = 'GroupsName2'
      Visible = True
      UniqueName = #1043#1088#1091#1087#1087#1072' 2'
    end
    object pvGroupsName1: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' 1'
      DataBinding.FieldName = 'GroupsName1'
      Visible = True
      Width = 200
      UniqueName = #1043#1088#1091#1087#1087#1072' 3'
    end
    object pvGroupsName4: TcxDBPivotGridField
      AreaIndex = 13
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' 4'
      DataBinding.FieldName = 'GroupsName4'
      UniqueName = #1043#1088#1091#1087#1087#1072' 4'
    end
    object pvCompositionName: TcxDBPivotGridField
      AreaIndex = 22
      IsCaptionAssigned = True
      Caption = #1057#1086#1089#1090#1072#1074
      DataBinding.FieldName = 'CompositionName'
      Visible = True
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvGoodsInfoName: TcxDBPivotGridField
      AreaIndex = 23
      IsCaptionAssigned = True
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077
      DataBinding.FieldName = 'GoodsInfoName'
      Visible = True
      UniqueName = #1054#1087#1080#1089#1072#1085#1080#1077
    end
    object pvLineFabricaName: TcxDBPivotGridField
      AreaIndex = 28
      IsCaptionAssigned = True
      Caption = #1051#1080#1085#1080#1103
      DataBinding.FieldName = 'LineFabricaName'
      UniqueName = #1051#1080#1085#1080#1103
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
      AreaIndex = 9
      IsCaptionAssigned = True
      Caption = #1050#1086#1076
      DataBinding.FieldName = 'GoodsCode'
      Visible = True
      Width = 50
      UniqueName = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object pvGoodsName: TcxDBPivotGridField
      AreaIndex = 11
      IsCaptionAssigned = True
      Caption = #1040#1088#1090#1080#1082#1091#1083
      DataBinding.FieldName = 'GoodsName'
      Visible = True
      Width = 55
      UniqueName = #1057#1095#1077#1090'-'#1075#1088#1091#1087#1087#1072
    end
    object pvGoodsSizeName: TcxDBPivotGridField
      AreaIndex = 12
      IsCaptionAssigned = True
      Caption = #1056#1072#1079#1084'.'
      DataBinding.FieldName = 'GoodsSizeName'
      Visible = True
      Width = 40
      UniqueName = #1057#1095#1077#1090' - '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
    end
    object pvisOLAP_Partion: TcxDBPivotGridField
      AreaIndex = 25
      IsCaptionAssigned = True
      Caption = #1057#1087#1080#1089#1086#1082' '#1087#1072#1088#1090#1080#1081
      DataBinding.FieldName = 'isOLAP_Partion'
      Visible = True
      Width = 55
      UniqueName = #1057#1095#1077#1090' - '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
    end
    object pvisOLAP_Goods: TcxDBPivotGridField
      AreaIndex = 26
      IsCaptionAssigned = True
      Caption = #1057#1087#1080#1089#1086#1082' '#1090#1086#1074'.'
      DataBinding.FieldName = 'isOLAP_Goods'
      Visible = True
      Width = 55
      UniqueName = #1057#1095#1077#1090' - '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
    end
    object pvUnitName: TcxDBPivotGridField
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      DataBinding.FieldName = 'UnitName'
      Visible = True
      UniqueName = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object pvClientName: TcxDBPivotGridField
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
      DataBinding.FieldName = 'ClientName'
      UniqueName = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
    end
    object pvDiscountSaleKindName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 3
      IsCaptionAssigned = True
      Caption = #1042#1080#1076' '#1089#1082#1080#1076#1082#1080
      DataBinding.FieldName = 'DiscountSaleKindName'
      Visible = True
      UniqueName = #1042#1080#1076' '#1089#1082#1080#1076#1082#1080
    end
    object pvChangePercent: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 4
      IsCaptionAssigned = True
      Caption = '% '#1089#1082'.-1'
      DataBinding.FieldName = 'ChangePercent'
      Visible = True
      Width = 55
      UniqueName = '% '#1089#1082'.'
    end
    object pvChangePercentNext: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 5
      IsCaptionAssigned = True
      Caption = '% '#1089#1082'.-2'
      DataBinding.FieldName = 'ChangePercentNext'
      Visible = True
      Width = 55
      UniqueName = '% '#1089#1082'.'
    end
    object pvUnitName_In: TcxDBPivotGridField
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1087#1088#1080#1093#1086#1076#1072
      DataBinding.FieldName = 'UnitName_In'
      UniqueName = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object pvCurrencyName: TcxDBPivotGridField
      AreaIndex = 24
      IsCaptionAssigned = True
      Caption = #1042#1072#1083'.'
      DataBinding.FieldName = 'CurrencyName'
      Visible = True
      Width = 40
      UniqueName = #1042#1072#1083'.'
    end
    object pvOperPrice: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1062#1077#1085#1072' '#1074#1093'.'
      DataBinding.FieldName = 'OperPrice'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Visible = True
      Width = 55
      UniqueName = #1062#1077#1085#1072' '#1074#1093'.'
    end
    object pvDebt_Amount: TcxDBPivotGridField
      AreaIndex = 29
      IsCaptionAssigned = True
      Caption = #1044#1086#1083#1075' '#1082#1086#1083'.'
      DataBinding.FieldName = 'Debt_Amount'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvDebt_Summ: TcxDBPivotGridField
      AreaIndex = 42
      IsCaptionAssigned = True
      Caption = #1044#1086#1083#1075' '#1057'/'#1057
      DataBinding.FieldName = 'Debt_Summ'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Width = 55
      UniqueName = #1044#1086#1083#1075' '#1057'/'#1057
    end
    object pvResult_InDiscount: TcxDBPivotGridField
      Area = faData
      AreaIndex = 29
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076'. '#1055#1054' '#1089#1082'.'
      DataBinding.FieldName = 'Result_InDiscount'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = 'AmountDebetStart'
    end
    object pvResult_OutDiscount: TcxDBPivotGridField
      Area = faData
      AreaIndex = 33
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076'. '#1044#1054' '#1089#1082'.'
      DataBinding.FieldName = 'Result_OutDiscount'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = 'AmountDebetStart'
    end
    object pvResult_SummCost_curr_InD: TcxDBPivotGridField
      Area = faData
      AreaIndex = 30
      IsCaptionAssigned = True
      Caption = #1057'\'#1089' '#1074' '#1074#1072#1083'. '#1055#1054' '#1089#1082'.'
      DataBinding.FieldName = 'Result_SummCost_curr_InD'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = 'AmountDebetStart'
    end
    object pvResult_SummCost_curr_OutD: TcxDBPivotGridField
      Area = faData
      AreaIndex = 34
      IsCaptionAssigned = True
      Caption = #1057'\'#1089' '#1074' '#1074#1072#1083'. '#1044#1054' '#1089#1082'.'
      DataBinding.FieldName = 'Result_SummCost_curr_OutD'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = 'AmountDebetStart'
    end
    object pvResult_Summ_InD: TcxDBPivotGridField
      Area = faData
      AreaIndex = 31
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076'. '#1074' '#1043#1056#1053' '#1055#1054' '#1089#1082'.'
      DataBinding.FieldName = 'Result_Summ_InD'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = 'AmountDebetStart'
    end
    object pvResult_Summ_OutD: TcxDBPivotGridField
      Area = faData
      AreaIndex = 35
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076'. '#1074' '#1043#1056#1053' '#1044#1054' '#1089#1082'.'
      DataBinding.FieldName = 'Result_Summ_OutD'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = 'AmountDebetStart'
    end
    object pvResult_Summ_10200_InD: TcxDBPivotGridField
      Area = faData
      AreaIndex = 32
      IsCaptionAssigned = True
      Caption = #1057#1082#1080#1076#1082#1072' '#1074' '#1043#1056#1053' '#1055#1054' '#1089#1082'.'
      DataBinding.FieldName = 'Result_Summ_10200_InD'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = 'AmountDebetStart'
    end
    object pvResult_Summ_10200_OutD: TcxDBPivotGridField
      Area = faData
      AreaIndex = 36
      IsCaptionAssigned = True
      Caption = #1057#1082#1080#1076#1082#1072' '#1074' '#1043#1056#1053' '#1044#1054' '#1089#1082'.'
      DataBinding.FieldName = 'Result_Summ_10200_OutD'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = 'AmountDebetStart'
    end
    object pvIncome_Amount: TcxDBPivotGridField
      Area = faData
      AreaIndex = 5
      IsCaptionAssigned = True
      Caption = #1055#1088#1080#1093#1086#1076' '#1082#1086#1083'. '
      DataBinding.FieldName = 'Income_Amount'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 70
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvIncome_Summ: TcxDBPivotGridField
      Area = faData
      AreaIndex = 6
      IsCaptionAssigned = True
      Caption = #1055#1088#1080#1093#1086#1076' '#1074' '#1074#1072#1083'.'
      DataBinding.FieldName = 'Income_Summ'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 90
      UniqueName = #1057#1091#1084#1084#1072' '#1087#1088#1080#1093'. '#1074' '#1074#1072#1083'. '
    end
    object pvIncomeReal_Amount: TcxDBPivotGridField
      AreaIndex = 45
      IsCaptionAssigned = True
      Caption = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1082#1086#1083'.'
      DataBinding.FieldName = 'IncomeReal_Amount'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1082#1086#1083'.'
    end
    object pvIncomeReal_Summ: TcxDBPivotGridField
      AreaIndex = 43
      IsCaptionAssigned = True
      Caption = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
      DataBinding.FieldName = 'IncomeReal_Summ'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Width = 70
      UniqueName = #1055#1088#1080#1093'. '#1073#1077#1079' '#1091#1095'. '#1073#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvSendIn_Amount: TcxDBPivotGridField
      Area = faData
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = '+'#1055#1077#1088#1077#1084#1077#1097'.'
      DataBinding.FieldName = 'SendIn_Amount'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 58
      UniqueName = '+'#1055#1077#1088#1077#1084#1077#1097'.'
    end
    object pvSendIn_Summ: TcxDBPivotGridField
      AreaIndex = 40
      IsCaptionAssigned = True
      Caption = '+'#1055#1077#1088#1077#1084'. '#1074' '#1074#1072#1083'.'
      DataBinding.FieldName = 'SendIn_Summ'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 80
      UniqueName = '+'#1055#1077#1088#1077#1084'. '#1074' '#1074#1072#1083'.'
    end
    object pvSendOut_Amount: TcxDBPivotGridField
      Area = faData
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = '-'#1055#1077#1088#1077#1084#1077#1097'.'
      DataBinding.FieldName = 'SendOut_Amount'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 58
      UniqueName = '-'#1055#1077#1088#1077#1084#1077#1097'.'
    end
    object pvSendOut_Summ: TcxDBPivotGridField
      AreaIndex = 41
      IsCaptionAssigned = True
      Caption = '-'#1055#1077#1088#1077#1084'. '#1074' '#1074#1072#1083'.'
      DataBinding.FieldName = 'SendOut_Summ'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 80
      UniqueName = '-'#1055#1077#1088#1077#1084'. '#1074' '#1074#1072#1083'.'
    end
    object pvLoss_Amount: TcxDBPivotGridField
      Area = faData
      AreaIndex = 3
      IsCaptionAssigned = True
      Caption = #1041#1088#1072#1082' '#1082#1086#1083'.'
      DataBinding.FieldName = 'Loss_Amount'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 40
      UniqueName = #1041#1088#1072#1082' '#1082#1086#1083'. '
    end
    object pvLoss_Summ: TcxDBPivotGridField
      AreaIndex = 44
      IsCaptionAssigned = True
      Caption = #1041#1088#1072#1082' '#1074' '#1074#1072#1083'.'
      DataBinding.FieldName = 'Loss_Summ'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Width = 70
      UniqueName = #1041#1088#1072#1082' '#1074' '#1074#1072#1083'.'
    end
    object pvRemains_Amount: TcxDBPivotGridField
      Area = faData
      AreaIndex = 13
      IsCaptionAssigned = True
      Caption = #1054#1089#1090'. '#1082#1086#1083'. '
      DataBinding.FieldName = 'Remains_Amount'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Hidden = True
      Width = 58
      UniqueName = #1054#1089#1090'. '#1082#1086#1083'. '
    end
    object pvRemains_Summ: TcxDBPivotGridField
      Area = faData
      AreaIndex = 16
      IsCaptionAssigned = True
      Caption = #1054#1089#1090'. '#1074' '#1074#1072#1083'. '
      DataBinding.FieldName = 'Remains_Summ'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Hidden = True
      Width = 70
      UniqueName = #1054#1089#1090'. '#1074' '#1074#1072#1083'. '
    end
    object pvRemains_Amount_real: TcxDBPivotGridField
      AreaIndex = 36
      IsCaptionAssigned = True
      Caption = #1054#1089#1090'. '#1082#1086#1083'. +'#1044'.'
      DataBinding.FieldName = 'Remains_Amount_real'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Hidden = True
      Width = 80
      UniqueName = #1054#1089#1090'. '#1082#1086#1083'. +'#1044'.'
    end
    object pvRemainsStart: TcxDBPivotGridField
      Area = faData
      AreaIndex = 14
      IsCaptionAssigned = True
      Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1082#1086#1083'. '
      DataBinding.FieldName = 'RemainsStart'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Visible = True
      Width = 58
      UniqueName = #1054#1089#1090'. '#1082#1086#1083'. '
    end
    object pvRemainsEnd: TcxDBPivotGridField
      Area = faData
      AreaIndex = 15
      IsCaptionAssigned = True
      Caption = #1054#1089#1090'. '#1082#1086#1085#1077#1095#1085'. '#1082#1086#1083'. '
      DataBinding.FieldName = 'RemainsEnd'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Visible = True
      Width = 58
      UniqueName = #1054#1089#1090'. '#1082#1086#1083'. '
    end
    object pvRemainsStart_Summ: TcxDBPivotGridField
      Area = faData
      AreaIndex = 17
      IsCaptionAssigned = True
      Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1074' '#1043#1056#1053' ('#1062#1055#1088#1080#1093')'
      DataBinding.FieldName = 'RemainsStart_Summ'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Visible = True
      Width = 70
      UniqueName = #1054#1089#1090'. '#1074' '#1074#1072#1083'. '
    end
    object pvRemainsEnd_Summ: TcxDBPivotGridField
      Area = faData
      AreaIndex = 21
      IsCaptionAssigned = True
      Caption = #1054#1089#1090'. '#1082#1086#1085#1077#1095#1085'. '#1074' '#1043#1056#1053' ('#1062#1055#1088#1080#1093')'
      DataBinding.FieldName = 'RemainsEnd_Summ'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Visible = True
      Width = 70
      UniqueName = #1054#1089#1090'. '#1074' '#1074#1072#1083'. '
    end
    object RemainsStart_PriceListSumm: TcxDBPivotGridField
      Area = faData
      AreaIndex = 18
      IsCaptionAssigned = True
      Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1074' '#1043#1056#1053' ('#1062#1055#1088#1086#1076'.)'
      DataBinding.FieldName = 'RemainsStart_PriceListSumm'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Visible = True
      Width = 70
      UniqueName = #1054#1089#1090'. '#1074' '#1074#1072#1083'. '
    end
    object RemainsEnd_PriceListSumm: TcxDBPivotGridField
      Area = faData
      AreaIndex = 22
      IsCaptionAssigned = True
      Caption = #1054#1089#1090'. '#1082#1086#1085#1077#1095#1085'. '#1074' '#1043#1056#1053' ('#1062#1055#1088#1086#1076'.)'
      DataBinding.FieldName = 'RemainsEnd_PriceListSumm'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Visible = True
      Width = 70
      UniqueName = #1054#1089#1090'. '#1074' '#1074#1072#1083'. '
    end
    object RemainsStart_PriceListSumm_curr: TcxDBPivotGridField
      Area = faData
      AreaIndex = 19
      IsCaptionAssigned = True
      Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1074' '#1074#1072#1083'. ('#1062#1055#1088#1086#1076'.)'
      DataBinding.FieldName = 'RemainsStart_PriceListSumm_curr'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Visible = True
      Width = 70
      UniqueName = #1054#1089#1090'. '#1074' '#1074#1072#1083'. '
    end
    object RemainsEnd_PriceListSumm_curr: TcxDBPivotGridField
      Area = faData
      AreaIndex = 23
      IsCaptionAssigned = True
      Caption = #1054#1089#1090'. '#1082#1086#1085#1077#1095#1085'. '#1074' '#1074#1072#1083'. ('#1062#1055#1088#1086#1076'.)'
      DataBinding.FieldName = 'RemainsEnd_PriceListSumm_curr'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Visible = True
      Width = 70
      UniqueName = #1054#1089#1090'. '#1074' '#1074#1072#1083'. '
    end
    object pvRemainsStart_Summ_curr: TcxDBPivotGridField
      Area = faData
      AreaIndex = 20
      IsCaptionAssigned = True
      Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1074' '#1074#1072#1083'. ('#1062#1055#1088#1080#1093')'
      DataBinding.FieldName = 'RemainsStart_Summ_curr'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Visible = True
      Width = 70
      UniqueName = #1054#1089#1090'. '#1074' '#1074#1072#1083'. '
    end
    object pvRemainsEnd_Summ_curr: TcxDBPivotGridField
      Area = faData
      AreaIndex = 24
      IsCaptionAssigned = True
      Caption = #1054#1089#1090'. '#1082#1086#1085#1077#1095#1085'. '#1074' '#1074#1072#1083'. ('#1062#1055#1088#1080#1093')'
      DataBinding.FieldName = 'RemainsEnd_Summ_curr'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Visible = True
      Width = 70
      UniqueName = #1054#1089#1090'. '#1074' '#1074#1072#1083'. '
    end
    object pvResult_Amount: TcxDBPivotGridField
      Area = faData
      AreaIndex = 9
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076'. '#1082#1086#1083'.'
      DataBinding.FieldName = 'Result_Amount'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 70
      UniqueName = #1055#1072#1089#1089#1080#1074#1099' '#1085#1072' '#1082#1086#1085#1077#1094
    end
    object pvResult_Amount_real: TcxDBPivotGridField
      AreaIndex = 38
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076'. '#1082#1086#1083'. -'#1044'.'
      DataBinding.FieldName = 'Result_Amount_real'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      UniqueName = #1055#1088#1086#1076'. '#1082#1086#1083'. -'#1044'.'
    end
    object pvResult_Summ_curr: TcxDBPivotGridField
      Area = faData
      AreaIndex = 11
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076'. '#1074' '#1074#1072#1083'.'
      DataBinding.FieldName = 'Result_Summ_curr'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1057#1091#1084#1084#1072' '#1048#1090#1086#1075' '#1074' '#1074#1072#1083'.'
    end
    object pvResult_Summ: TcxDBPivotGridField
      Area = faData
      AreaIndex = 10
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076'. '#1074' '#1043#1056#1053
      DataBinding.FieldName = 'Result_Summ'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 90
      UniqueName = #1055#1072#1089#1089#1080#1074#1099' '#1085#1072' '#1082#1086#1085#1077#1094
    end
    object pvResult_SummCost_curr: TcxDBPivotGridField
      Area = faData
      AreaIndex = 12
      IsCaptionAssigned = True
      Caption = #1057'\'#1089' '#1074' '#1074#1072#1083'.'
      DataBinding.FieldName = 'Result_SummCost_curr'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 70
      UniqueName = #1057'\'#1089' '#1048#1090#1086#1075' '#1074' '#1074#1072#1083'.'
    end
    object pvResult_SummCost: TcxDBPivotGridField
      Area = faData
      AreaIndex = 47
      IsCaptionAssigned = True
      Caption = #1057'\'#1089' '#1074' '#1043#1056#1053
      DataBinding.FieldName = 'Result_SummCost'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      UniqueName = #1055#1072#1089#1089#1080#1074#1099' '#1085#1072' '#1082#1086#1085#1077#1094
    end
    object pvResult_Summ_10200_curr: TcxDBPivotGridField
      Area = faData
      AreaIndex = 26
      IsCaptionAssigned = True
      Caption = #1057#1082#1080#1076#1082#1072' '#1074' '#1074#1072#1083'.'
      DataBinding.FieldName = 'Result_Summ_10200_curr'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 90
      UniqueName = #1057#1082#1080#1076#1082#1072' '#1048#1090#1086#1075' '#1074' '#1074#1072#1083'.'
    end
    object pvResult_Summ_10200: TcxDBPivotGridField
      Area = faData
      AreaIndex = 48
      IsCaptionAssigned = True
      Caption = #1057#1082#1080#1076#1082#1072' '#1074' '#1043#1056#1053
      DataBinding.FieldName = 'Result_Summ_10200'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      UniqueName = #1055#1072#1089#1089#1080#1074#1099' '#1085#1072' '#1082#1086#1085#1077#1094
    end
    object pvResult_Summ_prof_curr: TcxDBPivotGridField
      Area = faData
      AreaIndex = 25
      IsCaptionAssigned = True
      Caption = #1055#1088#1080#1073#1099#1083#1100' '#1074' '#1074#1072#1083'.'
      DataBinding.FieldName = 'Result_Summ_prof_curr'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Width = 100
      UniqueName = #1055#1088#1080#1073#1099#1083#1100' '#1048#1090#1086#1075' '#1074' '#1074#1072#1083'.'
    end
    object pvResult_Summ_prof: TcxDBPivotGridField
      Area = faData
      AreaIndex = 27
      IsCaptionAssigned = True
      Caption = #1055#1088#1080#1073#1099#1083#1100' '#1074' '#1043#1056#1053
      DataBinding.FieldName = 'Result_Summ_prof'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      UniqueName = #1055#1088#1080#1073#1099#1083#1100' '#1048#1090#1086#1075
    end
    object pvSale_Summ_prof: TcxDBPivotGridField
      AreaIndex = 20
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076'. '#1087#1088#1080#1073'. '#1074' '#1043#1056#1053' '
      DataBinding.FieldName = 'Sale_Summ_prof'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      UniqueName = #1055#1088#1080#1073#1099#1083#1100' '#1087#1088#1086#1076#1072#1078#1072
    end
    object pvReturn_Summ_prof: TcxDBPivotGridField
      AreaIndex = 21
      IsCaptionAssigned = True
      Caption = #1042#1086#1079#1074#1088'. '#1091#1073#1099#1090'. '#1074' '#1043#1056#1053' '
      DataBinding.FieldName = 'Return_Summ_prof'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      UniqueName = #1055#1088#1080#1073#1099#1083#1100' '#1074#1086#1079#1074#1088#1072#1090
    end
    object pvSale_Amount: TcxDBPivotGridField
      Area = faData
      AreaIndex = 28
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076'. '#1082#1086#1083': +'#1044'. -'#1042'. '
      DataBinding.FieldName = 'Sale_Amount'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = 'AmountDebetStart'
    end
    object pvSale_Amount_real: TcxDBPivotGridField
      AreaIndex = 37
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076'. '#1082#1086#1083': -'#1044'. -'#1042'. '
      DataBinding.FieldName = 'Sale_Amount_real'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = #1055#1088#1086#1076'. '#1082#1086#1083': -'#1044'. -'#1042'. '
    end
    object pvSale_Summ_curr: TcxDBPivotGridField
      AreaIndex = 30
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076'. '#1074' '#1074#1072#1083'. '#1073#1077#1079' '#1074#1086#1079#1074#1088'.'
      DataBinding.FieldName = 'Sale_Summ_curr'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076'. '#1074' '#1074#1072#1083'. '
    end
    object pvSale_Summ: TcxDBPivotGridField
      Area = faData
      AreaIndex = 38
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076'. '#1074' '#1043#1056#1053' '#1073#1077#1079' '#1074#1086#1079#1074#1088'.'
      DataBinding.FieldName = 'Sale_Summ'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = 'AmountKreditStart'
    end
    object pvSale_SummCost_curr: TcxDBPivotGridField
      AreaIndex = 34
      IsCaptionAssigned = True
      Caption = #1057'\'#1089' '#1074' '#1074#1072#1083'. '#1073#1077#1079' '#1074#1086#1079#1074#1088'.'
      DataBinding.FieldName = 'Sale_SummCost_curr'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = #1057'\'#1089' '#1087#1088#1086#1076'. '#1074' '#1074#1072#1083'.'
    end
    object pvSale_SummCost: TcxDBPivotGridField
      Area = faData
      AreaIndex = 39
      IsCaptionAssigned = True
      Caption = #1057'\'#1089' '#1074' '#1043#1056#1053' '#1073#1077#1079' '#1074#1086#1079#1074#1088'.'
      DataBinding.FieldName = 'Sale_SummCost'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = #1055#1072#1089#1089#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvSale_Summ_10200_curr: TcxDBPivotGridField
      AreaIndex = 31
      IsCaptionAssigned = True
      Caption = #1057#1082#1080#1076#1082#1072' '#1074' '#1074#1072#1083'. '#1073#1077#1079' '#1074#1086#1079#1074#1088'.'
      DataBinding.FieldName = 'Sale_Summ_10200_curr'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = #1057#1082#1080#1076#1082#1072' '#1048#1058#1054#1043#1054' '#1074' '#1074#1072#1083'.'
    end
    object pvSale_Summ_10200: TcxDBPivotGridField
      Area = faData
      AreaIndex = 43
      IsCaptionAssigned = True
      Caption = #1057#1082#1080#1076#1082#1072' '#1074' '#1043#1056#1053' '#1073#1077#1079' '#1074#1086#1079#1074#1088'.'
      DataBinding.FieldName = 'Sale_Summ_10200'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = #1055#1072#1089#1089#1080#1074#1099' '#1085#1072' '#1082#1086#1085#1077#1094
    end
    object pvSale_Summ_10100: TcxDBPivotGridField
      Area = faData
      AreaIndex = 40
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076'. '#1073#1077#1079' '#1089#1082#1080#1076'. '#1074' '#1043#1056#1053
      DataBinding.FieldName = 'Sale_Summ_10100'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = #1044#1077#1073#1077#1090' '#1086#1073#1086#1088#1086#1090
    end
    object pvSale_Summ_10201: TcxDBPivotGridField
      Area = faData
      AreaIndex = 41
      IsCaptionAssigned = True
      Caption = #1057#1077#1079#1086#1085#1085#1072#1103' '#1089#1082#1080#1076#1082#1072
      DataBinding.FieldName = 'Sale_Summ_10201'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = #1050#1088#1077#1076#1080#1090' '#1086#1073#1086#1088#1086#1090
    end
    object pvSale_Summ_10202: TcxDBPivotGridField
      Area = faData
      AreaIndex = 49
      IsCaptionAssigned = True
      Caption = #1057#1082#1080#1076#1082#1072' outlet'
      DataBinding.FieldName = 'Sale_Summ_10202'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = 'AmountDebetEnd'
    end
    object pvSale_Summ_10203: TcxDBPivotGridField
      Area = faData
      AreaIndex = 50
      IsCaptionAssigned = True
      Caption = #1057#1082#1080#1076#1082#1072' '#1082#1083#1080#1077#1085#1090#1072
      DataBinding.FieldName = 'Sale_Summ_10203'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = 'AmountKreditEnd'
    end
    object pvSale_Summ_10204: TcxDBPivotGridField
      Area = faData
      AreaIndex = 42
      IsCaptionAssigned = True
      Caption = #1057#1082#1080#1076#1082#1072' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103
      DataBinding.FieldName = 'Sale_Summ_10204'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxHeaderStyle
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1082#1086#1085#1077#1094
    end
    object pvReturn_Amount: TcxDBPivotGridField
      Area = faData
      AreaIndex = 37
      IsCaptionAssigned = True
      Caption = #1042#1086#1079#1074#1088'. '#1082#1086#1083'. '
      DataBinding.FieldName = 'Return_Amount'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      UniqueName = #1055#1072#1089#1089#1080#1074#1099' '#1085#1072' '#1082#1086#1085#1077#1094
    end
    object pvReturn_Summ_curr: TcxDBPivotGridField
      AreaIndex = 32
      IsCaptionAssigned = True
      Caption = #1042#1086#1079#1074#1088'. '#1074' '#1074#1072#1083'.'
      DataBinding.FieldName = 'Return_Summ_curr'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      UniqueName = #1057#1091#1084#1084#1072' '#1074#1086#1079#1074#1088'. '#1074' '#1074#1072#1083'.'
    end
    object pvReturn_Summ: TcxDBPivotGridField
      Area = faData
      AreaIndex = 44
      IsCaptionAssigned = True
      Caption = #1042#1086#1079#1074#1088'. '#1074' '#1043#1056#1053
      DataBinding.FieldName = 'Return_Summ'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      UniqueName = #1055#1072#1089#1089#1080#1074#1099' '#1085#1072' '#1082#1086#1085#1077#1094
    end
    object pvReturn_SummCost_curr: TcxDBPivotGridField
      AreaIndex = 35
      IsCaptionAssigned = True
      Caption = #1057'\'#1089' '#1074#1086#1079#1074#1088'. '#1074' '#1074#1072#1083'.'
      DataBinding.FieldName = 'Return_SummCost_curr'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      UniqueName = #1057'\'#1089' '#1074#1086#1079#1074#1088'. '#1074' '#1074#1072#1083'.'
    end
    object pvReturn_SummCost: TcxDBPivotGridField
      Area = faData
      AreaIndex = 45
      IsCaptionAssigned = True
      Caption = #1057'\'#1089' '#1074#1086#1079#1074#1088'. '#1074' '#1043#1056#1053
      DataBinding.FieldName = 'Return_SummCost'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      UniqueName = #1055#1072#1089#1089#1080#1074#1099' '#1085#1072' '#1082#1086#1085#1077#1094
    end
    object pvReturn_Summ_10200_curr: TcxDBPivotGridField
      AreaIndex = 33
      IsCaptionAssigned = True
      Caption = #1057#1082#1080#1076#1082#1072' '#1074#1086#1079#1074#1088'. '#1074' '#1074#1072#1083'.'
      DataBinding.FieldName = 'Return_Summ_10200_curr'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      UniqueName = #1057#1082#1080#1076#1082#1072' '#1074#1086#1079#1074#1088'. '#1074' '#1074#1072#1083'.'
    end
    object pvReturn_Summ_10200: TcxDBPivotGridField
      Area = faData
      AreaIndex = 46
      IsCaptionAssigned = True
      Caption = #1057#1082#1080#1076#1082#1072' '#1074#1086#1079#1074#1088'. '#1074' '#1043#1056#1053
      DataBinding.FieldName = 'Return_Summ_10200'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      UniqueName = #1055#1072#1089#1089#1080#1074#1099' '#1085#1072' '#1082#1086#1085#1077#1094
    end
    object pvResult_SummCost_diff: TcxDBPivotGridField
      AreaIndex = 19
      IsCaptionAssigned = True
      Caption = #1050#1091#1088#1089'. '#1088#1072#1079#1085'. '#1048#1090#1086#1075
      DataBinding.FieldName = 'Result_SummCost_diff'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      UniqueName = #1050#1091#1088#1089'. '#1088#1072#1079#1085'. '#1048#1090#1086#1075
    end
    object pvSale_SummCost_diff: TcxDBPivotGridField
      AreaIndex = 17
      IsCaptionAssigned = True
      Caption = #1050#1091#1088#1089'. '#1088#1072#1079#1085'. '#1087#1088#1086#1076#1072#1078#1072
      DataBinding.FieldName = 'Sale_SummCost_diff'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      UniqueName = #1050#1091#1088#1089'. '#1088#1072#1079#1085'. '#1087#1088#1086#1076#1072#1078#1072
    end
    object pvReturn_SummCost_diff: TcxDBPivotGridField
      AreaIndex = 18
      IsCaptionAssigned = True
      Caption = #1050#1091#1088#1089'. '#1088#1072#1079#1085'. '#1074#1086#1079#1074#1088#1072#1090
      DataBinding.FieldName = 'Return_SummCost_diff'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      UniqueName = #1050#1091#1088#1089'. '#1088#1072#1079#1085'. '#1074#1086#1079#1074#1088#1072#1090
    end
    object pvPeriodName_doc: TcxDBPivotGridField
      AreaIndex = 14
      IsCaptionAssigned = True
      Caption = #1044#1072#1090#1072' ('#1087#1088#1086#1076'.)'
      DataBinding.FieldName = 'PeriodName_doc'
      UniqueName = #1044#1072#1090#1072' ('#1087#1088#1086#1076'.)'
    end
    object pvPeriodYear_doc: TcxDBPivotGridField
      AreaIndex = 15
      IsCaptionAssigned = True
      Caption = #1043#1086#1076' ('#1087#1088#1086#1076'.)'
      DataBinding.FieldName = 'PeriodYear_doc'
      UniqueName = #1043#1086#1076' ('#1087#1088#1086#1076'.)'
    end
    object pvDayName_doc: TcxDBPivotGridField
      AreaIndex = 16
      IsCaptionAssigned = True
      Caption = #1044#1077#1085#1100' ('#1087#1088#1086#1076'.)'
      DataBinding.FieldName = 'DayName_doc'
      UniqueName = #1044#1077#1085#1100' ('#1087#1088#1086#1076'.)'
    end
    object pvTax_Amount: TcxDBPivotGridField
      Area = faData
      AreaIndex = 8
      IsCaptionAssigned = True
      Caption = '% '#1055#1088#1086#1076'.*'
      DataBinding.FieldName = 'Tax_Amount'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxSelection
      Width = 55
      UniqueName = '% '#1050#1086#1083'-'#1074#1086
    end
    object pvTax_Summ_prof: TcxDBPivotGridField
      Area = faData
      AreaIndex = 4
      IsCaptionAssigned = True
      Caption = '% '#1056#1077#1085#1090'.*'
      DataBinding.FieldName = 'Tax_Summ_prof'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxSelection
      Width = 50
      UniqueName = '% '#1056#1077#1085#1090'.'
    end
    object pvTax_Amount_real: TcxDBPivotGridField
      AreaIndex = 39
      IsCaptionAssigned = True
      Caption = '% '#1055#1088#1086#1076'. -'#1044'.*'
      DataBinding.FieldName = 'Tax_Amount_real'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Width = 50
      UniqueName = '% '#1055#1088#1086#1076'. -'#1044'.'
    end
    object pvTax_Summ_curr: TcxDBPivotGridField
      AreaIndex = 27
      IsCaptionAssigned = True
      Caption = '% '#1055#1088#1086#1076'. '#1074#1072#1083'. -'#1044'.*'
      DataBinding.FieldName = 'Tax_Summ_curr'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxSelection
      Width = 68
      UniqueName = '% '#1057#1091#1084#1084#1072' '#1074#1093'.'
    end
    object pvTax_Amount_calc: TcxDBPivotGridField
      Area = faData
      AreaIndex = 7
      IsCaptionAssigned = True
      Caption = '% '#1055#1088#1086#1076'.'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxSelection
      Width = 45
      UniqueName = '% '#1055#1088#1086#1076'.'
    end
    object pvTax_Amount_calc1: TcxDBPivotGridField
      Area = faData
      AreaIndex = 51
      AllowedAreas = []
      IsCaptionAssigned = True
      Caption = 'A1'
      DataBinding.FieldName = 'Tax_Amount_calc1'
      UniqueName = 'Tax_Amount_calc1'
    end
    object pvTax_Amount_calc2: TcxDBPivotGridField
      Area = faData
      AreaIndex = 52
      AllowedAreas = []
      IsCaptionAssigned = True
      Caption = 'A2'
      DataBinding.FieldName = 'Tax_Amount_calc2'
      UniqueName = 'Tax_Amount_calc2'
    end
    object pvTax_Summ_prof_calc: TcxDBPivotGridField
      Area = faData
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = '% '#1056#1077#1085#1090'.'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Styles.ColumnHeader = dmMain.cxSelection
      Width = 50
      UniqueName = '% '#1056#1077#1085#1090'.'
    end
    object pvTax_Summ_prof_calc1: TcxDBPivotGridField
      Area = faData
      AreaIndex = 53
      AllowedAreas = []
      IsCaptionAssigned = True
      Caption = #1056'1'
      DataBinding.FieldName = 'Tax_Summ_prof_calc1'
      UniqueName = #1056'1'
    end
    object pvTax_Summ_prof_calc2: TcxDBPivotGridField
      Area = faData
      AreaIndex = 54
      AllowedAreas = []
      IsCaptionAssigned = True
      Caption = #1056'2'
      DataBinding.FieldName = 'Tax_Summ_prof_calc2'
      UniqueName = #1056'2'
    end
    object pvTax_Amount_real_calc: TcxDBPivotGridField
      Area = faData
      AreaIndex = 55
      IsCaptionAssigned = True
      Caption = '% '#1055#1088#1086#1076'. -'#1044'.'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Width = 50
      UniqueName = '% '#1055#1088#1086#1076'. -'#1044'.'
    end
    object pvTax_Amount_real_calc1: TcxDBPivotGridField
      Area = faData
      AreaIndex = 57
      AllowedAreas = []
      IsCaptionAssigned = True
      Caption = 'AR1'
      DataBinding.FieldName = 'Tax_Amount_real_calc1'
      UniqueName = 'AR1'
    end
    object pvTax_Amount_real_calc2: TcxDBPivotGridField
      Area = faData
      AreaIndex = 58
      AllowedAreas = []
      IsCaptionAssigned = True
      Caption = 'AR2'
      DataBinding.FieldName = 'Tax_Amount_real_calc2'
      UniqueName = 'AR2'
    end
    object pvTax_Summ_curr_calc: TcxDBPivotGridField
      Area = faData
      AreaIndex = 56
      IsCaptionAssigned = True
      Caption = '% '#1055#1088#1086#1076'. '#1074#1072#1083'. -'#1044'.'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.;-,0.; ;'
      Width = 68
      UniqueName = '% '#1055#1088#1086#1076'. '#1074#1072#1083'. -'#1044'.'
    end
    object pvTax_Summ_curr_calc1: TcxDBPivotGridField
      Area = faData
      AreaIndex = 59
      AllowedAreas = []
      IsCaptionAssigned = True
      Caption = 'S1'
      DataBinding.FieldName = 'Tax_Summ_curr_calc1'
      UniqueName = 'S1'
    end
    object pvTax_Summ_curr_calc2: TcxDBPivotGridField
      Area = faData
      AreaIndex = 60
      AllowedAreas = []
      IsCaptionAssigned = True
      Caption = 'S2'
      DataBinding.FieldName = 'Tax_Summ_curr_calc2'
      UniqueName = 'S2'
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
    Left = 64
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
        Component = GuidesBrand
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesEndYear
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
        Component = GuidesStartYear
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesUnit
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
    Left = 32
    Top = 264
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_ReportGoods_Params
      StoredProcList = <
        item
          StoredProc = spGet_ReportGoods_Params
        end
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
      FormName = 'TReport_MotionOLAPDialogForm'
      FormNameParam.Value = 'TReport_MotionOLAPDialogForm'
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
          Name = 'UnitId'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
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
          Value = '0'
          Component = GuidesStartYear
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartYearText'
          Value = Null
          Component = GuidesStartYear
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndYear'
          Value = ''
          Component = GuidesEndYear
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndYearText'
          Value = Null
          Component = GuidesEndYear
          ComponentItem = 'TextValue'
          DataType = ftString
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
        end
        item
          Name = 'isDiscount'
          Value = Null
          Component = cbDiscount
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isMark'
          Value = Null
          Component = cbMark
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsCode'
          Value = Null
          Component = edGoodsCode2
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actRefreshCode: TdsdDataSetRefresh
      Category = 'DSDLib'
      ActiveControl = edGoodsCode2
      MoveParams = <>
      StoredProc = spGet_ReportGoods_Params
      StoredProcList = <
        item
          StoredProc = spGet_ReportGoods_Params
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 13
      RefreshOnTabSetChanges = False
    end
    object actRefreshChoice: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_ReportGoods_Params1
      StoredProcList = <
        item
          StoredProc = spGet_ReportGoods_Params1
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
  object spReport: TdsdStoredProc
    StoredProcName = 'gpReport_MotionOLAP'
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
        Component = GuidesUnit
        ComponentItem = 'Key'
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
        Name = 'inGoodsId'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartYear'
        Value = Null
        Component = GuidesStartYear
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndYear'
        Value = Null
        Component = GuidesEndYear
        ComponentItem = 'Key'
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
      end
      item
        Name = 'inIsDiscount'
        Value = Null
        Component = cbDiscount
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsMark'
        Value = Null
        Component = cbMark
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 208
    Top = 288
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 520
    Top = 200
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
        Component = cbPeriodAll
      end
      item
        Component = GuidesUnit
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
        Component = GuidesStartYear
      end
      item
        Component = GuidesEndYear
      end
      item
        Component = cbYear
      end
      item
        Component = cbDiscount
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
        Component = cbOperPrice
      end
      item
        Component = cbOperDate_doc
      end
      item
        Component = cbDay_doc
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
    Left = 352
    Top = 24
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
    Left = 606
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
    Left = 638
    Top = 26
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
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
    Left = 457
    Top = 65529
  end
  object GuidesStartYear: TdsdGuides
    KeyField = 'Id'
    LookupControl = edStartYear
    Key = '0'
    FormNameParam.Value = 'TPeriodYear_ChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPeriodYear_ChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesStartYear
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesStartYear
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 682
    Top = 65529
  end
  object GuidesEndYear: TdsdGuides
    KeyField = 'Id'
    LookupControl = edEndYear
    Key = '0'
    FormNameParam.Value = 'TPeriodYear_ChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPeriodYear_ChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesEndYear
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesEndYear
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 885
    Top = 65523
  end
  object cfTax_Amount: TdsdPivotGridCalcFields
    PivotGrid = cxDBPivotGrid
    CalcField = pvTax_Amount_calc
    GridFields = <
      item
        Field = pvTax_Amount_calc1
      end
      item
        Field = pvTax_Amount_calc2
      end>
    CalcFieldsType = cfPercent
    Left = 656
    Top = 208
  end
  object cfTax_Summ_prof_calc: TdsdPivotGridCalcFields
    PivotGrid = cxDBPivotGrid
    CalcField = pvTax_Summ_prof_calc
    GridFields = <
      item
        Field = pvTax_Summ_prof_calc1
      end
      item
        Field = pvTax_Summ_prof_calc2
      end>
    CalcFieldsType = cfPercent
    Left = 656
    Top = 256
  end
  object cfTax_Amount_real_calc: TdsdPivotGridCalcFields
    PivotGrid = cxDBPivotGrid
    CalcField = pvTax_Amount_real_calc
    GridFields = <
      item
        Field = pvTax_Amount_real_calc1
      end
      item
        Field = pvTax_Amount_real_calc2
      end>
    CalcFieldsType = cfPercent
    Left = 656
    Top = 304
  end
  object cfTax_Summ_curr_calc: TdsdPivotGridCalcFields
    PivotGrid = cxDBPivotGrid
    CalcField = pvTax_Summ_curr_calc
    GridFields = <
      item
        Field = pvTax_Summ_curr_calc1
      end
      item
        Field = pvTax_Summ_curr_calc2
      end>
    CalcFieldsType = cfPercent
    Left = 656
    Top = 360
  end
  object GuidesPartionGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsCodeChoice
    FormNameParam.Value = 'TPartionGoodsChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartionGoodsChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Code'
        Value = ''
        Component = GuidesPartionGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = ''
        Component = GuidesPartionGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberAll'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionId'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitName'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsSizeId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsSizeName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = Null
        Component = edGoodsCode2
        MultiSelectSeparator = ','
      end>
    Left = 816
    Top = 35
  end
  object RefreshDispatcher1: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefreshChoice
    ComponentList = <
      item
        Component = GuidesPartionGoods
      end>
    Left = 808
    Top = 248
  end
  object spGet_ReportGoods_Params1: TdsdStoredProc
    StoredProcName = 'gpGet_GoodsId_byCode'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioGoodsCode'
        Value = ''
        Component = GuidesPartionGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioGoodsCode'
        Value = 0.000000000000000000
        Component = edGoodsCode2
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsId'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsId'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 816
    Top = 305
  end
  object spGet_ReportGoods_Params: TdsdStoredProc
    StoredProcName = 'gpGet_GoodsId_byCode'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioGoodsCode'
        Value = 0.000000000000000000
        Component = edGoodsCode2
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsId'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsId'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 808
    Top = 353
  end
end
