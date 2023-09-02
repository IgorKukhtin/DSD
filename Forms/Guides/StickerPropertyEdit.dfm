object StickerPropertyEditForm: TStickerPropertyEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1057#1074#1086#1081#1089#1090#1074#1072' '#1101#1090#1080#1082#1077#1090#1082#1080'>'
  ClientHeight = 559
  ClientWidth = 349
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
    Top = 215
    Caption = #1042#1086#1083#1086#1075#1110#1089#1090#1100' '#1084#1110#1085
  end
  object cxButton1: TcxButton
    Left = 67
    Top = 522
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 1
  end
  object cxButton2: TcxButton
    Left = 208
    Top = 522
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
    Caption = #1069#1090#1080#1082#1077#1090#1082#1072
  end
  object edSticker: TcxButtonEdit
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
    Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
  end
  object edGoodsKind: TcxButtonEdit
    Left = 19
    Top = 106
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 153
  end
  object cxLabel7: TcxLabel
    Left = 19
    Top = 174
    Caption = #1064#1040#1041#1051#1054#1053
  end
  object edStickerFile: TcxButtonEdit
    Left = 19
    Top = 188
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 153
  end
  object edComment: TcxTextEdit
    Left = 19
    Top = 487
    TabOrder = 9
    Width = 312
  end
  object cxLabel8: TcxLabel
    Left = 19
    Top = 471
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceValue1: TcxCurrencyEdit
    Left = 19
    Top = 230
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 11
    Width = 153
  end
  object Код: TcxLabel
    Left = 19
    Top = 4
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 19
    Top = 20
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 13
    Width = 153
  end
  object cxLabel4: TcxLabel
    Left = 178
    Top = 215
    Caption = #1042#1086#1083#1086#1075#1110#1089#1090#1100' '#1084#1072#1082#1089
  end
  object ceValue2: TcxCurrencyEdit
    Left = 178
    Top = 230
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 15
    Width = 153
  end
  object cxLabel9: TcxLabel
    Left = 19
    Top = 254
    Caption = #1058' '#1084#1110#1085
  end
  object ceValue3: TcxCurrencyEdit
    Left = 19
    Top = 269
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 17
    Width = 153
  end
  object cxLabel10: TcxLabel
    Left = 178
    Top = 255
    Caption = #1058' '#1084#1072#1082#1089
  end
  object ceValue4: TcxCurrencyEdit
    Left = 178
    Top = 271
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 19
    Width = 153
  end
  object cxLabel11: TcxLabel
    Left = 19
    Top = 298
    Caption = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1076#1110#1073
  end
  object ceValue5: TcxCurrencyEdit
    Left = 19
    Top = 314
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 21
    Width = 153
  end
  object cxLabel2: TcxLabel
    Left = 19
    Top = 134
    Caption = #1054#1073#1086#1083#1086#1095#1082#1072
  end
  object edStickerSkin: TcxButtonEdit
    Left = 19
    Top = 150
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 23
    Width = 312
  end
  object cxLabel3: TcxLabel
    Left = 178
    Top = 89
    Caption = #1042#1080#1076' '#1087#1072#1082#1091#1074#1072#1085#1085#1103
  end
  object edStickerPack: TcxButtonEdit
    Left = 178
    Top = 106
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 25
    Width = 153
  end
  object cbisFix: TcxCheckBox
    Left = 212
    Top = 357
    Caption = #1060#1080#1082#1089'. '#1074#1077#1089
    TabOrder = 26
    Width = 74
  end
  object cxLabel12: TcxLabel
    Left = 178
    Top = 299
    Caption = #1042#1077#1089
  end
  object ceValue6: TcxCurrencyEdit
    Left = 178
    Top = 314
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 28
    Width = 153
  end
  object cxLabel13: TcxLabel
    Left = 19
    Top = 341
    Caption = '% '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1103
  end
  object ceValue7: TcxCurrencyEdit
    Left = 19
    Top = 357
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 30
    Width = 153
  end
  object cxLabel14: TcxLabel
    Left = 178
    Top = 4
    Caption = #1064#1090#1088#1080#1093#1082#1086#1076
  end
  object edBarCode: TcxTextEdit
    Left = 178
    Top = 20
    TabOrder = 32
    Width = 153
  end
  object cxLabel15: TcxLabel
    Left = 19
    Top = 382
    Caption = #1058' '#1084#1110#1085' - '#1074#1090#1086#1088#1086#1081' '#1089#1088#1086#1082
  end
  object ceValue8: TcxCurrencyEdit
    Left = 19
    Top = 397
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 34
    Width = 153
  end
  object cxLabel16: TcxLabel
    Left = 178
    Top = 382
    Caption = #1058' '#1084#1072#1082#1089' - '#1074#1090#1086#1088#1086#1081' '#1089#1088#1086#1082
  end
  object ceValue9: TcxCurrencyEdit
    Left = 178
    Top = 397
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 36
    Width = 153
  end
  object cxLabel17: TcxLabel
    Left = 19
    Top = 426
    Caption = #1082#1110#1083#1100#1082#1110#1089#1090#1100' '#1076#1110#1073' - '#1074#1090#1086#1088#1086#1081' '#1089#1088#1086#1082
  end
  object ceValue10: TcxCurrencyEdit
    Left = 19
    Top = 442
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 38
    Width = 153
  end
  object cxLabel18: TcxLabel
    Left = 178
    Top = 426
    Caption = #1074#1083#1086#1078#1077#1085#1085#1086#1089#1090#1100
  end
  object ceValue11: TcxCurrencyEdit
    Left = 178
    Top = 442
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 40
    Width = 153
  end
  object cxLabel19: TcxLabel
    Left = 178
    Top = 174
    Caption = #1064#1040#1041#1051#1054#1053' 70_70'
  end
  object edStickerFile70_70: TcxButtonEdit
    Left = 178
    Top = 188
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 42
    Width = 153
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
    StoredProcName = 'gpInsertUpdate_Object_StickerProperty'
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
        Name = 'inStickerId'
        Value = ''
        Component = GuidesSticker
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = ''
        Component = GuidesGoodsKind
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
        Component = GuidesStickerFile70_70
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStickerSkinName'
        Value = 0.000000000000000000
        Component = edStickerSkin
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStickerPackName'
        Value = Null
        Component = edStickerPack
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBarCode'
        Value = Null
        Component = edBarCode
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisFix'
        Value = Null
        Component = cbisFix
        DataType = ftBoolean
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
      end
      item
        Name = 'inValue9'
        Value = Null
        Component = ceValue9
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue10'
        Value = Null
        Component = ceValue10
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue11'
        Value = Null
        Component = ceValue11
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 160
    Top = 317
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
        Name = 'StickerId'
        Value = Null
        Component = GuidesSticker
        ComponentItem = 'Key'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'StickerName'
        Value = Null
        Component = GuidesSticker
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMaskId'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 278
    Top = 509
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_StickerProperty'
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
        Name = 'StickerId'
        Value = ''
        Component = GuidesSticker
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StickerName'
        Value = ''
        Component = GuidesSticker
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindId'
        Value = ''
        Component = GuidesGoodsKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindName'
        Value = ''
        Component = GuidesGoodsKind
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
        Name = 'StickerSkinId'
        Value = 0.000000000000000000
        Component = GuidesStickerSkin
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StickerSkinName'
        Value = Null
        Component = GuidesStickerSkin
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StickerPackId'
        Value = Null
        Component = GuidesStickerPack
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StickerPackName'
        Value = Null
        Component = GuidesStickerPack
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
        Name = 'Value9'
        Value = Null
        Component = ceValue9
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value10'
        Value = Null
        Component = ceValue10
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value11'
        Value = Null
        Component = ceValue11
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isFix'
        Value = Null
        Component = cbisFix
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BarCode'
        Value = Null
        Component = edBarCode
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StickerFileId_70_70'
        Value = Null
        Component = GuidesStickerFile70_70
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StickerFileName_70_70'
        Value = Null
        Component = GuidesStickerFile70_70
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 305
    Top = 341
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
    Left = 200
    Top = 80
  end
  object GuidesSticker: TdsdGuides
    KeyField = 'Id'
    LookupControl = edSticker
    FormNameParam.Value = 'TSticker_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TSticker_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesSticker
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesSticker
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 152
    Top = 47
  end
  object GuidesGoodsKind: TdsdGuides
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
        Component = GuidesGoodsKind
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 104
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
    Left = 103
    Top = 167
  end
  object GuidesStickerSkin: TdsdGuides
    KeyField = 'Id'
    LookupControl = edStickerSkin
    FormNameParam.Value = 'TStickerSkinForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TStickerSkinForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesStickerSkin
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesStickerSkin
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 64
    Top = 201
  end
  object GuidesStickerPack: TdsdGuides
    KeyField = 'Id'
    LookupControl = edStickerPack
    FormNameParam.Value = 'TStickerPackForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TStickerPackForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesStickerPack
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesStickerPack
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 264
    Top = 91
  end
  object GuidesStickerFile70_70: TdsdGuides
    KeyField = 'Id'
    LookupControl = edStickerFile70_70
    FormNameParam.Value = 'TStickerFileForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TStickerFileForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesStickerFile70_70
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesStickerFile70_70
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 242
    Top = 185
  end
end
