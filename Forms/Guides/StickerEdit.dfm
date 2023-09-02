object StickerEditForm: TStickerEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1069#1090#1080#1082#1077#1090#1082#1091'>'
  ClientHeight = 395
  ClientWidth = 687
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxLabel1: TcxLabel
    Left = 19
    Top = 261
    Caption = #1059#1075#1083#1077#1074#1086#1076#1080' <='
  end
  object cxButton1: TcxButton
    Left = 403
    Top = 359
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 1
  end
  object cxButton2: TcxButton
    Left = 544
    Top = 359
    Width = 75
    Height = 25
    Action = dsdFormClose1
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 2
  end
  object cxLabel5: TcxLabel
    Left = 19
    Top = 46
    Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100': '#1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100' / '#1070#1088'. '#1083#1080#1094#1086' / '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
  end
  object edJuridical: TcxButtonEdit
    Left = 19
    Top = 63
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 312
  end
  object cxLabel6: TcxLabel
    Left = 19
    Top = 89
    Caption = #1058#1086#1074#1072#1088
  end
  object edGoods: TcxButtonEdit
    Left = 19
    Top = 106
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 312
  end
  object cxLabel7: TcxLabel
    Left = 346
    Top = 261
    Caption = #1064#1040#1041#1051#1054#1053' ('#1080#1085#1076#1080#1074#1080#1076#1091#1072#1083#1100#1085#1099#1081')'
  end
  object edStickerFile: TcxButtonEdit
    Left = 346
    Top = 276
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 148
  end
  object edComment: TcxTextEdit
    Left = 346
    Top = 316
    TabOrder = 9
    Width = 327
  end
  object cxLabel8: TcxLabel
    Left = 348
    Top = 300
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceValue1: TcxCurrencyEdit
    Left = 19
    Top = 276
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 11
    Width = 87
  end
  object Код: TcxLabel
    Left = 19
    Top = 4
    Caption = #1050#1086#1076' '#1069#1090#1080#1082#1077#1090#1082#1080
  end
  object ceCode: TcxCurrencyEdit
    Left = 19
    Top = 20
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 153
  end
  object cxLabel4: TcxLabel
    Left = 119
    Top = 261
    Caption = #1041#1077#1083#1082#1080' >='
  end
  object ceValue2: TcxCurrencyEdit
    Left = 119
    Top = 276
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 15
    Width = 87
  end
  object cxLabel9: TcxLabel
    Left = 216
    Top = 261
    Caption = #1046#1080#1088#1099' <='
  end
  object ceValue3: TcxCurrencyEdit
    Left = 216
    Top = 276
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 17
    Width = 87
  end
  object cxLabel10: TcxLabel
    Left = 19
    Top = 301
    Caption = #1082#1050#1072#1083#1086#1088
  end
  object ceValue4: TcxCurrencyEdit
    Left = 19
    Top = 316
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 19
    Width = 87
  end
  object cxLabel11: TcxLabel
    Left = 119
    Top = 301
    Caption = #1082#1044#1078
  end
  object ceValue5: TcxCurrencyEdit
    Left = 119
    Top = 316
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 21
    Width = 87
  end
  object cxLabel2: TcxLabel
    Left = 19
    Top = 134
    Caption = #1042#1080#1076' ('#1043#1088#1091#1087#1087#1072')'
  end
  object edStickerGroup: TcxButtonEdit
    Left = 19
    Top = 151
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 23
    Width = 153
  end
  object cxLabel3: TcxLabel
    Left = 178
    Top = 134
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1088#1086#1076#1091#1082#1090#1072
  end
  object edStickerTag: TcxButtonEdit
    Left = 178
    Top = 151
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 25
    Width = 153
  end
  object cxLabel12: TcxLabel
    Left = 19
    Top = 174
    Caption = #1057#1086#1088#1090#1085#1086#1089#1090#1100
  end
  object edStickerSort: TcxButtonEdit
    Left = 19
    Top = 192
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 27
    Width = 153
  end
  object cxLabel13: TcxLabel
    Left = 178
    Top = 174
    Caption = #1057#1087#1086#1089#1086#1073' '#1080#1079#1075#1086#1090#1086#1074#1083#1077#1085#1080#1103
  end
  object edStickerType: TcxButtonEdit
    Left = 178
    Top = 192
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 29
    Width = 153
  end
  object cxLabel14: TcxLabel
    Left = 19
    Top = 217
    Caption = #1058#1059' '#1080#1083#1080' '#1044#1057#1058#1059
  end
  object edStickerNorm: TcxButtonEdit
    Left = 19
    Top = 233
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 31
    Width = 312
  end
  object ceInfo: TcxMemo
    Left = 352
    Top = 17
    TabOrder = 32
    Height = 239
    Width = 327
  end
  object cxLabel15: TcxLabel
    Left = 346
    Top = 0
    Caption = #1057#1086#1089#1090#1072#1074' '#1087#1088#1086#1076#1091#1082#1090#1072
  end
  object cxLabel16: TcxLabel
    Left = 19
    Top = 344
    Hint = #1079' '#1085#1080#1093' '#1085#1072#1089#1080#1095#1077#1085#1110' ('#1078#1080#1088#1080')'
    Caption = #1079' '#1085#1080#1093' '#1085#1072#1089#1080#1095#1077#1085#1110
    ParentShowHint = False
    ShowHint = True
  end
  object ceValue6: TcxCurrencyEdit
    Left = 19
    Top = 359
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 35
    Width = 87
  end
  object ceValue7: TcxCurrencyEdit
    Left = 119
    Top = 359
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 36
    Width = 87
  end
  object cxLabel17: TcxLabel
    Left = 119
    Top = 344
    Caption = #1094#1091#1082#1088#1080
  end
  object cxLabel18: TcxLabel
    Left = 216
    Top = 344
    Caption = #1089#1110#1083#1100
  end
  object ceValue8: TcxCurrencyEdit
    Left = 216
    Top = 359
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 39
    Width = 87
  end
  object cxLabel19: TcxLabel
    Left = 502
    Top = 261
    Caption = #1064#1040#1041#1051#1054#1053' 70_70 ('#1080#1085#1076#1080#1074#1080#1076#1091#1072#1083#1100#1085#1099#1081')'
  end
  object edStickerFile_70_70: TcxButtonEdit
    Left = 502
    Top = 276
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 41
    Width = 171
  end
  object ActionList: TActionList
    Left = 305
    Top = 40
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
    object dsdFormClose1: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
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
      Caption = #1054#1082
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Sticker'
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
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = ceCode
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
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStickerFileId'
        Value = ''
        Component = GuidesStickerFile
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStickerFileId_70_70'
        Value = Null
        Component = GuidesStickerFile_70_70
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStickerGroupName'
        Value = 0.000000000000000000
        Component = edStickerGroup
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStickerTypeName'
        Value = 0.000000000000000000
        Component = edStickerType
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStickerTagName'
        Value = Null
        Component = edStickerTag
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStickerSortName'
        Value = Null
        Component = edStickerSort
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStickerNormName'
        Value = Null
        Component = edStickerNorm
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfo'
        Value = Null
        Component = ceInfo
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue1'
        Value = 0.000000000000000000
        Component = ceValue1
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue2'
        Value = Null
        Component = ceValue2
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue3'
        Value = Null
        Component = ceValue3
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue4'
        Value = Null
        Component = ceValue4
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue5'
        Value = Null
        Component = ceValue5
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue6'
        Value = Null
        Component = ceValue6
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue7'
        Value = Null
        Component = ceValue7
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue8'
        Value = Null
        Component = ceValue8
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 304
    Top = 40
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
        Name = 'inMaskId'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 240
    Top = 8
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Sticker'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMaskId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMaskId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
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
        Name = 'JuridicalId'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = ''
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
        Name = 'StickerFileId'
        Value = ''
        Component = GuidesStickerFile
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StickerFileName'
        Value = ''
        Component = GuidesStickerFile
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StickerGroupId'
        Value = 0.000000000000000000
        Component = GuidesStickerGroup
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StickerGroupName'
        Value = Null
        Component = GuidesStickerGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StickerNormId'
        Value = Null
        Component = GuidesStickerNorm
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StickerNormName'
        Value = Null
        Component = GuidesStickerNorm
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StickerSortId'
        Value = Null
        Component = GuidesStickerSort
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StickerSortName'
        Value = Null
        Component = GuidesStickerSort
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StickerTagId'
        Value = Null
        Component = GuidesStickerTag
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StickerTagName'
        Value = Null
        Component = GuidesStickerTag
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StickerTypeId'
        Value = Null
        Component = GuidesStickerType
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StickerTypeName'
        Value = Null
        Component = GuidesStickerType
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value1'
        Value = 0.000000000000000000
        Component = ceValue1
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value2'
        Value = Null
        Component = ceValue2
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value3'
        Value = Null
        Component = ceValue3
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value4'
        Value = Null
        Component = ceValue4
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value5'
        Value = Null
        Component = ceValue5
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value6'
        Value = Null
        Component = ceValue6
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value7'
        Value = Null
        Component = ceValue7
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value8'
        Value = Null
        Component = ceValue8
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isInfo'
        Value = Null
        Component = ceInfo
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StickerFileId_70_70'
        Value = Null
        Component = GuidesStickerFile_70_70
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StickerFileName_70_70'
        Value = Null
        Component = GuidesStickerFile_70_70
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 281
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
    Left = 104
    Top = 16
  end
  object dsdUserSettingsStorageAddOn1: TdsdUserSettingsStorageAddOn
    Left = 304
    Top = 8
  end
  object GuidesJuridical: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridicalRetailPartner_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalRetailPartner_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 71
  end
  object GuidesGoods: TdsdGuides
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
        Component = GuidesGoods
        ComponentItem = 'Key'
        DataType = ftString
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
      end>
    Left = 176
    Top = 95
  end
  object GuidesStickerFile: TdsdGuides
    KeyField = 'Id'
    LookupControl = edStickerFile
    FormNameParam.Value = 'TStickerFileForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TStickerFileForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesStickerFile
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesStickerFile
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 407
    Top = 267
  end
  object GuidesStickerGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edStickerGroup
    FormNameParam.Value = 'TStickerGroupForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TStickerGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesStickerGroup
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesStickerGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 88
    Top = 132
  end
  object GuidesStickerTag: TdsdGuides
    KeyField = 'Id'
    LookupControl = edStickerTag
    FormNameParam.Value = 'TStickerTagForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TStickerTagForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesStickerTag
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesStickerTag
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 232
    Top = 144
  end
  object GuidesStickerSort: TdsdGuides
    KeyField = 'Id'
    LookupControl = edStickerSort
    FormNameParam.Value = 'TStickerSortForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TStickerSortForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesStickerSort
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesStickerSort
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 56
    Top = 170
  end
  object GuidesStickerType: TdsdGuides
    KeyField = 'Id'
    LookupControl = edStickerType
    FormNameParam.Value = 'TStickerTypeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TStickerTypeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesStickerType
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesStickerType
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 224
    Top = 178
  end
  object GuidesStickerNorm: TdsdGuides
    KeyField = 'Id'
    LookupControl = edStickerNorm
    FormNameParam.Value = 'TStickerNormForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TStickerNormForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesStickerNorm
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesStickerNorm
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 104
    Top = 229
  end
  object GuidesStickerFile_70_70: TdsdGuides
    KeyField = 'Id'
    LookupControl = edStickerFile_70_70
    FormNameParam.Value = 'TStickerFileForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TStickerFileForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesStickerFile_70_70
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesStickerFile_70_70
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 579
    Top = 259
  end
end
