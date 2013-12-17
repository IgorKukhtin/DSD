object CardFuelEditForm: TCardFuelEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1058#1086#1087#1083#1080#1074#1085#1099#1077' '#1082#1072#1088#1090#1099'>'
  ClientHeight = 435
  ClientWidth = 369
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
    Top = 88
    TabOrder = 0
    Width = 209
  end
  object cxLabel1: TcxLabel
    Left = 32
    Top = 68
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 80
    Top = 397
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 224
    Top = 397
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
    Top = 19
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 32
    Top = 42
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 273
  end
  object ceGoods: TcxButtonEdit
    Left = 35
    Top = 352
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 6
    Width = 273
  end
  object cxLabel7: TcxLabel
    Left = 35
    Top = 329
    Caption = #1058#1086#1074#1072#1088
  end
  object cxLabel2: TcxLabel
    Left = 32
    Top = 123
    Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1074#1086#1076#1080#1090#1077#1083#1100')'
  end
  object cePersonalDriver: TcxButtonEdit
    Left = 32
    Top = 146
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 9
    Width = 273
  end
  object cxLabel3: TcxLabel
    Left = 35
    Top = 179
    Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1080
  end
  object ceCar: TcxButtonEdit
    Left = 35
    Top = 202
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 11
    Width = 273
  end
  object cxLabel4: TcxLabel
    Left = 35
    Top = 229
    Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099' '
  end
  object cePaidKind: TcxButtonEdit
    Left = 35
    Top = 252
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 13
    Width = 273
  end
  object cxLabel5: TcxLabel
    Left = 35
    Top = 279
    Caption = #1070#1088'. '#1083#1080#1094#1086
  end
  object ceJuridical: TcxButtonEdit
    Left = 35
    Top = 302
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 15
    Width = 273
  end
  object ceLimit: TcxCurrencyEdit
    Left = 256
    Top = 88
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 16
    Width = 49
  end
  object cxLabel6: TcxLabel
    Left = 256
    Top = 68
    Caption = #1051#1080#1084#1080#1090
  end
  object ActionList: TActionList
    Left = 320
    Top = 96
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
    object dsdFormClose1: TdsdFormClose
    end
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = #1054#1082
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_CardFuel'
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
        Name = 'inCardFuelLimit'
        Value = 0.000000000000000000
        Component = ceLimit
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPersonalDriverId'
        Value = ''
        Component = PersonalDriverGuides
        ParamType = ptInput
      end
      item
        Name = 'inCarId'
        Value = ''
        Component = CarGuides
        ParamType = ptInput
      end
      item
        Name = 'inPaidKindId'
        Value = ''
        Component = PaidKindGuides
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = JuridicalGuides
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = ''
        Component = GoodsGuides
        ParamType = ptInput
      end>
    Left = 320
    Top = 40
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
      end>
    Left = 208
    Top = 80
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_CardFuel'
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
        Name = 'PersonalDriverId'
        Value = ''
        Component = PersonalDriverGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PersonalDriverName'
        Value = ''
        Component = PersonalDriverGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'CarId'
        Value = ''
        Component = CarGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'CarName'
        Value = ''
        Component = CarGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'PaidKindId'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'GoodsId'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'GoodsName'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'CardFuelLimit'
        Value = 0.000000000000000000
        Component = ceLimit
        DataType = ftFloat
      end>
    Left = 320
    Top = 160
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
    Left = 128
    Top = 80
  end
  object dsdUserSettingsStorageAddOn1: TdsdUserSettingsStorageAddOn
    Left = 200
    Top = 8
  end
  object GoodsGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoods
    FormName = 'TGoods_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 207
    Top = 343
  end
  object PersonalDriverGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePersonalDriver
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PersonalDriverGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PersonalDriverGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 183
    Top = 135
  end
  object CarGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceCar
    FormName = 'TCarForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = CarGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = CarGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 167
    Top = 191
  end
  object PaidKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePaidKind
    FormName = 'TPaidKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 215
    Top = 239
  end
  object JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridical
    FormName = 'TJuridicalForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 159
    Top = 295
  end
end
