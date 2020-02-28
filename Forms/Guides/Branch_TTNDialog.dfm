object Branch_TTNDialogForm: TBranch_TTNDialogForm
  Left = 0
  Top = 0
  Caption = #1044#1072#1085#1085#1099#1077' '#1076#1083#1103' '#1079#1072#1087#1083#1086#1085#1077#1085#1080#1103' '#1058#1058#1053
  ClientHeight = 361
  ClientWidth = 320
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
  object cxButton1: TcxButton
    Left = 37
    Top = 316
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 181
    Top = 316
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
  end
  object cxLabel5: TcxLabel
    Left = 19
    Top = 8
    Caption = #1060#1048#1054' ('#1042#1086#1076#1080#1090#1077#1083#1100')'
  end
  object cxLabel14: TcxLabel
    Left = 19
    Top = 55
    Caption = #1054#1090#1088#1080#1084#1072#1074' '#1074#1086#1076#1110#1081'/'#1077#1082#1089#1087#1077#1076#1080#1090#1086#1088
  end
  object edMember1: TcxButtonEdit
    Left = 19
    Top = 78
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 267
  end
  object cxLabel11: TcxLabel
    Left = 19
    Top = 113
    Caption = #1041#1091#1093#1075#1072#1083#1090#1077#1088' ('#1074#1110#1076#1087#1086#1074#1110#1076#1072#1083#1100#1085#1072' '#1086#1089#1086#1073#1072' '#1074#1072#1085#1090#1072#1078#1086#1074#1110#1076#1087#1088#1072#1074'.)'
  end
  object edMember2: TcxButtonEdit
    Left = 19
    Top = 133
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 267
  end
  object cxLabel13: TcxLabel
    Left = 19
    Top = 158
    Caption = #1042#1110#1076#1087#1091#1089#1082' '#1076#1086#1079#1074#1086#1083#1080#1074
  end
  object edMember3: TcxButtonEdit
    Left = 19
    Top = 181
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 267
  end
  object cxLabel15: TcxLabel
    Left = 19
    Top = 208
    Caption = #1047#1076#1072#1074' ('#1074#1110#1076#1087#1086#1074#1110#1076#1072#1083#1100#1085#1072' '#1086#1089#1086#1073#1072' '#1074#1072#1085#1090#1072#1078#1086#1074#1110#1076#1087#1088#1072#1074#1085#1080#1082#1072') '
  end
  object edMember4: TcxButtonEdit
    Left = 19
    Top = 228
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 267
  end
  object edPersonalDriver: TcxButtonEdit
    Left = 19
    Top = 30
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 267
  end
  object cxLabel9: TcxLabel
    Left = 19
    Top = 255
    Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100
  end
  object edCar: TcxButtonEdit
    Left = 19
    Top = 272
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 267
  end
  object ActionList: TActionList
    Left = 240
    Top = 208
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
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
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Branch_TTN'
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
        Name = 'inPersonalDriverId'
        Value = 0.000000000000000000
        Component = GuidePersonalDriver
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMember1Id'
        Value = ''
        Component = GuideMember1
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMember2Id'
        Value = ''
        Component = GuideMember2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMember3Id'
        Value = ''
        Component = GuideMember3
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMember4Id'
        Value = ''
        Component = GuideMember4
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCarId'
        Value = Null
        Component = GuideCar
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 120
    Top = 208
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalDriverId'
        Value = Null
        Component = GuidePersonalDriver
        ComponentItem = 'Key'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Member1Id'
        Value = Null
        Component = GuideMember1
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Member2Id'
        Value = Null
        Component = GuideMember2
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Member3Id'
        Value = Null
        Component = GuideMember3
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Member4Id'
        Value = Null
        Component = GuideMember4
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalDriverName'
        Value = Null
        Component = GuidePersonalDriver
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Member1Name'
        Value = Null
        Component = GuideMember1
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Member2Name'
        Value = Null
        Component = GuideMember2
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Member3Name'
        Value = Null
        Component = GuideMember3
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Member4Name'
        Value = Null
        Component = GuideMember4
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarId'
        Value = Null
        Component = GuideCar
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarName'
        Value = Null
        Component = GuideCar
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 272
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
    Left = 156
    Top = 320
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 288
    Top = 144
  end
  object GuidePersonalDriver: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalDriver
    FormNameParam.Value = 'TMember_ChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidePersonalDriver
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidePersonalDriver
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 177
    Top = 19
  end
  object GuideMember1: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMember1
    FormNameParam.Value = 'TMember_ChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuideMember1
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuideMember1
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 168
    Top = 67
  end
  object GuideMember2: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMember2
    FormNameParam.Value = 'TMember_ChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuideMember2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuideMember2
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 190
    Top = 123
  end
  object GuideMember3: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMember3
    FormNameParam.Value = 'TMember_ChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuideMember3
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuideMember3
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 158
  end
  object GuideMember4: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMember4
    FormNameParam.Value = 'TMember_ChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuideMember4
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuideMember4
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 198
    Top = 197
  end
  object GuideCar: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCar
    FormNameParam.Value = 'TCarForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCarForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuideCar
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuideCar
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarModelName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 144
    Top = 266
  end
end
