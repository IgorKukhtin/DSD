object CarEditForm: TCarEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1040#1074#1090#1086#1084#1086#1073#1080#1083#1100'>'
  ClientHeight = 381
  ClientWidth = 617
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
    Left = 185
    Top = 345
    Width = 75
    Height = 25
    Action = InsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 359
    Top = 345
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
    Top = 86
    Caption = #1052#1072#1088#1082#1072' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
  end
  object cxLabel2: TcxLabel
    Left = 330
    Top = 46
    Caption = #1058#1077#1093#1087#1072#1089#1087#1086#1088#1090
  end
  object ceRegistrationCertificate: TcxTextEdit
    Left = 328
    Top = 62
    TabOrder = 8
    Width = 273
  end
  object ceCarModel: TcxButtonEdit
    Left = 32
    Top = 103
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
    Left = 328
    Top = 5
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object ceUnit: TcxButtonEdit
    Left = 328
    Top = 22
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
    Left = 33
    Top = 125
    Caption = #1042#1086#1076#1080#1090#1077#1083#1100
  end
  object cePersonalDriver: TcxButtonEdit
    Left = 32
    Top = 142
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
    Top = 164
    Caption = #1042#1080#1076' '#1090#1086#1087#1083#1080#1074#1072' ('#1086#1089#1085#1086#1074#1085#1086#1081')'
  end
  object ceFuelMaster: TcxButtonEdit
    Left = 32
    Top = 179
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
    Left = 328
    Top = 164
    Caption = #1042#1080#1076' '#1090#1086#1087#1083#1080#1074#1072' ('#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081')'
  end
  object ceFuelChild: TcxButtonEdit
    Left = 328
    Top = 179
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
    Top = 202
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086'('#1089#1090#1086#1088#1086#1085#1085#1077#1077')'
  end
  object ceJuridical: TcxButtonEdit
    Left = 32
    Top = 218
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
    Left = 328
    Top = 288
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit
    Left = 328
    Top = 306
    TabOrder = 21
    Width = 273
  end
  object cxLabel10: TcxLabel
    Left = 328
    Top = 202
    Caption = #1054#1089#1085#1086#1074#1085#1086#1077' '#1089#1088#1077#1076#1089#1090#1074#1086' ('#1080#1085#1092'.)'
  end
  object ceAsset: TcxButtonEdit
    Left = 328
    Top = 218
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
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
    Top = 5
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
    Left = 171
    Top = 62
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 27
    Width = 133
  end
  object edLength: TcxCurrencyEdit
    Left = 32
    Top = 262
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 28
    Width = 60
  end
  object cxLabel12: TcxLabel
    Left = 32
    Top = 248
    Caption = #1044#1083#1080#1085#1072', '#1084#1084
  end
  object cxLabel13: TcxLabel
    Left = 170
    Top = 248
    Caption = #1042#1099#1089#1086#1090#1072', '#1084#1084
  end
  object edWidth: TcxCurrencyEdit
    Left = 101
    Top = 262
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 31
    Width = 60
  end
  object cxLabel14: TcxLabel
    Left = 101
    Top = 248
    Caption = #1064#1080#1088#1080#1085#1072', '#1084#1084
  end
  object edHeight: TcxCurrencyEdit
    Left = 170
    Top = 262
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 33
    Width = 60
  end
  object cxLabel15: TcxLabel
    Left = 240
    Top = 248
    Caption = #1042#1077#1089', '#1082#1075
  end
  object edWeight: TcxCurrencyEdit
    Left = 240
    Top = 262
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 35
    Width = 65
  end
  object cxLabel16: TcxLabel
    Left = 240
    Top = 290
    Caption = #1043#1086#1076' '#1074#1099#1087#1091#1089#1082#1072
  end
  object edYear: TcxCurrencyEdit
    Left = 240
    Top = 306
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 37
    Width = 65
  end
  object cxLabel17: TcxLabel
    Left = 32
    Top = 288
    Caption = 'VIN '#1082#1086#1076
  end
  object edVIN: TcxTextEdit
    Left = 32
    Top = 306
    TabOrder = 39
    Width = 198
  end
  object cxLabel18: TcxLabel
    Left = 328
    Top = 248
    Caption = #1053#1086#1084#1077#1088' '#1076#1074#1080#1075#1072#1090#1077#1083#1103
  end
  object edEngineNum: TcxTextEdit
    Left = 328
    Top = 262
    TabOrder = 41
    Width = 273
  end
  object cxLabel19: TcxLabel
    Left = 328
    Top = 86
    Caption = #1052#1086#1076#1077#1083#1100' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
  end
  object edCarType: TcxButtonEdit
    Left = 328
    Top = 103
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 43
    Width = 133
  end
  object cxLabel20: TcxLabel
    Left = 468
    Top = 86
    Caption = #1058#1080#1087' '#1082#1091#1079#1086#1074#1072
  end
  object edBodyType: TcxButtonEdit
    Left = 468
    Top = 103
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 45
    Width = 133
  end
  object edCarProperty: TcxButtonEdit
    Left = 330
    Top = 142
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 46
    Width = 133
  end
  object cxLabel21: TcxLabel
    Left = 330
    Top = 125
    Caption = #1058#1080#1087' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
  end
  object edObjectColor: TcxButtonEdit
    Left = 468
    Top = 142
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 48
    Width = 133
  end
  object cxLabel22: TcxLabel
    Left = 468
    Top = 125
    Caption = #1062#1074#1077#1090' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
  end
  object ActionList: TActionList
    Left = 112
    Top = 334
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
        Name = 'inVIN'
        Value = Null
        Component = edVIN
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
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCarModelId'
        Value = ''
        Component = GuidesCarModel
        ComponentItem = 'Key'
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
        Name = 'inBodyTypeId'
        Value = Null
        Component = GuidesBodyType
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
        Name = 'inUnitId '
        Value = ''
        Component = GuidesUnit
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalDriverId '
        Value = ''
        Component = GuidesPersonal
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFuelMasterId'
        Value = ''
        Component = GuidesFuelMaster
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
        Component = GuidesJuridical
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
    Top = 184
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 480
    Top = 334
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
        Component = GuidesCarModel
        ComponentItem = 'key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarModelName'
        Value = ''
        Component = GuidesCarModel
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
        Component = GuidesUnit
        ComponentItem = 'key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalDriverId'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalDriverName'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FuelMasterId'
        Value = ''
        Component = GuidesFuelMaster
        ComponentItem = 'key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FuelMasterName'
        Value = ''
        Component = GuidesFuelMaster
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
        Component = GuidesJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AssetId'
        Value = Null
        Component = GuidesAsset
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AssetName'
        Value = Null
        Component = GuidesAsset
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
      end
      item
        Name = 'Length'
        Value = Null
        Component = edLength
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
        Name = 'Height'
        Value = Null
        Component = edHeight
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
        Name = 'VIN'
        Value = Null
        Component = edVIN
        DataType = ftString
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
        Name = 'EngineNum'
        Value = Null
        Component = edEngineNum
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BodyTypeId'
        Value = Null
        Component = GuidesBodyType
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BodyTypeName'
        Value = Null
        Component = GuidesBodyType
        ComponentItem = 'TextValue'
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
    Left = 40
    Top = 334
  end
  object dsdUserSettingsStorageAddOn1: TdsdUserSettingsStorageAddOn
    Top = 120
  end
  object GuidesUnit: TdsdGuides
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
        Component = GuidesUnit
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 103
    Top = 39
  end
  object GuidesPersonal: TdsdGuides
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
        Component = GuidesPersonal
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 207
    Top = 112
  end
  object GuidesFuelMaster: TdsdGuides
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
        Component = GuidesFuelMaster
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesFuelMaster
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 183
    Top = 160
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
    Left = 527
    Top = 162
  end
  object GuidesCarModel: TdsdGuides
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
        Component = GuidesCarModel
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCarModel
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 183
    Top = 87
  end
  object GuidesJuridical: TdsdGuides
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
    Left = 191
    Top = 200
  end
  object GuidesAsset: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceAsset
    DisableGuidesOpen = True
    FormNameParam.Value = 'TAssetForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAssetForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesAsset
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesAsset
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 543
    Top = 212
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
    Left = 511
    Top = 31
  end
  object GuidesBodyType: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBodyType
    FormNameParam.Value = 'TBodyTypeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBodyTypeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBodyType
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBodyType
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 519
    Top = 78
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
    Left = 383
    Top = 128
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
    Left = 535
    Top = 126
  end
end
