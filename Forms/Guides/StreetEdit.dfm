object StreetEditForm: TStreetEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1059#1083#1080#1094#1072'/'#1087#1088#1086#1089#1087#1077#1082#1090'>'
  ClientHeight = 300
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
    TabOrder = 0
    Width = 296
  end
  object cxLabel1: TcxLabel
    Left = 40
    Top = 51
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 79
    Top = 258
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 229
    Top = 258
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
    Width = 296
  end
  object cxLabel2: TcxLabel
    Left = 242
    Top = 96
    Caption = #1055#1086#1095#1090#1086#1074#1099#1081' '#1080#1085#1076#1077#1082#1089
  end
  object edPostalCode: TcxTextEdit
    Left = 242
    Top = 114
    TabOrder = 7
    Width = 94
  end
  object cxLabel3: TcxLabel
    Left = 42
    Top = 139
    Caption = #1053#1072#1089#1077#1083#1077#1085#1085#1099#1081' '#1087#1091#1085#1082#1090
  end
  object ceCity: TcxButtonEdit
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
  object ceProvinceCity: TcxButtonEdit
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
    Caption = #1042#1080#1076'('#1091#1083#1080#1094#1072','#1087#1088#1086#1089#1087#1077#1082#1090')'
  end
  object ceStreetKind: TcxButtonEdit
    Left = 40
    Top = 114
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 175
  end
  object cxLabel6: TcxLabel
    Left = 42
    Top = 183
    Caption = #1052#1080#1082#1088#1086#1088#1072#1081#1086#1085
  end
  object ActionList: TActionList
    Left = 272
    Top = 20
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
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Street'
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
        Name = 'inPostalCode'
        Value = ''
        Component = edPostalCode
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inStreetKindId'
        Value = ''
        Component = StreetKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inCityId'
        Value = ''
        Component = CityGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inProvinceCityId'
        Value = ''
        Component = ProvinceCityGuides
        ComponentItem = 'Key'
        ParamType = ptInput
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
      end>
    Left = 24
    Top = 240
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Street'
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
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
      end
      item
        Name = 'PostalCode'
        Value = ''
        Component = edPostalCode
        DataType = ftString
      end
      item
        Name = 'StreetKindId'
        Value = ''
        Component = StreetKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'StreetKindName'
        Value = ''
        Component = StreetKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'CityId'
        Value = ''
        Component = CityGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'CityName'
        Value = ''
        Component = CityGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'ProvinceCityId'
        Value = ''
        Component = ProvinceCityGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ProvinceCityName'
        Value = ''
        Component = ProvinceCityGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    PackSize = 1
    Left = 344
    Top = 16
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 208
    Top = 7
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
  object CityGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceCity
    FormNameParam.Value = 'TCityForm'
    FormNameParam.DataType = ftString
    FormName = 'TCityForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = CityGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = CityGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 152
    Top = 152
  end
  object ProvinceCityGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceProvinceCity
    FormNameParam.Value = 'TProvinceCityForm'
    FormNameParam.DataType = ftString
    FormName = 'TProvinceCityForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ProvinceCityGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ProvinceCityGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 176
    Top = 200
  end
  object StreetKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceStreetKind
    FormNameParam.Value = 'TStreetKindForm'
    FormNameParam.DataType = ftString
    FormName = 'TStreetKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = StreetKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = StreetKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 104
    Top = 96
  end
end
