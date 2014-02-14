object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1081' '#1059#1095#1077#1090' '#171'Project'#187
  ClientHeight = 407
  ClientWidth = 1118
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
    Font.Height = -11
    Font.Name = 'Tahoma'
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
        end
        item
          Visible = True
          ItemName = 'bbGoodsDocuments_Separator'
        end
        item
          Visible = True
          ItemName = 'bbTax'
        end
        item
          Visible = True
          ItemName = 'bbTaxCorrective'
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
    object bbTax: TdxBarButton
      Action = actTax
      Category = 0
    end
    object bbTaxCorrective: TdxBarButton
      Action = actTaxCorrection
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
    object bbAsset: TdxBarSubItem
      Caption = #1054#1089#1085#1086#1074#1085#1099#1077' '#1089#1088#1077#1076#1089#1090#1074#1072' '
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbAsset_Separator'
        end
        item
          Visible = True
          ItemName = 'bbGuideAsset'
        end
        item
          Visible = True
          ItemName = 'bbAssetGroup'
        end
        item
          Visible = True
          ItemName = 'bbCountry'
        end
        item
          Visible = True
          ItemName = 'bbMaker'
        end>
    end
    object bbAssetGroup: TdxBarButton
      Action = actAssetGroup
      Category = 0
    end
    object bbAsset_Separator: TdxBarSeparator
      Caption = 'bbAsset_Separator'
      Category = 0
      Hint = 'bbAsset_Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbGuideAsset: TdxBarButton
      Action = actAsset
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082
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
      Caption = #1054#1090#1095#1077#1090#1099' ('#1087#1088'-'#1074#1086')'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbReportProductionUnion'
        end>
    end
    object bbReportsProduction_Separator: TdxBarSeparator
      Caption = 'bbReportsProduction_Separator'
      Category = 0
      Hint = 'bbReportsProduction_Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbReportProductionUnion: TdxBarButton
      Action = actReport_Production_Union
      Category = 0
    end
    object bbReportsGoods: TdxBarSubItem
      Caption = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
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
          ItemName = 'bbReport_GoodsMI_Income'
        end
        item
          Visible = True
          ItemName = 'bbReport_GoodsMI_IncomeByPartner'
        end
        item
          Visible = True
          ItemName = 'bbReport_GoodsMI_SaleReturnIn'
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
    object bbReport_GoodsMI_SaleReturnIn: TdxBarButton
      Action = actReport_GoodsMI_SaleReturnIn
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
    object bbReport_GoodsMI_Income: TdxBarButton
      Action = actReport_GoodsMI_Income
      Category = 0
    end
    object bbReport_GoodsMI_IncomeByPartner: TdxBarButton
      Action = actReport_GoodsMI_IncomeByPartner
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
      Caption = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbReport_JuridicalSold'
        end
        item
          Visible = True
          ItemName = 'bbReport_JuridicalDefermentPayment'
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
    object bbReport_JuridicalDefermentPayment: TdxBarButton
      Action = actReport_JuridicalDefermentPayment
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
      Caption = #1054#1090#1095#1077#1090#1099' ('#1059#1055')'
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
          ItemName = 'bbReport_CheckTax'
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
    object bbReportProfitLoss: TdxBarButton
      Action = actReport_ProfitLoss
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
          ItemName = 'bbGoods_List'
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
    object bbGoods_List: TdxBarButton
      Action = actGoods_List
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
    object bbCountry: TdxBarButton
      Action = actCountry
      Category = 0
    end
    object bbMaker: TdxBarButton
      Action = actMaker
      Category = 0
    end
    object bbReport_CheckTax: TdxBarButton
      Action = actReport_CheckTax
      Category = 0
    end
  end
  object ActionList: TActionList
    Left = 192
    Top = 48
    object actMaker: TdsdOpenForm
      Category = #1054#1089#1085#1086#1074#1085#1099#1077' '#1089#1088#1077#1076#1089#1090#1074#1072' '
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100' '#1054#1057
      Hint = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100' ('#1054#1057')'
      FormName = 'TMakerForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
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
      Category = #1054#1090#1095#1077#1090#1099' ('#1059#1055')'
      Caption = #1041#1072#1083#1072#1085#1089
      FormName = 'TReport_BalanceForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_ProfitLoss: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1059#1055')'
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
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
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
    object actGoods_List: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1058#1086#1074#1072#1088#1099' ('#1089#1087#1080#1089#1086#1082')'
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TGoodsForm'
      FormNameParam.Value = 'TGoodsForm'
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
      Category = #1054#1089#1085#1086#1074#1085#1099#1077' '#1089#1088#1077#1076#1089#1090#1074#1072' '
      Caption = #1054#1089#1085#1086#1074#1085#1099#1077' '#1089#1088#1077#1076#1089#1090#1074#1072' '
      Hint = #1054#1089#1085#1086#1074#1085#1099#1077' '#1089#1088#1077#1076#1089#1090#1074#1072' '
      FormName = 'TAssetForm'
      FormNameParam.Value = 'TAssetForm'
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
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
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
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      Caption = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1102#1088'.'#1083#1080#1094#1072#1084
      FormName = 'TReport_JuridicalSoldForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_JuridicalCollation: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
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
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
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
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
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
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
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
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
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
    object actReport_GoodsMI_SaleReturnIn: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      Caption = #1055#1088#1086#1076#1072#1078#1072' / '#1042#1086#1079#1074#1088#1072#1090' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084
      FormName = 'TReport_GoodsMI_SaleReturnInForm'
      FormNameParam.Value = 'TReport_GoodsMI_SaleReturnInForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Production_Union: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1087#1088'-'#1074#1086')'
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1087#1088#1086#1076#1091#1082#1094#1080#1080
      FormName = 'TReport_Production_Union'
      FormNameParam.Value = 'TReport_Production_Union'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsMI_Income: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      Caption = #1055#1088#1080#1093#1086#1076' '#1090#1086#1074#1072#1088#1072' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1080#1090#1086#1075#1080')'
      FormName = 'TReport_GoodsMI_IncomeForm'
      FormNameParam.Value = 'TReport_GoodsMI_IncomeForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <
        item
          Name = 'inDescId'
          Value = 1
        end
        item
          Name = 'InDescName'
          Value = #1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074' ('#1080#1090#1086#1075')'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actReport_GoodsMI_IncomeByPartner: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      Caption = #1055#1088#1080#1093#1086#1076' '#1090#1086#1074#1072#1088#1072' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
      FormName = 'TReport_GoodsMI_IncomeByPartnerForm'
      FormNameParam.Value = 'TReport_GoodsMI_IncomeByPartnerForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <
        item
          Name = 'inDescId'
          Value = 1
        end
        item
          Name = 'InDescName'
          Value = #1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
          DataType = ftString
        end>
      isShowModal = False
    end
    object actReport_JuridicalDefermentPayment: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1090#1089#1088#1086#1095#1082#1077
      FormName = 'TReport_JuridicalDefermentPayment'
      FormNameParam.Value = 'TReport_JuridicalDefermentPayment'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actTax: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      FormName = 'TTaxJournalForm'
      FormNameParam.Name = 'TTaxJournalForm'
      FormNameParam.Value = 'TTaxJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actTaxCorrection: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081
      FormName = 'TTaxCorrectiveJournalForm'
      FormNameParam.Name = 'TTaxCorrectiveJournalForm'
      FormNameParam.Value = 'TTaxCorrectiveJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actAssetGroup: TdsdOpenForm
      Category = #1054#1089#1085#1086#1074#1085#1099#1077' '#1089#1088#1077#1076#1089#1090#1074#1072' '
      Caption = #1043#1088#1091#1087#1087#1099' '#1054#1057
      Hint = #1043#1088#1091#1087#1087#1099' '#1086#1089#1085#1086#1074#1085#1099#1093' '#1089#1088#1077#1076#1089#1090#1074' '
      FormName = 'TAssetGroupForm'
      FormNameParam.Value = 'TAssetGroupForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actCountry: TdsdOpenForm
      Category = #1054#1089#1085#1086#1074#1085#1099#1077' '#1089#1088#1077#1076#1089#1090#1074#1072' '
      Caption = #1057#1090#1088#1072#1085#1099
      Hint = #1057#1090#1088#1072#1085#1099
      FormName = 'TCountryForm'
      FormNameParam.Value = 'TCountryForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_CheckTax: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1059#1055')'
      Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1053#1072#1083#1086#1075#1086#1074#1099#1093' '#1085#1072#1082#1083#1072#1076#1085#1099#1093
      FormName = 'TReport_CheckTaxForm'
      FormNameParam.Value = 'TReport_CheckTaxForm'
      FormNameParam.DataType = ftString
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
    ReportOptions.CreateDate = 37867.733215115710000000
    ReportOptions.Name = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' - '#1059#1082#1088#1057#1082#1083#1072#1076
    ReportOptions.LastChange = 41452.570119166700000000
    ScriptLanguage = 'C++Script'
    ScriptText.Strings = (
      'String PodDog1;'
      'String PodDog2;'
      'Date PodDogDate2;'
      'int PodDogCount2;      '
      'String PodDog3;'
      ''
      'String ParseDate(String aDateStr)'
      '{'
      '  int DatePos1 = Pos("'#1075'", Lowercase(aDateStr));'
      '  if(DatePos1 == 0)'
      '  {      '
      '    DatePos1 = Pos("'#1088'", Lowercase(aDateStr));'
      '  }'
      '  if(DatePos1 > 0)'
      '  {'
      
        '    Delete(aDateStr,DatePos1,255);                              ' +
        '           '
      '  }'
      '  return aDateStr;'
      '}    '
      ''
      'void CalcPodDog()'
      '{'
      '  PodDog1 = "";'
      '  PodDog2 = "";'
      '  PodDog3 = "";                    '
      '  String PodDogTmp;'
      '  int PodDogPos3;        '
      '  PodDogTmp = <'#1053#1053#1072#1082#1083'.'#1059#1089#1083#1086#1074#1055#1088#1086#1076#1072#1078'>;'
      '  '
      '  int PodDogPos1 = Pos(" '#1074#1110#1076'", Lowercase(PodDogTmp));'
      '  PodDogCount2 = 3;                  '
      '  if(PodDogPos1 == 0)'
      '  {      '
      '    PodDogPos1 = Pos(" '#1086#1090'", Lowercase(PodDogTmp));'
      '    PodDogCount2 = 2;                       '
      '  }            '
      '  if(PodDogPos1 == 0)'
      '  {'
      '    PodDog1 = PodDogTmp;'
      '    break;'
      '  }'
      '  int PodDogPos2 = Pos("'#8470'", Lowercase(PodDogTmp));'
      '  if(PodDogPos2 == 0)'
      '  {'
      '    PodDog1 = PodDogTmp;'
      '    break;'
      '  }'
      '  if(PodDogPos2 > PodDogPos1)'
      '  {      '
      '    PodDog1 = PodDogTmp;'
      '    Delete(PodDog1,PodDogPos1,255);'
      '    PodDog1 = Trim(PodDog1);'
      '    '
      '    PodDog2 = PodDogTmp;'
      '    Delete(PodDog2, 1, PodDogPos1+PodDogCount2);'
      '    PodDog2 = Trim(PodDog2);'
      '    PodDog3 = PodDog2;'
      '    PodDogPos3 = Pos("'#8470'", Lowercase(PodDog3));'
      '    if(PodDogPos3 == 0)'
      '    {'
      '      PodDog1 = PodDogTmp;'
      '      PodDog2 = "";'
      '      PodDog3 = "";        '
      '      break;'
      '    }'
      '    Delete(PodDog2,PodDogPos3,255);'
      '    PodDog2 = Trim(PodDog2);'
      '    PodDog2 = ParseDate(PodDog2);              '
      '    PodDogDate2 = StrToDate(PodDog2);'
      '       '
      '    Delete(PodDog3, 1, PodDogPos3);'
      '    PodDog3 = Trim(PodDog3);'
      '  }'
      '  else'
      '  {'
      '    PodDog1 = PodDogTmp;'
      '    Delete(PodDog1,PodDogPos2,255);'
      '    PodDog1 = Trim(PodDog1);'
      '  '
      '    PodDog3 = PodDogTmp;'
      '    Delete(PodDog3, 1, PodDogPos2);'
      '    PodDog3 = Trim(PodDog3);'
      '    PodDog2 = PodDog3;'
      '  '
      '    PodDogPos3 = Pos(" '#1074#1110#1076'", Lowercase(PodDog2));'
      '    PodDogCount2 = 3;                    '
      '    if(PodDogPos3 == 0)'
      '    {        '
      '      PodDogPos3 = Pos(" '#1086#1090'", Lowercase(PodDog2));'
      '      PodDogCount2 = 2;                      '
      '    }                '
      '    if(PodDogPos3 == 0)'
      '    {'
      '      PodDog1 = PodDogTmp;'
      '      PodDog2 = "";'
      '      PodDog3 = "";        '
      '      break;'
      '    }'
      '    Delete(PodDog3,PodDogPos3,255);'
      '    PodDog3 = Trim(PodDog3);'
      '                                    '
      '    Delete(PodDog2, 1, PodDogPos3+PodDogCount2);'
      '    PodDog2 = Trim(PodDog2);'
      '    PodDog2 = ParseDate(PodDog2);        '
      '    PodDogDate2 = StrToDate(PodDog2);'
      '  }      '
      '}'
      ''
      'void OnFillEmpty(TfrxComponent Sender)'
      '{'
      
        '  if((Trim(TfrxMemoView(Sender).Text) == "") || (Trim(TfrxMemoVi' +
        'ew(Sender).Text) == "0.00") || (Trim(TfrxMemoView(Sender).Text) ' +
        '== "0"))'
      '  {'
      '    TfrxMemoView(Sender).HAlign = haCenter;'
      '    TfrxMemoView(Sender).Text = "";'
      '  }'
      '  else'
      '  {'
      '    TfrxMemoView(Sender).HAlign = haRight;'
      '  }'
      '}'
      ''
      'void OnFillEmptyNull(TfrxComponent Sender)'
      '{'
      
        '  if((Trim(TfrxMemoView(Sender).Text) == "") || (Trim(TfrxMemoVi' +
        'ew(Sender).Text) == "0.00") || (Trim(TfrxMemoView(Sender).Text) ' +
        '== "0") || (Trim(TfrxMemoView(Sender).Text) == "0,00"))'
      '    TfrxMemoView(Sender).Text = "";'
      '}'
      ''
      'double RealZn;'
      '                       '
      ''
      'void Band3OnBeforePrint(TfrxComponent Sender)'
      '{'
      
        '  ElMemo13.TagStr = IntToStr(<Page>) + "|" + IntToStr(Band3.Data' +
        'Set.RecNo+1);  '
      
        '  Memo164.TagStr = IntToStr(<Page>) + "|" + IntToStr(Band3.DataS' +
        'et.RecNo+1);'
      
        '  Memo165.TagStr = IntToStr(<Page>) + "|" + IntToStr(Band3.DataS' +
        'et.RecNo+1);'
      
        '  Memo115.TagStr = IntToStr(<Page>) + "|" + IntToStr(Band3.DataS' +
        'et.RecNo+1);'
      
        '  Memo166.TagStr = IntToStr(<Page>) + "|" + IntToStr(Band3.DataS' +
        'et.RecNo+1);'
      
        '  Memo167.TagStr = IntToStr(<Page>) + "|" + IntToStr(Band3.DataS' +
        'et.RecNo+1);'
      
        '  ElMemo14.TagStr = IntToStr(<Page>) + "|" + IntToStr(Band3.Data' +
        'Set.RecNo+1);'
      
        '  ElMemo15.TagStr = IntToStr(<Page>) + "|" + IntToStr(Band3.Data' +
        'Set.RecNo+1);      '
      
        '  Memo168.TagStr = IntToStr(<Page>) + "|" + IntToStr(Band3.DataS' +
        'et.RecNo+1);'
      
        '  Memo169.TagStr = IntToStr(<Page>) + "|" + IntToStr(Band3.DataS' +
        'et.RecNo+1);'
      
        '  Memo170.TagStr = IntToStr(<Page>) + "|" + IntToStr(Band3.DataS' +
        'et.RecNo+1);'
      
        '  Memo171.TagStr = IntToStr(<Page>) + "|" + IntToStr(Band3.DataS' +
        'et.RecNo+1);'
      
        '  Memo172.TagStr = IntToStr(<Page>) + "|" + IntToStr(Band3.DataS' +
        'et.RecNo+1);      '
      '}'
      ''
      '{'
      '  CalcPodDog();'
      '  /*'
      '  if(<'#1057#1082#1080#1076#1082#1072'.'#1062#1080#1092#1088#1072#1084#1080'> != 0)'
      '  {'
      '    if(<'#1057#1082#1080#1076#1082#1072'.'#1058#1080#1087'> == 1)'
      '      RealZn = <'#1057#1082#1080#1076#1082#1072'.'#1062#1080#1092#1088#1072#1084#1080'>;'
      '    else'
      '      RealZn = <'#1057#1082#1080#1076#1082#1072'.'#1062#1080#1092#1088#1072#1084#1080'>*(-1);'
      '  }'
      '  */        '
      '}')
    Left = 360
    Top = 88
    Datasets = <
      item
        DataSetName = 'DataRep'
      end>
    Variables = <
      item
        Name = ' '#1052#1086#1080#1055#1077#1088#1077#1084#1077#1085#1085#1099#1077
        Value = Null
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.EMail+'
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.EMail'
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.WWW'
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.'#1040#1076#1088#1077#1089
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.'#1041#1072#1085#1082'+'
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.'#1041#1072#1085#1082
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.'#1041#1091#1093#1075#1072#1083#1090#1077#1088
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.'#1042#1089#1077#1056#1077#1082#1074#1080#1079#1080#1090#1099
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.'#1044#1080#1088#1077#1082#1090#1086#1088
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.'#1044#1086#1075#1086#1074#1086#1088
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086'1'
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086'2'
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086'3'
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086'4'
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.'#1047#1050#1055#1054'+'
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.'#1047#1050#1055#1054
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.'#1048#1055#1053'+'
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.'#1048#1055#1053
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.'#1052#1060#1054'+'
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.'#1052#1060#1054
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.'#1057#1074#1080#1076'+'
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.'#1057#1074#1080#1076
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.'#1057#1082#1083#1072#1076
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.'#1057#1082#1083#1072#1076#1055#1086#1083#1091#1095#1072#1090#1077#1083#1100
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.'#1057#1095#1077#1090'+'
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.'#1057#1095#1077#1090
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.'#1057#1095#1077#1090#1044#1083#1103#1053#1044#1057'+'
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.'#1057#1095#1077#1090#1044#1083#1103#1053#1044#1057
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.'#1058#1077#1083
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.'#1060#1048#1054
        Value = '0'
      end
      item
        Name = #1040#1082#1090#1060#1080#1088#1084#1072'.'#1070#1088#1040#1076#1088#1077#1089
        Value = '0'
      end
      item
        Name = #1042#1072#1083#1102#1090#1072'.'#1057#1086#1082#1088
        Value = '0'
      end
      item
        Name = #1044#1086#1082#1091#1084'.'#1044#1072#1090#1072'.'#1057#1083#1086#1074#1072#1084#1080
        Value = '0'
      end
      item
        Name = #1044#1086#1082#1091#1084'.'#1044#1072#1090#1072'.'#1062#1080#1092#1088#1072#1084#1080
        Value = '0'
      end
      item
        Name = #1044#1086#1082#1091#1084'.'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086
        Value = '0'
      end
      item
        Name = #1044#1086#1082#1091#1084'.'#1050#1091#1088#1089
        Value = '0'
      end
      item
        Name = #1044#1086#1082#1091#1084'.'#1052#1077#1090#1082#1072
        Value = '0'
      end
      item
        Name = #1044#1086#1082#1091#1084'.'#1053#1086#1084#1077#1088
        Value = '0'
      end
      item
        Name = #1044#1086#1082#1091#1084'.'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        Value = '0'
      end
      item
        Name = #1044#1086#1082#1091#1084'.'#1059#1089#1083#1086#1074#1055#1088#1086#1076#1072#1078
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.EMail+'
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.EMail'
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.WWW'
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1040#1076#1088#1077#1089
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1041#1072#1083#1072#1085#1089
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1041#1072#1085#1082'+'
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1041#1072#1085#1082
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1041#1091#1093#1075#1072#1083#1090#1077#1088
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1042#1089#1077#1056#1077#1082#1074#1080#1079#1080#1090#1099
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1044#1080#1088#1077#1082#1090#1086#1088
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1044#1080#1089#1082#1086#1085#1090#1050#1072#1088#1090#1072
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1044#1086#1075#1086#1074#1086#1088
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1044#1086#1082#1091#1084#1077#1085#1090'.'#1042#1099#1076#1072#1085
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1044#1086#1082#1091#1084#1077#1085#1090'.'#1044#1072#1090#1072
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1044#1086#1082#1091#1084#1077#1085#1090'.'#1053#1086#1084#1077#1088
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1044#1086#1082#1091#1084#1077#1085#1090'.'#1057#1077#1088#1080#1103
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1044#1086#1082#1091#1084#1077#1085#1090'.'#1058#1080#1087
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086'1'
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086'2'
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086'3'
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086'4'
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1047#1050#1055#1054'+'
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1047#1050#1055#1054
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1048#1055#1053'+'
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1048#1055#1053
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1052#1060#1054'+'
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1052#1060#1054
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1053#1072#1082#1086#1087#1057#1091#1084#1084#1072
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1057#1074#1080#1076'+'
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1057#1074#1080#1076
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1057#1095#1077#1090'+'
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1057#1095#1077#1090
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1057#1095#1077#1090#1044#1083#1103#1053#1044#1057'+'
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1057#1095#1077#1090#1044#1083#1103#1053#1044#1057
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1058#1077#1083
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1060#1048#1054
        Value = '0'
      end
      item
        Name = #1050#1083#1080#1077#1085#1090'.'#1070#1088#1040#1076#1088#1077#1089
        Value = '0'
      end
      item
        Name = #1053#1072#1082#1083'.'#1059#1089#1083#1086#1074#1080#1077
        Value = '0'
      end
      item
        Name = #1053#1072#1083#1086#1075'.'#1056#1077#1082#1083#1072#1084#1072
        Value = '0'
      end
      item
        Name = #1053#1044#1057'.'#1057#1083#1086#1074#1072#1084#1080
        Value = '0'
      end
      item
        Name = #1053#1044#1057'.'#1058#1080#1087
        Value = '0'
      end
      item
        Name = #1053#1044#1057'.'#1062#1080#1092#1088#1072#1084#1080
        Value = '0'
      end
      item
        Name = #1053#1053#1072#1082#1083'.'#1044#1072#1090#1072
        Value = '0'
      end
      item
        Name = #1053#1053#1072#1082#1083'.'#1044#1072#1090#1072#1054#1090#1075#1088#1091#1079#1082#1080
        Value = '0'
      end
      item
        Name = #1053#1053#1072#1082#1083'.'#1053#1086#1084#1077#1088
        Value = '0'
      end
      item
        Name = #1053#1053#1072#1082#1083'.'#1059#1089#1083#1086#1074#1055#1088#1086#1076#1072#1078
        Value = '0'
      end
      item
        Name = #1053#1053#1072#1082#1083'.'#1060#1086#1088#1084#1072#1057#1095
        Value = '0'
      end
      item
        Name = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100'.'#1044#1086#1083#1078#1085#1086#1089#1090#1100
        Value = '0'
      end
      item
        Name = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100'.'#1060#1048#1054
        Value = '0'
      end
      item
        Name = #1057#1082#1080#1076#1082#1072'.'#1042#1080#1076
        Value = '0'
      end
      item
        Name = #1057#1082#1080#1076#1082#1072'.'#1055#1088#1086#1094#1077#1085#1090
        Value = '0'
      end
      item
        Name = #1057#1082#1080#1076#1082#1072'.'#1058#1080#1087
        Value = '0'
      end
      item
        Name = #1057#1082#1080#1076#1082#1072'.'#1062#1080#1092#1088#1072#1084#1080
        Value = '0'
      end
      item
        Name = #1057#1091#1084#1084#1072'.'#1041#1077#1079#1053#1044#1057'.'#1041#1077#1079#1057#1082#1080#1076#1082#1080
        Value = '0'
      end
      item
        Name = #1057#1091#1084#1084#1072'.'#1041#1077#1079#1053#1044#1057'.'#1053#1053#1056#1072#1079#1076#1077#1083'1'
        Value = '0'
      end
      item
        Name = #1057#1091#1084#1084#1072'.'#1041#1077#1079#1053#1044#1057'.'#1057#1083#1086#1074#1072#1084#1080
        Value = '0'
      end
      item
        Name = #1057#1091#1084#1084#1072'.'#1041#1077#1079#1053#1044#1057
        Value = '0'
      end
      item
        Name = #1057#1091#1084#1084#1072'.'#1055#1086'1'#1056#1072#1079#1076#1077#1083#1091
        Value = '0'
      end
      item
        Name = #1057#1091#1084#1084#1072'.'#1057#1053#1044#1057'.'#1057#1083#1086#1074#1072#1084#1080
        Value = '0'
      end
      item
        Name = #1057#1091#1084#1084#1072'.'#1057#1053#1044#1057
        Value = '0'
      end
      item
        Name = #1057#1091#1084#1084#1072'.'#1057#1053#1044#1057'-'#1044#1088#1091#1075#1080#1077#1053#1072#1083#1086#1075#1080'.'#1057#1083#1086#1074#1072#1084#1080
        Value = '0'
      end
      item
        Name = #1057#1091#1084#1084#1072'.'#1057#1053#1044#1057'-'#1044#1088#1091#1075#1080#1077#1053#1072#1083#1086#1075#1080
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1042#1077#1089
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1043#1072#1088#1072#1085#1090#1080#1103
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1043#1088#1091#1087#1087#1072
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1044#1083#1080#1085#1072
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086'1'
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086'2'
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086'3'
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086'4'
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086'5'
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1045#1076#1048#1079#1084
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1045#1089#1083#1080#1059#1089#1083#1091#1075#1072
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1050#1086#1076
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1050#1086#1083#1074#1086'.'#1042#1059#1087#1072#1082#1086#1074#1082#1077
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1050#1086#1083#1074#1086
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1050#1086#1083#1074#1086#1042#1089#1077#1075#1086'.'#1057#1083#1086#1074#1072#1084#1080
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1050#1086#1083#1074#1086#1042#1089#1077#1075#1086
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1050#1086#1083#1074#1086#1053#1072#1057#1082#1083#1072#1076#1077
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1053#1072#1079#1074
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1055#1086#1076#1088#1086#1073#1085#1086#1077#1054#1087#1080#1089#1072#1085#1080#1077
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1057#1082#1080#1076#1082#1072#1053#1072#1076#1073#1072#1074#1082#1072'.'#1062#1077#1085#1072
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1057#1082#1083#1072#1076
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1057#1082#1083#1072#1076#1055#1086#1083#1091#1095#1072#1090#1077#1083#1100
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1057#1091#1084#1072'.'#1041#1077#1079#1053#1044#1057
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1057#1091#1084#1084#1072'.'#1057#1082#1080#1076#1082#1072#1053#1072#1076#1073#1072#1074#1082#1072'.'#1041#1077#1079#1053#1044#1057
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1057#1091#1084#1084#1072'.'#1057#1053#1044#1057
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1058#1080#1087#1053#1044#1057
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1058#1086#1083#1097#1080#1085#1072
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1060#1072#1089#1086#1074#1082#1072
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1060#1086#1090#1086
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1062#1077#1085#1072'.'#1042#1072#1083#1102#1090#1072'.'#1055#1088#1080#1093#1086#1076#1085#1072#1103
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1062#1077#1085#1072'.'#1042#1072#1083#1102#1090#1072'.'#1056#1072#1089#1093#1086#1076#1085#1072#1103
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1062#1077#1085#1072'.'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086'1'
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1062#1077#1085#1072'.'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086'2'
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1062#1077#1085#1072'.'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086'3'
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1062#1077#1085#1072'.'#1054#1087#1090#1086#1074#1072#1103
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1062#1077#1085#1072'.'#1055#1088#1080#1093#1086#1076#1085#1072#1103
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1062#1077#1085#1072'.'#1056#1086#1079#1085#1080#1095#1085#1072#1103
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1062#1077#1085#1072
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1062#1077#1085#1072#1057#1053#1044#1057
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1064#1080#1088#1080#1085#1072
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1064#1090#1088#1080#1093#1050#1086#1076'.'#1042#1085#1091#1090#1088#1077#1085#1085#1080#1081
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088'.'#1064#1090#1088#1080#1093#1050#1086#1076'.'#1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1103
        Value = '0'
      end
      item
        Name = #1058#1086#1074#1072#1088#1085#1086'-'#1090#1088#1072#1085#1089#1087#1086#1088#1090#1085#1099#1077
        Value = '0'
      end
      item
        Name = #1092#1086#1088#1084#1072#1090'_c'#1091#1084#1084#1072'_'#1083'_'#1090#1072#1073#1083
        Value = '0'
      end
      item
        Name = #1092#1086#1088#1084#1072#1090'_'#1089#1091#1084#1084#1072'_'#1090#1072#1073#1083
        Value = '0'
      end
      item
        Name = #1092#1086#1088#1084#1072#1090'_'#1094#1077#1085#1072'_'#1090#1072#1073#1083
        Value = '0'
      end>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
      LeftMargin = 15.000000000000000000
      RightMargin = 6.000000000000000000
      TopMargin = 6.000000000000000000
      BottomMargin = 6.000000000000000000
      Columns = 1
      ColumnWidth = 189.000000000000000000
      ColumnPositions.Strings = (
        '0')
      object Band2: TfrxFooter
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Height = 300.000000000000000000
        ParentFont = False
        Top = 573.000000000000000000
        Width = 714.331170000000000000
        AllowSplit = True
        object Memo73: TfrxMemoView
          Left = 22.677180000000000000
          Width = 226.771800000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1059#1089#1100#1086#1075#1086' '#1087#1086' '#1088#1086#1079#1076#1110#1083#1091' '#1030)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo74: TfrxMemoView
          Left = 306.141930000000000000
          Width = 34.015770000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo75: TfrxMemoView
          Left = 340.157700000000000000
          Width = 45.354330710000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo76: TfrxMemoView
          Left = 385.512060000000000000
          Width = 56.692913390000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo77: TfrxMemoView
          Left = 442.205010000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          OnAfterData = 'OnFillEmptyNull'
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          HideZeros = True
          Memo.UTF8W = (
            
              '[FormatFloat(<'#1092#1086#1088#1084#1072#1090'_'#1089#1091#1084#1084#1072'_'#1090#1072#1073#1083'>,SUM(StrToFloat(Memo169.Value)))' +
              ']')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo78: TfrxMemoView
          Left = 495.118430000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          OnAfterData = 'OnFillEmptyNull'
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          HideZeros = True
          Memo.UTF8W = (
            
              '[FormatFloat(<'#1092#1086#1088#1084#1072#1090'_'#1089#1091#1084#1084#1072'_'#1090#1072#1073#1083'>,SUM(StrToFloat(Memo170.Value)))' +
              ']')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo79: TfrxMemoView
          Left = 548.031850000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          OnAfterData = 'OnFillEmptyNull'
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          HideZeros = True
          Memo.UTF8W = (
            
              '[FormatFloat(<'#1092#1086#1088#1084#1072#1090'_'#1089#1091#1084#1084#1072'_'#1090#1072#1073#1083'>,SUM(StrToFloat(Memo171.Value)))' +
              ']')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo80: TfrxMemoView
          Left = 600.945270000000000000
          Width = 52.913420000000000000
          Height = 11.338590000000000000
          OnAfterData = 'OnFillEmptyNull'
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          HideZeros = True
          Memo.UTF8W = (
            
              '[FormatFloat(<'#1092#1086#1088#1084#1072#1090'_'#1089#1091#1084#1084#1072'_'#1090#1072#1073#1083'>,SUM(StrToFloat(Memo172.Value)))' +
              ']')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo81: TfrxMemoView
          Left = 653.858690000000000000
          Width = 60.472480000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight]
          HAlign = haRight
          Memo.UTF8W = (
            
              '[FormatFloat(<'#1092#1086#1088#1084#1072#1090'_'#1089#1091#1084#1084#1072'_'#1090#1072#1073#1083'>,StrToFloat(Memo77.Value)+StrToF' +
              'loat(Memo78.Value)+StrToFloat(Memo79.Value)+StrToFloat(Memo80.Va' +
              'lue))]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo83: TfrxMemoView
          Width = 22.677180000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftBottom]
          HAlign = haCenter
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo94: TfrxMemoView
          Left = 22.677180000000000000
          Top = 11.338590000000000000
          Width = 226.771653543307000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1047#1074#1086#1088#1086#1090#1085#1072' ('#1079#1072#1089#1090#1072#1074#1085#1072') '#1090#1072#1088#1072)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo95: TfrxMemoView
          Left = 306.141930000000000000
          Top = 11.338590000000000000
          Width = 34.015770000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo96: TfrxMemoView
          Left = 340.157700000000000000
          Top = 11.338590000000000000
          Width = 45.354330710000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo97: TfrxMemoView
          Left = 385.512060000000000000
          Top = 11.338590000000000000
          Width = 56.692913390000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo98: TfrxMemoView
          Left = 442.205010000000000000
          Top = 11.338590000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo99: TfrxMemoView
          Left = 495.118430000000000000
          Top = 11.338590000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo100: TfrxMemoView
          Left = 548.031850000000000000
          Top = 11.338590000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo101: TfrxMemoView
          Left = 600.945270000000000000
          Top = 11.338590000000000000
          Width = 52.913420000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo102: TfrxMemoView
          Left = 653.858690000000000000
          Top = 11.338590000000000000
          Width = 60.472480000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo103: TfrxMemoView
          Top = 11.338590000000000000
          Width = 22.677180000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1030#1030)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo143: TfrxMemoView
          Top = 22.677180000000000000
          Width = 22.677180000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1030#1030#1030)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo153: TfrxMemoView
          Top = 34.015770000000000000
          Width = 22.677180000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            'IV')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo154: TfrxMemoView
          Top = 52.913420000000000000
          Width = 714.331170000000000000
          Height = 26.456710000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            
              #1057#1091#1084#1080' '#1055#1044#1042', '#1085#1072#1088#1072#1093#1086#1074#1072#1085#1110' ('#1089#1087#1083#1072#1095#1077#1085#1110') '#1074' '#1079#1074#39#1103#1079#1082#1091' '#1079' '#1087#1086#1089#1090#1072#1095#1072#1085#1085#1103#1084' '#1090#1086#1074#1072#1088#1110#1074'/' +
              #1087#1086#1089#1083#1091#1075', '#1079#1072#1079#1085#1072#1095#1077#1085#1080#1093' '#1091' '#1094#1110#1081' '#1085#1072#1082#1083#1072#1076#1085#1110#1081', '#1074#1080#1079#1085#1072#1095#1077#1085#1110' '#1087#1088#1072#1074#1080#1083#1100#1085#1086', '#1074#1110#1076#1087#1086#1074#1110 +
              #1076#1072#1102#1090#1100' '#1089#1091#1084#1110' '#1087#1086#1076#1072#1090#1082#1086#1074#1080#1093' '#1079#1086#1073#1086#1074#39#1103#1079#1072#1085#1100' '#1087#1088#1086#1076#1072#1074#1094#1103' '#1110' '#1074#1082#1083#1102#1095#1077#1085#1110' '#1076#1086' '#1088#1077#1108#1089#1090#1088#1091 +
              ' '#1074#1080#1076#1072#1085#1080#1093' '#1090#1072' '#1086#1090#1088#1080#1084#1072#1085#1080#1093' '#1087#1086#1076#1072#1090#1082#1086#1074#1080#1093' '#1085#1072#1082#1083#1072#1076#1085#1080#1093'.')
          ParentFont = False
        end
        object Memo155: TfrxMemoView
          Left = 449.764070000000000000
          Top = 120.944960000000000000
          Width = 264.567100000000000000
          Height = 15.118120000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '['#1040#1082#1090#1060#1080#1088#1084#1072'.'#1041#1091#1093#1075#1072#1083#1090#1077#1088']')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo156: TfrxMemoView
          Left = 449.764070000000000000
          Top = 136.063080000000000000
          Width = 264.567100000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftTop]
          HAlign = haCenter
          Memo.UTF8W = (
            '('#1087#1110#1076#1087#1080#1089' '#1110' '#1087#1088#1110#1079#1074#1080#1097#1077' '#1086#1089#1086#1073#1080', '#1103#1082#1072' '#1089#1082#1083#1072#1083#1072' '#1087#1086#1076#1072#1090#1082#1086#1074#1091' '#1085#1072#1082#1083#1072#1076#1085#1091')')
          ParentFont = False
          WordWrap = False
        end
        object Memo157: TfrxMemoView
          Left = 49.133890000000000000
          Top = 105.826840000000000000
          Width = 60.472480000000000000
          Height = 49.133890000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1052'.'#1055'.')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo158: TfrxMemoView
          Top = 181.417440000000000000
          Width = 714.331170000000000000
          Height = 45.354360000000000000
          ShowHint = False
          AllowHTMLTags = True
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Arial'
          Font.Style = [fsItalic]
          Memo.UTF8W = (
            
              '<sup>1</sup> '#1047#1072#1079#1085#1072#1095#1072#1108#1090#1100#1089#1103' '#1082#1086#1076' '#1074#1080#1076#1091' '#1076#1110#1103#1083#1100#1085#1086#1089#1090#1110', '#1097#1086' '#1087#1077#1088#1077#1076#1073#1072#1095#1072#1108' '#1089#1087#1077 +
              #1094#1110#1072#1083#1100#1085#1080#1081' '#1088#1077#1078#1080#1084' '#1086#1087#1086#1076#1072#1090#1082#1091#1074#1072#1085#1085#1103' (2, '#1072#1073#1086' 3, '#1072#1073#1086' 4), '#1091' '#1088#1072#1079#1110' '#1089#1082#1083#1072#1076#1072#1085#1085#1103 +
              ' '#1087#1086#1076#1072#1090#1082#1086#1074#1086#1111' '#1085#1072#1082#1083#1072#1076#1085#1086#1111' '#1079#1072' '#1090#1072#1082#1086#1102' '#1076#1110#1103#1083#1100#1085#1110#1089#1090#1102'.'
            
              '<sup>2</sup> '#1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1080' '#1089#1090#1072#1074#1080#1090#1100#1089#1103' '#1091' '#1088#1072#1079#1110' '#1087#1086#1087#1077#1088#1077#1076#1085#1100#1086#1111' '#1086#1087#1083#1072#1090#1080' '#1087#1086#1089 +
              #1090#1072#1095#1072#1085#1085#1103', '#1085#1072' '#1103#1082#1091' '#1074#1080#1087#1080#1089#1091#1108#1090#1100#1089#1103' '#1087#1086#1076#1072#1090#1082#1086#1074#1072' '#1085#1072#1082#1083#1072#1076#1085#1072', '#1076#1083#1103' '#1086#1087#1077#1088#1072#1094#1110#1081' '#1079' '#1087 +
              #1086#1089#1090#1072#1095#1072#1085#1085#1103' '#1090#1086#1074#1072#1088#1110#1074'/'#1087#1086#1089#1083#1091#1075'  '#1074#1110#1076#1087#1086#1074#1110#1076#1085#1086' '#1076#1086' '#1087#1091#1085#1082#1090#1091' 187.10 '#1089#1090#1072#1090#1090#1110' 187' +
              ' '#1088#1086#1079#1076#1110#1083#1091' V '#1055#1086#1076#1072#1090#1082#1086#1074#1086#1075#1086' '#1082#1086#1076#1077#1082#1089#1091' '#1059#1082#1088#1072#1111#1085#1080'.'
            '<sup>3</sup>')
          ParentFont = False
        end
        object Memo134: TfrxMemoView
          Left = 22.677180000000000000
          Top = 22.677180000000000000
          Width = 226.771653543307000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1055#1086#1076#1072#1090#1086#1082' '#1085#1072' '#1076#1086#1076#1072#1085#1091' '#1074#1072#1088#1090#1110#1089#1090#1100)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo135: TfrxMemoView
          Left = 306.141930000000000000
          Top = 22.677180000000000000
          Width = 34.015770000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo136: TfrxMemoView
          Left = 340.157700000000000000
          Top = 22.677180000000000000
          Width = 45.354330710000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo137: TfrxMemoView
          Left = 385.512060000000000000
          Top = 22.677180000000000000
          Width = 56.692913390000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo138: TfrxMemoView
          Left = 442.205010000000000000
          Top = 22.677180000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          OnAfterData = 'OnFillEmptyNull'
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            '['#1053#1044#1057'.'#1062#1080#1092#1088#1072#1084#1080']')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo139: TfrxMemoView
          Left = 495.118430000000000000
          Top = 22.677180000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            '[IIF((SUM(StrToFloat(Memo170.Value)) > 0),"0,00","")]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo140: TfrxMemoView
          Left = 548.031850000000000000
          Top = 22.677180000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            '[IIF((SUM(StrToFloat(Memo171.Value)) > 0),"0,00","")]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo141: TfrxMemoView
          Left = 600.945270000000000000
          Top = 22.677180000000000000
          Width = 52.913420000000000000
          Height = 11.338590000000000000
          OnAfterData = 'OnFillEmptyNull'
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            
              '[IIF( (((<'#1053#1044#1057'.'#1058#1080#1087'> == 3) && ((<'#1058#1086#1074#1072#1088'.'#1058#1080#1087#1053#1044#1057'> == -1) || (<'#1058#1086#1074#1072#1088'.'#1058 +
              #1080#1087#1053#1044#1057'> == 0))) || (<'#1058#1086#1074#1072#1088'.'#1058#1080#1087#1053#1044#1057'> == 3)),"'#1041#1077#1079' '#1055#1044#1042'","" )]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo142: TfrxMemoView
          Left = 653.858690000000000000
          Top = 22.677180000000000000
          Width = 60.472480000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            '['#1053#1044#1057'.'#1062#1080#1092#1088#1072#1084#1080']')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo144: TfrxMemoView
          Left = 22.677180000000000000
          Top = 34.015770000000000000
          Width = 226.771653543307000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1047#1072#1075#1072#1083#1100#1085#1072' '#1089#1091#1084#1072' '#1079' '#1055#1044#1042)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo145: TfrxMemoView
          Left = 306.141930000000000000
          Top = 34.015770000000000000
          Width = 34.015770000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo146: TfrxMemoView
          Left = 340.157700000000000000
          Top = 34.015770000000000000
          Width = 45.354330710000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo147: TfrxMemoView
          Left = 385.512060000000000000
          Top = 34.015770000000000000
          Width = 56.692913390000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo148: TfrxMemoView
          Left = 442.205010000000000000
          Top = 34.015770000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          OnAfterData = 'OnFillEmptyNull'
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            
              '[IIF(StrToFloat(Memo77.Value)+StrToFloat(Memo138.Value) > 0,Form' +
              'atFloat(<'#1092#1086#1088#1084#1072#1090'_'#1089#1091#1084#1084#1072'_'#1090#1072#1073#1083'>,StrToFloat(Memo77.Value)+StrToFloat(' +
              'Memo138.Value) ),0)]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo149: TfrxMemoView
          Left = 495.118430000000000000
          Top = 34.015770000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          OnAfterData = 'OnFillEmptyNull'
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            
              '[IIF(StrToFloat(Memo78.Value) > 0,FormatFloat(<'#1092#1086#1088#1084#1072#1090'_'#1089#1091#1084#1084#1072'_'#1090#1072#1073#1083 +
              '>,StrToFloat(Memo78.Value) ),0)]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo150: TfrxMemoView
          Left = 548.031850000000000000
          Top = 34.015770000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          OnAfterData = 'OnFillEmptyNull'
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            
              '[IIF(StrToFloat(Memo79.Value) > 0,FormatFloat(<'#1092#1086#1088#1084#1072#1090'_'#1089#1091#1084#1084#1072'_'#1090#1072#1073#1083 +
              '>,StrToFloat(Memo79.Value) ),0)]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo151: TfrxMemoView
          Left = 600.945270000000000000
          Top = 34.015770000000000000
          Width = 52.913420000000000000
          Height = 11.338590000000000000
          OnAfterData = 'OnFillEmptyNull'
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            
              '[IIF(StrToFloat(Memo80.Value) > 0,FormatFloat(<'#1092#1086#1088#1084#1072#1090'_'#1089#1091#1084#1084#1072'_'#1090#1072#1073#1083 +
              '>,StrToFloat(Memo80.Value) ),0)]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo152: TfrxMemoView
          Left = 653.858690000000000000
          Top = 34.015770000000000000
          Width = 60.472480000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            
              '[FormatFloat(<'#1092#1086#1088#1084#1072#1090'_'#1089#1091#1084#1084#1072'_'#1090#1072#1073#1083'>,StrToFloat(Memo148.Value)+StrTo' +
              'Float(Memo149.Value)+StrToFloat(Memo150.Value)+StrToFloat(Memo15' +
              '1.Value))]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo84: TfrxMemoView
          Top = 162.519790000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
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
        object Memo250: TfrxMemoView
          Left = 7.559060000000000000
          Top = 211.653680000000000000
          Width = 544.252320000000000000
          Height = 15.118120000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            '['#1053#1053#1072#1082#1083'.'#1057#1090#1072#1090#1100#1080#1054#1090#1053#1044#1057']')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo111: TfrxMemoView
          Left = 249.448980000000000000
          Width = 56.692913390000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo112: TfrxMemoView
          Left = 249.448980000000000000
          Top = 11.338590000000000000
          Width = 56.692913390000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo113: TfrxMemoView
          Left = 249.448980000000000000
          Top = 22.677180000000000000
          Width = 56.692913390000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo114: TfrxMemoView
          Left = 249.448980000000000000
          Top = 34.015770000000000000
          Width = 56.692913390000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo116: TfrxMemoView
          Left = 7.559060000000000000
          Top = 226.771800000000000000
          Width = 544.252320000000000000
          Height = 15.118120000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -8
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftTop]
          Memo.UTF8W = (
            
              '('#1074#1110#1076#1087#1086#1074#1110#1076#1085#1110' '#1087#1091#1085#1082#1090#1080' ('#1087#1110#1076#1087#1091#1085#1082#1090#1080'), '#1089#1090#1072#1090#1090#1110', '#1087#1110#1076#1088#1086#1079#1076#1110#1083#1080', '#1088#1086#1079#1076#1110#1083#1080'  '#1055#1086#1076 +
              #1072#1090#1082#1086#1074#1086#1075#1086' '#1082#1086#1076#1077#1082#1089#1091' '#1059#1082#1088#1072#1111#1085#1080', '#1103#1082#1080#1084#1080' '#1087#1077#1088#1077#1076#1073#1072#1095#1077#1085#1086' '#1079#1074#1110#1083#1100#1085#1077#1085#1085#1103' '#1074#1110#1076' '#1086#1087#1086#1076#1072 +
              #1090#1082#1091#1074#1072#1085#1085#1103')')
          ParentFont = False
        end
      end
      object Band3: TfrxMasterData
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Height = 11.338590000000000000
        ParentFont = False
        Top = 542.000000000000000000
        Width = 714.331170000000000000
        OnBeforePrint = 'Band3OnBeforePrint'
        Columns = 1
        ColumnWidth = 200.000000000000000000
        ColumnGap = 20.000000000000000000
        DataSetName = 'DataRep'
        RowCount = 0
        Stretched = True
        object Memo163: TfrxMemoView
          Width = 22.677180000000000000
          Height = 11.338590000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight]
          HAlign = haCenter
          Memo.UTF8W = (
            'I')
          ParentFont = False
          SuppressRepeated = True
          VAlign = vaCenter
        end
        object Memo164: TfrxMemoView
          Left = 22.677180000000000000
          Width = 52.913420000000000000
          Height = 11.338590000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.FormatStr = 'ddmmyyyy'
          DisplayFormat.Kind = fkDateTime
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '['#1053#1053#1072#1082#1083'.'#1044#1072#1090#1072#1054#1090#1075#1088#1091#1079#1082#1080']')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo165: TfrxMemoView
          Left = 75.590600000000000000
          Width = 173.858380000000000000
          Height = 11.338590000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8W = (
            '['#1058#1086#1074#1072#1088'.'#1053#1072#1079#1074']')
          ParentFont = False
        end
        object Memo166: TfrxMemoView
          Left = 306.141930000000000000
          Width = 34.015770000000000000
          Height = 11.338590000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[IIF(<'#1058#1086#1074#1072#1088'.'#1045#1089#1083#1080#1059#1089#1083#1091#1075#1072'> > 0,"'#1075#1088#1085'.",<'#1058#1086#1074#1072#1088'.'#1045#1076#1048#1079#1084'>)]')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo167: TfrxMemoView
          Left = 340.157700000000000000
          Width = 45.354330710000000000
          Height = 11.338590000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            
              '[IIF(<'#1058#1086#1074#1072#1088'.'#1045#1089#1083#1080#1059#1089#1083#1091#1075#1072'> > 0,IIF(<'#1058#1086#1074#1072#1088'.'#1050#1086#1083#1074#1086'> == 1,"'#1087#1086#1089#1083#1091#1075#1072'",<'#1058#1086 +
              #1074#1072#1088'.'#1050#1086#1083#1074#1086'> + " / '#1087#1086#1089#1083#1091#1075#1072'"),<'#1058#1086#1074#1072#1088'.'#1050#1086#1083#1074#1086'>)]')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo168: TfrxMemoView
          Left = 385.512060000000000000
          Width = 56.692950000000000000
          Height = 11.338590000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            '['#1058#1086#1074#1072#1088'.'#1057#1082#1080#1076#1082#1072#1053#1072#1076#1073#1072#1074#1082#1072'.'#1062#1077#1085#1072']')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo169: TfrxMemoView
          Left = 442.205010000000000000
          Width = 52.913420000000000000
          Height = 11.338590000000000000
          OnAfterData = 'OnFillEmpty'
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            
              '[IIF(  ((<'#1053#1044#1057'.'#1058#1080#1087'> == 0) && ((<'#1058#1086#1074#1072#1088'.'#1058#1080#1087#1053#1044#1057'> == -1) || (<'#1058#1086#1074#1072#1088'.'#1058 +
              #1080#1087#1053#1044#1057'> == 0))),<'#1058#1086#1074#1072#1088'.'#1057#1091#1084#1084#1072'.'#1057#1082#1080#1076#1082#1072#1053#1072#1076#1073#1072#1074#1082#1072'.'#1041#1077#1079#1053#1044#1057'>,0 )]')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo170: TfrxMemoView
          Left = 495.118430000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          OnAfterData = 'OnFillEmpty'
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            
              '[IIF(  (((<'#1053#1044#1057'.'#1058#1080#1087'> == 1) && ((<'#1058#1086#1074#1072#1088'.'#1058#1080#1087#1053#1044#1057'> == -1) || (<'#1058#1086#1074#1072#1088'.' +
              #1058#1080#1087#1053#1044#1057'> == 0))) || (<'#1058#1086#1074#1072#1088'.'#1058#1080#1087#1053#1044#1057'> == 1)),<'#1058#1086#1074#1072#1088'.'#1057#1091#1084#1084#1072'.'#1057#1082#1080#1076#1082#1072#1053#1072#1076 +
              #1073#1072#1074#1082#1072'.'#1041#1077#1079#1053#1044#1057'>,0 )]')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo171: TfrxMemoView
          Left = 548.031850000000000000
          Width = 52.913420000000000000
          Height = 11.338590000000000000
          OnAfterData = 'OnFillEmpty'
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            
              '[IIF( (((<'#1053#1044#1057'.'#1058#1080#1087'> == 2) && ((<'#1058#1086#1074#1072#1088'.'#1058#1080#1087#1053#1044#1057'> == -1) || (<'#1058#1086#1074#1072#1088'.'#1058 +
              #1080#1087#1053#1044#1057'> == 0))) || (<'#1058#1086#1074#1072#1088'.'#1058#1080#1087#1053#1044#1057'> == 2)),<'#1058#1086#1074#1072#1088'.'#1057#1091#1084#1084#1072'.'#1057#1082#1080#1076#1082#1072#1053#1072#1076#1073 +
              #1072#1074#1082#1072'.'#1041#1077#1079#1053#1044#1057'>,0 )]')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo172: TfrxMemoView
          Left = 600.945270000000000000
          Width = 52.913420000000000000
          Height = 11.338590000000000000
          OnAfterData = 'OnFillEmpty'
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            
              '[IIF( (((<'#1053#1044#1057'.'#1058#1080#1087'> == 3) && ((<'#1058#1086#1074#1072#1088'.'#1058#1080#1087#1053#1044#1057'> == -1) || (<'#1058#1086#1074#1072#1088'.'#1058 +
              #1080#1087#1053#1044#1057'> == 0))) || (<'#1058#1086#1074#1072#1088'.'#1058#1080#1087#1053#1044#1057'> == 3)),<'#1058#1086#1074#1072#1088'.'#1057#1091#1084#1084#1072'.'#1057#1082#1080#1076#1082#1072#1053#1072#1076#1073 +
              #1072#1074#1082#1072'.'#1041#1077#1079#1053#1044#1057'>,0 )]')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo173: TfrxMemoView
          Left = 653.858690000000000000
          Width = 60.472480000000000000
          Height = 11.338590000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight]
          HAlign = haCenter
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo115: TfrxMemoView
          Left = 249.448980000000000000
          Width = 56.692913390000000000
          Height = 11.338590000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          CharSpacing = -0.100000000000000000
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '['#1058#1086#1074#1072#1088'.'#1050#1086#1076'.'#1059#1050#1058'_'#1047#1045#1044']')
          ParentFont = False
          VAlign = vaCenter
        end
        object ElMemo13: TfrxMemoView
          Printable = False
          Left = 22.677180000000000000
          Width = 7.559060000000000000
          Height = 11.338590000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.FormatStr = 'ddmmyyyy'
          DisplayFormat.Kind = fkDateTime
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNone
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Color = clNone
          GapX = 100.000000000000000000
          GapY = 100.000000000000000000
          Memo.UTF8W = (
            '['#1053#1053#1072#1082#1083'.'#1044#1072#1090#1072#1054#1090#1075#1088#1091#1079#1082#1080']')
          ParentFont = False
          WordWrap = False
        end
        object ElMemo14: TfrxMemoView
          Printable = False
          Left = 340.157700000000000000
          Width = 7.559060000000000000
          Height = 11.338590000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNone
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Color = clNone
          GapX = 100.000000000000000000
          GapY = 100.000000000000000000
          Memo.UTF8W = (
            '['#1058#1086#1074#1072#1088'.'#1050#1086#1083#1074#1086']')
          ParentFont = False
          WordWrap = False
        end
        object ElMemo15: TfrxMemoView
          Printable = False
          Left = 347.716760000000000000
          Width = 7.559060000000000000
          Height = 11.338590000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNone
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Color = clNone
          GapX = 100.000000000000000000
          GapY = 100.000000000000000000
          Memo.UTF8W = (
            '[IIF(<'#1058#1086#1074#1072#1088'.'#1045#1089#1083#1080#1059#1089#1083#1091#1075#1072'> > 0,"'#1087#1086#1089#1083#1091#1075#1072'","")]')
          ParentFont = False
          WordWrap = False
        end
      end
      object MasterHeader1: TfrxHeader
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Height = 506.457020000000000000
        ParentFont = False
        Top = 16.000000000000000000
        Width = 714.331170000000000000
        object Memo1: TfrxMemoView
          Left = 45.354360000000000000
          Width = 117.165430000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8W = (
            #1042#1080#1076#1072#1108#1090#1100#1089#1103' '#1087#1086#1082#1091#1087#1094#1102)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo2: TfrxMemoView
          Left = 162.519790000000000000
          Top = 11.338590000000000000
          Width = 30.236240000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '['#1053#1053#1072#1082#1083'.'#1045#1056#1053#1053']')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo3: TfrxMemoView
          Left = 162.519790000000000000
          Width = 30.236240000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[IIF(<'#1053#1053#1072#1082#1083'.'#1054#1088#1080#1075#1080#1085#1072#1083#1059#1055#1088#1086#1076#1072#1074#1094#1072'.'#1052#1077#1090#1082#1072'> == "X","","X")]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo4: TfrxMemoView
          Left = 45.354360000000000000
          Top = 11.338590000000000000
          Width = 117.165430000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8W = (
            #1042#1082#1083#1102#1095#1077#1085#1086' '#1076#1086' '#1028#1056#1055#1053)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo5: TfrxMemoView
          Top = 56.692950000000000000
          Width = 192.756030000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftTop]
          HAlign = haCenter
          Memo.UTF8W = (
            '('#1055#1086#1090#1088#1110#1073#1085#1077' '#1074#1080#1076#1110#1083#1080#1090#1080' '#1087#1086#1084#1110#1090#1082#1086#1102' "'#1061'")')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo6: TfrxMemoView
          Top = 56.692950000000000000
          Width = 714.331170000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          HAlign = haCenter
          Memo.UTF8W = (
            #1055#1054#1044#1040#1058#1050#1054#1042#1040' '#1053#1040#1050#1051#1040#1044#1053#1040)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo7: TfrxMemoView
          Left = 517.795610000000000000
          Top = 3.779530000000000000
          Width = 196.535560000000000000
          Height = 34.015770000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            #1047#1040#1058#1042#1045#1056#1044#1046#1045#1053#1054
            #1053#1072#1082#1072#1079' '#1052#1110#1085#1110#1089#1090#1077#1088#1089#1090#1074#1072' '#1092#1110#1085#1072#1085#1089#1110#1074' '#1059#1082#1088#1072#1111#1085#1080' '
            '01.11.2011 '#8470'1379')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo8: TfrxMemoView
          Top = 86.929190000000000000
          Width = 200.315090000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            #1044#1072#1090#1072' '#1074#1080#1087#1080#1089#1082#1080' '#1087#1086#1076#1072#1090#1082#1086#1074#1086#1111' '#1085#1072#1082#1083#1072#1076#1085#1086#1111)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo10: TfrxMemoView
          Left = 362.834880000000000000
          Top = 86.929190000000000000
          Width = 154.960730000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            #1055#1086#1088#1103#1076#1082#1086#1074#1080#1081' '#1085#1086#1084#1077#1088)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo12: TfrxMemoView
          Left = 102.047310000000000000
          Top = 117.165430000000000000
          Width = 249.448980000000000000
          Height = 15.118120000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          HAlign = haCenter
          Memo.UTF8W = (
            #1055#1088#1086#1076#1072#1074#1077#1094#1100)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo13: TfrxMemoView
          Left = 464.882190000000000000
          Top = 117.165430000000000000
          Width = 249.448980000000000000
          Height = 15.118120000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          HAlign = haCenter
          Memo.UTF8W = (
            #1055#1086#1082#1091#1087#1077#1094#1100)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo14: TfrxMemoView
          Left = 102.047310000000000000
          Top = 132.283550000000000000
          Width = 249.448980000000000000
          Height = 49.133890000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            '['#1040#1082#1090#1060#1080#1088#1084#1072'.'#1060#1048#1054']')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo15: TfrxMemoView
          Left = 464.882190000000000000
          Top = 132.283550000000000000
          Width = 249.448980000000000000
          Height = 49.133890000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            '['#1050#1083#1080#1077#1085#1090'.'#1060#1048#1054']')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo16: TfrxMemoView
          Top = 132.283550000000000000
          Width = 102.047310000000000000
          Height = 49.133890000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            #1054#1089#1086#1073#1072' ('#1087#1083#1072#1090#1085#1080#1082' '
            #1087#1086#1076#1072#1090#1082#1091') - '#1087#1088#1086#1076#1072#1074#1077#1094#1100)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo17: TfrxMemoView
          Left = 362.834880000000000000
          Top = 132.283550000000000000
          Width = 102.047310000000000000
          Height = 49.133890000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftRight]
          Memo.UTF8W = (
            #1054#1089#1086#1073#1072' ('#1087#1083#1072#1090#1085#1080#1082' '
            #1087#1086#1076#1072#1090#1082#1091') - '#1087#1086#1082#1091#1087#1077#1094#1100)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo18: TfrxMemoView
          Top = 234.330860000000000000
          Width = 102.047310000000000000
          Height = 34.015770000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            #1052#1110#1089#1094#1077#1079#1085#1072#1093#1086#1076#1078#1077#1085#1085#1103' ('#1087#1086#1076#1072#1090#1082#1086#1074#1072' '#1072#1076#1088#1077#1089#1072') '#1087#1088#1086#1076#1072#1074#1094#1103)
          ParentFont = False
        end
        object Memo19: TfrxMemoView
          Left = 102.047310000000000000
          Top = 181.417440000000000000
          Width = 249.448980000000000000
          Height = 22.677180000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haCenter
          Memo.UTF8W = (
            
              '('#1085#1072#1081#1084#1077#1085#1091#1074#1072#1085#1085#1103'; '#1087#1088#1110#1079#1074#1080#1097#1077', '#1110#1084#39#1103', '#1087#1086' '#1073#1072#1090#1100#1082#1086#1074#1110' - '#1076#1083#1103' '#1092#1110#1079#1080#1095#1085#1086#1111' '#1086#1089#1086#1073#1080' ' +
              '- '#1087#1110#1076#1087#1088#1080#1108#1084#1094#1103') ')
          ParentFont = False
        end
        object Memo21: TfrxMemoView
          Top = 275.905690000000000000
          Width = 151.181200000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            #1053#1086#1084#1077#1088' '#1090#1077#1083#1077#1092#1086#1085#1091)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo23: TfrxMemoView
          Top = 351.496290000000000000
          Width = 173.858380000000000000
          Height = 15.118120000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            #1042#1080#1076' '#1094#1080#1074#1110#1083#1100#1085#1086'-'#1087#1088#1072#1074#1086#1074#1086#1075#1086' '#1076#1086#1075#1086#1074#1086#1088#1091' ')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo24: TfrxMemoView
          Left = 173.858380000000000000
          Top = 340.157700000000000000
          Width = 204.094620000000000000
          Height = 26.456710000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            '[PodDog1]')
          ParentFont = False
          VAlign = vaBottom
        end
        object Memo25: TfrxMemoView
          Top = 306.141930000000000000
          Width = 200.315090000000000000
          Height = 26.456710000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            
              #1053#1086#1084#1077#1088' '#1089#1074#1110#1076#1086#1094#1090#1074#1072' '#1087#1088#1086' '#1088#1077#1108#1089#1090#1088#1072#1094#1110#1102' '#1087#1083#1072#1090#1085#1080#1082#1072' '#1087#1086#1076#1072#1090#1082#1091' '#1085#1072' '#1076#1086#1076#1072#1085#1091' '#1074#1072#1088#1090#1110#1089 +
              #1090#1100' ('#1087#1088#1086#1076#1072#1074#1094#1103')')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo27: TfrxMemoView
          Left = 362.834880000000000000
          Top = 234.330860000000000000
          Width = 102.047310000000000000
          Height = 34.015770000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            #1052#1110#1089#1094#1077#1079#1085#1072#1093#1086#1076#1078#1077#1085#1085#1103' ('#1087#1086#1076#1072#1090#1082#1086#1074#1072' '#1072#1076#1088#1077#1089#1072') '#1087#1086#1082#1091#1087#1094#1103)
          ParentFont = False
        end
        object Memo29: TfrxMemoView
          Left = 362.834880000000000000
          Top = 275.905690000000000000
          Width = 151.181200000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            #1053#1086#1084#1077#1088' '#1090#1077#1083#1077#1092#1086#1085#1091)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo31: TfrxMemoView
          Left = 362.834880000000000000
          Top = 306.141930000000000000
          Width = 200.315090000000000000
          Height = 26.456710000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            
              #1053#1086#1084#1077#1088' '#1089#1074#1110#1076#1086#1094#1090#1074#1072' '#1087#1088#1086' '#1088#1077#1108#1089#1090#1088#1072#1094#1110#1102' '#1087#1083#1072#1090#1085#1080#1082#1072' '#1087#1086#1076#1072#1090#1082#1091' '#1085#1072' '#1076#1086#1076#1072#1085#1091' '#1074#1072#1088#1090#1110#1089 +
              #1090#1100' ('#1087#1086#1082#1091#1087#1094#1103')')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo33: TfrxMemoView
          Left = 464.882190000000000000
          Top = 181.417440000000000000
          Width = 249.448980000000000000
          Height = 22.677180000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haCenter
          Memo.UTF8W = (
            
              '('#1085#1072#1081#1084#1077#1085#1091#1074#1072#1085#1085#1103'; '#1087#1088#1110#1079#1074#1080#1097#1077', '#1110#1084#39#1103', '#1087#1086' '#1073#1072#1090#1100#1082#1086#1074#1110' - '#1076#1083#1103' '#1092#1110#1079#1080#1095#1085#1086#1111' '#1086#1089#1086#1073#1080' ' +
              '- '#1087#1110#1076#1087#1088#1080#1108#1084#1094#1103')')
          ParentFont = False
        end
        object Memo34: TfrxMemoView
          Left = 170.078850000000000000
          Top = 222.992270000000000000
          Width = 181.417440000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftTop]
          HAlign = haCenter
          Memo.UTF8W = (
            '('#1110#1085#1076#1080#1074#1110#1076#1091#1072#1083#1100#1085#1080#1081' '#1087#1086#1076#1072#1090#1082#1086#1074#1080#1081' '#1085#1086#1084#1077#1088' '#1087#1088#1086#1076#1072#1074#1094#1103')')
          ParentFont = False
          WordWrap = False
        end
        object Memo35: TfrxMemoView
          Left = 532.913730000000000000
          Top = 222.992270000000000000
          Width = 181.417440000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftTop]
          HAlign = haCenter
          Memo.UTF8W = (
            '('#1110#1085#1076#1080#1074#1110#1076#1091#1072#1083#1100#1085#1080#1081' '#1087#1086#1076#1072#1090#1082#1086#1074#1080#1081' '#1085#1086#1084#1077#1088' '#1087#1086#1082#1091#1087#1094#1103')')
          ParentFont = False
          WordWrap = False
        end
        object Memo36: TfrxMemoView
          Left = 173.858380000000000000
          Top = 366.614410000000000000
          Width = 204.094620000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftTop]
          HAlign = haCenter
          Memo.UTF8W = (
            '('#1074#1080#1076' '#1076#1086#1075#1086#1074#1086#1088#1091')')
          ParentFont = False
          WordWrap = False
        end
        object Memo37: TfrxMemoView
          Top = 377.953000000000000000
          Width = 173.858380000000000000
          Height = 15.118120000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            #1060#1086#1088#1084#1072' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1093' '#1088#1086#1079#1088#1072#1093#1091#1085#1082#1110#1074)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo38: TfrxMemoView
          Left = 173.858380000000000000
          Top = 377.953000000000000000
          Width = 495.118430000000000000
          Height = 15.118120000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            '['#1053#1053#1072#1082#1083'.'#1060#1086#1088#1084#1072#1057#1095']')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo39: TfrxMemoView
          Left = 173.858380000000000000
          Top = 393.071120000000000000
          Width = 495.118430000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftTop]
          HAlign = haCenter
          Memo.UTF8W = (
            '('#1073#1072#1088#1090#1077#1088', '#1075#1086#1090#1110#1074#1082#1072', '#1086#1087#1083#1072#1090#1072' '#1079' '#1087#1086#1090#1086#1095#1085#1086#1075#1086' '#1088#1072#1093#1091#1085#1082#1072', '#1095#1077#1082' '#1090#1086#1097#1086')')
          ParentFont = False
          WordWrap = False
        end
        object Memo40: TfrxMemoView
          Top = 408.189240000000000000
          Width = 22.677180000000000000
          Height = 86.929190000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1056#1086#1079'-'
            #1076#1110#1083)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo41: TfrxMemoView
          Left = 22.677180000000000000
          Top = 408.189240000000000000
          Width = 52.913420000000000000
          Height = 86.929190000000000000
          ShowHint = False
          AllowHTMLTags = True
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            
              #1044#1072#1090#1072' '#1074#1080#1085#1080#1082#1085#1077#1085#1085#1103' '#1087#1086#1076#1072#1090#1082#1086#1074#1086#1075#1086' '#1079#1086#1073#1086#1074#8217#1103#1079#1072#1085#1085#1103' ('#1087#1086#1089#1090#1072#1095#1072#1085#1085#1103' ('#1086#1087#1083#1072#1090#1080'<sup' +
              '>2</sup>)) ')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo42: TfrxMemoView
          Left = 75.590600000000000000
          Top = 408.189240000000000000
          Width = 173.858267720000000000
          Height = 86.929190000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1053#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072' '
            #1090#1086#1074#1072#1088#1110#1074'/'#1087#1086#1089#1083#1091#1075' '
            #1087#1088#1086#1076#1072#1074#1094#1103)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo43: TfrxMemoView
          Left = 306.141930000000000000
          Top = 408.189240000000000000
          Width = 34.015770000000000000
          Height = 86.929190000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1054#1076#1080'-'
            #1085#1080#1094#1103
            #1074#1080#1084#1110#1088#1091
            #1090#1086#1074#1072#1088#1091)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo44: TfrxMemoView
          Left = 340.157700000000000000
          Top = 408.189240000000000000
          Width = 45.354360000000000000
          Height = 86.929190000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1050#1110#1083#1100#1082#1110#1089#1090#1100' ('#1086#1073#39#1108#1084', '#1086#1073#1089#1103#1075')')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo45: TfrxMemoView
          Left = 385.512060000000000000
          Top = 408.189240000000000000
          Width = 56.692950000000000000
          Height = 86.929190000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1062#1110#1085#1072' '#1087#1086#1089#1090#1072#1095#1072#1085#1085#1103' '#1086#1076#1080#1085#1080#1094#1110' '#1090#1086#1074#1072#1088#1091'/'
            #1087#1086#1089#1083#1091#1075#1080' '#1073#1077#1079' '#1091#1088#1072#1093#1091#1074#1072#1085#1085#1103' '#1055#1044#1042)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo46: TfrxMemoView
          Left = 442.205010000000000000
          Top = 408.189240000000000000
          Width = 211.653680000000000000
          Height = 34.015770000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            
              #1054#1073#1089#1103#1075#1080' '#1087#1086#1089#1090#1072#1095#1072#1085#1085#1103' ('#1073#1072#1079#1072' '#1086#1087#1086#1076#1072#1090#1082#1091#1074#1072#1085#1085#1103') '#1073#1077#1079' '#1091#1088#1072#1093#1091#1074#1072#1085#1085#1103' '#1055#1044#1042', '#1097#1086' '#1087#1110 +
              #1076#1083#1103#1075#1072#1102#1090#1100' '#1086#1087#1086#1076#1072#1090#1082#1091#1074#1072#1085#1085#1102' '#1079#1072' '#1089#1090#1072#1074#1082#1072#1084#1080)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo47: TfrxMemoView
          Left = 442.205010000000000000
          Top = 442.205010000000000000
          Width = 52.913420000000000000
          Height = 52.913420000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1086#1089#1085#1086#1074#1085#1072
            #1089#1090#1072#1074#1082#1072)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo48: TfrxMemoView
          Left = 495.118430000000000000
          Top = 453.543600000000000000
          Width = 52.913420000000000000
          Height = 41.574830000000000000
          ShowHint = False
          CharSpacing = -0.400000000000000000
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '('#1087#1086#1089#1090#1072#1095#1072#1085#1085#1103' '#1085#1072' '#1084#1080#1090#1085#1110#1081
            ' '#1090#1077#1088#1080#1090#1086#1088#1110#1111' '#1059#1082#1088#1072#1111#1085#1080')')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo49: TfrxMemoView
          Left = 548.031850000000000000
          Top = 453.543600000000000000
          Width = 52.913385830000000000
          Height = 41.574830000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '('#1077#1082#1089#1087#1086#1088#1090')')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo50: TfrxMemoView
          Left = 600.945270000000000000
          Top = 442.205010000000000000
          Width = 52.913420000000000000
          Height = 52.913420000000000000
          ShowHint = False
          AllowHTMLTags = True
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1079#1074#1110#1083#1100#1085#1077#1085#1085#1103
            #1074#1110#1076' '#1055#1044#1042'<sup>3</sup>')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo51: TfrxMemoView
          Left = 653.858690000000000000
          Top = 408.189240000000000000
          Width = 60.472480000000000000
          Height = 86.929190000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1047#1072#1075#1072#1083#1100#1085#1072' '#1089#1091#1084#1072' '#1082#1086#1096#1090#1110#1074', '#1097#1086' '#1087#1110#1076#1083#1103#1075#1072#1108' '#1089#1087#1083#1072#1090#1110)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo52: TfrxMemoView
          Top = 495.118430000000000000
          Width = 22.677180000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '1')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo53: TfrxMemoView
          Left = 22.677180000000000000
          Top = 495.118430000000000000
          Width = 52.913420000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '2')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo54: TfrxMemoView
          Left = 75.590600000000000000
          Top = 495.118430000000000000
          Width = 173.858267720000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '3')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo55: TfrxMemoView
          Left = 306.141930000000000000
          Top = 495.118430000000000000
          Width = 34.015770000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '5')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo56: TfrxMemoView
          Left = 340.157700000000000000
          Top = 495.118430000000000000
          Width = 45.354360000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '6')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo57: TfrxMemoView
          Left = 385.512060000000000000
          Top = 495.118430000000000000
          Width = 56.692950000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '7')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo58: TfrxMemoView
          Left = 442.205010000000000000
          Top = 495.118430000000000000
          Width = 52.913420000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '8')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo59: TfrxMemoView
          Left = 495.118430000000000000
          Top = 495.118430000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '9')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo60: TfrxMemoView
          Left = 548.031850000000000000
          Top = 495.118430000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '10')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo61: TfrxMemoView
          Left = 600.945270000000000000
          Top = 495.118430000000000000
          Width = 52.913420000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '11')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo62: TfrxMemoView
          Left = 653.858690000000000000
          Top = 495.118430000000000000
          Width = 60.472480000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '12')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo159: TfrxMemoView
          Left = 102.047310000000000000
          Top = 234.330860000000000000
          Width = 249.448980000000000000
          Height = 34.015770000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            '['#1040#1082#1090#1060#1080#1088#1084#1072'.'#1070#1088#1040#1076#1088#1077#1089']')
          ParentFont = False
          VAlign = vaBottom
        end
        object Memo160: TfrxMemoView
          Left = 464.882190000000000000
          Top = 234.330860000000000000
          Width = 249.448980000000000000
          Height = 34.015770000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            '['#1050#1083#1080#1077#1085#1090'.'#1070#1088#1040#1076#1088#1077#1089']')
          ParentFont = False
          VAlign = vaBottom
        end
        object Memo175: TfrxMemoView
          Left = 185.196970000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo176: TfrxMemoView
          Left = 200.315090000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo177: TfrxMemoView
          Left = 215.433210000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo178: TfrxMemoView
          Left = 230.551330000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo179: TfrxMemoView
          Left = 245.669450000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo180: TfrxMemoView
          Left = 260.787570000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo181: TfrxMemoView
          Left = 275.905690000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo182: TfrxMemoView
          Left = 291.023810000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo183: TfrxMemoView
          Left = 306.141930000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo184: TfrxMemoView
          Left = 321.260050000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo185: TfrxMemoView
          Left = 336.378170000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo187: TfrxMemoView
          Left = 548.031850000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo188: TfrxMemoView
          Left = 563.149970000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo189: TfrxMemoView
          Left = 578.268090000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo190: TfrxMemoView
          Left = 593.386210000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo191: TfrxMemoView
          Left = 608.504330000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo192: TfrxMemoView
          Left = 623.622450000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo193: TfrxMemoView
          Left = 638.740570000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo194: TfrxMemoView
          Left = 653.858690000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo195: TfrxMemoView
          Left = 668.976810000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo196: TfrxMemoView
          Left = 684.094930000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo197: TfrxMemoView
          Left = 699.213050000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo63: TfrxMemoView
          Left = 45.354360000000000000
          Top = 22.677180000000000000
          Width = 117.165430000000000000
          Height = 22.677180000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8W = (
            #1047#1072#1083#1080#1096#1072#1108#1090#1100#1089#1103' '#1091' '#1087#1088#1086#1076#1072#1074#1094#1103' '
            '('#1090#1080#1087' '#1087#1088#1080#1095#1080#1085#1080')')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo64: TfrxMemoView
          Width = 45.354360000000000000
          Height = 45.354360000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8W = (
            #1054#1088#1080#1075#1110#1085#1072#1083)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo65: TfrxMemoView
          Left = 162.519790000000000000
          Top = 22.677180000000000000
          Width = 30.236240000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '['#1053#1053#1072#1082#1083'.'#1054#1088#1080#1075#1080#1085#1072#1083#1059#1055#1088#1086#1076#1072#1074#1094#1072'.'#1052#1077#1090#1082#1072']')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo66: TfrxMemoView
          Left = 162.519790000000000000
          Top = 34.015770000000000000
          Width = 30.236240000000000000
          Height = 11.338590000000000000
          ShowHint = False
          CharSpacing = 7.000000000000000000
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          GapX = 6.000000000000000000
          Memo.UTF8W = (
            
              '[IIF(<'#1053#1053#1072#1082#1083'.'#1054#1088#1080#1075#1080#1085#1072#1083#1059#1055#1088#1086#1076#1072#1074#1094#1072'.'#1052#1077#1090#1082#1072'> == "X",<'#1053#1053#1072#1082#1083'.'#1054#1088#1080#1075#1080#1085#1072#1083#1059#1055#1088#1086#1076 +
              #1072#1074#1094#1072'.'#1055#1088#1080#1095#1080#1085#1072'>,"")]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo67: TfrxMemoView
          Left = 177.637910000000000000
          Top = 34.015770000000000000
          Width = 15.118120000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo68: TfrxMemoView
          Top = 45.354360000000000000
          Width = 162.519790000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8W = (
            #1050#1086#1087#1110#1103' ('#1079#1072#1083#1080#1096#1072#1108#1090#1100#1089#1103' '#1091' '#1087#1088#1086#1076#1072#1074#1094#1103')')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo69: TfrxMemoView
          Left = 162.519790000000000000
          Top = 45.354360000000000000
          Width = 30.236240000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo70: TfrxMemoView
          Left = 638.740570000000000000
          Top = 105.826840000000000000
          Width = 75.590600000000000000
          Height = 11.338590000000000000
          ShowHint = False
          AllowHTMLTags = True
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haCenter
          Memo.UTF8W = (
            '(<sup>1</sup>)   ('#1085#1086#1084#1077#1088' '#1092#1110#1083#1110#1111')')
          ParentFont = False
          WordWrap = False
        end
        object Memo71: TfrxMemoView
          Left = 517.795610000000000000
          Top = 86.929190000000000000
          Width = 105.826840000000000000
          Height = 18.897650000000000000
          ShowHint = False
          CharSpacing = 7.000000000000000000
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          GapX = 4.000000000000000000
          HAlign = haRight
          HideZeros = True
          Memo.UTF8W = (
            
              '[IIF((Pos("/",<'#1044#1086#1082#1091#1084'.'#1053#1086#1084#1077#1088'>) > 0),Copy(<'#1044#1086#1082#1091#1084'.'#1053#1086#1084#1077#1088'>,1,Pos("/",<' +
              #1044#1086#1082#1091#1084'.'#1053#1086#1084#1077#1088'>)-1),<'#1044#1086#1082#1091#1084'.'#1053#1086#1084#1077#1088'>) ]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo72: TfrxMemoView
          Left = 532.913730000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo82: TfrxMemoView
          Left = 548.031850000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo108: TfrxMemoView
          Left = 563.149970000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo117: TfrxMemoView
          Left = 578.268090000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo198: TfrxMemoView
          Left = 593.386210000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo199: TfrxMemoView
          Left = 608.504330000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo202: TfrxMemoView
          Left = 653.858690000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo203: TfrxMemoView
          Left = 668.976810000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo204: TfrxMemoView
          Left = 684.094930000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo205: TfrxMemoView
          Left = 623.622450000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          CharSpacing = 7.000000000000000000
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          GapX = 4.000000000000000000
          HideZeros = True
          Memo.UTF8W = (
            '/')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo11: TfrxMemoView
          Left = 200.315090000000000000
          Top = 86.929190000000000000
          Width = 120.944960000000000000
          Height = 18.897650000000000000
          ShowHint = False
          CharSpacing = 7.000000000000000000
          DisplayFormat.FormatStr = 'ddmmyyyy'
          DisplayFormat.Kind = fkDateTime
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          GapX = 4.000000000000000000
          HideZeros = True
          Memo.UTF8W = (
            '['#1044#1086#1082#1091#1084'.'#1044#1072#1090#1072'.'#1062#1080#1092#1088#1072#1084#1080']')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo200: TfrxMemoView
          Left = 245.669450000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo206: TfrxMemoView
          Left = 260.787570000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo207: TfrxMemoView
          Left = 275.905690000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo208: TfrxMemoView
          Left = 291.023810000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo209: TfrxMemoView
          Left = 306.141930000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo9: TfrxMemoView
          Left = 200.315090000000000000
          Top = 275.905690000000000000
          Width = 151.181200000000000000
          Height = 18.897650000000000000
          ShowHint = False
          CharSpacing = 7.000000000000000000
          DisplayFormat.FormatStr = 'dd.mm.yy'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          GapX = 4.000000000000000000
          HAlign = haRight
          HideZeros = True
          Memo.UTF8W = (
            
              '[IIF((Length(FilterPhone(<'#1040#1082#1090#1060#1080#1088#1084#1072'.'#1058#1077#1083'>)) > 10),Copy(FilterPhone' +
              '(<'#1040#1082#1090#1060#1080#1088#1084#1072'.'#1058#1077#1083'>),Length(FilterPhone(<'#1040#1082#1090#1060#1080#1088#1084#1072'.'#1058#1077#1083'>))-9,10),Filte' +
              'rPhone(<'#1040#1082#1090#1060#1080#1088#1084#1072'.'#1058#1077#1083'>))]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo20: TfrxMemoView
          Left = 215.433210000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo28: TfrxMemoView
          Left = 230.551330000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo212: TfrxMemoView
          Left = 245.669450000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo213: TfrxMemoView
          Left = 260.787570000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo214: TfrxMemoView
          Left = 275.905690000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo215: TfrxMemoView
          Left = 291.023810000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo216: TfrxMemoView
          Left = 306.141930000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo22: TfrxMemoView
          Left = 321.260050000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo161: TfrxMemoView
          Left = 336.378170000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo217: TfrxMemoView
          Left = 563.149970000000000000
          Top = 275.905690000000000000
          Width = 151.181200000000000000
          Height = 18.897650000000000000
          ShowHint = False
          CharSpacing = 7.000000000000000000
          DisplayFormat.FormatStr = 'dd.mm.yy'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          GapX = 4.000000000000000000
          HAlign = haRight
          HideZeros = True
          Memo.UTF8W = (
            
              '[IIF((Length(FilterPhone(<'#1050#1083#1080#1077#1085#1090'.'#1058#1077#1083'>)) > 10),Copy(FilterPhone(<' +
              #1050#1083#1080#1077#1085#1090'.'#1058#1077#1083'>),Length(FilterPhone(<'#1050#1083#1080#1077#1085#1090'.'#1058#1077#1083'>))-9,10),FilterPhone' +
              '(<'#1050#1083#1080#1077#1085#1090'.'#1058#1077#1083'>))]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo218: TfrxMemoView
          Left = 578.268090000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo219: TfrxMemoView
          Left = 593.386210000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo220: TfrxMemoView
          Left = 608.504330000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo221: TfrxMemoView
          Left = 623.622450000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo222: TfrxMemoView
          Left = 638.740570000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo223: TfrxMemoView
          Left = 653.858690000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo224: TfrxMemoView
          Left = 668.976810000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo225: TfrxMemoView
          Left = 684.094930000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo226: TfrxMemoView
          Left = 699.213050000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo30: TfrxMemoView
          Left = 200.315090000000000000
          Top = 313.700990000000000000
          Width = 151.181200000000000000
          Height = 18.897650000000000000
          ShowHint = False
          CharSpacing = 7.000000000000000000
          DisplayFormat.FormatStr = 'dd.mm.yy'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          GapX = 4.000000000000000000
          HAlign = haRight
          HideZeros = True
          Memo.UTF8W = (
            '['#1040#1082#1090#1060#1080#1088#1084#1072'.'#1057#1074#1080#1076']')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo162: TfrxMemoView
          Left = 215.433210000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo227: TfrxMemoView
          Left = 230.551330000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo228: TfrxMemoView
          Left = 245.669450000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo229: TfrxMemoView
          Left = 260.787570000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo230: TfrxMemoView
          Left = 275.905690000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo231: TfrxMemoView
          Left = 291.023810000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo232: TfrxMemoView
          Left = 306.141930000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo233: TfrxMemoView
          Left = 321.260050000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo234: TfrxMemoView
          Left = 336.378170000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo235: TfrxMemoView
          Left = 563.149970000000000000
          Top = 313.700990000000000000
          Width = 151.181200000000000000
          Height = 18.897650000000000000
          ShowHint = False
          CharSpacing = 7.000000000000000000
          DisplayFormat.FormatStr = 'dd.mm.yy'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          GapX = 4.000000000000000000
          HAlign = haRight
          HideZeros = True
          Memo.UTF8W = (
            '[IIF(Length(Trim(<'#1050#1083#1080#1077#1085#1090'.'#1057#1074#1080#1076'>)) == 0,"0",<'#1050#1083#1080#1077#1085#1090'.'#1057#1074#1080#1076'>)]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo236: TfrxMemoView
          Left = 578.268090000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo237: TfrxMemoView
          Left = 593.386210000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo238: TfrxMemoView
          Left = 608.504330000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo239: TfrxMemoView
          Left = 623.622450000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo240: TfrxMemoView
          Left = 638.740570000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo241: TfrxMemoView
          Left = 653.858690000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo242: TfrxMemoView
          Left = 668.976810000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo243: TfrxMemoView
          Left = 684.094930000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo244: TfrxMemoView
          Left = 699.213050000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo26: TfrxMemoView
          Left = 396.850650000000000000
          Top = 347.716760000000000000
          Width = 120.944960000000000000
          Height = 18.897650000000000000
          ShowHint = False
          CharSpacing = 7.000000000000000000
          DisplayFormat.FormatStr = 'ddmmyyyy'
          DisplayFormat.Kind = fkDateTime
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          GapX = 4.000000000000000000
          HideZeros = True
          Memo.UTF8W = (
            '[PodDogDate2]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo32: TfrxMemoView
          Left = 442.205010000000000000
          Top = 347.716760000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo245: TfrxMemoView
          Left = 457.323130000000000000
          Top = 347.716760000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo246: TfrxMemoView
          Left = 472.441250000000000000
          Top = 347.716760000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo247: TfrxMemoView
          Left = 487.559370000000000000
          Top = 347.716760000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo248: TfrxMemoView
          Left = 502.677490000000000000
          Top = 347.716760000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo251: TfrxMemoView
          Left = 517.795610000000000000
          Top = 347.716760000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          CharSpacing = 7.000000000000000000
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          GapX = 4.000000000000000000
          HideZeros = True
          Memo.UTF8W = (
            #8470)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo252: TfrxMemoView
          Left = 532.913730000000000000
          Top = 347.716760000000000000
          Width = 181.417440000000000000
          Height = 18.897650000000000000
          ShowHint = False
          CharSpacing = 2.000000000000000000
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          GapX = 4.000000000000000000
          HAlign = haRight
          HideZeros = True
          Memo.UTF8W = (
            '[PodDog3]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo258: TfrxMemoView
          Left = 377.953000000000000000
          Top = 351.496290000000000000
          Width = 18.897650000000000000
          Height = 15.118120000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haCenter
          Memo.UTF8W = (
            #1074#1110#1076)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo85: TfrxMemoView
          Left = 411.968770000000000000
          Top = 347.716760000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo86: TfrxMemoView
          Left = 427.086890000000000000
          Top = 347.716760000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo87: TfrxMemoView
          Left = 215.433210000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo88: TfrxMemoView
          Left = 230.551330000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo89: TfrxMemoView
          Left = 170.078850000000000000
          Top = 204.094620000000000000
          Width = 181.417440000000000000
          Height = 18.897650000000000000
          ShowHint = False
          CharSpacing = 7.000000000000000000
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          GapX = 4.000000000000000000
          HAlign = haRight
          HideZeros = True
          Memo.UTF8W = (
            '['#1040#1082#1090#1060#1080#1088#1084#1072'.'#1048#1055#1053']')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo90: TfrxMemoView
          Left = 532.913730000000000000
          Top = 204.094620000000000000
          Width = 181.417440000000000000
          Height = 18.897650000000000000
          ShowHint = False
          CharSpacing = 7.000000000000000000
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          GapX = 4.000000000000000000
          HAlign = haRight
          HideZeros = True
          Memo.UTF8W = (
            '[IIF(Length(Trim(<'#1050#1083#1080#1077#1085#1090'.'#1048#1055#1053'>)) == 0,"0",<'#1050#1083#1080#1077#1085#1090'.'#1048#1055#1053'>)]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo107: TfrxMemoView
          Left = 638.740570000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          CharSpacing = 7.000000000000000000
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          GapX = 4.000000000000000000
          HideZeros = True
          Memo.UTF8W = (
            
              '[IIF((Pos("/",<'#1044#1086#1082#1091#1084'.'#1053#1086#1084#1077#1088'>) > 0),Copy(<'#1044#1086#1082#1091#1084'.'#1053#1086#1084#1077#1088'>,Pos("/",<'#1044#1086 +
              #1082#1091#1084'.'#1053#1086#1084#1077#1088'>)+1,100),"") ]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo105: TfrxMemoView
          Left = 495.118430000000000000
          Top = 442.205010000000000000
          Width = 105.826840000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1085#1091#1083#1100#1086#1074#1072' '#1089#1090#1072#1074#1082#1072)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo109: TfrxMemoView
          Left = 249.448980000000000000
          Top = 408.189240000000000000
          Width = 56.692950000000000000
          Height = 86.929190000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1050#1086#1076' '#1090#1086#1074#1072#1088#1091' '#1079#1075#1110#1076#1085#1086' '#1079' '#1059#1050#1058' '#1047#1045#1044)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo110: TfrxMemoView
          Left = 249.448980000000000000
          Top = 495.118430000000000000
          Width = 56.692913390000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '4')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo473: TfrxMemoView
          Left = 653.858690000000000000
          Top = 86.929190000000000000
          Width = 60.472480000000000000
          Height = 18.897650000000000000
          ShowHint = False
          CharSpacing = 7.000000000000000000
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          GapX = 4.000000000000000000
          HAlign = haRight
          HideZeros = True
          Memo.UTF8W = (
            '['#1040#1082#1090#1060#1080#1088#1084#1072'.'#1050#1086#1076#1060#1080#1083#1080#1080']')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object ElMemo1: TfrxMemoView
          Printable = False
          Left = 226.771800000000000000
          Top = 7.559060000000000000
          Width = 7.559060000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNone
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Color = clNone
          GapX = 100.000000000000000000
          GapY = 100.000000000000000000
          Memo.UTF8W = (
            '[FormatDateTime("ddmmyyyy",<Date>)]')
          ParentFont = False
          WordWrap = False
        end
        object ElMemo2: TfrxMemoView
          Printable = False
          Left = 234.330860000000000000
          Top = 7.559060000000000000
          Width = 7.559060000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNone
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Color = clNone
          GapX = 100.000000000000000000
          GapY = 100.000000000000000000
          Memo.UTF8W = (
            '[FormatDateTime("yyyy",<'#1044#1086#1082#1091#1084'.'#1044#1072#1090#1072'.'#1062#1080#1092#1088#1072#1084#1080'>)]')
          ParentFont = False
          WordWrap = False
        end
        object ElMemo3: TfrxMemoView
          Printable = False
          Left = 241.889920000000000000
          Top = 7.559060000000000000
          Width = 7.559060000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNone
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Color = clNone
          GapX = 100.000000000000000000
          GapY = 100.000000000000000000
          Memo.UTF8W = (
            '[FormatDateTime("m",<'#1044#1086#1082#1091#1084'.'#1044#1072#1090#1072'.'#1062#1080#1092#1088#1072#1084#1080'>)]')
          ParentFont = False
          WordWrap = False
        end
        object ElMemo4: TfrxMemoView
          Printable = False
          Left = 249.448980000000000000
          Top = 7.559060000000000000
          Width = 7.559060000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNone
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Color = clNone
          GapX = 100.000000000000000000
          GapY = 100.000000000000000000
          Memo.UTF8W = (
            '['#1040#1082#1090#1060#1080#1088#1084#1072'.'#1050#1086#1076#1054#1073#1083#1072#1089#1090#1100']')
          ParentFont = False
          WordWrap = False
        end
        object ElMemo5: TfrxMemoView
          Printable = False
          Left = 257.008040000000000000
          Top = 7.559060000000000000
          Width = 7.559060000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNone
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Color = clNone
          GapX = 100.000000000000000000
          GapY = 100.000000000000000000
          Memo.UTF8W = (
            '['#1040#1082#1090#1060#1080#1088#1084#1072'.'#1050#1086#1076#1056#1072#1081#1086#1085']')
          ParentFont = False
          WordWrap = False
        end
        object ElMemo6: TfrxMemoView
          Printable = False
          Left = 264.567100000000000000
          Top = 7.559060000000000000
          Width = 7.559060000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNone
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Color = clNone
          GapX = 100.000000000000000000
          GapY = 100.000000000000000000
          Memo.UTF8W = (
            '['#1040#1082#1090#1060#1080#1088#1084#1072'.'#1050#1086#1076#1043#1053#1048']')
          ParentFont = False
          WordWrap = False
        end
        object ElMemo7: TfrxMemoView
          Printable = False
          Left = 272.126160000000000000
          Top = 7.559060000000000000
          Width = 7.559060000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNone
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Color = clNone
          GapX = 100.000000000000000000
          GapY = 100.000000000000000000
          Memo.UTF8W = (
            '['#1044#1086#1082#1091#1084'.'#1044#1072#1090#1072'.'#1057#1083#1086#1074#1072#1084#1080']')
          ParentFont = False
          WordWrap = False
        end
        object ElMemo8: TfrxMemoView
          Printable = False
          Left = 287.244280000000000000
          Top = 7.559060000000000000
          Width = 7.559060000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNone
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Color = clNone
          GapX = 100.000000000000000000
          GapY = 100.000000000000000000
          Memo.UTF8W = (
            '[IIF(<'#1053#1053#1072#1082#1083'.'#1054#1088#1080#1075#1080#1085#1072#1083#1059#1055#1088#1086#1076#1072#1074#1094#1072'.'#1052#1077#1090#1082#1072'> == "X","","1")]')
          ParentFont = False
          WordWrap = False
        end
        object ElMemo9: TfrxMemoView
          Printable = False
          Left = 294.803340000000000000
          Top = 7.559060000000000000
          Width = 7.559060000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNone
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Color = clNone
          GapX = 100.000000000000000000
          GapY = 100.000000000000000000
          Memo.UTF8W = (
            '[IIF(<'#1053#1053#1072#1082#1083'.'#1045#1056#1053#1053'> == "X","1","")]')
          ParentFont = False
          WordWrap = False
        end
        object ElMemo10: TfrxMemoView
          Printable = False
          Left = 302.362400000000000000
          Top = 7.559060000000000000
          Width = 7.559060000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNone
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Color = clNone
          GapX = 100.000000000000000000
          GapY = 100.000000000000000000
          Memo.UTF8W = (
            '[IIF(<'#1053#1053#1072#1082#1083'.'#1054#1088#1080#1075#1080#1085#1072#1083#1059#1055#1088#1086#1076#1072#1074#1094#1072'.'#1052#1077#1090#1082#1072'> == "X","1","")]')
          ParentFont = False
          WordWrap = False
        end
        object ElMemo11: TfrxMemoView
          Printable = False
          Left = 309.921460000000000000
          Top = 7.559060000000000000
          Width = 7.559060000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNone
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Color = clNone
          GapX = 100.000000000000000000
          GapY = 100.000000000000000000
          Memo.UTF8W = (
            '['#1040#1082#1090#1060#1080#1088#1084#1072'.'#1047#1050#1055#1054']')
          ParentFont = False
          WordWrap = False
        end
        object ElMemo12: TfrxMemoView
          Printable = False
          Left = 317.480520000000000000
          Top = 7.559060000000000000
          Width = 7.559060000000000000
          Height = 18.897650000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNone
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Color = clNone
          GapX = 100.000000000000000000
          GapY = 100.000000000000000000
          Memo.UTF8W = (
            '[IIF((Length(<'#1040#1082#1090#1060#1080#1088#1084#1072'.'#1047#1050#1055#1054'>) > 8),"F","J")]')
          ParentFont = False
          WordWrap = False
        end
      end
    end
    object Page2: TfrxReportPage
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
      LeftMargin = 15.000000000000000000
      RightMargin = 6.000000000000000000
      TopMargin = 6.000000000000000000
      BottomMargin = 6.000000000000000000
      object Header1: TfrxHeader
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Height = 506.457020000000000000
        ParentFont = False
        Top = 18.897650000000000000
        Width = 714.331170000000000000
        object Memo118: TfrxMemoView
          Left = 45.354360000000000000
          Width = 117.165430000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8W = (
            #1042#1080#1076#1072#1108#1090#1100#1089#1103' '#1087#1086#1082#1091#1087#1094#1102)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo119: TfrxMemoView
          Left = 162.519790000000000000
          Top = 11.338590000000000000
          Width = 30.236240000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '['#1053#1053#1072#1082#1083'.'#1045#1056#1053#1053']')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo120: TfrxMemoView
          Left = 162.519790000000000000
          Width = 30.236240000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo121: TfrxMemoView
          Left = 45.354360000000000000
          Top = 11.338590000000000000
          Width = 117.165430000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8W = (
            #1042#1082#1083#1102#1095#1077#1085#1086' '#1076#1086' '#1028#1056#1055#1053)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo122: TfrxMemoView
          Top = 56.692950000000000000
          Width = 192.756030000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftTop]
          HAlign = haCenter
          Memo.UTF8W = (
            '('#1055#1086#1090#1088#1110#1073#1085#1077' '#1074#1080#1076#1110#1083#1080#1090#1080' '#1087#1086#1084#1110#1090#1082#1086#1102' "'#1061'")')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo123: TfrxMemoView
          Top = 56.692950000000000000
          Width = 714.331170000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          HAlign = haCenter
          Memo.UTF8W = (
            #1055#1054#1044#1040#1058#1050#1054#1042#1040' '#1053#1040#1050#1051#1040#1044#1053#1040)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo124: TfrxMemoView
          Left = 517.795610000000000000
          Top = 3.779530000000000000
          Width = 196.535560000000000000
          Height = 34.015770000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            #1047#1040#1058#1042#1045#1056#1044#1046#1045#1053#1054
            #1053#1072#1082#1072#1079' '#1052#1110#1085#1110#1089#1090#1077#1088#1089#1090#1074#1072' '#1092#1110#1085#1072#1085#1089#1110#1074' '#1059#1082#1088#1072#1111#1085#1080' '
            '01.11.2011 '#8470'1379')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo125: TfrxMemoView
          Top = 86.929190000000000000
          Width = 200.315090000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            #1044#1072#1090#1072' '#1074#1080#1087#1080#1089#1082#1080' '#1087#1086#1076#1072#1090#1082#1086#1074#1086#1111' '#1085#1072#1082#1083#1072#1076#1085#1086#1111)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo126: TfrxMemoView
          Left = 362.834880000000000000
          Top = 86.929190000000000000
          Width = 154.960730000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            #1055#1086#1088#1103#1076#1082#1086#1074#1080#1081' '#1085#1086#1084#1077#1088)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo127: TfrxMemoView
          Left = 102.047310000000000000
          Top = 117.165430000000000000
          Width = 249.448980000000000000
          Height = 15.118120000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          HAlign = haCenter
          Memo.UTF8W = (
            #1055#1088#1086#1076#1072#1074#1077#1094#1100)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo128: TfrxMemoView
          Left = 464.882190000000000000
          Top = 117.165430000000000000
          Width = 249.448980000000000000
          Height = 15.118120000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          HAlign = haCenter
          Memo.UTF8W = (
            #1055#1086#1082#1091#1087#1077#1094#1100)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo129: TfrxMemoView
          Left = 102.047310000000000000
          Top = 132.283550000000000000
          Width = 249.448980000000000000
          Height = 49.133890000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            '['#1040#1082#1090#1060#1080#1088#1084#1072'.'#1060#1048#1054']')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo130: TfrxMemoView
          Left = 464.882190000000000000
          Top = 132.283550000000000000
          Width = 249.448980000000000000
          Height = 49.133890000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            '['#1050#1083#1080#1077#1085#1090'.'#1060#1048#1054']')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo131: TfrxMemoView
          Top = 132.283550000000000000
          Width = 102.047310000000000000
          Height = 49.133890000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            #1054#1089#1086#1073#1072' ('#1087#1083#1072#1090#1085#1080#1082' '
            #1087#1086#1076#1072#1090#1082#1091') - '#1087#1088#1086#1076#1072#1074#1077#1094#1100)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo132: TfrxMemoView
          Left = 362.834880000000000000
          Top = 132.283550000000000000
          Width = 102.047310000000000000
          Height = 49.133890000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftRight]
          Memo.UTF8W = (
            #1054#1089#1086#1073#1072' ('#1087#1083#1072#1090#1085#1080#1082' '
            #1087#1086#1076#1072#1090#1082#1091') - '#1087#1086#1082#1091#1087#1077#1094#1100)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo133: TfrxMemoView
          Top = 234.330860000000000000
          Width = 102.047310000000000000
          Height = 34.015770000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            #1052#1110#1089#1094#1077#1079#1085#1072#1093#1086#1076#1078#1077#1085#1085#1103' ('#1087#1086#1076#1072#1090#1082#1086#1074#1072' '#1072#1076#1088#1077#1089#1072') '#1087#1088#1086#1076#1072#1074#1094#1103)
          ParentFont = False
        end
        object Memo174: TfrxMemoView
          Left = 102.047310000000000000
          Top = 181.417440000000000000
          Width = 249.448980000000000000
          Height = 22.677180000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haCenter
          Memo.UTF8W = (
            
              '('#1085#1072#1081#1084#1077#1085#1091#1074#1072#1085#1085#1103'; '#1087#1088#1110#1079#1074#1080#1097#1077', '#1110#1084#39#1103', '#1087#1086' '#1073#1072#1090#1100#1082#1086#1074#1110' - '#1076#1083#1103' '#1092#1110#1079#1080#1095#1085#1086#1111' '#1086#1089#1086#1073#1080' ' +
              '- '#1087#1110#1076#1087#1088#1080#1108#1084#1094#1103') ')
          ParentFont = False
        end
        object Memo186: TfrxMemoView
          Top = 275.905690000000000000
          Width = 151.181200000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            #1053#1086#1084#1077#1088' '#1090#1077#1083#1077#1092#1086#1085#1091)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo201: TfrxMemoView
          Top = 351.496290000000000000
          Width = 173.858380000000000000
          Height = 15.118120000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            #1042#1080#1076' '#1094#1080#1074#1110#1083#1100#1085#1086'-'#1087#1088#1072#1074#1086#1074#1086#1075#1086' '#1076#1086#1075#1086#1074#1086#1088#1091' ')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo210: TfrxMemoView
          Left = 173.858380000000000000
          Top = 340.157700000000000000
          Width = 204.094620000000000000
          Height = 26.456710000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            '[PodDog1]')
          ParentFont = False
          VAlign = vaBottom
        end
        object Memo211: TfrxMemoView
          Top = 306.141930000000000000
          Width = 200.315090000000000000
          Height = 26.456710000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            
              #1053#1086#1084#1077#1088' '#1089#1074#1110#1076#1086#1094#1090#1074#1072' '#1087#1088#1086' '#1088#1077#1108#1089#1090#1088#1072#1094#1110#1102' '#1087#1083#1072#1090#1085#1080#1082#1072' '#1087#1086#1076#1072#1090#1082#1091' '#1085#1072' '#1076#1086#1076#1072#1085#1091' '#1074#1072#1088#1090#1110#1089 +
              #1090#1100' ('#1087#1088#1086#1076#1072#1074#1094#1103')')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo249: TfrxMemoView
          Left = 362.834880000000000000
          Top = 234.330860000000000000
          Width = 102.047310000000000000
          Height = 34.015770000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            #1052#1110#1089#1094#1077#1079#1085#1072#1093#1086#1076#1078#1077#1085#1085#1103' ('#1087#1086#1076#1072#1090#1082#1086#1074#1072' '#1072#1076#1088#1077#1089#1072') '#1087#1086#1082#1091#1087#1094#1103)
          ParentFont = False
        end
        object Memo259: TfrxMemoView
          Left = 362.834880000000000000
          Top = 275.905690000000000000
          Width = 151.181200000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            #1053#1086#1084#1077#1088' '#1090#1077#1083#1077#1092#1086#1085#1091)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo260: TfrxMemoView
          Left = 362.834880000000000000
          Top = 306.141930000000000000
          Width = 200.315090000000000000
          Height = 26.456710000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            
              #1053#1086#1084#1077#1088' '#1089#1074#1110#1076#1086#1094#1090#1074#1072' '#1087#1088#1086' '#1088#1077#1108#1089#1090#1088#1072#1094#1110#1102' '#1087#1083#1072#1090#1085#1080#1082#1072' '#1087#1086#1076#1072#1090#1082#1091' '#1085#1072' '#1076#1086#1076#1072#1085#1091' '#1074#1072#1088#1090#1110#1089 +
              #1090#1100' ('#1087#1086#1082#1091#1087#1094#1103')')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo261: TfrxMemoView
          Left = 464.882190000000000000
          Top = 181.417440000000000000
          Width = 249.448980000000000000
          Height = 22.677180000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haCenter
          Memo.UTF8W = (
            
              '('#1085#1072#1081#1084#1077#1085#1091#1074#1072#1085#1085#1103'; '#1087#1088#1110#1079#1074#1080#1097#1077', '#1110#1084#39#1103', '#1087#1086' '#1073#1072#1090#1100#1082#1086#1074#1110' - '#1076#1083#1103' '#1092#1110#1079#1080#1095#1085#1086#1111' '#1086#1089#1086#1073#1080' ' +
              '- '#1087#1110#1076#1087#1088#1080#1108#1084#1094#1103')')
          ParentFont = False
        end
        object Memo262: TfrxMemoView
          Left = 170.078850000000000000
          Top = 222.992270000000000000
          Width = 181.417440000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftTop]
          HAlign = haCenter
          Memo.UTF8W = (
            '('#1110#1085#1076#1080#1074#1110#1076#1091#1072#1083#1100#1085#1080#1081' '#1087#1086#1076#1072#1090#1082#1086#1074#1080#1081' '#1085#1086#1084#1077#1088' '#1087#1088#1086#1076#1072#1074#1094#1103')')
          ParentFont = False
          WordWrap = False
        end
        object Memo263: TfrxMemoView
          Left = 532.913730000000000000
          Top = 222.992270000000000000
          Width = 181.417440000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftTop]
          HAlign = haCenter
          Memo.UTF8W = (
            '('#1110#1085#1076#1080#1074#1110#1076#1091#1072#1083#1100#1085#1080#1081' '#1087#1086#1076#1072#1090#1082#1086#1074#1080#1081' '#1085#1086#1084#1077#1088' '#1087#1086#1082#1091#1087#1094#1103')')
          ParentFont = False
          WordWrap = False
        end
        object Memo264: TfrxMemoView
          Left = 173.858380000000000000
          Top = 366.614410000000000000
          Width = 204.094620000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftTop]
          HAlign = haCenter
          Memo.UTF8W = (
            '('#1074#1080#1076' '#1076#1086#1075#1086#1074#1086#1088#1091')')
          ParentFont = False
          WordWrap = False
        end
        object Memo265: TfrxMemoView
          Top = 377.953000000000000000
          Width = 173.858380000000000000
          Height = 15.118120000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            #1060#1086#1088#1084#1072' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1093' '#1088#1086#1079#1088#1072#1093#1091#1085#1082#1110#1074)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo266: TfrxMemoView
          Left = 173.858380000000000000
          Top = 377.953000000000000000
          Width = 495.118430000000000000
          Height = 15.118120000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            '['#1053#1053#1072#1082#1083'.'#1060#1086#1088#1084#1072#1057#1095']')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo267: TfrxMemoView
          Left = 173.858380000000000000
          Top = 393.071120000000000000
          Width = 495.118430000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftTop]
          HAlign = haCenter
          Memo.UTF8W = (
            '('#1073#1072#1088#1090#1077#1088', '#1075#1086#1090#1110#1074#1082#1072', '#1086#1087#1083#1072#1090#1072' '#1079' '#1087#1086#1090#1086#1095#1085#1086#1075#1086' '#1088#1072#1093#1091#1085#1082#1072', '#1095#1077#1082' '#1090#1086#1097#1086')')
          ParentFont = False
          WordWrap = False
        end
        object Memo268: TfrxMemoView
          Top = 408.189240000000000000
          Width = 22.677180000000000000
          Height = 86.929190000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1056#1086#1079'-'
            #1076#1110#1083)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo269: TfrxMemoView
          Left = 22.677180000000000000
          Top = 408.189240000000000000
          Width = 52.913420000000000000
          Height = 86.929190000000000000
          ShowHint = False
          AllowHTMLTags = True
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            
              #1044#1072#1090#1072' '#1074#1080#1085#1080#1082#1085#1077#1085#1085#1103' '#1087#1086#1076#1072#1090#1082#1086#1074#1086#1075#1086' '#1079#1086#1073#1086#1074#8217#1103#1079#1072#1085#1085#1103' ('#1087#1086#1089#1090#1072#1095#1072#1085#1085#1103' ('#1086#1087#1083#1072#1090#1080'<sup' +
              '>2</sup>)) ')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo270: TfrxMemoView
          Left = 75.590600000000000000
          Top = 408.189240000000000000
          Width = 173.858267720000000000
          Height = 86.929190000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1053#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072' '
            #1090#1086#1074#1072#1088#1110#1074'/'#1087#1086#1089#1083#1091#1075' '
            #1087#1088#1086#1076#1072#1074#1094#1103)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo271: TfrxMemoView
          Left = 306.141930000000000000
          Top = 408.189240000000000000
          Width = 34.015770000000000000
          Height = 86.929190000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1054#1076#1080'-'
            #1085#1080#1094#1103
            #1074#1080#1084#1110#1088#1091
            #1090#1086#1074#1072#1088#1091)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo272: TfrxMemoView
          Left = 340.157700000000000000
          Top = 408.189240000000000000
          Width = 45.354360000000000000
          Height = 86.929190000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1050#1110#1083#1100#1082#1110#1089#1090#1100' ('#1086#1073#39#1108#1084', '#1086#1073#1089#1103#1075')')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo273: TfrxMemoView
          Left = 385.512060000000000000
          Top = 408.189240000000000000
          Width = 56.692950000000000000
          Height = 86.929190000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1062#1110#1085#1072' '#1087#1086#1089#1090#1072#1095#1072#1085#1085#1103' '#1086#1076#1080#1085#1080#1094#1110' '#1090#1086#1074#1072#1088#1091'/'
            #1087#1086#1089#1083#1091#1075#1080' '#1073#1077#1079' '#1091#1088#1072#1093#1091#1074#1072#1085#1085#1103' '#1055#1044#1042)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo274: TfrxMemoView
          Left = 442.205010000000000000
          Top = 408.189240000000000000
          Width = 211.653680000000000000
          Height = 34.015770000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            
              #1054#1073#1089#1103#1075#1080' '#1087#1086#1089#1090#1072#1095#1072#1085#1085#1103' ('#1073#1072#1079#1072' '#1086#1087#1086#1076#1072#1090#1082#1091#1074#1072#1085#1085#1103') '#1073#1077#1079' '#1091#1088#1072#1093#1091#1074#1072#1085#1085#1103' '#1055#1044#1042', '#1097#1086' '#1087#1110 +
              #1076#1083#1103#1075#1072#1102#1090#1100' '#1086#1087#1086#1076#1072#1090#1082#1091#1074#1072#1085#1085#1102' '#1079#1072' '#1089#1090#1072#1074#1082#1072#1084#1080)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo275: TfrxMemoView
          Left = 442.205010000000000000
          Top = 442.205010000000000000
          Width = 52.913420000000000000
          Height = 52.913420000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1086#1089#1085#1086#1074#1085#1072
            #1089#1090#1072#1074#1082#1072)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo276: TfrxMemoView
          Left = 495.118430000000000000
          Top = 453.543600000000000000
          Width = 52.913420000000000000
          Height = 41.574830000000000000
          ShowHint = False
          CharSpacing = -0.400000000000000000
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '('#1087#1086#1089#1090#1072#1095#1072#1085#1085#1103' '#1085#1072' '#1084#1080#1090#1085#1110#1081
            ' '#1090#1077#1088#1080#1090#1086#1088#1110#1111' '#1059#1082#1088#1072#1111#1085#1080')')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo277: TfrxMemoView
          Left = 548.031850000000000000
          Top = 453.543600000000000000
          Width = 52.913385830000000000
          Height = 41.574830000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '('#1077#1082#1089#1087#1086#1088#1090')')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo278: TfrxMemoView
          Left = 600.945270000000000000
          Top = 442.205010000000000000
          Width = 52.913420000000000000
          Height = 52.913420000000000000
          ShowHint = False
          AllowHTMLTags = True
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1079#1074#1110#1083#1100#1085#1077#1085#1085#1103
            #1074#1110#1076' '#1055#1044#1042'<sup>3</sup>')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo279: TfrxMemoView
          Left = 653.858690000000000000
          Top = 408.189240000000000000
          Width = 60.472480000000000000
          Height = 86.929190000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1047#1072#1075#1072#1083#1100#1085#1072' '#1089#1091#1084#1072' '#1082#1086#1096#1090#1110#1074', '#1097#1086' '#1087#1110#1076#1083#1103#1075#1072#1108' '#1089#1087#1083#1072#1090#1110)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo280: TfrxMemoView
          Top = 495.118430000000000000
          Width = 22.677180000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '1')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo281: TfrxMemoView
          Left = 22.677180000000000000
          Top = 495.118430000000000000
          Width = 52.913420000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '2')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo282: TfrxMemoView
          Left = 75.590600000000000000
          Top = 495.118430000000000000
          Width = 173.858267720000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '3')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo283: TfrxMemoView
          Left = 306.141930000000000000
          Top = 495.118430000000000000
          Width = 34.015770000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '5')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo284: TfrxMemoView
          Left = 340.157700000000000000
          Top = 495.118430000000000000
          Width = 45.354360000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '6')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo285: TfrxMemoView
          Left = 385.512060000000000000
          Top = 495.118430000000000000
          Width = 56.692950000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '7')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo286: TfrxMemoView
          Left = 442.205010000000000000
          Top = 495.118430000000000000
          Width = 52.913420000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '8')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo287: TfrxMemoView
          Left = 495.118430000000000000
          Top = 495.118430000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '9')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo288: TfrxMemoView
          Left = 548.031850000000000000
          Top = 495.118430000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '10')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo289: TfrxMemoView
          Left = 600.945270000000000000
          Top = 495.118430000000000000
          Width = 52.913420000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '11')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo290: TfrxMemoView
          Left = 653.858690000000000000
          Top = 495.118430000000000000
          Width = 60.472480000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '12')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo291: TfrxMemoView
          Left = 102.047310000000000000
          Top = 234.330860000000000000
          Width = 249.448980000000000000
          Height = 34.015770000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            '['#1040#1082#1090#1060#1080#1088#1084#1072'.'#1070#1088#1040#1076#1088#1077#1089']')
          ParentFont = False
          VAlign = vaBottom
        end
        object Memo292: TfrxMemoView
          Left = 464.882190000000000000
          Top = 234.330860000000000000
          Width = 249.448980000000000000
          Height = 34.015770000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            '['#1050#1083#1080#1077#1085#1090'.'#1070#1088#1040#1076#1088#1077#1089']')
          ParentFont = False
          VAlign = vaBottom
        end
        object Memo293: TfrxMemoView
          Left = 185.196970000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo294: TfrxMemoView
          Left = 200.315090000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo295: TfrxMemoView
          Left = 215.433210000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo296: TfrxMemoView
          Left = 230.551330000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo297: TfrxMemoView
          Left = 245.669450000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo298: TfrxMemoView
          Left = 260.787570000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo299: TfrxMemoView
          Left = 275.905690000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo300: TfrxMemoView
          Left = 291.023810000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo301: TfrxMemoView
          Left = 306.141930000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo302: TfrxMemoView
          Left = 321.260050000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo303: TfrxMemoView
          Left = 336.378170000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo304: TfrxMemoView
          Left = 548.031850000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo305: TfrxMemoView
          Left = 563.149970000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo306: TfrxMemoView
          Left = 578.268090000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo307: TfrxMemoView
          Left = 593.386210000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo308: TfrxMemoView
          Left = 608.504330000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo309: TfrxMemoView
          Left = 623.622450000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo310: TfrxMemoView
          Left = 638.740570000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo311: TfrxMemoView
          Left = 653.858690000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo312: TfrxMemoView
          Left = 668.976810000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo313: TfrxMemoView
          Left = 684.094930000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo314: TfrxMemoView
          Left = 699.213050000000000000
          Top = 204.094620000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo315: TfrxMemoView
          Left = 45.354360000000000000
          Top = 22.677180000000000000
          Width = 117.165430000000000000
          Height = 22.677180000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8W = (
            #1047#1072#1083#1080#1096#1072#1108#1090#1100#1089#1103' '#1091' '#1087#1088#1086#1076#1072#1074#1094#1103' '
            '('#1090#1080#1087' '#1087#1088#1080#1095#1080#1085#1080')')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo316: TfrxMemoView
          Width = 45.354360000000000000
          Height = 45.354360000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8W = (
            #1054#1088#1080#1075#1110#1085#1072#1083)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo317: TfrxMemoView
          Left = 162.519790000000000000
          Top = 22.677180000000000000
          Width = 30.236240000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo318: TfrxMemoView
          Left = 162.519790000000000000
          Top = 34.015770000000000000
          Width = 30.236240000000000000
          Height = 11.338590000000000000
          ShowHint = False
          CharSpacing = 7.000000000000000000
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          GapX = 6.000000000000000000
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo319: TfrxMemoView
          Left = 177.637910000000000000
          Top = 34.015770000000000000
          Width = 15.118120000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo320: TfrxMemoView
          Top = 45.354360000000000000
          Width = 162.519790000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8W = (
            #1050#1086#1087#1110#1103' ('#1079#1072#1083#1080#1096#1072#1108#1090#1100#1089#1103' '#1091' '#1087#1088#1086#1076#1072#1074#1094#1103')')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo321: TfrxMemoView
          Left = 162.519790000000000000
          Top = 45.354360000000000000
          Width = 30.236240000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            'X')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo322: TfrxMemoView
          Left = 638.740570000000000000
          Top = 105.826840000000000000
          Width = 75.590600000000000000
          Height = 11.338590000000000000
          ShowHint = False
          AllowHTMLTags = True
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haCenter
          Memo.UTF8W = (
            '(<sup>1</sup>)   ('#1085#1086#1084#1077#1088' '#1092#1110#1083#1110#1111')')
          ParentFont = False
          WordWrap = False
        end
        object Memo323: TfrxMemoView
          Left = 517.795610000000000000
          Top = 86.929190000000000000
          Width = 105.826840000000000000
          Height = 18.897650000000000000
          ShowHint = False
          CharSpacing = 7.000000000000000000
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          GapX = 4.000000000000000000
          HAlign = haRight
          HideZeros = True
          Memo.UTF8W = (
            
              '[IIF((Pos("/",<'#1044#1086#1082#1091#1084'.'#1053#1086#1084#1077#1088'>) > 0),Copy(<'#1044#1086#1082#1091#1084'.'#1053#1086#1084#1077#1088'>,1,Pos("/",<' +
              #1044#1086#1082#1091#1084'.'#1053#1086#1084#1077#1088'>)-1),<'#1044#1086#1082#1091#1084'.'#1053#1086#1084#1077#1088'>) ]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo324: TfrxMemoView
          Left = 532.913730000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo325: TfrxMemoView
          Left = 548.031850000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo326: TfrxMemoView
          Left = 563.149970000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo327: TfrxMemoView
          Left = 578.268090000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo328: TfrxMemoView
          Left = 593.386210000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo329: TfrxMemoView
          Left = 608.504330000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo330: TfrxMemoView
          Left = 653.858690000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo331: TfrxMemoView
          Left = 668.976810000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo332: TfrxMemoView
          Left = 684.094930000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo333: TfrxMemoView
          Left = 623.622450000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          CharSpacing = 7.000000000000000000
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          GapX = 4.000000000000000000
          HideZeros = True
          Memo.UTF8W = (
            '/')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo334: TfrxMemoView
          Left = 200.315090000000000000
          Top = 86.929190000000000000
          Width = 120.944960000000000000
          Height = 18.897650000000000000
          ShowHint = False
          CharSpacing = 7.000000000000000000
          DisplayFormat.FormatStr = 'ddmmyyyy'
          DisplayFormat.Kind = fkDateTime
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          GapX = 4.000000000000000000
          HideZeros = True
          Memo.UTF8W = (
            '['#1044#1086#1082#1091#1084'.'#1044#1072#1090#1072'.'#1062#1080#1092#1088#1072#1084#1080']')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo335: TfrxMemoView
          Left = 245.669450000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo336: TfrxMemoView
          Left = 260.787570000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo337: TfrxMemoView
          Left = 275.905690000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo338: TfrxMemoView
          Left = 291.023810000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo339: TfrxMemoView
          Left = 306.141930000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo340: TfrxMemoView
          Left = 200.315090000000000000
          Top = 275.905690000000000000
          Width = 151.181200000000000000
          Height = 18.897650000000000000
          ShowHint = False
          CharSpacing = 7.000000000000000000
          DisplayFormat.FormatStr = 'dd.mm.yy'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          GapX = 4.000000000000000000
          HAlign = haRight
          HideZeros = True
          Memo.UTF8W = (
            
              '[IIF((Length(FilterPhone(<'#1040#1082#1090#1060#1080#1088#1084#1072'.'#1058#1077#1083'>)) > 10),Copy(FilterPhone' +
              '(<'#1040#1082#1090#1060#1080#1088#1084#1072'.'#1058#1077#1083'>),Length(FilterPhone(<'#1040#1082#1090#1060#1080#1088#1084#1072'.'#1058#1077#1083'>))-9,10),Filte' +
              'rPhone(<'#1040#1082#1090#1060#1080#1088#1084#1072'.'#1058#1077#1083'>))]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo341: TfrxMemoView
          Left = 215.433210000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo342: TfrxMemoView
          Left = 230.551330000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo343: TfrxMemoView
          Left = 245.669450000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo344: TfrxMemoView
          Left = 260.787570000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo345: TfrxMemoView
          Left = 275.905690000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo346: TfrxMemoView
          Left = 291.023810000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo347: TfrxMemoView
          Left = 306.141930000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo348: TfrxMemoView
          Left = 321.260050000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo349: TfrxMemoView
          Left = 336.378170000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo350: TfrxMemoView
          Left = 563.149970000000000000
          Top = 275.905690000000000000
          Width = 151.181200000000000000
          Height = 18.897650000000000000
          ShowHint = False
          CharSpacing = 7.000000000000000000
          DisplayFormat.FormatStr = 'dd.mm.yy'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          GapX = 4.000000000000000000
          HAlign = haRight
          HideZeros = True
          Memo.UTF8W = (
            
              '[IIF((Length(FilterPhone(<'#1050#1083#1080#1077#1085#1090'.'#1058#1077#1083'>)) > 10),Copy(FilterPhone(<' +
              #1050#1083#1080#1077#1085#1090'.'#1058#1077#1083'>),Length(FilterPhone(<'#1050#1083#1080#1077#1085#1090'.'#1058#1077#1083'>))-9,10),FilterPhone' +
              '(<'#1050#1083#1080#1077#1085#1090'.'#1058#1077#1083'>))]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo351: TfrxMemoView
          Left = 578.268090000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo352: TfrxMemoView
          Left = 593.386210000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo353: TfrxMemoView
          Left = 608.504330000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo354: TfrxMemoView
          Left = 623.622450000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo355: TfrxMemoView
          Left = 638.740570000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo356: TfrxMemoView
          Left = 653.858690000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo357: TfrxMemoView
          Left = 668.976810000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo358: TfrxMemoView
          Left = 684.094930000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo359: TfrxMemoView
          Left = 699.213050000000000000
          Top = 275.905690000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo360: TfrxMemoView
          Left = 200.315090000000000000
          Top = 313.700990000000000000
          Width = 151.181200000000000000
          Height = 18.897650000000000000
          ShowHint = False
          CharSpacing = 7.000000000000000000
          DisplayFormat.FormatStr = 'dd.mm.yy'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          GapX = 4.000000000000000000
          HAlign = haRight
          HideZeros = True
          Memo.UTF8W = (
            '['#1040#1082#1090#1060#1080#1088#1084#1072'.'#1057#1074#1080#1076']')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo361: TfrxMemoView
          Left = 215.433210000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo362: TfrxMemoView
          Left = 230.551330000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo363: TfrxMemoView
          Left = 245.669450000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo364: TfrxMemoView
          Left = 260.787570000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo365: TfrxMemoView
          Left = 275.905690000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo366: TfrxMemoView
          Left = 291.023810000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo367: TfrxMemoView
          Left = 306.141930000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo368: TfrxMemoView
          Left = 321.260050000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo369: TfrxMemoView
          Left = 336.378170000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo370: TfrxMemoView
          Left = 563.149970000000000000
          Top = 313.700990000000000000
          Width = 151.181200000000000000
          Height = 18.897650000000000000
          ShowHint = False
          CharSpacing = 7.000000000000000000
          DisplayFormat.FormatStr = 'dd.mm.yy'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          GapX = 4.000000000000000000
          HAlign = haRight
          HideZeros = True
          Memo.UTF8W = (
            '[IIF(Length(Trim(<'#1050#1083#1080#1077#1085#1090'.'#1057#1074#1080#1076'>)) == 0,"0",<'#1050#1083#1080#1077#1085#1090'.'#1057#1074#1080#1076'>)]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo371: TfrxMemoView
          Left = 578.268090000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo372: TfrxMemoView
          Left = 593.386210000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo373: TfrxMemoView
          Left = 608.504330000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo374: TfrxMemoView
          Left = 623.622450000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo375: TfrxMemoView
          Left = 638.740570000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo376: TfrxMemoView
          Left = 653.858690000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo377: TfrxMemoView
          Left = 668.976810000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo378: TfrxMemoView
          Left = 684.094930000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo379: TfrxMemoView
          Left = 699.213050000000000000
          Top = 313.700990000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo380: TfrxMemoView
          Left = 396.850650000000000000
          Top = 347.716760000000000000
          Width = 120.944960000000000000
          Height = 18.897650000000000000
          ShowHint = False
          CharSpacing = 7.000000000000000000
          DisplayFormat.FormatStr = 'ddmmyyyy'
          DisplayFormat.Kind = fkDateTime
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          GapX = 4.000000000000000000
          HideZeros = True
          Memo.UTF8W = (
            '[PodDogDate2]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo381: TfrxMemoView
          Left = 442.205010000000000000
          Top = 347.716760000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo382: TfrxMemoView
          Left = 457.323130000000000000
          Top = 347.716760000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo383: TfrxMemoView
          Left = 472.441250000000000000
          Top = 347.716760000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo384: TfrxMemoView
          Left = 487.559370000000000000
          Top = 347.716760000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo385: TfrxMemoView
          Left = 502.677490000000000000
          Top = 347.716760000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo386: TfrxMemoView
          Left = 517.795610000000000000
          Top = 347.716760000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          CharSpacing = 7.000000000000000000
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          GapX = 4.000000000000000000
          HideZeros = True
          Memo.UTF8W = (
            #8470)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo387: TfrxMemoView
          Left = 532.913730000000000000
          Top = 347.716760000000000000
          Width = 181.417440000000000000
          Height = 18.897650000000000000
          ShowHint = False
          CharSpacing = 2.000000000000000000
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          GapX = 4.000000000000000000
          HAlign = haRight
          HideZeros = True
          Memo.UTF8W = (
            '[PodDog3]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo393: TfrxMemoView
          Left = 377.953000000000000000
          Top = 351.496290000000000000
          Width = 18.897650000000000000
          Height = 15.118120000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haCenter
          Memo.UTF8W = (
            #1074#1110#1076)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo394: TfrxMemoView
          Left = 411.968770000000000000
          Top = 347.716760000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo395: TfrxMemoView
          Left = 427.086890000000000000
          Top = 347.716760000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo396: TfrxMemoView
          Left = 215.433210000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo397: TfrxMemoView
          Left = 230.551330000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          HideZeros = True
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo398: TfrxMemoView
          Left = 170.078850000000000000
          Top = 204.094620000000000000
          Width = 181.417440000000000000
          Height = 18.897650000000000000
          ShowHint = False
          CharSpacing = 7.000000000000000000
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          GapX = 4.000000000000000000
          HAlign = haRight
          HideZeros = True
          Memo.UTF8W = (
            '['#1040#1082#1090#1060#1080#1088#1084#1072'.'#1048#1055#1053']')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo399: TfrxMemoView
          Left = 532.913730000000000000
          Top = 204.094620000000000000
          Width = 181.417440000000000000
          Height = 18.897650000000000000
          ShowHint = False
          CharSpacing = 7.000000000000000000
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          GapX = 4.000000000000000000
          HAlign = haRight
          HideZeros = True
          Memo.UTF8W = (
            '[IIF(Length(Trim(<'#1050#1083#1080#1077#1085#1090'.'#1048#1055#1053'>)) == 0,"0",<'#1050#1083#1080#1077#1085#1090'.'#1048#1055#1053'>)]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo405: TfrxMemoView
          Left = 638.740570000000000000
          Top = 86.929190000000000000
          Width = 15.118120000000000000
          Height = 18.897650000000000000
          ShowHint = False
          CharSpacing = 7.000000000000000000
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          GapX = 4.000000000000000000
          HideZeros = True
          Memo.UTF8W = (
            
              '[IIF((Pos("/",<'#1044#1086#1082#1091#1084'.'#1053#1086#1084#1077#1088'>) > 0),Copy(<'#1044#1086#1082#1091#1084'.'#1053#1086#1084#1077#1088'>,Pos("/",<'#1044#1086 +
              #1082#1091#1084'.'#1053#1086#1084#1077#1088'>)+1,100),"") ]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo406: TfrxMemoView
          Left = 495.118430000000000000
          Top = 442.205010000000000000
          Width = 105.826840000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1085#1091#1083#1100#1086#1074#1072' '#1089#1090#1072#1074#1082#1072)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo407: TfrxMemoView
          Left = 249.448980000000000000
          Top = 408.189240000000000000
          Width = 56.692950000000000000
          Height = 86.929190000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1050#1086#1076' '#1090#1086#1074#1072#1088#1091' '#1079#1075#1110#1076#1085#1086' '#1079' '#1059#1050#1058' '#1047#1045#1044)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo408: TfrxMemoView
          Left = 249.448980000000000000
          Top = 495.118430000000000000
          Width = 56.692913390000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '4')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo474: TfrxMemoView
          Left = 653.858690000000000000
          Top = 86.929190000000000000
          Width = 60.472480000000000000
          Height = 18.897650000000000000
          ShowHint = False
          CharSpacing = 7.000000000000000000
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          GapX = 4.000000000000000000
          HAlign = haRight
          HideZeros = True
          Memo.UTF8W = (
            '['#1040#1082#1090#1060#1080#1088#1084#1072'.'#1050#1086#1076#1060#1080#1083#1080#1080']')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
      end
      object MasterData1: TfrxMasterData
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Height = 11.338590000000000000
        ParentFont = False
        Top = 548.031850000000000000
        Width = 714.331170000000000000
        Columns = 1
        ColumnWidth = 200.000000000000000000
        ColumnGap = 20.000000000000000000
        DataSetName = 'DataRep'
        RowCount = 0
        Stretched = True
        object Memo409: TfrxMemoView
          Width = 22.677180000000000000
          Height = 11.338590000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight]
          HAlign = haCenter
          Memo.UTF8W = (
            'I')
          ParentFont = False
          SuppressRepeated = True
          VAlign = vaCenter
        end
        object Memo410: TfrxMemoView
          Left = 22.677180000000000000
          Width = 52.913420000000000000
          Height = 11.338590000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.FormatStr = 'ddmmyyyy'
          DisplayFormat.Kind = fkDateTime
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '['#1053#1053#1072#1082#1083'.'#1044#1072#1090#1072#1054#1090#1075#1088#1091#1079#1082#1080']')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo411: TfrxMemoView
          Left = 75.590600000000000000
          Width = 173.858380000000000000
          Height = 11.338590000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8W = (
            '['#1058#1086#1074#1072#1088'.'#1053#1072#1079#1074']')
          ParentFont = False
        end
        object Memo412: TfrxMemoView
          Left = 306.141930000000000000
          Width = 34.015770000000000000
          Height = 11.338590000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '[IIF(<'#1058#1086#1074#1072#1088'.'#1045#1089#1083#1080#1059#1089#1083#1091#1075#1072'> > 0,"'#1075#1088#1085'.",<'#1058#1086#1074#1072#1088'.'#1045#1076#1048#1079#1084'>)]')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo413: TfrxMemoView
          Left = 340.157700000000000000
          Width = 45.354330710000000000
          Height = 11.338590000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            
              '[IIF(<'#1058#1086#1074#1072#1088'.'#1045#1089#1083#1080#1059#1089#1083#1091#1075#1072'> > 0,IIF(<'#1058#1086#1074#1072#1088'.'#1050#1086#1083#1074#1086'> == 1,"'#1087#1086#1089#1083#1091#1075#1072'",<'#1058#1086 +
              #1074#1072#1088'.'#1050#1086#1083#1074#1086'> + " / '#1087#1086#1089#1083#1091#1075#1072'"),<'#1058#1086#1074#1072#1088'.'#1050#1086#1083#1074#1086'>)]')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo414: TfrxMemoView
          Left = 385.512060000000000000
          Width = 56.692950000000000000
          Height = 11.338590000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            '['#1058#1086#1074#1072#1088'.'#1057#1082#1080#1076#1082#1072#1053#1072#1076#1073#1072#1074#1082#1072'.'#1062#1077#1085#1072']')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo415: TfrxMemoView
          Left = 442.205010000000000000
          Width = 52.913420000000000000
          Height = 11.338590000000000000
          OnAfterData = 'OnFillEmpty'
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            
              '[IIF(  ((<'#1053#1044#1057'.'#1058#1080#1087'> == 0) && ((<'#1058#1086#1074#1072#1088'.'#1058#1080#1087#1053#1044#1057'> == -1) || (<'#1058#1086#1074#1072#1088'.'#1058 +
              #1080#1087#1053#1044#1057'> == 0))),<'#1058#1086#1074#1072#1088'.'#1057#1091#1084#1084#1072'.'#1057#1082#1080#1076#1082#1072#1053#1072#1076#1073#1072#1074#1082#1072'.'#1041#1077#1079#1053#1044#1057'>,0 )]')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo416: TfrxMemoView
          Left = 495.118430000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          OnAfterData = 'OnFillEmpty'
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            
              '[IIF(  (((<'#1053#1044#1057'.'#1058#1080#1087'> == 1) && ((<'#1058#1086#1074#1072#1088'.'#1058#1080#1087#1053#1044#1057'> == -1) || (<'#1058#1086#1074#1072#1088'.' +
              #1058#1080#1087#1053#1044#1057'> == 0))) || (<'#1058#1086#1074#1072#1088'.'#1058#1080#1087#1053#1044#1057'> == 1)),<'#1058#1086#1074#1072#1088'.'#1057#1091#1084#1084#1072'.'#1057#1082#1080#1076#1082#1072#1053#1072#1076 +
              #1073#1072#1074#1082#1072'.'#1041#1077#1079#1053#1044#1057'>,0 )]')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo417: TfrxMemoView
          Left = 548.031850000000000000
          Width = 52.913420000000000000
          Height = 11.338590000000000000
          OnAfterData = 'OnFillEmpty'
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            
              '[IIF( (((<'#1053#1044#1057'.'#1058#1080#1087'> == 2) && ((<'#1058#1086#1074#1072#1088'.'#1058#1080#1087#1053#1044#1057'> == -1) || (<'#1058#1086#1074#1072#1088'.'#1058 +
              #1080#1087#1053#1044#1057'> == 0))) || (<'#1058#1086#1074#1072#1088'.'#1058#1080#1087#1053#1044#1057'> == 2)),<'#1058#1086#1074#1072#1088'.'#1057#1091#1084#1084#1072'.'#1057#1082#1080#1076#1082#1072#1053#1072#1076#1073 +
              #1072#1074#1082#1072'.'#1041#1077#1079#1053#1044#1057'>,0 )]')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo418: TfrxMemoView
          Left = 600.945270000000000000
          Width = 52.913420000000000000
          Height = 11.338590000000000000
          OnAfterData = 'OnFillEmpty'
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            
              '[IIF( (((<'#1053#1044#1057'.'#1058#1080#1087'> == 3) && ((<'#1058#1086#1074#1072#1088'.'#1058#1080#1087#1053#1044#1057'> == -1) || (<'#1058#1086#1074#1072#1088'.'#1058 +
              #1080#1087#1053#1044#1057'> == 0))) || (<'#1058#1086#1074#1072#1088'.'#1058#1080#1087#1053#1044#1057'> == 3)),<'#1058#1086#1074#1072#1088'.'#1057#1091#1084#1084#1072'.'#1057#1082#1080#1076#1082#1072#1053#1072#1076#1073 +
              #1072#1074#1082#1072'.'#1041#1077#1079#1053#1044#1057'>,0 )]')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo419: TfrxMemoView
          Left = 653.858690000000000000
          Width = 60.472480000000000000
          Height = 11.338590000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight]
          HAlign = haCenter
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo420: TfrxMemoView
          Left = 249.448980000000000000
          Width = 56.692913390000000000
          Height = 11.338590000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          CharSpacing = -0.100000000000000000
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '['#1058#1086#1074#1072#1088'.'#1050#1086#1076'.'#1059#1050#1058'_'#1047#1045#1044']')
          ParentFont = False
          VAlign = vaCenter
        end
      end
      object Footer1: TfrxFooter
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Height = 300.000000000000000000
        ParentFont = False
        Top = 582.047620000000000000
        Width = 714.331170000000000000
        AllowSplit = True
        object Memo421: TfrxMemoView
          Left = 22.677180000000000000
          Width = 226.771800000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1059#1089#1100#1086#1075#1086' '#1087#1086' '#1088#1086#1079#1076#1110#1083#1091' '#1030)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo422: TfrxMemoView
          Left = 306.141930000000000000
          Width = 34.015770000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo423: TfrxMemoView
          Left = 340.157700000000000000
          Width = 45.354330710000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo424: TfrxMemoView
          Left = 385.512060000000000000
          Width = 56.692913390000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo425: TfrxMemoView
          Left = 442.205010000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          OnAfterData = 'OnFillEmptyNull'
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          HideZeros = True
          Memo.UTF8W = (
            
              '[FormatFloat(<'#1092#1086#1088#1084#1072#1090'_'#1089#1091#1084#1084#1072'_'#1090#1072#1073#1083'>,SUM(StrToFloat(Memo415.Value)))' +
              ']')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo426: TfrxMemoView
          Left = 495.118430000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          OnAfterData = 'OnFillEmptyNull'
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          HideZeros = True
          Memo.UTF8W = (
            
              '[FormatFloat(<'#1092#1086#1088#1084#1072#1090'_'#1089#1091#1084#1084#1072'_'#1090#1072#1073#1083'>,SUM(StrToFloat(Memo416.Value)))' +
              ']')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo427: TfrxMemoView
          Left = 548.031850000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          OnAfterData = 'OnFillEmptyNull'
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          HideZeros = True
          Memo.UTF8W = (
            
              '[FormatFloat(<'#1092#1086#1088#1084#1072#1090'_'#1089#1091#1084#1084#1072'_'#1090#1072#1073#1083'>,SUM(StrToFloat(Memo417.Value)))' +
              ']')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo428: TfrxMemoView
          Left = 600.945270000000000000
          Width = 52.913420000000000000
          Height = 11.338590000000000000
          OnAfterData = 'OnFillEmptyNull'
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          HideZeros = True
          Memo.UTF8W = (
            
              '[FormatFloat(<'#1092#1086#1088#1084#1072#1090'_'#1089#1091#1084#1084#1072'_'#1090#1072#1073#1083'>,SUM(StrToFloat(Memo418.Value)))' +
              ']')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo429: TfrxMemoView
          Left = 653.858690000000000000
          Width = 60.472480000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight]
          HAlign = haRight
          Memo.UTF8W = (
            
              '[FormatFloat(<'#1092#1086#1088#1084#1072#1090'_'#1089#1091#1084#1084#1072'_'#1090#1072#1073#1083'>,StrToFloat(Memo425.Value)+StrTo' +
              'Float(Memo426.Value)+StrToFloat(Memo427.Value)+StrToFloat(Memo42' +
              '8.Value))]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo430: TfrxMemoView
          Width = 22.677180000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftBottom]
          HAlign = haCenter
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo431: TfrxMemoView
          Left = 22.677180000000000000
          Top = 11.338590000000000000
          Width = 226.771653543307000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1047#1074#1086#1088#1086#1090#1085#1072' ('#1079#1072#1089#1090#1072#1074#1085#1072') '#1090#1072#1088#1072)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo432: TfrxMemoView
          Left = 306.141930000000000000
          Top = 11.338590000000000000
          Width = 34.015770000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo433: TfrxMemoView
          Left = 340.157700000000000000
          Top = 11.338590000000000000
          Width = 45.354330710000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo434: TfrxMemoView
          Left = 385.512060000000000000
          Top = 11.338590000000000000
          Width = 56.692913390000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo435: TfrxMemoView
          Left = 442.205010000000000000
          Top = 11.338590000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo436: TfrxMemoView
          Left = 495.118430000000000000
          Top = 11.338590000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo437: TfrxMemoView
          Left = 548.031850000000000000
          Top = 11.338590000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo438: TfrxMemoView
          Left = 600.945270000000000000
          Top = 11.338590000000000000
          Width = 52.913420000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo439: TfrxMemoView
          Left = 653.858690000000000000
          Top = 11.338590000000000000
          Width = 60.472480000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo440: TfrxMemoView
          Top = 11.338590000000000000
          Width = 22.677180000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1030#1030)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo441: TfrxMemoView
          Top = 22.677180000000000000
          Width = 22.677180000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1030#1030#1030)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo442: TfrxMemoView
          Top = 34.015770000000000000
          Width = 22.677180000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            'IV')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo443: TfrxMemoView
          Top = 52.913420000000000000
          Width = 714.331170000000000000
          Height = 26.456710000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            
              #1057#1091#1084#1080' '#1055#1044#1042', '#1085#1072#1088#1072#1093#1086#1074#1072#1085#1110' ('#1089#1087#1083#1072#1095#1077#1085#1110') '#1074' '#1079#1074#39#1103#1079#1082#1091' '#1079' '#1087#1086#1089#1090#1072#1095#1072#1085#1085#1103#1084' '#1090#1086#1074#1072#1088#1110#1074'/' +
              #1087#1086#1089#1083#1091#1075', '#1079#1072#1079#1085#1072#1095#1077#1085#1080#1093' '#1091' '#1094#1110#1081' '#1085#1072#1082#1083#1072#1076#1085#1110#1081', '#1074#1080#1079#1085#1072#1095#1077#1085#1110' '#1087#1088#1072#1074#1080#1083#1100#1085#1086', '#1074#1110#1076#1087#1086#1074#1110 +
              #1076#1072#1102#1090#1100' '#1089#1091#1084#1110' '#1087#1086#1076#1072#1090#1082#1086#1074#1080#1093' '#1079#1086#1073#1086#1074#39#1103#1079#1072#1085#1100' '#1087#1088#1086#1076#1072#1074#1094#1103' '#1110' '#1074#1082#1083#1102#1095#1077#1085#1110' '#1076#1086' '#1088#1077#1108#1089#1090#1088#1091 +
              ' '#1074#1080#1076#1072#1085#1080#1093' '#1090#1072' '#1086#1090#1088#1080#1084#1072#1085#1080#1093' '#1087#1086#1076#1072#1090#1082#1086#1074#1080#1093' '#1085#1072#1082#1083#1072#1076#1085#1080#1093'.')
          ParentFont = False
        end
        object Memo444: TfrxMemoView
          Left = 449.764070000000000000
          Top = 120.944960000000000000
          Width = 264.567100000000000000
          Height = 15.118120000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            '['#1040#1082#1090#1060#1080#1088#1084#1072'.'#1041#1091#1093#1075#1072#1083#1090#1077#1088']')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo445: TfrxMemoView
          Left = 449.764070000000000000
          Top = 136.063080000000000000
          Width = 264.567100000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftTop]
          HAlign = haCenter
          Memo.UTF8W = (
            '('#1087#1110#1076#1087#1080#1089' '#1110' '#1087#1088#1110#1079#1074#1080#1097#1077' '#1086#1089#1086#1073#1080', '#1103#1082#1072' '#1089#1082#1083#1072#1083#1072' '#1087#1086#1076#1072#1090#1082#1086#1074#1091' '#1085#1072#1082#1083#1072#1076#1085#1091')')
          ParentFont = False
          WordWrap = False
        end
        object Memo446: TfrxMemoView
          Left = 49.133890000000000000
          Top = 105.826840000000000000
          Width = 60.472480000000000000
          Height = 49.133890000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1052'.'#1055'.')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo447: TfrxMemoView
          Top = 181.417440000000000000
          Width = 714.331170000000000000
          Height = 45.354360000000000000
          ShowHint = False
          AllowHTMLTags = True
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Arial'
          Font.Style = [fsItalic]
          Memo.UTF8W = (
            
              '<sup>1</sup> '#1047#1072#1079#1085#1072#1095#1072#1108#1090#1100#1089#1103' '#1082#1086#1076' '#1074#1080#1076#1091' '#1076#1110#1103#1083#1100#1085#1086#1089#1090#1110', '#1097#1086' '#1087#1077#1088#1077#1076#1073#1072#1095#1072#1108' '#1089#1087#1077 +
              #1094#1110#1072#1083#1100#1085#1080#1081' '#1088#1077#1078#1080#1084' '#1086#1087#1086#1076#1072#1090#1082#1091#1074#1072#1085#1085#1103' (2, '#1072#1073#1086' 3, '#1072#1073#1086' 4), '#1091' '#1088#1072#1079#1110' '#1089#1082#1083#1072#1076#1072#1085#1085#1103 +
              ' '#1087#1086#1076#1072#1090#1082#1086#1074#1086#1111' '#1085#1072#1082#1083#1072#1076#1085#1086#1111' '#1079#1072' '#1090#1072#1082#1086#1102' '#1076#1110#1103#1083#1100#1085#1110#1089#1090#1102'.'
            
              '<sup>2</sup> '#1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1080' '#1089#1090#1072#1074#1080#1090#1100#1089#1103' '#1091' '#1088#1072#1079#1110' '#1087#1086#1087#1077#1088#1077#1076#1085#1100#1086#1111' '#1086#1087#1083#1072#1090#1080' '#1087#1086#1089 +
              #1090#1072#1095#1072#1085#1085#1103', '#1085#1072' '#1103#1082#1091' '#1074#1080#1087#1080#1089#1091#1108#1090#1100#1089#1103' '#1087#1086#1076#1072#1090#1082#1086#1074#1072' '#1085#1072#1082#1083#1072#1076#1085#1072', '#1076#1083#1103' '#1086#1087#1077#1088#1072#1094#1110#1081' '#1079' '#1087 +
              #1086#1089#1090#1072#1095#1072#1085#1085#1103' '#1090#1086#1074#1072#1088#1110#1074'/'#1087#1086#1089#1083#1091#1075'  '#1074#1110#1076#1087#1086#1074#1110#1076#1085#1086' '#1076#1086' '#1087#1091#1085#1082#1090#1091' 187.10 '#1089#1090#1072#1090#1090#1110' 187' +
              ' '#1088#1086#1079#1076#1110#1083#1091' V '#1055#1086#1076#1072#1090#1082#1086#1074#1086#1075#1086' '#1082#1086#1076#1077#1082#1089#1091' '#1059#1082#1088#1072#1111#1085#1080'.'
            '<sup>3</sup>')
          ParentFont = False
        end
        object Memo448: TfrxMemoView
          Left = 22.677180000000000000
          Top = 22.677180000000000000
          Width = 226.771653543307000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1055#1086#1076#1072#1090#1086#1082' '#1085#1072' '#1076#1086#1076#1072#1085#1091' '#1074#1072#1088#1090#1110#1089#1090#1100)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo449: TfrxMemoView
          Left = 306.141930000000000000
          Top = 22.677180000000000000
          Width = 34.015770000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo450: TfrxMemoView
          Left = 340.157700000000000000
          Top = 22.677180000000000000
          Width = 45.354330710000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo451: TfrxMemoView
          Left = 385.512060000000000000
          Top = 22.677180000000000000
          Width = 56.692913390000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo452: TfrxMemoView
          Left = 442.205010000000000000
          Top = 22.677180000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          OnAfterData = 'OnFillEmptyNull'
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            '['#1053#1044#1057'.'#1062#1080#1092#1088#1072#1084#1080']')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo453: TfrxMemoView
          Left = 495.118430000000000000
          Top = 22.677180000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            '[IIF((SUM(StrToFloat(Memo416.Value)) > 0),"0,00","")]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo454: TfrxMemoView
          Left = 548.031850000000000000
          Top = 22.677180000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            '[IIF((SUM(StrToFloat(Memo417.Value)) > 0),"0,00","")]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo455: TfrxMemoView
          Left = 600.945270000000000000
          Top = 22.677180000000000000
          Width = 52.913420000000000000
          Height = 11.338590000000000000
          OnAfterData = 'OnFillEmptyNull'
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            
              '[IIF( (((<'#1053#1044#1057'.'#1058#1080#1087'> == 3) && ((<'#1058#1086#1074#1072#1088'.'#1058#1080#1087#1053#1044#1057'> == -1) || (<'#1058#1086#1074#1072#1088'.'#1058 +
              #1080#1087#1053#1044#1057'> == 0))) || (<'#1058#1086#1074#1072#1088'.'#1058#1080#1087#1053#1044#1057'> == 3)),"'#1041#1077#1079' '#1055#1044#1042'","" )]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo456: TfrxMemoView
          Left = 653.858690000000000000
          Top = 22.677180000000000000
          Width = 60.472480000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            '['#1053#1044#1057'.'#1062#1080#1092#1088#1072#1084#1080']')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo457: TfrxMemoView
          Left = 22.677180000000000000
          Top = 34.015770000000000000
          Width = 226.771653543307000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1047#1072#1075#1072#1083#1100#1085#1072' '#1089#1091#1084#1072' '#1079' '#1055#1044#1042)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo458: TfrxMemoView
          Left = 306.141930000000000000
          Top = 34.015770000000000000
          Width = 34.015770000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo459: TfrxMemoView
          Left = 340.157700000000000000
          Top = 34.015770000000000000
          Width = 45.354330710000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo460: TfrxMemoView
          Left = 385.512060000000000000
          Top = 34.015770000000000000
          Width = 56.692913390000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo461: TfrxMemoView
          Left = 442.205010000000000000
          Top = 34.015770000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          OnAfterData = 'OnFillEmptyNull'
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            
              '[IIF(StrToFloat(Memo425.Value)+StrToFloat(Memo452.Value) > 0,For' +
              'matFloat(<'#1092#1086#1088#1084#1072#1090'_'#1089#1091#1084#1084#1072'_'#1090#1072#1073#1083'>,StrToFloat(Memo425.Value)+StrToFloa' +
              't(Memo452.Value) ),0)]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo462: TfrxMemoView
          Left = 495.118430000000000000
          Top = 34.015770000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          OnAfterData = 'OnFillEmptyNull'
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            
              '[IIF(StrToFloat(Memo426.Value) > 0,FormatFloat(<'#1092#1086#1088#1084#1072#1090'_'#1089#1091#1084#1084#1072'_'#1090#1072#1073 +
              #1083'>,StrToFloat(Memo426.Value) ),0)]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo463: TfrxMemoView
          Left = 548.031850000000000000
          Top = 34.015770000000000000
          Width = 52.913385830000000000
          Height = 11.338590000000000000
          OnAfterData = 'OnFillEmptyNull'
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            
              '[IIF(StrToFloat(Memo427.Value) > 0,FormatFloat(<'#1092#1086#1088#1084#1072#1090'_'#1089#1091#1084#1084#1072'_'#1090#1072#1073 +
              #1083'>,StrToFloat(Memo427.Value) ),0)]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo464: TfrxMemoView
          Left = 600.945270000000000000
          Top = 34.015770000000000000
          Width = 52.913420000000000000
          Height = 11.338590000000000000
          OnAfterData = 'OnFillEmptyNull'
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            
              '[IIF(StrToFloat(Memo428.Value) > 0,FormatFloat(<'#1092#1086#1088#1084#1072#1090'_'#1089#1091#1084#1084#1072'_'#1090#1072#1073 +
              #1083'>,StrToFloat(Memo428.Value) ),0)]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo465: TfrxMemoView
          Left = 653.858690000000000000
          Top = 34.015770000000000000
          Width = 60.472480000000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haRight
          Memo.UTF8W = (
            
              '[FormatFloat(<'#1092#1086#1088#1084#1072#1090'_'#1089#1091#1084#1084#1072'_'#1090#1072#1073#1083'>,StrToFloat(Memo461.Value)+StrTo' +
              'Float(Memo462.Value)+StrToFloat(Memo463.Value)+StrToFloat(Memo46' +
              '4.Value))]')
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo466: TfrxMemoView
          Top = 162.519790000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
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
        object Memo467: TfrxMemoView
          Left = 7.559060000000000000
          Top = 211.653680000000000000
          Width = 544.252320000000000000
          Height = 15.118120000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            '['#1053#1053#1072#1082#1083'.'#1057#1090#1072#1090#1100#1080#1054#1090#1053#1044#1057']')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo468: TfrxMemoView
          Left = 249.448980000000000000
          Width = 56.692913390000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo469: TfrxMemoView
          Left = 249.448980000000000000
          Top = 11.338590000000000000
          Width = 56.692913390000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo470: TfrxMemoView
          Left = 249.448980000000000000
          Top = 22.677180000000000000
          Width = 56.692913390000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo471: TfrxMemoView
          Left = 249.448980000000000000
          Top = 34.015770000000000000
          Width = 56.692913390000000000
          Height = 11.338590000000000000
          ShowHint = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8W = (
            #1061)
          ParentFont = False
          WordWrap = False
          VAlign = vaCenter
        end
        object Memo472: TfrxMemoView
          Left = 7.559060000000000000
          Top = 226.771800000000000000
          Width = 544.252320000000000000
          Height = 15.118120000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -8
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftTop]
          Memo.UTF8W = (
            
              '('#1074#1110#1076#1087#1086#1074#1110#1076#1085#1110' '#1087#1091#1085#1082#1090#1080' ('#1087#1110#1076#1087#1091#1085#1082#1090#1080'), '#1089#1090#1072#1090#1090#1110', '#1087#1110#1076#1088#1086#1079#1076#1110#1083#1080', '#1088#1086#1079#1076#1110#1083#1080'  '#1055#1086#1076 +
              #1072#1090#1082#1086#1074#1086#1075#1086' '#1082#1086#1076#1077#1082#1089#1091' '#1059#1082#1088#1072#1111#1085#1080', '#1103#1082#1080#1084#1080' '#1087#1077#1088#1077#1076#1073#1072#1095#1077#1085#1086' '#1079#1074#1110#1083#1100#1085#1077#1085#1085#1103' '#1074#1110#1076' '#1086#1087#1086#1076#1072 +
              #1090#1082#1091#1074#1072#1085#1085#1103')')
          ParentFont = False
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
