object Report_CashDialogForm: TReport_CashDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1082#1072#1089#1089#1077'>'
  ClientHeight = 181
  ClientWidth = 381
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
    Left = 47
    Top = 131
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 221
    Top = 131
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 8
    Top = 85
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
    Top = 62
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
  end
  object cxLabel1: TcxLabel
    Left = 136
    Top = 7
    Caption = #1050#1072#1089#1089#1072':'
  end
  object ceCash: TcxButtonEdit
    Left = 136
    Top = 27
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 224
  end
  object cxLabel3: TcxLabel
    Left = 136
    Top = 62
    Caption = #1057#1095#1077#1090' '#1085#1072#1079#1074#1072#1085#1080#1077':'
  end
  object edAccount: TcxButtonEdit
    Left = 136
    Top = 85
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 224
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 40
    Top = 32
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 160
    Top = 127
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
    Left = 296
    Top = 113
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
        Name = 'AccountId'
        Value = ''
        Component = GuidesAccount
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'AccountName'
        Value = ''
        Component = GuidesAccount
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'CashId'
        Value = ''
        Component = GuidesCash
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'CashName'
        Value = ''
        Component = GuidesCash
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 40
    Top = 120
  end
  object GuidesAccount: TdsdGuides
    KeyField = 'Id'
    LookupControl = edAccount
    FormNameParam.Value = 'TAccount_ObjectDescForm'
    FormNameParam.DataType = ftString
    FormName = 'TAccount_ObjectDescForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesAccount
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValueAll'
        Value = ''
        Component = GuidesAccount
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inDescCode'
        Value = 'zc_Object_Cash'
        DataType = ftString
      end>
    Left = 208
    Top = 64
  end
  object GuidesCash: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceCash
    FormNameParam.Value = 'TCash_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TCash_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCash
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCash
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        ComponentItem = 'Key'
      end
      item
        Name = 'InfoMoneyName_all'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'ContractId'
        Value = ''
        ComponentItem = 'Key'
      end
      item
        Name = 'ContractName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'PositionId'
        Value = ''
        ComponentItem = 'Key'
      end
      item
        Name = 'PositionName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 248
    Top = 13
  end
end
