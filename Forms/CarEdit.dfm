object CarEditForm: TCarEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1040#1074#1090#1086#1084#1086#1073#1080#1083#1100'>'
  ClientHeight = 424
  ClientWidth = 354
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
    Action = InsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 230
    Top = 380
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
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 273
  end
  object cxLabel7: TcxLabel
    Left = 32
    Top = 203
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object ceUnit: TcxButtonEdit
    Left = 32
    Top = 218
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
    Properties.ReadOnly = True
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
    Properties.ReadOnly = True
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
    Properties.ReadOnly = True
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
      RefreshOnTabSetChanges = False
    end
    object InsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'Ok'
    end
    object dsdFormClose: TdsdFormClose
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
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = ceCode
        ParamType = ptInput
      end
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inRegistrationCertificate'
        Value = ''
        Component = ceRegistrationCertificate
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inCarModelId'
        Value = ''
        Component = CarModelGuides
        ParamType = ptInput
      end
      item
        Name = 'inUnitId '
        Value = ''
        Component = UnitGuides
        ParamType = ptInput
      end
      item
        Name = 'inPersonalDriverId '
        Value = ''
        Component = PersonalGuides
        ParamType = ptInput
      end
      item
        Name = 'inFuelMasterId'
        Value = ''
        Component = FuelMasterGuides
        ParamType = ptInput
      end
      item
        Name = 'inFuelChildId'
        Value = ''
        Component = FuelChildGuides
        ParamType = ptInput
      end>
    Left = 320
    Top = 32
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
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
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
      end
      item
        Name = 'CarModelId'
        Value = ''
        Component = CarModelGuides
        ComponentItem = 'key'
      end
      item
        Name = 'CarModelName'
        Value = ''
        Component = CarModelGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'RegistrationCertificate'
        Value = ''
        Component = ceRegistrationCertificate
        DataType = ftString
      end
      item
        Name = 'UnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'key'
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'PersonalDriverId'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'key'
      end
      item
        Name = 'PersonalDriverName'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'FuelMasterId'
        Value = ''
        Component = FuelMasterGuides
        ComponentItem = 'key'
      end
      item
        Name = 'FuelMasterName'
        Value = ''
        Component = FuelMasterGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'FuelChildId'
        Value = ''
        Component = FuelChildGuides
        ComponentItem = 'key'
      end
      item
        Name = 'FuelChildName'
        Value = ''
        Component = FuelChildGuides
        ComponentItem = 'TextValue'
        DataType = ftString
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
    KeyField = 'Id'
    LookupControl = ceUnit
    FormName = 'TObject_UnitForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 135
    Top = 207
  end
  object PersonalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePersonalDriver
    FormName = 'TPersonalForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 207
    Top = 247
  end
  object FuelMasterGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceFuelMaster
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
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = FuelMasterGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 151
    Top = 279
  end
  object FuelChildGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceFuelChild
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
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = FuelChildGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 159
    Top = 343
  end
  object CarModelGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceCarModel
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
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = CarModelGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 159
    Top = 167
  end
end
