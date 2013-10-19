object StaffListEditForm: TStaffListEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1064#1090#1072#1090#1085#1091#1102' '#1077#1076#1080#1085#1080#1094#1091'>'
  ClientHeight = 398
  ClientWidth = 355
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object cxLabel1: TcxLabel
    Left = 192
    Top = 19
    Caption = #1050#1086#1083'. '#1077#1076#1080#1085#1080#1094
  end
  object cxButton1: TcxButton
    Left = 64
    Top = 353
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 1
  end
  object cxButton2: TcxButton
    Left = 205
    Top = 353
    Width = 75
    Height = 25
    Action = dsdFormClose1
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 2
  end
  object cxLabel2: TcxLabel
    Left = 35
    Top = 19
    Caption = #1055#1083#1072#1085' '#1095#1072#1089#1086#1074
  end
  object cxLabel3: TcxLabel
    Left = 34
    Top = 69
    Caption = #1060#1086#1085#1076' '#1086#1087#1083#1072#1090#1099' ('#1079#1072' '#1084#1077#1089#1103#1094')'
  end
  object cxLabel5: TcxLabel
    Left = 35
    Top = 131
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object ceUnit: TcxButtonEdit
    Left = 35
    Top = 154
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 6
    Width = 270
  end
  object cxLabel6: TcxLabel
    Left = 35
    Top = 181
    Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
  end
  object cePosition: TcxButtonEdit
    Left = 35
    Top = 204
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 8
    Width = 270
  end
  object cxLabel7: TcxLabel
    Left = 35
    Top = 231
    Caption = #1056#1072#1079#1088#1103#1076
  end
  object cePositionLevel: TcxButtonEdit
    Left = 34
    Top = 254
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 10
    Width = 270
  end
  object cxLabel4: TcxLabel
    Left = 183
    Top = 69
    Caption = #1060#1086#1085#1076' '#1086#1087#1083#1072#1090#1099' ('#1079#1072' '#1076#1077#1085#1100')'
  end
  object edComment: TcxTextEdit
    Left = 35
    Top = 312
    TabOrder = 12
    Width = 270
  end
  object cxLabel8: TcxLabel
    Left = 35
    Top = 289
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object edPersonalCount: TcxCurrencyEdit
    Left = 181
    Top = 42
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 14
    Width = 123
  end
  object edHoursPlan: TcxCurrencyEdit
    Left = 35
    Top = 42
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 15
    Width = 123
  end
  object edFundPayMonth: TcxCurrencyEdit
    Left = 35
    Top = 92
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 16
    Width = 123
  end
  object edFundPayTurn: TcxCurrencyEdit
    Left = 181
    Top = 92
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 17
    Width = 123
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
    StoredProcName = 'gpInsertUpdate_Object_StaffList'
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
        Name = 'inHoursPlan'
        Value = 0.000000000000000000
        Component = edHoursPlan
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPersonalCount'
        Value = 0.000000000000000000
        Component = edPersonalCount
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inFundPayMonth'
        Value = 0.000000000000000000
        Component = edFundPayMonth
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inFundPayTurn'
        Value = 0.000000000000000000
        Component = edFundPayTurn
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Value = ''
        Component = edComment
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = UnitGuides
        ParamType = ptInput
      end
      item
        Name = 'inPositionId'
        Value = ''
        Component = PositionGuides
        ParamType = ptInput
      end
      item
        Name = 'inPositionLevelId'
        Value = ''
        Component = PositionLevelGuides
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
    StoredProcName = 'gpGet_Object_StaffList'
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
        Name = 'HoursPlan'
        Value = 0.000000000000000000
        Component = edHoursPlan
        DataType = ftFloat
      end
      item
        Name = 'PersonalCount'
        Value = 0.000000000000000000
        Component = edPersonalCount
        DataType = ftFloat
      end
      item
        Name = 'FundPayMonth'
        Value = 0.000000000000000000
        Component = edFundPayMonth
        DataType = ftFloat
      end
      item
        Name = 'FundPayTurn'
        Value = 0.000000000000000000
        Component = edFundPayTurn
        DataType = ftFloat
      end
      item
        Name = 'Comment'
        Value = ''
        Component = edComment
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
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormName = 'TUnitForm'
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
    Left = 167
    Top = 135
  end
  object PositionGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePosition
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
    Left = 207
    Top = 191
  end
  object PositionLevelGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePositionLevel
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
    Left = 143
    Top = 239
  end
end
