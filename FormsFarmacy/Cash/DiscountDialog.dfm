inherited DiscountDialogForm: TDiscountDialogForm
  ActiveControl = ceDiscountExternal
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1042#1099#1073#1086#1088' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074' - '#1055#1088#1086#1077#1082#1090' ('#1076#1080#1089#1082#1086#1085#1090#1085#1099#1077' '#1082#1072#1088#1090#1099')'
  ClientHeight = 117
  ClientWidth = 554
  Position = poScreenCenter
  ExplicitWidth = 560
  ExplicitHeight = 146
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 16
    Top = 8
    Width = 41
    Height = 13
    Caption = #1055#1088#1086#1077#1082#1090':'
  end
  object Label2: TLabel [1]
    Left = 295
    Top = 8
    Width = 115
    Height = 13
    Caption = #8470' '#1076#1080#1089#1082#1086#1085#1090#1085#1086#1081' '#1082#1072#1088#1090#1099':'
  end
  inherited bbOk: TcxButton
    Left = 190
    Top = 75
    ModalResult = 0
    OnClick = bbOkClick
    ExplicitLeft = 190
    ExplicitTop = 75
  end
  inherited bbCancel: TcxButton
    Left = 311
    Top = 75
    ExplicitLeft = 311
    ExplicitTop = 75
  end
  object ceDiscountExternal: TcxButtonEdit [4]
    Left = 16
    Top = 27
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.Nullstring = '<'#1044#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1084#1077#1085#1077#1076#1078#1077#1088#1072' '#1085#1072#1078#1084#1080#1090#1077' [Ctrl+Enter]>'
    Properties.ReadOnly = True
    Properties.UseNullString = True
    TabOrder = 2
    Text = '<'#1044#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1087#1088#1086#1077#1082#1090#1072' '#1085#1072#1078#1084#1080#1090#1077' [Ctrl+Enter]>'
    Width = 265
  end
  object edCardNumber: TcxTextEdit [5]
    Left = 295
    Top = 27
    TabOrder = 3
    Width = 250
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 51
    Top = 48
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 24
    Top = 48
  end
  inherited ActionList: TActionList
    Left = 79
    Top = 47
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'URL'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Service'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Port'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Password'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 48
  end
  object DiscountExternalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceDiscountExternal
    FormNameParam.Value = 'TDiscountExternal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TDiscountExternal_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = DiscountExternalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = DiscountExternalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 200
    Top = 48
  end
  object spDiscountExternal_Search: TdsdStoredProc
    StoredProcName = 'gpGet_Object_DiscountExternal_Search'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inCode'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDiscountExternalId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDiscountExternalName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 462
    Top = 48
  end
end
