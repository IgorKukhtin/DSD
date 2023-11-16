object CarExternalEditForm: TCarExternalEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1040#1074#1090#1086#1084#1086#1073#1080#1083#1100' ('#1089#1090#1086#1088#1086#1085#1085#1080#1077')>'
  ClientHeight = 437
  ClientWidth = 334
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
    Left = 32
    Top = 62
    TabOrder = 0
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 32
    Top = 46
    Caption = #1043#1086#1089'. '#1085#1086#1084#1077#1088
  end
  object cxButton1: TcxButton
    Left = 49
    Top = 397
    Width = 75
    Height = 25
    Action = InsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 223
    Top = 397
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 32
    Top = 5
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 32
    Top = 22
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 273
  end
  object cxLabel5: TcxLabel
    Left = 32
    Top = 126
    Caption = #1052#1072#1088#1082#1072' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
  end
  object cxLabel2: TcxLabel
    Left = 32
    Top = 86
    Caption = #1058#1077#1093#1087#1072#1089#1087#1086#1088#1090
  end
  object ceRegistrationCertificate: TcxTextEdit
    Left = 32
    Top = 102
    TabOrder = 8
    Width = 273
  end
  object ceCarModel: TcxButtonEdit
    Left = 32
    Top = 143
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 133
  end
  object cxLabel8: TcxLabel
    Left = 32
    Top = 215
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086'('#1089#1090#1086#1088#1086#1085#1085#1077#1077')'
  end
  object ceJuridical: TcxButtonEdit
    Left = 32
    Top = 231
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 273
  end
  object cxLabel9: TcxLabel
    Left = 33
    Top = 257
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit
    Left = 32
    Top = 274
    TabOrder = 13
    Width = 273
  end
  object edLength: TcxCurrencyEdit
    Left = 32
    Top = 317
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 14
    Width = 60
  end
  object cxLabel12: TcxLabel
    Left = 33
    Top = 303
    Caption = #1044#1083#1080#1085#1072', '#1084#1084
  end
  object cxLabel13: TcxLabel
    Left = 171
    Top = 303
    Caption = #1042#1099#1089#1086#1090#1072', '#1084#1084
  end
  object edWidth: TcxCurrencyEdit
    Left = 102
    Top = 317
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 17
    Width = 60
  end
  object cxLabel14: TcxLabel
    Left = 102
    Top = 303
    Caption = #1064#1080#1088#1080#1085#1072', '#1084#1084
  end
  object edHeight: TcxCurrencyEdit
    Left = 171
    Top = 317
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 19
    Width = 60
  end
  object cxLabel15: TcxLabel
    Left = 241
    Top = 303
    Caption = #1042#1077#1089', '#1082#1075
  end
  object edWeight: TcxCurrencyEdit
    Left = 241
    Top = 317
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 21
    Width = 65
  end
  object cxLabel16: TcxLabel
    Left = 241
    Top = 343
    Caption = #1043#1086#1076' '#1074#1099#1087#1091#1089#1082#1072
  end
  object edYear: TcxCurrencyEdit
    Left = 241
    Top = 360
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 23
    Width = 65
  end
  object cxLabel17: TcxLabel
    Left = 32
    Top = 343
    Caption = 'VIN '#1082#1086#1076
  end
  object edVIN: TcxTextEdit
    Left = 32
    Top = 360
    TabOrder = 25
    Width = 198
  end
  object cxLabel19: TcxLabel
    Left = 172
    Top = 126
    Caption = #1052#1086#1076#1077#1083#1100' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
  end
  object edCarType: TcxButtonEdit
    Left = 172
    Top = 143
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 27
    Width = 133
  end
  object edCarProperty: TcxButtonEdit
    Left = 32
    Top = 187
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 28
    Width = 133
  end
  object cxLabel21: TcxLabel
    Left = 32
    Top = 170
    Caption = #1058#1080#1087' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
  end
  object cxLabel22: TcxLabel
    Left = 172
    Top = 170
    Caption = #1062#1074#1077#1090' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
  end
  object edObjectColor: TcxButtonEdit
    Left = 172
    Top = 187
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 31
    Width = 133
  end
  object ActionList: TActionList
    Left = 240
    Top = 80
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
    object InsertUpdateGuides: TdsdInsertUpdateGuides
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
    StoredProcName = 'gpInsertUpdate_Object_CarExternal'
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
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRegistrationCertificate'
        Value = ''
        Component = ceRegistrationCertificate
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inVIN'
        Value = Null
        Component = edVIN
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
      end
      item
        Name = 'inCarModelId'
        Value = ''
        Component = CarModelGuides
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCarTypeId'
        Value = Null
        Component = GuidesCarType
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCarPropertyId'
        Value = Null
        Component = GuidesCarProperty
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inObjectColorId'
        Value = Null
        Component = GuidesObjectColor
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLength'
        Value = Null
        Component = edLength
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth'
        Value = Null
        Component = edWidth
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHeight'
        Value = Null
        Component = edHeight
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeight'
        Value = Null
        Component = edWeight
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inYear'
        Value = Null
        Component = edYear
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 288
    Top = 32
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 280
    Top = 88
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_CarExternal'
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
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
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
        Name = 'CarModelId'
        Value = ''
        Component = CarModelGuides
        ComponentItem = 'key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarModelName'
        Value = ''
        Component = CarModelGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'RegistrationCertificate'
        Value = ''
        Component = ceRegistrationCertificate
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = Null
        Component = JuridicalGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = Null
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Height'
        Value = Null
        Component = edHeight
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Length'
        Value = Null
        Component = edLength
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Weight'
        Value = Null
        Component = edWeight
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width'
        Value = Null
        Component = edWidth
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Year'
        Value = Null
        Component = edYear
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'VIN'
        Value = Null
        Component = edVIN
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarTypeId'
        Value = Null
        Component = GuidesCarType
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarTypeName'
        Value = Null
        Component = GuidesCarType
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarPropertyId'
        Value = Null
        Component = GuidesCarProperty
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarPropertyName'
        Value = Null
        Component = GuidesCarProperty
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ObjectColorId'
        Value = Null
        Component = GuidesObjectColor
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ObjectColorName'
        Value = Null
        Component = GuidesObjectColor
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 65528
    Top = 40
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
    Left = 144
    Top = 56
  end
  object dsdUserSettingsStorageAddOn1: TdsdUserSettingsStorageAddOn
    Left = 168
    Top = 65528
  end
  object CarModelGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceCarModel
    FormNameParam.Value = 'TCarModelForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCarModelForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = CarModelGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = CarModelGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 95
    Top = 103
  end
  object JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridical
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 176
    Top = 222
  end
  object GuidesCarType: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCarType
    FormNameParam.Value = 'TCarTypeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCarTypeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCarType
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCarType
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 247
    Top = 127
  end
  object GuidesObjectColor: TdsdGuides
    KeyField = 'Id'
    LookupControl = edObjectColor
    FormNameParam.Value = 'TObjectColorForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TObjectColorForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesObjectColor
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesObjectColor
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 248
    Top = 172
  end
  object GuidesCarProperty: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCarProperty
    FormNameParam.Value = 'TCarPropertyForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCarPropertyForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCarProperty
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCarProperty
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 166
  end
end
