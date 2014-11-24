object CityEditForm: TCityEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1053#1072#1089#1077#1083#1077#1085#1085#1099#1081' '#1087#1091#1085#1082#1090'>'
  ClientHeight = 291
  ClientWidth = 388
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
    Left = 20
    Top = 74
    TabOrder = 0
    Width = 340
  end
  object cxLabel1: TcxLabel
    Left = 20
    Top = 54
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 93
    Top = 249
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 237
    Top = 249
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
  end
  object cxLabel2: TcxLabel
    Left = 20
    Top = 10
    Caption = #1050#1086#1076
  end
  object edCode: TcxCurrencyEdit
    Left = 20
    Top = 30
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 340
  end
  object ceCityKind: TcxButtonEdit
    Left = 20
    Top = 119
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 340
  end
  object cxLabel3: TcxLabel
    Left = 20
    Top = 101
    Caption = #1042#1080#1076' '#1085#1072#1089#1077#1083#1077#1085#1085#1086#1075#1086' '#1087#1091#1085#1082#1090#1072
  end
  object cxLabel4: TcxLabel
    Left = 20
    Top = 148
    Caption = #1054#1073#1083#1072#1089#1090#1100
  end
  object cxLabel5: TcxLabel
    Left = 20
    Top = 190
    Caption = #1056#1072#1081#1086#1085
  end
  object ceRegion: TcxButtonEdit
    Left = 20
    Top = 165
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 340
  end
  object ceProvince: TcxButtonEdit
    Left = 20
    Top = 207
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 340
  end
  object ActionList: TActionList
    Left = 167
    Top = 56
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
    StoredProcName = 'gpInsertUpdate_Object_City'
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
        Component = edCode
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
        Name = 'inCityKindId'
        Value = ''
        Component = CityKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inRegionId'
        Value = ''
        Component = RegionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inProvinceId'
        Value = ''
        Component = ProvinceGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 136
    Top = 245
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
      end>
    Left = 199
    Top = 8
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_City'
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
        Component = edCode
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
      end
      item
        Name = 'CityKindId'
        Value = ''
        Component = CityKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'CityKindName'
        Value = ''
        Component = CityKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'RegionId'
        Value = ''
        Component = RegionGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'RegionName'
        Value = ''
        Component = RegionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'ProvinceId'
        Value = ''
        Component = ProvinceGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ProvinceName'
        Value = ''
        Component = ProvinceGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    PackSize = 1
    Left = 8
    Top = 245
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
    Left = 287
    Top = 40
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 95
    Top = 65528
  end
  object CityKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceCityKind
    FormNameParam.Value = 'TCityKindForm'
    FormNameParam.DataType = ftString
    FormName = 'TCityKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = CityKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = CityKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 136
    Top = 104
  end
  object RegionGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceRegion
    FormNameParam.Value = 'TRegionForm'
    FormNameParam.DataType = ftString
    FormName = 'TRegionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = RegionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = RegionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 192
    Top = 160
  end
  object ProvinceGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceProvince
    FormNameParam.Value = 'TProvinceForm'
    FormNameParam.DataType = ftString
    FormName = 'TProvinceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ProvinceGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ProvinceGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 88
    Top = 200
  end
end
