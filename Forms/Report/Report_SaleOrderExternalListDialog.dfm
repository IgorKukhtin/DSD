object Report_SaleOrderExternalListDialogForm: TReport_SaleOrderExternalListDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1079#1072#1103#1074#1086#1082' '#1080' '#1087#1088#1086#1076#1072#1078'>'
  ClientHeight = 220
  ClientWidth = 329
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 55
    Top = 184
    Width = 75
    Height = 23
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 189
    Top = 184
    Width = 75
    Height = 23
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 8
    Top = 75
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 100
  end
  object deStart: TcxDateEdit
    Left = 8
    Top = 27
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 100
  end
  object cxLabel6: TcxLabel
    Left = 8
    Top = 7
    Caption = #1044#1072#1090#1072' '#1089' :'
  end
  object cxLabel7: TcxLabel
    Left = 8
    Top = 55
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
  end
  object cxLabel8: TcxLabel
    Left = 8
    Top = 118
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
  end
  object edUnit: TcxButtonEdit
    Left = 8
    Top = 141
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 313
  end
  object cbSale: TcxCheckBox
    Left = 131
    Top = 27
    Hint = #1086#1090#1075#1088#1091#1078#1077#1085#1085#1099#1077' '#1079#1072#1103#1074#1082#1080
    Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1086#1090#1075#1088#1091#1078#1077#1085#1085#1099#1077' '#1079#1072#1103#1074#1082#1080
    Properties.ReadOnly = False
    TabOrder = 8
    Width = 184
  end
  object cbNoSale: TcxCheckBox
    Left = 131
    Top = 75
    Hint = #1085#1077' '#1086#1090#1075#1088#1091#1078#1077#1085#1085#1099#1077' '#1079#1072#1103#1074#1082#1080
    Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1086#1090#1075#1088#1091#1078#1077#1085#1085#1099#1077' '#1079#1072#1103#1074#1082#1080
    Properties.ReadOnly = False
    TabOrder = 9
    Width = 198
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 56
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 160
    Top = 172
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
    Left = 36
    Top = 65
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Value = 41579d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'EndDate'
        Value = 41608d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'UnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'isSale'
        Value = Null
        Component = cbSale
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'isNoSale'
        Value = Null
        Component = cbNoSale
        DataType = ftBoolean
        ParamType = ptInput
      end>
    Left = 208
    Top = 120
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 112
    Top = 119
  end
end
