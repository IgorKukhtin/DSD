object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1081' '#1059#1095#1077#1090' '#171'Project'#187
  ClientHeight = 350
  ClientWidth = 838
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
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
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 128
    Top = 48
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManager1Bar1: TdxBar
      Caption = 'MainMenu'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 683
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      IsMainMenu = True
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbGoodsDocuments'
        end
        item
          Visible = True
          ItemName = 'bbFinanceDocuments'
        end
        item
          Visible = True
          ItemName = 'bbTransportDocuments'
        end
        item
          Visible = True
          ItemName = 'bbPersonalDocuments'
        end
        item
          Visible = True
          ItemName = 'bbHistory'
        end
        item
          Visible = True
          ItemName = 'bbGuides'
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
      MultiLine = True
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = True
    end
    object bbExit: TdxBarButton
      Action = actExit
      Category = 0
    end
    object bbGoodsDocuments: TdxBarSubItem
      Caption = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbIncome'
        end
        item
          Visible = True
          ItemName = 'bbReturnOut'
        end
        item
          Visible = True
          ItemName = 'bbSendOnPrice'
        end
        item
          Visible = True
          ItemName = 'bbSend'
        end
        item
          Visible = True
          ItemName = 'bbSale'
        end
        item
          Visible = True
          ItemName = 'bbReturnIn'
        end
        item
          Visible = True
          ItemName = 'bbLoss'
        end
        item
          Visible = True
          ItemName = 'bbInventory'
        end
        item
          Visible = True
          ItemName = 'bbProductionSeparate'
        end
        item
          Visible = True
          ItemName = 'bbProductionUnion'
        end
        item
          Visible = True
          ItemName = 'bbZakazExternal'
        end
        item
          Visible = True
          ItemName = 'bbZakazInternal'
        end>
    end
    object bbGuides: TdxBarSubItem
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbJuridicalGroup'
        end
        item
          Visible = True
          ItemName = 'bbJuridical'
        end
        item
          Visible = True
          ItemName = 'bbPartner'
        end
        item
          Visible = True
          ItemName = 'bbRouteSorting'
        end
        item
          Visible = True
          ItemName = 'bbGuides_Separator'
        end
        item
          Visible = True
          ItemName = 'bbPaidKind'
        end
        item
          Visible = True
          ItemName = 'bbGuides_Separator'
        end
        item
          Visible = True
          ItemName = 'bbContractKind'
        end
        item
          Visible = True
          ItemName = 'bbContract'
        end
        item
          Visible = True
          ItemName = 'bbGuides_Separator'
        end
        item
          Visible = True
          ItemName = 'bbAsset'
        end
        item
          Visible = True
          ItemName = 'bbBusiness'
        end
        item
          Visible = True
          ItemName = 'bbBranch'
        end
        item
          Visible = True
          ItemName = 'bbUnit'
        end
        item
          Visible = True
          ItemName = 'bbCash'
        end
        item
          Visible = True
          ItemName = 'bbBank'
        end
        item
          Visible = True
          ItemName = 'bbBankAccount'
        end
        item
          Visible = True
          ItemName = 'bbCurrency'
        end
        item
          Visible = True
          ItemName = 'bbGuides_Separator'
        end
        item
          Visible = True
          ItemName = 'bbGoodsGroup'
        end
        item
          Visible = True
          ItemName = 'bbGoods'
        end
        item
          Visible = True
          ItemName = 'bbGoodsKind'
        end
        item
          Visible = True
          ItemName = 'bbMeasure'
        end
        item
          Visible = True
          ItemName = 'bbGoodsProperty'
        end
        item
          Visible = True
          ItemName = 'bbTradeMark'
        end
        item
          Visible = True
          ItemName = 'bbPriceList'
        end
        item
          Visible = True
          ItemName = 'bbGuides_Separator'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem'
        end>
    end
    object bbGuides_Separator: TdxBarSeparator
      Caption = 'bbGuides_Separator'
      Category = 0
      Hint = 'bbGuides_Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbMeasure: TdxBarButton
      Action = actMeasure
      Category = 0
    end
    object bbJuridicalGroup: TdxBarButton
      Action = actJuridicalGroup
      Category = 0
    end
    object bbGoodsProperty: TdxBarButton
      Action = actGoodsProperty
      Category = 0
    end
    object bbJuridical: TdxBarButton
      Action = actJuridical
      Category = 0
    end
    object bbBusiness: TdxBarButton
      Action = actBusiness
      Category = 0
    end
    object bbBranch: TdxBarButton
      Action = actBranch
      Category = 0
    end
    object bbIncome: TdxBarButton
      Action = actIncome
      Category = 0
    end
    object bbSendOnPrice: TdxBarButton
      Action = actSendOnPrice
      Category = 0
    end
    object bbSend: TdxBarButton
      Action = actSend
      Category = 0
    end
    object bbSale: TdxBarButton
      Action = actSale
      Category = 0
    end
    object bbReturnOut: TdxBarButton
      Action = actReturnOut
      Category = 0
    end
    object bbReturnIn: TdxBarButton
      Action = actReturnIn
      Category = 0
    end
    object bbLoss: TdxBarButton
      Action = actLoss
      Category = 0
    end
    object bbInventory: TdxBarButton
      Action = actInventory
      Category = 0
    end
    object bbProductionSeparate: TdxBarButton
      Action = actProductionSeparate
      Category = 0
    end
    object bbProductionUnion: TdxBarButton
      Action = actProductionUnion
      Category = 0
    end
    object bbZakazExternal: TdxBarButton
      Action = actZakazExternal
      Category = 0
    end
    object bbZakazInternal: TdxBarButton
      Action = actZakazInternal
      Category = 0
    end
    object bbPartner: TdxBarButton
      Action = actPartner
      Category = 0
    end
    object bbPaidKind: TdxBarButton
      Action = actPaidKind
      Category = 0
    end
    object bbContractKind: TdxBarButton
      Action = actContractKind
      Category = 0
    end
    object bbContract: TdxBarButton
      Action = actContract
      Category = 0
    end
    object bbUnitGroup: TdxBarButton
      Caption = #1043#1088#1091#1087#1087#1099' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081
      Category = 0
      Hint = #1043#1088#1091#1087#1087#1099' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081
      Visible = ivAlways
    end
    object bbUnit: TdxBarButton
      Action = actUnit
      Category = 0
    end
    object bbGoodsGroup: TdxBarButton
      Action = actGoodsGroup
      Category = 0
    end
    object bbGoods: TdxBarButton
      Action = actGoods
      Category = 0
    end
    object bbGoodsKind: TdxBarButton
      Action = actGoodsKind
      Category = 0
    end
    object bbReportBalance: TdxBarButton
      Action = actReport_Balance
      Category = 0
    end
    object bbReportProfitLoss: TdxBarButton
      Action = actReport_ProfitLoss
      Category = 0
    end
    object bbReportHistoryCost: TdxBarButton
      Action = actReport_HistoryCost
      Category = 0
    end
    object bbReport_MotionGoods: TdxBarButton
      Action = actReport_MotionGoods
      Category = 0
    end
    object bbReports: TdxBarSubItem
      Caption = #1054#1090#1095#1077#1090#1099
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbReportBalance'
        end
        item
          Visible = True
          ItemName = 'bbReportProfitLoss'
        end
        item
          Visible = True
          ItemName = 'bbReportHistoryCost'
        end
        item
          Visible = True
          ItemName = 'bbReport_MotionGoods'
        end>
    end
    object bbBank: TdxBarButton
      Action = actBank
      Category = 0
    end
    object bbPriceList: TdxBarButton
      Action = actPriceList
      Category = 0
    end
    object bbCash: TdxBarButton
      Action = actCash
      Category = 0
    end
    object bbCurrency: TdxBarButton
      Action = actCurrency
      Category = 0
    end
    object bbInfoMoneyGroup: TdxBarButton
      Action = actInfoMoneyGroup
      Category = 0
    end
    object bbInfoMoneyDestination: TdxBarButton
      Action = actInfoMoneyDestination
      Category = 0
    end
    object bbInfoMoney: TdxBarButton
      Action = actInfoMoney
      Category = 0
    end
    object bbAccountGroup: TdxBarButton
      Action = actAccountGroup
      Category = 0
    end
    object bbAccountDirection: TdxBarButton
      Action = actAccountDirection
      Category = 0
    end
    object bbProfitLossGroup: TdxBarButton
      Action = actProfitLossGroup
      Category = 0
    end
    object bbProfitLossDirection: TdxBarButton
      Action = actProfitLossDirection
      Category = 0
    end
    object dxBarSubItem: TdxBarSubItem
      Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInfoMoneyGroup'
        end
        item
          Visible = True
          ItemName = 'bbInfoMoneyDestination'
        end
        item
          Visible = True
          ItemName = 'bbInfoMoney'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbAccountGroup'
        end
        item
          Visible = True
          ItemName = 'bbAccountDirection'
        end
        item
          Visible = True
          ItemName = 'bbAccount'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbProfitLossGroup'
        end
        item
          Visible = True
          ItemName = 'bbProfitLossDirection'
        end
        item
          Visible = True
          ItemName = 'bbProfitLoss'
        end>
    end
    object bbAccount: TdxBarButton
      Action = actAccount
      Category = 0
    end
    object bbProfitLoss: TdxBarButton
      Action = actProfitLoss
      Category = 0
    end
    object bbRouteSorting: TdxBarButton
      Action = actRouteSorting
      Category = 0
    end
    object bbTradeMark: TdxBarButton
      Action = actTradeMark
      Category = 0
    end
    object bbAsset: TdxBarButton
      Action = actAsset
      Category = 0
    end
    object bbHistory: TdxBarSubItem
      Caption = #1048#1089#1090#1086#1088#1080#1080
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbPriceListItem'
        end>
    end
    object bbPriceListItem: TdxBarButton
      Action = actPriceListItem
      Category = 0
    end
    object bbFinanceDocuments: TdxBarSubItem
      Caption = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      Category = 0
      Hint = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1092#1080#1085#1072#1085#1089#1086#1074#1099#1077
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbIncomeCash'
        end>
    end
    object bbIncomeCash: TdxBarButton
      Action = actIncomeCash
      Category = 0
    end
    object bbBankAccount: TdxBarButton
      Action = actBankAccount
      Category = 0
    end
    object bbRole: TdxBarButton
      Action = actRole
      Category = 0
    end
    object bbService: TdxBarSubItem
      Caption = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbAction'
        end
        item
          Visible = True
          ItemName = 'bbProcess'
        end
        item
          Visible = True
          ItemName = 'bbUser'
        end
        item
          Visible = True
          ItemName = 'bbRole'
        end>
    end
    object bbAction: TdxBarButton
      Action = actAction
      Category = 0
    end
    object bbUser: TdxBarButton
      Action = actUser
      Category = 0
    end
    object bbProcess: TdxBarButton
      Action = actProcess
      Category = 0
    end
    object bbTransportDocuments: TdxBarSubItem
      Caption = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbTransport'
        end
        item
          Visible = True
          ItemName = 'bbIncomeFuel'
        end
        item
          Visible = True
          ItemName = 'bbPersonalSendCash'
        end
        item
          Visible = True
          ItemName = 'bbTransportDocuments_Separator'
        end
        item
          Visible = True
          ItemName = 'bbCar'
        end
        item
          Visible = True
          ItemName = 'bbRoute'
        end
        item
          Visible = True
          ItemName = 'bbCarModel'
        end
        item
          Visible = True
          ItemName = 'bbFreight'
        end
        item
          Visible = True
          ItemName = 'bbFuel'
        end
        item
          Visible = True
          ItemName = 'bbRateFuelKind'
        end
        item
          Visible = True
          ItemName = 'bbRateFuel'
        end
        item
          Visible = True
          ItemName = 'bbTransportDocuments_Separator'
        end
        item
          Visible = True
          ItemName = 'bbtReport_Transport'
        end
        item
          Visible = True
          ItemName = 'bbReport_Fuel'
        end>
    end
    object bbTransport: TdxBarButton
      Action = actTransport
      Category = 0
    end
    object bbIncomeFuel: TdxBarButton
      Action = actIncomeFuel
      Category = 0
    end
    object bbPersonalSendCash: TdxBarButton
      Action = actPersonalSendCash
      Category = 0
    end
    object bbTransportDocuments_Separator: TdxBarSeparator
      Caption = 'bbTransportDocuments_Separator'
      Category = 0
      Hint = 'bbTransportDocuments_Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbCar: TdxBarButton
      Action = actCar
      Category = 0
    end
    object bbRoute: TdxBarButton
      Action = actRoute
      Category = 0
    end
    object bbCarModel: TdxBarButton
      Action = actCarModel
      Category = 0
    end
    object bbFreight: TdxBarButton
      Action = actFreight
      Category = 0
    end
    object bbFuel: TdxBarButton
      Action = actFuel
      Category = 0
    end
    object bbRateFuelKind: TdxBarButton
      Action = actRateFuelKind
      Category = 0
    end
    object bbRateFuel: TdxBarButton
      Action = actRateFuel
      Category = 0
    end
    object bbtReport_Transport: TdxBarButton
      Action = actReport_Transport
      Category = 0
    end
    object bbReport_Fuel: TdxBarButton
      Action = actReport_Fuel
      Category = 0
    end
    object bbPersonalDocuments: TdxBarSubItem
      Caption = #1055#1077#1088#1089#1086#1085#1072#1083
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbPersonalGroup'
        end
        item
          Visible = True
          ItemName = 'bbPersonal'
        end
        item
          Visible = True
          ItemName = 'bbPosition'
        end
        item
          Visible = True
          ItemName = 'bbMember'
        end
        item
          Visible = True
          ItemName = 'bbWorkTimeKind'
        end
        item
          Visible = True
          ItemName = 'bbPersonalDocuments_Separator'
        end
        item
          Visible = True
          ItemName = 'bbSheetWorkTime'
        end
        item
          Visible = True
          ItemName = 'bbPersonalService'
        end>
    end
    object bbPersonalGroup: TdxBarButton
      Action = actPersonalGroup
      Category = 0
    end
    object bbPersonal: TdxBarButton
      Action = actPersonal
      Category = 0
    end
    object bbPosition: TdxBarButton
      Action = actPosition
      Category = 0
    end
    object bbMember: TdxBarButton
      Action = actMember
      Category = 0
    end
    object bbWorkTimeKind: TdxBarButton
      Action = actWorkTimeKind
      Category = 0
    end
    object bbPersonalDocuments_Separator: TdxBarSeparator
      Caption = 'bbPersonalDocuments_Separator'
      Category = 0
      Hint = 'bbPersonalDocuments_Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbSheetWorkTime: TdxBarButton
      Action = actSheetWorkTime
      Category = 0
    end
    object bbPersonalService: TdxBarButton
      Action = actPersonalService
      Category = 0
    end
  end
  object ActionList: TActionList
    Left = 192
    Top = 48
    object actPersonalGroup: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      Caption = #1043#1088#1091#1087#1087#1080#1088#1086#1074#1082#1080' '#1057#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074' '
      Hint = #1043#1088#1091#1087#1087#1080#1088#1086#1074#1082#1080' '#1057#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074' '
      FormName = 'TPersonalGroupForm'
      GuiParams = <>
      isShowModal = False
    end
    object actPersonal: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082#1080' '
      Hint = #1057#1086#1090#1088#1091#1076#1085#1080#1082#1080' '
      FormName = 'TPersonalForm'
      GuiParams = <>
      isShowModal = False
    end
    object actPosition: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1080' '
      Hint = #1044#1086#1083#1078#1085#1086#1089#1090#1080' '
      FormName = 'TPositionForm'
      GuiParams = <>
      isShowModal = False
    end
    object actMember: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      Caption = #1060#1080#1079#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      Hint = #1060#1080#1079#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      FormName = 'TMemberForm'
      GuiParams = <>
      isShowModal = False
    end
    object actTransport: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1055#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090
      Hint = #1055#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090
      FormName = 'TTransportJournalForm'
      GuiParams = <>
      isShowModal = False
    end
    object actIncomeFuel: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1047#1072#1087#1088#1072#1074#1082#1072' '#1072#1074#1090#1086') '
      Hint = #1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1079#1072#1087#1088#1072#1074#1082#1072' '#1072#1074#1090#1086') '
      FormName = 'TIncomeFuelJournalForm'
      GuiParams = <>
      isShowModal = False
    end
    object actPersonalSendCash: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1056#1072#1089#1093#1086#1076' '#1076#1077#1085#1077#1075' '#1089' '#1087#1086#1076#1086#1090#1095#1077#1090#1072' '#1085#1072' '#1087#1086#1076#1086#1090#1095#1077#1090
      Hint = #1056#1072#1089#1093#1086#1076' '#1076#1077#1085#1077#1075' '#1089' '#1087#1086#1076#1086#1090#1095#1077#1090#1072' '#1085#1072' '#1087#1086#1076#1086#1090#1095#1077#1090
      FormName = 'TPersonalSendCashJournalForm'
      GuiParams = <>
      isShowModal = False
    end
    object actCar: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1080
      Hint = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1080
      FormName = 'TCarForm'
      GuiParams = <>
      isShowModal = False
    end
    object actRoute: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1052#1072#1088#1096#1088#1091#1090#1099
      Hint = #1052#1072#1088#1096#1088#1091#1090#1099
      FormName = 'TRouteForm'
      GuiParams = <>
      isShowModal = False
    end
    object actCarModel: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1052#1072#1088#1082#1080' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1077#1081
      Hint = #1052#1072#1088#1082#1080' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1077#1081
      FormName = 'TCarModelForm'
      GuiParams = <>
      isShowModal = False
    end
    object actFuel: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1042#1080#1076#1099' '#1090#1086#1087#1083#1080#1074#1072
      Hint = #1042#1080#1076#1099' '#1090#1086#1087#1083#1080#1074#1072
      FormName = 'TFuelForm'
      GuiParams = <>
      isShowModal = False
    end
    object actRateFuelKind: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1042#1080#1076#1099' '#1085#1086#1088#1084' '#1090#1086#1087#1083#1080#1074#1072
      Hint = #1042#1080#1076#1099' '#1085#1086#1088#1084' '#1090#1086#1087#1083#1080#1074#1072
      FormName = 'TRateFuelKindForm'
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Balance: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      Caption = #1041#1072#1083#1072#1085#1089
      FormName = 'TReport_BalanceForm'
      GuiParams = <>
      isShowModal = False
    end
    object actReport_ProfitLoss: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      Caption = #1054#1090#1095#1077#1090' '#1086' '#1055#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1059#1073#1099#1090#1082#1072#1093
      FormName = 'TReport_ProfitLossForm'
      GuiParams = <>
      isShowModal = False
    end
    object actProcess: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Caption = #1055#1088#1086#1094#1077#1089#1089#1099
      Hint = #1055#1088#1086#1094#1077#1089#1089#1099
      FormName = 'TProcessForm'
      GuiParams = <>
      isShowModal = False
    end
    object actIncome: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      Caption = #1055#1088#1080#1093#1086#1076#1085#1099#1077' '#1085#1072#1082#1083#1072#1076#1085#1099#1077
      FormName = 'TIncomeJournalForm'
      GuiParams = <>
      isShowModal = False
    end
    object actReport_HistoryCost: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      Caption = #1057#1077#1073#1077#1089#1090#1086#1080#1084#1086#1089#1090#1100
      FormName = 'TReport_HistoryCostForm'
      GuiParams = <>
      isShowModal = False
    end
    object actExit: TFileExit
      Category = #1055#1088#1080#1083#1086#1078#1077#1085#1080#1077
      Caption = #1042#1099'&x'#1086#1076
      Hint = #1042#1099#1093#1086#1076'|'#1047#1072#1082#1088#1099#1090#1100' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077
      ImageIndex = 43
      ShortCut = 16472
    end
    object actInventory: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      Caption = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103
      FormName = 'TInventoryJournalForm'
      GuiParams = <>
      isShowModal = False
    end
    object actLoss: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      Caption = #1057#1087#1080#1089#1072#1085#1080#1077
      FormName = 'TLossJournalForm'
      GuiParams = <>
      isShowModal = False
    end
    object actBank: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1041#1072#1085#1082#1080
      Hint = #1041#1072#1085#1082#1080
      FormName = 'TBankForm'
      GuiParams = <>
      isShowModal = False
    end
    object actSendOnPrice: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1094#1077#1085#1077
      FormName = 'TSendOnPriceJournalForm'
      GuiParams = <>
      isShowModal = False
    end
    object actBankAccount: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1077' '#1089#1095#1077#1090#1072
      Hint = #1056#1072#1089#1095#1077#1090#1085#1099#1077' '#1089#1095#1077#1090#1072
      FormName = 'TBankAccountForm'
      GuiParams = <>
      isShowModal = False
    end
    object actBranch: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1060#1080#1083#1080#1072#1083#1099
      Hint = #1060#1080#1083#1080#1072#1083#1099
      FormName = 'TBranchForm'
      GuiParams = <>
      isShowModal = False
    end
    object actBusiness: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1041#1080#1079#1085#1077#1089#1099
      Hint = #1041#1080#1079#1085#1077#1089#1099
      FormName = 'TBusinessForm'
      GuiParams = <>
      isShowModal = False
    end
    object actCash: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1050#1072#1089#1089#1072
      Hint = #1050#1072#1089#1089#1072
      FormName = 'TCashForm'
      GuiParams = <>
      isShowModal = False
    end
    object actContractKind: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1042#1080#1076#1099' '#1076#1086#1075#1086#1074#1086#1088#1086#1074
      Hint = #1042#1080#1076#1099' '#1076#1086#1075#1086#1074#1086#1088#1086#1074
      FormName = 'TContractKindForm'
      GuiParams = <>
      isShowModal = False
    end
    object actContract: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1044#1086#1075#1086#1074#1086#1088#1072
      Hint = #1044#1086#1075#1086#1074#1086#1088#1072
      FormName = 'TContractForm'
      GuiParams = <>
      isShowModal = False
    end
    object actCurrency: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1042#1072#1083#1102#1090#1099
      Hint = #1042#1072#1083#1102#1090#1099
      FormName = 'TCurrencyForm'
      GuiParams = <>
      isShowModal = False
    end
    object actGoods: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1058#1086#1074#1072#1088#1099
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TGoodsTreeForm'
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1043#1088#1091#1087#1087#1099' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1043#1088#1091#1087#1087#1099' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TGoodsGroupForm'
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsKind: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1042#1080#1076#1099' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1042#1080#1076#1099' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TGoodsKindForm'
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsProperty: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088#1099' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TGoodsPropertyForm'
      GuiParams = <>
      isShowModal = False
    end
    object actJuridical: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      Hint = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      FormName = 'TJuridicalTreeForm'
      GuiParams = <>
      isShowModal = False
    end
    object actJuridicalGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1043#1088#1091#1087#1087#1099' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1080#1093' '#1083#1080#1094
      Hint = #1043#1088#1091#1087#1087#1099' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1080#1093' '#1083#1080#1094
      FormName = 'TJuridicalGroupForm'
      GuiParams = <>
      isShowModal = False
    end
    object actMeasure: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1045#1076#1080#1085#1080#1094#1099' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
      Hint = #1045#1076#1080#1085#1080#1094#1099' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
      FormName = 'TMeasureForm'
      GuiParams = <>
      isShowModal = False
    end
    object actPaidKind: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1042#1080#1076#1099' '#1092#1086#1088#1084' '#1086#1087#1083#1072#1090#1099
      Hint = #1042#1080#1076#1099' '#1092#1086#1088#1084' '#1086#1087#1083#1072#1090#1099
      FormName = 'TPaidKindForm'
      GuiParams = <>
      isShowModal = False
    end
    object actPartner: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099
      Hint = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099
      FormName = 'TPartnerForm'
      GuiParams = <>
      isShowModal = False
    end
    object actUnit: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
      Hint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
      FormName = 'TUnitTreeForm'
      GuiParams = <>
      isShowModal = False
    end
    object actPriceList: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090#1099
      Hint = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090#1099
      FormName = 'TPriceListForm'
      GuiParams = <>
      isShowModal = False
    end
    object actInfoMoneyGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1043#1088#1091#1087#1087#1099' '#1091#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1093' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1081
      Hint = #1043#1088#1091#1087#1087#1099' '#1091#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1093' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1081
      FormName = 'TInfoMoneyGroupForm'
      GuiParams = <>
      isShowModal = False
    end
    object actInfoMoneyDestination: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      Hint = #1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      FormName = 'TInfoMoneyDestinationForm'
      GuiParams = <>
      isShowModal = False
    end
    object actInfoMoney: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1057#1090#1072#1090#1100#1080' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      Hint = #1057#1090#1072#1090#1100#1080' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      FormName = 'TInfoMoneyForm'
      GuiParams = <>
      isShowModal = False
    end
    object actAccountGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1043#1088#1091#1087#1087#1099' '#1089#1095#1077#1090#1086#1074
      Hint = #1043#1088#1091#1087#1087#1099' '#1089#1095#1077#1090#1086#1074
      FormName = 'TAccountGroupForm'
      GuiParams = <>
      isShowModal = False
    end
    object actAccountDirection: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1040#1085#1072#1083#1080#1090#1080#1082#1080' '#1089#1095#1077#1090#1086#1074' - '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1103
      Hint = #1040#1085#1072#1083#1080#1090#1080#1082#1080' '#1089#1095#1077#1090#1086#1074' - '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1103
      FormName = 'TAccountDirectionForm'
      GuiParams = <>
      isShowModal = False
    end
    object actProfitLossGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1043#1088#1091#1087#1087#1099' '#1089#1090#1072#1090#1077#1081' '#1086#1090#1095#1077#1090#1072' '#1086' '#1087#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1091#1073#1099#1090#1082#1072#1093
      Hint = #1043#1088#1091#1087#1087#1099' '#1089#1090#1072#1090#1077#1081' '#1086#1090#1095#1077#1090#1072' '#1086' '#1087#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1091#1073#1099#1090#1082#1072#1093
      FormName = 'TProfitLossGroupForm'
      GuiParams = <>
      isShowModal = False
    end
    object actProfitLossDirection: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1040#1085#1072#1083#1080#1090#1080#1082#1080' '#1089#1090#1072#1090#1077#1081' '#1086#1090#1095#1077#1090#1072' '#1086' '#1087#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1091#1073#1099#1090#1082#1072#1093' - '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1103
      Hint = #1040#1085#1072#1083#1080#1090#1080#1082#1080' '#1089#1090#1072#1090#1077#1081' '#1086#1090#1095#1077#1090#1072' '#1086' '#1087#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1091#1073#1099#1090#1082#1072#1093' - '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1103
      FormName = 'TProfitLossDirectionForm'
      GuiParams = <>
      isShowModal = False
    end
    object actAccount: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1057#1095#1077#1090#1072
      Hint = #1057#1095#1077#1090#1072
      FormName = 'TAccountForm'
      GuiParams = <>
      isShowModal = False
    end
    object actProfitLoss: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1057#1090#1072#1090#1100#1080' '#1086#1090#1095#1077#1090#1072' '#1086' '#1087#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1091#1073#1099#1090#1082#1072#1093
      Hint = #1057#1090#1072#1090#1100#1080' '#1086#1090#1095#1077#1090#1072' '#1086' '#1087#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1091#1073#1099#1090#1082#1072#1093
      FormName = 'TProfitLossForm'
      GuiParams = <>
      isShowModal = False
    end
    object actTradeMark: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1058#1086#1088#1075#1086#1074#1099#1077' '#1084#1072#1088#1082#1080
      Hint = #1058#1086#1088#1075#1086#1074#1099#1077' '#1084#1072#1088#1082#1080
      FormName = 'TTradeMarkForm'
      GuiParams = <>
      isShowModal = False
    end
    object actAsset: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1054#1089#1085#1086#1074#1085#1099#1077' '#1089#1088#1077#1076#1089#1090#1074#1072' '
      Hint = #1054#1089#1085#1086#1074#1085#1099#1077' '#1089#1088#1077#1076#1089#1090#1074#1072' '
      FormName = 'TAssetForm'
      GuiParams = <>
      isShowModal = False
    end
    object actRouteSorting: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1080' '#1084#1072#1088#1096#1088#1091#1090#1086#1074
      Hint = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1080' '#1084#1072#1088#1096#1088#1091#1090#1086#1074
      FormName = 'TRouteSortingForm'
      GuiParams = <>
      isShowModal = False
    end
    object actSend: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      FormName = 'TSendJournalForm'
      GuiParams = <>
      isShowModal = False
    end
    object actSale: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      Caption = #1056#1077#1072#1083#1080#1079#1072#1094#1080#1103
      FormName = 'TSaleJournalForm'
      GuiParams = <>
      isShowModal = False
    end
    object actReturnOut: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
      FormName = 'TReturnOutJournalForm'
      GuiParams = <>
      isShowModal = False
    end
    object actReturnIn: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
      FormName = 'TReturnInJournalForm'
      GuiParams = <>
      isShowModal = False
    end
    object actProductionSeparate: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      FormName = 'TProductionSeparateJournalForm'
      GuiParams = <>
      isShowModal = False
    end
    object actProductionUnion: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1089#1084#1077#1096#1080#1074#1072#1085#1080#1077
      FormName = 'TProductionUnionJournalForm'
      GuiParams = <>
      isShowModal = False
    end
    object actZakazExternal: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      Caption = #1047#1072#1103#1074#1082#1072' ('#1089#1090#1086#1088#1086#1085#1085#1103#1103')'
      FormName = 'TZakazExternalJournalForm'
      GuiParams = <>
      isShowModal = False
    end
    object actPriceListItem: TdsdOpenForm
      Category = #1048#1089#1090#1086#1088#1080#1080
      Caption = #1048#1089#1090#1086#1088#1080#1080' '#1094#1077#1085' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1048#1089#1090#1086#1088#1080#1080' '#1094#1077#1085' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TPriceListItemForm'
      GuiParams = <>
      isShowModal = False
    end
    object actZakazInternal: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      Caption = #1047#1072#1103#1074#1082#1072' ('#1074#1085#1091#1090#1088#1077#1085#1085#1103#1103')'
      FormName = 'TZakazInternalJournalForm'
      GuiParams = <>
      isShowModal = False
    end
    object actIncomeCash: TdsdOpenForm
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      Caption = #1055#1088#1080#1093#1086#1076#1085#1099#1081' '#1082#1072#1089#1089#1086#1074#1099#1081' '#1086#1088#1076#1077#1088
      Hint = #1055#1088#1080#1093#1086#1076#1085#1099#1081' '#1082#1072#1089#1089#1086#1074#1099#1081' '#1086#1088#1076#1077#1088
      GuiParams = <>
      isShowModal = False
    end
    object actOutcomeCash: TdsdOpenForm
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      Caption = #1056#1072#1089#1093#1086#1076#1085#1099#1081' '#1082#1072#1089#1089#1086#1074#1099#1081' '#1086#1088#1076#1077#1088
      Hint = #1056#1072#1089#1093#1086#1076#1085#1099#1081' '#1082#1072#1089#1089#1086#1074#1099#1081' '#1086#1088#1076#1077#1088
      GuiParams = <>
      isShowModal = False
    end
    object actReport_MotionGoods: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      Caption = #1044#1074#1080#1078#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
      FormName = 'TReport_MotionGoodsForm'
      GuiParams = <>
      isShowModal = False
    end
    object actRole: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Caption = #1056#1086#1083#1080' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
      FormName = 'TRoleForm'
      GuiParams = <>
      isShowModal = False
    end
    object actAction: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Caption = #1044#1077#1081#1089#1090#1074#1080#1103
      Hint = #1044#1077#1081#1089#1090#1074#1080#1103
      FormName = 'TActionForm'
      GuiParams = <>
      isShowModal = False
    end
    object actUser: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080
      Hint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080
      FormName = 'TUserForm'
      GuiParams = <>
      isShowModal = False
    end
    object actRateFuel: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1053#1086#1088#1084#1099' '#1090#1086#1087#1083#1080#1074#1072
      Hint = #1053#1086#1088#1084#1099' '#1090#1086#1087#1083#1080#1074#1072
      FormName = 'TRateFuelForm'
      GuiParams = <>
      isShowModal = False
    end
    object actFreight: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1053#1072#1079#1074#1072#1085#1080#1103' '#1075#1088#1091#1079#1086#1074
      Hint = #1053#1072#1079#1074#1072#1085#1080#1103' '#1075#1088#1091#1079#1086#1074
      FormName = 'TFreightForm'
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Transport: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1040#1074#1090#1086#1084#1086#1073#1080#1083#1103#1084
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1040#1074#1090#1086#1084#1086#1073#1080#1083#1103#1084
      FormName = 'TReport_TransportForm'
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Fuel: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1088#1072#1089#1093#1086#1076#1072' '#1090#1086#1087#1083#1080#1074#1072
      Hint = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1088#1072#1089#1093#1086#1076#1072' '#1090#1086#1087#1083#1080#1074#1072
      FormName = 'TReport_FuelForm'
      GuiParams = <>
      isShowModal = False
    end
    object actWorkTimeKind: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      Caption = #1058#1080#1087#1099' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080
      Hint = #1058#1080#1087#1099' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080
      FormName = 'TWorkTimeKindForm'
      GuiParams = <>
      isShowModal = False
    end
    object actSheetWorkTime: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      Caption = #1058#1072#1073#1077#1083#1100' '#1091#1095#1077#1090#1072' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080
      Hint = #1058#1072#1073#1077#1083#1100' '#1091#1095#1077#1090#1072' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080
      FormName = 'TSheetWorkTimeForm'
      GuiParams = <>
      isShowModal = False
    end
    object actPersonalService: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1079#1072#1088#1087#1083#1072#1090#1099
      Hint = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1079#1072#1088#1087#1083#1072#1090#1099
      FormName = 'TPersonalServiceForm'
      GuiParams = <>
      isShowModal = False
    end
  end
  object cxLocalizer: TcxLocalizer
    StorageType = lstResource
    Left = 256
    Top = 48
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 184
    Top = 96
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
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
    Left = 240
    Top = 96
  end
  object frxReport1: TfrxReport
    Version = '4.12.2'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 41515.476209444450000000
    ReportOptions.LastChange = 41515.476209444450000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      ''
      'begin'
      ''
      'end.')
    Left = 360
    Top = 88
    Datasets = <>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      object ReportTitle1: TfrxReportTitle
        Height = 22.677180000000000000
        Top = 18.897650000000000000
        Width = 718.110700000000000000
      end
      object MasterData1: TfrxMasterData
        Height = 30.236240000000000000
        Top = 151.181200000000000000
        Width = 718.110700000000000000
        RowCount = 0
      end
      object PageFooter1: TfrxPageFooter
        Height = 22.677180000000000000
        Top = 241.889920000000000000
        Width = 718.110700000000000000
        object Memo1: TfrxMemoView
          Left = 642.520100000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          ShowHint = False
          HAlign = haRight
          Memo.UTF8W = (
            '[Page#]')
        end
      end
      object ColumnHeader1: TfrxColumnHeader
        Height = 26.456692913385830000
        Top = 64.252010000000000000
        Width = 718.110700000000000000
        object Memo2: TfrxMemoView
          Width = 26.456692910000000000
          Height = 26.456692910000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #8470)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo3: TfrxMemoView
          Left = 26.456710000000000000
          Width = 113.385841420000000000
          Height = 26.456692910000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1053#1072#1079#1074#1072#1085#1080#1103)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo4: TfrxMemoView
          Left = 139.842610000000000000
          Width = 37.795282910000000000
          Height = 26.456692910000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #8470)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo5: TfrxMemoView
          Left = 177.637910000000000000
          Width = 37.795282910000000000
          Height = 26.456692910000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #8470)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo6: TfrxMemoView
          Left = 215.433210000000000000
          Width = 37.795282910000000000
          Height = 26.456692910000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #8470)
          ParentFont = False
          VAlign = vaCenter
        end
      end
    end
  end
  object StoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ActionByUser'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <>
    Left = 128
    Top = 152
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 192
    Top = 168
  end
end
