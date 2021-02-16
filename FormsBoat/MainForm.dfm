inherited MainForm: TMainForm
  Caption = 'ProjectBoat'
  ClientHeight = 168
  ClientWidth = 805
  KeyPreview = True
  ExplicitWidth = 821
  ExplicitHeight = 226
  PixelsPerInch = 96
  TextHeight = 13
  inherited ActionList: TActionList
    Left = 336
    Top = 8
    object actInvoiceJournal: TdsdOpenForm [0]
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1057#1095#1077#1090#1072
      FormName = 'TInvoiceJournalForm'
      FormNameParam.Value = 'TInvoiceJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReceiptService: TdsdOpenForm [1]
      Category = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1056#1072#1073#1086#1090#1099'/'#1059#1089#1083#1091#1075#1080
      FormName = 'TReceiptServiceForm'
      FormNameParam.Value = 'TReceiptServiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReceiptLevel: TdsdOpenForm [2]
      Category = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1069#1090#1072#1087#1099' '#1089#1073#1086#1088#1082#1080
      FormName = 'TReceiptLevelForm'
      FormNameParam.Value = 'TReceiptLevelForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actModelEtiketen: TdsdOpenForm [3]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1052#1086#1076#1077#1083#1100' '#1087#1077#1095#1072#1090#1080' '#1101#1090#1080#1082#1077#1090#1082#1080
      FormName = 'TModelEtiketenForm'
      FormNameParam.Value = 'TModelEtiketenForm'
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
    object actReceiptGoods: TdsdOpenForm [4]
      Category = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080' '#1059#1079#1083#1086#1074
      FormName = 'TReceiptGoodsForm'
      FormNameParam.Value = 'TReceiptGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProdGroup: TdsdOpenForm [5]
      Category = #1051#1086#1076#1082#1080
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1099
      FormName = 'TGoodsForm'
      FormNameParam.Value = 'TGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actColorPattern: TdsdOpenForm [6]
      Category = #1051#1086#1076#1082#1080
      MoveParams = <>
      Caption = #1064#1072#1073#1083#1086#1085' Boat Structure'
      FormName = 'TColorPatternForm'
      FormNameParam.Value = 'TColorPatternForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actCashJournal: TdsdOpenForm [7]
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
      FormName = 'TCashJournalForm'
      FormNameParam.Value = 'TCashJournalForm'
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
    object actReport_Income: TdsdOpenForm [9]
      Category = #1054#1090#1095#1077#1090#1099' ('#1089#1082#1083#1072#1076')'
      MoveParams = <>
      Caption = #1055#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
      FormName = 'TReport_MovementIncomeForm'
      FormNameParam.Value = 'TReport_MovementIncomeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actTaxKindEdit: TdsdOpenForm [10]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1058#1080#1087#1099' '#1053#1044#1057' ('#1082#1086#1088#1088'.)'
      FormName = 'TTaxKindEditForm'
      FormNameParam.Value = 'TTaxKindEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Sale: TdsdOpenForm [11]
      Category = #1054#1090#1095#1077#1090#1099' ('#1089#1082#1083#1072#1076')'
      MoveParams = <>
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1050#1083#1080#1077#1085#1090#1091
      FormName = 'TReport_SaleForm'
      FormNameParam.Value = 'TReport_SaleForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReceiptProdModel: TdsdOpenForm [12]
      Category = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080' '#1052#1086#1076#1077#1083#1080
      FormName = 'TReceiptProdModelForm'
      FormNameParam.Value = 'TReceiptProdModelForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Send: TdsdOpenForm [13]
      Category = #1054#1090#1095#1077#1090#1099' ('#1089#1082#1083#1072#1076')'
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      FormName = 'TReport_MovementSendForm'
      FormNameParam.Value = 'TReport_MovementSendForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_SaleOLAP: TdsdOpenForm [14]
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
    object actProdColorPattern: TdsdOpenForm [15]
      Category = #1051#1086#1076#1082#1080
      MoveParams = <>
      Caption = #1069#1083#1077#1084#1077#1085#1090#1099' Boat Structure'
      FormName = 'TProdColorPatternForm'
      FormNameParam.Value = 'TProdColorPatternForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPLZ: TdsdOpenForm [16]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1086#1095#1090#1086#1074#1099#1077' '#1072#1076#1088#1077#1089#1072
      FormName = 'TPLZForm'
      FormNameParam.Value = 'TPLZForm'
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
    object actReport_CollationByClient: TdsdOpenForm [17]
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080
      FormName = 'TReport_CollationByClientForm'
      FormNameParam.Value = 'TReport_CollationByClientForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actTranslateMessage: TdsdOpenForm [18]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1074#1086#1076' '#1057#1086#1086#1073#1097#1077#1085#1080#1081
      FormName = 'TTranslateMessageForm'
      FormNameParam.Value = 'TTranslateMessageForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Loss: TdsdOpenForm [19]
      Category = #1054#1090#1095#1077#1090#1099' ('#1089#1082#1083#1072#1076')'
      MoveParams = <>
      Caption = #1057#1087#1080#1089#1072#1085#1080#1077
      FormName = 'TReport_MovementLossForm'
      FormNameParam.Value = 'TReport_MovementLossForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProdOptPattern: TdsdOpenForm [20]
      Category = #1051#1086#1076#1082#1080
      MoveParams = <>
      Caption = #1064#1072#1073#1083#1086#1085' '#1054#1087#1094#1080#1081' ('#1051#1086#1076#1082#1072')'
      FormName = 'TProdOptPatternForm'
      FormNameParam.Value = 'TProdOptPatternForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProdColorKind: TdsdOpenForm [21]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1042#1080#1076#1099' Boat Structure'
      FormName = 'TProdColorKindForm'
      FormNameParam.Value = 'TProdColorKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsCode: TdsdOpenForm [22]
      Category = #1054#1090#1095#1077#1090#1099' ('#1089#1082#1083#1072#1076')'
      MoveParams = <>
      Caption = #1044#1074#1080#1078#1077#1085#1080#1077' ('#1074#1074#1086#1076' '#1040#1088#1090#1080#1082#1091#1083#1072')'
      FormName = 'TReport_GoodsCodeForm'
      FormNameParam.Value = 'TReport_GoodsCodeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Remains_onDate: TdsdOpenForm [23]
      Category = #1054#1090#1095#1077#1090#1099' ('#1089#1082#1083#1072#1076')'
      MoveParams = <>
      Caption = #1054#1089#1090#1072#1090#1082#1080' '#1085#1072' '#1076#1072#1090#1091
      FormName = 'TReport_Goods_RemainsCurrent_onDateForm'
      FormNameParam.Value = 'TReport_Goods_RemainsCurrent_onDateForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_MotionByClient: TdsdOpenForm [24]
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
    object actReport_Account: TdsdOpenForm [25]
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1088#1072#1089#1095#1077#1090#1072#1084
      FormName = 'TReport_GoodsMI_AccountForm'
      FormNameParam.Value = 'TReport_GoodsMI_AccountForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actBrand: TdsdOpenForm [26]
      Category = #1051#1086#1076#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1088#1075#1086#1074#1099#1077' '#1052#1072#1088#1082#1080
      FormName = 'TBrandForm'
      FormNameParam.Value = 'TBrandForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProdModel: TdsdOpenForm [27]
      Category = #1051#1086#1076#1082#1080
      MoveParams = <>
      Caption = #1052#1086#1076#1077#1083#1080
      FormName = 'TProdModelForm'
      FormNameParam.Value = 'TProdModelForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProdEngine: TdsdOpenForm [28]
      Category = #1051#1086#1076#1082#1080
      MoveParams = <>
      Caption = #1052#1086#1090#1086#1088#1099
      FormName = 'TProdEngineForm'
      FormNameParam.Value = 'TProdEngineForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Remains_curr: TdsdOpenForm [29]
      Category = #1054#1090#1095#1077#1090#1099' ('#1089#1082#1083#1072#1076')'
      MoveParams = <>
      Caption = #1054#1089#1090#1072#1090#1082#1080
      FormName = 'TReport_Goods_RemainsCurrentForm'
      FormNameParam.Value = 'TReport_Goods_RemainsCurrentForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actDiscountItem: TdsdOpenForm [30]
      Category = #1048#1089#1090#1086#1088#1080#1080
      MoveParams = <>
      Caption = #1048#1089#1090#1086#1088#1080#1103' '#1089#1082#1080#1076#1086#1082
      FormName = 'TDiscountPeriodItemForm'
      FormNameParam.Value = 'TDiscountPeriodItemForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actIncome: TdsdOpenForm [31]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
      FormName = 'TIncomeJournalForm'
      FormNameParam.Value = 'TIncomeJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSale: TdsdOpenForm [32]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1050#1083#1080#1077#1085#1090#1091
      FormName = 'TSaleJournalForm'
      FormNameParam.Value = 'TSaleJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSend: TdsdOpenForm [33]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      FormName = 'TSendJournalForm'
      FormNameParam.Value = 'TSendJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actLoss: TdsdOpenForm [34]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1057#1087#1080#1089#1072#1085#1080#1077
      FormName = 'TLossJournalForm'
      FormNameParam.Value = 'TLossJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actInventory: TdsdOpenForm [35]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103
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
    object actUser: TdsdOpenForm [40]
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
    object actForms: TdsdOpenForm [44]
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
    object actRole: TdsdOpenForm [45]
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
    object actPriceList: TdsdOpenForm [46]
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
    inherited actAccount: TdsdOpenForm [56]
    end
    inherited actProfitLossGroup: TdsdOpenForm [57]
    end
    inherited actProfitLossDirection: TdsdOpenForm [58]
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
    object actCountry: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1057#1090#1088#1072#1085#1099
      FormName = 'TCountryForm'
      FormNameParam.Value = 'TCountryForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProduct: TdsdOpenForm
      Category = #1051#1086#1076#1082#1080
      MoveParams = <>
      Caption = #1051#1086#1076#1082#1080
      FormName = 'TProductForm'
      FormNameParam.Value = 'TProductForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsSize: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = 'Gr'#246#223'e'
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
    object actPartner: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = 'Lieferanten'
      FormName = 'TPartnerForm'
      FormNameParam.Value = 'TPartnerForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actClient: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = 'Kunden'
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
    object actGoods: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' '#1089#1087#1080#1089#1086#1082
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
      Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
      FormName = 'TGoodsTreeForm'
      FormNameParam.Value = 'TGoodsTreeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPartionGoods: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' '#1055#1072#1088#1090#1080#1080' '
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
    object actCurrencyMovement: TdsdOpenForm
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1050#1091#1088#1089#1086#1074#1072#1103' '#1088#1072#1079#1085#1080#1094#1072
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
      Caption = #1048#1089#1090#1086#1088#1080#1103' '#1094#1077#1085
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
      Caption = #1050#1072#1089#1089#1099
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
      Caption = #1041#1072#1085#1082#1080
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
    object actBankAccountJournal: TdsdOpenForm
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090' '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
      FormName = 'TBankAccountJournalForm'
      FormNameParam.Value = 'TBankAccountJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actOrderPartner: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1047#1072#1082#1072#1079' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1091
      FormName = 'TIncomeJournalForm'
      FormNameParam.Value = 'TIncomeJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actOrderClient: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
      FormName = 'TOrderClientJournalForm'
      FormNameParam.Value = 'TOrderClientJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actOrderProduction: TdsdOpenForm
      Category = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1047#1072#1082#1072#1079' '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      FormName = 'TIncomeJournalForm'
      FormNameParam.Value = 'TIncomeJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProductionUnion: TdsdOpenForm
      Category = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'-'#1082#1086#1084#1087#1083#1077#1082#1090#1072#1094#1080#1103
      FormName = 'TIncomeJournalForm'
      FormNameParam.Value = 'TIncomeJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_ProductionOLAP: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1087#1088'-'#1074#1086')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1091' (OLAP)'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1091' (OLAP)'
      FormName = 'TReport_ProfitLossForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actLanguage: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1071#1079#1099#1082#1080' '#1087#1077#1088#1077#1074#1086#1076#1072
      FormName = 'TLanguageForm'
      FormNameParam.Value = 'TLanguageForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actTranslateWord: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1074#1086#1076' '#1089#1083#1086#1074
      FormName = 'TTranslateWordForm'
      FormNameParam.Value = 'TTranslateWordForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProdColorGroup: TdsdOpenForm
      Category = #1051#1086#1076#1082#1080
      MoveParams = <>
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' Boat Structure'
      FormName = 'TProdColorGroupForm'
      FormNameParam.Value = 'TProdColorGroupForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProdColor: TdsdOpenForm
      Category = #1051#1086#1076#1082#1080
      MoveParams = <>
      Caption = #1062#1074#1077#1090#1072
      FormName = 'TProdColorForm'
      FormNameParam.Value = 'TProdColorForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProdColorItems: TdsdOpenForm
      Category = #1051#1086#1076#1082#1080
      MoveParams = <>
      Caption = 'Boat Structure'
      FormName = 'TProdColorItemsForm'
      FormNameParam.Value = 'TProdColorItemsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProdOptions: TdsdOpenForm
      Category = #1051#1086#1076#1082#1080
      MoveParams = <>
      Caption = #1054#1087#1094#1080#1080
      FormName = 'TProdOptionsForm'
      FormNameParam.Value = 'TProdOptionsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProdOptItems: TdsdOpenForm
      Category = #1051#1086#1076#1082#1080
      MoveParams = <>
      Caption = #1069#1083#1077#1084#1077#1085#1090#1099' '#1054#1087#1094#1080#1081
      FormName = 'TProdOptItemsForm'
      FormNameParam.Value = 'TProdOptItemsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReceipt: TdsdOpenForm
      Category = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1058#1077#1093' '#1082#1072#1088#1090#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072
      FormName = 'TIncomeJournalForm'
      FormNameParam.Value = 'TIncomeJournalForm'
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
      object miSend: TMenuItem
        Action = actSend
        Enabled = False
      end
      object miLine11: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object miOrderPartner: TMenuItem
        Action = actOrderPartner
        Enabled = False
      end
      object miOrderClient: TMenuItem
        Action = actOrderClient
      end
      object miLine12: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object miSale: TMenuItem
        Action = actSale
        Enabled = False
      end
      object miLoss: TMenuItem
        Action = actLoss
        Enabled = False
      end
      object miLine13: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object miInventory: TMenuItem
        Action = actInventory
        Enabled = False
        Hint = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103
      end
    end
    object miProduction: TMenuItem [1]
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      object miOrderProduction: TMenuItem
        Action = actOrderProduction
        Enabled = False
      end
      object miProductionUnion: TMenuItem
        Action = actProductionUnion
        Enabled = False
      end
      object miLine21_: TMenuItem
        Caption = '-'
      end
      object miReceiptProdModel: TMenuItem
        Action = actReceiptProdModel
        Caption = #1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1072' '#1052#1086#1076#1077#1083#1080
      end
      object miLine22_: TMenuItem
        Caption = '-'
      end
      object miReceiptGoods: TMenuItem
        Action = actReceiptGoods
        Caption = #1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1072' '#1059#1079#1083#1086#1074
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object N8: TMenuItem
        Action = actReceiptLevel
      end
      object miReceiptService: TMenuItem
        Action = actReceiptService
      end
    end
    object miBoat: TMenuItem [2]
      Caption = #1051#1086#1076#1082#1080
      object miProdGroup: TMenuItem
        Action = actProdGroup
      end
      object miBrand: TMenuItem
        Action = actBrand
      end
      object miProdModel: TMenuItem
        Action = actProdModel
      end
      object miProdEngine: TMenuItem
        Action = actProdEngine
      end
      object miProduct: TMenuItem
        Action = actProduct
      end
      object miLine31_: TMenuItem
        Caption = '-'
      end
      object miProdColorPattern: TMenuItem
        Action = actProdColorPattern
        Caption = 'Boat Structure'
      end
      object miProdColorGroup: TMenuItem
        Action = actProdColorGroup
      end
      object miColorPattern: TMenuItem
        Action = actColorPattern
      end
      object miProdColor: TMenuItem
        Action = actProdColor
        Caption = 'Farbe'
      end
      object miProdColorItems: TMenuItem
        Action = actProdColorItems
        Caption = #1069#1083#1077#1084#1077#1085#1090#1099' Boat Structure'
      end
      object miLine32_: TMenuItem
        Caption = '-'
      end
      object miProdOptPattern: TMenuItem
        Action = actProdOptPattern
        Caption = #1064#1072#1073#1083#1086#1085#1099' '#1054#1087#1094#1080#1081
      end
      object miProdOptions: TMenuItem
        Action = actProdOptions
      end
      object miProdOptItems: TMenuItem
        Action = actProdOptItems
      end
    end
    object miFinance: TMenuItem [3]
      Caption = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      object miBankAccountJournal: TMenuItem
        Action = actBankAccountJournal
      end
      object miLine21: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object miCashJournal: TMenuItem
        Action = actCashJournal
        Enabled = False
      end
      object N4: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object miCurrencyMovement: TMenuItem
        Action = actCurrencyMovement
        Enabled = False
      end
      object N12: TMenuItem
        Caption = '-'
      end
      object N11: TMenuItem
        Action = actInvoiceJournal
      end
    end
    object miHistory: TMenuItem [4]
      Caption = #1048#1089#1090#1086#1088#1080#1080
      object miPriceListItem: TMenuItem
        Action = actPriceListItem
      end
      object miLine31: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object miDiscountItem: TMenuItem
        Action = actDiscountItem
        Enabled = False
      end
    end
    object miReport_Unit: TMenuItem [5]
      Caption = #1054#1090#1095#1077#1090#1099' ('#1087#1088'-'#1074#1086')'
      object miReport_ProductionOLAP: TMenuItem
        Action = actReport_ProductionOLAP
        Enabled = False
      end
      object miLine41: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object miReport_Remains_curr_prod: TMenuItem
        Action = actReport_Remains_curr
        Enabled = False
      end
      object actReport_Remains_onDate_prod: TMenuItem
        Action = actReport_Remains_onDate
        Enabled = False
      end
    end
    object miReport: TMenuItem [6]
      Caption = #1054#1090#1095#1077#1090#1099' ('#1089#1082#1083#1072#1076')'
      object miReport_Income: TMenuItem
        Action = actReport_Income
        Enabled = False
      end
      object miReport_Send: TMenuItem
        Action = actReport_Send
        Enabled = False
      end
      object miReport_MovementLoss: TMenuItem
        Action = actReport_Loss
        Enabled = False
      end
      object miReport_Sale: TMenuItem
        Action = actReport_Sale
        Enabled = False
      end
      object miLine51: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object miReport_Remains_curr: TMenuItem
        Action = actReport_Remains_curr
        Enabled = False
      end
      object miReport_Remains_onDate: TMenuItem
        Action = actReport_Remains_onDate
        Enabled = False
      end
      object N3: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object miReport_GoodsCode: TMenuItem
        Action = actReport_GoodsCode
        Enabled = False
      end
    end
    object miReport_Finance: TMenuItem [7]
      Caption = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      object miReport_CollationByPartner: TMenuItem
        Action = actReport_CollationByClient
        Enabled = False
      end
      object miReport_Cash: TMenuItem
        Action = actReport_Cash
        Enabled = False
      end
      object miLine61: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object miReport_MotionByPartner: TMenuItem
        Action = actReport_MotionByClient
        Enabled = False
      end
    end
    object miReport_Basis: TMenuItem [8]
      Caption = #1054#1090#1095#1077#1090#1099' ('#1059#1055')'
      object miReport_Balance: TMenuItem
        Action = actReport_Balance
        Enabled = False
      end
      object miReport_ProfitLoss: TMenuItem
        Action = actReport_ProfitLoss
        Enabled = False
      end
      object miReport_ProfitLossPeriod: TMenuItem
        Action = actReport_ProfitLossPeriod
        Enabled = False
      end
      object N7: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object miReport_SaleOLAP: TMenuItem
        Action = actReport_SaleOLAP
        Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' (OLAP)'
        Enabled = False
      end
      object miLine71: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object miReport_SaleOLAP_Analysis: TMenuItem
        Caption = #1040#1085#1072#1083#1080#1079' '#1087#1088#1086#1076#1072#1078
        Enabled = False
      end
      object N6: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object miReport_Sale_Analysis: TMenuItem
        Caption = #1040#1085#1072#1083#1080#1090#1080#1082#1072' '#1082#1083#1102#1095#1077#1074#1099#1093' '#1087#1086#1082#1072#1079#1072#1090#1077#1083#1077#1081
        Enabled = False
      end
    end
    inherited miGuide: TMenuItem
      object miGoodsGroup: TMenuItem
        Action = actGoodsGroup
        Caption = #1043#1088#1091#1087#1087#1099
      end
      object miGoods: TMenuItem
        Action = actGoods
      end
      object miPartionGoods: TMenuItem
        Action = actPartionGoods
        Enabled = False
        Visible = False
      end
      object miGoodsTree: TMenuItem
        Action = actGoodsTree
        Visible = False
      end
      object miMeasure: TMenuItem
        Action = actMeasure
      end
      object miGoodsSize: TMenuItem
        Action = actGoodsSize
      end
      object miModelEtiketen: TMenuItem
        Action = actModelEtiketen
      end
      object miLine81: TMenuItem
        Caption = '-'
        Visible = False
      end
      object miUnit: TMenuItem
        Action = actUnit
        Caption = #1057#1082#1083#1072#1076#1099
      end
      object miPriceList: TMenuItem
        Action = actPriceList
        Enabled = False
        Visible = False
      end
      object miLine82: TMenuItem
        Caption = '-'
        Visible = False
      end
      object miPartner: TMenuItem
        Action = actPartner
      end
      object miCountryBrand: TMenuItem
        Action = actCountry
      end
      object miPLZ: TMenuItem
        Action = actPLZ
        Caption = #1055#1086#1095#1090#1086#1074#1099#1077' '#1080#1085#1076#1077#1082#1089#1099
      end
      object N5: TMenuItem
        Caption = '-'
        Visible = False
      end
      object miClient: TMenuItem
        Action = actClient
      end
      object miLine83: TMenuItem
        Caption = '-'
        Visible = False
      end
      object miCash: TMenuItem
        Action = actCash
        Enabled = False
        Visible = False
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
        Visible = False
      end
      object miMember: TMenuItem
        Action = actMember
      end
      object miPersonal: TMenuItem
        Action = actPersonal
      end
      object miPosition: TMenuItem
        Action = actPosition
      end
    end
    inherited miService: TMenuItem
      inherited miServiceGuide: TMenuItem
        object miForms: TMenuItem [0]
          Action = actForms
        end
        object miBoatStructure: TMenuItem
          Action = actProdColorKind
        end
        object N13: TMenuItem
          Caption = '-'
        end
        object miTaxKindEdit: TMenuItem
          Action = actTaxKindEdit
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
          Enabled = False
        end
        object miAccountDirection: TMenuItem
          Action = actAccountDirection
          Enabled = False
        end
        object miAccount: TMenuItem
          Action = actAccount
          Enabled = False
        end
        object miLine8001: TMenuItem
          Caption = '-'
          Enabled = False
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
          Enabled = False
        end
        object miProfitLossGroup: TMenuItem
          Action = actProfitLossGroup
          Enabled = False
        end
        object miProfitLossDirection: TMenuItem
          Action = actProfitLossDirection
          Enabled = False
        end
        object miProfitLoss: TMenuItem
          Action = actProfitLoss
          Enabled = False
        end
      end
      object N1: TMenuItem [5]
        Caption = '-'
      end
      object miLanguage: TMenuItem [6]
        Action = actLanguage
      end
      inherited miLine801: TMenuItem [7]
      end
      object miTranslateWord: TMenuItem [8]
        Action = actTranslateWord
      end
      object miTranslateMessage: TMenuItem [9]
        Action = actTranslateMessage
      end
      object N2: TMenuItem [10]
        Caption = '-'
      end
      object miImportType: TMenuItem [11]
        Action = actImportType
      end
      object miImportSettings: TMenuItem [12]
        Action = actImportSettings
      end
      object N10: TMenuItem [13]
        Caption = '-'
      end
      inherited miProtocolAll: TMenuItem [14]
        inherited miProtocol: TMenuItem
          Enabled = False
          Visible = False
        end
        inherited miMovementProtocol: TMenuItem
          Enabled = False
          Visible = False
        end
        inherited miUserProtocol: TMenuItem
          Enabled = False
        end
      end
    end
  end
  inherited frxXLSExport: TfrxXLSExport
    Left = 152
    Top = 112
  end
end
