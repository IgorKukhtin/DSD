inherited MemberEditForm: TMemberEditForm
  Caption = #1060#1080#1079#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
  ClientHeight = 200
  ClientWidth = 338
  ExplicitWidth = 346
  ExplicitHeight = 227
  PixelsPerInch = 96
  TextHeight = 13
  object edMeasureName: TcxTextEdit
    Left = 32
    Top = 86
    TabOrder = 0
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 32
    Top = 63
    Caption = #1060#1048#1054
  end
  object cxButton1: TcxButton
    Left = 64
    Top = 163
    Width = 75
    Height = 25
    Action = InsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 216
    Top = 163
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
  object ceINN: TcxTextEdit
    Left = 32
    Top = 136
    TabOrder = 6
    Width = 273
  end
  object cxLabel2: TcxLabel
    Left = 32
    Top = 113
    Caption = #1048#1053#1053
  end
  object ActionList: TActionList
    Left = 256
    Top = 88
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
    StoredProcName = 'gpInsertUpdate_Object_Member'
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
        Component = edMeasureName
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inINN'
        Component = ceINN
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    Left = 232
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
    Left = 120
    Top = 136
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Member'
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
        Component = edMeasureName
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'INN'
        Component = ceINN
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end>
    Left = 192
    Top = 104
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
    Top = 96
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 168
  end
end
