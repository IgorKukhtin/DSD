object CarEditForm: TCarEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1040#1074#1090#1086#1084#1086#1073#1080#1083#1100'>'
  ClientHeight = 485
  ClientWidth = 328
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
    Width = 133
  end
  object cxLabel1: TcxLabel
    Left = 32
    Top = 46
    Caption = #1043#1086#1089'. '#1085#1086#1084#1077#1088
  end
  object cxButton1: TcxButton
    Left = 48
    Top = 449
    Width = 75
    Height = 25
    Action = InsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 222
    Top = 449
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
    Left = 31
    Top = 22
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 134
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
    Width = 273
  end
  object cxLabel7: TcxLabel
    Left = 32
    Top = 166
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object ceUnit: TcxButtonEdit
    Left = 32
    Top = 182
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 273
  end
  object cxLabel3: TcxLabel
    Left = 32
    Top = 205
    Caption = #1042#1086#1076#1080#1090#1077#1083#1100
  end
  object cePersonalDriver: TcxButtonEdit
    Left = 32
    Top = 220
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 273
  end
  object cxLabel4: TcxLabel
    Left = 32
    Top = 243
    Caption = #1042#1080#1076' '#1090#1086#1087#1083#1080#1074#1072' ('#1086#1089#1085#1086#1074#1085#1086#1081')'
  end
  object ceFuelMaster: TcxButtonEdit
    Left = 32
    Top = 258
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 273
  end
  object cxLabel6: TcxLabel
    Left = 32
    Top = 281
    Caption = #1042#1080#1076' '#1090#1086#1087#1083#1080#1074#1072' ('#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081')'
  end
  object ceFuelChild: TcxButtonEdit
    Left = 32
    Top = 297
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 273
  end
  object cxLabel8: TcxLabel
    Left = 32
    Top = 320
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086'('#1089#1090#1086#1088#1086#1085#1085#1077#1077')'
  end
  object ceJuridical: TcxButtonEdit
    Left = 32
    Top = 336
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 273
  end
  object cxLabel9: TcxLabel
    Left = 32
    Top = 399
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit
    Left = 32
    Top = 416
    TabOrder = 21
    Width = 273
  end
  object cxLabel10: TcxLabel
    Left = 32
    Top = 359
    Caption = #1054#1089#1085#1086#1074#1085#1086#1077' '#1089#1088#1077#1076#1089#1090#1074#1086
  end
  object ceAsset: TcxButtonEdit
    Left = 32
    Top = 375
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 23
    Width = 273
  end
  object edKoeffHoursWork: TcxCurrencyEdit
    Left = 172
    Top = 22
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 24
    Width = 133
  end
  object cxLabel33: TcxLabel
    Left = 172
    Top = 8
    Hint = #1050#1086#1101#1092#1092'. '#1076#1083#1103' '#1084#1086#1076#1077#1083#1080' '#1088#1072#1073#1086#1095#1077#1077' '#1074#1088#1077#1084#1103' '#1080#1079' '#1087#1091#1090'. '#1083#1080#1089#1090#1072
    Caption = #1050#1086#1101#1092#1092'. '#1076#1083#1103' '#1084#1086#1076#1077#1083#1080' '#1088'.'#1074#1088'.'
  end
  object cxLabel11: TcxLabel
    Left = 172
    Top = 46
    Hint = #1050#1086#1101#1092#1092'. '#1076#1083#1103' '#1084#1086#1076#1077#1083#1080' '#1088#1072#1073#1086#1095#1077#1077' '#1074#1088#1077#1084#1103' '#1080#1079' '#1087#1091#1090'. '#1083#1080#1089#1090#1072
    Caption = #1050#1086#1083'-'#1074#1086' '#1084#1080#1085#1091#1090' '#1085#1072' '#1058#1058
  end
  object edPartnerMin: TcxCurrencyEdit
    Left = 172
    Top = 62
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 27
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
    StoredProcName = 'gpInsertUpdate_Object_Car'
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
        Name = 'inUnitId '
        Value = ''
        Component = UnitGuides
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalDriverId '
        Value = ''
        Component = PersonalGuides
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFuelMasterId'
        Value = ''
        Component = FuelMasterGuides
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFuelChildId'
        Value = ''
        Component = FuelChildGuides
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
        Name = 'inAssetId'
        Value = Null
        Component = AssetGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeffHoursWork'
        Value = Null
        Component = edKoeffHoursWork
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerMin'
        Value = Null
        Component = edPartnerMin
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 320
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
    Left = 312
    Top = 96
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Car'
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
        Name = 'UnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalDriverId'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalDriverName'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FuelMasterId'
        Value = ''
        Component = FuelMasterGuides
        ComponentItem = 'key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FuelMasterName'
        Value = ''
        Component = FuelMasterGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FuelChildId'
        Value = ''
        Component = FuelChildGuides
        ComponentItem = 'key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FuelChildName'
        Value = ''
        Component = FuelChildGuides
        ComponentItem = 'TextValue'
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
        Name = 'AssetId'
        Value = Null
        Component = AssetGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AssetName'
        Value = Null
        Component = AssetGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'KoeffHoursWork'
        Value = Null
        Component = edKoeffHoursWork
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerMin'
        Value = Null
        Component = edPartnerMin
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
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
    Left = 88
    Top = 56
  end
  object dsdUserSettingsStorageAddOn1: TdsdUserSettingsStorageAddOn
    Top = 120
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 119
    Top = 159
  end
  object PersonalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePersonalDriver
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 207
    Top = 191
  end
  object FuelMasterGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceFuelMaster
    FormNameParam.Value = 'TFuelForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TFuelForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = FuelMasterGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = FuelMasterGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 183
    Top = 239
  end
  object FuelChildGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceFuelChild
    FormNameParam.Value = 'TFuelForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TFuelForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = FuelChildGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = FuelChildGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 231
    Top = 279
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
    Left = 183
    Top = 127
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
    Left = 175
    Top = 327
  end
  object AssetGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceAsset
    FormNameParam.Value = 'TAssetForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAssetForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = AssetGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = AssetGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 167
    Top = 358
  end
end
