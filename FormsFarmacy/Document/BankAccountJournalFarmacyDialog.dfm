object BankAccountJournalFarmacyDialogForm: TBankAccountJournalFarmacyDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1086#1088' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074' '#1078#1091#1088#1085#1072#1083#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
  ClientHeight = 223
  ClientWidth = 417
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
    Left = 94
    Top = 188
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 268
    Top = 188
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 120
    Top = 39
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 90
  end
  object deStart: TcxDateEdit
    Left = 120
    Top = 12
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 90
  end
  object cxLabel6: TcxLabel
    Left = 27
    Top = 13
    Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
  end
  object cxLabel7: TcxLabel
    Left = 8
    Top = 40
    Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
  end
  object sbIsPartnerDate: TcxCheckBox
    Left = 224
    Top = 12
    Caption = #1055#1077#1088#1080#1086#1076' '#1076#1083#1103' '#1044#1072#1090#1072' '#1055#1053' '#1087#1086#1089#1090'-'#1082#1072
    TabOrder = 6
    Width = 178
  end
  object cxLabel4: TcxLabel
    Left = 29
    Top = 76
    Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090':'
  end
  object cxLabel1: TcxLabel
    Left = 37
    Top = 111
    Caption = #1054#1090' '#1050#1086#1075#1086', '#1050#1086#1084#1091':'
  end
  object ceBankAccount: TcxButtonEdit
    Left = 120
    Top = 75
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 282
  end
  object ceObject: TcxButtonEdit
    Left = 120
    Top = 110
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 282
  end
  object cxLabel3: TcxLabel
    Left = 40
    Top = 146
    Caption = #1053#1072#1096#1077' '#1070#1088'.'#1083#1080#1094#1086
  end
  object ceJuridicalCorporate: TcxButtonEdit
    Left = 120
    Top = 145
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 282
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 152
    Top = 104
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 203
    Top = 29
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
    Left = 328
    Top = 28
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
        Name = 'IsPartnerDate'
        Value = Null
        Component = sbIsPartnerDate
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'BankAccountId'
        Value = Null
        Component = BankAccountGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'BankAccountName'
        Value = Null
        Component = BankAccountGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ObjectId'
        Value = Null
        Component = ObjectGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'ObjectName'
        Value = Null
        Component = ObjectGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'JuridicalCorporateId'
        Value = Null
        Component = JuridicalCorporateGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'JuridicalCorporateName'
        Value = Null
        Component = JuridicalCorporateGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 23
    Top = 102
  end
  object BankAccountGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBankAccount
    FormNameParam.Value = 'TBankAccount_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TBankAccount_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BankAccountGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BankAccountGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
      end>
    Left = 196
    Top = 69
  end
  object ObjectGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceObject
    FormNameParam.Value = 'TMoneyPlace_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TMoneyPlace_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ObjectGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ObjectGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 278
    Top = 84
  end
  object JuridicalCorporateGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridicalCorporate
    FormNameParam.Value = 'TJuridicalCorporateForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridicalCorporateForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalCorporateGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalCorporateGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 218
    Top = 116
  end
end
