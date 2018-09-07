inherited MainForm: TMainForm
  Caption = #1056#1072#1073#1086#1090#1072' '#1089' '#1079#1072#1082#1072#1079#1072#1084#1080
  ClientHeight = 171
  ClientWidth = 666
  KeyPreview = True
  ExplicitWidth = 682
  ExplicitHeight = 229
  PixelsPerInch = 96
  TextHeight = 13
  inherited ActionList: TActionList
    Left = 328
    object actReport_Check_Rating: TdsdOpenForm [0]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1056#1077#1081#1090#1080#1085#1075' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1086#1074
      FormName = 'TReport_Check_RatingForm'
      FormNameParam.Value = 'TReport_Check_RatingForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_MovementPriceList_Cross: TdsdOpenForm [1]
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1072#1081#1089#1072#1084
      FormName = 'TReport_MovementPriceListForm'
      FormNameParam.Value = 'TReport_MovementPriceListForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'JuridicalId_1'
          Value = '59611'
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId_2'
          Value = '59610'
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId_3'
          Value = '59612'
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName_1'
          Value = #1054#1087#1090#1080#1084#1072
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName_2'
          Value = #1041#1072#1044#1052
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName_3'
          Value = #1042#1077#1085#1090#1072
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractId_1'
          Value = '183338'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractId_2'
          Value = '183275'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractId_3'
          Value = '183378'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractName_1'
          Value = #1054#1087#1090#1080#1084#1072' '#1060#1072#1082#1090
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractName_2'
          Value = #1041#1072#1076#1084' '#1060#1072#1082#1090
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractName_3'
          Value = #1042#1077#1085#1090#1072
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actMemberIncomeCheck: TdsdOpenForm [2]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1060#1048#1054' '#1059#1087#1086#1083#1085#1086#1084#1086#1095#1077#1085#1085#1099#1093' '#1083#1080#1094
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TMemberIncomeCheckForm'
      FormNameParam.Value = 'TMemberIncomeCheckForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPromoUnit: TdsdOpenForm [3]
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1055#1083#1072#1085' '#1087#1086' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1091' '#1076#1083#1103' '#1090#1086#1095#1077#1082
      FormName = 'TPromoUnitJournalForm'
      FormNameParam.Value = 'TPromoUnitJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProvinceCity: TdsdOpenForm [4]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1056#1072#1081#1086#1085' '#1075#1086#1088#1086#1076#1072
      Hint = #1056#1072#1081#1086#1085' '#1075#1086#1088#1086#1076#1072
      FormName = 'TProvinceCityForm'
      FormNameParam.Name = #1045
      FormNameParam.Value = 'TProvinceCityForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPersonalList: TdsdOpenForm [5]
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082#1080' ('#1087#1088#1086#1089#1084#1086#1090#1088')'
      Hint = #1057#1086#1090#1088#1091#1076#1085#1080#1082#1080
      FormName = 'TPersonal_ObjectForm'
      FormNameParam.Value = 'TPersonal_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPromoCode: TdsdOpenForm [6]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1056#1054#1052#1054' '#1050#1054#1044' ('#1053#1072#1079#1074#1072#1085#1080#1077' '#1072#1082#1094#1080#1080')'
      Hint = #1055#1056#1054#1052#1054' '#1050#1054#1044' ('#1053#1072#1079#1074#1072#1085#1080#1077' '#1072#1082#1094#1080#1080')'
      FormName = 'TPromoCodeForm'
      FormNameParam.Value = 'TPromoCodeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actRepriceChangeJournal: TdsdOpenForm [7]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1046#1091#1088#1085#1072#1083' '#1087#1077#1088#1077#1086#1094#1077#1085#1086#1082' '#1094#1077#1085#1099' '#1057#1054' '#1057#1050#1048#1044#1050#1054#1049
      Hint = #1046#1091#1088#1085#1072#1083' '#1087#1077#1088#1077#1086#1094#1077#1085#1086#1082' '#1094#1077#1085#1099' '#1057#1054' '#1057#1050#1048#1044#1050#1054#1049
      FormName = 'TRepriceChangeJournalForm'
      FormNameParam.Value = 'TRepriceChangeJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Check_PriceChange: TdsdOpenForm [8]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1086#1076#1072#1078#1080' '#1087#1086' '#1094#1077#1085#1077' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
      Hint = #1055#1088#1086#1076#1072#1078#1080' '#1087#1086' '#1094#1077#1085#1077' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
      FormName = 'TReport_Check_PriceChangeForm'
      FormNameParam.Value = 'TReport_Check_PriceChangeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Check_UKTZED: TdsdOpenForm [9]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1076#1083#1103' '#1073#1091#1093#1075#1072#1083#1090#1077#1088#1080#1080
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1076#1083#1103' '#1073#1091#1093#1075#1072#1083#1090#1077#1088#1080#1080
      FormName = 'TReport_Check_UKTZEDForm'
      FormNameParam.Value = 'TReport_Check_UKTZEDForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_OverOrder: TdsdOpenForm [10]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1080#1093#1086#1076' '#1085#1072' '#1090#1086#1095#1082#1091' '#1089#1074#1077#1088#1093' '#1079#1072#1082#1072#1079#1072
      FormName = 'TReport_OverOrderForm'
      FormNameParam.Value = 'TReport_OverOrderForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSPKind: TdsdOpenForm [11]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1042#1080#1076#1099' '#1089#1086#1094'.'#1087#1088#1086#1077#1082#1090#1086#1074
      Hint = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072
      FormName = 'TSPKindForm'
      FormNameParam.Value = 'TSPKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMedicSP: TdsdOpenForm [12]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1060#1048#1054' '#1074#1088#1072#1095#1072' ('#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090')'
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TMedicSPForm'
      FormNameParam.Value = 'TMedicSPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMemberSP: TdsdOpenForm [13]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1060#1048#1054' '#1087#1072#1094#1080#1077#1085#1090#1072' ('#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090')'
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TMemberSPForm'
      FormNameParam.Value = 'TMemberSPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMarginCategory_Total: TdsdOpenForm [14]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1086#1082' ('#1086#1073#1097#1080#1081')'
      FormName = 'TMarginCategory_TotalForm'
      FormNameParam.Value = 'TMarginCategory_TotalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsSPJournal: TdsdOpenForm [15]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1072' ('#1076#1086#1082#1091#1084#1077#1085#1090')'
      FormName = 'TGoodsSPJournalForm'
      FormNameParam.Value = 'TGoodsSPJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_SaleSP: TdsdOpenForm [16]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' "'#1088#1077#1077#1089#1090#1088' '#1087#1086' '#1087#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1102' 1303"'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1090#1086#1074#1072#1088#1086#1074' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072
      FormName = 'TReport_SaleSPForm'
      FormNameParam.Value = 'TReport_SaleSPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsRemainsCurrent: TdsdOpenForm [17]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1058#1077#1082#1091#1097#1080#1077' '#1086#1089#1090#1072#1090#1082#1080' '#1087#1086' '#1089#1077#1090#1080
      FormName = 'TReport_GoodsRemainsCurrentForm'
      FormNameParam.Value = 'TReport_GoodsRemainsCurrentForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actBarCode: TdsdOpenForm [18]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1064#1090#1088#1080#1093'-'#1082#1086#1076#1099' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1064#1090#1088#1080#1093'-'#1082#1086#1076#1099' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TBarCodeForm'
      FormNameParam.Value = 'TBarCodeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actUnit_JuridicalArea: TdsdOpenForm [19]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' ('#1087#1086#1089#1090#1072#1074#1097#1080#1082')'
      Hint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
      FormName = 'TUnit_JuridicalAreaForm'
      FormNameParam.Value = 'TUnit_JuridicalAreaForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actFiscal: TdsdOpenForm [20]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1086#1074#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1099
      Hint = #1050#1072#1089#1089#1086#1074#1099#1081' '#1072#1087#1087#1072#1088#1072#1090
      FormName = 'TFiscalForm'
      FormNameParam.Value = 'TFiscalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMarginCategory_Movement: TdsdOpenForm [21]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1082#1080' ('#1057#1040#1059#1062')'
      FormName = 'TMarginCategoryJournalForm'
      FormNameParam.Value = 'TMarginCategoryJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Check_Assortment: TdsdOpenForm [22]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1040#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090' '#1089#1077#1090#1080
      Hint = #1040#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090' '#1089#1077#1090#1080
      FormName = 'TReport_Check_AssortmentForm'
      FormNameParam.Value = 'TReport_Check_AssortmentForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_CheckMiddle_Detail: TdsdOpenForm [23]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1057#1088#1077#1076#1085#1080#1081' '#1095#1077#1082' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      FormName = 'TReport_CheckMiddle_DetailForm'
      FormNameParam.Value = 'TReport_CheckMiddle_DetailForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsRemains_AnotherRetail: TdsdOpenForm [24]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1054#1089#1090#1072#1090#1082#1080' '#1090#1086#1074#1072#1088#1072' (ID '#1090#1086#1074#1072#1088#1072' '#1076#1088#1091#1075#1086#1081' '#1089#1077#1090#1080')'
      FormName = 'TReport_GoodsRemains_AnotherRetailForm'
      FormNameParam.Value = 'TReport_GoodsRemains_AnotherRetailForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMarginCategory_Cross: TdsdOpenForm [25]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1086#1082' (cross)'
      FormName = 'TMarginCategory_CrossForm'
      FormNameParam.Value = 'TMarginCategory_CrossForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actConfirmedKind: TdsdOpenForm [26]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072
      Hint = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072
      FormName = 'TConfirmedKindForm'
      FormNameParam.Value = 'TConfirmedKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actBrandSP: TdsdOpenForm [27]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1088#1075#1086#1074#1077#1083#1100#1085#1072' '#1085#1072#1079#1074#1072' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091' ('#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090')'
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TBrandSPForm'
      FormNameParam.Value = 'TBrandSPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actConditionsKeep: TdsdOpenForm [28]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1059#1089#1083#1086#1074#1080#1103' '#1093#1088#1072#1085#1077#1085#1080#1103
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TConditionsKeepForm'
      FormNameParam.Value = 'TConditionsKeepForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPartnerMedical: TdsdOpenForm [29]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1052#1077#1076#1080#1094#1080#1085#1089#1082#1086#1077' '#1091#1095#1088#1077#1078#1076#1077#1085#1080#1077
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TPartnerMedicalForm'
      FormNameParam.Value = 'TPartnerMedicalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsRetail: TdsdOpenForm [30]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' ('#1074#1099#1073#1086#1088' '#1090#1086#1088#1075'. '#1089#1077#1090#1080')'
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TGoodsRetailForm'
      FormNameParam.Value = 'TGoodsRetailForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoods_NDS_diff: TdsdOpenForm [31]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' '#1089#1077#1090#1080' ('#1080#1079#1084#1077#1085#1077#1085#1080#1077' '#1053#1044#1057')'
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TGoods_NDS_diffForm'
      FormNameParam.Value = 'TGoods_NDS_diffForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actIntenalSP: TdsdOpenForm [32]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1052#1110#1078#1085#1072#1088#1086#1076#1085#1072' '#1085#1077#1087#1072#1090#1077#1085#1090#1086#1074#1072#1085#1072' '#1085#1072#1079#1074#1072' ('#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090')'
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TIntenalSPForm'
      FormNameParam.Value = 'TIntenalSPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actDiscountExternalJuridical: TdsdOpenForm [33]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1055#1088#1086#1077#1082#1090#1086#1074' ('#1076#1080#1089#1082#1086#1085#1090#1085#1099#1077' '#1082#1072#1088#1090#1099', '#1102#1088'. '#1083#1080#1094#1072')'
      Hint = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1055#1088#1086#1077#1082#1090#1086#1074' ('#1076#1080#1089#1082#1086#1085#1090#1085#1099#1077' '#1082#1072#1088#1090#1099', '#1102#1088'. '#1083#1080#1094#1072')'
      FormName = 'TDiscountExternalJuridicalForm'
      FormNameParam.Value = 'TDiscountExternalJuridicalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsSP: TdsdOpenForm [34]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' '#1057#1086#1094'. '#1055#1088#1086#1077#1082#1090#1072
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TGoodsSPForm'
      FormNameParam.Value = 'TGoodsSPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actInvoice: TdsdOpenForm [35]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1046#1091#1088#1085#1072#1083' '#1089#1095#1077#1090#1086#1074' '#1087#1086' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072#1084
      FormName = 'TInvoiceJournalForm'
      FormNameParam.Value = 'TInvoiceJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_MinPrice_onGoods: TdsdOpenForm [36]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1043#1088#1072#1092#1080#1082' '#1076#1074#1080#1078#1077#1085#1080#1103' '#1094#1077#1085#1099' '#1087#1088#1077#1087#1072#1088#1072#1090#1072
      Hint = #1043#1088#1072#1092#1080#1082' '#1076#1074#1080#1078#1077#1085#1080#1103' '#1094#1077#1085#1099' '#1087#1088#1077#1087#1072#1088#1072#1090#1072
      FormName = 'TReport_MinPrice_onGoodsForm'
      FormNameParam.Name = 'TReport_MinPrice_onGoodsForm'
      FormNameParam.Value = 'TReport_MinPrice_onGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Badm: TdsdOpenForm [37]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1087#1086' '#1072#1087#1090#1077#1082#1072#1084' ('#1041#1072#1044#1052')'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1087#1086' '#1072#1087#1090#1077#1082#1072#1084' ('#1041#1072#1044#1052')'
      FormName = 'TReport_BadmForm'
      FormNameParam.Value = 'TReport_BadmForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoods_BarCode: TdsdOpenForm [38]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' '#1089#1077#1090#1080' ('#1096'/'#1082' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1103')'
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TGoods_BarCodeForm'
      FormNameParam.Value = 'TGoods_BarCodeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actEmail: TdsdOpenForm [39]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1086#1095#1090#1086#1074#1099#1081' '#1103#1097#1080#1082
      Hint = #1055#1086#1095#1090#1086#1074#1099#1081' '#1103#1097#1080#1082
      FormName = 'TEmailForm'
      FormNameParam.Value = 'TEmailForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_CheckSP: TdsdOpenForm [40]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1090#1086#1074#1072#1088#1086#1074' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1090#1086#1074#1072#1088#1086#1074' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072
      FormName = 'TReport_CheckSPForm'
      FormNameParam.Name = 'TOverSettingsForm'
      FormNameParam.Value = 'TReport_CheckSPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_CheckPromoFarm: TdsdOpenForm [41]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1060#1072#1088#1084'-'#1090#1091' '#1086#1090#1095#1077#1090' % ('#1089#1091#1084#1084#1099') '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103' '#1077#1078#1077#1084#1077#1089#1103#1095'.'#1084#1072#1088#1082#1077#1090' '#1087#1083#1072#1085#1072
      Hint = #1060#1072#1088#1084'-'#1090#1091' '#1086#1090#1095#1077#1090' % ('#1089#1091#1084#1084#1099') '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103' '#1077#1078#1077#1084#1077#1089#1103#1095'.'#1084#1072#1088#1082#1077#1090' '#1087#1083#1072#1085#1072
      FormName = 'TReport_CheckPromoForm'
      FormNameParam.Value = 'TReport_CheckPromoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inIsFarm'
          Value = 'True'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actReport_CheckPromo: TdsdOpenForm [42]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1093' '#1087#1088#1086#1076#1072#1078
      Hint = #1054#1090#1095#1077#1090' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1093' '#1087#1088#1086#1076#1072#1078
      FormName = 'TReport_CheckPromoForm'
      FormNameParam.Value = 'TReport_CheckPromoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inIsFarm'
          Value = 'False'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUnit_Object: TdsdOpenForm [43]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' ('#1089#1087#1080#1089#1086#1082')'
      Hint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
      FormName = 'TUnit_ObjectForm'
      FormNameParam.Value = 'TUnit_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_MovementCheck_Cross: TdsdOpenForm [44]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1083#1072#1085#1091' '#1084#1072#1088#1082#1077#1090#1087#1088#1086#1076#1072#1078
      Hint = #1054#1090#1095#1077#1090' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1093' '#1087#1088#1086#1076#1072#1078
      FormName = 'TReport_MovementCheck_CrossForm'
      FormNameParam.Value = 'TReport_MovementCheck_CrossForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'isFarm'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actReport_RemainsOverGoods_To: TdsdOpenForm [45]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1080#1079#1083#1080#1096#1082#1086#1074' '#1085#1072' '#1072#1087#1090#1077#1082#1091
      FormName = 'TReport_RemainsOverGoods_ToForm'
      FormNameParam.Value = 'TReport_RemainsOverGoods_ToForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_MovementCheckFarm_Cross: TdsdOpenForm [46]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1060#1072#1088#1084'-'#1090#1091'  '#1086#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1077#1087#1072#1088#1072#1090#1072#1084' '#1077#1078#1077#1084#1077#1089#1103#1095'. '#1084#1072#1088#1082#1077#1090'. '#1087#1083#1072#1085#1072
      Hint = #1060#1072#1088#1084'-'#1090#1091'  '#1086#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1077#1087#1072#1088#1072#1090#1072#1084' '#1077#1078#1077#1084#1077#1089#1103#1095'. '#1084#1072#1088#1082#1077#1090'. '#1087#1083#1072#1085#1072
      FormName = 'TReport_MovementCheck_CrossForm'
      FormNameParam.Value = 'TReport_MovementCheck_CrossForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'isFarm'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actReport_GoodsRemainsLight: TdsdOpenForm [47]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1057#1091#1084#1084#1072#1088#1085#1099#1077' '#1086#1089#1090#1072#1090#1082#1080' '#1087#1086' '#1089#1077#1090#1080
      FormName = 'TReport_GoodsRemainsLightForm'
      FormNameParam.Value = 'TReport_GoodsRemainsLightForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReportMovementCheckLight: TdsdOpenForm [48]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = 'C'#1091#1084#1084#1072#1088#1085#1099#1077' '#1087#1088#1086#1076#1072#1078#1080' '#1087#1086' '#1089#1077#1090#1080' '
      Hint = 'C'#1091#1084#1084#1072#1088#1085#1099#1077' '#1087#1088#1086#1076#1072#1078#1080' '#1087#1086' '#1089#1077#1090#1080' '
      FormName = 'TReportMovementCheckLightForm'
      FormNameParam.Value = 'TReportMovementCheckLightForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReportMovementCheckMiddleForm: TdsdOpenForm [49]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1057#1088#1077#1076#1085#1080#1081' '#1095#1077#1082
      FormName = 'TReportMovementCheckMiddleForm'
      FormNameParam.Value = 'TReportMovementCheckMiddleForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_PriceIntervention2: TdsdOpenForm [50]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1062#1077#1085#1086#1074#1072#1103' '#1080#1085#1090#1077#1088#1074#1077#1085#1094#1080#1103' 2'
      Hint = #1054#1090#1095#1077#1090' '#1062#1077#1085#1086#1074#1072#1103' '#1080#1085#1090#1077#1088#1074#1077#1085#1094#1080#1103' 2'
      FormName = 'TReport_PriceIntervention2Form'
      FormNameParam.Value = 'TReport_PriceIntervention2Form'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPromoCodeMovement: TdsdOpenForm [51]
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1046#1091#1088#1085#1072#1083' <'#1055#1088#1086#1084#1086'-'#1082#1086#1076#1099'>'
      FormName = 'TPromoCodeJournalForm'
      FormNameParam.Value = 'TPromoCodeJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPromo: TdsdOpenForm [52]
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1052#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1081' '#1082#1086#1085#1090#1088#1072#1082#1090
      FormName = 'TPromoJournalForm'
      FormNameParam.Value = 'TPromoJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actOrderShedule: TdsdOpenForm [53]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1043#1088#1072#1092#1080#1082' '#1079#1072#1082#1072#1079#1072'/'#1076#1086#1089#1090#1072#1074#1082#1080
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TOrderSheduleForm'
      FormNameParam.Value = 'TOrderSheduleForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actArea: TdsdOpenForm [54]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1056#1077#1075#1080#1086#1085#1099
      Hint = #1056#1077#1075#1080#1086#1085#1099
      FormName = 'TAreaForm'
      FormNameParam.Value = 'TAreaForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actKindOutSP: TdsdOpenForm [55]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1060#1086#1088#1084#1072' '#1074#1080#1087#1091#1089#1082#1091' ('#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090')'
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TKindOutSPForm'
      FormNameParam.Value = 'TKindOutSPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actDiscountCard: TdsdOpenForm [56]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1044#1080#1089#1082#1086#1085#1090#1085#1099#1077' '#1082#1072#1088#1090#1099
      Hint = #1044#1080#1089#1082#1086#1085#1090#1085#1099#1077' '#1082#1072#1088#1090#1099
      FormName = 'TDiscountCardForm'
      FormNameParam.Value = 'TDiscountCardForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_MovementIncome_Promo: TdsdOpenForm [57]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1080#1093#1086#1076#1072#1084' ('#1084#1072#1088#1082#1077#1090'. '#1082#1086#1085#1090#1088#1072#1082#1090')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1080#1093#1086#1076#1072#1084' ('#1084#1072#1088#1082#1077#1090'. '#1082#1086#1085#1090#1088#1072#1082#1090')'
      FormName = 'TReport_MovementIncome_PromoForm'
      FormNameParam.Value = 'TReport_MovementIncome_PromoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actJuridicalArea: TdsdOpenForm [58]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1056#1077#1075#1080#1086#1085#1099' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
      Hint = #1056#1077#1075#1080#1086#1085#1099' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
      FormName = 'TJuridicalAreaForm'
      FormNameParam.Value = 'TJuridicalAreaForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_MovementCheck_Promo: TdsdOpenForm [59]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' ('#1084#1072#1088#1082#1077#1090'. '#1082#1086#1085#1090#1088#1072#1082#1090')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' ('#1084#1072#1088#1082#1077#1090'. '#1082#1086#1085#1090#1088#1072#1082#1090')'
      FormName = 'TReport_MovementCheck_PromoForm'
      FormNameParam.Value = 'TReport_MovementCheck_PromoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_PriceInterventionForm: TdsdOpenForm [60]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1062#1077#1085#1086#1074#1072#1103' '#1080#1085#1090#1077#1088#1074#1077#1085#1094#1080#1103
      Hint = #1054#1090#1095#1077#1090' '#1062#1077#1085#1086#1074#1072#1103' '#1080#1085#1090#1077#1088#1074#1077#1085#1094#1080#1103
      FormName = 'TReport_PriceInterventionForm'
      FormNameParam.Value = 'TReport_PriceInterventionForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actEmailKind: TdsdOpenForm [61]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1058#1080#1087#1099' '#1091#1089#1090#1072#1085#1086#1074#1086#1082' '#1076#1083#1103' '#1087#1086#1095#1090#1099
      Hint = #1058#1080#1087#1099' '#1091#1089#1090#1072#1085#1086#1074#1086#1082' '#1076#1083#1103' '#1087#1086#1095#1090#1099
      FormName = 'TEmailKindForm'
      FormNameParam.Value = 'TEmailKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actUnit_byReportBadm: TdsdOpenForm [62]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' ('#1041#1072#1044#1052')'
      FormName = 'TUnit_byReportBadmForm'
      FormNameParam.Value = 'TUnit_byReportBadmForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReportMovementIncomeFarmForm: TdsdOpenForm [63]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1055#1088#1080#1093#1086#1076' '#1085#1072' '#1090#1086#1095#1082#1091' ('#1076#1083#1103' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1072')'
      Hint = #1054#1090#1095#1077#1090' '#1055#1088#1080#1093#1086#1076' '#1085#1072' '#1090#1086#1095#1082#1091' ('#1076#1083#1103' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1072')'
      FormName = 'TReport_MovementIncomeFarmForm'
      FormNameParam.Value = 'TReport_MovementIncomeFarmForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actOverSettings: TdsdOpenForm [64]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1080' '#1076#1083#1103' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1103' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1087#1086' '#1080#1079#1083#1080#1096#1082#1072#1084
      Hint = #1059#1089#1090#1072#1085#1086#1074#1082#1080' '#1076#1083#1103' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1103' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1087#1086' '#1080#1079#1083#1080#1096#1082#1072#1084
      FormName = 'TOverSettingsForm'
      FormNameParam.Name = 'TOverSettingsForm'
      FormNameParam.Value = 'TOverSettingsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actOver: TdsdOpenForm [65]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1048#1079#1083#1080#1096#1082#1080' ('#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1087#1086' '#1072#1087#1090#1077#1082#1072#1084')'
      FormName = 'TOverJournalForm'
      FormNameParam.Name = 'TOverJournalForm'
      FormNameParam.Value = 'TOverJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMaker: TdsdOpenForm [66]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1080
      Hint = #1045#1076#1080#1085#1080#1094#1099' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
      FormName = 'TMakerForm'
      FormNameParam.Value = 'TMakerForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Payment_Plan: TdsdOpenForm [67]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1043#1088#1072#1092#1080#1082' '#1087#1088#1086#1075#1085#1086#1079#1080#1088#1091#1077#1084#1099#1093' '#1087#1083#1072#1090#1077#1078#1077#1081' '#1085#1072' '#1084#1077#1089#1103#1094
      Hint = ' '#1043#1088#1072#1092#1080#1082' '#1087#1088#1086#1075#1085#1086#1079#1080#1088#1091#1077#1084#1099#1093' '#1087#1083#1072#1090#1077#1078#1077#1081' '#1085#1072' '#1084#1077#1089#1103#1094
      FormName = 'TReport_Payment_PlanForm'
      FormNameParam.Value = 'TReport_Payment_PlanForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actRoleUnion: TdsdOpenForm [68]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1056#1086#1083#1080' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103' ('#1087#1086#1076#1088#1086#1073#1085#1086')'
      FormName = 'TRoleUnionForm'
      FormNameParam.Value = 'TRoleUnionForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_MovementCheckUnLiquid: TdsdOpenForm [69]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1053#1077#1083#1080#1082#1074#1080#1076#1085#1099#1084' '#1090#1086#1074#1072#1088#1072#1084
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1053#1077#1083#1080#1082#1074#1080#1076#1085#1099#1084' '#1090#1086#1074#1072#1088#1072#1084
      FormName = 'TReport_MovementCheck_UnLiquidForm'
      FormNameParam.Value = 'TReport_MovementCheck_UnLiquidForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_MovementCheckErrorForm: TdsdOpenForm [70]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1095#1077#1082#1072#1084' - '#1087#1088#1086#1074#1077#1088#1082#1072' '#1087#1088#1086#1074#1086#1076#1086#1082
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1095#1077#1082#1072#1084' - '#1087#1088#1086#1074#1077#1088#1082#1072' '#1087#1088#1086#1074#1086#1076#1086#1082
      FormName = 'TReport_MovementCheckErrorForm'
      FormNameParam.Value = 'TReport_MovementCheckErrorForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actUnitForFarmacyCash: TdsdOpenForm [71]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1089#1074#1103#1079#1080' '#1089' FarmacyCash'
      FormName = 'TUnitForFarmacyCashForm'
      FormNameParam.Value = 'TUnitForFarmacyCashForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_ProfitForm: TdsdOpenForm [72]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1044#1086#1093#1086#1076#1085#1086#1089#1090#1080
      Hint = #1054#1090#1095#1077#1090' '#1044#1086#1093#1086#1076#1085#1086#1089#1090#1080
      FormName = 'TReport_ProfitForm'
      FormNameParam.Value = 'TReport_ProfitForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReportPromoParams: TdsdOpenForm [73]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1083#1072#1085' '#1087#1086' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1091
      FormName = 'TReportPromoParamsForm'
      FormNameParam.Value = 'TReportPromoParamsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actEmailTools: TdsdOpenForm [74]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1091#1089#1090#1072#1085#1086#1074#1086#1082' '#1076#1083#1103' '#1087#1086#1095#1090#1099
      Hint = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1091#1089#1090#1072#1085#1086#1074#1086#1082' '#1076#1083#1103' '#1087#1086#1095#1090#1099
      FormName = 'TEmailToolsForm'
      FormNameParam.Value = 'TEmailToolsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsOnUnit_ForSite: TdsdOpenForm [75]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' '#1076#1083#1103' '#1089#1072#1081#1090#1072
      FormName = 'TReport_GoodsOnUnit_ForSiteForm'
      FormNameParam.Value = 'TReport_GoodsOnUnit_ForSiteForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsAllRetail: TdsdOpenForm [76]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099'  '#1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
      Hint = #1058#1086#1074#1072#1088#1099'  '#1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
      FormName = 'TGoodsAllRetailForm'
      FormNameParam.Value = 'TGoodsAllRetailForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_RemainsOverGoods: TdsdOpenForm [77]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1080#1079#1083#1080#1096#1082#1086#1074' '#1087#1086' '#1072#1087#1090#1077#1082#1072#1084
      FormName = 'TReport_RemainsOverGoodsForm'
      FormNameParam.Value = 'TReport_RemainsOverGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReportMovementIncomeForm: TdsdOpenForm [78]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1055#1088#1080#1093#1086#1076' '#1085#1072' '#1090#1086#1095#1082#1091
      Hint = #1054#1090#1095#1077#1090' '#1055#1088#1080#1093#1086#1076' '#1085#1072' '#1090#1086#1095#1082#1091
      FormName = 'TReport_MovementIncomeForm'
      FormNameParam.Value = 'TReport_MovementIncomeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsAllJuridical: TdsdOpenForm [79]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' '#1055#1086#1089#1090#1072#1074#1097#1080#1082
      Hint = #1058#1086#1074#1072#1088#1099' '#1055#1086#1089#1090#1072#1074#1097#1080#1082
      FormName = 'TGoodsAllJuridicalForm'
      FormNameParam.Value = 'TGoodsAllJuridicalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReportMovementCheckFarmForm: TdsdOpenForm [80]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093' ('#1076#1083#1103' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1072')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093' ('#1076#1083#1103' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1072')'
      FormName = 'TReportMovementCheckFarmForm'
      FormNameParam.Value = 'TReportMovementCheckFarmForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsAll: TdsdOpenForm [81]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' '#1054#1073#1097#1080#1081
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TGoodsAllForm'
      FormNameParam.Value = 'TGoodsAllForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actColor: TdsdOpenForm [82]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1094#1074#1077#1090#1086#1074
      FormName = 'TColorForm'
      FormNameParam.Value = 'TColorForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actCalendar: TdsdOpenForm [83]
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1050#1072#1083#1077#1085#1076#1072#1088#1100' '#1088#1072#1073#1086#1095#1080#1093' '#1076#1085#1077#1081
      Hint = #1050#1072#1083#1077#1085#1076#1072#1088#1100' '#1088#1072#1073#1086#1095#1080#1093' '#1076#1085#1077#1081
      FormName = 'TCalendarForm'
      FormNameParam.Value = 'TCalendarForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPosition: TdsdOpenForm [84]
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1080
      Hint = #1044#1086#1083#1078#1085#1086#1089#1090#1080
      FormName = 'TPositionForm'
      FormNameParam.Value = 'TPositionForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMember: TdsdOpenForm [85]
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1060#1080#1079#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      Hint = #1057#1086#1090#1088#1091#1076#1085#1080#1082#1080
      FormName = 'TMemberForm'
      FormNameParam.Value = 'TMemberForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Wage: TdsdOpenForm [86]
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1047#1055
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1047#1055
      FormName = 'TReport_WageForm'
      FormNameParam.Value = 'TReport_WageForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actWorkTimeKind: TdsdOpenForm [87]
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1058#1080#1087#1099' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080
      Hint = #1058#1080#1087#1099' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080
      FormName = 'TWorkTimeKindForm'
      FormNameParam.Value = 'TWorkTimeKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actEmailSettings: TdsdOpenForm [88]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1080' '#1076#1083#1103' '#1087#1086#1095#1090#1099
      Hint = #1059#1089#1090#1072#1085#1086#1074#1082#1080' '#1076#1083#1103' '#1087#1086#1095#1090#1099
      FormName = 'TEmailSettingsForm'
      FormNameParam.Value = 'TEmailSettingsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPersonal: TdsdOpenForm [89]
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082#1080
      Hint = #1057#1086#1090#1088#1091#1076#1085#1080#1082#1080
      FormName = 'TPersonalForm'
      FormNameParam.Value = 'TPersonalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPersonalGroup: TdsdOpenForm [90]
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1080#1088#1086#1074#1082#1080' '#1057#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074
      Hint = #1043#1088#1091#1087#1087#1080#1088#1086#1074#1082#1080' '#1057#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074
      FormName = 'TPersonalGroupForm'
      FormNameParam.Value = 'TPersonalGroupForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actIncomePharmacy: TdsdOpenForm [91]
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1055#1088#1080#1093#1086#1076#1099
      FormName = 'TIncomePharmacyJournalForm'
      FormNameParam.Value = 'TIncomePharmacyJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_LiquidForm: TdsdOpenForm [92]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1051#1080#1082#1074#1080#1076#1085#1086#1089#1090#1080' '#1090#1086#1095#1082#1080
      Hint = #1054#1090#1095#1077#1090' '#1051#1080#1082#1074#1080#1076#1085#1086#1089#1090#1080' '#1090#1086#1095#1082#1080
      FormName = 'TReport_LiquidForm'
      FormNameParam.Value = 'TReport_LiquidForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actEducation: TdsdOpenForm [93]
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1057#1087#1077#1094#1080#1072#1083#1100#1085#1086#1089#1090#1080
      Hint = #1057#1087#1077#1094#1080#1072#1083#1100#1085#1086#1089#1090#1080
      FormName = 'TEducationForm'
      FormNameParam.Value = 'TEducationForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actChoiceGoodsFromRemains: TdsdOpenForm [94]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1087#1086' '#1074#1089#1077#1081' '#1089#1077#1090#1080
      Hint = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1087#1086' '#1074#1089#1077#1081' '#1089#1077#1090#1080
      SecondaryShortCuts.Strings = (
        'Ctrl++')
      FormName = 'TChoiceGoodsFromRemainsForm'
      FormNameParam.Value = 'TChoiceGoodsFromRemainsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMarginCategoryLink: TdsdOpenForm [95]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1057#1074#1103#1079#1100' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1086#1082
      FormName = 'TMarginCategoryLinkForm'
      FormNameParam.Value = 'TMarginCategoryLinkForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMarginCategoryItem: TdsdOpenForm [96]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1086#1082
      FormName = 'TMarginCategoryItemForm'
      FormNameParam.Value = 'TMarginCategoryItemForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReportGoodsOrder: TdsdOpenForm [97]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1074' '#1079#1072#1103#1074#1082#1072#1093
      Hint = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1074' '#1079#1072#1103#1074#1082#1072#1093
      ShortCut = 120
      FormName = 'TReportOrderGoodsForm'
      FormNameParam.Value = 'TReportOrderGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPriceList: TdsdOpenForm [98]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
      FormName = 'TPriceListJournalForm'
      FormNameParam.Value = 'TPriceListJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actLossDebt: TdsdOpenForm [99]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1079#1072#1076#1086#1083#1078#1077#1085#1085#1086#1089#1090#1080
      FormName = 'TLossDebtJournalForm'
      FormNameParam.Value = 'TLossDebtJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actOrderInternalLite: TdsdOpenForm [101]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1047#1072#1103#1074#1082#1080' '#1074#1085#1091#1090#1088#1077#1085#1085#1080#1077
      FormName = 'TOrderInternalLiteForm'
      FormNameParam.Value = 'TOrderInternalLiteForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMarginCategory: TdsdOpenForm [102]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1086#1082
      FormName = 'TMarginCategoryForm'
      FormNameParam.Value = 'TMarginCategoryForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMovementLoad: TdsdOpenForm [103]
      Category = #1047#1072#1075#1088#1091#1079#1082#1080
      MoveParams = <>
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1075#1088#1091#1079#1082#1080
      Hint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1075#1088#1091#1079#1082#1080
      FormName = 'TMovementLoadForm'
      FormNameParam.Value = 'TMovementLoadForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actRetail: TdsdOpenForm [104]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1058#1086#1088#1075#1086#1074#1099#1077' '#1089#1077#1090#1080
      FormName = 'TRetailForm'
      FormNameParam.Value = 'TRetailForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actRepriceJournal: TdsdOpenForm [105]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1046#1091#1088#1085#1072#1083' '#1087#1077#1088#1077#1086#1094#1077#1085#1086#1082
      Hint = #1046#1091#1088#1085#1072#1083' '#1087#1077#1088#1077#1086#1094#1077#1085#1086#1082
      FormName = 'TRepriceJournalForm'
      FormNameParam.Value = 'TRepriceJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSetDefault: TdsdOpenForm [106]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1044#1077#1092#1086#1083#1090#1099' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081
      Hint = #1044#1077#1092#1086#1083#1090#1099' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081
      FormName = 'TSetUserDefaultsForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoods: TdsdOpenForm [107]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' '#1089#1077#1090#1080
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TGoodsForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actOrderKind: TdsdOpenForm [108]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1042#1080#1076' '#1079#1072#1082#1072#1079#1072
      Hint = #1042#1080#1076' '#1079#1072#1082#1072#1079#1072
      FormName = 'TOrderKindForm'
      FormNameParam.Value = 'TOrderKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actUser: TdsdOpenForm [112]
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
    object actMeasure: TdsdOpenForm [116]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1045#1076#1080#1085#1080#1094#1099' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
      Hint = #1045#1076#1080#1085#1080#1094#1099' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
      FormName = 'TMeasureForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPriceChangeOnDate: TdsdOpenForm [117]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' '#1085#1072' '#1076#1072#1090#1091' ('#1094#1077#1085#1099' '#1057#1054' '#1057#1050#1048#1044#1050#1054#1049')'
      FormName = 'TPriceChangeOnDateForm'
      FormNameParam.Value = 'TPriceChangeOnDateForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPriceOnDate: TdsdOpenForm [118]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' '#1085#1072' '#1076#1072#1090#1091
      FormName = 'TPriceOnDateForm'
      FormNameParam.Value = 'TPriceOnDateForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actJuridicalGroup: TdsdOpenForm [119]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1099' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1080#1093' '#1083#1080#1094
      Hint = #1043#1088#1091#1087#1087#1099' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1080#1093' '#1083#1080#1094
      FormName = 'TJuridicalGroupForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actBusiness: TdsdOpenForm [120]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1041#1080#1079#1085#1077#1089#1099
      Hint = #1041#1080#1079#1085#1077#1089#1099
      FormName = 'TBusinessForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actForms: TdsdOpenForm [121]
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
    object actContractKind: TdsdOpenForm [122]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1042#1080#1076#1099' '#1076#1086#1075#1086#1074#1086#1088#1086#1074
      Hint = #1042#1080#1076#1099' '#1076#1086#1075#1086#1074#1086#1088#1086#1074
      FormName = 'TContractKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actUnitGroup: TdsdOpenForm [123]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1099' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081
      Hint = #1043#1088#1091#1087#1087#1099' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081
      FormName = 'TUnitGroupForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actUnit: TdsdOpenForm [124]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
      Hint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
      FormName = 'TUnitTreeForm'
      FormNameParam.Value = 'TUnitTreeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsGroup: TdsdOpenForm [125]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1099' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1043#1088#1091#1087#1087#1099' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TGoodsGroupForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsMain: TdsdOpenForm [126]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' '#1086#1073#1098#1077#1076#1080#1085#1077#1085#1085#1099#1081
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TGoodsMainForm'
      FormNameParam.Value = 'TGoodsMainForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actContactPerson: TdsdOpenForm [127]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1086#1085#1090#1072#1082#1090#1085#1099#1077' '#1083#1080#1094#1072
      FormName = 'TContactPersonForm'
      FormNameParam.Value = 'TContactPersonForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actContract: TdsdOpenForm [128]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1044#1086#1075#1086#1074#1086#1088#1072
      Hint = #1044#1086#1075#1086#1074#1086#1088#1072
      FormName = 'TContractForm'
      FormNameParam.Value = 'TContractForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsKind: TdsdOpenForm [129]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1042#1080#1076#1099' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1042#1080#1076#1099' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsProperty: TdsdOpenForm [130]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088#1099' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TGoodsPropertyForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPaidKind: TdsdOpenForm [131]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1042#1080#1076#1099' '#1092#1086#1088#1084' '#1086#1087#1083#1072#1090#1099
      Hint = #1042#1080#1076#1099' '#1092#1086#1088#1084' '#1086#1087#1083#1072#1090#1099
      FormName = 'TPaidKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReportSoldParamsFormOpen: TdsdOpenForm [132]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1083#1072#1085' '#1087#1088#1086#1076#1072#1078
      FormName = 'TReportSoldParamsForm'
      FormNameParam.Value = 'TReportSoldParamsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actBank: TdsdOpenForm [133]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1041#1072#1085#1082#1080
      Hint = #1041#1072#1085#1082#1080
      FormName = 'TBankForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actBankAccount: TdsdOpenForm [134]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1077' '#1089#1095#1077#1090#1072
      Hint = #1056#1072#1089#1095#1077#1090#1085#1099#1077' '#1089#1095#1077#1090#1072
      FormName = 'TBankAccountForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReasonDifferences: TdsdOpenForm [135]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1088#1080#1095#1080#1085#1099' '#1088#1072#1079#1085#1086#1075#1083#1072#1089#1080#1103
      FormName = 'TReasonDifferencesForm'
      FormNameParam.Value = 'TReasonDifferencesForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actJuridical: TdsdOpenForm [136]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      Hint = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      FormName = 'TJuridicalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actIncome: TdsdOpenForm [137]
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1055#1088#1080#1093#1086#1076#1085#1099#1077' '#1085#1072#1082#1083#1072#1076#1085#1099#1077
      FormName = 'TIncomeJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPartner: TdsdOpenForm [138]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099
      Hint = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099
      FormName = 'TPartnerForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actCash: TdsdOpenForm [139]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1099
      Hint = #1050#1072#1089#1089#1099
      FormName = 'TCashForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actCurrency: TdsdOpenForm [140]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1042#1072#1083#1102#1090#1099
      Hint = #1042#1072#1083#1102#1090#1099
      FormName = 'TCurrencyForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actBalance: TdsdOpenForm [141]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1041#1072#1083#1072#1085#1089
      FormName = 'TReport_BalanceForm'
      FormNameParam.Value = 'TReport_BalanceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPriceListLoad: TdsdOpenForm [142]
      Category = #1047#1072#1075#1088#1091#1079#1082#1080
      MoveParams = <>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1086#1074
      FormName = 'TPriceListLoadForm'
      FormNameParam.Value = 'TPriceListLoadForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actOrderExternal: TdsdOpenForm [143]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1047#1072#1103#1074#1082#1080' '#1074#1085#1077#1096#1085#1080#1077
      FormName = 'TOrderExternalJournalForm'
      FormNameParam.Value = 'TOrderExternalJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actOrderInternal: TdsdOpenForm [144]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1047#1072#1103#1074#1082#1080' '#1074#1085#1091#1090#1088#1077#1085#1085#1080#1077
      FormName = 'TOrderInternalJournalForm'
      FormNameParam.Value = 'TOrderInternalJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actNDSKind: TdsdOpenForm [145]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1042#1080#1076#1099' '#1053#1044#1057
      FormName = 'TNDSKindForm'
      FormNameParam.Value = 'TNDSKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actRole: TdsdOpenForm [146]
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
    object actAdditionalGoods: TdsdOpenForm [147]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1044#1086#1087#1086#1083#1085#1103#1102#1097#1080#1077' '#1090#1086#1074#1072#1088#1099
      FormName = 'TAdditionalGoodsForm'
      FormNameParam.Value = 'TAdditionalGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actTestFormOpen: TdsdOpenForm [148]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = 'actTestFormOpen'
      FormName = 'TTestForm'
      FormNameParam.Value = 'TTestForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsPartnerCode: TdsdOpenForm [149]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
      FormName = 'TGoodsPartnerCodeForm'
      FormNameParam.Value = 'TGoodsPartnerCodeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsPartnerCodeMaster: TdsdOpenForm [150]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1085#1072#1096
      FormName = 'TGoodsPartnerCodeMasterForm'
      FormNameParam.Value = 'TGoodsPartnerCodeMasterForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPriceGroupSettings: TdsdOpenForm [151]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1080' '#1076#1083#1103' '#1094#1077#1085#1086#1074#1099#1093' '#1075#1088#1091#1087#1087
      FormName = 'TPriceGroupSettingsForm'
      FormNameParam.Value = 'TPriceGroupSettingsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPriceGroupSettingsTOP: TdsdOpenForm [152]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1080' '#1076#1083#1103' '#1094#1077#1085#1086#1074#1099#1093' '#1075#1088#1091#1087#1087' '#1058#1054#1055
      FormName = 'TPriceGroupSettingsTopForm'
      FormNameParam.Value = 'TPriceGroupSettingsTopForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actJuridicalSettings: TdsdOpenForm [153]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1080' '#1076#1083#1103' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1080#1093' '#1083#1080#1094
      FormName = 'TJuridicalSettingsForm'
      FormNameParam.Value = 'TJuridicalSettingsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actJuridicalSettingsPriceList: TdsdOpenForm [154]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1047#1072#1082#1088#1099#1090#1080#1077' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1086#1074
      FormName = 'TJuridicalSettingsPriceListForm'
      FormNameParam.Value = 'TJuridicalSettingsPriceListForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSaveData: TAction [155]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093
      OnExecute = actSaveDataExecute
    end
    object actSearchGoods: TdsdOpenForm [156]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1074' '#1087#1088#1072#1081#1089' - '#1083#1080#1089#1090#1072#1093
      ShortCut = 123
      SecondaryShortCuts.Strings = (
        'Ctrl++')
      FormName = 'TChoiceGoodsFromPriceListForm'
      FormNameParam.Value = 'TChoiceGoodsFromPriceListForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    inherited actInfoMoneyGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actInfoMoneyDestination: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actInfoMoney: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actAccountGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actAccountDirection: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actProfitLossGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actProfitLossDirection: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actAccount: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actProfitLoss: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    object actReturnOut: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
      FormName = 'TReturnOutJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReturnType: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1080#1087#1099' '#1074#1086#1079#1074#1088#1072#1090#1072
      FormName = 'TReturnTypeForm'
      FormNameParam.Value = 'TReturnTypeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actBankLoad: TdsdOpenForm
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1041#1072#1085#1082#1086#1074#1089#1082#1080#1077' '#1074#1099#1087#1080#1089#1082#1080
      FormName = 'TBankStatementJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actBankAccountDocument: TdsdOpenForm
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1056#1072#1089#1093#1086#1076' '#1087#1086' '#1088#1072#1089#1095#1077#1090#1085#1086#1084#1091' '#1089#1095#1077#1090#1091
      FormName = 'TBankAccountJournalFarmacyForm'
      FormNameParam.Value = 'TBankAccountJournalFarmacyForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_JuridicalSold: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1102#1088'.'#1083#1080#1094#1072#1084
      FormName = 'TReport_JuridicalSoldForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_JuridicalCollation: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080
      FormName = 'TReport_JuridicalCollationForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSendOnPrice: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1094#1077#1085#1077
      FormName = 'TSendOnPriceJournalForm'
      FormNameParam.Value = 'TSendOnPriceJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMarginCategoryReport: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1086#1082
      FormName = 'TMarginCategoryForm'
      FormNameParam.Value = 'TMarginCategoryForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actCheck: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1086#1074#1099#1077' '#1095#1077#1082#1080
      FormName = 'TCheckJournalForm'
      FormNameParam.Value = 'TCheckJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actCashRegister: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1086#1074#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1099
      FormName = 'TCashRegisterForm'
      FormNameParam.Value = 'TCashRegisterForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodRemains: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1089#1090#1072#1090#1082#1080' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084
      FormName = 'TReport_GoodsRemainsForm'
      FormNameParam.Value = 'TReport_GoodsRemainsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPriceChange: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' '#1090#1077#1082#1091#1097#1080#1081' ('#1094#1077#1085#1099' '#1057#1054' '#1057#1050#1048#1044#1050#1054#1049')'
      FormName = 'TPriceChangeForm'
      FormNameParam.Value = 'TPriceChangeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPrice: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' '#1090#1077#1082#1091#1097#1080#1081
      FormName = 'TPriceForm'
      FormNameParam.Value = 'TPriceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actAlternativeGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1099' '#1072#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074
      Hint = #1043#1088#1091#1087#1087#1099' '#1072#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074
      FormName = 'TAlternativeGroupForm'
      FormNameParam.Value = 'TAlternativeGroupForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPaidType: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1080#1087#1099' '#1086#1087#1083#1072#1090#1099
      FormName = 'TPaidTypeForm'
      FormNameParam.Value = 'TPaidTypeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actInventoryJournal: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1091#1095#1077#1090#1099
      FormName = 'TInventoryJournalForm'
      FormNameParam.Value = 'TInventoryJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actLossJournal: TdsdOpenForm
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
    object actSendJournal: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
      FormName = 'TSendJournalForm'
      FormNameParam.Value = 'TSendJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actCreateOrderFromMCS: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1079#1072#1103#1074#1086#1082' '#1085#1072' '#1086#1089#1085#1086#1074#1077' '#1053#1058#1047
      FormName = 'TCreateOrderFromMCSForm'
      FormNameParam.Value = 'TCreateOrderFromMCSForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReportMovementCheckForm: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      FormName = 'TReportMovementCheckForm'
      FormNameParam.Value = 'TReportMovementCheckForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsPartionMoveForm: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1044#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1087#1072#1088#1090#1080#1103#1084' '#1090#1086#1074#1072#1088#1072
      FormName = 'TReport_GoodsPartionMoveForm'
      FormNameParam.Value = 'TReport_GoodsPartionMoveForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsPartionHistoryForm: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1044#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1087#1072#1088#1090#1080#1080' '#1090#1086#1074#1072#1088#1072
      Hint = #1044#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1087#1072#1088#1090#1080#1080' '#1090#1086#1074#1072#1088#1072
      FormName = 'TReport_GoodsPartionHistoryForm'
      FormNameParam.Value = 'TReport_GoodsPartionHistoryForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_SoldForm: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1083#1072#1085#1091' '#1087#1088#1086#1076#1072#1078
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1083#1072#1085#1091' '#1087#1088#1086#1076#1072#1078
      FormName = 'TReport_SoldForm'
      FormNameParam.Value = 'TReport_SoldForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Sold_DayForm: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1083#1072#1085#1091' '#1087#1088#1086#1076#1072#1078' ('#1076#1085#1077#1074#1085#1086#1081')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1083#1072#1085#1091' '#1087#1088#1086#1076#1072#1078' ('#1076#1085#1077#1074#1085#1086#1081')'
      FormName = 'TReport_Sold_DayForm'
      FormNameParam.Value = 'TReport_Sold_DayForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Sold_DayUserForm: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1083#1072#1085#1091' '#1087#1088#1086#1076#1072#1078' ('#1076#1085#1077#1074#1085#1086#1081')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1083#1072#1085#1091' '#1087#1088#1086#1076#1072#1078' ('#1076#1085#1077#1074#1085#1086#1081')'
      FormName = 'TReport_Sold_DayUserForm'
      FormNameParam.Value = 'TReport_Sold_DayUserForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSaleJournal: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1086#1076#1072#1078#1072
      FormName = 'TSaleJournalForm'
      FormNameParam.Value = 'TSaleJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Movement_ByPartionGoodsForm: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1055#1086#1080#1089#1082' '#1076#1077#1092#1077#1082#1090#1091#1088#1099
      Hint = #1055#1086#1080#1089#1082' '#1076#1077#1092#1077#1082#1090#1091#1088#1099
      FormName = 'TReport_Movement_ByPartionGoodsForm'
      FormNameParam.Value = 'TReport_Movement_ByPartionGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPaymentJournal: TdsdOpenForm
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1054#1087#1083#1072#1090#1099' '#1087#1088#1080#1093#1086#1076#1086#1074
      FormName = 'TPaymentJournalForm'
      FormNameParam.Value = 'TPaymentJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_UploadBaDMForm: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1083#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1041#1072#1044#1052')'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1083#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1041#1072#1044#1052')'
      FormName = 'TReport_UploadBaDMForm'
      FormNameParam.Value = 'TReport_UploadBaDMForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_UploadOptimaForm: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1083#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1054#1087#1090#1080#1084#1072')'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1083#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1054#1087#1090#1080#1084#1072')'
      FormName = 'TReport_UploadOptimaForm'
      FormNameParam.Value = 'TReport_UploadOptimaForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actChangeIncomePaymentJournal: TdsdOpenForm
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1076#1086#1083#1075#1072' '#1087#1086' '#1087#1088#1080#1093#1086#1076#1072#1084
      FormName = 'TChangeIncomePaymentJournalForm'
      FormNameParam.Value = 'TChangeIncomePaymentJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSheetWorkTime: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1058#1072#1073#1077#1083#1100' '#1091#1095#1077#1090#1072' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080
      Hint = #1058#1072#1073#1077#1083#1100' '#1091#1095#1077#1090#1072' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080
      FormName = 'TSheetWorkTimeJournalForm'
      FormNameParam.Value = 'TSheetWorkTimeJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actDiscountExternal: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1088#1086#1077#1082#1090#1099' ('#1076#1080#1089#1082#1086#1085#1090#1085#1099#1077' '#1082#1072#1088#1090#1099')'
      Hint = #1055#1088#1086#1077#1082#1090#1099' ('#1076#1080#1089#1082#1086#1085#1090#1085#1099#1077' '#1082#1072#1088#1090#1099')'
      FormName = 'TDiscountExternalForm'
      FormNameParam.Value = 'TDiscountExternalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actDiscountExternalTools: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1055#1088#1086#1077#1082#1090#1086#1074' ('#1076#1080#1089#1082#1086#1085#1090#1085#1099#1077' '#1082#1072#1088#1090#1099', '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103')'
      Hint = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1055#1088#1086#1077#1082#1090#1086#1074' ('#1076#1080#1089#1082#1086#1085#1090#1085#1099#1077' '#1082#1072#1088#1090#1099', '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103')'
      FormName = 'TDiscountExternalToolsForm'
      FormNameParam.Value = 'TDiscountExternalToolsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsBarCodeLoad: TdsdOpenForm
      Category = #1047#1072#1075#1088#1091#1079#1082#1080
      MoveParams = <>
      Caption = #1064#1090#1088#1080#1093'-'#1082#1086#1076#1099' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1077#1081
      FormName = 'TGoodsBarCodeForm'
      FormNameParam.Value = 'TGoodsBarCodeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReportMovementCheckGrowthAndFalling: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1040#1085#1072#1083#1080#1079' '#1087#1088#1086#1076#1072#1078' '#1087#1088#1077#1087#1072#1088#1072#1090#1086#1074
      Hint = #1040#1085#1072#1083#1080#1079' '#1087#1088#1086#1076#1072#1078' '#1087#1088#1077#1087#1072#1088#1072#1090#1086#1074
      FormName = 'TReportMovementCheckGrowthAndFallingForm'
      FormNameParam.Value = 'TReportMovementCheckGrowthAndFallingForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actExportSalesForSuppClick: TAction
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1076#1083#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
      OnExecute = actExportSalesForSuppClickExecute
    end
    object actReport_Analysis_Remains_Selling: TAction
      Category = #1054#1090#1095#1077#1090#1099
      Caption = #1056#1077#1072#1083#1080#1079#1072#1094#1080#1103' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1086#1089#1090#1072#1090#1082#1086#1084' '#1085#1072' '#1082#1086#1085#1077#1094' '#1087#1077#1088#1080#1086#1076#1072
      OnExecute = actReport_Analysis_Remains_SellingExecute
    end
    object actReportMovementCheckFLForm: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093' '#1092#1080#1079'. '#1083#1080#1094#1072#1084
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093' '#1092#1080#1079'. '#1083#1080#1094#1072#1084
      FormName = 'TReportMovementCheckFLForm'
      FormNameParam.Value = 'TReportMovementCheckFLForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_ImplementationPlanEmployee: TAction
      Category = #1054#1090#1095#1077#1090#1099
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1102' '#1087#1083#1072#1085#1072' '#1087#1088#1086#1076#1072#1078' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091
      OnExecute = actReport_ImplementationPlanEmployeeExecute
    end
    object actReport_IncomeConsumptionBalance: TAction
      Category = #1054#1090#1095#1077#1090#1099
      Caption = #1054#1090#1095#1077#1090' '#1087#1088#1080#1093#1086#1076' '#1088#1072#1089#1093#1086#1076' '#1086#1089#1090#1072#1090#1086#1082
      Hint = #1054#1090#1095#1077#1090' '#1087#1088#1080#1093#1086#1076' '#1088#1072#1089#1093#1086#1076' '#1086#1089#1090#1072#1090#1086#1082
      OnExecute = actReport_IncomeConsumptionBalanceExecute
    end
    object actReport_ImplementationPlanEmployeeAll: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1102' '#1087#1083#1072#1085#1072' '#1087#1088#1086#1076#1072#1078' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1102' '#1087#1083#1072#1085#1072' '#1087#1088#1086#1076#1072#1078' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084
      FormName = 'TReport_ImplementationPlanEmployeeAllForm'
      FormNameParam.Value = 'TReport_ImplementationPlanEmployeeAllForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Liquidity: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1083#1080#1082#1074#1080#1076#1085#1086#1089#1090#1080
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1083#1080#1082#1074#1080#1076#1085#1086#1089#1090#1080
      FormName = 'TReport_LiquidityForm'
      FormNameParam.Value = 'TReport_LiquidityForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 496
    Top = 24
  end
  inherited StoredProc: TdsdStoredProc
    Left = 48
  end
  inherited ClientDataSet: TClientDataSet
    Left = 104
    Top = 104
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
    Left = 200
  end
  inherited MainMenu: TMainMenu
    Left = 488
    Top = 88
    inherited miGuide: TMenuItem
      object miCommon: TMenuItem
        Action = actGoods
      end
      object miGoods_NDS_diff: TMenuItem
        Action = actGoods_NDS_diff
      end
      object N142: TMenuItem
        Action = actGoods_BarCode
      end
      object miGoodsRetail: TMenuItem
        Action = actGoodsRetail
      end
      object N88: TMenuItem
        Caption = #1058#1086#1074#1072#1088#1099' '#1042#1057#1045
        Hint = #1058#1086#1074#1072#1088#1099
        object N89: TMenuItem
          Action = actGoodsAll
        end
        object N90: TMenuItem
          Action = actGoodsAllRetail
        end
        object N91: TMenuItem
          Action = actGoodsAllJuridical
        end
      end
      object miAdditionalGoods: TMenuItem
        Action = actAdditionalGoods
      end
      object N1: TMenuItem
        Caption = #1050#1086#1076#1099' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
        object miGoodsPartnerCode: TMenuItem
          Action = actGoodsPartnerCode
        end
        object miGoodsPartnerCodeMaster: TMenuItem
          Action = actGoodsPartnerCodeMaster
        end
      end
      object N119: TMenuItem
        Caption = '-'
      end
      object N111: TMenuItem
        Caption = #1057#1086#1094'. '#1087#1088#1086#1077#1082#1090
        object N115: TMenuItem
          Action = actGoodsSP
        end
        object N112: TMenuItem
          Action = actKindOutSP
        end
        object N113: TMenuItem
          Action = actBrandSP
        end
        object N114: TMenuItem
          Action = actIntenalSP
        end
        object N120: TMenuItem
          Action = actPartnerMedical
        end
        object N41: TMenuItem
          Action = actMedicSP
        end
        object N129: TMenuItem
          Action = actMemberSP
        end
        object N139: TMenuItem
          Action = actSPKind
        end
        object N118: TMenuItem
          Caption = '-'
        end
        object N117: TMenuItem
          Action = actReport_CheckSP
        end
        object N13031: TMenuItem
          Action = actReport_SaleSP
        end
        object N134: TMenuItem
          Caption = '-'
        end
        object N70: TMenuItem
          Action = actInvoice
        end
        object miGoodsSPJournal: TMenuItem
          Action = actGoodsSPJournal
        end
      end
      object N103: TMenuItem
        Caption = '-'
      end
      object miUnit: TMenuItem
        Action = actUnit
      end
      object N149: TMenuItem
        Action = actUnit_Object
      end
      object N152: TMenuItem
        Action = actUnit_JuridicalArea
      end
      object N125: TMenuItem
        Action = actUnit_byReportBadm
      end
      object N145: TMenuItem
        Action = actProvinceCity
      end
      object N150: TMenuItem
        Action = actArea
      end
      object N151: TMenuItem
        Action = actJuridicalArea
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object miJuridical: TMenuItem
        Action = actJuridical
      end
      object miContract: TMenuItem
        Action = actContract
      end
      object miContactPerson: TMenuItem
        Action = actContactPerson
      end
      object N64: TMenuItem
        Action = actMaker
        Hint = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1080
      end
      object N107: TMenuItem
        Action = actOrderShedule
      end
      object N16: TMenuItem
        Caption = '-'
      end
      object N17: TMenuItem
        Action = actBank
      end
      object N18: TMenuItem
        Action = actBankAccount
      end
      object N19: TMenuItem
        Action = actReturnType
      end
      object N52: TMenuItem
        Action = actPrice
      end
      object N96: TMenuItem
        Action = actPriceOnDate
      end
      object N53: TMenuItem
        Action = actAlternativeGroup
      end
      object N54: TMenuItem
        Action = actPaidType
      end
      object N62: TMenuItem
        Action = actReportSoldParamsFormOpen
      end
      object N68: TMenuItem
        Action = actReasonDifferences
      end
      object N165: TMenuItem
        Caption = #1062#1077#1085#1099' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
        object miPriceChange: TMenuItem
          Action = actPriceChange
        end
        object miPriceChangeOnDate: TMenuItem
          Action = actPriceChangeOnDate
        end
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object N99: TMenuItem
        Caption = #1044#1080#1089#1082#1086#1085#1090#1085#1099#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
        object miDiscountExternalTools: TMenuItem
          Action = actDiscountExternalTools
        end
        object miDiscountExternalJuridical: TMenuItem
          Action = actDiscountExternalJuridical
        end
        object miDiscountExternal: TMenuItem
          Action = actDiscountExternal
        end
        object N101: TMenuItem
          Action = actDiscountCard
        end
        object N100: TMenuItem
          Action = actBarCode
        end
      end
    end
    object miPersonal: TMenuItem [1]
      Caption = #1055#1077#1088#1089#1086#1085#1072#1083
      object N75: TMenuItem
        Action = actEducation
      end
      object N78: TMenuItem
        Action = actPosition
      end
      object N77: TMenuItem
        Action = actPersonal
      end
      object N76: TMenuItem
        Action = actPersonalGroup
      end
      object N81: TMenuItem
        Action = actMember
      end
      object N140: TMenuItem
        Action = actMemberIncomeCheck
      end
      object N80: TMenuItem
        Caption = '-'
      end
      object N79: TMenuItem
        Action = actCalendar
      end
      object N82: TMenuItem
        Action = actWorkTimeKind
      end
      object N83: TMenuItem
        Action = actSheetWorkTime
      end
      object N87: TMenuItem
        Caption = '-'
      end
      object N86: TMenuItem
        Action = actReport_Wage
      end
    end
    object miLoad: TMenuItem [2]
      Caption = #1047#1072#1075#1088#1091#1079#1082#1080
      object miImportGroup: TMenuItem
        Action = actImportGroup
      end
      object miMovementLoad: TMenuItem
        Action = actMovementLoad
      end
      object miPriceListLoad: TMenuItem
        Action = actPriceListLoad
      end
      object N141: TMenuItem
        Action = actGoodsBarCodeLoad
      end
    end
    object miDocuments: TMenuItem [3]
      Caption = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      object N11: TMenuItem
        Action = actIncome
      end
      object N48: TMenuItem
        Action = actIncomePharmacy
      end
      object N35: TMenuItem
        Action = actReturnOut
      end
      object N49: TMenuItem
        Action = actCheck
      end
      object N66: TMenuItem
        Action = actSaleJournal
      end
      object N72: TMenuItem
        Action = actRepriceJournal
      end
      object miRepriceChangeJournal: TMenuItem
        Action = actRepriceChangeJournal
      end
      object N33: TMenuItem
        Caption = '-'
      end
      object N43: TMenuItem
        Action = actSendOnPrice
      end
      object N42: TMenuItem
        Caption = '-'
      end
      object N12: TMenuItem
        Action = actOrderExternal
      end
      object N13: TMenuItem
        Action = actOrderInternal
      end
      object N14: TMenuItem
        Action = actOrderInternalLite
      end
      object N15: TMenuItem
        Action = actPriceList
      end
      object N55: TMenuItem
        Action = actInventoryJournal
      end
      object N56: TMenuItem
        Action = actLossJournal
      end
      object N57: TMenuItem
        Action = actSendJournal
      end
      object N84: TMenuItem
        Action = actOver
      end
      object N58: TMenuItem
        Action = actCreateOrderFromMCS
      end
    end
    object N36: TMenuItem [4]
      Caption = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      object N32: TMenuItem
        Action = actBankAccountDocument
      end
      object N37: TMenuItem
        Action = actBankLoad
      end
      object N67: TMenuItem
        Action = actPaymentJournal
      end
      object N38: TMenuItem
        Caption = '-'
      end
      object N34: TMenuItem
        Action = actLossDebt
      end
      object N73: TMenuItem
        Action = actChangeIncomePaymentJournal
      end
      object N135: TMenuItem
        Caption = '-'
      end
      object N105: TMenuItem
        Action = actReport_Payment_Plan
        Caption = #1043#1088#1072#1092#1080#1082' '#1087#1088#1086#1075#1085#1086#1079#1080#1088#1091#1077#1084#1099#1093' '#1087#1083#1072#1090#1077#1078#1077#1081
        Hint = ' '#1043#1088#1072#1092#1080#1082' '#1087#1088#1086#1075#1085#1086#1079#1080#1088#1091#1077#1084#1099#1093' '#1087#1083#1072#1090#1077#1078#1077#1081
      end
    end
    object miReports: TMenuItem [5]
      Caption = #1054#1090#1095#1077#1090#1099
      object miBalance: TMenuItem
        Action = actBalance
      end
      object miReportGoodsOrder: TMenuItem
        Action = actReportGoodsOrder
        Caption = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1086#1090' '#1079#1072#1082#1072#1079#1072' '#1076#1086' '#1087#1088#1086#1076#1072#1078#1080
      end
      object miSearchGoods: TMenuItem
        Action = actSearchGoods
      end
      object N60: TMenuItem
        Action = actChoiceGoodsFromRemains
      end
      object mniReport_Movement_ByPartionGoodsForm: TMenuItem
        Action = actReport_Movement_ByPartionGoodsForm
      end
      object N39: TMenuItem
        Caption = '-'
      end
      object miReport_JuridicalSold: TMenuItem
        Action = actReport_JuridicalSold
      end
      object miReport_JuridicalCollation: TMenuItem
        Action = actReport_JuridicalCollation
      end
      object miReport_GoodRemains: TMenuItem
        Action = actReport_GoodRemains
      end
      object N144: TMenuItem
        Action = actReport_GoodsRemainsLight
      end
      object miReport_GoodsRemainsCurrent: TMenuItem
        Action = actReport_GoodsRemainsCurrent
      end
      object miReportMovementCheckForm: TMenuItem
        Action = actReportMovementCheckForm
      end
      object miReportMovementCheckFarmForm: TMenuItem
        Action = actReportMovementCheckFarmForm
      end
      object miReportMovementCheckFLForm: TMenuItem
        Action = actReportMovementCheckFLForm
      end
      object N143: TMenuItem
        Action = actReportMovementCheckLight
      end
      object N146: TMenuItem
        Action = actReport_Check_Assortment
      end
      object N106: TMenuItem
        Action = actReport_MovementCheckErrorForm
      end
      object miReportMovementIncomeForm: TMenuItem
        Action = actReportMovementIncomeForm
      end
      object N51: TMenuItem
        Action = actReportMovementIncomeFarmForm
      end
      object miReport_GoodsPartionMoveForm: TMenuItem
        Action = actReport_GoodsPartionMoveForm
      end
      object miReport_GoodsPartionHistoryForm: TMenuItem
        Action = actReport_GoodsPartionHistoryForm
      end
      object miReport_SoldForm: TMenuItem
        Action = actReport_SoldForm
      end
      object miReport_Sold_DayForm: TMenuItem
        Action = actReport_Sold_DayForm
      end
      object miReport_Sold_DayUserForm: TMenuItem
        Action = actReport_Sold_DayUserForm
      end
      object miReport_LiquidForm: TMenuItem
        Action = actReport_LiquidForm
      end
      object N104: TMenuItem
        Action = actReport_MovementCheckUnLiquid
      end
      object miReport_RemainsOverGoods: TMenuItem
        Action = actReport_RemainsOverGoods
      end
      object N130: TMenuItem
        Action = actReport_RemainsOverGoods_To
      end
      object miOverSettings: TMenuItem
        Action = actOverSettings
      end
    end
    object N40: TMenuItem [6]
      Caption = #1041#1040#1048
      Hint = #1041#1083#1086#1082' '#1072#1085#1072#1083#1080#1090#1080#1095#1077#1089#1082#1080#1093' '#1080#1089#1089#1083#1077#1076#1086#1074#1072#1085#1080#1081
      object miReport_ProfitForm: TMenuItem
        Action = actReport_ProfitForm
      end
      object miReport_PriceInterventionForm: TMenuItem
        Action = actReport_PriceInterventionForm
      end
      object N59: TMenuItem
        Action = actReport_PriceIntervention2
      end
      object N63: TMenuItem
        Action = actReportMovementCheckMiddleForm
      end
      object N153: TMenuItem
        Action = actReport_CheckMiddle_Detail
      end
      object N138: TMenuItem
        Caption = '-'
      end
      object N137: TMenuItem
        Action = actReport_MovementPriceList_Cross
      end
      object N148: TMenuItem
        Caption = '-'
      end
      object N147: TMenuItem
        Action = actReport_OverOrder
      end
      object miReportMovementCheckGrowthAndFalling: TMenuItem
        Action = actReportMovementCheckGrowthAndFalling
      end
      object N156: TMenuItem
        Action = actReport_Check_UKTZED
      end
      object N155: TMenuItem
        Caption = '-'
      end
      object N154: TMenuItem
        Action = actMarginCategory_Movement
      end
      object N164: TMenuItem
        Action = actReport_Liquidity
      end
      object miReport_Check_PriceChange: TMenuItem
        Action = actReport_Check_PriceChange
      end
    end
    object N131: TMenuItem [7]
      Caption = #1052#1072#1088#1082#1077#1090#1080#1085#1075
      object miReport_MovementCheck_Cross: TMenuItem
        Action = actReport_MovementCheck_Cross
      end
      object miReport_MovementCheckFarm_Cross: TMenuItem
        Action = actReport_MovementCheckFarm_Cross
      end
      object N108: TMenuItem
        Action = actReport_MovementIncome_Promo
      end
      object N109: TMenuItem
        Action = actReport_MovementCheck_Promo
      end
      object N110: TMenuItem
        Action = actReport_CheckPromo
      end
      object N136: TMenuItem
        Action = actReport_CheckPromoFarm
      end
      object N2: TMenuItem
        Action = actReport_Analysis_Remains_Selling
      end
      object N116: TMenuItem
        Action = actReport_IncomeConsumptionBalance
      end
      object N163: TMenuItem
        Action = actReport_ImplementationPlanEmployeeAll
      end
      object N3: TMenuItem
        Action = actReport_ImplementationPlanEmployee
      end
      object N132: TMenuItem
        Caption = '-'
      end
      object N65: TMenuItem
        Action = actPromo
      end
      object N128: TMenuItem
        Action = actPromoUnit
      end
      object N122: TMenuItem
        Action = actReportPromoParams
      end
      object N124: TMenuItem
        Action = actReport_Check_Rating
      end
      object N133: TMenuItem
        Caption = '-'
      end
      object N157: TMenuItem
        Caption = #1055#1088#1086#1084#1086' '#1082#1086#1076#1099
        Hint = #1055#1088#1086#1084#1086' '#1082#1086#1076#1099
        object N159: TMenuItem
          Action = actPromoCode
        end
        object N161: TMenuItem
          Caption = '-'
        end
        object N160: TMenuItem
          Action = actPromoCodeMovement
        end
      end
      object N158: TMenuItem
        Caption = '-'
      end
      object N123: TMenuItem
        Action = actReport_MinPrice_onGoods
      end
      object N69: TMenuItem
        Caption = '-'
      end
      object miReport_UploadBaDMForm: TMenuItem
        Action = actReport_UploadBaDMForm
      end
      object miReport_UploadOptimaForm: TMenuItem
        Action = actReport_UploadOptimaForm
      end
      object N126: TMenuItem
        Action = actReport_Badm
      end
    end
    inherited miService: TMenuItem
      inherited miServiceGuide: TMenuItem
        object miNDSKind: TMenuItem [0]
          Action = actNDSKind
        end
        object miOrderKind: TMenuItem [1]
          Action = actOrderKind
        end
        object miMeasure: TMenuItem [2]
          Action = actMeasure
        end
        object miRetail: TMenuItem [3]
          Action = actRetail
        end
        object N121: TMenuItem [4]
          Action = actConditionsKeep
        end
        object N8: TMenuItem [5]
          Caption = '-'
        end
        object N50: TMenuItem [6]
          Action = actCashRegister
        end
        object N20: TMenuItem [7]
          Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
          object N21: TMenuItem
            Action = actAccountGroup
          end
          object N22: TMenuItem
            Action = actAccountDirection
          end
          object N23: TMenuItem
            Action = actAccount
          end
          object N24: TMenuItem
            Caption = '-'
          end
          object N25: TMenuItem
            Action = actInfoMoneyGroup
          end
          object N26: TMenuItem
            Action = actInfoMoneyDestination
          end
          object N27: TMenuItem
            Action = actInfoMoney
          end
          object N28: TMenuItem
            Caption = '-'
          end
          object N29: TMenuItem
            Action = actProfitLossGroup
          end
          object N30: TMenuItem
            Action = actProfitLossDirection
          end
          object N31: TMenuItem
            Action = actProfitLoss
          end
        end
        object N6: TMenuItem [8]
          Caption = '-'
        end
        object N97: TMenuItem [9]
          Action = actColor
        end
        object N74: TMenuItem [10]
          Action = actForms
        end
        object miTest: TMenuItem
          Action = actTestFormOpen
        end
        object N162: TMenuItem
          Caption = '-'
        end
        object miFiscal: TMenuItem
          Action = actFiscal
        end
      end
      object N44: TMenuItem [1]
        Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1086#1082
        object N45: TMenuItem
          Action = actMarginCategory
        end
        object N46: TMenuItem
          Action = actMarginCategoryItem
        end
        object N47: TMenuItem
          Action = actMarginCategoryLink
        end
        object N127: TMenuItem
          Action = actMarginCategory_Cross
          Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1086#1082' ('#1054#1073#1097#1080#1081')'
        end
      end
      object miUser: TMenuItem [2]
        Action = actUser
      end
      object miRole: TMenuItem [3]
        Action = actRole
      end
      object N85: TMenuItem [4]
        Action = actRoleUnion
      end
      object miSetDefault: TMenuItem [5]
        Action = actSetDefault
      end
      object N92: TMenuItem [6]
        Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1055#1086#1095#1090#1099
        object N93: TMenuItem
          Action = actEmailSettings
        end
        object N94: TMenuItem
          Action = actEmailKind
        end
        object N95: TMenuItem
          Action = actEmailTools
        end
        object N71: TMenuItem
          Action = actEmail
        end
      end
      object miGoodsCommon: TMenuItem [7]
        Action = actGoodsMain
      end
      object N61: TMenuItem [8]
        Action = actGoodsOnUnit_ForSite
      end
      object N98: TMenuItem [9]
        Action = actConfirmedKind
      end
      object ID1: TMenuItem [10]
        Action = actReport_GoodsRemains_AnotherRetail
      end
      object N7: TMenuItem [11]
        Caption = '-'
      end
      object miSaveData: TMenuItem [12]
        Action = actSaveData
      end
      object miPriceGroupSettings: TMenuItem [13]
        Action = actPriceGroupSettings
      end
      object N102: TMenuItem [14]
        Action = actPriceGroupSettingsTOP
      end
      object miJuridicalSettings: TMenuItem [15]
        Action = actJuridicalSettings
      end
      object N9: TMenuItem [16]
        Caption = '-'
      end
      object miImportType: TMenuItem [17]
        Action = actImportType
      end
      object miImportSettings: TMenuItem [18]
        Action = actImportSettings
      end
      object miImportExportLink: TMenuItem [19]
        Action = actImportExportLink
      end
      object FarmacyCash1: TMenuItem [21]
        Action = actUnitForFarmacyCash
      end
      object N10: TMenuItem [23]
        Caption = '-'
      end
      object miReprice: TMenuItem [24]
        Caption = #1055#1077#1088#1077#1086#1094#1077#1085#1082#1072
        OnClick = miRepriceClick
      end
      object miRepriceChange: TMenuItem [25]
        Caption = #1055#1077#1088#1077#1086#1094#1077#1085#1082#1072' '#1094#1077#1085' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
        OnClick = miRepriceChangeClick
      end
      object miExportSalesForSupp: TMenuItem [26]
        Action = actExportSalesForSuppClick
      end
    end
  end
end
