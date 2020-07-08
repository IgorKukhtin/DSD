inherited HouseholdInventoryEditForm: THouseholdInventoryEditForm
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1061#1086#1079#1103#1081#1089#1090#1074#1077#1085#1085#1099#1081' '#1080#1085#1074#1077#1085#1090#1072#1088#1100' >'
  ClientHeight = 146
  ClientWidth = 467
  ExplicitWidth = 473
  ExplicitHeight = 175
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 97
    Top = 103
    TabOrder = 2
    ExplicitLeft = 97
    ExplicitTop = 103
  end
  inherited bbCancel: TcxButton
    Left = 270
    Top = 103
    TabOrder = 3
    ExplicitLeft = 270
    ExplicitTop = 103
  end
  object edName: TcxTextEdit [2]
    Left = 7
    Top = 66
    TabOrder = 1
    Width = 434
  end
  object cxLabel1: TcxLabel [3]
    Left = 7
    Top = 50
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object Код: TcxLabel [4]
    Left = 7
    Top = 4
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit [5]
    Left = 7
    Top = 22
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 0
    Width = 74
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 67
    Top = 88
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 400
    Top = 32
  end
  inherited ActionList: TActionList
    Images = dmMain.ImageList
    Left = 175
    Top = 79
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
        end>
    end
    inherited InsertUpdateGuides: TdsdInsertUpdateGuides
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end
        item
        end>
    end
  end
  inherited FormParams: TdsdFormParams
    Left = 368
    Top = 80
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_HouseholdInventory'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = ceCode
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 328
    Top = 32
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_HouseholdInventory'
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 272
    Top = 88
  end
end
