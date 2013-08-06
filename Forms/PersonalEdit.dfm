inherited PersonalEditForm: TPersonalEditForm
  Caption = 'C'#1086#1090#1088#1091#1076#1085#1080#1082
  ClientHeight = 271
  ClientWidth = 607
  ExplicitWidth = 615
  ExplicitHeight = 305
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 168
    Top = 238
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 8
  end
  object cxButton2: TcxButton
    Left = 365
    Top = 235
    Width = 75
    Height = 25
    Action = dsdFormClose1
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 9
  end
  object Код: TcxLabel
    Left = 16
    Top = 3
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 16
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 0
    Width = 273
  end
  object cxLabel3: TcxLabel
    Left = 168
    Top = 167
    Caption = #1044#1072#1090#1072' '#1087#1088#1080#1085#1103#1090#1080#1103
  end
  object cxLabel2: TcxLabel
    Left = 319
    Top = 167
    Caption = #1044#1072#1090#1072' '#1091#1074#1086#1083#1100#1085#1077#1085#1080#1103
  end
  object cxLabel5: TcxLabel
    Left = 16
    Top = 117
    Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
  end
  object cxLabel6: TcxLabel
    Left = 15
    Top = 63
    Caption = #1060#1080#1079#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
  end
  object cxLabel7: TcxLabel
    Left = 319
    Top = 3
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
  end
  object cxLabel8: TcxLabel
    Left = 319
    Top = 63
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
  end
  object cxLabel9: TcxLabel
    Left = 319
    Top = 121
    Caption = #1041#1080#1079#1085#1077#1089
  end
  object cePosition: TcxButtonEdit
    Left = 16
    Top = 140
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 2
    Width = 273
  end
  object ceUnit: TcxButtonEdit
    Left = 319
    Top = 26
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 3
    Width = 273
  end
  object ceJuridical: TcxButtonEdit
    Left = 319
    Top = 86
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 4
    Width = 273
  end
  object ceBusiness: TcxButtonEdit
    Left = 319
    Top = 140
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 5
    Width = 273
  end
  object ceMember: TcxButtonEdit
    Left = 15
    Top = 86
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 1
    Width = 273
  end
  object edDateIn: TcxDateEdit
    Left = 168
    Top = 192
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 6
    Width = 121
  end
  object edDateOut: TcxDateEdit
    Left = 319
    Top = 192
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 7
    Width = 121
  end
  object ActionList: TActionList
    Left = 296
    Top = 40
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
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inPositionId'
        Component = PositionGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inUnitId'
        Component = UnitGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inJuridicalId'
        Component = JuridicalGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inBusinessId'
        Component = BusinessGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inDateIn'
        DataType = ftDateTime
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'inDateOut'
        DataType = ftDateTime
        ParamType = ptInput
        Value = Null
      end>
    Left = 504
    Top = 40
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        DataType = ftInteger
        ParamType = ptInputOutput
        Value = '0'
      end>
    Left = 224
    Top = 16
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
        Component = MemberGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'MemberName'
        Component = MemberGuides
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'PositionId'
        Component = PositionGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'PositionName'
        Component = PositionGuides
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'UnitId'
        Component = UnitGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'UnitName'
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'JuridicalId'
        Component = JuridicalGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'JuridicalName'
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'BusinessId'
        Component = BusinessGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'BusinessName'
        Component = BusinessGuides
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'DateIn'
        Component = edDateIn
        DataType = ftInteger
        ParamType = ptOutput
        Value = 0d
      end
      item
        Name = 'DateOut'
        Component = edDateOut
        DataType = ftInteger
        ParamType = ptOutput
        Value = 0d
      end>
    Left = 472
    Top = 168
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
    Left = 136
    Top = 40
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 512
    Top = 184
  end
  object MemberGuides: TdsdGuides
    LookupControl = ceMember
    FormName = 'TMemberForm'
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 296
    Top = 93
  end
  object PositionGuides: TdsdGuides
    LookupControl = cePosition
    FormName = 'TPositionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 288
    Top = 165
  end
  object UnitGuides: TdsdGuides
    LookupControl = ceUnit
    FormName = 'TUnitForm'
    PositionDataSet = 'GridDataSet'
    Params = <>
    Left = 487
    Top = 7
  end
  object JuridicalGuides: TdsdGuides
    LookupControl = ceJuridical
    FormName = 'TJuridicalForm'
    PositionDataSet = 'GridDataSet'
    Params = <>
    Left = 559
    Top = 65
  end
  object BusinessGuides: TdsdGuides
    LookupControl = ceBusiness
    FormName = 'TBusinessForm'
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 527
    Top = 113
  end
end
