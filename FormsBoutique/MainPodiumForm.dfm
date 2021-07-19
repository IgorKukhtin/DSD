inherited MainForm: TMainForm
  Caption = 'Podium'
  ClientHeight = 168
  ClientWidth = 723
  KeyPreview = True
  ExplicitWidth = 739
  ExplicitHeight = 226
  PixelsPerInch = 96
  TextHeight = 13
  inherited ActionList: TActionList
    Left = 336
    Top = 8
    object actCashJournal: TdsdOpenForm [0]
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
      Hint = #1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
      FormName = 'TCashJournalForm'
      FormNameParam.Value = 'TCashJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_ProfitDemoPeriod: TdsdOpenForm [1]
      Category = #1054#1090#1095#1077#1090#1099' ('#1059#1055')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1086' '#1055#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1059#1073#1099#1090#1082#1072#1093' ('#1089#1088#1072#1074#1085#1077#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1086#1074') ('#1044#1077#1084#1086'-'#1074#1077#1088#1089#1080#1103')'
      FormName = 'TReport_ProfitDemoPeriodForm'
      FormNameParam.Value = 'TReport_ProfitDemoPeriodForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsAccountPodium: TdsdOpenForm [2]
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1056#1072#1089#1095#1077#1090#1099' '#1079#1072' '#1055#1088#1086#1076#1072#1078#1091' ('#1074#1089#1077')'
      Hint = #1056#1072#1089#1095#1077#1090#1099' '#1089' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1077#1084' '#1079#1072' '#1055#1088#1086#1076#1072#1078#1091' ('#1078#1091#1088#1085#1072#1083')'
      FormName = 'TGoodsAccountPodiumJournalForm'
      FormNameParam.Value = 'TGoodsAccountPodiumJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_SaleOLAP_Analysis: TdsdOpenForm [3]
      Category = #1054#1090#1095#1077#1090#1099' ('#1059#1055')'
      MoveParams = <>
      Caption = #1040#1085#1072#1083#1080#1079' '#1087#1088#1086#1076#1072#1078
      FormName = 'TReport_SaleOLAP_AnalysisForm'
      FormNameParam.Value = 'TReport_SaleOLAP_AnalysisForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPriceListItem_Currency: TdsdOpenForm [4]
      Category = #1048#1089#1090#1086#1088#1080#1080
      MoveParams = <>
      Caption = #1048#1089#1090#1086#1088#1080#1103' '#1094#1077#1085' '#1090#1086#1074#1072#1088#1086#1074' ('#1080#1079#1084'. '#1074#1072#1083#1102#1090#1099')'
      Hint = #1048#1089#1090#1086#1088#1080#1103' '#1094#1077#1085' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TPriceListItem_CurrencyForm'
      FormNameParam.Value = 'TPriceListItem_CurrencyForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Sale_AnalysisAll: TdsdOpenForm [5]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1040#1085#1072#1083#1080#1090#1080#1082#1072' '#1082#1083#1102#1095#1077#1074#1099#1093' '#1087#1086#1082#1072#1079#1072#1090#1077#1083#1077#1081' ('#1042#1057#1045')'
      FormName = 'TReport_Sale_AnalysisAllForm'
      FormNameParam.Value = 'TReport_Sale_AnalysisAllForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReturnInPodium: TdsdOpenForm [6]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103' ('#1074#1089#1077')'
      Hint = #1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103' ('#1078#1091#1088#1085#1072#1083')'
      FormName = 'TReturnInPodiumJournalForm'
      FormNameParam.Value = 'TReturnInPodiumJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_MotionOLAP: TdsdOpenForm [7]
      Category = #1054#1090#1095#1077#1090#1099' ('#1059#1055')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1076#1074#1080#1078#1077#1085#1080#1102' ('#1054#1051#1040#1055')'
      FormName = 'TReport_MotionOLAPForm'
      FormNameParam.Value = 'TReport_MotionOLAPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_ProfitLossPeriod: TdsdOpenForm [8]
      Category = #1054#1090#1095#1077#1090#1099' ('#1059#1055')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1086' '#1055#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1059#1073#1099#1090#1082#1072#1093' ('#1089#1088#1072#1074#1085#1077#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1086#1074')'
      FormName = 'TReport_ProfitLossPeriodForm'
      FormNameParam.Value = 'TReport_ProfitLossPeriodForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_ProfitDemo: TdsdOpenForm [9]
      Category = #1054#1090#1095#1077#1090#1099' ('#1059#1055')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1086' '#1055#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1059#1073#1099#1090#1082#1072#1093' ('#1044#1077#1084#1086'-'#1074#1077#1088#1089#1080#1103')'
      FormName = 'TReport_ProfitDemoForm'
      FormNameParam.Value = 'TReport_ProfitDemoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSmsSettings: TdsdOpenForm [10]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1080' '#1076#1083#1103' '#1057#1052#1057
      FormName = 'TSmsSettingsForm'
      FormNameParam.Value = 'TSmsSettingsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Sale: TdsdOpenForm [11]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102
      FormName = 'TReport_SaleForm'
      FormNameParam.Value = 'TReport_SaleForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_ReturnIn: TdsdOpenForm [12]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
      FormName = 'TReport_ReturnInForm'
      FormNameParam.Value = 'TReport_ReturnInForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Goods_RemainsCurrent_onDate: TdsdOpenForm [13]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1089#1090#1072#1090#1082#1080' '#1090#1086#1074#1072#1088#1072' '#1085#1072' '#1076#1072#1090#1091
      FormName = 'TReport_Goods_RemainsCurrent_onDateForm'
      FormNameParam.Value = 'TReport_Goods_RemainsCurrent_onDateForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Sale_Analysis: TdsdOpenForm [14]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1040#1085#1072#1083#1080#1090#1080#1082#1072' '#1082#1083#1102#1095#1077#1074#1099#1093' '#1087#1086#1082#1072#1079#1072#1090#1077#1083#1077#1081
      FormName = 'TReport_Sale_AnalysisForm'
      FormNameParam.Value = 'TReport_Sale_AnalysisForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_OH_DiscountPeriod: TdsdOpenForm [15]
      Category = #1048#1089#1090#1086#1088#1080#1080
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1077#1088#1080#1086#1076#1099' '#1089#1077#1079#1086#1085#1085#1099#1093' '#1089#1082#1080#1076#1086#1082'>'
      FormName = 'TReport_OH_DiscountPeriodForm'
      FormNameParam.Value = 'TReport_OH_DiscountPeriodForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProfitLossDemo: TdsdOpenForm [16]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080'\'#1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = 'M'#1086#1076#1077#1083#1100' '#1086#1090#1095#1077#1090#1072' '#1076#1083#1103' '#1076#1077#1084#1086'-'#1074#1077#1088#1089#1080#1080
      FormName = 'TProfitLossDemoForm'
      FormNameParam.Value = 'TProfitLossDemoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_SaleOLAP: TdsdOpenForm [17]
      Category = #1054#1090#1095#1077#1090#1099' ('#1059#1055')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' ('#1054#1051#1040#1055')'
      FormName = 'TReport_SaleOLAPForm'
      FormNameParam.Value = 'TReport_SaleOLAPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actIncomeKoeff: TdsdOpenForm [18]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1050#1086#1101#1092#1092'. '#1076#1083#1103' '#1087#1088#1080#1093#1086#1076#1072' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097'.'
      FormName = 'TIncomeKoeffEditForm'
      FormNameParam.Value = 'TIncomeKoeffEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_CollationByClientPodium: TdsdOpenForm [19]
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080
      FormName = 'TReport_CollationByClientPodiumForm'
      FormNameParam.Value = 'TReport_CollationByClientPodiumForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actClientSMS: TdsdOpenForm [20]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1041#1072#1079#1072' '#1082#1083#1080#1077#1085#1090#1086#1074' '#1057#1052#1057
      FormName = 'TClientSMSForm'
      FormNameParam.Value = 'TClientSMSForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsCode: TdsdOpenForm [21]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1044#1074#1080#1078#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1072' ('#1074#1074#1086#1076' '#1050#1086#1076#1072')'
      FormName = 'TReport_GoodsCodeForm'
      FormNameParam.Value = 'TReport_GoodsCodeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Sale_ContainerError: TdsdOpenForm [22]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1044#1086#1083#1075#1086#1074
      FormName = 'TReport_Sale_ContainerErrorForm'
      FormNameParam.Value = 'TReport_Sale_ContainerErrorForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Client_LastError: TdsdOpenForm [23]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1057#1091#1084#1084' '#1087#1086#1089#1083#1077#1076#1085#1077#1081' '#1087#1086#1082#1091#1087#1082#1080' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1077#1081
      FormName = 'TReport_Client_LastErrorForm'
      FormNameParam.Value = 'TReport_Client_LastErrorForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Client_TotalError: TdsdOpenForm [24]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1048#1090#1086#1075#1086#1074#1099#1093' '#1089#1091#1084#1084' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1077#1081
      FormName = 'TReport_Client_TotalErrorForm'
      FormNameParam.Value = 'TReport_Client_TotalErrorForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Sale_TotalError: TdsdOpenForm [25]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1048#1090#1086#1075#1086#1074#1099#1093' '#1057#1091#1084#1084' '#1074' '#1055#1088#1086#1076#1072#1078#1072#1093
      FormName = 'TReport_Sale_TotalErrorForm'
      FormNameParam.Value = 'TReport_Sale_TotalErrorForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_ReturnIn_TotalError: TdsdOpenForm [26]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1057#1091#1084#1084#1099' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1086#1087#1083#1072#1090#1099' '#1074' '#1042#1086#1079#1074#1088#1072#1090#1072#1093
      FormName = 'TReport_ReturnIn_TotalErrorForm'
      FormNameParam.Value = 'TReport_ReturnIn_TotalErrorForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actIncome: TdsdOpenForm [27]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
      Hint = #1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
      FormName = 'TIncomeJournalForm'
      FormNameParam.Value = 'TIncomeJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsTag: TdsdOpenForm [28]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1090#1086#1074#1072#1088#1072
      FormName = 'TGoodsTagForm'
      FormNameParam.Value = 'TGoodsTagForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReturnOut: TdsdOpenForm [29]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
      Hint = #1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
      FormName = 'TReturnOutJournalForm'
      FormNameParam.Value = 'TReturnOutJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsAccountMovement: TdsdOpenForm [30]
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1056#1072#1089#1095#1077#1090#1099
      Hint = #1057#1086#1079#1076#1072#1085#1080#1077' - '#1056#1072#1089#1095#1077#1090#1099' '#1089' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1077#1084' '#1079#1072' '#1055#1088#1086#1076#1072#1078#1091
      FormName = 'TGoodsAccountPodiumForm'
      FormNameParam.Value = 'TGoodsAccountPodiumForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 43101d
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actReport_MotionByClient: TdsdOpenForm [31]
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1044#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102
      FormName = 'TReport_MotionByClientForm'
      FormNameParam.Value = 'TReport_MotionByClientForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_ClientDebtPodium: TdsdOpenForm [32]
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1044#1086#1083#1075#1080' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1077#1081
      FormName = 'TReport_ClientDebtPodiumForm'
      FormNameParam.Value = 'TReport_ClientDebtPodiumForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actDiscountPeriod: TdsdOpenForm [33]
      Category = #1048#1089#1090#1086#1088#1080#1080
      MoveParams = <>
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1055#1077#1088#1080#1086#1076#1099' '#1089#1077#1079#1086#1085#1085#1099#1093' '#1089#1082#1080#1076#1086#1082'>'
      FormName = 'TDiscountPeriodForm'
      FormNameParam.Value = 'TDiscountPeriodForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsAccount: TdsdOpenForm [34]
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1056#1072#1089#1095#1077#1090#1099' '#1079#1072' '#1055#1088#1086#1076#1072#1078#1091' ('#1074#1089#1077')'
      Hint = #1056#1072#1089#1095#1077#1090#1099' '#1089' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1077#1084' '#1079#1072' '#1055#1088#1086#1076#1072#1078#1091' ('#1078#1091#1088#1085#1072#1083')'
      FormName = 'TGoodsAccountJournalForm'
      FormNameParam.Value = 'TGoodsAccountJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsAccount_ReturnIn: TdsdOpenForm [35]
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1056#1072#1089#1095#1077#1090#1099' '#1079#1072' '#1042#1086#1079#1074#1088#1072#1090' ('#1074#1089#1077')'
      Hint = #1056#1072#1089#1095#1077#1090#1099' '#1089' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1077#1084' '#1079#1072' '#1042#1086#1079#1074#1088#1072#1090' ('#1078#1091#1088#1085#1072#1083')'
      FormName = 'TGoodsAccount_ReturnInJournalForm'
      FormNameParam.Value = 'TGoodsAccount_ReturnInJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsMI_AccountPodium: TdsdOpenForm [36]
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1088#1072#1089#1095#1077#1090#1072#1084
      FormName = 'TReport_GoodsMI_AccountPodiumForm'
      FormNameParam.Value = 'TReport_GoodsMI_AccountPodiumForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsAccount_TotalError: TdsdOpenForm [37]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1057#1091#1084#1084#1099' '#1086#1087#1083#1072#1090#1099' '#1074' '#1056#1072#1089#1095#1077#1090#1072#1093' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1077#1081
      FormName = 'TReport_GoodsAccount_TotalErrorForm'
      FormNameParam.Value = 'TReport_GoodsAccount_TotalErrorForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_MovementIncome: TdsdOpenForm [38]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
      Hint = #1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
      FormName = 'TReport_MovementIncomeForm'
      FormNameParam.Value = 'TReport_MovementIncomeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_MovementReturnOut: TdsdOpenForm [39]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
      Hint = #1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
      FormName = 'TReport_MovementReturnOutForm'
      FormNameParam.Value = 'TReport_MovementReturnOutForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_MovementSend: TdsdOpenForm [40]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      Hint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      FormName = 'TReport_MovementSendForm'
      FormNameParam.Value = 'TReport_MovementSendForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Goods: TdsdOpenForm [41]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1044#1074#1080#1078#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
      FormName = 'TReport_GoodsForm'
      FormNameParam.Value = 'TReport_GoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Goods_RemainsCurrentPodium: TdsdOpenForm [42]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1056#1077#1077#1089#1090#1088' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TReport_Goods_RemainsCurrentPodiumForm'
      FormNameParam.Value = 'TReport_Goods_RemainsCurrentPodiumForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsPrint: TdsdOpenForm [43]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' '#1076#1083#1103' '#1087#1077#1095#1072#1090#1080' '#1094#1077#1085#1085#1080#1082#1086#1074
      FormName = 'TGoodsPrintForm'
      FormNameParam.Value = 'TGoodsPrintForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_MovementLoss: TdsdOpenForm [44]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1057#1087#1080#1089#1072#1085#1080#1077
      Hint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      FormName = 'TReport_MovementLossForm'
      FormNameParam.Value = 'TReport_MovementLossForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSalePodium: TdsdOpenForm [45]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' ('#1074#1089#1077')'
      Hint = #1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' ('#1078#1091#1088#1085#1072#1083')'
      FormName = 'TSalePodiumJournalForm'
      FormNameParam.Value = 'TSalePodiumJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actDiscountPeriodItem: TdsdOpenForm [46]
      Category = #1048#1089#1090#1086#1088#1080#1080
      MoveParams = <>
      Caption = #1048#1089#1090#1086#1088#1080#1103' '#1089#1077#1079#1086#1085#1085#1099#1093' '#1089#1082#1080#1076#1086#1082
      Hint = #1048#1089#1090#1086#1088#1080#1103' '#1089#1077#1079#1086#1085#1085#1099#1093' '#1089#1082#1080#1076#1086#1082
      FormName = 'TDiscountPeriodPodiumItemForm'
      FormNameParam.Value = 'TDiscountPeriodPodiumItemForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSale: TdsdOpenForm [47]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' ('#1074#1089#1077')'
      Hint = #1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' ('#1078#1091#1088#1085#1072#1083')'
      FormName = 'TSaleJournalForm'
      FormNameParam.Value = 'TSaleJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSaleMovement: TdsdOpenForm [48]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1086#1076#1072#1078#1072
      Hint = #1057#1086#1079#1076#1072#1085#1080#1077' - '#1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102
      FormName = 'TSalePodiumForm'
      FormNameParam.Value = 'TSalePodiumForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 43101d
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actReturnIn: TdsdOpenForm [49]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103' ('#1074#1089#1077')'
      Hint = #1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103' ('#1078#1091#1088#1085#1072#1083')'
      FormName = 'TReturnInJournalForm'
      FormNameParam.Value = 'TReturnInJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReturnInMovement: TdsdOpenForm [50]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1042#1086#1079#1074#1088#1072#1090
      Hint = #1057#1086#1079#1076#1072#1085#1080#1077' - '#1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
      FormName = 'TReturnInPodiumForm'
      FormNameParam.Value = 'TReturnInPodiumForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 43101d
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actSend: TdsdOpenForm [51]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      Hint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      FormName = 'TSendPodiumJournalForm'
      FormNameParam.Value = 'TSendPodiumJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actInventory: TdsdOpenForm [52]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103
      Hint = #1057#1087#1080#1089#1072#1085#1080#1077
      FormName = 'TInventoryJournalForm'
      FormNameParam.Value = 'TInventoryJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    inherited actExit: TFileExit
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
    end
    object actUser: TdsdOpenForm [57]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080
      FormName = 'TUserForm'
      FormNameParam.Value = 'TUserForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actForms: TdsdOpenForm [61]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1086#1081' '#1089#1080#1089#1090#1077#1084#1086#1081
      Hint = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1086#1081' '#1089#1080#1089#1090#1077#1084#1086#1081
      FormName = 'TFormsForm'
      FormNameParam.Value = 'TFormsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actRole: TdsdOpenForm [62]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1056#1086#1083#1080
      FormName = 'TRoleForm'
      FormNameParam.Value = 'TRoleForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPriceList: TdsdOpenForm [63]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099
      FormName = 'TPriceListForm'
      FormNameParam.Value = 'TPriceListForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    inherited actImportExportLink: TdsdOpenForm
      Enabled = False
    end
    inherited actAccount: TdsdOpenForm [73]
    end
    inherited actProfitLossGroup: TdsdOpenForm [74]
    end
    inherited actProfitLossDirection: TdsdOpenForm [75]
    end
    object actMeasure: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1045#1076#1080#1085#1080#1094#1099' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
      FormName = 'TMeasureForm'
      FormNameParam.Value = 'TMeasureForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actCompositionGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1072' '#1076#1083#1103' '#1089#1086#1089#1090#1072#1074#1072' '#1090#1086#1074#1072#1088#1072
      FormName = 'TCompositionGroupForm'
      FormNameParam.Value = 'TCompositionGroupForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actComposition: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1057#1086#1089#1090#1072#1074' '#1090#1086#1074#1072#1088#1072
      FormName = 'TCompositionForm'
      FormNameParam.Value = 'TCompositionForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actCountryBrand: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1057#1090#1088#1072#1085#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
      FormName = 'TCountryBrandForm'
      FormNameParam.Value = 'TCountryBrandForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actBrand: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
      FormName = 'TBrandForm'
      FormNameParam.Value = 'TBrandForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actFabrika: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1060#1072#1073#1088#1080#1082#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
      FormName = 'TFabrikaForm'
      FormNameParam.Value = 'TFabrikaForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actLineFabrica: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1051#1080#1085#1080#1103' '#1082#1086#1083#1083#1077#1082#1094#1080#1080
      FormName = 'TLineFabricaForm'
      FormNameParam.Value = 'TLineFabricaForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsInfo: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
      FormName = 'TGoodsInfoForm'
      FormNameParam.Value = 'TGoodsInfoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsSize: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1056#1072#1079#1084#1077#1088' '#1090#1086#1074#1072#1088#1072
      FormName = 'TGoodsSizeForm'
      FormNameParam.Value = 'TGoodsSizeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1099' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TGoodsGroupForm'
      FormNameParam.Value = 'TGoodsGroupForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actCurrency: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1042#1072#1083#1102#1090#1072
      FormName = 'TCurrencyForm'
      FormNameParam.Value = 'TCurrencyForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMember: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1060#1080#1079#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      FormName = 'TMemberForm'
      FormNameParam.Value = 'TMemberForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPeriod: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1057#1077#1079#1086#1085
      FormName = 'TPeriodForm'
      FormNameParam.Value = 'TPeriodForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actDiscount: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1053#1072#1079#1074#1072#1085#1080#1103' '#1085#1072#1082#1086#1087#1080#1090#1077#1083#1100#1085#1099#1093' '#1089#1082#1080#1076#1086#1082
      FormName = 'TDiscountForm'
      FormNameParam.Value = 'TDiscountForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actDiscountTools: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1087#1088#1086#1094#1077#1085#1090#1086#1074' '#1087#1086' '#1085#1072#1082#1086#1087#1080#1090#1077#1083#1100#1085#1099#1084' '#1089#1082#1080#1076#1082#1072#1084
      FormName = 'TDiscountToolsForm'
      FormNameParam.Value = 'TDiscountToolsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPartner: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1086'c'#1090#1072#1074#1097#1080#1082#1080
      FormName = 'TPartnerForm'
      FormNameParam.Value = 'TPartnerForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actJuridicalGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1099' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1080#1093' '#1083#1080#1094
      FormName = 'TJuridicalGroupForm'
      FormNameParam.Value = 'TJuridicalGroupForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actJuridical: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      FormName = 'TJuridicalForm'
      FormNameParam.Value = 'TJuridicalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actUnit: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
      FormName = 'TUnitForm'
      FormNameParam.Value = 'TUnitForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actCity: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1053#1072#1089#1077#1083#1077#1085#1085#1099#1081' '#1087#1091#1085#1082#1090
      FormName = 'TCityForm'
      FormNameParam.Value = 'TCityForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actClient: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1080
      FormName = 'TClientForm'
      FormNameParam.Value = 'TClientForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MasterUnitId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterUnitName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actLabel: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1094#1077#1085#1085#1080#1082#1072
      FormName = 'TLabelForm'
      FormNameParam.Value = 'TLabelForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoods: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' '#1089#1087#1080#1089#1086#1082
      FormName = 'TGoodsForm'
      FormNameParam.Value = 'TGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsTree: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099
      FormName = 'TGoodsTreeForm'
      FormNameParam.Value = 'TGoodsTreeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object catGoodsItem: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' '#1089' '#1088#1072#1079#1084#1077#1088#1072#1084#1080
      FormName = 'TGoodsItemForm'
      FormNameParam.Value = 'TGoodsItemForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPartionGoods: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1072#1088#1090#1080#1080' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TPartionGoodsChoiceForm'
      FormNameParam.Value = 'TPartionGoodsChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPosition: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1080
      FormName = 'TPositionForm'
      FormNameParam.Value = 'TPositionForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPersonal: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082#1080
      FormName = 'TPersonalForm'
      FormNameParam.Value = 'TPersonalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actLoss: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1057#1087#1080#1089#1072#1085#1080#1077
      Hint = #1057#1087#1080#1089#1072#1085#1080#1077
      FormName = 'TLossJournalForm'
      FormNameParam.Value = 'TLossJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actCurrencyMovement: TdsdOpenForm
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1050#1091#1088#1089#1086#1074#1072#1103' '#1088#1072#1079#1085#1080#1094#1072
      Hint = #1050#1091#1088#1089#1086#1074#1072#1103' '#1088#1072#1079#1085#1080#1094#1072
      FormName = 'TCurrencyJournalForm'
      FormNameParam.Value = 'TCurrencyJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPriceListItem: TdsdOpenForm
      Category = #1048#1089#1090#1086#1088#1080#1080
      MoveParams = <>
      Caption = #1048#1089#1090#1086#1088#1080#1103' '#1094#1077#1085' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1048#1089#1090#1086#1088#1080#1103' '#1094#1077#1085' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TPriceListItemForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actCash: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1072
      FormName = 'TCashForm'
      FormNameParam.Value = 'TCashForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actBank: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1041#1072#1085#1082
      FormName = 'TBankForm'
      FormNameParam.Value = 'TBankForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actBankAccount: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1077' '#1089#1095#1077#1090#1072
      FormName = 'TBankAccountForm'
      FormNameParam.Value = 'TBankAccountForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Balance: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1059#1055')'
      MoveParams = <>
      Caption = #1041#1072#1083#1072#1085#1089
      FormName = 'TReport_BalanceForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_ProfitLoss: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1059#1055')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1086' '#1055#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1059#1073#1099#1090#1082#1072#1093
      FormName = 'TReport_ProfitLossForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Cash: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1082#1072#1089#1089#1077
      FormName = 'TReport_CashForm'
      FormNameParam.Value = 'TReport_CashForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_SaleReturnInPodium: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' / '#1074#1086#1079#1074#1088#1072#1090#1072#1084
      FormName = 'TReport_SaleReturnInPodiumForm'
      FormNameParam.Value = 'TReport_SaleReturnInPodiumForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 152
    Top = 8
  end
  inherited StoredProc: TdsdStoredProc
    Left = 48
    Top = 8
  end
  inherited ClientDataSet: TClientDataSet
    Left = 48
    Top = 56
  end
  inherited frxXMLExport: TfrxXMLExport
    Left = 152
    Top = 56
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    Left = 48
    Top = 112
  end
  inherited MainMenu: TMainMenu
    Left = 272
    Top = 8
    object miMovement: TMenuItem [0]
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      object miIncome: TMenuItem
        Action = actIncome
      end
      object miReturnOut: TMenuItem
        Action = actReturnOut
      end
      object miSend: TMenuItem
        Action = actSend
      end
      object miLoss: TMenuItem
        Action = actLoss
      end
      object miLine11: TMenuItem
        Caption = '-'
      end
      object miSalePodium: TMenuItem
        Action = actSalePodium
      end
      object miReturnIn: TMenuItem
        Action = actReturnInPodium
      end
      object miLine12: TMenuItem
        Caption = '-'
      end
      object miInventory: TMenuItem
        Action = actInventory
        Hint = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103
      end
    end
    object miFinance: TMenuItem [1]
      Caption = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      object miGoodsAccount: TMenuItem
        Action = actGoodsAccountPodium
      end
      object miGoodsAccount_ReturnIn: TMenuItem
        Action = actGoodsAccount_ReturnIn
      end
      object miLine21: TMenuItem
        Caption = '-'
      end
      object miCurrencyMovement: TMenuItem
        Action = actCurrencyMovement
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object miCashJournal: TMenuItem
        Action = actCashJournal
      end
    end
    object miHistory: TMenuItem [2]
      Caption = #1048#1089#1090#1086#1088#1080#1080
      object miPriceListItem: TMenuItem
        Action = actPriceListItem
      end
      object miPriceListItem_Currency: TMenuItem
        Action = actPriceListItem_Currency
      end
      object miGoodsPrint: TMenuItem
        Action = actGoodsPrint
      end
      object miLine31: TMenuItem
        Caption = '-'
      end
      object miDiscountPeriodItem: TMenuItem
        Action = actDiscountPeriodItem
      end
      object miDiscountPeriod: TMenuItem
        Action = actDiscountPeriod
      end
      object miReport_OH_DiscountPeriod: TMenuItem
        Action = actReport_OH_DiscountPeriod
      end
    end
    object miSaleMovement: TMenuItem [3]
      Action = actSaleMovement
    end
    object miReturnInMovement: TMenuItem [4]
      Action = actReturnInMovement
    end
    object miGoodsAccountMovement: TMenuItem [5]
      Action = actGoodsAccountMovement
    end
    object miReport_Unit: TMenuItem [6]
      Caption = #1054#1090#1095#1077#1090#1099' ('#1084#1072#1075#1072#1079#1080#1085')'
      object miReport_SaleReturnIn: TMenuItem
        Action = actReport_SaleReturnInPodium
      end
      object miReport_GoodsMI_Account: TMenuItem
        Action = actReport_GoodsMI_AccountPodium
      end
      object miLine41: TMenuItem
        Caption = '-'
      end
      object miReport_CollationByPartner: TMenuItem
        Action = actReport_CollationByClientPodium
      end
      object miReport_PartnerDebt: TMenuItem
        Action = actReport_ClientDebtPodium
      end
      object miLine42: TMenuItem
        Caption = '-'
      end
      object miReport_Goods_RemainsCurrent: TMenuItem
        Action = actReport_Goods_RemainsCurrentPodium
      end
      object miClientSMS: TMenuItem
        Action = actClientSMS
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object miReport_Goods_RemainsCurrent_onDate: TMenuItem
        Action = actReport_Goods_RemainsCurrent_onDate
      end
    end
    object miReport: TMenuItem [7]
      Caption = #1054#1090#1095#1077#1090#1099
      object miReport_MovementIncome: TMenuItem
        Action = actReport_MovementIncome
      end
      object miReport_MovementReturnOut: TMenuItem
        Action = actReport_MovementReturnOut
      end
      object miReport_MovementSend: TMenuItem
        Action = actReport_MovementSend
      end
      object miReport_MovementLoss: TMenuItem
        Action = actReport_MovementLoss
      end
      object miReport_Sale: TMenuItem
        Action = actReport_Sale
      end
      object miReport_ReturnIn: TMenuItem
        Action = actReport_ReturnIn
      end
      object miLine51: TMenuItem
        Caption = '-'
      end
      object miReport_GoodsCode: TMenuItem
        Action = actReport_GoodsCode
      end
    end
    object miReport_Finance: TMenuItem [8]
      Caption = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      object miReport_Cash: TMenuItem
        Action = actReport_Cash
      end
      object miLine61: TMenuItem
        Caption = '-'
      end
      object miReport_MotionByPartner: TMenuItem
        Action = actReport_MotionByClient
      end
    end
    object miReport_Basis: TMenuItem [9]
      Caption = #1054#1090#1095#1077#1090#1099' ('#1059#1055')'
      object miReport_Balance: TMenuItem
        Action = actReport_Balance
      end
      object miReport_ProfitLoss: TMenuItem
        Action = actReport_ProfitLoss
      end
      object miReport_ProfitLossPeriod: TMenuItem
        Action = actReport_ProfitLossPeriod
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object miReport_ProfitDemo: TMenuItem
        Action = actReport_ProfitDemo
      end
      object miReport_ProfitDemoPeriod: TMenuItem
        Action = actReport_ProfitDemoPeriod
      end
      object miLine71: TMenuItem
        Caption = '-'
      end
      object miReport_SaleOLAP: TMenuItem
        Action = actReport_SaleOLAP
      end
      object miReport_SaleOLAP_Analysis: TMenuItem
        Action = actReport_SaleOLAP_Analysis
      end
      object miReport_MotionOLAP: TMenuItem
        Action = actReport_MotionOLAP
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object miReport_Sale_Analysis: TMenuItem
        Action = actReport_Sale_Analysis
      end
      object miReport_Sale_AnalysisAll: TMenuItem
        Action = actReport_Sale_AnalysisAll
      end
    end
    inherited miGuide: TMenuItem
      object miGoodsAll: TMenuItem
        Caption = #1058#1086#1074#1072#1088#1099
        object mioodsTree: TMenuItem
          Action = actGoodsTree
        end
        object miGoods: TMenuItem
          Action = actGoods
        end
        object miGoodsSize: TMenuItem
          Action = actGoodsSize
        end
        object miMeasure: TMenuItem
          Action = actMeasure
        end
        object miGoodsItem: TMenuItem
          Action = catGoodsItem
        end
        object miPartionGoods: TMenuItem
          Action = actPartionGoods
        end
        object miLine711: TMenuItem
          Caption = '-'
        end
        object miCompositionGroup: TMenuItem
          Action = actCompositionGroup
        end
        object miComposition: TMenuItem
          Action = actComposition
        end
        object miGoodsInfo: TMenuItem
          Action = actGoodsInfo
        end
        object miLineFabrica: TMenuItem
          Action = actLineFabrica
        end
        object miLabel: TMenuItem
          Action = actLabel
        end
      end
      object miGoodsGroup: TMenuItem
        Action = actGoodsGroup
      end
      object miGoodsTag: TMenuItem
        Action = actGoodsTag
      end
      object miUnit: TMenuItem
        Action = actUnit
      end
      object miJuridical: TMenuItem
        Action = actJuridical
      end
      object miJuridicalGroup: TMenuItem
        Action = actJuridicalGroup
      end
      object miPriceList: TMenuItem
        Action = actPriceList
      end
      object miLine81: TMenuItem
        Caption = '-'
      end
      object miPartner: TMenuItem
        Action = actPartner
      end
      object miPeriod: TMenuItem
        Action = actPeriod
      end
      object miBrand: TMenuItem
        Action = actBrand
      end
      object miCountryBrand: TMenuItem
        Action = actCountryBrand
      end
      object miFabrika: TMenuItem
        Action = actFabrika
      end
      object miLine82: TMenuItem
        Caption = '-'
      end
      object miClient: TMenuItem
        Action = actClient
      end
      object miCity: TMenuItem
        Action = actCity
      end
      object miDiscount: TMenuItem
        Action = actDiscount
      end
      object miDiscountTools: TMenuItem
        Action = actDiscountTools
      end
      object miLine83: TMenuItem
        Caption = '-'
      end
      object miCash: TMenuItem
        Action = actCash
      end
      object miBankAccount: TMenuItem
        Action = actBankAccount
      end
      object miBank: TMenuItem
        Action = actBank
      end
      object miCurrency: TMenuItem
        Action = actCurrency
      end
      object miLine84: TMenuItem
        Caption = '-'
      end
      object miPersonal: TMenuItem
        Action = actPersonal
      end
      object miPosition: TMenuItem
        Action = actPosition
      end
      object miMember: TMenuItem
        Action = actMember
      end
    end
    inherited miService: TMenuItem
      inherited miServiceGuide: TMenuItem
        object miForms: TMenuItem [0]
          Action = actForms
        end
        object N8: TMenuItem
          Caption = '-'
        end
        object miSmsSettings: TMenuItem
          Action = actSmsSettings
        end
      end
      object miUser: TMenuItem [1]
        Action = actUser
      end
      object miRole: TMenuItem [2]
        Action = actRole
      end
      inherited miLine802: TMenuItem [3]
      end
      object miGuide_Basis: TMenuItem [4]
        Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
        object miAccountGroup: TMenuItem
          Action = actAccountGroup
        end
        object miAccountDirection: TMenuItem
          Action = actAccountDirection
        end
        object miAccount: TMenuItem
          Action = actAccount
        end
        object miLine8001: TMenuItem
          Caption = '-'
        end
        object miInfoMoneyGroup: TMenuItem
          Action = actInfoMoneyGroup
        end
        object miInfoMoneyDestination: TMenuItem
          Action = actInfoMoneyDestination
        end
        object miInfoMoney: TMenuItem
          Action = actInfoMoney
        end
        object miLine8002: TMenuItem
          Caption = '-'
        end
        object miProfitLossGroup: TMenuItem
          Action = actProfitLossGroup
        end
        object miProfitLossDirection: TMenuItem
          Action = actProfitLossDirection
        end
        object miProfitLoss: TMenuItem
          Action = actProfitLoss
        end
        object miProfitLossDemo: TMenuItem
          Action = actProfitLossDemo
        end
      end
      object N1: TMenuItem [5]
        Caption = '-'
      end
      object miTotalError: TMenuItem [6]
        Caption = #1055#1088#1086#1074#1077#1088#1082#1072
        object miGoodsAccount_TotalError: TMenuItem
          Action = actReport_GoodsAccount_TotalError
        end
        object miReturnIn_TotalError: TMenuItem
          Action = actReport_ReturnIn_TotalError
        end
        object miSale_TotalError: TMenuItem
          Action = actReport_Sale_TotalError
        end
        object miObject_Client_TotalError: TMenuItem
          Action = actReport_Client_TotalError
        end
        object miObject_Client_LastError: TMenuItem
          Action = actReport_Client_LastError
        end
        object miReport_Sale_ContainerError: TMenuItem
          Action = actReport_Sale_ContainerError
        end
      end
      inherited miLine801: TMenuItem [7]
      end
      object miIncomeKoeff: TMenuItem [8]
        Action = actIncomeKoeff
      end
      object N2: TMenuItem [9]
        Caption = '-'
      end
      object miImportType: TMenuItem [10]
        Action = actImportType
      end
      object miImportSettings: TMenuItem [11]
        Action = actImportSettings
      end
      object N10: TMenuItem [12]
        Caption = '-'
      end
      inherited miProtocolAll: TMenuItem [13]
        inherited miProtocol: TMenuItem
          Visible = False
        end
        inherited miMovementProtocol: TMenuItem
          Visible = False
        end
      end
    end
  end
  inherited frxXLSExport: TfrxXLSExport
    Left = 152
    Top = 112
  end
end
