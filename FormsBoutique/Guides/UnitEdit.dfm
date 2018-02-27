object UnitEditForm: TUnitEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103'>'
  ClientHeight = 476
  ClientWidth = 302
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 10
    Top = 72
    TabOrder = 0
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 10
    Top = 54
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 41
    Top = 443
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    TabOrder = 8
  end
  object cxButton2: TcxButton
    Left = 185
    Top = 443
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 9
  end
  object cxLabel2: TcxLabel
    Left = 10
    Top = 8
    Caption = #1050#1086#1076
  end
  object edCode: TcxCurrencyEdit
    Left = 10
    Top = 30
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 273
  end
  object cxLabel3: TcxLabel
    Left = 10
    Top = 219
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
  end
  object ceJuridical: TcxButtonEdit
    Left = 8
    Top = 235
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 275
  end
  object edDiscountTax: TcxCurrencyEdit
    Left = 10
    Top = 195
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = '0'
    TabOrder = 3
    Width = 95
  end
  object edAddress: TcxTextEdit
    Left = 10
    Top = 112
    TabOrder = 1
    Width = 273
  end
  object cxLabel4: TcxLabel
    Left = 10
    Top = 94
    Caption = #1040#1076#1088#1077#1089
  end
  object edPhone: TcxTextEdit
    Left = 10
    Top = 152
    TabOrder = 2
    Width = 273
  end
  object cxLabel5: TcxLabel
    Left = 10
    Top = 134
    Caption = #1058#1077#1083#1077#1092#1086#1085
  end
  object cxLabel6: TcxLabel
    Left = 10
    Top = 175
    Caption = '% '#1089#1082#1080#1076#1082#1080' OUTLET'
  end
  object cxLabel7: TcxLabel
    Left = 10
    Top = 261
    Caption = #1043#1088#1091#1087#1087#1072
  end
  object ceParent: TcxButtonEdit
    Left = 8
    Top = 277
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 275
  end
  object cxLabel8: TcxLabel
    Left = 10
    Top = 304
    Caption = #1057#1082#1083#1072#1076
  end
  object ceChild: TcxButtonEdit
    Left = 8
    Top = 320
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 275
  end
  object cxLabel9: TcxLabel
    Left = 10
    Top = 344
    Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090
  end
  object ceBankAccount: TcxButtonEdit
    Left = 8
    Top = 360
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 275
  end
  object cxLabel10: TcxLabel
    Left = 10
    Top = 387
    Caption = #1040#1085#1072#1083#1080#1090#1080#1082#1080' '#1089#1095#1077#1090#1086#1074' - '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
  end
  object ceAccountDirection: TcxButtonEdit
    Left = 8
    Top = 403
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 21
    Width = 275
  end
  object cxLabel11: TcxLabel
    Left = 113
    Top = 177
    Caption = #1055#1088#1080#1085#1090#1077#1088' ('#1087#1077#1095#1072#1090#1100' '#1095#1077#1082#1086#1074')'
  end
  object edPrinter: TcxTextEdit
    Left = 113
    Top = 195
    TabOrder = 23
    Width = 170
  end
  object ActionList: TActionList
    Left = 176
    Top = 8
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
    StoredProcName = 'gpInsertUpdate_Object_Unit'
    DataSets = <>
    OutputType = otResult
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
        Name = 'ioCode'
        Value = Null
        Component = edCode
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAddress'
        Value = Null
        Component = edAddress
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPhone'
        Value = Null
        Component = edPhone
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrinter'
        Value = Null
        Component = edPrinter
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscountTax'
        Value = Null
        Component = edDiscountTax
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = ParentGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChildId'
        Value = Null
        Component = ChildGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankAccountId'
        Value = Null
        Component = BankAccountGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAccountDirectionId'
        Value = Null
        Component = AccountDirectionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 96
    Top = 48
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 8
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Unit'
    DataSets = <>
    OutputType = otResult
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
        Component = edCode
        DataType = ftUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Address'
        Value = Null
        Component = edAddress
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Phone'
        Value = Null
        Component = edPhone
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Printer'
        Value = Null
        Component = edPrinter
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountTax'
        Value = Null
        Component = edDiscountTax
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = Null
        Component = JuridicalGuides
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = Null
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParentId'
        Value = Null
        Component = ParentGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParentName'
        Value = Null
        Component = ParentGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChildId'
        Value = Null
        Component = ChildGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChildName'
        Value = Null
        Component = ChildGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankAccountId'
        Value = Null
        Component = BankAccountGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankAccountName'
        Value = Null
        Component = BankAccountGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountDirectionId'
        Value = Null
        Component = AccountDirectionGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountDirectionName'
        Value = Null
        Component = AccountDirectionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 240
    Top = 8
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
    Left = 176
    Top = 56
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 200
    Top = 104
  end
  object JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridical
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 200
    Top = 216
  end
  object ParentGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceParent
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ParentGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ParentGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 192
    Top = 250
  end
  object ChildGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceChild
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ChildGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ChildGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 192
    Top = 293
  end
  object BankAccountGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBankAccount
    FormNameParam.Value = 'TBankAccountForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankAccountForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BankAccountGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BankAccountGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 184
    Top = 325
  end
  object AccountDirectionGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceAccountDirection
    FormNameParam.Value = 'TAccountDirection_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAccountDirection_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = AccountDirectionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = AccountDirectionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 152
    Top = 397
  end
end
