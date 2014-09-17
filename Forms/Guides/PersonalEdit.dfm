object PersonalEditForm: TPersonalEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <C'#1086#1090#1088#1091#1076#1085#1080#1082'>'
  ClientHeight = 334
  ClientWidth = 331
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
    Left = 72
    Top = 294
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 6
  end
  object cxButton2: TcxButton
    Left = 176
    Top = 294
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
  object ceMemberCode: TcxCurrencyEdit
    Left = 16
    Top = 20
    Enabled = False
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 0
    Width = 73
  end
  object cxLabel3: TcxLabel
    Left = 16
    Top = 211
    Caption = #1044#1072#1090#1072' '#1087#1088#1080#1077#1084#1072
  end
  object cxLabel2: TcxLabel
    Left = 130
    Top = 211
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
    Properties.ReadOnly = True
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
    Properties.ReadOnly = True
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
    Properties.ReadOnly = True
    TabOrder = 1
    Width = 226
  end
  object edDateIn: TcxDateEdit
    Left = 16
    Top = 231
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 4
    Width = 92
  end
  object edDateOut: TcxDateEdit
    Left = 130
    Top = 231
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 5
    Width = 92
  end
  object cePersonalGroup: TcxButtonEdit
    Left = 16
    Top = 106
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 14
    Width = 305
  end
  object cxLabel1: TcxLabel
    Left = 16
    Top = 89
    Caption = ' '#1043#1088#1091#1087#1087#1080#1088#1086#1074#1082#1080' '#1057#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074' '
  end
  object cxLabel4: TcxLabel
    Left = 16
    Top = 171
    Caption = #1056#1072#1079#1088#1103#1076' '#1076#1086#1083#1078#1085#1086#1089#1090#1080
  end
  object cePositionLevel: TcxButtonEdit
    Left = 16
    Top = 188
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 305
  end
  object cbDateOut: TcxCheckBox
    Left = 233
    Top = 231
    Hint = #1054#1092#1086#1088#1084#1083#1077#1085' '#1086#1092#1080#1094#1080#1072#1083#1100#1085#1086
    Caption = #1059#1074#1086#1083#1077#1085
    TabOrder = 18
    Width = 79
  end
  object cbMain: TcxCheckBox
    Left = 18
    Top = 259
    Hint = #1054#1092#1086#1088#1084#1083#1077#1085' '#1086#1092#1080#1094#1080#1072#1083#1100#1085#1086
    Caption = #1054#1089#1085#1086#1074#1085#1086#1077' '#1084#1077#1089#1090#1086' '#1088#1072#1073#1086#1090#1099
    TabOrder = 19
    Width = 186
  end
  object ActionList: TActionList
    Left = 64
    Top = 272
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
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
      RefreshOnTabSetChanges = False
    end
    object dsdFormClose1: TdsdFormClose
      MoveParams = <>
    end
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
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
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inMemberId '
        Value = ''
        Component = MemberGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPositionId'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPositionLevelId'
        Value = ''
        Component = PositionLevelGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPersonalGroupId'
        Value = ''
        Component = PersonalGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inDateIn'
        Value = 0d
        Component = edDateIn
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inDateOut'
        Value = 0d
        Component = edDateOut
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inIsDateOut'
        Value = 'False'
        Component = cbDateOut
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inIsMain'
        Value = 'False'
        Component = cbMain
        DataType = ftBoolean
        ParamType = ptInput
      end>
    Left = 115
    Top = 166
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
      end
      item
        Name = 'MaskId'
        Value = Null
        ParamType = ptInputOutput
      end>
    Left = 88
    Top = 96
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Personal'
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
        Name = 'MaskId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'MaskId'
        ParamType = ptInput
      end
      item
        Name = 'MemberCode'
        Value = 0.000000000000000000
        Component = ceMemberCode
      end
      item
        Name = 'MemberId'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'MemberName'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'PositionId'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PositionName'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'PositionLevelId'
        Value = ''
        Component = PositionLevelGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PositionLevelName'
        Value = ''
        Component = PositionLevelGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'UnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'PersonalGroupId'
        Value = ''
        Component = PersonalGroupGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PersonalGroupName'
        Value = ''
        Component = PersonalGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'DateIn'
        Value = 0d
        Component = edDateIn
        DataType = ftDateTime
      end
      item
        Name = 'DateOut'
        Value = 0d
        Component = edDateOut
        DataType = ftDateTime
      end
      item
        Name = 'IsDateOut'
        Value = 'False'
        Component = cbDateOut
        DataType = ftBoolean
      end
      item
        Name = 'IsMain'
        Value = 'False'
        Component = cbMain
        DataType = ftBoolean
      end>
    Left = 96
    Top = 134
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
    Left = 16
    Top = 272
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 112
    Top = 272
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnit_ObjectForm'
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
    Left = 280
    Top = 55
  end
  object MemberGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMember
    FormNameParam.Value = 'TMemberForm'
    FormNameParam.DataType = ftString
    FormName = 'TMemberForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceMemberCode
        ComponentItem = 'Code'
      end>
    Left = 277
    Top = 8
  end
  object PersonalGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePersonalGroup
    FormNameParam.Value = 'TPersonalGroupForm'
    FormNameParam.DataType = ftString
    FormName = 'TPersonalGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PersonalGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PersonalGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 279
    Top = 96
  end
  object PositionGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePosition
    FormNameParam.Value = 'TPositionForm'
    FormNameParam.DataType = ftString
    FormName = 'TPositionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 279
    Top = 144
  end
  object PositionLevelGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePositionLevel
    FormNameParam.Value = 'TPositionLevelForm'
    FormNameParam.DataType = ftString
    FormName = 'TPositionLevelForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PositionLevelGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PositionLevelGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 287
    Top = 185
  end
end
