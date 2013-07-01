object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 350
  ClientWidth = 657
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object dxBarManager: TdxBarManager
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
          ItemName = 'bbDocuments'
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
    object bbDocuments: TdxBarSubItem
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbIncome'
        end>
    end
    object bbGuides: TdxBarSubItem
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbBank'
        end
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
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbPaidKind'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbContractKind'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
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
          ItemName = 'bbUnitGroup'
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
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbGoodsProperty'
        end>
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
    object bbPartner: TdxBarButton
      Action = actPartner
      Category = 0
    end
    object dxBarSeparator1: TdxBarSeparator
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
    object bbPaidKind: TdxBarButton
      Action = actPaidKind
      Category = 0
    end
    object bbContractKind: TdxBarButton
      Action = actContractKind
      Category = 0
    end
    object bbUnitGroup: TdxBarButton
      Action = actUnitGroup
      Category = 0
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
    object bbBalance: TdxBarButton
      Action = actBalance
      Category = 0
    end
    object bbReports: TdxBarSubItem
      Caption = #1054#1090#1095#1077#1090#1099
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbBalance'
        end>
    end
    object bbBank: TdxBarButton
      Action = actBank
      Category = 0
    end
  end
  object ActionList: TActionList
    Left = 192
    Top = 48
    object actExit: TFileExit
      Category = #1055#1088#1080#1083#1086#1078#1077#1085#1080#1077
      Caption = #1042#1099'&x'#1086#1076
      Hint = #1042#1099#1093#1086#1076'|'#1047#1072#1082#1088#1099#1090#1100' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077
      ImageIndex = 43
      ShortCut = 16472
    end
    object actBank: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1041#1072#1085#1082#1080
      Hint = #1041#1072#1085#1082#1080
      FormName = 'TBankForm'
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
      Caption = #1050#1072#1089#1089#1099
      Hint = #1050#1072#1089#1089#1099
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
      FormName = 'TGoodsForm'
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
      FormName = 'TJuridicalForm'
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
    object actIncome: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      Caption = #1055#1088#1080#1093#1086#1076#1085#1099#1077' '#1085#1072#1082#1083#1072#1076#1085#1099#1077
      FormName = 'TIncomeJournalForm'
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
      FormName = 'TUnitForm'
      GuiParams = <>
      isShowModal = False
    end
    object actUnitGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Caption = #1043#1088#1091#1087#1087#1099' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081
      Hint = #1043#1088#1091#1087#1087#1099' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081
      FormName = 'TUnitGroupForm'
      GuiParams = <>
      isShowModal = False
    end
    object actBalance: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      Caption = #1041#1072#1083#1072#1085#1089
      FormName = 'TBalanceForm'
      GuiParams = <>
      isShowModal = False
    end
  end
  object cxLocalizer: TcxLocalizer
    StorageType = lstResource
    Left = 256
    Top = 48
  end
end
