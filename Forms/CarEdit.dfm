inherited CarEditForm: TCarEditForm
  Caption = #1053#1086#1074#1099#1081' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1100
  ClientHeight = 424
  ClientWidth = 354
  ExplicitWidth = 370
  ExplicitHeight = 459
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 32
    Top = 78
    TabOrder = 0
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 32
    Top = 55
    Caption = #1043#1086#1089'. '#1085#1086#1084#1077#1088
  end
  object cxButton1: TcxButton
    Left = 56
    Top = 380
    Width = 75
    Height = 25
    Action = dsdExecStoredProc
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 230
    Top = 380
    Width = 75
    Height = 25
    Action = dsdFormClose1
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 32
    Top = 11
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 32
    Top = 34
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 273
  end
  object cxLabel5: TcxLabel
    Left = 32
    Top = 157
    Caption = #1052#1072#1088#1082#1072' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
  end
  object cxLabel2: TcxLabel
    Left = 32
    Top = 107
    Caption = #1058#1077#1093#1087#1072#1089#1087#1086#1088#1090
  end
  object ceRegistrationCertificate: TcxTextEdit
    Left = 32
    Top = 130
    TabOrder = 8
    Width = 273
  end
  object ceCarModel: TcxButtonEdit
    Left = 32
    Top = 172
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 9
    Width = 273
  end
  object cxLabel7: TcxLabel
    Left = 32
    Top = 203
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
  end
  object ceUnit: TcxButtonEdit
    Left = 32
    Top = 218
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 11
    Width = 273
  end
  object cxLabel3: TcxLabel
    Left = 32
    Top = 245
    Caption = #1042#1086#1076#1080#1090#1077#1083#1100
  end
  object cePersonalDriver: TcxButtonEdit
    Left = 32
    Top = 258
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 13
    Width = 273
  end
  object cxLabel4: TcxLabel
    Left = 32
    Top = 285
    Caption = #1042#1080#1076' '#1090#1086#1087#1083#1080#1074#1072' ('#1086#1089#1085#1086#1074#1085#1086#1081')'
  end
  object ceFuelMaster: TcxButtonEdit
    Left = 32
    Top = 298
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 15
    Width = 273
  end
  object cxLabel6: TcxLabel
    Left = 32
    Top = 325
    Caption = #1042#1080#1076' '#1090#1086#1087#1083#1080#1074#1072' ('#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081')'
  end
  object ceFuelChild: TcxButtonEdit
    Left = 32
    Top = 338
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 17
    Width = 273
  end
  object ActionList: TActionList
    Left = 240
    Top = 80
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
    end
    object dsdExecStoredProc: TdsdExecStoredProc
      Category = 'DSDLib'
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'Ok'
    end
    object dsdFormClose1: TdsdFormClose
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Car'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = dsdFormParams
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptInputOutput
        Value = '0'
      end
      item
        Name = 'inCode'
        Component = ceCode
        DataType = ftInteger
        ParamType = ptInput
        Value = 0.000000000000000000
      end
      item
        Name = 'inName'
        Component = edName
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inRegistrationCertificate'
        Component = ceRegistrationCertificate
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inCarModelId'
        Component = CarModelGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inUnitId '
        Component = UnitGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inPersonalDriverId '
        Component = PersonalGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inFuelMasterId'
        Component = FuelMasterGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inFuelChildId'
        Component = FuelChildGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end>
    Left = 320
    Top = 32
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        DataType = ftInteger
        ParamType = ptInputOutput
        Value = '0'
      end>
    Left = 184
    Top = 104
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Car'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Component = dsdFormParams
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'Code'
        Component = ceCode
        DataType = ftInteger
        ParamType = ptOutput
        Value = 0.000000000000000000
      end
      item
        Name = 'Name'
        Component = edName
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'CarModelId'
        Component = CarModelGuides
        ComponentItem = 'key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'CarModelName'
        Component = CarModelGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'RegistrationCertificate'
        Component = ceRegistrationCertificate
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'UnitId'
        Component = UnitGuides
        ComponentItem = 'key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'UnitName'
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'PersonalDriverId'
        Component = PersonalGuides
        ComponentItem = 'key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'PersonalDriverName'
        Component = PersonalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'FuelMasterId'
        Component = FuelMasterGuides
        ComponentItem = 'key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'FuelMasterName'
        Component = FuelMasterGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'FuelChildId'
        Component = FuelChildGuides
        ComponentItem = 'key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'FuelChildName'
        Component = FuelChildGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end>
    Left = 64
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
    Left = 144
    Top = 56
  end
  object dsdUserSettingsStorageAddOn1: TdsdUserSettingsStorageAddOn
    Left = 168
    Top = 65528
  end
  object UnitGuides: TdsdGuides
    Key = '0'
    LookupControl = ceUnit
    FormName = 'TUnitForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Component = UnitGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'TextValue'
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    Left = 135
    Top = 207
  end
  object PersonalGuides: TdsdGuides
    Key = '0'
    LookupControl = cePersonalDriver
    FormName = 'TPersonalForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Component = PersonalGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'TextValue'
        Component = PersonalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    Left = 207
    Top = 247
  end
  object FuelMasterGuides: TdsdGuides
    Key = '0'
    LookupControl = ceFuelMaster
    FormName = 'TFuelForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Component = FuelMasterGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'TextValue'
        Component = FuelMasterGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    Left = 151
    Top = 279
  end
  object FuelChildGuides: TdsdGuides
    Key = '0'
    LookupControl = ceFuelChild
    FormName = 'TFuelForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Component = FuelChildGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'TextValue'
        Component = FuelChildGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    Left = 159
    Top = 343
  end
  object CarModelGuides: TdsdGuides
    Key = '0'
    LookupControl = ceCarModel
    FormName = 'TCarModelForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Component = CarModelGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'TextValue'
        Component = CarModelGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    Left = 159
    Top = 167
  end
end
