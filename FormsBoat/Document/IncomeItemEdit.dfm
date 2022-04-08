object IncomeItemEditForm: TIncomeItemEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090' '#1087#1088#1080#1093#1086#1076#1072'>'
  ClientHeight = 288
  ClientWidth = 520
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxLabel1: TcxLabel
    Left = 148
    Top = 53
    Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
  end
  object cxButtonOK: TcxButton
    Left = 134
    Top = 247
    Width = 75
    Height = 25
    Action = actInsertUpdate
    TabOrder = 6
  end
  object cxButtonCancel: TcxButton
    Left = 287
    Top = 247
    Width = 75
    Height = 25
    Action = actFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 10
  end
  object edGoodsName: TcxButtonEdit
    Left = 148
    Top = 71
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 363
  end
  object cxLabel18: TcxLabel
    Left = 8
    Top = 99
    Caption = #1050#1086#1083'-'#1074#1086
  end
  object ceAmount: TcxCurrencyEdit
    Left = 8
    Top = 116
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 0
    Width = 54
  end
  object cxLabel2: TcxLabel
    Left = 69
    Top = 99
    Hint = #1042#1093'. '#1094#1077#1085#1072
    Caption = 'EK Netto'
    ParentShowHint = False
    ShowHint = True
  end
  object ceOperPrice_orig: TcxCurrencyEdit
    Left = 69
    Top = 116
    Hint = #1042#1093'. '#1094#1077#1085#1072' '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####; -,0.####; '
    Properties.EditFormat = ',0.####; -,0.####; '
    ShowHint = True
    TabOrder = 1
    Width = 64
  end
  object cxLabel8: TcxLabel
    Left = 431
    Top = 99
    Caption = 'Ladenpreis'
  end
  object ceOperPriceList: TcxCurrencyEdit
    Left = 431
    Top = 116
    Hint = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####; -,0.####; '
    Properties.EditFormat = ',0.####; -,0.####; '
    TabOrder = 9
    Width = 80
  end
  object cxLabel10: TcxLabel
    Left = 8
    Top = 237
    Caption = #1050#1086#1083'. '#1074' '#1094#1077#1085#1077
    Visible = False
  end
  object ceCountForPrice: TcxCurrencyEdit
    Left = 9
    Top = 252
    EditValue = 1.000000000000000000
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 16
    Visible = False
    Width = 73
  end
  object cxLabel12: TcxLabel
    Left = 148
    Top = 8
    Caption = 'Lieferanten'
  end
  object edFrom: TcxButtonEdit
    Left = 148
    Top = 26
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 364
  end
  object cxLabel14: TcxLabel
    Left = 8
    Top = 53
    Caption = 'Interne Nr'
  end
  object edGoodsCode: TcxTextEdit
    Left = 8
    Top = 71
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 125
  end
  object cxLabel3: TcxLabel
    Left = 8
    Top = 8
    Caption = 'Artikel Nr'
  end
  object edArticle: TcxTextEdit
    Left = 8
    Top = 26
    TabOrder = 21
    Width = 125
  end
  object ceDiscountTax: TcxCurrencyEdit
    Left = 8
    Top = 159
    Hint = '% '#1089#1082#1080#1076#1082#1080
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####; -,0.####; '
    Properties.EditFormat = ',0.####; -,0.####; '
    ShowHint = True
    TabOrder = 2
    Width = 125
  end
  object cxLabel4: TcxLabel
    Left = 8
    Top = 142
    Hint = '% '#1089#1082#1080#1076#1082#1080
    Caption = 'zus.Rabbat in %'
  end
  object cxLabel5: TcxLabel
    Left = 148
    Top = 142
    Hint = #1062#1077#1085#1072' '#1074#1093'. '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080' '#1074' '#1101#1083#1077#1084#1077#1085#1090#1077
    Caption = 'Buchungs EK'
  end
  object ceOperPrice: TcxCurrencyEdit
    Left = 148
    Top = 159
    Hint = #1042#1093'. '#1094#1077#1085#1072' '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####; -,0.####; '
    Properties.EditFormat = ',0.####; -,0.####; '
    ShowHint = True
    TabOrder = 3
    Width = 80
  end
  object cxLabel6: TcxLabel
    Left = 241
    Top = 142
    Hint = #1057#1091#1084#1084#1072' '#1074#1093'. '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080
    Caption = 'Gesamt EK'
  end
  object ceSummIn: TcxCurrencyEdit
    Left = 241
    Top = 159
    Hint = #1057#1091#1084#1084#1072' '#1074#1093'. '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####; -,0.####; '
    Properties.EditFormat = ',0.####; -,0.####; '
    ShowHint = True
    TabOrder = 4
    Width = 80
  end
  object ceEmpfPrice: TcxCurrencyEdit
    Left = 431
    Top = 159
    Hint = #1062#1077#1085#1072' '#1088#1077#1082#1086#1084#1077#1085#1076#1086#1074#1072#1085#1085#1072#1103' '#1073#1077#1079' '#1053#1044#1057
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####; -,0.####; '
    Properties.EditFormat = ',0.####; -,0.####; '
    TabOrder = 25
    Width = 80
  end
  object cxLabel7: TcxLabel
    Left = 431
    Top = 142
    Caption = 'Empf. VK'
  end
  object ceComment: TcxTextEdit
    Left = 148
    Top = 207
    TabOrder = 27
    Width = 363
  end
  object cxLabel16: TcxLabel
    Left = 148
    Top = 190
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object cePartNumber: TcxTextEdit
    Left = 8
    Top = 207
    Hint = #1057#1077#1088#1080#1081#1085#1099#1081' '#8470' '#1087#1086' '#1090#1077#1093' '#1087#1072#1089#1087#1086#1088#1090#1091
    TabOrder = 5
    Width = 125
  end
  object cxLabel9: TcxLabel
    Left = 8
    Top = 190
    Caption = 'S/N'
  end
  object ActionList: TActionList
    Left = 24
    Top = 20
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = 'actRefresh'
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actInsertUpdate: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = #1054#1082
    end
    object actFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
    object actRefresh_Price: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_MI_Income_Price
      StoredProcList = <
        item
          StoredProc = spGet_MI_Income_Price
        end>
      Caption = 'actRefresh_Price'
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Income'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = 2.000000000000000000
        Component = ceAmount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperPrice_orig'
        Value = 45.000000000000000000
        Component = ceOperPrice_orig
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountForPrice'
        Value = 1.000000000000000000
        Component = ceCountForPrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioDiscountTax'
        Value = Null
        Component = ceDiscountTax
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioOperPrice'
        Value = Null
        Component = ceOperPrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioSummIn'
        Value = Null
        Component = ceSummIn
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount_old'
        Value = Null
        Component = ceAmount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperPrice_orig_old'
        Value = Null
        Component = ceOperPrice_orig
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscountTax_old'
        Value = Null
        Component = ceDiscountTax
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperPrice_old'
        Value = Null
        Component = ceOperPrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummIn_old'
        Value = Null
        Component = ceSummIn
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperPriceList'
        Value = 55.000000000000000000
        Component = ceOperPriceList
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEmpfPrice'
        Value = Null
        Component = ceEmpfPrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartNumber'
        Value = Null
        Component = cePartNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 348
    Top = 57
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
        Name = 'MovementId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount_old'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperPrice_orig_old'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountTax_old'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperPrice_old'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummIn_old'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 232
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_MovementItem_Income'
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
        Name = 'inGoodsId'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsCode'
        Value = Null
        Component = edGoodsCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'Article'
        Value = Null
        Component = edArticle
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount'
        Value = Null
        Component = ceAmount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperPrice_orig'
        Value = Null
        Component = ceOperPrice_orig
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CountForPrice'
        Value = Null
        Component = ceCountForPrice
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountTax'
        Value = Null
        Component = ceDiscountTax
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperPrice'
        Value = Null
        Component = ceOperPrice
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummIn'
        Value = Null
        Component = ceSummIn
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperPriceList'
        Value = Null
        Component = ceOperPriceList
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'EmpfPrice'
        Value = Null
        Component = ceEmpfPrice
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartNumber'
        Value = Null
        Component = cePartNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount_old'
        Value = Null
        Component = FormParams
        ComponentItem = 'Amount_old'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperPrice_orig'
        Value = Null
        Component = FormParams
        ComponentItem = 'OperPrice_orig_old'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountTax'
        Value = Null
        Component = FormParams
        ComponentItem = 'DiscountTax_old'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperPrice'
        Value = Null
        Component = FormParams
        ComponentItem = 'OperPrice_old'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummIn'
        Value = Null
        Component = FormParams
        ComponentItem = 'SummIn_old'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 392
    Top = 97
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
    Left = 176
    Top = 41
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 408
    Top = 219
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsName
    FormNameParam.Value = 'TGoodsForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = Null
        Component = edGoodsCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'Article'
        Value = Null
        Component = edArticle
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'EKPrice'
        Value = Null
        Component = ceOperPrice_orig
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BasisPrice'
        Value = Null
        Component = ceOperPriceList
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'EmpfPrice'
        Value = Null
        Component = ceEmpfPrice
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 105
    Top = 47
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPartnerForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartnerForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 319
    Top = 15
  end
  object spGet_MI_Income_Price: TdsdStoredProc
    StoredProcName = 'gpGet_MI_Income_Price'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioAmount'
        Value = Null
        Component = ceAmount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioOperPrice_orig'
        Value = Null
        Component = ceOperPrice_orig
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountForPrice'
        Value = Null
        Component = ceCountForPrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioDiscountTax'
        Value = 0.000000000000000000
        Component = ceDiscountTax
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioOperPrice'
        Value = 0.000000000000000000
        Component = ceOperPrice
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioSummIn'
        Value = 0.000000000000000000
        Component = ceSummIn
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount_old'
        Value = Null
        Component = FormParams
        ComponentItem = 'Amount_old'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperPrice_orig_old'
        Value = Null
        Component = FormParams
        ComponentItem = 'OperPrice_orig_old'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscountTax_old'
        Value = Null
        Component = FormParams
        ComponentItem = 'DiscountTax_old'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperPrice_old'
        Value = Null
        Component = FormParams
        ComponentItem = 'OperPrice_old'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummIn_old'
        Value = Null
        Component = FormParams
        ComponentItem = 'SummIn_old'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmount'
        Value = Null
        Component = FormParams
        ComponentItem = 'Amount_old'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioOperPrice_orig'
        Value = Null
        Component = FormParams
        ComponentItem = 'OperPrice_orig_old'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioDiscountTax'
        Value = Null
        Component = FormParams
        ComponentItem = 'DiscountTax_old'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioOperPrice'
        Value = Null
        Component = FormParams
        ComponentItem = 'OperPrice_old'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioSummIn'
        Value = Null
        Component = FormParams
        ComponentItem = 'SummIn_old'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 416
    Top = 8
  end
  object spUpdate_Price: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_Income_Price'
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
        Name = 'inAmount'
        Value = Null
        Component = ceAmount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioOperPrice_orig'
        Value = Null
        Component = ceOperPrice_orig
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioDiscountTax'
        Value = Null
        Component = ceDiscountTax
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioOperPrice'
        Value = 0.000000000000000000
        Component = ceOperPrice
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioSummIn'
        Value = Null
        Component = ceSummIn
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperPriceList'
        Value = Null
        Component = ceOperPriceList
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 229
    Top = 94
  end
  object HeaderExit: THeaderExit
    ExitList = <
      item
        Control = ceAmount
      end
      item
        Control = ceOperPrice_orig
      end
      item
        Control = ceDiscountTax
      end
      item
        Control = ceOperPrice
      end
      item
        Control = ceSummIn
      end>
    Action = actRefresh_Price
    Left = 352
    Top = 156
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    GuidesList = <
      item
        Guides = GuidesGoods
      end>
    ActionItemList = <
      item
      end>
    Left = 136
    Top = 80
  end
  object EnterMoveNext: TEnterMoveNext
    EnterMoveNextList = <
      item
        Control = ceAmount
      end
      item
        Control = ceOperPrice_orig
      end
      item
        Control = ceDiscountTax
      end
      item
        Control = ceOperPrice
      end
      item
        Control = ceSummIn
      end
      item
        Control = cePartNumber
      end
      item
        Control = cxButtonOK
      end>
    Left = 336
    Top = 120
  end
end
