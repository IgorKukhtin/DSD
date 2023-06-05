object Report_OrderClient_byBoatDialogForm: TReport_OrderClient_byBoatDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072' '#1082#1083#1080#1077#1085#1090#1072'>'
  ClientHeight = 220
  ClientWidth = 287
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
    Left = 31
    Top = 179
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 146
    Top = 179
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 121
    Top = 27
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 90
  end
  object deStart: TcxDateEdit
    Left = 11
    Top = 27
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 90
  end
  object cxLabel6: TcxLabel
    Left = 11
    Top = 7
    Caption = #1044#1072#1090#1072' '#1089' :'
  end
  object cxLabel7: TcxLabel
    Left = 121
    Top = 7
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
  end
  object cbisProduct: TcxCheckBox
    Left = 8
    Top = 70
    Caption = #1055#1086' '#1083#1086#1076#1082#1072#1084' ('#1044#1072'/'#1053#1077#1090')'
    Properties.ReadOnly = False
    TabOrder = 6
    Width = 148
  end
  object cxLabel15: TcxLabel
    Left = 8
    Top = 97
    Caption = #8470' '#1076#1086#1082'. '#1047#1072#1082#1072#1079
  end
  object edOrderClient: TcxButtonEdit
    Left = 8
    Top = 120
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 257
  end
  object cbisOnlyChild: TcxCheckBox
    Left = 146
    Top = 70
    Hint = #1058#1086#1083#1100#1082#1086' '#1091#1079#1083#1099' ('#1044#1072'/'#1053#1077#1090')'
    Caption = #1058#1086#1083#1100#1082#1086' '#1091#1079#1083#1099' ('#1044#1072'/'#1053#1077#1090')'
    Properties.ReadOnly = False
    TabOrder = 9
    Width = 141
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 152
    Top = 32
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 200
    Top = 140
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
    Left = 184
    Top = 176
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Value = 41579d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = 41608d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isProduct'
        Value = Null
        Component = cbisProduct
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_OrderClient'
        Value = Null
        Component = GuidesOrderClient
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_OrderClient'
        Value = Null
        Component = GuidesOrderClient
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isOnlyChild'
        Value = Null
        Component = cbisOnlyChild
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 164
  end
  object GuidesOrderClient: TdsdGuides
    KeyField = 'Id'
    LookupControl = edOrderClient
    FormNameParam.Value = 'TOrderClientJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TOrderClientJournalChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesOrderClient
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ''
        Component = GuidesOrderClient
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterClientId'
        Value = ''
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterClientName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ClientId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ClientName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 140
    Top = 83
  end
end
