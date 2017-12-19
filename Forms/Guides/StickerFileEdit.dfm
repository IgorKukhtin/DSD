object StickerFileEditForm: TStickerFileEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1064#1040#1041#1051#1054#1053'>'
  ClientHeight = 461
  ClientWidth = 377
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
    Left = 40
    Top = 71
    Properties.ReadOnly = True
    TabOrder = 0
    Width = 296
  end
  object cxLabel1: TcxLabel
    Left = 40
    Top = 51
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 72
    Top = 418
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 222
    Top = 418
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 40
    Top = 3
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 40
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 137
  end
  object cxLabel2: TcxLabel
    Left = 42
    Top = 232
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit
    Left = 40
    Top = 250
    TabOrder = 7
    Width = 296
  end
  object cxLabel3: TcxLabel
    Left = 42
    Top = 139
    Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
  end
  object edTradeMark: TcxButtonEdit
    Left = 40
    Top = 158
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 296
  end
  object edJuridical: TcxButtonEdit
    Left = 40
    Top = 199
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 296
  end
  object cxLabel5: TcxLabel
    Left = 42
    Top = 96
    Caption = #1071#1079#1099#1082
  end
  object edLanguage: TcxButtonEdit
    Left = 40
    Top = 114
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 12
    Width = 296
  end
  object cxLabel6: TcxLabel
    Left = 42
    Top = 183
    Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100': '#1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100' / '#1070#1088'. '#1083#1080#1094#1086' / '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
  end
  object cbisDefault: TcxCheckBox
    Left = 239
    Top = 26
    Caption = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
    TabOrder = 14
    Width = 97
  end
  object cxLabel16: TcxLabel
    Left = 42
    Top = 285
    Caption = #1064#1080#1088#1080#1085#1072' '#1089#1090#1088#1086#1082#1080
  end
  object cxLabel7: TcxLabel
    Left = 59
    Top = 307
    Caption = '1-'#1086#1081
  end
  object ceWidth1: TcxCurrencyEdit
    Left = 59
    Top = 326
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 17
    Width = 45
  end
  object cxLabel11: TcxLabel
    Left = 59
    Top = 355
    Caption = '6-'#1086#1081
  end
  object ceWidth6: TcxCurrencyEdit
    Left = 59
    Top = 374
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 19
    Width = 45
  end
  object ceWidth7: TcxCurrencyEdit
    Left = 111
    Top = 374
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 20
    Width = 45
  end
  object cxLabel12: TcxLabel
    Left = 111
    Top = 355
    Caption = '7-'#1086#1081
  end
  object cxLabel4: TcxLabel
    Left = 111
    Top = 307
    Caption = '2-'#1086#1081
  end
  object cxLabel8: TcxLabel
    Left = 164
    Top = 307
    Caption = '3-'#1086#1081
  end
  object ceWidth3: TcxCurrencyEdit
    Left = 164
    Top = 326
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 24
    Width = 45
  end
  object ceWidth4: TcxCurrencyEdit
    Left = 217
    Top = 326
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 25
    Width = 45
  end
  object ceWidth2: TcxCurrencyEdit
    Left = 111
    Top = 326
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 26
    Width = 45
  end
  object cxLabel10: TcxLabel
    Left = 269
    Top = 307
    Caption = '5-'#1086#1081
  end
  object cxLabel9: TcxLabel
    Left = 217
    Top = 307
    Caption = '4-'#1086#1081
  end
  object ceWidth5: TcxCurrencyEdit
    Left = 269
    Top = 326
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 29
    Width = 45
  end
  object cxLabel15: TcxLabel
    Left = 269
    Top = 355
    Caption = '10-'#1086#1081
  end
  object ceWidth8: TcxCurrencyEdit
    Left = 269
    Top = 374
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 31
    Width = 45
  end
  object ceWidth9: TcxCurrencyEdit
    Left = 217
    Top = 374
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 32
    Width = 45
  end
  object cxLabel14: TcxLabel
    Left = 217
    Top = 355
    Caption = '9-'#1086#1081
  end
  object ceWidth10: TcxCurrencyEdit
    Left = 164
    Top = 374
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 34
    Width = 45
  end
  object cxLabel13: TcxLabel
    Left = 164
    Top = 355
    Caption = '8-'#1086#1081
  end
  object ActionList: TActionList
    Left = 280
    Top = 68
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
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_StickerFile'
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
        Component = ceCode
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
        Name = 'inTradeMarkId'
        Value = ''
        Component = GuidesTradeMark
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLanguageName'
        Value = ''
        Component = edLanguage
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = ''
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth1'
        Value = Null
        Component = ceWidth1
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth2'
        Value = Null
        Component = ceWidth2
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth3'
        Value = Null
        Component = ceWidth3
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth4'
        Value = Null
        Component = ceWidth4
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth5'
        Value = Null
        Component = ceWidth5
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth6'
        Value = Null
        Component = ceWidth6
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth7'
        Value = Null
        Component = ceWidth7
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth8'
        Value = Null
        Component = ceWidth8
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth9'
        Value = Null
        Component = ceWidth9
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth10'
        Value = Null
        Component = ceWidth10
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDefault'
        Value = Null
        Component = cbisDefault
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 112
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Top = 192
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_StickerFile'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
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
        Component = ceCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = ''
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'LanguageId'
        Value = ''
        Component = GuidesLanguage
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'LanguageName'
        Value = ''
        Component = GuidesLanguage
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TradeMarkId'
        Value = ''
        Component = GuidesTradeMark
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TradeMarkName'
        Value = ''
        Component = GuidesTradeMark
        ComponentItem = 'TextValue'
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
        Name = 'isDefault'
        Value = Null
        Component = cbisDefault
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width1'
        Value = Null
        Component = ceWidth1
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width2'
        Value = Null
        Component = ceWidth2
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width3'
        Value = Null
        Component = ceWidth3
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width4'
        Value = Null
        Component = ceWidth4
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width5'
        Value = Null
        Component = ceWidth5
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width6'
        Value = Null
        Component = ceWidth6
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width7'
        Value = Null
        Component = ceWidth7
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width8'
        Value = Null
        Component = ceWidth8
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width9'
        Value = Null
        Component = ceWidth9
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width10'
        Value = Null
        Component = ceWidth10
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 16
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 216
    Top = 63
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
    Left = 344
    Top = 64
  end
  object GuidesTradeMark: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTradeMark
    FormNameParam.Value = 'TTradeMarkForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TTradeMarkForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTradeMark
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTradeMark
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 144
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
    Left = 176
    Top = 200
  end
  object GuidesLanguage: TdsdGuides
    KeyField = 'Id'
    LookupControl = edLanguage
    FormNameParam.Value = 'TLanguageForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TLanguageForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesLanguage
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesLanguage
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 104
    Top = 96
  end
end
