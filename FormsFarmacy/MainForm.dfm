inherited MainForm: TMainForm
  ClientHeight = 151
  ClientWidth = 689
  ExplicitWidth = 697
  ExplicitHeight = 185
  PixelsPerInch = 96
  TextHeight = 13
  inherited dxBarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
    inherited dxBar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbGuides'
        end
        item
          Visible = True
          ItemName = 'bbLoad'
        end
        item
          Visible = True
          ItemName = 'bbDocuments'
        end
        item
          Visible = True
          ItemName = 'bbService'
        end
        item
          Visible = True
          ItemName = 'bbExit'
        end>
    end
    inherited bbService: TdxBarSubItem
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbUser'
        end
        item
          Visible = True
          ItemName = 'bbRole'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbNDSKind'
        end
        item
          Visible = True
          ItemName = 'bbRetail'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbImportType'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbAbout'
        end
        item
          Visible = True
          ItemName = 'bbUpdateProgramm'
        end>
    end
    inherited bbGuides: TdxBarSubItem
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbGoods'
        end
        item
          Visible = True
          ItemName = 'bbUnit'
        end
        item
          Visible = True
          ItemName = 'bbJuridical'
        end
        item
          Visible = True
          ItemName = 'bbContract'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbMeasure'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbExtraChargeCategories'
        end>
    end
    object bbDocuments: TdxBarSubItem [6]
      Caption = #1053#1072#1082#1083#1072#1076#1085#1099#1077
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbIncome'
        end
        item
          Visible = True
          ItemName = 'bbOrderExtrnal'
        end
        item
          Visible = True
          ItemName = 'bbOrderInternal'
        end
        item
          Visible = True
          ItemName = 'bbPriceList'
        end>
    end
    object bbMeasure: TdxBarButton [7]
      Action = actMeasure
      Category = 0
    end
    object bbJuridicalGroup: TdxBarButton [8]
      Action = actJuridicalGroup
      Category = 0
    end
    object bbGoodsProperty: TdxBarButton [9]
      Action = actGoodsProperty
      Category = 0
    end
    object bbJuridical: TdxBarButton [10]
      Action = actJuridical
      Category = 0
    end
    object bbBusiness: TdxBarButton [11]
      Action = actBusiness
      Category = 0
    end
    object bbBranch: TdxBarButton [12]
      Action = actExtraChargeCategories
      Category = 0
    end
    object bbIncome: TdxBarButton [13]
      Action = actIncome
      Category = 0
    end
    object bbPartner: TdxBarButton [14]
      Action = actPartner
      Category = 0
    end
    object dxBarSeparator1: TdxBarSeparator [15]
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
    object bbPaidKind: TdxBarButton [16]
      Action = actPaidKind
      Category = 0
    end
    object bbContractKind: TdxBarButton [17]
      Action = actContractKind
      Category = 0
    end
    object bbUnitGroup: TdxBarButton [18]
      Action = actUnitGroup
      Category = 0
    end
    object bbUnit: TdxBarButton [19]
      Action = actUnit
      Category = 0
    end
    object bbGoodsGroup: TdxBarButton [20]
      Action = actGoodsGroup
      Category = 0
    end
    object bbGoods: TdxBarButton [21]
      Action = actGoods
      Category = 0
    end
    object bbGoodsKind: TdxBarButton [22]
      Action = actGoodsKind
      Category = 0
    end
    object bbBalance: TdxBarButton [23]
      Action = actBalance
      Category = 0
    end
    object bbReports: TdxBarSubItem [24]
      Caption = #1054#1090#1095#1077#1090#1099
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbBalance'
        end>
    end
    object bbExtraChargeCategories: TdxBarButton [25]
      Action = actExtraChargeCategories
      Category = 0
    end
    object bbLoad: TdxBarSubItem
      Caption = #1047#1072#1075#1088#1091#1079#1082#1080
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbPriceListLoad'
        end>
    end
    object bbContract: TdxBarButton
      Action = actContract
      Category = 0
    end
    object bbOrderExtrnal: TdxBarButton
      Action = actOrderExternal
      Category = 0
    end
    object bbPriceList: TdxBarButton
      Action = actPriceList
      Category = 0
    end
    object bbOrderInternal: TdxBarButton
      Action = actOrderInternal
      Category = 0
    end
    object bbNDSKind: TdxBarButton
      Action = actNDSKind
      Category = 0
    end
    object bbRetail: TdxBarButton
      Action = actRetail
      Category = 0
    end
    object bbUser: TdxBarButton
      Action = actUser
      Category = 0
    end
    object bbRole: TdxBarButton
      Action = actRole
      Category = 0
    end
    object bbImportType: TdxBarButton
      Action = actImportType
      Category = 0
    end
  end
  inherited ActionList: TActionList
    object actPriceList: TdsdOpenForm [0]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
      FormName = 'TPriceListJournalForm'
      FormNameParam.Value = 'TPriceListJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actRetail: TdsdOpenForm [2]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1058#1086#1088#1075#1086#1074#1099#1077' '#1089#1077#1090#1080
      FormName = 'TRetailForm'
      FormNameParam.Value = 'TRetailForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actUser: TdsdOpenForm [4]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080
      FormName = 'TUserForm'
      FormNameParam.Value = 'TUserForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actImportType: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1058#1080#1087#1099' '#1080#1084#1087#1086#1088#1090#1072
      Hint = #1058#1080#1087#1099' '#1080#1084#1087#1086#1088#1090#1072
      FormName = 'TImportTypeForm'
      FormNameParam.Value = 'TImportTypeForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actMeasure: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1045#1076#1080#1085#1080#1094#1099' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
      Hint = #1045#1076#1080#1085#1080#1094#1099' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
      FormName = 'TMeasureForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actExtraChargeCategories: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1086#1082
      Hint = #1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1086#1082
      FormName = 'TExtraChargeCategoriesForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actJuridicalGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1099' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1080#1093' '#1083#1080#1094
      Hint = #1043#1088#1091#1087#1087#1099' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1080#1093' '#1083#1080#1094
      FormName = 'TJuridicalGroupForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actBusiness: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1041#1080#1079#1085#1077#1089#1099
      Hint = #1041#1080#1079#1085#1077#1089#1099
      FormName = 'TBusinessForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actContractKind: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1042#1080#1076#1099' '#1076#1086#1075#1086#1074#1086#1088#1086#1074
      Hint = #1042#1080#1076#1099' '#1076#1086#1075#1086#1074#1086#1088#1086#1074
      FormName = 'TContractKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actUnitGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1099' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081
      Hint = #1043#1088#1091#1087#1087#1099' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081
      FormName = 'TUnitGroupForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actUnit: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
      Hint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
      FormName = 'TUnitForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1099' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1043#1088#1091#1087#1087#1099' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TGoodsGroupForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actGoods: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TGoodsForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsKind: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1042#1080#1076#1099' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1042#1080#1076#1099' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsProperty: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088#1099' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TGoodsPropertyForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPaidKind: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1042#1080#1076#1099' '#1092#1086#1088#1084' '#1086#1087#1083#1072#1090#1099
      Hint = #1042#1080#1076#1099' '#1092#1086#1088#1084' '#1086#1087#1083#1072#1090#1099
      FormName = 'TPaidKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actBank: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1041#1072#1085#1082#1080
      Hint = #1041#1072#1085#1082#1080
      FormName = 'TBankForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actBankAccount: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1077' '#1089#1095#1077#1090#1072
      Hint = #1056#1072#1089#1095#1077#1090#1085#1099#1077' '#1089#1095#1077#1090#1072
      FormName = 'TBankAccountForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actJuridical: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      Hint = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      FormName = 'TJuridicalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actIncome: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1080#1093#1086#1076#1085#1099#1077' '#1085#1072#1082#1083#1072#1076#1085#1099#1077
      FormName = 'TIncomeJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPartner: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099
      Hint = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099
      FormName = 'TPartnerForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actCash: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1099
      Hint = #1050#1072#1089#1089#1099
      FormName = 'TCashForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actCurrency: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1042#1072#1083#1102#1090#1099
      Hint = #1042#1072#1083#1102#1090#1099
      FormName = 'TCurrencyForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actBalance: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1041#1072#1083#1072#1085#1089
      FormName = 'TBalanceForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPriceListLoad: TdsdOpenForm
      Category = #1047#1072#1075#1088#1091#1079#1082#1080
      MoveParams = <>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1086#1074
      FormName = 'TPriceListLoadForm'
      FormNameParam.Value = 'TPriceListLoadForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actContract: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1044#1086#1075#1086#1074#1086#1088#1072
      Hint = #1044#1086#1075#1086#1074#1086#1088#1072
      FormName = 'TContractForm'
      FormNameParam.Value = 'TContractForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actOrderExternal: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1047#1072#1103#1074#1082#1080' '#1074#1085#1077#1096#1085#1080#1077
      FormName = 'TOrderExternalJournalForm'
      FormNameParam.Value = 'TOrderExternalJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actOrderInternal: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1047#1072#1103#1074#1082#1080' '#1074#1085#1091#1090#1088#1077#1085#1085#1080#1077
      FormName = 'TOrderInternalJournalForm'
      FormNameParam.Value = 'TOrderInternalJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actNDSKind: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1042#1080#1076#1099' '#1053#1044#1057
      FormName = 'TNDSKindForm'
      FormNameParam.Value = 'TNDSKindForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actRole: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1056#1086#1083#1080
      FormName = 'TRoleForm'
      FormNameParam.Value = 'TRoleForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
  end
  inherited cxLocalizer: TcxLocalizer
    Top = 40
  end
  inherited StoredProc: TdsdStoredProc
    Left = 48
  end
  inherited ClientDataSet: TClientDataSet
    Left = 104
    Top = 104
  end
  object bbPriceListLoad: TdxBarButton
    Action = actPriceListLoad
    Category = -1
  end
end
