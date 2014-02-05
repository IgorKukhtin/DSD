object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1081' '#1059#1095#1077#1090' '#171'Project'#187
  ClientHeight = 407
  ClientWidth = 838
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesigned
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object dxBarManager: TdxBarManager
    AllowCallFromAnotherForm = True
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
      47
      0)
    object dxBar: TdxBar
      AllowClose = False
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
          ItemName = 'bbHistory'
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
          ItemName = 'bbReportsProduction'
        end
        item
          Visible = True
          ItemName = 'bbReportsGoods'
        end
        item
          Visible = True
          ItemName = 'bbReportsFinance'
        end
        item
          Visible = True
          ItemName = 'bbReportMain'
        end
        item
          Visible = True
          ItemName = 'bbGuides'
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
          ItemName = 'bbGoodsDocuments_Separator'
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
          ItemName = 'bbSendOnPrice'
        end
        item
          Visible = True
          ItemName = 'bbGoodsDocuments_Separator'
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
          ItemName = 'bbGoodsDocuments_Separator'
        end
        item
          Visible = True
          ItemName = 'bbSend'
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
          ItemName = 'bbGoodsDocuments_Separator'
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
    object bbGoodsDocuments_Separator: TdxBarSeparator
      Caption = 'bbGoodsDocuments_Separator'
      Category = 0
      Hint = 'bbGoodsDocuments_Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbIncome: TdxBarButton
      Action = actIncome
      Category = 0
    end
    object bbReturnOut: TdxBarButton
      Action = actReturnOut
      Category = 0
    end
    object bbSale: TdxBarButton
      Action = actSale
      Category = 0
    end
    object bbReturnIn: TdxBarButton
      Action = actReturnIn
      Category = 0
    end
    object bbSendOnPrice: TdxBarButton
      Action = actSendOnPrice
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
    object bbSend: TdxBarButton
      Action = actSend
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
    object bbZakazExternal: TdxBarButton
      Action = actZakazExternal
      Category = 0
    end
    object bbZakazInternal: TdxBarButton
      Action = actZakazInternal
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
        end
        item
          Visible = True
          ItemName = 'bbFinanceDocuments_Separator'
        end
        item
          Visible = True
          ItemName = 'bbJuridicalService'
        end
        item
          Visible = True
          ItemName = 'bbBankLoad'
        end
        item
          Visible = True
          ItemName = 'bbBankAccountDocument'
        end
        item
          Visible = True
          ItemName = 'bbFinanceDocuments_Separator'
        end
        item
          Visible = True
          ItemName = 'bbLossDebt'
        end
        item
          Visible = True
          ItemName = 'bbSendDebt'
        end>
    end
    object bbFinanceDocuments_Separator: TdxBarSeparator
      Caption = 'bbFinanceDocuments_Separator'
      Category = 0
      Hint = 'bbFinanceDocuments_Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbIncomeCash: TdxBarButton
      Action = actCashOperation
      Category = 0
    end
    object bbJuridicalService: TdxBarButton
      Action = actService
      Category = 0
    end
    object bbBankLoad: TdxBarButton
      Action = actBankLoad
      Category = 0
    end
    object bbBankAccountDocument: TdxBarButton
      Action = actBankAccountDocument
      Category = 0
    end
    object bbLossDebt: TdxBarButton
      Action = actLossDebt
      Category = 0
    end
    object bbSendDebt: TdxBarButton
      Action = actSendDebt
      Caption = #1042#1079#1072#1080#1084#1086#1079#1072#1095#1077#1090' ('#1102#1088'. '#1083#1080#1094#1072')'
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
    object bbHistory_Separator: TdxBarSeparator
      Caption = 'bbHistory_Separator'
      Category = 0
      Hint = 'bbHistory_Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbPriceListItem: TdxBarButton
      Action = actPriceListItem
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
          ItemName = 'bbPersonalAccount'
        end
        item
          Visible = True
          ItemName = 'bbTransportService'
        end
        item
          Visible = True
          ItemName = 'bbSendTicketFuel'
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
          ItemName = 'bbReport_TransportHoursWork'
        end>
    end
    object bbTransportDocuments_Separator: TdxBarSeparator
      Caption = 'bbTransportDocuments_Separator'
      Category = 0
      Hint = 'bbTransportDocuments_Separator'
      Visible = ivAlways
      ShowCaption = False
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
    object bbPersonalAccount: TdxBarButton
      Action = actPersonalAccount
      Category = 0
    end
    object bbTransportService: TdxBarButton
      Action = actTransportService
      Category = 0
    end
    object bbSendTicketFuel: TdxBarButton
      Action = actSendTicketFuel
      Category = 0
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
    object bbReport_TransportHoursWork: TdxBarButton
      Action = actReport_TransportHoursWork
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
          ItemName = 'bbStaffListData'
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
          ItemName = 'bbCalendar'
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
    object bbPersonalDocuments_Separator: TdxBarSeparator
      Caption = 'bbPersonalDocuments_Separator'
      Category = 0
      Hint = 'bbPersonalDocuments_Separator'
      Visible = ivAlways
      ShowCaption = False
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
    object bbPositionLevel: TdxBarButton
      Action = actPositionLevel
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
    object bbStaffListData: TdxBarButton
      Action = actStaffListData
      Category = 0
    end
    object bbModelService: TdxBarButton
      Action = actModelService
      Category = 0
    end
    object bbCalendar: TdxBarButton
      Action = actCalendar
      Category = 0
    end
    object bbSheetWorkTime: TdxBarButton
      Action = actSheetWorkTime
      Category = 0
    end
    object bbPersonalService: TdxBarButton
      Action = actPersonalService
      Category = 0
    end
    object bbReportsProduction: TdxBarSubItem
      Caption = #1054#1090#1095#1077#1090#1099' ('#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end>
    end
    object bbReportsProduction_Separator: TdxBarSeparator
      Caption = 'bbReportsProduction_Separator'
      Category = 0
      Hint = 'bbReportsProduction_Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object dxBarButton1: TdxBarButton
      Action = actReport_Production_Union
      Category = 0
    end
    object bbReportsGoods: TdxBarSubItem
      Caption = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074#1072#1088#1099')'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbReport_MotionGoods'
        end
        item
          Visible = True
          ItemName = 'bbReport_Goods'
        end
        item
          Visible = True
          ItemName = 'bbReportsGoods_Separator'
        end
        item
          Visible = True
          ItemName = 'bbReport_Goods_Movement'
        end
        item
          Visible = True
          ItemName = 'bbReport_GoodsMISale'
        end
        item
          Visible = True
          ItemName = 'bbReport_GoodsMI_byMovementSale'
        end
        item
          Visible = True
          ItemName = 'bbReport_GoodsMIReturn'
        end
        item
          Visible = True
          ItemName = 'bbReport_GoodsMI_byMovementReturn'
        end
        item
          Visible = True
          ItemName = 'bbReportsGoods_Separator'
        end
        item
          Visible = True
          ItemName = 'bbReportHistoryCost'
        end>
    end
    object bbReportsGoods_Separator: TdxBarSeparator
      Caption = 'bbReportsGoods_Separator'
      Category = 0
      Hint = 'bbReportsGoods_Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbReport_MotionGoods: TdxBarButton
      Action = actReport_MotionGoods
      Category = 0
    end
    object bbReport_Goods: TdxBarButton
      Action = actReport_Goods
      Category = 0
    end
    object bbReport_Goods_Movement: TdxBarButton
      Action = actReport_Goods_Movement
      Category = 0
    end
    object bbReport_GoodsMISale: TdxBarButton
      Action = actReport_GoodsMISale
      Category = 0
    end
    object bbReport_GoodsMI_byMovementSale: TdxBarButton
      Action = actReport_GoodsMI_byMovementSale
      Category = 0
    end
    object bbReport_GoodsMIReturn: TdxBarButton
      Action = actReport_GoodsMIReturn
      Category = 0
    end
    object bbReport_GoodsMI_byMovementReturn: TdxBarButton
      Action = actReport_GoodsMI_byMovementReturn
      Category = 0
    end
    object bbReportHistoryCost: TdxBarButton
      Action = actReport_HistoryCost
      Category = 0
    end
    object bbReportsFinance: TdxBarSubItem
      Caption = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085#1072#1085#1089#1099')'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbReport_JuridicalSold'
        end
        item
          Visible = True
          ItemName = 'bbReport_JuridicalCollation'
        end
        item
          Visible = True
          ItemName = 'bbReportsFinance_Separator'
        end
        item
          Visible = True
          ItemName = 'bbAccountReport'
        end>
    end
    object bbReportsFinance_Separator: TdxBarSeparator
      Caption = 'bbReportsFinance_Separator'
      Category = 0
      Hint = 'bbReportsFinance_Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbReport_JuridicalSold: TdxBarButton
      Action = actReport_JuridicalSold
      Category = 0
    end
    object bbReport_JuridicalCollation: TdxBarButton
      Action = actReport_JuridicalCollation
      Category = 0
    end
    object bbAccountReport: TdxBarButton
      Action = actReport_Account
      Category = 0
    end
    object bbReportMain: TdxBarSubItem
      Caption = #1054#1090#1095#1077#1090#1099' ('#1091#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077')'
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
        end>
    end
    object bbReportMain_Separator: TdxBarSeparator
      Caption = 'bbReportMain_Separator'
      Category = 0
      Hint = 'bbReportMain_Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbReportBalance: TdxBarButton
      Action = actReport_Balance
      Category = 0
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
          ItemName = 'bbJuridical_List'
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
          ItemName = 'bbArea'
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
          ItemName = 'bbContractConditionValue'
        end
        item
          Visible = True
          ItemName = 'bbContract'
        end
        item
          Visible = True
          ItemName = 'bbContractKind'
        end
        item
          Visible = True
          ItemName = 'bbContractArticle'
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
          ItemName = 'bbUnit_List'
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
          ItemName = 'bbCity'
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
    object bbReportProfitLoss: TdxBarButton
      Action = actReport_ProfitLoss
      Category = 0
    end
    object bbGuides_Separator: TdxBarSeparator
      Caption = 'bbGuides_Separator'
      Category = 0
      Hint = 'bbGuides_Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbJuridicalGroup: TdxBarButton
      Action = actJuridicalGroup
      Category = 0
    end
    object bbJuridical_List: TdxBarButton
      Action = actJuridical_List
      Category = 0
    end
    object bbJuridical: TdxBarButton
      Action = actJuridical
      Category = 0
    end
    object bbPartner: TdxBarButton
      Action = actPartner
      Category = 0
    end
    object bbRouteSorting: TdxBarButton
      Action = actRouteSorting
      Category = 0
    end
    object bbArea: TdxBarButton
      Action = actArea
      Category = 0
    end
    object bbPaidKind: TdxBarButton
      Action = actPaidKind
      Category = 0
    end
    object bbContractConditionValue: TdxBarButton
      Action = actContractConditionValue
      Category = 0
    end
    object bbContract: TdxBarButton
      Action = actContract
      Category = 0
    end
    object bbContractKind: TdxBarButton
      Action = actContractKind
      Category = 0
    end
    object bbContractArticle: TdxBarButton
      Action = actContractArticle
      Category = 0
    end
    object bbAsset: TdxBarButton
      Action = actAsset
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
    object bbUnit_List: TdxBarButton
      Action = actUnit_List
      Category = 0
    end
    object bbUnit: TdxBarButton
      Action = actUnit
      Category = 0
    end
    object bbCash: TdxBarButton
      Action = actCash
      Category = 0
    end
    object bbBank: TdxBarButton
      Action = actBank
      Category = 0
    end
    object bbBankAccount: TdxBarButton
      Action = actBankAccount
      Category = 0
    end
    object bbCurrency: TdxBarButton
      Action = actCurrency
      Category = 0
    end
    object bbCity: TdxBarButton
      Action = actCity
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
    object bbMeasure: TdxBarButton
      Action = actMeasure
      Category = 0
    end
    object bbGoodsProperty: TdxBarButton
      Action = actGoodsProperty
      Category = 0
    end
    object bbTradeMark: TdxBarButton
      Action = actTradeMark
      Category = 0
    end
    object bbPriceList: TdxBarButton
      Action = actPriceList
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
    object bbAccount: TdxBarButton
      Action = actAccount
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
    object bbProfitLoss: TdxBarButton
      Action = actProfitLoss
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
          ItemName = 'bbSetUserDefaults'
        end
        item
          Visible = True
          ItemName = 'bbProtocol'
        end
        item
          Visible = True
          ItemName = 'bbMovementDesc'
        end
        item
          Visible = True
          ItemName = 'bbPartner1CLink'
        end
        item
          Visible = True
          ItemName = 'bbGoods1CLink'
        end
        item
          Visible = True
          ItemName = 'bbLoad1CSale'
        end
        item
          Visible = True
          ItemName = 'bbService_Separator'
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
    object bbService_Separator: TdxBarSeparator
      Caption = 'bbService_Separator'
      Category = 0
      Hint = 'bbService_Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbRole: TdxBarButton
      Action = actRole
      Category = 0
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
    object bbProtocol: TdxBarButton
      Action = actProtocol
      Category = 0
    end
    object bbSetUserDefaults: TdxBarButton
      Action = actSetUserDefaults
      Category = 0
    end
    object bbMovementDesc: TdxBarButton
      Action = actMovementDesc
      Category = 0
    end
    object bbPartner1CLink: TdxBarButton
      Action = actPartner1CLink
      Category = 0
    end
    object bbGoods1CLink: TdxBarButton
      Action = actGoodsByGoodsKind1CLink
      Category = 0
    end
    object bbLoad1CSale: TdxBarButton
      Action = actLoad1CSale
      Category = 0
    end
    object bbAbout: TdxBarButton
      Action = actAbout
      Category = 0
    end
    object bbUpdateProgramm: TdxBarButton
      Action = actUpdateProgram
      Category = 0
    end
    object bbExit: TdxBarButton
      Action = actExit
      Category = 0
    end
  end
  object ActionList: TActionList
    Left = 192
    Top = 48
    object actTransport: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1055#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090
      Hint = #1055#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090
      FormName = 'TTransportJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actIncomeFuel: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1047#1072#1087#1088#1072#1074#1082#1072' '#1072#1074#1090#1086') '
      Hint = #1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1079#1072#1087#1088#1072#1074#1082#1072' '#1072#1074#1090#1086') '
      FormName = 'TIncomeFuelJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPersonalSendCash: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1056#1072#1089#1093#1086#1076' '#1076#1077#1085#1077#1075' '#1089' '#1087#1086#1076#1086#1090#1095#1077#1090#1072' '#1085#1072' '#1087#1086#1076#1086#1090#1095#1077#1090
      Hint = #1056#1072#1089#1093#1086#1076' '#1076#1077#1085#1077#1075' '#1089' '#1087#1086#1076#1086#1090#1095#1077#1090#1072' '#1085#1072' '#1087#1086#1076#1086#1090#1095#1077#1090
      FormName = 'TPersonalSendCashJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPersonalGroup: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      Caption = #1043#1088#1091#1087#1087#1080#1088#1086#1074#1082#1080' '#1057#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074' '
      Hint = #1043#1088#1091#1087#1087#1080#1088#1086#1074#1082#1080' '#1057#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074' '
      FormName = 'TPersonalGroupForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPersonal: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082#1080' '
      Hint = #1057#1086#1090#1088#1091#1076#1085#1080#1082#1080' '
      FormName = 'TPersonalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPosition: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1080' '
      Hint = #1044#1086#1083#1078#1085#1086#1089#1090#1080' '
      FormName = 'TPositionForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actCalendar: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      Caption = #1050#1072#1083#1077#1085#1076#1072#1088#1100' '#1088#1072#1073#1086#1095#1080#1093' '#1076#1085#1077#1081
      Hint = #1050#1072#1083#1077#1085#1076#1072#1088#1100' '#1088#1072#1073#1086#1095#1080#1093' '#1076#1085#1077#1081
      FormName = 'TCalendarForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPersonalAccount: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1056#1072#1089#1095#1077#1090#1099' '#1087#1086#1076#1086#1090#1095#1077#1090#1072' '#1089' '#1102#1088'.'#1083#1080#1094#1086#1084
      Hint = #1056#1072#1089#1095#1077#1090#1099' '#1087#1086#1076#1086#1090#1095#1077#1090#1072' '#1089' '#1102#1088'.'#1083#1080#1094#1086#1084
      FormName = 'TPersonalAccountJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actMember: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      Caption = #1060#1080#1079#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      Hint = #1060#1080#1079#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      FormName = 'TMemberForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actTransportService: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1085#1072#1077#1084#1085#1099#1081' '#1090#1088#1072#1085#1089#1087#1086#1088#1090
      Hint = #1056#1072#1089#1095#1077#1090#1099' '#1087#1086#1076#1086#1090#1095#1077#1090#1072' '#1089' '#1102#1088'.'#1083#1080#1094#1086#1084
      FormName = 'TTransportServiceJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actSendTicketFuel: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' ('#1058#1072#1083#1086#1085#1099' '#1085#1072' '#1090#1086#1087#1083#1080#1074#1086')'
      Hint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' ('#1058#1072#1083#1086#1085#1099' '#1085#1072' '#1090#1086#1087#1083#1080#1074#1086')'
      FormName = 'TSendTicketFuelJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actStaffListData: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      Caption = #1064#1090#1072#1090#1085#1086#1077' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1077
      Hint = #1096#1090#1072#1090#1085#1086#1077' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1077
      FormName = 'TStaffListDataForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actCar: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1080
      Hint = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1080
      FormName = 'TCarForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actRoute: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1052#1072#1088#1096#1088#1091#1090#1099
      Hint = #1052#1072#1088#1096#1088#1091#1090#1099
      FormName = 'TRouteForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actCarModel: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1052#1072#1088#1082#1080' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1077#1081
      Hint = #1052#1072#1088#1082#1080' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1077#1081
      FormName = 'TCarModelForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actFuel: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1042#1080#1076#1099' '#1090#1086#1087#1083#1080#1074#1072
      Hint = #1042#1080#1076#1099' '#1090#1086#1087#1083#1080#1074#1072
      FormName = 'TFuelForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actRateFuelKind: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1042#1080#1076#1099' '#1085#1086#1088#1084' '#1090#1086#1087#1083#1080#1074#1072
      Hint = #1042#1080#1076#1099' '#1085#1086#1088#1084' '#1090#1086#1087#1083#1080#1074#1072
      FormName = 'TRateFuelKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Balance: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1091#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077')'
      Caption = #1041#1072#1083#1072#1085#1089
      FormName = 'TReport_BalanceForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_ProfitLoss: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1091#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077')'
      Caption = #1054#1090#1095#1077#1090' '#1086' '#1055#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1059#1073#1099#1090#1082#1072#1093
      FormName = 'TReport_ProfitLossForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actProcess: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Caption = #1055#1088#1086#1094#1077#1089#1089#1099
      Hint = #1055#1088#1086#1094#1077#1089#1089#1099
      FormName = 'TProcessForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actIncome: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      Caption = #1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
      FormName = 'TIncomeJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_HistoryCost: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090')'
      Caption = #1057#1077#1073#1077#1089#1090#1086#1080#1084#1086#1089#1090#1100
      FormName = 'TReport_HistoryCostForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
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
    object actReturnOut: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
      FormName = 'TReturnOutJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actSale: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102
      FormName = 'TSaleJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReturnIn: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
      FormName = 'TReturnInJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actSendOnPrice: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1094#1077#1085#1077
      FormName = 'TSendOnPriceJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actSend: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      FormName = 'TSendJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actProductionSeparate: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      FormName = 'TProductionSeparateJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actProductionUnion: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1089#1084#1077#1096#1080#1074#1072#1085#1080#1077
      FormName = 'TProductionUnionJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actLoss: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      Caption = #1057#1087#1080#1089#1072#1085#1080#1077
      FormName = 'TLossJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actInventory: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      Caption = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103
      FormName = 'TInventoryJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actBank: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
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
      Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1077' '#1089#1095#1077#1090#1072
      Hint = #1056#1072#1089#1095#1077#1090#1085#1099#1077' '#1089#1095#1077#1090#1072
      FormName = 'TBankAccountForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actBranch: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1060#1080#1083#1080#1072#1083#1099
      Hint = #1060#1080#1083#1080#1072#1083#1099
      FormName = 'TBranchForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actBusiness: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1041#1080#1079#1085#1077#1089#1099
      Hint = #1041#1080#1079#1085#1077#1089#1099
      FormName = 'TBusinessForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actCash: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1050#1072#1089#1089#1072
      Hint = #1050#1072#1089#1089#1072
      FormName = 'TCashForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actContractKind: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1042#1080#1076#1099' '#1076#1086#1075#1086#1074#1086#1088#1086#1074
      Hint = #1042#1080#1076#1099' '#1076#1086#1075#1086#1074#1086#1088#1086#1074
      FormName = 'TContractKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actContractConditionValue: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1044#1086#1075#1086#1074#1086#1088#1072' ('#1089' '#1091#1089#1083#1086#1074#1080#1103#1084#1080')'
      Hint = #1044#1086#1075#1086#1074#1086#1088#1072' ('#1089' '#1091#1089#1083#1086#1074#1080#1103#1084#1080')'
      FormName = 'TContractConditionValueForm'
      FormNameParam.Value = 'TContractConditionValueForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actContract: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1044#1086#1075#1086#1074#1086#1088#1072
      Hint = #1044#1086#1075#1086#1074#1086#1088#1072
      FormName = 'TContractForm'
      FormNameParam.Value = 'TContractForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actContractArticle: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1055#1088#1077#1076#1084#1077#1090' '#1076#1086#1075#1086#1074#1086#1088#1072
      Hint = #1055#1088#1077#1076#1084#1077#1090' '#1076#1086#1075#1086#1074#1086#1088#1072
      FormName = 'TContractArticleForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actArea: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1056#1077#1075#1080#1086#1085#1099
      Hint = #1056#1077#1075#1080#1086#1085#1099
      FormName = 'TAreaForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actCurrency: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1042#1072#1083#1102#1090#1099
      Hint = #1042#1072#1083#1102#1090#1099
      FormName = 'TCurrencyForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actGoods: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1058#1086#1074#1072#1088#1099
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TGoodsTreeForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1043#1088#1091#1087#1087#1099' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1043#1088#1091#1087#1087#1099' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TGoodsGroupForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsKind: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
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
      Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088#1099' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TGoodsPropertyForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actJuridical_List: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072' ('#1089#1087#1080#1089#1086#1082')'
      Hint = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      FormName = 'TJuridicalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actJuridical: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      Hint = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      FormName = 'TJuridicalTreeForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actJuridicalGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1043#1088#1091#1087#1087#1099' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1080#1093' '#1083#1080#1094
      Hint = #1043#1088#1091#1087#1087#1099' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1080#1093' '#1083#1080#1094
      FormName = 'TJuridicalGroupForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actMeasure: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1045#1076#1080#1085#1080#1094#1099' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
      Hint = #1045#1076#1080#1085#1080#1094#1099' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
      FormName = 'TMeasureForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPaidKind: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1042#1080#1076#1099' '#1092#1086#1088#1084' '#1086#1087#1083#1072#1090#1099
      Hint = #1042#1080#1076#1099' '#1092#1086#1088#1084' '#1086#1087#1083#1072#1090#1099
      FormName = 'TPaidKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPartner: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099
      Hint = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099
      FormName = 'TPartnerForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actUnit_List: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' ('#1089#1087#1080#1089#1086#1082')'
      Hint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
      FormName = 'TUnitForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actUnit: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
      Hint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
      FormName = 'TUnitTreeForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPriceList: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090#1099
      Hint = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090#1099
      FormName = 'TPriceListForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actInfoMoneyGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1043#1088#1091#1087#1087#1099' '#1091#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1093' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1081
      Hint = #1043#1088#1091#1087#1087#1099' '#1091#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1093' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1081
      FormName = 'TInfoMoneyGroupForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actInfoMoneyDestination: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      Hint = #1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      FormName = 'TInfoMoneyDestinationForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actInfoMoney: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1057#1090#1072#1090#1100#1080' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      Hint = #1057#1090#1072#1090#1100#1080' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      FormName = 'TInfoMoneyForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actAccountGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1043#1088#1091#1087#1087#1099' '#1089#1095#1077#1090#1086#1074
      Hint = #1043#1088#1091#1087#1087#1099' '#1089#1095#1077#1090#1086#1074
      FormName = 'TAccountGroupForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actAccountDirection: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1040#1085#1072#1083#1080#1090#1080#1082#1080' '#1089#1095#1077#1090#1086#1074' - '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1103
      Hint = #1040#1085#1072#1083#1080#1090#1080#1082#1080' '#1089#1095#1077#1090#1086#1074' - '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1103
      FormName = 'TAccountDirectionForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actProfitLossGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1043#1088#1091#1087#1087#1099' '#1089#1090#1072#1090#1077#1081' '#1086#1090#1095#1077#1090#1072' '#1086' '#1087#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1091#1073#1099#1090#1082#1072#1093
      Hint = #1043#1088#1091#1087#1087#1099' '#1089#1090#1072#1090#1077#1081' '#1086#1090#1095#1077#1090#1072' '#1086' '#1087#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1091#1073#1099#1090#1082#1072#1093
      FormName = 'TProfitLossGroupForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actProfitLossDirection: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1040#1085#1072#1083#1080#1090#1080#1082#1080' '#1089#1090#1072#1090#1077#1081' '#1086#1090#1095#1077#1090#1072' '#1086' '#1087#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1091#1073#1099#1090#1082#1072#1093' - '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1103
      Hint = #1040#1085#1072#1083#1080#1090#1080#1082#1080' '#1089#1090#1072#1090#1077#1081' '#1086#1090#1095#1077#1090#1072' '#1086' '#1087#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1091#1073#1099#1090#1082#1072#1093' - '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1103
      FormName = 'TProfitLossDirectionForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actAccount: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1057#1095#1077#1090#1072
      Hint = #1057#1095#1077#1090#1072
      FormName = 'TAccountForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actProfitLoss: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1057#1090#1072#1090#1100#1080' '#1086#1090#1095#1077#1090#1072' '#1086' '#1087#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1091#1073#1099#1090#1082#1072#1093
      Hint = #1057#1090#1072#1090#1100#1080' '#1086#1090#1095#1077#1090#1072' '#1086' '#1087#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1091#1073#1099#1090#1082#1072#1093
      FormName = 'TProfitLossForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actTradeMark: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1058#1086#1088#1075#1086#1074#1099#1077' '#1084#1072#1088#1082#1080
      Hint = #1058#1086#1088#1075#1086#1074#1099#1077' '#1084#1072#1088#1082#1080
      FormName = 'TTradeMarkForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actAsset: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1054#1089#1085#1086#1074#1085#1099#1077' '#1089#1088#1077#1076#1089#1090#1074#1072' '
      Hint = #1054#1089#1085#1086#1074#1085#1099#1077' '#1089#1088#1077#1076#1089#1090#1074#1072' '
      FormName = 'TAssetForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actRouteSorting: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1080' '#1084#1072#1088#1096#1088#1091#1090#1086#1074
      Hint = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1080' '#1084#1072#1088#1096#1088#1091#1090#1086#1074
      FormName = 'TRouteSortingForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actZakazExternal: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      Caption = #1047#1072#1103#1074#1082#1072' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
      FormName = 'TZakazExternalJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPriceListItem: TdsdOpenForm
      Category = #1048#1089#1090#1086#1088#1080#1080
      Caption = #1048#1089#1090#1086#1088#1080#1080' '#1094#1077#1085' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1048#1089#1090#1086#1088#1080#1080' '#1094#1077#1085' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TPriceListItemForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actZakazInternal: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      Caption = #1047#1072#1103#1074#1082#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1077#1085#1085#1072#1103
      FormName = 'TZakazInternalJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actCashOperation: TdsdOpenForm
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      Caption = #1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
      Hint = #1054#1087#1077#1088#1072#1094#1080#1080' '#1089' '#1082#1072#1089#1089#1086#1081
      FormName = 'TCashJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_MotionGoods: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090')'
      Caption = #1044#1074#1080#1078#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
      FormName = 'TReport_MotionGoodsForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actRole: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Caption = #1056#1086#1083#1080' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
      FormName = 'TRoleForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actAction: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Caption = #1044#1077#1081#1089#1090#1074#1080#1103
      Hint = #1044#1077#1081#1089#1090#1074#1080#1103
      FormName = 'TActionForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actUser: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080
      Hint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080
      FormName = 'TUserForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actRateFuel: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1053#1086#1088#1084#1099' '#1090#1086#1087#1083#1080#1074#1072
      Hint = #1053#1086#1088#1084#1099' '#1090#1086#1087#1083#1080#1074#1072
      FormName = 'TRateFuelForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actFreight: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1053#1072#1079#1074#1072#1085#1080#1103' '#1075#1088#1091#1079#1086#1074
      Hint = #1053#1072#1079#1074#1072#1085#1080#1103' '#1075#1088#1091#1079#1086#1074
      FormName = 'TFreightForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actCardFuel: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1058#1086#1087#1083#1080#1074#1085#1099#1077' '#1082#1072#1088#1090#1099
      Hint = #1058#1086#1087#1083#1080#1074#1085#1099#1077' '#1082#1072#1088#1090#1099
      FormName = 'TCardFuelForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actTicketFuel: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1058#1072#1083#1086#1085#1099' '#1085#1072' '#1090#1086#1087#1083#1080#1074#1086' '
      Hint = #1058#1072#1083#1086#1085#1099' '#1085#1072' '#1090#1086#1087#1083#1080#1074#1086' '
      FormName = 'TTicketFuelForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Fuel: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1088#1072#1089#1093#1086#1076#1072' '#1090#1086#1087#1083#1080#1074#1072
      Hint = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1088#1072#1089#1093#1086#1076#1072' '#1090#1086#1087#1083#1080#1074#1072
      FormName = 'TReport_FuelForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Transport: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1091#1090#1077#1074#1099#1084' '#1083#1080#1089#1090#1072#1084
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1091#1090#1077#1074#1099#1084' '#1083#1080#1089#1090#1072#1084
      FormName = 'TReport_TransportForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_TransportHoursWork: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1074#1086#1076#1080#1090#1077#1083#1103#1084' ('#1088#1072#1073#1086#1095#1077#1077' '#1074#1088#1077#1084#1103')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1074#1086#1076#1080#1090#1077#1083#1103#1084' ('#1088#1072#1073#1086#1095#1077#1077' '#1074#1088#1077#1084#1103')'
      FormName = 'TReport_TransportHoursWorkForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actWorkTimeKind: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      Caption = #1058#1080#1087#1099' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080
      Hint = #1058#1080#1087#1099' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080
      FormName = 'TWorkTimeKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actSheetWorkTime: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      Caption = #1058#1072#1073#1077#1083#1100' '#1091#1095#1077#1090#1072' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080
      Hint = #1058#1072#1073#1077#1083#1100' '#1091#1095#1077#1090#1072' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080
      FormName = 'TSheetWorkTimeJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPersonalService: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1079#1072#1088#1087#1083#1072#1090#1099
      Hint = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1079#1072#1088#1087#1083#1072#1090#1099
      FormName = 'TPersonalServiceForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Account: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1089#1095#1077#1090#1091
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1095#1077#1090#1091
      FormName = 'TReport_AccountForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Goods: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1095#1077#1090#1091
      FormName = 'TReport_GoodsForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPositionLevel: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      Caption = #1056#1072#1079#1088#1103#1076#1099' '#1076#1086#1083#1078#1085#1086#1089#1090#1077#1081' '
      Hint = #1056#1072#1079#1088#1103#1076#1099' '#1076#1086#1083#1078#1085#1086#1089#1090#1077#1081' '
      FormName = 'TPositionLevelForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actUpdateProgram: TAction
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1074#1077#1088#1089#1080#1102' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
      ShortCut = 57429
      OnExecute = actUpdateProgramExecute
    end
    object actModelService: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      Caption = #1052#1086#1076#1077#1083#1080' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
      Hint = #1052#1086#1076#1077#1083#1080' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
      FormName = 'TModelServiceForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actAbout: TAction
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077'...'
      OnExecute = actAboutExecute
    end
    object actProtocol: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Caption = #1055#1088#1086#1090#1086#1082#1086#1083
      Hint = #1055#1088#1086#1090#1086#1082#1086#1083
      FormName = 'TProtocolForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actService: TdsdOpenForm
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1091#1089#1083#1091#1075
      FormName = 'TServiceJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actBankLoad: TdsdOpenForm
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      Caption = #1041#1072#1085#1082#1086#1074#1089#1082#1080#1077' '#1074#1099#1087#1080#1089#1082#1080
      FormName = 'TBankStatementJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actBankAccountDocument: TdsdOpenForm
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
      FormName = 'TBankAccountJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actSetUserDefaults: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Caption = #1044#1077#1092#1086#1083#1090#1099' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081
      Hint = #1044#1077#1092#1086#1083#1090#1099' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081
      FormName = 'TSetUserDefaultsForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actLossDebt: TdsdOpenForm
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1079#1072#1076#1086#1083#1078#1077#1085#1085#1086#1089#1090#1080' ('#1102#1088'.'#1083#1080#1094#1072')'
      FormName = 'TLossDebtJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actCity: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1043#1086#1088#1086#1076#1072
      Hint = #1041#1072#1085#1082#1080
      FormName = 'TCityForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_JuridicalSold: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090')'
      Caption = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1102#1088'.'#1083#1080#1094#1072#1084
      FormName = 'TReport_JuridicalSoldForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_JuridicalCollation: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090')'
      Caption = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080
      FormName = 'TReport_JuridicalCollationForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actMovementDesc: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
      FormName = 'TMovementDescDataForm'
      FormNameParam.Value = 'TMovementDescDataForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsMIReturn: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090')'
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1090#1086#1074#1072#1088#1072
      FormName = 'TReport_GoodsMIForm'
      FormNameParam.Value = 'TReport_GoodsMIForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'inDescId'
          Value = 6
        end
        item
          Name = 'InDescName'
          Value = #1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1077#1081' ('#1080#1090#1086#1075')'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actReport_GoodsMISale: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090')'
      Caption = #1056#1077#1072#1083#1080#1079#1072#1094#1080#1103' '#1090#1086#1074#1072#1088#1072
      FormName = 'TReport_GoodsMIForm'
      FormNameParam.Value = 'TReport_GoodsMIForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <
        item
          Name = 'inDescId'
          Value = 5
        end
        item
          Name = 'InDescName'
          Value = #1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084' ('#1080#1090#1086#1075')'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actSendDebt: TdsdOpenForm
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      Caption = #1042#1079#1072#1080#1084#1086#1079#1072#1095#1077#1090' ('#1070#1088'. '#1083#1080#1094#1072')'
      FormName = 'TSendDebtJournalForm'
      FormNameParam.Value = 'TSendDebtJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPartner1CLink: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Caption = #1057#1074#1103#1079#1100' '#1090#1086#1095#1077#1082' '#1076#1086#1089#1090#1072#1074#1082#1080' '#1089' 1'#1057
      FormName = 'TPartner1CLinkForm'
      FormNameParam.Value = 'TPartner1CLinkForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsByGoodsKind1CLink: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Caption = #1057#1074#1103#1079#1100' '#1090#1086#1074#1072#1088#1086#1074' '#1089' 1'#1057
      FormName = 'TGoodsByGoodsKind1CLinkForm'
      FormNameParam.Value = 'TGoodsByGoodsKind1CLinkForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actLoad1CSale: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1088#1072#1089#1093#1086#1076#1085#1099#1093' '#1085#1072#1082#1083#1072#1076#1085#1099#1093
      FormName = 'TLoadSaleFrom1CForm'
      FormNameParam.Value = 'TLoadSaleFrom1CForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsMI_byMovementSale: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090')'
      Caption = #1056#1077#1072#1083#1080#1079#1072#1094#1080#1103' '#1090#1086#1074#1072#1088#1072' ('#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084')'
      FormName = 'TReport_GoodsMI_byMovementForm'
      FormNameParam.Value = 'TReport_GoodsMI_byMovementForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <
        item
          Name = 'inDescId'
          Value = 5
        end
        item
          Name = 'InDescName'
          Value = #1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084' ('#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084')'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actReport_GoodsMI_byMovementReturn: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090')'
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1090#1086#1074#1072#1088#1072' ('#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084')'
      FormName = 'TReport_GoodsMI_byMovementForm'
      FormNameParam.Value = 'TReport_GoodsMI_byMovementForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'inDescId'
          Value = 6
        end
        item
          Name = 'InDescName'
          Value = #1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1077#1081' ('#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084')'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actReport_Goods_Movement: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090')'
      Caption = #1055#1088#1086#1076#1072#1078#1072' / '#1042#1086#1079#1074#1088#1072#1090' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084
      FormName = 'TReport_Goods_MovementForm'
      FormNameParam.Value = 'TReport_Goods_MovementForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Production_Union: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')'
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1087#1088#1086#1076#1091#1082#1094#1080#1080
      FormName = 'TReport_Production_Union'
      FormNameParam.Value = 'TReport_Production_Union'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
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
    Version = '4.12'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 41670.882795428200000000
    ReportOptions.LastChange = 41670.882795428200000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
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
      LeftMargin = 8.000000000000000000
      RightMargin = 8.000000000000000000
      TopMargin = 7.000000000000000000
      BottomMargin = 7.000000000000000000
      OnBeforePrint = 'Page1OnBeforePrint'
      object ReportTitle1: TfrxReportTitle
        Height = 220.000000000000000000
        Top = 16.000000000000000000
        Width = 733.228820000000000000
        object Memo8: TfrxMemoView
          Left = 110.000000000000000000
          Top = 37.000000000000000000
          Width = 401.000000000000000000
          Height = 82.000000000000000000
          OnBeforePrint = 'Memo8OnBeforePrint'
          ShowHint = False
          StretchMode = smMaxHeight
          AutoWidth = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Memo11: TfrxMemoView
          Align = baCenter
          Left = 193.114410000000000000
          Top = 217.000000000000000000
          Width = 347.000000000000000000
          Height = 36.000000000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          AutoWidth = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo12: TfrxMemoView
          Left = 516.000000000000000000
          Top = 42.000000000000000000
          Width = 96.000000000000000000
          Height = 12.000000000000000000
          OnBeforePrint = 'Memo12OnBeforePrint'
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haCenter
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo16: TfrxMemoView
          Left = 3.000000000000000000
          Top = 37.000000000000000000
          Width = 103.000000000000000000
          Height = 15.000000000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          AutoWidth = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold, fsUnderline]
          Memo.UTF8W = (
            #207#238#241#242#224#247#224#235#252#237#232#234)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo1: TfrxMemoView
          Left = 110.000000000000000000
          Top = 120.000000000000000000
          Width = 341.000000000000000000
          Height = 41.000000000000000000
          OnBeforePrint = 'Memo1OnBeforePrint'
          ShowHint = False
          StretchMode = smMaxHeight
          AutoWidth = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Memo13: TfrxMemoView
          Left = 3.000000000000000000
          Top = 120.000000000000000000
          Width = 103.000000000000000000
          Height = 15.000000000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          AutoWidth = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold, fsUnderline]
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo30: TfrxMemoView
          Left = 109.000000000000000000
          Top = 163.000000000000000000
          Width = 341.000000000000000000
          Height = 15.000000000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          AutoWidth = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Memo38: TfrxMemoView
          Left = 2.000000000000000000
          Top = 163.000000000000000000
          Width = 103.000000000000000000
          Height = 15.000000000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          AutoWidth = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold, fsUnderline]
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo39: TfrxMemoView
          Left = 110.000000000000000000
          Top = 180.000000000000000000
          Width = 341.000000000000000000
          Height = 15.000000000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          AutoWidth = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Memo40: TfrxMemoView
          Left = 3.000000000000000000
          Top = 180.000000000000000000
          Width = 103.000000000000000000
          Height = 15.000000000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          AutoWidth = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold, fsUnderline]
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo41: TfrxMemoView
          Left = 110.000000000000000000
          Top = 197.000000000000000000
          Width = 341.000000000000000000
          Height = 15.000000000000000000
          OnBeforePrint = 'Memo41OnBeforePrint'
          ShowHint = False
          StretchMode = smMaxHeight
          AutoWidth = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Memo45: TfrxMemoView
          Left = 3.000000000000000000
          Top = 197.000000000000000000
          Width = 103.000000000000000000
          Height = 15.000000000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          AutoWidth = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold, fsUnderline]
          ParentFont = False
          VAlign = vaCenter
        end
      end
      object MasterData1: TfrxMasterData
        Height = 19.000000000000000000
        Top = 352.000000000000000000
        Width = 733.228820000000000000
        Columns = 1
        ColumnWidth = 200.000000000000000000
        ColumnGap = 20.000000000000000000
        RowCount = 0
        Stretched = True
        object Memo17: TfrxMemoView
          Left = 1.000000000000000000
          Top = 17.000000000000000000
          Width = 24.000000000000000000
          Height = 36.000000000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo19: TfrxMemoView
          Left = 122.000000000000000000
          Top = 17.000000000000000000
          Width = 291.000000000000000000
          Height = 36.000000000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo20: TfrxMemoView
          Left = 413.000000000000000000
          Top = 17.000000000000000000
          Width = 48.000000000000000000
          Height = 36.000000000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo22: TfrxMemoView
          Left = 518.000000000000000000
          Top = 17.000000000000000000
          Width = 103.000000000000000000
          Height = 36.000000000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo23: TfrxMemoView
          Left = 621.000000000000000000
          Top = 17.000000000000000000
          Width = 75.000000000000000000
          Height = 36.000000000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo15: TfrxMemoView
          Left = 461.000000000000000000
          Top = 17.000000000000000000
          Width = 57.000000000000000000
          Height = 36.000000000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo10: TfrxMemoView
          Left = 25.000000000000000000
          Top = 17.000000000000000000
          Width = 97.000000000000000000
          Height = 36.000000000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          ParentFont = False
          VAlign = vaCenter
        end
      end
      object ColumnHeader1: TfrxColumnHeader
        Height = 36.000000000000000000
        Top = 256.000000000000000000
        Width = 733.228820000000000000
      end
      object ReportSummary1: TfrxReportSummary
        Height = 210.000000000000000000
        Top = 431.000000000000000000
        Width = 733.228820000000000000
        object Memo28: TfrxMemoView
          Left = 3.000000000000000000
          Top = 76.000000000000000000
          Width = 94.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          AutoWidth = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo29: TfrxMemoView
          Left = 3.000000000000000000
          Top = 94.000000000000000000
          Width = 217.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          AutoWidth = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo31: TfrxMemoView
          Left = 3.000000000000000000
          Top = 112.000000000000000000
          Width = 363.000000000000000000
          Height = 17.000000000000000000
          OnBeforePrint = 'Memo31OnBeforePrint'
          ShowHint = False
          StretchMode = smMaxHeight
          AutoWidth = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo32: TfrxMemoView
          Align = baCenter
          Left = 48.614410000000000000
          Top = 177.000000000000000000
          Width = 636.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          AutoWidth = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo35: TfrxMemoView
          Left = 520.000000000000000000
          Top = 18.000000000000000000
          Width = 100.000000000000000000
          Height = 19.000000000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          AutoWidth = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          HAlign = haRight
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo36: TfrxMemoView
          Left = 520.000000000000000000
          Top = 37.000000000000000000
          Width = 100.000000000000000000
          Height = 19.000000000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          AutoWidth = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          HAlign = haRight
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo37: TfrxMemoView
          Left = 520.000000000000000000
          Top = 56.000000000000000000
          Width = 100.000000000000000000
          Height = 19.000000000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          AutoWidth = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          HAlign = haRight
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo42: TfrxMemoView
          Left = 621.000000000000000000
          Top = 18.000000000000000000
          Width = 74.000000000000000000
          Height = 19.000000000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo43: TfrxMemoView
          Left = 621.000000000000000000
          Top = 37.000000000000000000
          Width = 74.000000000000000000
          Height = 19.000000000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo44: TfrxMemoView
          Left = 621.000000000000000000
          Top = 56.000000000000000000
          Width = 74.000000000000000000
          Height = 19.000000000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo26: TfrxMemoView
          Left = 451.000000000000000000
          Top = 205.000000000000000000
          Width = 167.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          AutoWidth = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo3: TfrxMemoView
          Left = 18.000000000000000000
          Top = 138.000000000000000000
          Width = 363.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          AutoWidth = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo4: TfrxMemoView
          Left = 461.000000000000000000
          Top = 18.000000000000000000
          Width = 57.000000000000000000
          Height = 19.000000000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          ParentFont = False
          VAlign = vaCenter
        end
      end
      object Memo2: TfrxMemoView
        Left = 413.000000000000000000
        Top = 406.000000000000000000
        Width = 48.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        StretchMode = smMaxHeight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo5: TfrxMemoView
        Left = 461.000000000000000000
        Top = 406.000000000000000000
        Width = 57.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        StretchMode = smMaxHeight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haRight
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo6: TfrxMemoView
        Left = 518.000000000000000000
        Top = 406.000000000000000000
        Width = 103.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        StretchMode = smMaxHeight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haRight
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo7: TfrxMemoView
        Left = 122.000000000000000000
        Top = 406.000000000000000000
        Width = 291.000000000000000000
        Height = 19.000000000000000000
        OnBeforePrint = 'Memo7OnBeforePrint'
        ShowHint = False
        StretchMode = smMaxHeight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo24: TfrxMemoView
        Left = 1.000000000000000000
        Top = 406.000000000000000000
        Width = 24.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        StretchMode = smMaxHeight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haRight
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo25: TfrxMemoView
        Left = 621.000000000000000000
        Top = 406.000000000000000000
        Width = 75.000000000000000000
        Height = 19.000000000000000000
        ShowHint = False
        StretchMode = smMaxHeight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haRight
        ParentFont = False
        VAlign = vaCenter
      end
      object Memo9: TfrxMemoView
        Left = 25.000000000000000000
        Top = 406.000000000000000000
        Width = 97.000000000000000000
        Height = 19.000000000000000000
        OnBeforePrint = 'Memo9OnBeforePrint'
        ShowHint = False
        StretchMode = smMaxHeight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        HAlign = haCenter
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
