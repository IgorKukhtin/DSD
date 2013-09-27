inherited FuelEditForm: TFuelEditForm
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1042#1080#1076#1072' '#1090#1086#1087#1083#1080#1074#1072
  ClientHeight = 256
  ClientWidth = 346
  ExplicitWidth = 354
  ExplicitHeight = 290
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 40
    Top = 71
    TabOrder = 0
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 40
    Top = 48
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 72
    Top = 219
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 216
    Top = 219
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
    Width = 273
  end
  object cxLabel3: TcxLabel
    Left = 40
    Top = 151
    Caption = #1042#1080#1076' '#1085#1086#1088#1084' '#1090#1086#1087#1083#1080#1074#1072
  end
  object cxLabel2: TcxLabel
    Left = 40
    Top = 101
    Caption = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090' '#1087#1077#1088#1077#1074#1086#1076#1072' '#1085#1086#1088#1084#1099
  end
  object edRatio: TcxTextEdit
    Left = 40
    Top = 124
    TabOrder = 8
    Width = 273
  end
  object edRateFuelKind: TcxButtonEdit
    Left = 40
    Top = 174
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 9
    Width = 273
  end
  object ActionList: TActionList
    Left = 296
    Top = 72
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
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'Ok'
    end
    object dsdFormClose: TdsdFormClose
      Category = 'DSDLib'
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Fuel'
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
        Name = 'inRatio'
        Component = edRatio
        DataType = ftFloat
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inRateFuelKindId '
        Component = RateFuelKindGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end>
    Left = 240
    Top = 48
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        DataType = ftInteger
        ParamType = ptInputOutput
        Value = '0'
      end>
    Left = 240
    Top = 8
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Fuel'
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
        Name = 'Ratio'
        Component = edRatio
        DataType = ftFloat
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'RateFuelKindId'
        Component = RateFuelKindGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'RateFuelKindName'
        Component = edRateFuelKind
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
      end>
    Left = 152
    Top = 112
  end
  object RateFuelKindGuides: TdsdGuides
    LookupControl = edRateFuelKind
    FormName = 'TRateFuelKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Component = RateFuelKindGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'TextValue'
        Component = RateFuelKindGuides
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end>
    Left = 112
    Top = 165
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 248
    Top = 144
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
    Left = 296
    Top = 104
  end
end
