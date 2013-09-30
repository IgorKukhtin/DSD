inherited PersonalEditForm: TPersonalEditForm
  Caption = 'C'#1086#1090#1088#1091#1076#1085#1080#1082
  ClientHeight = 275
  ClientWidth = 340
  ExplicitWidth = 348
  ExplicitHeight = 302
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 72
    Top = 239
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 6
  end
  object cxButton2: TcxButton
    Left = 176
    Top = 239
    Width = 75
    Height = 25
    Action = dsdFormClose1
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 7
  end
  object Код: TcxLabel
    Left = 16
    Top = 3
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 16
    Top = 20
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 0
    Width = 73
  end
  object cxLabel3: TcxLabel
    Left = 16
    Top = 175
    Caption = #1044#1072#1090#1072' '#1087#1088#1080#1077#1084#1072
  end
  object cxLabel2: TcxLabel
    Left = 136
    Top = 175
    Caption = #1044#1072#1090#1072' '#1091#1074#1086#1083#1100#1085#1077#1085#1080#1103
  end
  object cxLabel5: TcxLabel
    Left = 16
    Top = 132
    Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
  end
  object cxLabel6: TcxLabel
    Left = 95
    Top = 3
    Caption = #1060#1048#1054
  end
  object cxLabel7: TcxLabel
    Left = 16
    Top = 46
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object cePosition: TcxButtonEdit
    Left = 16
    Top = 149
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 2
    Width = 305
  end
  object ceUnit: TcxButtonEdit
    Left = 16
    Top = 63
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 3
    Width = 305
  end
  object ceMember: TcxButtonEdit
    Left = 95
    Top = 20
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 1
    Width = 226
  end
  object edDateIn: TcxDateEdit
    Left = 16
    Top = 195
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 4
    Width = 100
  end
  object edDateOut: TcxDateEdit
    Left = 136
    Top = 195
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 5
    Width = 100
  end
  object cePersonalGroup: TcxButtonEdit
    Left = 16
    Top = 106
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 14
    Width = 305
  end
  object cxLabel1: TcxLabel
    Left = 16
    Top = 89
    Caption = ' '#1043#1088#1091#1087#1087#1080#1088#1086#1074#1082#1080' '#1057#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074' '
  end
  object ActionList: TActionList
    Left = 72
    Top = 216
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
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
    StoredProcName = 'gpInsertUpdate_Object_Personal'
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
        Name = 'inMemberId '
        Component = MemberGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inPositionId'
        Component = PositionGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inUnitId'
        Component = UnitGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inPersonalGroupId'
        Component = PersonalGroupGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inDateIn'
        Component = edDateIn
        DataType = ftDateTime
        ParamType = ptInput
        Value = 0d
      end
      item
        Name = 'inDateOut'
        Component = edDateOut
        DataType = ftDateTime
        ParamType = ptInput
        Value = 0d
      end>
    Left = 275
    Top = 184
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        DataType = ftInteger
        ParamType = ptInputOutput
        Value = '0'
      end>
    Left = 304
    Top = 232
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Personal'
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
        Name = 'MemberId'
        Component = ceMember
        ComponentItem = 'key'
        DataType = ftInteger
        ParamType = ptOutput
      end
      item
        Name = 'MemberName'
        Component = ceMember
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptOutput
      end
      item
        Name = 'PositionId'
        Component = cePosition
        ComponentItem = 'key'
        DataType = ftInteger
        ParamType = ptOutput
      end
      item
        Name = 'PositionName'
        Component = cePosition
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptOutput
      end
      item
        Name = 'UnitId'
        Component = ceUnit
        ComponentItem = 'key'
        DataType = ftInteger
        ParamType = ptOutput
      end
      item
        Name = 'UnitName'
        Component = ceUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptOutput
      end
      item
        Name = 'PersonalGroupId'
        Component = cePersonalGroup
        ComponentItem = 'key'
        DataType = ftInteger
        ParamType = ptOutput
      end
      item
        Name = 'PersonalGroupName'
        Component = cePersonalGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptOutput
      end
      item
        Name = 'DateIn'
        Component = edDateIn
        DataType = ftDateTime
        ParamType = ptOutput
        Value = 0d
      end
      item
        Name = 'DateOut'
        Component = edDateOut
        DataType = ftDateTime
        ParamType = ptOutput
        Value = 0d
      end>
    Left = 248
    Top = 184
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
    Left = 24
    Top = 216
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 120
    Top = 216
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
    Left = 280
    Top = 55
  end
  object MemberGuides: TdsdGuides
    Key = '0'
    LookupControl = ceMember
    FormName = 'TMemberForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Component = MemberGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'TextValue'
        Component = MemberGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    Left = 277
    Top = 8
  end
  object PersonalGroupGuides: TdsdGuides
    Key = '0'
    LookupControl = cePersonalGroup
    FormName = 'TPersonalGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Component = PersonalGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'TextValue'
        Component = PersonalGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    Left = 279
    Top = 96
  end
  object PositionGuides: TdsdGuides
    Key = '0'
    LookupControl = cePosition
    FormName = 'TPositionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Component = PositionGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'TextValue'
        Component = PositionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    Left = 279
    Top = 144
  end
end
