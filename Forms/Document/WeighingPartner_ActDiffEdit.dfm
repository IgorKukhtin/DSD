inherited WeighingPartner_ActDiffEditForm: TWeighingPartner_ActDiffEditForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077' ('#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090')>('#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077')'
  ClientHeight = 325
  ClientWidth = 426
  AddOnFormData.isSingle = False
  ExplicitWidth = 432
  ExplicitHeight = 354
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 79
    Top = 264
    Height = 26
    ExplicitLeft = 79
    ExplicitTop = 264
    ExplicitHeight = 26
  end
  inherited bbCancel: TcxButton
    Left = 220
    Top = 264
    Height = 26
    ExplicitLeft = 220
    ExplicitTop = 264
    ExplicitHeight = 26
  end
  object cxLabel1: TcxLabel [2]
    Left = 101
    Top = 8
    Caption = #1044#1072#1090#1072' ('#1089#1082#1083#1072#1076')'
  end
  object Код: TcxLabel [3]
    Left = 13
    Top = 8
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object edOperDate: TcxDateEdit [4]
    Left = 99
    Top = 27
    EditValue = 42092d
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 2
    Width = 80
  end
  object edInvNumber: TcxTextEdit [5]
    Left = 13
    Top = 27
    Properties.ReadOnly = True
    TabOrder = 5
    Text = '0'
    Width = 76
  end
  object cxLabel18: TcxLabel [6]
    Left = 13
    Top = 206
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object edComment: TcxTextEdit [7]
    Left = 13
    Top = 226
    TabOrder = 7
    Width = 396
  end
  object cbisReturnOut: TcxCheckBox [8]
    Left = 287
    Top = 173
    Caption = #1042#1086#1079#1074#1088#1072#1090
    TabOrder = 8
    Width = 85
  end
  object cxLabel26: TcxLabel [9]
    Left = 189
    Top = 8
    Caption = #8470' '#1076#1086#1082'. '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
  end
  object edInvNumberPartner: TcxTextEdit [10]
    Left = 189
    Top = 27
    TabOrder = 10
    Width = 108
  end
  object edAmountPartnerSecond: TcxCurrencyEdit [11]
    Left = 13
    Top = 132
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = False
    TabOrder = 11
    Width = 135
  end
  object cxLabel17: TcxLabel [12]
    Left = 13
    Top = 114
    Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086#1089#1090'.'
  end
  object cxLabel2: TcxLabel [13]
    Left = 159
    Top = 114
    Caption = #1062#1077#1085#1072' '#1087#1086#1089#1090'.'
  end
  object edPricePartner: TcxCurrencyEdit [14]
    Left = 159
    Top = 132
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = False
    TabOrder = 14
    Width = 117
  end
  object cxLabel3: TcxLabel [15]
    Left = 287
    Top = 114
    Caption = #1057#1091#1084#1084#1072' '#1087#1086#1089#1090'.'
  end
  object edSummPartner: TcxCurrencyEdit [16]
    Left = 287
    Top = 132
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = False
    TabOrder = 16
    Width = 122
  end
  object cbisAmountPartnerSecond: TcxCheckBox [17]
    Left = 13
    Top = 173
    Caption = #1055#1088#1080#1079#1085#1072#1082' "'#1073#1077#1079' '#1086#1087#1083#1072#1090#1099'"'
    TabOrder = 17
    Width = 134
  end
  object cbisPriceWithVAT: TcxCheckBox [18]
    Left = 159
    Top = 173
    Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057
    TabOrder = 18
    Width = 91
  end
  object cxLabel4: TcxLabel [19]
    Left = 13
    Top = 60
    Caption = #1058#1086#1074#1072#1088
  end
  object cxLabel5: TcxLabel [20]
    Left = 307
    Top = 60
    Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
  end
  object cxLabel25: TcxLabel [21]
    Left = 307
    Top = 8
    Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1091' '#1082#1086#1085#1090#1088'.'
  end
  object edOperDatePartner: TcxDateEdit [22]
    Left = 307
    Top = 27
    Hint = #1044#1072#1090#1072' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' '#1091' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
    EditValue = 42184d
    ParentShowHint = False
    Properties.SaveTime = False
    Properties.ShowTime = False
    ShowHint = True
    TabOrder = 22
    Width = 102
  end
  object edGoods: TcxButtonEdit [23]
    Left = 13
    Top = 79
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 23
    Width = 284
  end
  object edGoodsKind: TcxButtonEdit [24]
    Left = 307
    Top = 79
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 24
    Width = 102
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 72
    Top = 247
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 109
    Top = 259
  end
  inherited ActionList: TActionList
    Left = 219
    inherited InsertUpdateGuides: TdsdInsertUpdateGuides [0]
    end
    inherited actRefresh: TdsdDataSetRefresh [1]
    end
    inherited FormClose: TdsdFormClose [2]
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'MovementId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id_check'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 25
    Top = 262
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_WeighingPartner_ActDiff_Edit'
    Params = <
      item
        Name = 'inId'
        Value = 42184d
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inId_check'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id_check'
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
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = GoodsKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumberPartner'
        Value = Null
        Component = edInvNumberPartner
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDatePartner'
        Value = Null
        Component = edOperDatePartner
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountPartnerSecond'
        Value = 0.000000000000000000
        Component = edAmountPartnerSecond
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPricePartner'
        Value = ''
        Component = edPricePartner
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummPartner'
        Value = ''
        Component = edSummPartner
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPriceWithVAT'
        Value = False
        Component = cbisPriceWithVAT
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAmountPartnerSecond'
        Value = False
        Component = cbisAmountPartnerSecond
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisReturnOut'
        Value = Null
        Component = cbisReturnOut
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = ''
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 364
    Top = 254
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_MI_WeighingPartner_ActDiff_Edit'
    Params = <
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inId_check'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id_check'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = 0d
        Component = FormParams
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = ''
        Component = FormParams
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberPartner'
        Value = ''
        Component = edInvNumberPartner
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDatePartner'
        Value = Null
        Component = edOperDatePartner
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = Null
        Component = GoodsGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindId'
        Value = Null
        Component = GoodsKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindName'
        Value = ''
        Component = GoodsKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountPartnerSecond'
        Value = ''
        Component = edAmountPartnerSecond
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PricePartner'
        Value = 0.000000000000000000
        Component = edPricePartner
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummPartner'
        Value = 0.000000000000000000
        Component = edSummPartner
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAmountPartnerSecond'
        Value = ''
        Component = cbisAmountPartnerSecond
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPriceWithVAT'
        Value = ''
        Component = cbisPriceWithVAT
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isReturnOut'
        Value = False
        Component = cbisReturnOut
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = ''
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        MultiSelectSeparator = ','
      end>
    Left = 292
    Top = 262
  end
  object GoodsKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsKind
    FormNameParam.Value = 'TGoodsKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 344
    Top = 75
  end
  object GoodsGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoods_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoods_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 152
    Top = 59
  end
end
