inherited MainForm: TMainForm
  Caption = 'ProjectBoat - 64bit'
  ClientHeight = 406
  ClientWidth = 1050
  KeyPreview = True
  ExplicitWidth = 1066
  ExplicitHeight = 465
  PixelsPerInch = 96
  TextHeight = 13
  object btnIncome: TcxButton [0]
    Left = 24
    Top = 17
    Width = 129
    Height = 77
    Action = actIncome_noDialog
    Colors.DefaultText = clBlue
    Colors.NormalText = clBlue
    Colors.HotText = clBlue
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object btnSend: TcxButton [1]
    Left = 159
    Top = 17
    Width = 129
    Height = 77
    Action = actSend_noDialog
    Colors.DefaultText = clBlue
    Colors.NormalText = clBlue
    Colors.HotText = clBlue
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object btnOrderPartner: TcxButton [2]
    Left = 24
    Top = 100
    Width = 129
    Height = 77
    Action = actOrderPartner_noDialog
    Colors.DefaultText = clBlue
    Colors.NormalText = clBlue
    Colors.HotText = clBlue
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object btnProduct: TcxButton [3]
    Left = 311
    Top = 17
    Width = 140
    Height = 77
    Action = actProduct_noDialog
    Colors.DefaultText = clPurple
    Colors.NormalText = clPurple
    Colors.HotText = clPurple
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object btnOrderInternal: TcxButton [4]
    Left = 459
    Top = 17
    Width = 140
    Height = 77
    Action = actOrderInternal_noDialog
    Colors.DefaultText = clPurple
    Colors.NormalText = clPurple
    Colors.HotText = clPurple
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object btnProductionUnion: TcxButton [5]
    Left = 459
    Top = 100
    Width = 140
    Height = 77
    Action = actProductionUnion_noDialog
    Colors.DefaultText = clPurple
    Colors.NormalText = clPurple
    Colors.HotText = clPurple
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object btnSale: TcxButton [6]
    Left = 607
    Top = 17
    Width = 140
    Height = 77
    Action = actSale_noDialog
    Colors.DefaultText = clPurple
    Colors.NormalText = clPurple
    Colors.HotText = clPurple
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object btnExit: TcxButton [7]
    Left = 766
    Top = 17
    Width = 140
    Height = 77
    Action = actExit_btn
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object btnInvoiceJournal: TcxButton [8]
    Left = 24
    Top = 212
    Width = 129
    Height = 77
    Action = actInvoiceJournal_noDialog
    Colors.DefaultText = clMaroon
    Colors.NormalText = clMaroon
    Colors.HotText = clMaroon
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object btnBankAccountJournal: TcxButton [9]
    Left = 159
    Top = 212
    Width = 129
    Height = 77
    Action = actBankAccountJournal_noDialog
    Colors.DefaultText = clMaroon
    Colors.NormalText = clMaroon
    Colors.HotText = clMaroon
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object btnProdOptions: TcxButton [10]
    Left = 459
    Top = 212
    Width = 140
    Height = 77
    Action = actProdOptions
    Colors.DefaultText = clOlive
    Colors.NormalText = clOlive
    Colors.HotText = clOlive
    ParentShowHint = False
    ShowHint = True
    TabOrder = 10
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object btnReceiptProdModel: TcxButton [11]
    Left = 607
    Top = 212
    Width = 140
    Height = 77
    Action = actReceiptProdModel
    Colors.DefaultText = clOlive
    Colors.NormalText = clOlive
    Colors.HotText = clOlive
    ParentShowHint = False
    ShowHint = True
    TabOrder = 11
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object btnReceiptGoods: TcxButton [12]
    Left = 607
    Top = 295
    Width = 140
    Height = 77
    Action = actReceiptGoods
    Colors.DefaultText = clOlive
    Colors.NormalText = clOlive
    Colors.HotText = clOlive
    ParentShowHint = False
    ShowHint = True
    TabOrder = 12
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  inherited ActionList: TActionList
    Left = 344
    Top = 145
    object actReport_PriceList: TdsdOpenForm [0]
      Category = '08_'#1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1055#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072#1084' ('#1085#1072' '#1076#1072#1090#1091')'
      FormName = 'TReport_PriceListForm'
      FormNameParam.Value = 'TReport_PriceListForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Client: TdsdOpenForm [1]
      Category = '08_'#1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084
      FormName = 'TReport_ClientForm'
      FormNameParam.Value = 'TReport_ClientForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Partner: TdsdOpenForm [2]
      Category = '08_'#1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084
      FormName = 'TReport_PartnerForm'
      FormNameParam.Value = 'TReport_PartnerForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_ProductionPersonal: TdsdOpenForm [3]
      Category = '06_'#1054#1090#1095#1077#1090#1099' ('#1087#1088'-'#1074#1086')'
      MoveParams = <>
      Caption = #1063#1072#1089#1099' '#1057#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074' - '#1057#1073#1086#1088#1082#1072
      Hint = #1063#1072#1089#1099' '#1057#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074' - '#1057#1073#1086#1088#1082#1072
      FormName = 'TReport_ProductionPersonalForm'
      FormNameParam.Value = 'TReport_ProductionPersonalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_OrderClient_byBoat: TdsdOpenForm [4]
      Category = '07_'#1054#1090#1095#1077#1090#1099' ('#1089#1082#1083#1072#1076')'
      MoveParams = <>
      Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' '#1076#1083#1103' '#1079#1072#1082#1072#1079' '#1082#1083#1080#1077#1085#1090#1072
      FormName = 'TReport_OrderClient_byBoatForm'
      FormNameParam.Value = 'TReport_OrderClient_byBoatForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Personal: TdsdOpenForm [5]
      Category = '08_'#1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084
      FormName = 'TReport_PersonalForm'
      FormNameParam.Value = 'TReport_PersonalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_OrderInternal: TdsdOpenForm [6]
      Category = '07_'#1054#1090#1095#1077#1090#1099' ('#1089#1082#1083#1072#1076')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1047#1072#1082#1072#1079#1072#1084' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072
      FormName = 'TReport_OrderInternalForm'
      FormNameParam.Value = 'TReport_OrderInternalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsMotion: TdsdOpenForm [7]
      Category = '07_'#1054#1090#1095#1077#1090#1099' ('#1089#1082#1083#1072#1076')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1076#1074#1080#1078#1077#1085#1080#1102' '#1082#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1093
      FormName = 'TReport_GoodsMotionForm'
      FormNameParam.Value = 'TReport_GoodsMotionForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_OrderClient: TdsdOpenForm [8]
      Category = '07_'#1054#1090#1095#1077#1090#1099' ('#1089#1082#1083#1072#1076')'
      MoveParams = <>
      Caption = #1047#1072#1082#1072#1079#1099' '#1050#1083#1080#1077#1085#1090#1072
      FormName = 'TReport_OrderClientForm'
      FormNameParam.Value = 'TReport_OrderClientForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actOrderInternal: TdsdOpenForm [9]
      Category = '02_'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1047#1072#1082#1072#1079' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      ImageIndex = 31
      FormName = 'TOrderInternalJournalForm'
      FormNameParam.Value = 'TOrderInternalJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actOrderInternal_noDialog: TdsdOpenForm [10]
      Category = '02_'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1047#1072#1082#1072#1079' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      ImageIndex = 31
      FormName = 'TOrderInternalJournalForm'
      FormNameParam.Value = 'TOrderInternalJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
      isNotExecuteDialog = True
    end
    object actProductionUnion: TdsdOpenForm [11]
      Category = '02_'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1089#1073#1086#1088#1082#1072
      ImageIndex = 25
      FormName = 'TProductionUnionJournalForm'
      FormNameParam.Value = 'TProductionUnionJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProductionUnion_noDialog: TdsdOpenForm [12]
      Category = '02_'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1089#1073#1086#1088#1082#1072
      ImageIndex = 25
      FormName = 'TProductionUnionJournalForm'
      FormNameParam.Value = 'TProductionUnionJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
      isNotExecuteDialog = True
    end
    object actProductionUnionMaster: TdsdOpenForm [13]
      Category = '02_'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1089#1073#1086#1088#1082#1072' ('#1091#1079#1083#1099')'
      FormName = 'TProductionUnionMasterJournalForm'
      FormNameParam.Value = 'TProductionUnionMasterJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReceiptProdModel: TdsdOpenForm [14]
      Category = '02_'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080' '#1052#1086#1076#1077#1083#1080
      ImageIndex = 47
      FormName = 'TReceiptProdModelForm'
      FormNameParam.Value = 'TReceiptProdModelForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReceiptGoods: TdsdOpenForm [15]
      Category = '02_'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080' '#1059#1079#1083#1086#1074
      ImageIndex = 48
      FormName = 'TReceiptGoodsForm'
      FormNameParam.Value = 'TReceiptGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReceiptGoodsLine: TdsdOpenForm [16]
      Category = '02_'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080' '#1059#1079#1083#1086#1074' ('#1089#1087#1080#1089#1086#1082')'
      FormName = 'TReceiptGoodsLineForm'
      FormNameParam.Value = 'TReceiptGoodsLineForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsGroup_List: TdsdOpenForm [17]
      Category = '10_'#1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1099' '#1082#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1093' ('#1089#1087#1080#1089#1086#1082')'
      FormName = 'TGoodsGroup_ListForm'
      FormNameParam.Value = 'TGoodsGroup_ListForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Movement_PriceList: TdsdOpenForm [18]
      Category = '08_'#1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1055#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072#1084
      FormName = 'TReport_Movement_PriceListForm'
      FormNameParam.Value = 'TReport_Movement_PriceListForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actIncome: TdsdOpenForm [19]
      Category = '01_'#1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
      ImageIndex = 30
      FormName = 'TIncomeJournalForm'
      FormNameParam.Value = 'TIncomeJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSend: TdsdOpenForm [20]
      Category = '01_'#1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      ImageIndex = 27
      FormName = 'TSendJournalForm'
      FormNameParam.Value = 'TSendJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actOrderPartner: TdsdOpenForm [21]
      Category = '01_'#1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1047#1072#1082#1072#1079' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1091
      ImageIndex = 32
      FormName = 'TOrderPartnerJournalForm'
      FormNameParam.Value = 'TOrderPartnerJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actOrderClient: TdsdOpenForm [22]
      Category = '01_'#1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
      FormName = 'TOrderClientJournalForm'
      FormNameParam.Value = 'TOrderClientJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSale: TdsdOpenForm [23]
      Category = '01_'#1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1050#1083#1080#1077#1085#1090#1091
      ImageIndex = 54
      FormName = 'TSaleJournalForm'
      FormNameParam.Value = 'TSaleJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actLoss: TdsdOpenForm [24]
      Category = '01_'#1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1057#1087#1080#1089#1072#1085#1080#1077
      FormName = 'TLossJournalForm'
      FormNameParam.Value = 'TLossJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actInventory: TdsdOpenForm [25]
      Category = '01_'#1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103
      FormName = 'TInventoryJournalForm'
      FormNameParam.Value = 'TInventoryJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPriceListJournal: TdsdOpenForm [26]
      Category = '01_'#1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' ('#1094#1077#1085#1099' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072')'
      FormName = 'TPriceListJournalForm'
      FormNameParam.Value = 'TPriceListJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actInvoiceJournal: TdsdOpenForm [27]
      Category = '04_'#1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1057#1095#1077#1090#1072
      ImageIndex = 60
      FormName = 'TInvoiceJournalForm'
      FormNameParam.Value = 'TInvoiceJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actInvoiceJournal_noDialog: TdsdOpenForm [28]
      Category = '04_'#1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1057#1095#1077#1090#1072
      ImageIndex = 60
      FormName = 'TInvoiceJournalForm'
      FormNameParam.Value = 'TInvoiceJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
      isNotExecuteDialog = True
    end
    object actBankAccountJournal: TdsdOpenForm [29]
      Category = '04_'#1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090
      Hint = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090' '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
      ImageIndex = 42
      FormName = 'TBankAccountJournalForm'
      FormNameParam.Value = 'TBankAccountJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actBankAccountJournal_noDialog: TdsdOpenForm [30]
      Category = '04_'#1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090
      Hint = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090' '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
      ImageIndex = 42
      FormName = 'TBankAccountJournalForm'
      FormNameParam.Value = 'TBankAccountJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
      isNotExecuteDialog = True
    end
    object actCashJournal: TdsdOpenForm [31]
      Category = '04_'#1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
      FormName = 'TCashJournalForm'
      FormNameParam.Value = 'TCashJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actIncomeCost: TdsdOpenForm [32]
      Category = '04_'#1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1047#1072#1090#1088#1072#1090#1099
      FormName = 'TIncomeCostJournalForm'
      FormNameParam.Value = 'TIncomeCostJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMaterialOptions: TdsdOpenForm [33]
      Category = '10_'#1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1054#1087#1094#1080#1081
      FormName = 'TMaterialOptionsForm'
      FormNameParam.Value = 'TMaterialOptionsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMeasureCode: TdsdOpenForm [34]
      Category = '10_'#1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1057#1086#1082#1088#1072#1097#1077#1085#1085#1099#1081' '#1082#1086#1076' '#1077#1076'. '#1080#1079#1084'.'
      FormName = 'TMeasureCodeForm'
      FormNameParam.Value = 'TMeasureCodeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actTranslateObject: TdsdOpenForm [35]
      Category = '10_'#1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1074#1086#1076' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1086#1074
      FormName = 'TTranslateObjectForm'
      FormNameParam.Value = 'TTranslateObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReceiptService: TdsdOpenForm [36]
      Category = '02_'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1056#1072#1073#1086#1090#1099'/'#1059#1089#1083#1091#1075#1080
      FormName = 'TReceiptServiceForm'
      FormNameParam.Value = 'TReceiptServiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReceiptLevel: TdsdOpenForm [37]
      Category = '02_'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1069#1090#1072#1087#1099' '#1089#1073#1086#1088#1082#1080
      FormName = 'TReceiptLevelForm'
      FormNameParam.Value = 'TReceiptLevelForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MasterObjectDesc'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actProductionPersonal: TdsdOpenForm [38]
      Category = '02_'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1095#1072#1089#1099' '#1057#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074
      FormName = 'TProductionPersonalJournalForm'
      FormNameParam.Value = 'TProductionPersonalJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Goods: TdsdOpenForm [39]
      Category = '07_'#1054#1090#1095#1077#1090#1099' ('#1089#1082#1083#1072#1076')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1082#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1084
      FormName = 'TReport_GoodsForm'
      FormNameParam.Value = 'TReport_GoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actModelEtiketen: TdsdOpenForm [40]
      Category = '10_'#1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
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
    object actProdGroup: TdsdOpenForm [41]
      Category = '03_'#1051#1086#1076#1082#1080
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1099
      FormName = 'TGoodsForm'
      FormNameParam.Value = 'TGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actColorPattern: TdsdOpenForm [42]
      Category = '03_'#1051#1086#1076#1082#1080
      MoveParams = <>
      Caption = #1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088' - '#1053#1072#1079#1074#1072#1085#1080#1103' '#1096#1072#1073#1083#1086#1085#1072
      FormName = 'TColorPatternForm'
      FormNameParam.Value = 'TColorPatternForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_ProfitLossPeriod: TdsdOpenForm [43]
      Category = '09_'#1054#1090#1095#1077#1090#1099' ('#1059#1055')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1086' '#1055#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1059#1073#1099#1090#1082#1072#1093' ('#1089#1088#1072#1074#1085#1077#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1086#1074')'
      FormName = 'TReport_ProfitLossPeriodForm'
      FormNameParam.Value = 'TReport_ProfitLossPeriodForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Income: TdsdOpenForm [44]
      Category = '07_'#1054#1090#1095#1077#1090#1099' ('#1089#1082#1083#1072#1076')'
      MoveParams = <>
      Caption = #1055#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
      FormName = 'TReport_MovementIncomeForm'
      FormNameParam.Value = 'TReport_MovementIncomeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actTaxKindEdit: TdsdOpenForm [45]
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1058#1080#1087#1099' '#1053#1044#1057' ('#1082#1086#1088#1088'.)'
      FormName = 'TTaxKindEditForm'
      FormNameParam.Value = 'TTaxKindEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Sale: TdsdOpenForm [46]
      Category = '07_'#1054#1090#1095#1077#1090#1099' ('#1089#1082#1083#1072#1076')'
      MoveParams = <>
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1050#1083#1080#1077#1085#1090#1091
      FormName = 'TReport_SaleForm'
      FormNameParam.Value = 'TReport_SaleForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Send: TdsdOpenForm [47]
      Category = '07_'#1054#1090#1095#1077#1090#1099' ('#1089#1082#1083#1072#1076')'
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      FormName = 'TReport_SendForm'
      FormNameParam.Value = 'TReport_SendForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actDocTag: TdsdOpenForm [48]
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1094#1080#1080
      FormName = 'TDocTagForm'
      FormNameParam.Value = 'TDocTagForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_SaleOLAP: TdsdOpenForm [49]
      Category = '09_'#1054#1090#1095#1077#1090#1099' ('#1059#1055')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' ('#1054#1051#1040#1055')'
      FormName = 'TReport_SaleOLAPForm'
      FormNameParam.Value = 'TReport_SaleOLAPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProdColorPattern: TdsdOpenForm [50]
      Category = '03_'#1051#1086#1076#1082#1080
      MoveParams = <>
      Caption = #1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088' - '#1064#1072#1073#1083#1086#1085' '#1076#1083#1103' '#1084#1086#1076#1077#1083#1080
      FormName = 'TProdColorPatternForm'
      FormNameParam.Value = 'TProdColorPatternForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPLZ: TdsdOpenForm [51]
      Category = '10_'#1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1086#1095#1090#1086#1074#1099#1077' '#1080#1085#1076#1077#1082#1089#1099
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
    object actReport_CollationByPartner: TdsdOpenForm [52]
      Category = '08_'#1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080
      FormName = 'TReport_CollationByPartnerForm'
      FormNameParam.Value = 'TReport_CollationByPartnerForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actTranslateMessage: TdsdOpenForm [53]
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1074#1086#1076' '#1057#1086#1086#1073#1097#1077#1085#1080#1081
      FormName = 'TTranslateMessageForm'
      FormNameParam.Value = 'TTranslateMessageForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Loss: TdsdOpenForm [54]
      Category = '07_'#1054#1090#1095#1077#1090#1099' ('#1089#1082#1083#1072#1076')'
      MoveParams = <>
      Caption = #1057#1087#1080#1089#1072#1085#1080#1077
      FormName = 'TReport_MovementLossForm'
      FormNameParam.Value = 'TReport_MovementLossForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProdOptPattern: TdsdOpenForm [55]
      Category = '03_'#1051#1086#1076#1082#1080
      MoveParams = <>
      Caption = #1064#1072#1073#1083#1086#1085' '#1054#1087#1094#1080#1081
      FormName = 'TProdOptPatternForm'
      FormNameParam.Value = 'TProdOptPatternForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProdColorKind: TdsdOpenForm [56]
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1042#1080#1076#1099' Boat Structure'
      FormName = 'TProdColorKindForm'
      FormNameParam.Value = 'TProdColorKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsCode: TdsdOpenForm [57]
      Category = '07_'#1054#1090#1095#1077#1090#1099' ('#1089#1082#1083#1072#1076')'
      MoveParams = <>
      Caption = #1044#1074#1080#1078#1077#1085#1080#1077' ('#1074#1074#1086#1076' '#1040#1088#1090#1080#1082#1091#1083#1072')'
      FormName = 'TReport_GoodsCodeForm'
      FormNameParam.Value = 'TReport_GoodsCodeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Remains_onDate: TdsdOpenForm [58]
      Category = '07_'#1054#1090#1095#1077#1090#1099' ('#1089#1082#1083#1072#1076')'
      MoveParams = <>
      Caption = #1054#1089#1090#1072#1090#1082#1080' '#1085#1072' '#1076#1072#1090#1091
      FormName = 'TReport_Goods_RemainsCurrent_onDateForm'
      FormNameParam.Value = 'TReport_Goods_RemainsCurrent_onDateForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_MotionByClient: TdsdOpenForm [59]
      Category = '08_'#1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1044#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1082#1083#1080#1077#1085#1090#1072#1084
      FormName = 'TReport_MotionByClientForm'
      FormNameParam.Value = 'TReport_MotionByClientForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Account: TdsdOpenForm [60]
      Category = '08_'#1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1088#1072#1089#1095#1077#1090#1072#1084
      FormName = 'TReport_GoodsMI_AccountForm'
      FormNameParam.Value = 'TReport_GoodsMI_AccountForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actBrand: TdsdOpenForm [61]
      Category = '03_'#1051#1086#1076#1082#1080
      MoveParams = <>
      Caption = #1052#1072#1088#1082#1080' '#1084#1086#1076#1077#1083#1080
      FormName = 'TBrandForm'
      FormNameParam.Value = 'TBrandForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProdModel: TdsdOpenForm [62]
      Category = '03_'#1051#1086#1076#1082#1080
      MoveParams = <>
      Caption = #1052#1086#1076#1077#1083#1080
      FormName = 'TProdModelForm'
      FormNameParam.Value = 'TProdModelForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProdEngine: TdsdOpenForm [63]
      Category = '03_'#1051#1086#1076#1082#1080
      MoveParams = <>
      Caption = #1052#1086#1090#1086#1088#1099
      FormName = 'TProdEngineForm'
      FormNameParam.Value = 'TProdEngineForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Remains_curr: TdsdOpenForm [64]
      Category = '07_'#1054#1090#1095#1077#1090#1099' ('#1089#1082#1083#1072#1076')'
      MoveParams = <>
      Caption = #1054#1089#1090#1072#1090#1082#1080
      FormName = 'TReport_Goods_RemainsCurrentForm'
      FormNameParam.Value = 'TReport_Goods_RemainsCurrentForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actDiscountItem: TdsdOpenForm [65]
      Category = '05_'#1048#1089#1090#1086#1088#1080#1080
      MoveParams = <>
      Caption = #1048#1089#1090#1086#1088#1080#1103' '#1089#1082#1080#1076#1086#1082
      FormName = 'TDiscountPeriodItemForm'
      FormNameParam.Value = 'TDiscountPeriodItemForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    inherited actAbout: TAction [66]
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077
    end
    inherited actUpdateProgram: TAction [67]
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077
    end
    inherited actLookAndFeel: TAction [68]
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077
    end
    object actUser: TdsdOpenForm [69]
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080
      FormName = 'TUserForm'
      FormNameParam.Value = 'TUserForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    inherited actImportSettings: TdsdOpenForm [70]
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077
    end
    inherited actImportGroup: TdsdOpenForm [71]
    end
    inherited actImportType: TdsdOpenForm [72]
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077
    end
    object actForms: TdsdOpenForm [73]
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077
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
    object actRole: TdsdOpenForm [74]
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1056#1086#1083#1080
      FormName = 'TRoleForm'
      FormNameParam.Value = 'TRoleForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPriceList: TdsdOpenForm [75]
      Category = '10_'#1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099
      FormName = 'TPriceListForm'
      FormNameParam.Value = 'TPriceListForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    inherited actImportExportLink: TdsdOpenForm [76]
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077
      Enabled = False
    end
    inherited actProtocolUser: TdsdOpenForm [77]
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077
    end
    inherited actProtocolMovement: TdsdOpenForm [78]
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077
    end
    inherited actProtocol: TdsdOpenForm [79]
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077
    end
    inherited actInfoMoneyGroup: TdsdOpenForm [80]
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077'\'#1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actInfoMoneyDestination: TdsdOpenForm [81]
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077'\'#1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actInfoMoney: TdsdOpenForm [82]
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077'\'#1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actAccountGroup: TdsdOpenForm [83]
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077'\'#1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actAccountDirection: TdsdOpenForm [84]
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077'\'#1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actAccount: TdsdOpenForm [85]
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077'\'#1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actProfitLoss: TdsdOpenForm [86]
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077'\'#1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actMovementDesc: TdsdOpenForm [87]
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077
    end
    object actMeasure: TdsdOpenForm [88]
      Category = '10_'#1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1045#1076#1080#1085#1080#1094#1099' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
      FormName = 'TMeasureForm'
      FormNameParam.Value = 'TMeasureForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actCountry: TdsdOpenForm [89]
      Category = '10_'#1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1057#1090#1088#1072#1085#1099
      FormName = 'TCountryForm'
      FormNameParam.Value = 'TCountryForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProduct: TdsdOpenForm [90]
      Category = '03_'#1051#1086#1076#1082#1080
      MoveParams = <>
      Caption = '***'#1051#1086#1076#1082#1072' - '#1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088
      ImageIndex = 43
      FormName = 'TProductForm'
      FormNameParam.Value = 'TProductForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProduct_noDialog: TdsdOpenForm [91]
      Category = '03_'#1051#1086#1076#1082#1080
      MoveParams = <>
      Caption = '***'#1051#1086#1076#1082#1072' - '#1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088
      ImageIndex = 43
      FormName = 'TProductForm'
      FormNameParam.Value = 'TProductForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
      isNotExecuteDialog = True
    end
    object actGoodsSize: TdsdOpenForm [92]
      Category = '10_'#1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = 'Gr'#246#223'e('#1056#1072#1079#1084#1077#1088#1099')'
      FormName = 'TGoodsSizeForm'
      FormNameParam.Value = 'TGoodsSizeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsGroup: TdsdOpenForm [93]
      Category = '10_'#1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1099' '#1082#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1093
      FormName = 'TGoodsGroupForm'
      FormNameParam.Value = 'TGoodsGroupForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actCurrency: TdsdOpenForm [94]
      Category = '10_'#1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1042#1072#1083#1102#1090#1072
      FormName = 'TCurrencyForm'
      FormNameParam.Value = 'TCurrencyForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMember: TdsdOpenForm [95]
      Category = '10_'#1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1060#1080#1079#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      FormName = 'TMemberForm'
      FormNameParam.Value = 'TMemberForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPartner: TdsdOpenForm [96]
      Category = '10_'#1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = 'Lieferanten('#1055#1086#1089#1090#1072#1074#1097#1080#1082#1080')'
      FormName = 'TPartnerForm'
      FormNameParam.Value = 'TPartnerForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actClient: TdsdOpenForm [97]
      Category = '10_'#1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = 'Kunden('#1055#1086#1082#1091#1087#1072#1090#1077#1083#1080')'
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
    object actUnit: TdsdOpenForm [98]
      Category = '10_'#1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1057#1082#1083#1072#1076#1099'/'#1059#1095#1072#1089#1090#1082#1080' '#1089#1073#1086#1088#1082#1080
      FormName = 'TUnitForm'
      FormNameParam.Value = 'TUnitForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoods: TdsdOpenForm [99]
      Category = '10_'#1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' '#1089#1087#1080#1089#1086#1082
      FormName = 'TGoodsForm'
      FormNameParam.Value = 'TGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsTree: TdsdOpenForm [100]
      Category = '10_'#1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
      FormName = 'TGoodsTreeForm'
      FormNameParam.Value = 'TGoodsTreeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPartionGoods: TdsdOpenForm [101]
      Category = '10_'#1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' '#1055#1072#1088#1090#1080#1080' '
      FormName = 'TPartionGoodsChoiceForm'
      FormNameParam.Value = 'TPartionGoodsChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPosition: TdsdOpenForm [102]
      Category = '10_'#1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1080
      FormName = 'TPositionForm'
      FormNameParam.Value = 'TPositionForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPersonal: TdsdOpenForm [103]
      Category = '10_'#1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082#1080
      FormName = 'TPersonalForm'
      FormNameParam.Value = 'TPersonalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actCurrencyMovement: TdsdOpenForm [104]
      Category = '04_'#1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1050#1091#1088#1089#1086#1074#1072#1103' '#1088#1072#1079#1085#1080#1094#1072
      FormName = 'TCurrencyJournalForm'
      FormNameParam.Value = 'TCurrencyJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPriceListItem: TdsdOpenForm [105]
      Category = '05_'#1048#1089#1090#1086#1088#1080#1080
      MoveParams = <>
      Caption = #1048#1089#1090#1086#1088#1080#1103' '#1094#1077#1085
      FormName = 'TPriceListItemForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actCash: TdsdOpenForm [106]
      Category = '10_'#1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1099
      FormName = 'TCashForm'
      FormNameParam.Value = 'TCashForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actBank: TdsdOpenForm [107]
      Category = '10_'#1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1041#1072#1085#1082#1080
      FormName = 'TBankForm'
      FormNameParam.Value = 'TBankForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actBankAccount: TdsdOpenForm [108]
      Category = '10_'#1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1077' '#1089#1095#1077#1090#1072
      FormName = 'TBankAccountForm'
      FormNameParam.Value = 'TBankAccountForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Balance: TdsdOpenForm [109]
      Category = '09_'#1054#1090#1095#1077#1090#1099' ('#1059#1055')'
      MoveParams = <>
      Caption = #1041#1072#1083#1072#1085#1089
      FormName = 'TReport_BalanceForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_ProfitLoss: TdsdOpenForm [110]
      Category = '09_'#1054#1090#1095#1077#1090#1099' ('#1059#1055')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1086' '#1055#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1059#1073#1099#1090#1082#1072#1093
      FormName = 'TReport_ProfitLossForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Cash: TdsdOpenForm [111]
      Category = '08_'#1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1082#1072#1089#1089#1077
      FormName = 'TReport_CashForm'
      FormNameParam.Value = 'TReport_CashForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_ProductionOLAP: TdsdOpenForm [112]
      Category = '06_'#1054#1090#1095#1077#1090#1099' ('#1087#1088'-'#1074#1086')'
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
    object actLanguage: TdsdOpenForm [113]
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1071#1079#1099#1082#1080' '#1087#1077#1088#1077#1074#1086#1076#1072
      FormName = 'TLanguageForm'
      FormNameParam.Value = 'TLanguageForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actTranslateWord: TdsdOpenForm [114]
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1074#1086#1076' '#1089#1083#1086#1074
      FormName = 'TTranslateWordForm'
      FormNameParam.Value = 'TTranslateWordForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    inherited actProfitLossDirection: TdsdOpenForm [115]
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077'\'#1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actProfitLossGroup: TdsdOpenForm [116]
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077'\'#1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actExit: TFileExit [117]
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077
    end
    object actProdColorGroup: TdsdOpenForm
      Category = '03_'#1051#1086#1076#1082#1080
      MoveParams = <>
      Caption = #1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088' - '#1069#1083#1077#1084#1077#1085#1090#1099' '#1076#1083#1103' '#1096#1072#1073#1083#1086#1085#1072
      FormName = 'TProdColorGroupForm'
      FormNameParam.Value = 'TProdColorGroupForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProdColor: TdsdOpenForm
      Category = '03_'#1051#1086#1076#1082#1080
      MoveParams = <>
      Caption = #1062#1074#1077#1090
      FormName = 'TProdColorForm'
      FormNameParam.Value = 'TProdColorForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProdColorItems: TdsdOpenForm
      Category = '03_'#1051#1086#1076#1082#1080
      MoveParams = <>
      Caption = '*'#1051#1086#1076#1082#1072' - '#1069#1083#1077#1084#1077#1085#1090#1099' '#1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088#1072
      FormName = 'TProdColorItemsForm'
      FormNameParam.Value = 'TProdColorItemsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProdOptions: TdsdOpenForm
      Category = '03_'#1051#1086#1076#1082#1080
      MoveParams = <>
      Caption = #1054#1087#1094#1080#1080
      ImageIndex = 33
      FormName = 'TProdOptionsForm'
      FormNameParam.Value = 'TProdOptionsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProdOptItems: TdsdOpenForm
      Category = '03_'#1051#1086#1076#1082#1080
      MoveParams = <>
      Caption = '*'#1051#1086#1076#1082#1072' - '#1069#1083#1077#1084#1077#1085#1090#1099' '#1054#1087#1094#1080#1081
      FormName = 'TProdOptItemsForm'
      FormNameParam.Value = 'TProdOptItemsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actHelp: TShellExecuteAction
      Category = 'DSDLib'
      MoveParams = <>
      Param.Value = Null
      Param.Component = FormParams
      Param.ComponentItem = 'HelpFile'
      Param.DataType = ftString
      Param.MultiSelectSeparator = ','
      Caption = #1055#1086#1084#1086#1097#1100
    end
    object actGet_Object_Form_HelpFile: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Object_Form_HelpFile
      StoredProcList = <
        item
          StoredProc = spGet_Object_Form_HelpFile
        end>
      Caption = 'actGet_Object_Form_HelpFile'
    end
    object mactHelp: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Object_Form_HelpFile
        end
        item
          Action = actHelp
        end>
      Caption = #1055#1086#1084#1086#1097#1100
      ShortCut = 16496
    end
    object actExit_btn: TAction
      Category = '11_'#1057#1083#1091#1078#1077#1073#1085#1099#1077
      Caption = #1047#1072#1082#1088#1099#1090#1100
      ImageIndex = 87
      OnExecute = actExit_btnExecute
    end
    object actIncome_noDialog: TdsdOpenForm
      Category = '01_'#1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1080#1093#1086#1076' '#1086#1090' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
      ImageIndex = 30
      FormName = 'TIncomeJournalForm'
      FormNameParam.Value = 'TIncomeJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
      isNotExecuteDialog = True
    end
    object actSend_noDialog: TdsdOpenForm
      Category = '01_'#1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      ImageIndex = 27
      FormName = 'TSendJournalForm'
      FormNameParam.Value = 'TSendJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
      isNotExecuteDialog = True
    end
    object actOrderPartner_noDialog: TdsdOpenForm
      Category = '01_'#1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1047#1072#1082#1072#1079' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1091
      ImageIndex = 32
      FormName = 'TOrderPartnerJournalForm'
      FormNameParam.Value = 'TOrderPartnerJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
      isNotExecuteDialog = True
    end
    object actSale_noDialog: TdsdOpenForm
      Category = '01_'#1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1050#1083#1080#1077#1085#1090#1091
      ImageIndex = 54
      FormName = 'TSaleJournalForm'
      FormNameParam.Value = 'TSaleJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
      isNotExecuteDialog = True
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 256
    Top = 73
  end
  inherited StoredProc: TdsdStoredProc
    Left = 224
    Top = 121
  end
  inherited ClientDataSet: TClientDataSet
    Left = 48
    Top = 73
  end
  inherited frxXMLExport: TfrxXMLExport
    Left = 152
    Top = 73
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
    Left = 32
    Top = 161
  end
  inherited MainMenu: TMainMenu
    Left = 272
    Top = 25
    object miMovement: TMenuItem [0]
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      object miIncome: TMenuItem
        Action = actIncome
      end
      object miSend: TMenuItem
        Action = actSend
      end
      object miLine11: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object miOrderPartner: TMenuItem
        Action = actOrderPartner
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
      end
      object miLoss: TMenuItem
        Action = actLoss
      end
      object miLine13: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object miInventory: TMenuItem
        Action = actInventory
      end
      object N21: TMenuItem
        Caption = '-'
      end
      object miPriceListJournal: TMenuItem
        Action = actPriceListJournal
      end
    end
    object miProduction: TMenuItem [1]
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      object miOrderInternal: TMenuItem
        Action = actOrderInternal
      end
      object miProductionUnion: TMenuItem
        Action = actProductionUnion
      end
      object miProductionUnionMaster: TMenuItem
        Action = actProductionUnionMaster
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
      object miReceiptGoodsLine: TMenuItem
        Action = actReceiptGoodsLine
      end
      object miLine23_: TMenuItem
        Caption = '-'
      end
      object miReceiptLevel: TMenuItem
        Action = actReceiptLevel
      end
      object miReceiptService: TMenuItem
        Action = actReceiptService
      end
      object miLine24_: TMenuItem
        Caption = '-'
      end
      object miProductionPersonal: TMenuItem
        Action = actProductionPersonal
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
      object miLine31_: TMenuItem
        Caption = '-'
      end
      object miProduct: TMenuItem
        Action = actProduct
      end
      object miLine32_: TMenuItem
        Caption = '-'
      end
      object miProdOptions: TMenuItem
        Action = actProdOptions
      end
      object miMaterialOptions: TMenuItem
        Action = actMaterialOptions
      end
      object miProdOptPattern: TMenuItem
        Action = actProdOptPattern
      end
      object miLine33_: TMenuItem
        Caption = '-'
      end
      object miProdColorPattern: TMenuItem
        Action = actProdColorPattern
        Caption = #1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088' - '#1069#1083#1077#1084#1077#1085#1090#1099'  '#1076#1083#1103' '#1084#1086#1076#1077#1083#1080
      end
      object miProdColorGroup: TMenuItem
        Action = actProdColorGroup
        Caption = #1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088' - '#1069#1083#1077#1084#1077#1085#1090#1099
      end
      object miColorPattern: TMenuItem
        Action = actColorPattern
      end
      object miProdColor: TMenuItem
        Action = actProdColor
      end
      object miLine34_: TMenuItem
        Caption = '-'
      end
      object miProdColorItems: TMenuItem
        Action = actProdColorItems
      end
      object miProdOptItems: TMenuItem
        Action = actProdOptItems
      end
    end
    object miFinance: TMenuItem [3]
      Caption = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      object miInvoiceJournal: TMenuItem
        Action = actInvoiceJournal
      end
      object miLine41_: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object miBankAccountJournal: TMenuItem
        Action = actBankAccountJournal
      end
      object miLine42_: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object miCashJournal: TMenuItem
        Action = actCashJournal
        Enabled = False
      end
      object miLine43_: TMenuItem
        Caption = '-'
      end
      object miIncomeCost: TMenuItem
        Action = actIncomeCost
      end
      object miCurrencyMovement: TMenuItem
        Action = actCurrencyMovement
        Enabled = False
      end
    end
    object miHistory: TMenuItem [4]
      Caption = #1048#1089#1090#1086#1088#1080#1080
      object miPriceListItem: TMenuItem
        Action = actPriceListItem
      end
      object miLine51_: TMenuItem
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
      object miReport_OrderInternal: TMenuItem
        Action = actReport_OrderInternal
      end
      object miLine61: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object miReport_Remains_curr_: TMenuItem
        Action = actReport_Remains_curr
      end
      object miReport_Remains_onDate_: TMenuItem
        Action = actReport_Remains_onDate
        Enabled = False
      end
      object miLine62_: TMenuItem
        Caption = '-'
      end
      object miReport_ProductionPersonal: TMenuItem
        Action = actReport_ProductionPersonal
      end
    end
    object miReport: TMenuItem [6]
      Caption = #1054#1090#1095#1077#1090#1099' ('#1089#1082#1083#1072#1076')'
      object miReport_Income: TMenuItem
        Action = actReport_Income
      end
      object miReport_Send: TMenuItem
        Action = actReport_Send
      end
      object miReport_Loss: TMenuItem
        Action = actReport_Loss
        Enabled = False
      end
      object miReport_Sale: TMenuItem
        Action = actReport_Sale
        Enabled = False
      end
      object miReport_OrderClient: TMenuItem
        Action = actReport_OrderClient
      end
      object miLine71: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object miReport_Remains_curr: TMenuItem
        Action = actReport_Remains_curr
      end
      object miReport_Remains_onDate: TMenuItem
        Action = actReport_Remains_onDate
        Enabled = False
      end
      object miLine72: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object miReport_GoodsCode: TMenuItem
        Action = actReport_GoodsCode
        Enabled = False
      end
      object miReport_Goods: TMenuItem
        Action = actReport_Goods
      end
      object miReport_GoodsMotion: TMenuItem
        Action = actReport_GoodsMotion
      end
      object miReport_OrderClient_byBoat: TMenuItem
        Action = actReport_OrderClient_byBoat
        Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072' '#1082#1083#1080#1077#1085#1090#1072
      end
    end
    object miReport_Finance: TMenuItem [7]
      Caption = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      object miReport_CollationByPartner: TMenuItem
        Action = actReport_CollationByPartner
      end
      object miReport_Cash: TMenuItem
        Action = actReport_Cash
        Enabled = False
      end
      object miReport_Personal: TMenuItem
        Action = actReport_Personal
      end
      object miReport_Partner: TMenuItem
        Action = actReport_Partner
      end
      object miReport_Client: TMenuItem
        Action = actReport_Client
      end
      object miLine81_: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object miReport_MotionByPartner: TMenuItem
        Action = actReport_MotionByClient
        Enabled = False
      end
      object miReport_Movement_PriceList: TMenuItem
        Action = actReport_Movement_PriceList
      end
      object miReport_PriceList: TMenuItem
        Action = actReport_PriceList
      end
    end
    object miReport_Basis: TMenuItem [8]
      Caption = #1054#1090#1095#1077#1090#1099' ('#1059#1055')'
      object miReport_Balance: TMenuItem
        Action = actReport_Balance
      end
      object miReport_ProfitLoss: TMenuItem
        Action = actReport_ProfitLoss
      end
      object miReport_ProfitLossPeriod: TMenuItem
        Action = actReport_ProfitLossPeriod
        Enabled = False
      end
      object miLine91_: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object miReport_SaleOLAP: TMenuItem
        Action = actReport_SaleOLAP
        Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' (OLAP)'
        Enabled = False
      end
      object miLine92_: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object miReport_SaleOLAP_Analysis: TMenuItem
        Caption = #1040#1085#1072#1083#1080#1079' '#1087#1088#1086#1076#1072#1078
        Enabled = False
      end
      object miLine93_: TMenuItem
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
      end
      object miGoodsGroupList: TMenuItem
        Action = actGoodsGroup_List
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
      object miMeasureCode: TMenuItem
        Action = actMeasureCode
      end
      object miGoodsSize: TMenuItem
        Action = actGoodsSize
      end
      object miModelEtiketen: TMenuItem
        Action = actModelEtiketen
      end
      object miLine10_1: TMenuItem
        Caption = '-'
        Visible = False
      end
      object miUnit: TMenuItem
        Action = actUnit
      end
      object miPriceList: TMenuItem
        Action = actPriceList
        Enabled = False
        Visible = False
      end
      object miLine10_2: TMenuItem
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
      end
      object miLine10_3: TMenuItem
        Caption = '-'
        Visible = False
      end
      object miClient: TMenuItem
        Action = actClient
      end
      object miLine10_4: TMenuItem
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
      object miLine10_5: TMenuItem
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
        object N17: TMenuItem
          Caption = '-'
        end
        object N16: TMenuItem
          Action = actDocTag
        end
      end
      object miUser: TMenuItem [1]
        Action = actUser
      end
      object miRole: TMenuItem [2]
        Action = actRole
      end
      object miGuide_Basis: TMenuItem [4]
        Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
        object miAccountGroup: TMenuItem
          Action = actAccountGroup
        end
        object miAccountDirection: TMenuItem
          Action = actAccountDirection
        end
        object miAccount: TMenuItem
          Action = actAccount
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
        end
        object miProfitLossDirection: TMenuItem
          Action = actProfitLossDirection
        end
        object miProfitLoss: TMenuItem
          Action = actProfitLoss
        end
      end
      inherited miLine802: TMenuItem [5]
      end
      object miLanguage: TMenuItem [6]
        Action = actLanguage
      end
      object miTranslateWord: TMenuItem [7]
        Action = actTranslateWord
      end
      object miLine803: TMenuItem [8]
        Caption = '-'
      end
      object miTranslateMessage: TMenuItem [9]
        Action = actTranslateMessage
      end
      object miTranslateObject: TMenuItem [10]
        Action = actTranslateObject
      end
      object miLine804: TMenuItem [11]
        Caption = '-'
      end
      object miImportType: TMenuItem [12]
        Action = actImportType
      end
      object miImportSettings: TMenuItem [13]
        Action = actImportSettings
      end
      object miLine805: TMenuItem [14]
        Caption = '-'
      end
      object N20: TMenuItem [15]
        Action = actForms
      end
      object miHelp: TMenuItem [16]
        Action = mactHelp
      end
      inherited miProtocolAll: TMenuItem [17]
        inherited miProtocol: TMenuItem
          Enabled = False
          Visible = False
        end
        inherited miMovementProtocol: TMenuItem
          Enabled = False
          Visible = False
        end
      end
    end
  end
  inherited frxXLSExport: TfrxXLSExport
    Left = 152
    Top = 129
  end
  object spGet_Object_Form_HelpFile: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Form_HelpFile'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inFormName'
        Value = 'TMainForm'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outHelpFile'
        Value = Null
        Component = FormParams
        ComponentItem = 'HelpFile'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 480
    Top = 57
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'HelpFile'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'IP_str'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 578
    Top = 121
  end
end
