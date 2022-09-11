inherited SalePromoGoodsDialogForm: TSalePromoGoodsDialogForm
  BorderIcons = [biSystemMenu]
  Caption = #1042#1099#1073#1086#1088' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072' '#1076#1083#1103' '#1087#1086#1076#1087#1080#1089#1080' '#1088#1077#1094#1077#1087#1090#1086#1074
  ClientHeight = 343
  ClientWidth = 489
  Position = poScreenCenter
  ExplicitWidth = 505
  ExplicitHeight = 382
  PixelsPerInch = 96
  TextHeight = 13
  object BankPOSTerminalGrid: TcxGrid [0]
    Left = 0
    Top = 0
    Width = 489
    Height = 302
    Align = alClient
    TabOrder = 0
    object BankPOSTerminalGridDBTableView: TcxGridDBTableView
      OnDblClick = BankPOSTerminalGridDBTableViewDblClick
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = SalePromoGoodsDialoglDS
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.GridLineColor = clBtnFace
      OptionsView.GroupByBox = False
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object GoodsPresentCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsPresentCode'
        HeaderAlignmentHorz = taCenter
        Width = 70
      end
      object GoodsPresentName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsPresentName'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 242
      end
      object PriceSale: TcxGridDBColumn
        Caption = #1062#1077#1085#1072
        DataBinding.FieldName = 'PriceSale'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00; ;'
        HeaderAlignmentHorz = taCenter
        Width = 70
      end
      object AmountSale: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086
        DataBinding.FieldName = 'AmountSale'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.###;-,0.###; ;'
        HeaderAlignmentHorz = taCenter
        Width = 68
      end
    end
    object BankPOSTerminalGridLevel: TcxGridLevel
      Caption = #1040#1083#1100#1090' (24 '#1087#1086#1079') "*"'
      GridView = BankPOSTerminalGridDBTableView
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 302
    Width = 489
    Height = 41
    Align = alBottom
    TabOrder = 1
    object bbCancel: TcxButton
      Left = 309
      Top = 6
      Width = 75
      Height = 25
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 0
    end
    object bbOk: TcxButton
      Left = 79
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Ok'
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 67
    Top = 104
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 256
    Top = 104
  end
  inherited ActionList: TActionList
    Images = dmMain.ImageList
    Left = 167
    Top = 103
  end
  object SalePromoGoodsDialoglDS: TDataSource
    Left = 64
    Top = 32
  end
end
