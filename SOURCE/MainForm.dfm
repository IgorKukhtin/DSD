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
  OnKeyDown = FormKeyDown
  OnShow = FormShow
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
        end
        item
          Visible = True
          ItemName = 'bbGuides_Separator'
        end
        item
          Visible = True
          ItemName = 'bbUpdateProgramm'
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
          ItemName = 'bbCardFuel'
        end
        item
          Visible = True
          ItemName = 'bbTicketFuel'
        end
        item
          Visible = True
          ItemName = 'bbFrom_byIncomeFuel'
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
        end
        item
          Visible = True
          ItemName = 'bbAccountReport'
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
    object bbCardFuel: TdxBarButton
      Action = actCardFuel
      Category = 0
    end
    object bbTicketFuel: TdxBarButton
      Action = actTicketFuel
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
    object bbAccountReport: TdxBarButton
      Action = actReport_Account
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
          ItemName = 'bbPositionLevel'
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
          ItemName = 'bbStaffList'
        end
        item
          Visible = True
          ItemName = 'bbModelService'
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
    object bbFrom_byIncomeFuel: TdxBarButton
      Action = actFrom_byIncomeFuel
      Category = 0
    end
    object bbPositionLevel: TdxBarButton
      Action = actPositionLevel
      Category = 0
    end
    object bbStaffList: TdxBarButton
      Action = actStaffList
      Category = 0
    end
    object bbUpdateProgramm: TdxBarButton
      Action = actUpdateProgram
      Category = 0
    end
    object bbModelService: TdxBarButton
      Action = actModelService
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
    object actStaffList: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      Caption = #1064#1090#1072#1090#1085#1086#1077' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1077
      Hint = #1096#1090#1072#1090#1085#1086#1077' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1077
      FormName = 'TStaffListForm'
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
    object actCardFuel: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1058#1086#1087#1083#1080#1074#1085#1099#1077' '#1082#1072#1088#1090#1099
      Hint = #1058#1086#1087#1083#1080#1074#1085#1099#1077' '#1082#1072#1088#1090#1099
      FormName = 'TCardFuelForm'
      GuiParams = <>
      isShowModal = False
    end
    object actTicketFuel: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1058#1072#1083#1086#1085#1099' '#1085#1072' '#1090#1086#1087#1083#1080#1074#1086' '
      Hint = #1058#1072#1083#1086#1085#1099' '#1085#1072' '#1090#1086#1087#1083#1080#1074#1086' '
      FormName = 'TTicketFuelForm'
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
      FormName = 'TSheetWorkTimeJournalForm'
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
    object actReport_Account: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1095#1077#1090#1091
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1095#1077#1090#1091
      FormName = 'TReport_AccountForm'
      GuiParams = <>
      isShowModal = False
    end
    object actFrom_byIncomeFuel: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1050#1090#1086' '#1079#1072#1087#1088#1072#1074#1083#1103#1083
      Hint = #1050#1090#1086' '#1079#1072#1087#1088#1072#1074#1083#1103#1083
      FormName = 'TFrom_byIncomeFuelForm'
      GuiParams = <>
      isShowModal = False
    end
    object actPositionLevel: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      Caption = #1056#1072#1079#1088#1103#1076#1099' '#1076#1086#1083#1078#1085#1086#1089#1090#1077#1081' '
      Hint = #1056#1072#1079#1088#1103#1076#1099' '#1076#1086#1083#1078#1085#1086#1089#1090#1077#1081' '
      FormName = 'TPositionLevelForm'
      GuiParams = <>
      isShowModal = False
    end
    object actUpdateProgram: TAction
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Caption = #1054#1085#1086#1074#1080#1090#1100' '#1074#1077#1088#1089#1080#1102' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
      ShortCut = 57429
      OnExecute = actUpdateProgramExecute
    end
    object actModelService: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      Caption = #1052#1086#1076#1077#1083#1080' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
      Hint = #1052#1086#1076#1077#1083#1080' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
      FormName = 'TModelServiceForm'
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
    Version = '4.14'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 38749.448434976900000000
    ReportOptions.LastChange = 39427.468951041700000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 360
    Top = 88
    Datasets = <>
    Variables = <
      item
        Name = ' values'
        Value = Null
      end
      item
        Name = #1043#1086#1089'. '#1085#1086#1084#1077#1088
        Value = Null
      end
      item
        Name = #1052#1072#1088#1082#1072
        Value = Null
      end
      item
        Name = #1042#1086#1076#1080#1090#1077#1083#1100
        Value = Null
      end
      item
        Name = #8470' '#1091#1076#1086#1089#1090#1086#1074
        Value = Null
      end
      item
        Name = #1050#1083#1072#1089#1089
        Value = Null
      end
      item
        Name = #1044#1072#1090#1072
        Value = Null
      end
      item
        Name = #1042#1088#1077#1084#1103' '#1074#1099#1077#1079#1076
        Value = Null
      end
      item
        Name = #1042#1088#1077#1084#1103' '#1074#1086#1079#1074#1088#1072#1090
        Value = Null
      end
      item
        Name = #1057#1087#1080#1076#1086#1084' '#1074#1099#1077#1079#1076
        Value = Null
      end
      item
        Name = #1043#1057#1052' '#1074#1099#1077#1079#1076
        Value = Null
      end
      item
        Name = #1050#1083#1080#1077#1085#1090
        Value = Null
      end
      item
        Name = #1050#1083#1080#1077#1085#1090' '#1072#1076#1088#1077#1089
        Value = Null
      end
      item
        Name = #1042#1086#1076#1080#1090#1077#1083#1100' '#1082#1086#1088#1086#1090
        Value = Null
      end
      item
        Name = #1052#1077#1076#1080#1082
        Value = Null
      end
      item
        Name = #1052#1077#1093#1072#1085#1080#1082
        Value = Null
      end
      item
        Name = #1052#1077#1093#1072#1085#1080#1082' '#1087#1088#1080#1085
        Value = Null
      end
      item
        Name = #1044#1080#1089#1087#1077#1090#1095#1077#1088
        Value = Null
      end
      item
        Name = #8470' '#1087#1091#1090#1077#1074#1086#1075#1086
        Value = Null
      end
      item
        Name = #1054#1050#1055#1054
        Value = Null
      end
      item
        Name = #1054#1050#1059#1044
        Value = Null
      end
      item
        Name = #1055#1088#1077#1076#1087#1088#1080#1103#1090#1080#1077
        Value = Null
      end
      item
        Name = #1040#1076#1088#1077#1089
        Value = Null
      end>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object TfrxReportPage
      Orientation = poLandscape
      PaperWidth = 297.000000000000000000
      PaperHeight = 210.000000000000000000
      PaperSize = 9
      LeftMargin = 5.000000000000000000
      RightMargin = 5.000000000000000000
      TopMargin = 5.000000000000000000
      BottomMargin = 5.000000000000000000
      PrintOnPreviousPage = True
      object Memo210: TfrxMemoView
        ShiftMode = smDontShift
        Left = 867.000000000000000000
        Top = 240.000000000000000000
        Width = 156.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        HAlign = haCenter
        Memo.UTF8W = (
          '('#1092#1072#1084#1080#1083#1080#1103', '#1080'., '#1086'. '#1086#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1086#1075#1086' '#1083#1080#1094#1072')')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo192: TfrxMemoView
        ShiftMode = smDontShift
        Left = 644.000000000000000000
        Top = 634.000000000000000000
        Width = 72.000000000000000000
        Height = 25.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        HAlign = haCenter
        Memo.UTF8W = (
          #1080#1089#1087#1088#1072#1074#1077#1085
          #1085#1077' '#1080#1089#1087#1088#1072#1074#1077#1085)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo172: TfrxMemoView
        ShiftMode = smDontShift
        Left = 549.000000000000000000
        Top = 594.000000000000000000
        Width = 111.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftTop]
        HAlign = haCenter
        Memo.UTF8W = (
          '('#1087#1086#1076#1087#1080#1089#1100')')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo163: TfrxMemoView
        ShiftMode = smDontShift
        Left = 210.000000000000000000
        Top = 629.000000000000000000
        Width = 99.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        HAlign = haCenter
        Memo.UTF8W = (
          '('#1088#1072#1089#1096#1080#1092#1088#1086#1074#1082#1072' '#1087#1086#1076#1087#1080#1089#1080')')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo158: TfrxMemoView
        ShiftMode = smDontShift
        Left = 150.000000000000000000
        Top = 587.000000000000000000
        Width = 88.000000000000000000
        Height = 10.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        HAlign = haCenter
        Memo.UTF8W = (
          '('#1087#1088#1086#1087#1080#1089#1100#1102')')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo52: TfrxMemoView
        ShiftMode = smDontShift
        Left = 148.000000000000000000
        Top = 284.000000000000000000
        Width = 33.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        HAlign = haCenter
        Memo.UTF8W = (
          #1084#1072#1088#1082#1072)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo43: TfrxMemoView
        ShiftMode = smDontShift
        Left = 249.000000000000000000
        Top = 243.000000000000000000
        Width = 88.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        HAlign = haCenter
        Memo.UTF8W = (
          '('#1085#1077#1085#1091#1078#1085#1086#1077' '#1079#1072#1095#1077#1088#1082#1085#1091#1090#1100')')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo36: TfrxMemoView
        ShiftMode = smDontShift
        Left = 287.000000000000000000
        Top = 204.000000000000000000
        Width = 156.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        HAlign = haCenter
        Memo.UTF8W = (
          '('#1092#1072#1084#1080#1083#1080#1103', '#1080#1084#1103', '#1086#1090#1095#1077#1089#1090#1074#1086')')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo28: TfrxMemoView
        ShiftMode = smDontShift
        Left = 201.000000000000000000
        Top = 111.000000000000000000
        Width = 268.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        HAlign = haCenter
        Memo.UTF8W = (
          '('#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077', '#1072#1076#1088#1077#1089', '#1085#1086#1084#1077#1088' '#1090#1077#1083#1077#1092#1086#1085#1072')')
        ParentFont = False
      end
      object Memo1: TfrxMemoView
        ShiftMode = smDontShift
        Left = 19.000000000000000000
        Top = 19.000000000000000000
        Width = 76.000000000000000000
        Height = 23.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        HAlign = haCenter
        Memo.UTF8W = (
          #1052#1077#1089#1090#1086' '#1076#1083#1103' '#1096#1090#1072#1084#1087#1072
          #1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1080)
        ParentFont = False
      end
      object Memo2: TfrxMemoView
        ShiftMode = smDontShift
        Left = 621.000000000000000000
        Top = 19.000000000000000000
        Width = 197.338590000000000000
        Height = 30.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1058#1080#1087#1086#1074#1072#1103' '#1084#1077#1078#1086#1090#1088#1072#1089#1083#1077#1074#1072#1103' '#1092#1086#1088#1084#1072' '#8470' 3 '#1089#1087#1077#1094'.'
          #1059#1090#1074#1077#1088#1078#1076#1077#1085#1072' '#1087#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077#1084' '#1043#1086#1089#1082#1086#1084#1089#1090#1072#1090#1072' '#1056#1086#1089#1089#1080#1080
          #1086#1090' 28.11.97 '#8470' 78')
        ParentFont = False
      end
      object Memo3: TfrxMemoView
        ShiftMode = smDontShift
        Left = 833.000000000000000000
        Top = 19.000000000000000000
        Width = 218.000000000000000000
        Height = 16.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Memo.UTF8W = (
          #1058#1072#1083#1086#1085' '#1087#1077#1088#1074#1086#1075#1086' '#1079#1072#1082#1072#1079#1095#1080#1082#1072' '#1082' '#1087#1091#1090#1077#1074#1086#1084#1091)
        ParentFont = False
      end
      object Memo5: TfrxMemoView
        ShiftMode = smDontShift
        Left = 834.000000000000000000
        Top = 36.000000000000000000
        Width = 35.000000000000000000
        Height = 16.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1083#1080#1089#1090#1091)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo6: TfrxMemoView
        ShiftMode = smDontShift
        Left = 178.000000000000000000
        Top = 20.000000000000000000
        Width = 114.000000000000000000
        Height = 20.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Memo.UTF8W = (
          #1055#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo7: TfrxMemoView
        ShiftMode = smDontShift
        Left = 155.000000000000000000
        Top = 40.000000000000000000
        Width = 182.000000000000000000
        Height = 16.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Memo.UTF8W = (
          #1089#1087#1077#1094#1080#1072#1083#1100#1085#1086#1075#1086' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo8: TfrxMemoView
        ShiftMode = smDontShift
        Left = 155.000000000000000000
        Top = 61.000000000000000000
        Width = 243.000000000000000000
        Height = 20.000000000000000000
        ShowHint = False
        DisplayFormat.DecimalSeparator = ','
        DisplayFormat.FormatStr = 'd MMMM yyyy '#39#1075'.'#39
        DisplayFormat.Kind = fkDateTime
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        HAlign = haCenter
        Memo.UTF8W = (
          '[dt]')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo9: TfrxMemoView
        ShiftMode = smDontShift
        Left = 728.000000000000000000
        Top = 56.000000000000000000
        Width = 90.000000000000000000
        Height = 147.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        Frame.Width = 2.000000000000000000
        HAlign = haCenter
        Memo.UTF8W = (
          #1050#1086#1076#1099)
        ParentFont = False
      end
      object Memo10: TfrxMemoView
        ShiftMode = smDontShift
        Left = 729.000000000000000000
        Top = 72.000000000000000000
        Width = 87.000000000000000000
        Height = 16.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '['#1054#1050#1059#1044']')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo11: TfrxMemoView
        ShiftMode = smDontShift
        Left = 729.000000000000000000
        Top = 88.000000000000000000
        Width = 87.000000000000000000
        Height = 16.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '['#1054#1050#1055#1054']')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo12: TfrxMemoView
        ShiftMode = smDontShift
        Left = 729.000000000000000000
        Top = 119.000000000000000000
        Width = 87.000000000000000000
        Height = 16.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo13: TfrxMemoView
        ShiftMode = smDontShift
        Left = 729.000000000000000000
        Top = 152.000000000000000000
        Width = 87.000000000000000000
        Height = 16.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo14: TfrxMemoView
        ShiftMode = smDontShift
        Left = 19.000000000000000000
        Top = 92.000000000000000000
        Width = 80.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo15: TfrxMemoView
        ShiftMode = smDontShift
        Left = 378.000000000000000000
        Top = 55.000000000000000000
        Width = 34.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        HAlign = haCenter
        Memo.UTF8W = (
          #1057#1077#1088#1080#1103)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo16: TfrxMemoView
        ShiftMode = smDontShift
        Left = 441.000000000000000000
        Top = 43.000000000000000000
        Width = 23.000000000000000000
        Height = 13.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        HAlign = haCenter
        Memo.UTF8W = (
          #8470)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo17: TfrxMemoView
        ShiftMode = smDontShift
        Left = 353.000000000000000000
        Top = 37.000000000000000000
        Width = 89.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo18: TfrxMemoView
        ShiftMode = smDontShift
        Left = 464.000000000000000000
        Top = 37.000000000000000000
        Width = 116.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '['#8470' '#1087#1091#1090#1077#1074#1086#1075#1086']')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo19: TfrxMemoView
        ShiftMode = smDontShift
        Left = 100.000000000000000000
        Top = 92.000000000000000000
        Width = 508.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '['#1055#1088#1077#1076#1087#1088#1080#1103#1090#1080#1077']')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo20: TfrxMemoView
        ShiftMode = smDontShift
        Left = 19.000000000000000000
        Top = 124.000000000000000000
        Width = 589.000000000000000000
        Height = 18.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '['#1040#1076#1088#1077#1089']')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo24: TfrxMemoView
        ShiftMode = smDontShift
        Left = 629.000000000000000000
        Top = 72.000000000000000000
        Width = 97.000000000000000000
        Height = 81.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        HAlign = haRight
        LineSpacing = 5.000000000000000000
        Memo.UTF8W = (
          #1060#1086#1088#1084#1072' '#1087#1086' '#1054#1050#1059#1044
          #1087#1086' '#1054#1050#1055#1054
          #1056#1077#1078#1080#1084' '#1088#1072#1073#1086#1090#1099
          #1050#1086#1083#1086#1085#1085#1072
          #1041#1088#1080#1075#1072#1076#1072)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo26: TfrxMemoView
        ShiftMode = smDontShift
        Left = 19.000000000000000000
        Top = 145.000000000000000000
        Width = 116.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1052#1072#1088#1082#1072' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo27: TfrxMemoView
        ShiftMode = smDontShift
        Left = 136.000000000000000000
        Top = 145.000000000000000000
        Width = 472.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '['#1052#1072#1088#1082#1072']')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo29: TfrxMemoView
        ShiftMode = smDontShift
        Left = 729.000000000000000000
        Top = 185.000000000000000000
        Width = 87.000000000000000000
        Height = 17.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo30: TfrxMemoView
        ShiftMode = smDontShift
        Left = 615.000000000000000000
        Top = 170.000000000000000000
        Width = 111.000000000000000000
        Height = 33.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        HAlign = haRight
        LineSpacing = 5.000000000000000000
        Memo.UTF8W = (
          #1043#1072#1088#1072#1078#1085#1099#1081' '#1085#1086#1084#1077#1088
          #1058#1072#1073#1077#1083#1100#1085#1099#1081' '#1085#1086#1084#1077#1088)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo32: TfrxMemoView
        ShiftMode = smDontShift
        Left = 19.000000000000000000
        Top = 166.000000000000000000
        Width = 195.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1043#1086#1089#1091#1076#1072#1088#1089#1090#1074#1077#1085#1085#1099#1081' '#1085#1086#1084#1077#1088#1085#1086#1081' '#1079#1085#1072#1082)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo33: TfrxMemoView
        ShiftMode = smDontShift
        Left = 215.000000000000000000
        Top = 166.000000000000000000
        Width = 393.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '['#1043#1086#1089'. '#1085#1086#1084#1077#1088']')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo34: TfrxMemoView
        ShiftMode = smDontShift
        Left = 19.000000000000000000
        Top = 186.000000000000000000
        Width = 116.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1042#1086#1076#1080#1090#1077#1083#1100)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo35: TfrxMemoView
        ShiftMode = smDontShift
        Left = 136.000000000000000000
        Top = 186.000000000000000000
        Width = 472.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '['#1042#1086#1076#1080#1090#1077#1083#1100']')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo37: TfrxMemoView
        ShiftMode = smDontShift
        Left = 20.000000000000000000
        Top = 215.000000000000000000
        Width = 116.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1059#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077' '#8470)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo38: TfrxMemoView
        ShiftMode = smDontShift
        Left = 137.000000000000000000
        Top = 215.000000000000000000
        Width = 306.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '['#8470' '#1091#1076#1086#1089#1090#1086#1074']')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo39: TfrxMemoView
        ShiftMode = smDontShift
        Left = 512.000000000000000000
        Top = 215.000000000000000000
        Width = 41.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1050#1083#1072#1089#1089)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo40: TfrxMemoView
        ShiftMode = smDontShift
        Left = 554.000000000000000000
        Top = 215.000000000000000000
        Width = 54.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '['#1050#1083#1072#1089#1089']')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo41: TfrxMemoView
        ShiftMode = smDontShift
        Left = 20.000000000000000000
        Top = 231.000000000000000000
        Width = 126.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1051#1080#1094#1077#1085#1079#1080#1086#1085#1085#1072#1103' '#1082#1072#1088#1090#1086#1095#1082#1072)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo42: TfrxMemoView
        ShiftMode = smDontShift
        Left = 147.000000000000000000
        Top = 231.000000000000000000
        Width = 296.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsUnderline]
        HAlign = haCenter
        Memo.UTF8W = (
          #1089#1090#1072#1085#1076#1072#1088#1090#1085#1072#1103', '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1085#1072#1103)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo44: TfrxMemoView
        ShiftMode = smDontShift
        Left = 20.000000000000000000
        Top = 254.000000000000000000
        Width = 116.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1056#1077#1075#1080#1089#1090#1088#1072#1094#1080#1086#1085#1085#1099#1081' '#8470)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo45: TfrxMemoView
        ShiftMode = smDontShift
        Left = 137.000000000000000000
        Top = 254.000000000000000000
        Width = 142.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo46: TfrxMemoView
        ShiftMode = smDontShift
        Left = 310.000000000000000000
        Top = 254.000000000000000000
        Width = 38.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1057#1077#1088#1080#1103)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo47: TfrxMemoView
        ShiftMode = smDontShift
        Left = 348.000000000000000000
        Top = 254.000000000000000000
        Width = 130.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo48: TfrxMemoView
        ShiftMode = smDontShift
        Left = 524.000000000000000000
        Top = 254.000000000000000000
        Width = 18.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #8470)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo49: TfrxMemoView
        ShiftMode = smDontShift
        Left = 542.000000000000000000
        Top = 254.000000000000000000
        Width = 130.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo50: TfrxMemoView
        ShiftMode = smDontShift
        Left = 20.000000000000000000
        Top = 270.000000000000000000
        Width = 46.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1055#1088#1080#1094#1077#1087)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo51: TfrxMemoView
        ShiftMode = smDontShift
        Left = 67.000000000000000000
        Top = 270.000000000000000000
        Width = 212.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo53: TfrxMemoView
        ShiftMode = smDontShift
        Left = 280.000000000000000000
        Top = 270.000000000000000000
        Width = 178.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1043#1086#1089#1091#1076#1072#1088#1089#1090#1074#1077#1085#1085#1099#1081' '#1085#1086#1084#1077#1088#1085#1086#1081' '#1079#1085#1072#1082)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo54: TfrxMemoView
        ShiftMode = smDontShift
        Left = 459.000000000000000000
        Top = 270.000000000000000000
        Width = 141.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo55: TfrxMemoView
        ShiftMode = smDontShift
        Left = 727.000000000000000000
        Top = 270.000000000000000000
        Width = 91.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        Frame.Width = 2.000000000000000000
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo56: TfrxMemoView
        ShiftMode = smDontShift
        Left = 631.000000000000000000
        Top = 270.000000000000000000
        Width = 94.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        HAlign = haRight
        Memo.UTF8W = (
          #1043#1072#1088#1072#1078#1085#1099#1081' '#1085#1086#1084#1077#1088)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo57: TfrxMemoView
        ShiftMode = smDontShift
        Left = 19.000000000000000000
        Top = 295.000000000000000000
        Width = 348.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1056#1072#1073#1086#1090#1072' '#1074#1086#1076#1080#1090#1077#1083#1103' '#1080' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo58: TfrxMemoView
        ShiftMode = smDontShift
        Left = 367.000000000000000000
        Top = 295.000000000000000000
        Width = 357.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1044#1074#1080#1078#1077#1085#1080#1077' '#1075#1086#1088#1102#1095#1077#1075#1086', '#1083)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo59: TfrxMemoView
        ShiftMode = smDontShift
        Left = 724.000000000000000000
        Top = 295.000000000000000000
        Width = 97.000000000000000000
        Height = 27.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1042#1088#1077#1084#1103' '#1088#1072#1073#1086#1090#1099','
          #1095'., '#1084#1080#1085'.')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo60: TfrxMemoView
        ShiftMode = smDontShift
        Left = 19.000000000000000000
        Top = 310.000000000000000000
        Width = 79.000000000000000000
        Height = 41.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1086#1087#1077#1088#1072#1094#1080#1103)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo61: TfrxMemoView
        ShiftMode = smDontShift
        Left = 98.000000000000000000
        Top = 310.000000000000000000
        Width = 65.000000000000000000
        Height = 41.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1074#1088#1077#1084#1103' '#1087#1086' '
          #1075#1088#1072#1092#1080#1082#1091','
          #1095'., '#1084#1080#1085'.')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo62: TfrxMemoView
        ShiftMode = smDontShift
        Left = 163.000000000000000000
        Top = 310.000000000000000000
        Width = 47.000000000000000000
        Height = 41.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1085#1091#1083#1077#1074#1086#1081' '
          #1087#1088#1086#1073#1077#1075','
          #1082#1084)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo63: TfrxMemoView
        ShiftMode = smDontShift
        Left = 210.000000000000000000
        Top = 310.000000000000000000
        Width = 70.000000000000000000
        Height = 41.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1087#1086#1082#1072#1079#1072#1085#1080#1077' '
          #1089#1087#1080#1076#1086#1084#1077#1090#1088#1072', '
          #1082#1084)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo64: TfrxMemoView
        ShiftMode = smDontShift
        Left = 280.000000000000000000
        Top = 310.000000000000000000
        Width = 87.000000000000000000
        Height = 41.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1074#1088#1077#1084#1103' '#1092#1072#1082#1090#1080'- '
          #1095#1077#1089#1082#1086#1077', '#1095#1080#1089#1083#1072' '
          #1084#1077#1089#1103#1094#1072', '#1095'., '#1084#1080#1085'.')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo65: TfrxMemoView
        ShiftMode = smDontShift
        Left = 19.000000000000000000
        Top = 362.000000000000000000
        Width = 79.000000000000000000
        Height = 28.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1042#1099#1077#1079#1076' '#1080#1079' '
          #1075#1072#1088#1072#1078#1072)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo66: TfrxMemoView
        ShiftMode = smDontShift
        Left = 367.000000000000000000
        Top = 310.000000000000000000
        Width = 93.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1075#1086#1088#1102#1095#1077#1077)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo67: TfrxMemoView
        ShiftMode = smDontShift
        Left = 367.000000000000000000
        Top = 325.000000000000000000
        Width = 56.000000000000000000
        Height = 26.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1084#1072#1088#1082#1072)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo68: TfrxMemoView
        ShiftMode = smDontShift
        Left = 423.000000000000000000
        Top = 325.000000000000000000
        Width = 37.000000000000000000
        Height = 26.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1082#1086#1076)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo69: TfrxMemoView
        ShiftMode = smDontShift
        Left = 460.000000000000000000
        Top = 310.000000000000000000
        Width = 47.000000000000000000
        Height = 41.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1074#1099#1076#1072#1085#1086)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo70: TfrxMemoView
        ShiftMode = smDontShift
        Left = 507.000000000000000000
        Top = 310.000000000000000000
        Width = 96.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1086#1089#1090#1072#1090#1086#1082' '#1087#1088#1080)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo71: TfrxMemoView
        ShiftMode = smDontShift
        Left = 507.000000000000000000
        Top = 325.000000000000000000
        Width = 48.000000000000000000
        Height = 26.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1074#1099#1077#1079#1076#1077)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo72: TfrxMemoView
        ShiftMode = smDontShift
        Left = 555.000000000000000000
        Top = 325.000000000000000000
        Width = 48.000000000000000000
        Height = 26.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1074#1086#1079#1074#1088#1072
          #1097#1077#1085#1080#1080)
        ParentFont = False
      end
      object Memo73: TfrxMemoView
        ShiftMode = smDontShift
        Left = 603.000000000000000000
        Top = 310.000000000000000000
        Width = 47.000000000000000000
        Height = 41.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1089#1076#1072#1085#1086)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo74: TfrxMemoView
        ShiftMode = smDontShift
        Left = 650.000000000000000000
        Top = 310.000000000000000000
        Width = 74.000000000000000000
        Height = 41.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1082#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090' '
          #1080#1079#1084#1077#1085#1077#1085#1080#1103' '
          #1085#1086#1088#1084#1099)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo75: TfrxMemoView
        ShiftMode = smDontShift
        Left = 724.000000000000000000
        Top = 322.000000000000000000
        Width = 56.000000000000000000
        Height = 29.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1089#1087#1077#1094#1086#1073#1086
          #1088#1091#1076#1086#1074#1072#1085'.')
        ParentFont = False
      end
      object Memo76: TfrxMemoView
        ShiftMode = smDontShift
        Left = 780.000000000000000000
        Top = 322.000000000000000000
        Width = 41.000000000000000000
        Height = 29.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1076#1074#1080#1075#1072'-'
          #1090#1077#1083#1103)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo77: TfrxMemoView
        ShiftMode = smDontShift
        Left = 19.000000000000000000
        Top = 351.000000000000000000
        Width = 79.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '1')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo78: TfrxMemoView
        ShiftMode = smDontShift
        Left = 98.000000000000000000
        Top = 351.000000000000000000
        Width = 65.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '2')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo79: TfrxMemoView
        ShiftMode = smDontShift
        Left = 163.000000000000000000
        Top = 351.000000000000000000
        Width = 47.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '3')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo80: TfrxMemoView
        ShiftMode = smDontShift
        Left = 210.000000000000000000
        Top = 351.000000000000000000
        Width = 70.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '4')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo81: TfrxMemoView
        ShiftMode = smDontShift
        Left = 280.000000000000000000
        Top = 351.000000000000000000
        Width = 87.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '5')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo82: TfrxMemoView
        ShiftMode = smDontShift
        Left = 367.000000000000000000
        Top = 351.000000000000000000
        Width = 56.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '6')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo83: TfrxMemoView
        ShiftMode = smDontShift
        Left = 423.000000000000000000
        Top = 351.000000000000000000
        Width = 37.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '7')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo84: TfrxMemoView
        ShiftMode = smDontShift
        Left = 460.000000000000000000
        Top = 351.000000000000000000
        Width = 47.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '8')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo85: TfrxMemoView
        ShiftMode = smDontShift
        Left = 507.000000000000000000
        Top = 351.000000000000000000
        Width = 48.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '9')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo86: TfrxMemoView
        ShiftMode = smDontShift
        Left = 555.000000000000000000
        Top = 351.000000000000000000
        Width = 48.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '10')
        ParentFont = False
      end
      object Memo87: TfrxMemoView
        ShiftMode = smDontShift
        Left = 603.000000000000000000
        Top = 351.000000000000000000
        Width = 47.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '11')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo88: TfrxMemoView
        ShiftMode = smDontShift
        Left = 650.000000000000000000
        Top = 351.000000000000000000
        Width = 74.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '12')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo89: TfrxMemoView
        ShiftMode = smDontShift
        Left = 724.000000000000000000
        Top = 351.000000000000000000
        Width = 56.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '13')
        ParentFont = False
      end
      object Memo90: TfrxMemoView
        ShiftMode = smDontShift
        Left = 780.000000000000000000
        Top = 351.000000000000000000
        Width = 41.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '14')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo91: TfrxMemoView
        ShiftMode = smDontShift
        Left = 98.000000000000000000
        Top = 362.000000000000000000
        Width = 65.000000000000000000
        Height = 28.000000000000000000
        ShowHint = False
        DisplayFormat.FormatStr = 'hh:nn'
        DisplayFormat.Kind = fkDateTime
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '['#1042#1088#1077#1084#1103' '#1074#1099#1077#1079#1076']')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo92: TfrxMemoView
        ShiftMode = smDontShift
        Left = 163.000000000000000000
        Top = 362.000000000000000000
        Width = 47.000000000000000000
        Height = 28.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo93: TfrxMemoView
        ShiftMode = smDontShift
        Left = 210.000000000000000000
        Top = 362.000000000000000000
        Width = 70.000000000000000000
        Height = 28.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo94: TfrxMemoView
        ShiftMode = smDontShift
        Left = 280.000000000000000000
        Top = 362.000000000000000000
        Width = 87.000000000000000000
        Height = 28.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo95: TfrxMemoView
        ShiftMode = smDontShift
        Left = 367.000000000000000000
        Top = 362.000000000000000000
        Width = 56.000000000000000000
        Height = 28.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo97: TfrxMemoView
        ShiftMode = smDontShift
        Left = 460.000000000000000000
        Top = 362.000000000000000000
        Width = 47.000000000000000000
        Height = 28.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo98: TfrxMemoView
        ShiftMode = smDontShift
        Left = 507.000000000000000000
        Top = 362.000000000000000000
        Width = 48.000000000000000000
        Height = 28.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo99: TfrxMemoView
        ShiftMode = smDontShift
        Left = 555.000000000000000000
        Top = 362.000000000000000000
        Width = 48.000000000000000000
        Height = 28.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
      end
      object Memo100: TfrxMemoView
        ShiftMode = smDontShift
        Left = 603.000000000000000000
        Top = 362.000000000000000000
        Width = 47.000000000000000000
        Height = 28.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo101: TfrxMemoView
        ShiftMode = smDontShift
        Left = 650.000000000000000000
        Top = 362.000000000000000000
        Width = 74.000000000000000000
        Height = 28.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo102: TfrxMemoView
        ShiftMode = smDontShift
        Left = 724.000000000000000000
        Top = 362.000000000000000000
        Width = 56.000000000000000000
        Height = 28.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
      end
      object Memo103: TfrxMemoView
        ShiftMode = smDontShift
        Left = 780.000000000000000000
        Top = 362.000000000000000000
        Width = 41.000000000000000000
        Height = 28.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo96: TfrxMemoView
        ShiftMode = smDontShift
        Left = 423.000000000000000000
        Top = 362.000000000000000000
        Width = 37.000000000000000000
        Height = 28.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo104: TfrxMemoView
        ShiftMode = smDontShift
        Left = 98.000000000000000000
        Top = 390.000000000000000000
        Width = 65.000000000000000000
        Height = 28.000000000000000000
        ShowHint = False
        DisplayFormat.FormatStr = 'hh:nn'
        DisplayFormat.Kind = fkDateTime
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '['#1042#1088#1077#1084#1103' '#1074#1086#1079#1074#1088#1072#1090']')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo105: TfrxMemoView
        ShiftMode = smDontShift
        Left = 163.000000000000000000
        Top = 390.000000000000000000
        Width = 47.000000000000000000
        Height = 28.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo106: TfrxMemoView
        ShiftMode = smDontShift
        Left = 210.000000000000000000
        Top = 390.000000000000000000
        Width = 70.000000000000000000
        Height = 28.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo107: TfrxMemoView
        ShiftMode = smDontShift
        Left = 280.000000000000000000
        Top = 390.000000000000000000
        Width = 87.000000000000000000
        Height = 28.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo108: TfrxMemoView
        ShiftMode = smDontShift
        Left = 367.000000000000000000
        Top = 390.000000000000000000
        Width = 93.000000000000000000
        Height = 28.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1055#1086#1076#1087#1080#1089#1100)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo109: TfrxMemoView
        ShiftMode = smDontShift
        Left = 460.000000000000000000
        Top = 390.000000000000000000
        Width = 47.000000000000000000
        Height = 14.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1079#1072#1087#1088#1072#1074#1097#1080#1082#1072)
        ParentFont = False
      end
      object Memo110: TfrxMemoView
        ShiftMode = smDontShift
        Left = 507.000000000000000000
        Top = 390.000000000000000000
        Width = 96.000000000000000000
        Height = 14.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1084#1077#1093#1072#1085#1080#1082#1072)
        ParentFont = False
      end
      object Memo111: TfrxMemoView
        ShiftMode = smDontShift
        Left = 603.000000000000000000
        Top = 390.000000000000000000
        Width = 47.000000000000000000
        Height = 14.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1079#1072#1087#1088#1072#1074#1097#1080#1082#1072)
        ParentFont = False
      end
      object Memo112: TfrxMemoView
        ShiftMode = smDontShift
        Left = 603.000000000000000000
        Top = 404.000000000000000000
        Width = 47.000000000000000000
        Height = 14.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo113: TfrxMemoView
        ShiftMode = smDontShift
        Left = 650.000000000000000000
        Top = 404.000000000000000000
        Width = 74.000000000000000000
        Height = 14.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo114: TfrxMemoView
        ShiftMode = smDontShift
        Left = 724.000000000000000000
        Top = 404.000000000000000000
        Width = 56.000000000000000000
        Height = 14.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
      end
      object Memo115: TfrxMemoView
        ShiftMode = smDontShift
        Left = 780.000000000000000000
        Top = 404.000000000000000000
        Width = 41.000000000000000000
        Height = 14.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo117: TfrxMemoView
        ShiftMode = smDontShift
        Left = 19.000000000000000000
        Top = 390.000000000000000000
        Width = 79.000000000000000000
        Height = 28.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1042#1086#1079#1074#1088#1072#1097#1077#1085#1080#1077' '
          #1074'  '#1075#1072#1088#1072#1078)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo116: TfrxMemoView
        ShiftMode = smDontShift
        Left = 460.000000000000000000
        Top = 404.000000000000000000
        Width = 47.000000000000000000
        Height = 14.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
      end
      object Memo118: TfrxMemoView
        ShiftMode = smDontShift
        Left = 507.000000000000000000
        Top = 404.000000000000000000
        Width = 48.000000000000000000
        Height = 14.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
      end
      object Memo119: TfrxMemoView
        ShiftMode = smDontShift
        Left = 555.000000000000000000
        Top = 404.000000000000000000
        Width = 48.000000000000000000
        Height = 14.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
      end
      object Memo120: TfrxMemoView
        ShiftMode = smDontShift
        Left = 650.000000000000000000
        Top = 390.000000000000000000
        Width = 171.000000000000000000
        Height = 14.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1076#1080#1089#1087#1077#1090#1095#1077#1088#1072)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo121: TfrxMemoView
        ShiftMode = smDontShift
        Left = 19.000000000000000000
        Top = 418.000000000000000000
        Width = 191.000000000000000000
        Height = 14.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        Memo.UTF8W = (
          #1057#1077#1088#1080#1080' '#1080' '#1085#1086#1084#1077#1088#1072' '#1074#1099#1076#1072#1085#1085#1099#1093' '#1090#1072#1083#1086#1085#1086#1074)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo122: TfrxMemoView
        ShiftMode = smDontShift
        Left = 210.000000000000000000
        Top = 418.000000000000000000
        Width = 611.000000000000000000
        Height = 14.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo123: TfrxMemoView
        ShiftMode = smDontShift
        Left = 19.000000000000000000
        Top = 442.000000000000000000
        Width = 634.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1047#1040#1044#1040#1053#1048#1045'  '#1042#1054#1044#1048#1058#1045#1051#1070)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo124: TfrxMemoView
        ShiftMode = smDontShift
        Left = 653.000000000000000000
        Top = 442.000000000000000000
        Width = 168.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1054#1089#1086#1073#1099#1077' '#1086#1090#1084#1077#1090#1082#1080)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo125: TfrxMemoView
        ShiftMode = smDontShift
        Left = 19.000000000000000000
        Top = 457.000000000000000000
        Width = 310.000000000000000000
        Height = 30.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1074' '#1095#1100#1077' '#1088#1072#1089#1087#1086#1088#1103#1078#1077#1085#1080#1077
          '('#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1080' '#1072#1076#1088#1077#1089' '#1079#1072#1082#1072#1079#1095#1080#1082#1072')')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo126: TfrxMemoView
        ShiftMode = smDontShift
        Left = 329.000000000000000000
        Top = 457.000000000000000000
        Width = 168.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1074#1088#1077#1084#1103)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo127: TfrxMemoView
        ShiftMode = smDontShift
        Left = 329.000000000000000000
        Top = 472.000000000000000000
        Width = 84.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1087#1088#1080#1073#1099#1090#1080#1103)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo128: TfrxMemoView
        ShiftMode = smDontShift
        Left = 413.000000000000000000
        Top = 472.000000000000000000
        Width = 84.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1091#1073#1099#1090#1080#1103)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo129: TfrxMemoView
        ShiftMode = smDontShift
        Left = 497.000000000000000000
        Top = 457.000000000000000000
        Width = 156.000000000000000000
        Height = 30.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1074#1080#1076' '#1088#1072#1073#1086#1090#1099)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo130: TfrxMemoView
        ShiftMode = smDontShift
        Left = 653.000000000000000000
        Top = 457.000000000000000000
        Width = 168.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo131: TfrxMemoView
        ShiftMode = smDontShift
        Left = 653.000000000000000000
        Top = 472.000000000000000000
        Width = 168.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo132: TfrxMemoView
        ShiftMode = smDontShift
        Left = 19.000000000000000000
        Top = 487.000000000000000000
        Width = 310.000000000000000000
        Height = 14.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '15')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo133: TfrxMemoView
        ShiftMode = smDontShift
        Left = 329.000000000000000000
        Top = 487.000000000000000000
        Width = 84.000000000000000000
        Height = 14.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '16')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo134: TfrxMemoView
        ShiftMode = smDontShift
        Left = 413.000000000000000000
        Top = 487.000000000000000000
        Width = 84.000000000000000000
        Height = 14.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '17')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo135: TfrxMemoView
        ShiftMode = smDontShift
        Left = 497.000000000000000000
        Top = 487.000000000000000000
        Width = 156.000000000000000000
        Height = 14.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '18')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo136: TfrxMemoView
        ShiftMode = smDontShift
        Left = 653.000000000000000000
        Top = 487.000000000000000000
        Width = 168.000000000000000000
        Height = 14.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo137: TfrxMemoView
        ShiftMode = smDontShift
        Left = 19.000000000000000000
        Top = 501.000000000000000000
        Width = 310.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        Memo.UTF8W = (
          '1.['#1050#1083#1080#1077#1085#1090']')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo138: TfrxMemoView
        ShiftMode = smDontShift
        Left = 329.000000000000000000
        Top = 501.000000000000000000
        Width = 84.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo139: TfrxMemoView
        ShiftMode = smDontShift
        Left = 413.000000000000000000
        Top = 501.000000000000000000
        Width = 84.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo140: TfrxMemoView
        ShiftMode = smDontShift
        Left = 497.000000000000000000
        Top = 501.000000000000000000
        Width = 156.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo141: TfrxMemoView
        ShiftMode = smDontShift
        Left = 653.000000000000000000
        Top = 501.000000000000000000
        Width = 168.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo142: TfrxMemoView
        ShiftMode = smDontShift
        Left = 329.000000000000000000
        Top = 516.000000000000000000
        Width = 84.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo143: TfrxMemoView
        ShiftMode = smDontShift
        Left = 413.000000000000000000
        Top = 516.000000000000000000
        Width = 84.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo144: TfrxMemoView
        ShiftMode = smDontShift
        Left = 497.000000000000000000
        Top = 516.000000000000000000
        Width = 156.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo145: TfrxMemoView
        ShiftMode = smDontShift
        Left = 653.000000000000000000
        Top = 516.000000000000000000
        Width = 168.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo146: TfrxMemoView
        ShiftMode = smDontShift
        Left = 19.000000000000000000
        Top = 516.000000000000000000
        Width = 310.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        Memo.UTF8W = (
          '['#1050#1083#1080#1077#1085#1090' '#1072#1076#1088#1077#1089']')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo147: TfrxMemoView
        ShiftMode = smDontShift
        Left = 19.000000000000000000
        Top = 531.000000000000000000
        Width = 310.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        Memo.UTF8W = (
          '2.')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo148: TfrxMemoView
        ShiftMode = smDontShift
        Left = 329.000000000000000000
        Top = 531.000000000000000000
        Width = 84.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo149: TfrxMemoView
        ShiftMode = smDontShift
        Left = 413.000000000000000000
        Top = 531.000000000000000000
        Width = 84.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo150: TfrxMemoView
        ShiftMode = smDontShift
        Left = 497.000000000000000000
        Top = 531.000000000000000000
        Width = 156.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo151: TfrxMemoView
        ShiftMode = smDontShift
        Left = 653.000000000000000000
        Top = 531.000000000000000000
        Width = 168.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo152: TfrxMemoView
        ShiftMode = smDontShift
        Left = 329.000000000000000000
        Top = 546.000000000000000000
        Width = 84.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo153: TfrxMemoView
        ShiftMode = smDontShift
        Left = 413.000000000000000000
        Top = 546.000000000000000000
        Width = 84.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo154: TfrxMemoView
        ShiftMode = smDontShift
        Left = 497.000000000000000000
        Top = 546.000000000000000000
        Width = 156.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo155: TfrxMemoView
        ShiftMode = smDontShift
        Left = 653.000000000000000000
        Top = 546.000000000000000000
        Width = 168.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo156: TfrxMemoView
        ShiftMode = smDontShift
        Left = 19.000000000000000000
        Top = 546.000000000000000000
        Width = 310.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo157: TfrxMemoView
        ShiftMode = smDontShift
        Left = 19.000000000000000000
        Top = 562.000000000000000000
        Width = 317.000000000000000000
        Height = 27.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1042#1086#1076#1080#1090#1077#1083#1100#1089#1082#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077' '#1087#1088#1086#1074#1077#1088#1080#1083', '#1079#1072#1076#1072#1085#1080#1077' '#1074#1099#1076#1072#1083
          #1074#1099#1076#1072#1090#1100' '#1075#1086#1088#1102#1095#1077#1075#1086' ______________________________ '#1083#1080#1090#1088#1086#1074)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo159: TfrxMemoView
        ShiftMode = smDontShift
        Left = 90.000000000000000000
        Top = 628.000000000000000000
        Width = 90.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftTop]
        HAlign = haCenter
        Memo.UTF8W = (
          '('#1087#1086#1076#1087#1080#1089#1100')')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo160: TfrxMemoView
        ShiftMode = smDontShift
        Left = 20.000000000000000000
        Top = 614.000000000000000000
        Width = 69.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Memo.UTF8W = (
          #1044#1080#1089#1087#1077#1090#1095#1077#1088)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo162: TfrxMemoView
        ShiftMode = smDontShift
        Left = 200.000000000000000000
        Top = 614.000000000000000000
        Width = 125.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '['#1044#1080#1089#1087#1077#1090#1095#1077#1088']')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo164: TfrxMemoView
        ShiftMode = smDontShift
        Left = 19.000000000000000000
        Top = 652.000000000000000000
        Width = 329.000000000000000000
        Height = 27.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1042#1086#1076#1080#1090#1077#1083#1100' '#1087#1086' '#1089#1086#1089#1090#1086#1103#1085#1080#1102' '#1079#1076#1086#1088#1086#1074#1100#1103' '#1082' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1102' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1077#1084
          #1076#1086#1087#1091#1097#1077#1085)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo165: TfrxMemoView
        ShiftMode = smDontShift
        Left = 203.000000000000000000
        Top = 681.000000000000000000
        Width = 114.118120000000000000
        Height = 11.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        HAlign = haCenter
        Memo.UTF8W = (
          '('#1088#1072#1089#1096#1080#1092#1088#1086#1074#1082#1072' '#1087#1086#1076#1087#1080#1089#1080')')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo166: TfrxMemoView
        ShiftMode = smDontShift
        Left = 90.000000000000000000
        Top = 680.000000000000000000
        Width = 90.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftTop]
        HAlign = haCenter
        Memo.UTF8W = (
          '('#1087#1086#1076#1087#1080#1089#1100')')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo168: TfrxMemoView
        ShiftMode = smDontShift
        Left = 200.000000000000000000
        Top = 666.000000000000000000
        Width = 125.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '['#1052#1077#1076#1080#1082']')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo169: TfrxMemoView
        ShiftMode = smDontShift
        Left = 20.000000000000000000
        Top = 711.000000000000000000
        Width = 55.000000000000000000
        Height = 22.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -7
        Font.Name = 'Arial'
        Font.Style = []
        HAlign = haCenter
        Memo.UTF8W = (
          #1052#1077#1089#1090#1086' '
          #1076#1083#1103' '#1096#1090#1072#1084#1087#1072)
        ParentFont = False
      end
      object Memo170: TfrxMemoView
        ShiftMode = smDontShift
        Left = 469.000000000000000000
        Top = 565.000000000000000000
        Width = 286.000000000000000000
        Height = 14.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100' '#1090#1077#1093#1085#1080#1095#1077#1089#1082#1080' '#1080#1089#1087#1088#1072#1074#1077#1085', '#1074#1099#1077#1079#1076' '#1088#1072#1079#1088#1077#1096#1077#1085':')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo171: TfrxMemoView
        ShiftMode = smDontShift
        Left = 690.000000000000000000
        Top = 595.000000000000000000
        Width = 99.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        HAlign = haCenter
        Memo.UTF8W = (
          '('#1088#1072#1089#1096#1080#1092#1088#1086#1074#1082#1072' '#1087#1086#1076#1087#1080#1089#1080')')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo173: TfrxMemoView
        ShiftMode = smDontShift
        Left = 469.000000000000000000
        Top = 580.000000000000000000
        Width = 69.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Memo.UTF8W = (
          #1052#1077#1093#1072#1085#1080#1082)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo175: TfrxMemoView
        ShiftMode = smDontShift
        Left = 680.000000000000000000
        Top = 580.000000000000000000
        Width = 125.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '['#1052#1077#1093#1072#1085#1080#1082']')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo176: TfrxMemoView
        ShiftMode = smDontShift
        Left = 690.000000000000000000
        Top = 621.000000000000000000
        Width = 99.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        HAlign = haCenter
        Memo.UTF8W = (
          '('#1088#1072#1089#1096#1080#1092#1088#1086#1074#1082#1072' '#1087#1086#1076#1087#1080#1089#1080')')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo177: TfrxMemoView
        ShiftMode = smDontShift
        Left = 549.000000000000000000
        Top = 620.000000000000000000
        Width = 111.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftTop]
        HAlign = haCenter
        Memo.UTF8W = (
          '('#1087#1086#1076#1087#1080#1089#1100')')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo178: TfrxMemoView
        ShiftMode = smDontShift
        Left = 469.000000000000000000
        Top = 606.000000000000000000
        Width = 69.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Memo.UTF8W = (
          #1042#1086#1076#1080#1090#1077#1083#1100)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo180: TfrxMemoView
        ShiftMode = smDontShift
        Left = 680.000000000000000000
        Top = 606.000000000000000000
        Width = 125.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '['#1042#1086#1076#1080#1090#1077#1083#1100' '#1082#1086#1088#1086#1090']')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo181: TfrxMemoView
        ShiftMode = smDontShift
        Left = 570.000000000000000000
        Top = 676.000000000000000000
        Width = 90.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftTop]
        HAlign = haCenter
        Memo.UTF8W = (
          '('#1087#1086#1076#1087#1080#1089#1100')')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo182: TfrxMemoView
        ShiftMode = smDontShift
        Left = 690.000000000000000000
        Top = 677.000000000000000000
        Width = 99.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        HAlign = haCenter
        Memo.UTF8W = (
          '('#1088#1072#1089#1096#1080#1092#1088#1086#1074#1082#1072' '#1087#1086#1076#1087#1080#1089#1080')')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo183: TfrxMemoView
        ShiftMode = smDontShift
        Left = 469.000000000000000000
        Top = 662.000000000000000000
        Width = 98.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Memo.UTF8W = (
          #1057#1076#1072#1083' '#1074#1086#1076#1080#1090#1077#1083#1100)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo185: TfrxMemoView
        ShiftMode = smDontShift
        Left = 680.000000000000000000
        Top = 662.000000000000000000
        Width = 125.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '['#1042#1086#1076#1080#1090#1077#1083#1100' '#1082#1086#1088#1086#1090']')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo186: TfrxMemoView
        ShiftMode = smDontShift
        Left = 690.000000000000000000
        Top = 703.000000000000000000
        Width = 99.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        HAlign = haCenter
        Memo.UTF8W = (
          '('#1088#1072#1089#1096#1080#1092#1088#1086#1074#1082#1072' '#1087#1086#1076#1087#1080#1089#1080')')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo187: TfrxMemoView
        ShiftMode = smDontShift
        Left = 570.000000000000000000
        Top = 702.000000000000000000
        Width = 90.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftTop]
        HAlign = haCenter
        Memo.UTF8W = (
          '('#1087#1086#1076#1087#1080#1089#1100')')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo188: TfrxMemoView
        ShiftMode = smDontShift
        Left = 469.000000000000000000
        Top = 688.000000000000000000
        Width = 98.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Memo.UTF8W = (
          #1055#1088#1080#1085#1103#1083' '#1084#1077#1093#1072#1085#1080#1082)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo190: TfrxMemoView
        ShiftMode = smDontShift
        Left = 680.000000000000000000
        Top = 688.000000000000000000
        Width = 125.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '['#1052#1077#1093#1072#1085#1080#1082' '#1087#1088#1080#1085']')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo191: TfrxMemoView
        ShiftMode = smDontShift
        Left = 469.000000000000000000
        Top = 639.000000000000000000
        Width = 164.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1055#1088#1080' '#1074#1086#1079#1074#1088#1072#1097#1077#1085#1080#1080' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1100)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo193: TfrxMemoView
        ShiftMode = smDontShift
        Left = 636.000000000000000000
        Top = 648.000000000000000000
        Width = 90.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -7
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Frame.Typ = [ftTop]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo194: TfrxMemoView
        ShiftMode = smDontShift
        Left = 881.000000000000000000
        Top = 54.000000000000000000
        Width = 40.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        HAlign = haCenter
        Memo.UTF8W = (
          #1057#1077#1088#1080#1103)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo195: TfrxMemoView
        ShiftMode = smDontShift
        Left = 937.000000000000000000
        Top = 42.000000000000000000
        Width = 23.000000000000000000
        Height = 13.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        HAlign = haCenter
        Memo.UTF8W = (
          #8470)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo196: TfrxMemoView
        ShiftMode = smDontShift
        Left = 872.000000000000000000
        Top = 36.000000000000000000
        Width = 63.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo197: TfrxMemoView
        ShiftMode = smDontShift
        Left = 960.000000000000000000
        Top = 36.000000000000000000
        Width = 84.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '['#8470' '#1087#1091#1090#1077#1074#1086#1075#1086']')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo198: TfrxMemoView
        ShiftMode = smDontShift
        Left = 835.000000000000000000
        Top = 66.000000000000000000
        Width = 216.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        DisplayFormat.FormatStr = 'd MMMM yyyy '#39#1075'.'#39
        DisplayFormat.Kind = fkDateTime
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        Memo.UTF8W = (
          #1086#1090' ['#1044#1072#1090#1072']')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo199: TfrxMemoView
        ShiftMode = smDontShift
        Left = 835.000000000000000000
        Top = 88.000000000000000000
        Width = 70.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo200: TfrxMemoView
        ShiftMode = smDontShift
        Left = 905.000000000000000000
        Top = 88.000000000000000000
        Width = 145.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '['#1055#1088#1077#1076#1087#1088#1080#1103#1090#1080#1077']')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo201: TfrxMemoView
        ShiftMode = smDontShift
        Left = 835.000000000000000000
        Top = 104.000000000000000000
        Width = 102.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1052#1072#1088#1082#1072' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo202: TfrxMemoView
        ShiftMode = smDontShift
        Left = 938.000000000000000000
        Top = 104.000000000000000000
        Width = 113.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '['#1052#1072#1088#1082#1072']')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo203: TfrxMemoView
        ShiftMode = smDontShift
        Left = 835.000000000000000000
        Top = 124.000000000000000000
        Width = 177.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1043#1086#1089#1091#1076#1072#1088#1089#1090#1074#1077#1085#1085#1099#1081' '#1085#1086#1084#1077#1088#1085#1086#1081' '#1079#1085#1072#1082)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo204: TfrxMemoView
        ShiftMode = smDontShift
        Left = 834.000000000000000000
        Top = 144.000000000000000000
        Width = 217.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '['#1043#1086#1089'. '#1085#1086#1084#1077#1088']')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo205: TfrxMemoView
        ShiftMode = smDontShift
        Left = 835.000000000000000000
        Top = 164.000000000000000000
        Width = 56.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1042#1086#1076#1080#1090#1077#1083#1100)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo206: TfrxMemoView
        ShiftMode = smDontShift
        Left = 892.000000000000000000
        Top = 164.000000000000000000
        Width = 159.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '['#1042#1086#1076#1080#1090#1077#1083#1100' '#1082#1086#1088#1086#1090']')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo207: TfrxMemoView
        ShiftMode = smDontShift
        Left = 835.000000000000000000
        Top = 184.000000000000000000
        Width = 56.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1047#1072#1082#1072#1079#1095#1080#1082)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo208: TfrxMemoView
        ShiftMode = smDontShift
        Left = 892.000000000000000000
        Top = 184.000000000000000000
        Width = 159.000000000000000000
        Height = 37.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsUnderline]
        Memo.UTF8W = (
          '['#1050#1083#1080#1077#1085#1090']')
        ParentFont = False
        WordBreak = True
      end
      object Memo209: TfrxMemoView
        ShiftMode = smDontShift
        Left = 834.000000000000000000
        Top = 222.000000000000000000
        Width = 217.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Frame.Typ = [ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo211: TfrxMemoView
        ShiftMode = smDontShift
        Left = 833.000000000000000000
        Top = 252.000000000000000000
        Width = 103.000000000000000000
        Height = 30.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1042#1088#1077#1084#1103', '#1095'. '#1084#1080#1085'.')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo212: TfrxMemoView
        ShiftMode = smDontShift
        Left = 936.000000000000000000
        Top = 252.000000000000000000
        Width = 115.000000000000000000
        Height = 30.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1055#1086#1082#1072#1079#1072#1085#1080#1077' '#1089#1087#1080#1076#1086#1084#1077#1090'-'
          #1088#1072', '#1082#1084)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo213: TfrxMemoView
        ShiftMode = smDontShift
        Left = 833.000000000000000000
        Top = 307.000000000000000000
        Width = 51.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '19')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo214: TfrxMemoView
        ShiftMode = smDontShift
        Left = 884.000000000000000000
        Top = 307.000000000000000000
        Width = 52.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '20')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo215: TfrxMemoView
        ShiftMode = smDontShift
        Left = 936.000000000000000000
        Top = 307.000000000000000000
        Width = 57.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '21')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo216: TfrxMemoView
        ShiftMode = smDontShift
        Left = 993.000000000000000000
        Top = 307.000000000000000000
        Width = 58.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '22')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo217: TfrxMemoView
        ShiftMode = smDontShift
        Left = 833.000000000000000000
        Top = 318.000000000000000000
        Width = 51.000000000000000000
        Height = 18.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo218: TfrxMemoView
        ShiftMode = smDontShift
        Left = 884.000000000000000000
        Top = 318.000000000000000000
        Width = 52.000000000000000000
        Height = 18.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo219: TfrxMemoView
        ShiftMode = smDontShift
        Left = 936.000000000000000000
        Top = 318.000000000000000000
        Width = 57.000000000000000000
        Height = 18.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo220: TfrxMemoView
        ShiftMode = smDontShift
        Left = 993.000000000000000000
        Top = 318.000000000000000000
        Width = 58.000000000000000000
        Height = 18.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo221: TfrxMemoView
        ShiftMode = smDontShift
        Left = 833.000000000000000000
        Top = 282.000000000000000000
        Width = 51.000000000000000000
        Height = 25.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1087#1088#1080#1073#1099'-'
          #1090#1080#1103)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo222: TfrxMemoView
        ShiftMode = smDontShift
        Left = 884.000000000000000000
        Top = 282.000000000000000000
        Width = 52.000000000000000000
        Height = 25.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1091#1073#1099#1090#1080#1103)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo223: TfrxMemoView
        ShiftMode = smDontShift
        Left = 936.000000000000000000
        Top = 282.000000000000000000
        Width = 57.000000000000000000
        Height = 25.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1087#1088#1080' '#1087#1088#1080'-'
          #1073#1099#1090#1080#1080)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo224: TfrxMemoView
        ShiftMode = smDontShift
        Left = 993.000000000000000000
        Top = 282.000000000000000000
        Width = 58.000000000000000000
        Height = 25.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1087#1088#1080' '
          #1091#1073#1099#1090#1080#1080)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo225: TfrxMemoView
        ShiftMode = smDontShift
        Left = 951.000000000000000000
        Top = 352.000000000000000000
        Width = 103.338590000000000000
        Height = 11.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        HAlign = haCenter
        Memo.UTF8W = (
          '('#1088#1072#1089#1096#1080#1092#1088#1086#1074#1082#1072' '#1087#1086#1076#1087#1080#1089#1080')')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo226: TfrxMemoView
        ShiftMode = smDontShift
        Left = 889.000000000000000000
        Top = 351.000000000000000000
        Width = 51.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftTop]
        HAlign = haCenter
        Memo.UTF8W = (
          '('#1087#1086#1076#1087#1080#1089#1100')')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo227: TfrxMemoView
        ShiftMode = smDontShift
        Left = 834.000000000000000000
        Top = 337.000000000000000000
        Width = 54.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Memo.UTF8W = (
          #1047#1072#1082#1072#1079#1095#1080#1082)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo229: TfrxMemoView
        ShiftMode = smDontShift
        Left = 952.000000000000000000
        Top = 337.000000000000000000
        Width = 99.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo230: TfrxMemoView
        ShiftMode = smDontShift
        Left = 840.000000000000000000
        Top = 355.000000000000000000
        Width = 26.000000000000000000
        Height = 16.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1052'.'#1055'.')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo231: TfrxMemoView
        ShiftMode = smDontShift
        Left = 867.000000000000000000
        Top = 607.000000000000000000
        Width = 156.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        HAlign = haCenter
        Memo.UTF8W = (
          '('#1092#1072#1084#1080#1083#1080#1103', '#1080'., '#1086'. '#1086#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1086#1075#1086' '#1083#1080#1094#1072')')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo232: TfrxMemoView
        ShiftMode = smDontShift
        Left = 833.000000000000000000
        Top = 386.000000000000000000
        Width = 218.000000000000000000
        Height = 16.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Memo.UTF8W = (
          #1058#1072#1083#1086#1085' '#1074#1090#1086#1088#1086#1075#1086' '#1079#1072#1082#1072#1079#1095#1080#1082#1072' '#1082' '#1087#1091#1090#1077#1074#1086#1084#1091)
        ParentFont = False
      end
      object Memo233: TfrxMemoView
        ShiftMode = smDontShift
        Left = 834.000000000000000000
        Top = 403.000000000000000000
        Width = 35.000000000000000000
        Height = 16.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1083#1080#1089#1090#1091)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo234: TfrxMemoView
        ShiftMode = smDontShift
        Left = 881.000000000000000000
        Top = 421.000000000000000000
        Width = 40.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        HAlign = haCenter
        Memo.UTF8W = (
          #1057#1077#1088#1080#1103)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo235: TfrxMemoView
        ShiftMode = smDontShift
        Left = 937.000000000000000000
        Top = 409.000000000000000000
        Width = 23.000000000000000000
        Height = 13.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        HAlign = haCenter
        Memo.UTF8W = (
          #8470)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo236: TfrxMemoView
        ShiftMode = smDontShift
        Left = 872.000000000000000000
        Top = 403.000000000000000000
        Width = 63.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo237: TfrxMemoView
        ShiftMode = smDontShift
        Left = 960.000000000000000000
        Top = 403.000000000000000000
        Width = 84.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo238: TfrxMemoView
        ShiftMode = smDontShift
        Left = 835.000000000000000000
        Top = 433.000000000000000000
        Width = 216.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        Memo.UTF8W = (
          #1086#1090)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo239: TfrxMemoView
        ShiftMode = smDontShift
        Left = 835.000000000000000000
        Top = 455.000000000000000000
        Width = 70.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo240: TfrxMemoView
        ShiftMode = smDontShift
        Left = 905.000000000000000000
        Top = 455.000000000000000000
        Width = 145.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '['#1055#1088#1077#1076#1087#1088#1080#1103#1090#1080#1077']')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo241: TfrxMemoView
        ShiftMode = smDontShift
        Left = 835.000000000000000000
        Top = 471.000000000000000000
        Width = 102.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1052#1072#1088#1082#1072' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo242: TfrxMemoView
        ShiftMode = smDontShift
        Left = 938.000000000000000000
        Top = 471.000000000000000000
        Width = 113.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo243: TfrxMemoView
        ShiftMode = smDontShift
        Left = 835.000000000000000000
        Top = 491.000000000000000000
        Width = 177.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1043#1086#1089#1091#1076#1072#1088#1089#1090#1074#1077#1085#1085#1099#1081' '#1085#1086#1084#1077#1088#1085#1086#1081' '#1079#1085#1072#1082)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo244: TfrxMemoView
        ShiftMode = smDontShift
        Left = 834.000000000000000000
        Top = 511.000000000000000000
        Width = 217.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo245: TfrxMemoView
        ShiftMode = smDontShift
        Left = 835.000000000000000000
        Top = 531.000000000000000000
        Width = 56.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1042#1086#1076#1080#1090#1077#1083#1100)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo246: TfrxMemoView
        ShiftMode = smDontShift
        Left = 892.000000000000000000
        Top = 531.000000000000000000
        Width = 159.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo247: TfrxMemoView
        ShiftMode = smDontShift
        Left = 835.000000000000000000
        Top = 551.000000000000000000
        Width = 56.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1047#1072#1082#1072#1079#1095#1080#1082)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo248: TfrxMemoView
        ShiftMode = smDontShift
        Left = 892.000000000000000000
        Top = 551.000000000000000000
        Width = 159.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo249: TfrxMemoView
        ShiftMode = smDontShift
        Left = 834.000000000000000000
        Top = 589.000000000000000000
        Width = 217.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Frame.Typ = [ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo250: TfrxMemoView
        ShiftMode = smDontShift
        Left = 833.000000000000000000
        Top = 619.000000000000000000
        Width = 103.000000000000000000
        Height = 30.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1042#1088#1077#1084#1103', '#1095'. '#1084#1080#1085'.')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo251: TfrxMemoView
        ShiftMode = smDontShift
        Left = 936.000000000000000000
        Top = 619.000000000000000000
        Width = 115.000000000000000000
        Height = 30.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1055#1086#1082#1072#1079#1072#1085#1080#1077' '#1089#1087#1080#1076#1086#1084#1077#1090'-'
          #1088#1072', '#1082#1084)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo252: TfrxMemoView
        ShiftMode = smDontShift
        Left = 833.000000000000000000
        Top = 674.000000000000000000
        Width = 51.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '19')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo253: TfrxMemoView
        ShiftMode = smDontShift
        Left = 884.000000000000000000
        Top = 674.000000000000000000
        Width = 52.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '20')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo254: TfrxMemoView
        ShiftMode = smDontShift
        Left = 936.000000000000000000
        Top = 674.000000000000000000
        Width = 57.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '21')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo255: TfrxMemoView
        ShiftMode = smDontShift
        Left = 993.000000000000000000
        Top = 674.000000000000000000
        Width = 58.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          '22')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo256: TfrxMemoView
        ShiftMode = smDontShift
        Left = 833.000000000000000000
        Top = 685.000000000000000000
        Width = 51.000000000000000000
        Height = 18.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo257: TfrxMemoView
        ShiftMode = smDontShift
        Left = 884.000000000000000000
        Top = 685.000000000000000000
        Width = 52.000000000000000000
        Height = 18.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo258: TfrxMemoView
        ShiftMode = smDontShift
        Left = 936.000000000000000000
        Top = 685.000000000000000000
        Width = 57.000000000000000000
        Height = 18.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo259: TfrxMemoView
        ShiftMode = smDontShift
        Left = 993.000000000000000000
        Top = 685.000000000000000000
        Width = 58.000000000000000000
        Height = 18.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo260: TfrxMemoView
        ShiftMode = smDontShift
        Left = 833.000000000000000000
        Top = 649.000000000000000000
        Width = 51.000000000000000000
        Height = 25.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1087#1088#1080#1073#1099'-'
          #1090#1080#1103)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo261: TfrxMemoView
        ShiftMode = smDontShift
        Left = 884.000000000000000000
        Top = 649.000000000000000000
        Width = 52.000000000000000000
        Height = 25.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1091#1073#1099#1090#1080#1103)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo262: TfrxMemoView
        ShiftMode = smDontShift
        Left = 936.000000000000000000
        Top = 649.000000000000000000
        Width = 57.000000000000000000
        Height = 25.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1087#1088#1080' '#1087#1088#1080'-'
          #1073#1099#1090#1080#1080)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo263: TfrxMemoView
        ShiftMode = smDontShift
        Left = 993.000000000000000000
        Top = 649.000000000000000000
        Width = 58.000000000000000000
        Height = 25.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1087#1088#1080' '
          #1091#1073#1099#1090#1080#1080)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo264: TfrxMemoView
        ShiftMode = smDontShift
        Left = 946.000000000000000000
        Top = 719.000000000000000000
        Width = 107.118120000000000000
        Height = 11.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        HAlign = haCenter
        Memo.UTF8W = (
          '('#1088#1072#1089#1096#1080#1092#1088#1086#1074#1082#1072' '#1087#1086#1076#1087#1080#1089#1080')')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo265: TfrxMemoView
        ShiftMode = smDontShift
        Left = 888.000000000000000000
        Top = 718.000000000000000000
        Width = 52.000000000000000000
        Height = 11.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftTop]
        HAlign = haCenter
        Memo.UTF8W = (
          '('#1087#1086#1076#1087#1080#1089#1100')')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo266: TfrxMemoView
        ShiftMode = smDontShift
        Left = 834.000000000000000000
        Top = 704.000000000000000000
        Width = 54.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Memo.UTF8W = (
          #1047#1072#1082#1072#1079#1095#1080#1082)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo268: TfrxMemoView
        ShiftMode = smDontShift
        Left = 952.000000000000000000
        Top = 704.000000000000000000
        Width = 99.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo269: TfrxMemoView
        ShiftMode = smDontShift
        Left = 840.000000000000000000
        Top = 722.000000000000000000
        Width = 26.000000000000000000
        Height = 16.000000000000000000
        ShowHint = False
        AllowExpressions = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Memo.UTF8W = (
          #1052'.'#1055'.')
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo270: TfrxMemoView
        ShiftMode = smDontShift
        Left = 833.000000000000000000
        Top = 371.000000000000000000
        Width = 219.000000000000000000
        Height = 15.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1083#1080#1085#1080#1103'   '#1086#1090#1088#1077#1079#1072)
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo4: TfrxMemoView
        ShiftMode = smDontShift
        Left = 821.000000000000000000
        Top = 19.000000000000000000
        Width = 12.000000000000000000
        Height = 719.000000000000000000
        ShowHint = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        Memo.UTF8W = (
          #1051
          #1048
          #1053
          #1048
          #1071
          ''
          ''
          #1054
          #1058
          #1056
          #1045
          #1047
          #1040)
        ParentFont = False
        VAlign = vaCenter
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
  object frxXLSExport: TfrxXLSExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    ExportEMF = True
    AsText = False
    Background = True
    FastExport = True
    PageBreaks = True
    EmptyLines = True
    SuppressPageHeadersFooters = False
    Left = 56
    Top = 144
  end
  object frxXMLExport: TfrxXMLExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    Background = True
    Creator = 'FastReport'
    EmptyLines = True
    SuppressPageHeadersFooters = False
    RowsCount = 0
    Split = ssNotSplit
    Left = 56
    Top = 192
  end
  object frxRTFExport: TfrxRTFExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    PictureType = gpPNG
    Wysiwyg = True
    Creator = 'FastReport'
    SuppressPageHeadersFooters = False
    HeaderFooterMode = hfText
    AutoSize = False
    Left = 56
    Top = 104
  end
end
