object ProductEditForm: TProductEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1051#1086#1076#1082#1080'>'
  ClientHeight = 523
  ClientWidth = 590
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actDataSetRefresh
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 10
    Top = 393
    TabOrder = 0
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 10
    Top = 375
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 32
    Top = 485
    Width = 75
    Height = 25
    Action = actInsertUpdateGuides
    Default = True
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 176
    Top = 485
    Width = 75
    Height = 25
    Action = actFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
  end
  object cxLabel2: TcxLabel
    Left = 10
    Top = 8
    Caption = 'Interne Nr'
  end
  object edCode: TcxCurrencyEdit
    Left = 10
    Top = 30
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = False
    TabOrder = 5
    Width = 132
  end
  object cxLabel3: TcxLabel
    Left = 10
    Top = 423
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object edComment: TcxTextEdit
    Left = 10
    Top = 443
    TabOrder = 7
    Width = 273
  end
  object cxLabel6: TcxLabel
    Left = 10
    Top = 330
    Hint = #1053#1072#1095#1072#1083#1086' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072
    Caption = #1053#1072#1095#1072#1083#1086' '#1087#1088#1086#1080#1079#1074'.'
    ParentShowHint = False
    ShowHint = True
  end
  object edHours: TcxCurrencyEdit
    Left = 151
    Top = 305
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 9
    Width = 132
  end
  object cxLabel4: TcxLabel
    Left = 105
    Top = 330
    Hint = #1042#1074#1086#1076' '#1074' '#1101#1082#1089#1087#1083#1091#1072#1090#1072#1094#1080#1102
    Caption = #1042#1074#1086#1076' '#1074' '#1101#1082#1089#1087#1083'.'
    ParentShowHint = False
    ShowHint = True
  end
  object cxLabel5: TcxLabel
    Left = 201
    Top = 330
    Hint = #1055#1088#1086#1076#1072#1078#1072
    Caption = #1055#1088#1086#1076#1072#1078#1072
  end
  object cxLabel7: TcxLabel
    Left = 151
    Top = 284
    Caption = #1055#1086#1089#1083'. '#1074#1088#1077#1084#1103' '#1086#1073#1089#1083#1091#1078'.,'#1095'.'
  end
  object cxLabel9: TcxLabel
    Left = 10
    Top = 63
    Caption = 'CIN Nr.'
  end
  object edDateStart: TcxDateEdit
    Left = 10
    Top = 350
    EditValue = 42160d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 14
    Width = 82
  end
  object edDateBegin: TcxDateEdit
    Left = 105
    Top = 350
    EditValue = 42160d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 15
    Width = 82
  end
  object edDateSale: TcxDateEdit
    Left = 201
    Top = 350
    EditValue = 42160d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 16
    Width = 82
  end
  object edCIN: TcxTextEdit
    Left = 10
    Top = 81
    TabOrder = 17
    Width = 209
  end
  object cxLabel10: TcxLabel
    Left = 10
    Top = 285
    Caption = 'Engine Nr.'
  end
  object edEngineNum: TcxTextEdit
    Left = 10
    Top = 305
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 132
  end
  object cxLabel11: TcxLabel
    Left = 10
    Top = 195
    Caption = 'Brand'
  end
  object edBrand: TcxButtonEdit
    Left = 10
    Top = 215
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 21
    Width = 273
  end
  object cxLabel12: TcxLabel
    Left = 10
    Top = 102
    Caption = 'Model'
  end
  object edModel: TcxButtonEdit
    Left = 10
    Top = 121
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 23
    Width = 273
  end
  object cxLabel13: TcxLabel
    Left = 10
    Top = 241
    Caption = 'Engine'
  end
  object edEngine: TcxButtonEdit
    Left = 10
    Top = 261
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 25
    Width = 273
  end
  object cbBasicConf: TcxCheckBox
    Left = 151
    Top = 5
    Caption = 'Basic Conf'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlue
    Style.Font.Height = -16
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
    TabOrder = 26
    Width = 132
  end
  object cbProdColorPattern: TcxCheckBox
    Left = 151
    Top = 37
    Caption = 'Add Boat Structure'
    TabOrder = 27
    Width = 132
  end
  object cxLabel14: TcxLabel
    Left = 10
    Top = 149
    Caption = #1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080' '#1052#1086#1076#1077#1083#1080
  end
  object edReceiptProdModel: TcxButtonEdit
    Left = 10
    Top = 168
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 29
    Width = 273
  end
  object edDiscountNextTax: TcxCurrencyEdit
    Left = 418
    Top = 168
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 30
    Width = 80
  end
  object cxLabel15: TcxLabel
    Left = 418
    Top = 149
    Hint = '% '#1089#1082'. ('#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081')'
    Caption = '% '#1089#1082'. ('#1076#1086#1087'.)'
    ParentShowHint = False
    ShowHint = True
  end
  object cxLabel16: TcxLabel
    Left = 331
    Top = 148
    Caption = '% '#1089#1082'. ('#1086#1089#1085'-'#1086#1081')'
  end
  object edClienttext: TcxLabel
    Left = 331
    Top = 102
    Hint = #1050#1083#1080#1077#1085#1090
    Caption = 'Kunden'
    ParentShowHint = False
    ShowHint = True
  end
  object edClient: TcxButtonEdit
    Left = 331
    Top = 121
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 34
    Width = 239
  end
  object edDiscountTax: TcxCurrencyEdit
    Left = 331
    Top = 168
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 35
    Width = 79
  end
  object cxLabel8: TcxLabel
    Left = 331
    Top = 8
    Caption = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072
  end
  object cxLabel17: TcxLabel
    Left = 331
    Top = 63
    Caption = #8470' '#1076#1086#1082'.'
  end
  object edInvNumberOrderClient: TcxTextEdit
    Left = 331
    Top = 81
    Properties.ReadOnly = True
    TabOrder = 38
    Width = 114
  end
  object cxLabel18: TcxLabel
    Left = 456
    Top = 63
    Caption = #1044#1072#1090#1072
  end
  object edOperDateOrderClient: TcxDateEdit
    Left = 456
    Top = 81
    EditValue = 42160d
    Properties.ReadOnly = False
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 40
    Width = 114
  end
  object Panel1: TPanel
    Left = 553
    Top = 26
    Width = 63
    Height = 49
    Caption = 'Panel1'
    TabOrder = 41
    Visible = False
    object dxBarDockControl3: TdxBarDockControl
      Left = 1
      Top = 1
      Width = 238
      Height = 26
      Align = dalNone
      BarManager = BarManager
    end
  end
  object ceStatus: TcxButtonEdit
    Left = 331
    Top = 30
    Properties.Buttons = <
      item
        Action = CompleteMovement
        Kind = bkGlyph
      end
      item
        Action = UnCompleteMovement
        Default = True
        Kind = bkGlyph
      end
      item
        Action = DeleteMovement
        Kind = bkGlyph
      end>
    Properties.Images = dmMain.ImageList
    Properties.ReadOnly = True
    TabOrder = 43
    Width = 216
  end
  object cxLabel19: TcxLabel
    Left = 331
    Top = 195
    Caption = #1057#1091#1084#1084#1072' c '#1053#1044#1057
  end
  object edTotalSummPVAT: TcxCurrencyEdit
    Left = 331
    Top = 215
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 45
    Width = 80
  end
  object cxLabel20: TcxLabel
    Left = 418
    Top = 195
    Caption = #1057#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057
  end
  object edTotalSummMVAT: TcxCurrencyEdit
    Left = 418
    Top = 215
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 47
    Width = 80
  end
  object cxLabel21: TcxLabel
    Left = 504
    Top = 195
    Caption = #1057#1091#1084#1084#1072' '#1053#1044#1057
  end
  object edTotalSummVAT: TcxCurrencyEdit
    Left = 504
    Top = 215
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 48
    Width = 66
  end
  object ceStatusInvoice: TcxButtonEdit
    Left = 331
    Top = 261
    Properties.Buttons = <
      item
        Action = CompleteMovementInvoice
        Kind = bkGlyph
      end
      item
        Action = UnCompleteMovementInvoice
        Default = True
        Kind = bkGlyph
      end
      item
        Action = DeleteMovementInvoice
        Kind = bkGlyph
      end>
    Properties.Images = dmMain.ImageList
    Properties.ReadOnly = True
    TabOrder = 51
    Width = 239
  end
  object cxLabel22: TcxLabel
    Left = 331
    Top = 241
    Caption = #1057#1090#1072#1090#1091#1089' (Invoice)'
  end
  object cxLabel23: TcxLabel
    Left = 456
    Top = 285
    Caption = #1044#1072#1090#1072' (Invoice)'
  end
  object edOperDateInvoice: TcxDateEdit
    Left = 456
    Top = 305
    EditValue = 42160d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 53
    Width = 114
  end
  object cxLabel24: TcxLabel
    Left = 331
    Top = 285
    Caption = #8470' '#1076#1086#1082'. (Invoice)'
  end
  object edInvNumberInvoice: TcxTextEdit
    Left = 331
    Top = 305
    Properties.ReadOnly = True
    TabOrder = 55
    Width = 114
  end
  object cxLabel25: TcxLabel
    Left = 331
    Top = 330
    Caption = 'Debet (Invoice)'
  end
  object ceAmountInInvoice: TcxCurrencyEdit
    Left = 331
    Top = 350
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 56
    Width = 114
  end
  object ceAmountInInvoiceAll: TcxCurrencyEdit
    Left = 456
    Top = 350
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 59
    Width = 114
  end
  object cxLabel26: TcxLabel
    Left = 456
    Top = 330
    Caption = 'Debet (Invoice All)'
  end
  object cxLabel27: TcxLabel
    Left = 331
    Top = 375
    Caption = 'Debet (BankAccount)'
  end
  object ceAmountInBankAccount: TcxCurrencyEdit
    Left = 331
    Top = 393
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    Properties.ReadOnly = True
    TabOrder = 60
    Width = 114
  end
  object ceAmountInBankAccountAll: TcxCurrencyEdit
    Left = 456
    Top = 393
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    Properties.ReadOnly = True
    TabOrder = 63
    Width = 114
  end
  object cxLabel28: TcxLabel
    Left = 456
    Top = 377
    Caption = 'Debet (BankAccount All)'
  end
  object cxLabel29: TcxLabel
    Left = 504
    Top = 149
    Caption = '% '#1053#1044#1057
  end
  object edVATPercentOrderClient: TcxCurrencyEdit
    Left = 504
    Top = 168
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    Properties.ReadOnly = True
    TabOrder = 65
    Width = 66
  end
  object cxLabel30: TcxLabel
    Left = 331
    Top = 425
    Caption = #1054#1089#1090'. '#1082' '#1086#1087#1083'. '#1087#1086' '#1089#1095#1077#1090#1072#1084
  end
  object edAmountIn_rem: TcxCurrencyEdit
    Left = 331
    Top = 443
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    Properties.ReadOnly = True
    TabOrder = 66
    Width = 114
  end
  object edAmountIn_remAll: TcxCurrencyEdit
    Left = 456
    Top = 443
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    Properties.ReadOnly = True
    TabOrder = 68
    Width = 114
  end
  object cxLabel31: TcxLabel
    Left = 456
    Top = 425
    Caption = #1054#1089#1090'. '#1082' '#1086#1087#1083#1072#1090#1077' ('#1080#1090#1086#1075#1086')'
  end
  object cxButton3: TcxButton
    Left = 225
    Top = 79
    Width = 58
    Height = 25
    Action = actGetCIN
    Default = True
    TabOrder = 73
  end
  object ActionList: TActionList
    Left = 232
    Top = 147
    object actDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'Ok'
    end
    object actFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
    object UnCompleteMovementInvoice: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatusInvoice
      StoredProcList = <
        item
          StoredProc = spChangeStatusInvoice
        end
        item
        end
        item
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 11
      Status = mtUncomplete
      Guides = GuidesStatusInvoice
    end
    object actGetCIN: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGetCIN
      StoredProcList = <
        item
          StoredProc = spGetCIN
        end>
      Caption = 'get CIN'
      Hint = #1056#1072#1089#1089#1095#1080#1090#1072#1090#1100' CIN Nr.'
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object CompleteMovementInvoice: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatusInvoice
      StoredProcList = <
        item
          StoredProc = spChangeStatusInvoice
        end
        item
        end
        item
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 12
      Status = mtComplete
      Guides = GuidesStatusInvoice
    end
    object UnCompleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end
        item
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 11
      Status = mtUncomplete
      Guides = GuidesStatus
    end
    object DeleteMovementInvoice: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatusInvoice
      StoredProcList = <
        item
          StoredProc = spChangeStatusInvoice
        end
        item
        end
        item
        end>
      Caption = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      Hint = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      ImageIndex = 13
      Status = mtDelete
      Guides = GuidesStatusInvoice
    end
    object CompleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end
        item
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 12
      Status = mtComplete
      Guides = GuidesStatus
    end
    object DeleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end
        item
        end>
      Caption = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      Hint = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      ImageIndex = 13
      Status = mtDelete
      Guides = GuidesStatus
    end
    object actUnComplete: TdsdChangeMovementStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 11
      Status = mtUncomplete
    end
    object actComplete: TdsdChangeMovementStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 12
      Status = mtComplete
    end
    object actSetErased: TdsdChangeMovementStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      Hint = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      ImageIndex = 13
      Status = mtDelete
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Product'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCode'
        Value = 0.000000000000000000
        Component = edCode
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBrandId'
        Value = Null
        Component = GuidesBrand
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inModelId'
        Value = Null
        Component = GuidesModel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEngineId'
        Value = Null
        Component = GuidesProdEngine
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptProdModelId'
        Value = Null
        Component = GuidesReceiptProdModel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inClientId'
        Value = Null
        Component = GuidesClient
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsBasicConf'
        Value = Null
        Component = cbBasicConf
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsProdColorPattern'
        Value = Null
        Component = cbProdColorPattern
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHours'
        Value = Null
        Component = edHours
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscountTax'
        Value = Null
        Component = edDiscountTax
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscountNextTax'
        Value = Null
        Component = edDiscountNextTax
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateStart'
        Value = Null
        Component = edDateStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateBegin'
        Value = Null
        Component = edDateBegin
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateSale'
        Value = Null
        Component = edDateSale
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCIN'
        Value = Null
        Component = edCIN
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEngineNum'
        Value = Null
        Component = edEngineNum
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMovementId_OrderClient'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber_OrderClient'
        Value = Null
        Component = edInvNumberOrderClient
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate_OrderClient'
        Value = Null
        Component = edOperDateOrderClient
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Invoice'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMovementId_Invoice'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber_Invoice'
        Value = Null
        Component = edInvNumberInvoice
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate_Invoice'
        Value = Null
        Component = edOperDateInvoice
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountIn_Invoice'
        Value = Null
        Component = ceAmountInInvoice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountOut_Invoice'
        Value = Null
        Component = ceAmountInInvoiceAll
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 96
    Top = 48
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_OrderClient'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Invoice'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 8
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Product'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMovementId_OrderClient'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = edCode
        DataType = ftUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'Hours'
        Value = Null
        Component = edHours
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateStart'
        Value = Null
        Component = edDateStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateBegin'
        Value = Null
        Component = edDateBegin
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateSale'
        Value = Null
        Component = edDateSale
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'CIN'
        Value = Null
        Component = edCIN
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'EngineNum'
        Value = Null
        Component = edEngineNum
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BrandId'
        Value = Null
        Component = GuidesBrand
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BrandName'
        Value = Null
        Component = GuidesBrand
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ModelId'
        Value = Null
        Component = GuidesModel
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ModelName'
        Value = Null
        Component = GuidesModel
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ModelName_full'
        Value = Null
        Component = FormParams
        ComponentItem = 'ModelName_full'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'EngineId'
        Value = Null
        Component = GuidesProdEngine
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'EngineName'
        Value = Null
        Component = GuidesProdEngine
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isBasicConf'
        Value = Null
        Component = cbBasicConf
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isProdColorPattern'
        Value = Null
        Component = cbProdColorPattern
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReceiptProdModelId'
        Value = Null
        Component = GuidesReceiptProdModel
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReceiptProdModelName'
        Value = Null
        Component = GuidesReceiptProdModel
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ClientId'
        Value = Null
        Component = GuidesClient
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ClientName'
        Value = Null
        Component = GuidesClient
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountTax'
        Value = Null
        Component = edDiscountTax
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountNextTax'
        Value = Null
        Component = edDiscountNextTax
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_OrderClient'
        Value = Null
        Component = edInvNumberOrderClient
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate_OrderClient'
        Value = Null
        Component = edOperDateOrderClient
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode_OrderClient'
        Value = Null
        Component = GuidesStatus
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName_OrderClient'
        Value = Null
        Component = GuidesStatus
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent_OrderClient'
        Value = Null
        Component = edVATPercentOrderClient
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummMVAT'
        Value = Null
        Component = edTotalSummMVAT
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummPVAT'
        Value = Null
        Component = edTotalSummPVAT
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummVAT'
        Value = Null
        Component = edTotalSummVAT
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Invoice'
        Value = Null
        Component = edInvNumberInvoice
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate_Invoice'
        Value = Null
        Component = edOperDateInvoice
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode_Invoice'
        Value = Null
        Component = GuidesStatusInvoice
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName_Invoice'
        Value = Null
        Component = GuidesStatusInvoice
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountIn_Invoice'
        Value = Null
        Component = ceAmountInInvoice
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountIn_InvoiceAll'
        Value = Null
        Component = ceAmountInInvoiceAll
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountIn_BankAccount'
        Value = Null
        Component = ceAmountInBankAccount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountIn_BankAccountAll'
        Value = Null
        Component = ceAmountInBankAccountAll
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Invoice'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMovementId_Invoice'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountIn_rem'
        Value = Null
        Component = edAmountIn_rem
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountIn_remAll'
        Value = Null
        Component = edAmountIn_remAll
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 200
    Top = 48
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
    Left = 128
    Top = 441
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 248
    Top = 417
  end
  object GuidesBrand: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBrand
    FormNameParam.Value = 'TBrandForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBrandForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBrand
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBrand
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 95
    Top = 196
  end
  object GuidesModel: TdsdGuides
    KeyField = 'Id'
    LookupControl = edModel
    FormNameParam.Value = 'TProdModelForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TProdModelForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesModel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesModel
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BrandId'
        Value = Null
        Component = GuidesBrand
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BrandName'
        Value = Null
        Component = GuidesBrand
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdEngineId'
        Value = Null
        Component = GuidesProdEngine
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdEngineName'
        Value = Null
        Component = GuidesProdEngine
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReceiptProdModelId'
        Value = Null
        Component = GuidesReceiptProdModel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReceiptProdModelName'
        Value = Null
        Component = GuidesReceiptProdModel
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 183
    Top = 106
  end
  object GuidesProdEngine: TdsdGuides
    KeyField = 'Id'
    LookupControl = edEngine
    FormNameParam.Value = 'TProdEngineForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TProdEngineForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesProdEngine
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesProdEngine
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 136
    Top = 260
  end
  object GuidesReceiptProdModel: TdsdGuides
    KeyField = 'Id'
    LookupControl = edReceiptProdModel
    FormNameParam.Value = 'TReceiptProdModelForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TReceiptProdModelForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesReceiptProdModel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesReceiptProdModel
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BrandId'
        Value = ''
        Component = GuidesBrand
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BrandName'
        Value = ''
        Component = GuidesBrand
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdEngineId'
        Value = ''
        Component = GuidesProdEngine
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdEngineName'
        Value = ''
        Component = GuidesProdEngine
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ModelId'
        Value = Null
        Component = GuidesModel
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ModelName_full'
        Value = Null
        Component = FormParams
        ComponentItem = 'ModelName_full'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 103
    Top = 140
  end
  object GuidesClient: TdsdGuides
    KeyField = 'Id'
    LookupControl = edClient
    FormNameParam.Value = 'TClientForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TClientForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesClient
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesClient
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountTax'
        Value = Null
        Component = edDiscountTax
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 417
    Top = 104
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    ComponentList = <
      item
        Component = GuidesModel
      end
      item
        Component = edDateStart
      end>
    Left = 248
    Top = 8
  end
  object spGetCIN: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Product_CIN'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inModelId'
        Value = ''
        Component = GuidesModel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateStart'
        Value = 42160d
        Component = edDateStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCIN'
        Value = ''
        Component = edCIN
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 280
    Top = 96
  end
  object spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_OrderClient'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMovementId_OrderClient'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStatusCode'
        Value = ''
        Component = GuidesStatus
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 532
    Top = 62
  end
  object GuidesStatus: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceStatus
    FormNameParam.Value = ''
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 439
    Top = 22
  end
  object BarManager: TdxBarManager
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
    ImageOptions.Images = dmMain.ImageList
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 416
    Top = 1
    DockControlHeights = (
      0
      0
      0
      0)
    object BarManagerBar1: TdxBar
      Caption = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      CaptionButtons = <>
      DockControl = dxBarDockControl3
      DockedDockControl = dxBarDockControl3
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 651
      FloatTop = 377
      FloatClientWidth = 51
      FloatClientHeight = 44
      ItemLinks = <>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbCompleteMovement: TdxBarButton
      Action = CompleteMovement
      Category = 0
    end
    object bbDeleteMovement: TdxBarButton
      Action = DeleteMovement
      Category = 0
    end
    object bbDeleteDocument: TdxBarButton
      Action = UnCompleteMovement
      Category = 0
    end
  end
  object GuidesStatusInvoice: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceStatusInvoice
    DisableGuidesOpen = True
    FormNameParam.Value = ''
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 423
    Top = 246
  end
  object spChangeStatusInvoice: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Invoice'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMovementId_Invoice'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStatusCode'
        Value = ''
        Component = GuidesStatusInvoice
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 476
    Top = 222
  end
end
