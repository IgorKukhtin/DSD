object RetailEditForm: TRetailEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100'>'
  ClientHeight = 441
  ClientWidth = 347
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.Params = dsdFormParams
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 10
    Top = 72
    TabOrder = 0
    Width = 311
  end
  object cxLabel1: TcxLabel
    Left = 10
    Top = 53
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 55
    Top = 407
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 207
    Top = 407
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
  end
  object cxLabel2: TcxLabel
    Left = 10
    Top = 11
    Caption = #1050#1086#1076
  end
  object edCode: TcxCurrencyEdit
    Left = 10
    Top = 30
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 71
  end
  object cxLabel3: TcxLabel
    Left = 10
    Top = 98
    Caption = #1050#1086#1076' GLN '#1055#1086#1083#1091#1095#1072#1090#1077#1083#1100
  end
  object edGLNCode: TcxTextEdit
    Left = 10
    Top = 118
    TabOrder = 7
    Width = 311
  end
  object cxLabel4: TcxLabel
    Left = 10
    Top = 236
    Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1072
  end
  object ceGoodsProperty: TcxButtonEdit
    Left = 10
    Top = 257
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 311
  end
  object cxLabel5: TcxLabel
    Left = 10
    Top = 144
    Caption = #1050#1086#1076' GLN '#1055#1086#1089#1090#1072#1074#1097#1080#1082' '
  end
  object edGLNCodeCorporate: TcxTextEdit
    Left = 10
    Top = 164
    TabOrder = 11
    Width = 311
  end
  object cbOperDateOrder: TcxCheckBox
    Left = 87
    Top = 30
    Caption = #1094#1077#1085#1072' '#1087#1086' '#1076#1072#1090#1077' '#1079#1072#1103#1074#1082#1080
    TabOrder = 12
    Width = 129
  end
  object cxLabel6: TcxLabel
    Left = 10
    Top = 287
    Caption = #1054#1090#1074'. '#1089#1086#1090#1088#1091#1076#1085#1080#1082' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1086#1075#1086' '#1086#1090#1076#1077#1083#1072
  end
  object cePersonalMarketing: TcxButtonEdit
    Left = 8
    Top = 310
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 14
    Width = 311
  end
  object cxLabel7: TcxLabel
    Left = 10
    Top = 343
    Caption = #1054#1090#1074'. '#1089#1086#1090#1088#1091#1076#1085#1080#1082' '#1082#1086#1084#1084#1077#1088#1095#1077#1089#1082#1086#1075#1086' '#1086#1090#1076#1077#1083#1072
  end
  object cePersonalTrade: TcxButtonEdit
    Left = 8
    Top = 366
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 16
    Width = 311
  end
  object cxLabel8: TcxLabel
    Left = 10
    Top = 189
    Caption = #1054#1050#1055#1054' '#1076#1083#1103' '#1085#1072#1083#1086#1075'. '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
  end
  object edOKPO: TcxTextEdit
    Left = 10
    Top = 209
    TabOrder = 18
    Width = 156
  end
  object cxLabel9: TcxLabel
    Left = 177
    Top = 189
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1077#1081
  end
  object edClientKind: TcxButtonEdit
    Left = 177
    Top = 209
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 20
    Width = 144
  end
  object ceRoundWeight: TcxCurrencyEdit
    Left = 226
    Top = 30
    Hint = #1050#1086#1083'-'#1074#1086' '#1079#1085#1072#1082#1086#1074' '#1076#1083#1103' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1103' '#1074#1077#1089#1072
    ParentShowHint = False
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.EditFormat = '0'
    ShowHint = True
    TabOrder = 21
    Width = 95
  end
  object cxLabel10: TcxLabel
    Left = 225
    Top = 11
    Caption = #1050#1086#1083'. '#1079#1085'. '#1086#1082#1088'. '#1074#1077#1089#1072
  end
  object ActionList: TActionList
    Left = 152
    Top = 56
    object dsdDataSetRefresh: TdsdDataSetRefresh
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
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
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
    object dsdFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Retail'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = edCode
        ParamType = ptInput
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
        Name = 'inOperDateOrder'
        Value = Null
        Component = cbOperDateOrder
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGLNCode'
        Value = ''
        Component = edGLNCode
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGLNCodeCorporate'
        Value = Null
        Component = edGLNCodeCorporate
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOKPO'
        Value = Null
        Component = edOKPO
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsPropertyId'
        Value = Null
        Component = GuidesGoodsProperty
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalMarketingId'
        Value = Null
        Component = GuidesPersonalMarketing
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalTradeId'
        Value = Null
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inClientKindId'
        Value = Null
        Component = GuidesClientKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRoundWeight'
        Value = Null
        Component = ceRoundWeight
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 56
    Top = 64
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 88
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Retail'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = edCode
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
        Name = 'OperDateOrder'
        Value = Null
        Component = cbOperDateOrder
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'GLNCode'
        Value = ''
        Component = edGLNCode
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GLNCodeCorporate'
        Value = Null
        Component = edGLNCodeCorporate
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OKPO'
        Value = Null
        Component = edOKPO
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsPropertyId'
        Value = Null
        Component = GuidesGoodsProperty
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsPropertyName'
        Value = Null
        Component = GuidesGoodsProperty
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalMarketingId'
        Value = Null
        Component = GuidesPersonalMarketing
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalMarketingName'
        Value = Null
        Component = GuidesPersonalMarketing
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalTradeId'
        Value = Null
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalTradeName'
        Value = Null
        Component = GuidesPersonalTrade
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ClientKindId'
        Value = Null
        Component = GuidesClientKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ClientKindName'
        Value = Null
        Component = GuidesClientKind
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RoundWeight'
        Value = Null
        Component = ceRoundWeight
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 224
    Top = 128
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
    Left = 200
    Top = 72
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 256
    Top = 48
  end
  object GuidesGoodsProperty: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoodsProperty
    FormNameParam.Value = 'TGoodsPropertyForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsPropertyForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsProperty
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsProperty
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 235
  end
  object GuidesPersonalMarketing: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePersonalMarketing
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalMarketing
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalMarketing
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 151
    Top = 290
  end
  object GuidesPersonalTrade: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePersonalTrade
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalTrade
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 175
    Top = 346
  end
  object GuidesClientKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edClientKind
    FormNameParam.Value = 'TClientKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TClientKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesClientKind
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesClientKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 239
    Top = 203
  end
end
