inherited MainForm: TMainForm
  Caption = #1056#1072#1073#1086#1090#1072' '#1089' '#1079#1072#1082#1072#1079#1072#1084#1080
  ClientHeight = 166
  ClientWidth = 672
  KeyPreview = True
  ExplicitWidth = 680
  ExplicitHeight = 193
  PixelsPerInch = 96
  TextHeight = 13
  inherited dxBarManager: TdxBarManager
    Style = bmsFlat
    Left = 152
    Top = 56
    DockControlHeights = (
      0
      0
      22
      0)
    inherited dxBar: TdxBar
      BorderStyle = bbsNone
      FloatLeft = 580
      FloatTop = 708
      FloatClientWidth = 83
      FloatClientHeight = 117
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
          ItemName = 'bbReports'
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
          ItemName = 'bbGoodsCommon'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
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
          ItemName = 'bbSetDefault'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbSaveData'
        end
        item
          Visible = True
          ItemName = 'bbPriceGroupSettings'
        end
        item
          Visible = True
          ItemName = 'bbJuridicalSettings'
        end
        item
          Visible = True
          ItemName = 'bbJuridicalSettingsPriceList'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbMeasure'
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
          ItemName = 'bbOrderKind'
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
          ItemName = 'bbImportSettings'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbUserProtocol'
        end
        item
          Visible = True
          ItemName = 'bbLookAndFillSettings'
        end
        item
          Visible = True
          ItemName = 'bbAbout'
        end
        item
          Visible = True
          ItemName = 'bbUpdateProgramm'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbTest'
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
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1086#1082
      Category = 0
      Hint = #1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1086#1082
      Visible = ivAlways
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
    object bbGoodsKind: TdxBarButton [21]
      Action = actGoodsKind
      Category = 0
    end
    object bbBalance: TdxBarButton [22]
      Action = actBalance
      Category = 0
    end
    object bbGoodsCommon: TdxBarButton [23]
      Action = actGoodsMain
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
        end
        item
          Visible = True
          ItemName = 'bbReportOrderGoods'
        end
        item
          Visible = True
          ItemName = 'bbGoodsSearch'
        end>
    end
    object bbExtraChargeCategories: TdxBarButton [25]
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1086#1082
      Category = 0
      Hint = #1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1086#1082
      Visible = ivAlways
    end
    object bbLoad: TdxBarSubItem [27]
      Caption = #1047#1072#1075#1088#1091#1079#1082#1080
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbLoadLoad'
        end
        item
          Visible = True
          ItemName = 'bbMovementLoad'
        end
        item
          Visible = True
          ItemName = 'bbPriceListLoad'
        end>
    end
    object bbContract: TdxBarButton [28]
      Action = actContract
      Category = 0
    end
    object bbOrderExtrnal: TdxBarButton [29]
      Action = actOrderExternal
      Category = 0
    end
    object bbPriceList: TdxBarButton [30]
      Action = actPriceList
      Category = 0
    end
    object bbOrderInternal: TdxBarButton [31]
      Action = actOrderInternal
      Category = 0
    end
    object bbNDSKind: TdxBarButton [32]
      Action = actNDSKind
      Category = 0
    end
    object bbRetail: TdxBarButton [33]
      Action = actRetail
      Category = 0
    end
    object bbUser: TdxBarButton [34]
      Action = actUser
      Category = 0
    end
    object bbRole: TdxBarButton [35]
      Action = actRole
      Category = 0
    end
    inherited bbGuides: TdxBarSubItem
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbCommon'
        end
        item
          Visible = True
          ItemName = 'bbAlternativeGoodsCodeForm'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbUnit'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
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
          ItemName = 'bbContactPerson'
        end>
    end
    object bbMovementLoad: TdxBarButton [38]
      Action = actMovementLoad
      Category = 0
    end
    object bbAlternativeGoodsCodeForm: TdxBarButton [39]
      Action = actAdditionalGoods
      Category = 0
    end
    object bbTest: TdxBarButton [40]
      Action = actTestFormOpen
      Category = 0
    end
    object bbSetDefault: TdxBarButton [41]
      Action = actSetDefault
      Category = 0
    end
    object bbCommon: TdxBarButton [42]
      Action = actGoods
      Category = 0
    end
    object bbGoodsPartnerCode: TdxBarButton [43]
      Action = actGoodsPartnerCode
      Category = 0
    end
    object bbGoodsPartnerCodeMaster: TdxBarButton [44]
      Action = actGoodsPartnerCodeMaster
      Category = 0
    end
    object dxBarSubItem1: TdxBarSubItem [45]
      Caption = #1050#1086#1076#1099' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbGoodsPartnerCode'
        end
        item
          Visible = True
          ItemName = 'bbGoodsPartnerCodeMaster'
        end>
    end
    object bbPriceGroupSettings: TdxBarButton [46]
      Action = actPriceGroupSettings
      Category = 0
    end
    object bbJuridicalSettings: TdxBarButton [47]
      Action = actJuridicalSettings
      Category = 0
    end
    object bbUserProtocol: TdxBarButton [48]
      Action = actProtocolUser
      Category = 0
    end
    object bbSaveData: TdxBarButton [50]
      Action = actSaveData
      Category = 0
    end
    object bbContactPerson: TdxBarButton [51]
      Action = actContactPerson
      Category = 0
    end
    object bbJuridicalSettingsPriceList: TdxBarButton [52]
      Action = actJuridicalSettingsPriceList
      Category = 0
    end
    object bbGoodsSearch: TdxBarButton [53]
      Action = actSearchGoods
      Category = 0
    end
    object bbReportOrderGoods: TdxBarButton
      Action = actReportGoodsOrder
      Category = 0
    end
    object bbOrderKind: TdxBarButton
      Action = actOrderKind
      Category = 0
    end
  end
  inherited ActionList: TActionList
    Left = 240
    Top = 56
    object actReportGoodsOrder: TdsdOpenForm [0]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1074' '#1079#1072#1103#1074#1082#1072#1093
      Hint = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1074' '#1079#1072#1103#1074#1082#1072#1093
      ShortCut = 120
      FormName = 'TReportOrderGoodsForm'
      FormNameParam.Value = 'TReportOrderGoodsForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPriceList: TdsdOpenForm [1]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
      FormName = 'TPriceListJournalForm'
      FormNameParam.Value = 'TPriceListJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actMovementLoad: TdsdOpenForm [3]
      Category = #1047#1072#1075#1088#1091#1079#1082#1080
      MoveParams = <>
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1075#1088#1091#1079#1082#1080
      Hint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1075#1088#1091#1079#1082#1080
      FormName = 'TMovementLoadForm'
      FormNameParam.Value = 'TMovementLoadForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actRetail: TdsdOpenForm [4]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1058#1086#1088#1075#1086#1074#1099#1077' '#1089#1077#1090#1080
      FormName = 'TRetailForm'
      FormNameParam.Value = 'TRetailForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actSetDefault: TdsdOpenForm [5]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1044#1077#1092#1086#1083#1090#1099' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081
      Hint = #1044#1077#1092#1086#1083#1090#1099' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081
      FormName = 'TSetUserDefaultsForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actOrderKind: TdsdOpenForm [6]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1042#1080#1076' '#1079#1072#1082#1072#1079#1072
      Hint = #1042#1080#1076' '#1079#1072#1082#1072#1079#1072
      FormName = 'TOrderKindForm'
      FormNameParam.Value = 'TOrderKindForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actGoods: TdsdOpenForm [10]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' '#1089#1077#1090#1080
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TGoodsForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actUser: TdsdOpenForm [11]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080
      FormName = 'TUserForm'
      FormNameParam.Value = 'TUserForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actProtocolUser: TdsdOpenForm [14]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081
      Hint = #1055#1088#1086#1090#1086#1082#1086#1083' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081
      FormName = 'TUserProtocolForm'
      FormNameParam.Value = 'TUserProtocolForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actMeasure: TdsdOpenForm [15]
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
    object actJuridicalGroup: TdsdOpenForm [16]
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
    object actBusiness: TdsdOpenForm [17]
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
    object actContractKind: TdsdOpenForm [18]
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
    object actUnitGroup: TdsdOpenForm [19]
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
    object actUnit: TdsdOpenForm [20]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
      Hint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
      FormName = 'TUnitTreeForm'
      FormNameParam.Value = 'TUnitTreeForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsGroup: TdsdOpenForm [21]
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
    object actGoodsMain: TdsdOpenForm [22]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' '#1086#1073#1098#1077#1076#1080#1085#1077#1085#1085#1099#1081
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TGoodsMainForm'
      FormNameParam.Value = 'TGoodsMainForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actContactPerson: TdsdOpenForm [23]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1086#1085#1090#1072#1082#1090#1085#1099#1077' '#1083#1080#1094#1072
      FormName = 'TContactPersonForm'
      FormNameParam.Value = 'TContactPersonForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actContract: TdsdOpenForm [24]
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
    object actGoodsKind: TdsdOpenForm [25]
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
    object actGoodsProperty: TdsdOpenForm [26]
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
    object actPaidKind: TdsdOpenForm [27]
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
    object actBank: TdsdOpenForm [28]
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
    object actBankAccount: TdsdOpenForm [29]
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
    object actJuridical: TdsdOpenForm [30]
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
    object actIncome: TdsdOpenForm [31]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1080#1093#1086#1076#1085#1099#1077' '#1085#1072#1082#1083#1072#1076#1085#1099#1077
      FormName = 'TIncomeJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPartner: TdsdOpenForm [32]
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
    object actCash: TdsdOpenForm [33]
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
    object actCurrency: TdsdOpenForm [34]
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
    object actBalance: TdsdOpenForm [35]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1041#1072#1083#1072#1085#1089
      FormName = 'TBalanceForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPriceListLoad: TdsdOpenForm [36]
      Category = #1047#1072#1075#1088#1091#1079#1082#1080
      MoveParams = <>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1086#1074
      FormName = 'TPriceListLoadForm'
      FormNameParam.Value = 'TPriceListLoadForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actOrderExternal: TdsdOpenForm [37]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1047#1072#1103#1074#1082#1080' '#1074#1085#1077#1096#1085#1080#1077
      FormName = 'TOrderExternalJournalForm'
      FormNameParam.Value = 'TOrderExternalJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actOrderInternal: TdsdOpenForm [38]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1047#1072#1103#1074#1082#1080' '#1074#1085#1091#1090#1088#1077#1085#1085#1080#1077
      FormName = 'TOrderInternalJournalForm'
      FormNameParam.Value = 'TOrderInternalJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actNDSKind: TdsdOpenForm [39]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1042#1080#1076#1099' '#1053#1044#1057
      FormName = 'TNDSKindForm'
      FormNameParam.Value = 'TNDSKindForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actRole: TdsdOpenForm [40]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1056#1086#1083#1080
      FormName = 'TRoleForm'
      FormNameParam.Value = 'TRoleForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actAdditionalGoods: TdsdOpenForm [41]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1044#1086#1087#1086#1083#1085#1103#1102#1097#1080#1077' '#1090#1086#1074#1072#1088#1099
      FormName = 'TAdditionalGoodsForm'
      FormNameParam.Value = 'TAdditionalGoodsForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actTestFormOpen: TdsdOpenForm [42]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = 'actTestFormOpen'
      FormName = 'TTestForm'
      FormNameParam.Value = 'TTestForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsPartnerCode: TdsdOpenForm [43]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
      FormName = 'TGoodsPartnerCodeForm'
      FormNameParam.Value = 'TGoodsPartnerCodeForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsPartnerCodeMaster: TdsdOpenForm [44]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1085#1072#1096
      FormName = 'TGoodsPartnerCodeMasterForm'
      FormNameParam.Value = 'TGoodsPartnerCodeMasterForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPriceGroupSettings: TdsdOpenForm [45]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1080' '#1076#1083#1103' '#1094#1077#1085#1086#1074#1099#1093' '#1075#1088#1091#1087#1087
      FormName = 'TPriceGroupSettingsForm'
      FormNameParam.Value = 'TPriceGroupSettingsForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actJuridicalSettings: TdsdOpenForm [46]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1080' '#1076#1083#1103' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1080#1093' '#1083#1080#1094
      FormName = 'TJuridicalSettingsForm'
      FormNameParam.Value = 'TJuridicalSettingsForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actJuridicalSettingsPriceList: TdsdOpenForm [47]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1047#1072#1082#1088#1099#1090#1080#1077' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1086#1074
      FormName = 'TJuridicalSettingsPriceListForm'
      FormNameParam.Value = 'TJuridicalSettingsPriceListForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actSaveData: TAction [48]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093
      OnExecute = actSaveDataExecute
    end
    object actSearchGoods: TdsdOpenForm [49]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1074' '#1087#1088#1072#1081#1089' - '#1083#1080#1089#1090#1072#1093
      ShortCut = 123
      SecondaryShortCuts.Strings = (
        'Ctrl++')
      FormName = 'TChoiceGoodsFromPriceListForm'
      FormNameParam.Value = 'TChoiceGoodsFromPriceListForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
  end
  inherited cxLocalizer: TcxLocalizer
    Top = 40
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
  object bbPriceListLoad: TdxBarButton
    Action = actPriceListLoad
    Category = -1
    Left = 16
    Top = 64
  end
end
