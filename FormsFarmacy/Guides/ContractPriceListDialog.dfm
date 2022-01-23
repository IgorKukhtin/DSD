object ContractPriceListDialogForm: TContractPriceListDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1086#1088' '#1076#1086#1075#1086#1074#1086#1088#1072' '#1080#1079' '#1079#1072#1075#1088#1091#1078#1077#1085#1085#1099#1093' '#1087#1088#1072#1081#1089#1083#1080#1089#1090#1086#1074
  ClientHeight = 136
  ClientWidth = 340
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.Params = FormParams
  DesignSize = (
    340
    136)
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 42
    Top = 99
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 216
    Top = 99
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object edContractPriceList: TcxButtonEdit
    Left = 10
    Top = 49
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 2
    Width = 315
  end
  object cxLabel3: TcxLabel
    Left = 10
    Top = 29
    Caption = #1055#1088#1072#1081#1089' '#1083#1080#1089#1090':'
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 158
    Top = 69
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Left'
          'Top')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 271
    Top = 70
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ContractPriceListId'
        Value = ''
        Component = ContractPriceListGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractPriceListName'
        Value = ''
        Component = ContractPriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'AreaName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 158
    Top = 20
  end
  object ContractPriceListGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContractPriceList
    Key = '0'
    FormNameParam.Value = 'TContractPriceListForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractPriceListForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractPriceListGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractPriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'AreaName'
        Value = Null
        Component = FormParams
        ComponentItem = 'AreaName'
        MultiSelectSeparator = ','
      end>
    Left = 38
    Top = 68
  end
end
