object Report_OrderInternalDialogForm: TReport_OrderInternalDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1087#1086' '#1047#1072#1082#1072#1079#1072#1084' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072'>'
  ClientHeight = 187
  ClientWidth = 373
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
    Left = 78
    Top = 143
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 208
    Top = 143
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
  object edGoods: TcxButtonEdit
    Left = 8
    Top = 87
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 345
  end
  object cxLabel2: TcxLabel
    Left = 8
    Top = 64
    Caption = #1059#1079#1077#1083':'
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
  object cbisEmpty: TcxCheckBox
    Left = 397
    Top = 8
    Caption = #1041#1077#1079' '#1079#1072#1082#1072#1079#1072' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1091
    Properties.ReadOnly = False
    TabOrder = 8
    Visible = False
    Width = 153
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 224
    Top = 8
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 152
    Top = 56
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
    Left = 200
    Top = 108
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
        Name = 'GoodsId'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 40
    Top = 128
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TOrderClientJournalChoiceItemForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TOrderClientJournalChoiceItemForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'ObjectId'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ObjectName'
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 272
    Top = 79
  end
end
