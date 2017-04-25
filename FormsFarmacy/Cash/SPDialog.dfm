inherited SPDialogForm: TSPDialogForm
  ActiveControl = cePartnerMedical
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1042#1099#1073#1086#1088' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074' - '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090
  ClientHeight = 166
  ClientWidth = 554
  Position = poDesktopCenter
  ExplicitWidth = 560
  ExplicitHeight = 191
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 16
    Top = 8
    Width = 138
    Height = 13
    Caption = #1052#1077#1076#1080#1094#1080#1085#1089#1082#1086#1077' '#1091#1095#1088#1077#1078#1076#1077#1085#1080#1077':'
  end
  object Label2: TLabel [1]
    Left = 25
    Top = 58
    Width = 56
    Height = 13
    Caption = #1060#1048#1054' '#1074#1088#1072#1095#1072
  end
  inherited bbOk: TcxButton
    Left = 190
    Top = 123
    ModalResult = 0
    OnClick = bbOkClick
    ExplicitLeft = 190
    ExplicitTop = 123
  end
  inherited bbCancel: TcxButton
    Left = 311
    Top = 123
    ExplicitLeft = 311
    ExplicitTop = 123
  end
  object cePartnerMedical: TcxButtonEdit [4]
    Left = 16
    Top = 27
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.Nullstring = '<'#1044#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1052#1077#1076#1080#1094#1080#1085#1089#1082#1086#1075#1086' '#1091#1095#1088#1077#1078#1076#1077#1085#1080#1103' '#1085#1072#1078#1084#1080#1090#1077' [Ctrl+Enter]>'
    Properties.ReadOnly = True
    Properties.UseNullString = True
    TabOrder = 2
    Text = '<'#1044#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1052#1077#1076#1080#1094#1080#1085#1089#1082#1086#1075#1086' '#1091#1095#1088#1077#1078#1076#1077#1085#1080#1103' '#1085#1072#1078#1084#1080#1090#1077' [Ctrl+Enter]>'
    Width = 265
  end
  object edMedicSP: TcxTextEdit [5]
    Left = 16
    Top = 74
    TabOrder = 3
    Width = 265
  end
  object cxLabel13: TcxLabel [6]
    Left = 433
    Top = 54
    Caption = #1044#1072#1090#1072' '#1088#1077#1094#1077#1087#1090#1072
  end
  object edOperDateSP: TcxDateEdit [7]
    Left = 433
    Top = 74
    EditValue = 42261d
    Properties.ReadOnly = False
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 5
    Width = 90
  end
  object cxLabel14: TcxLabel [8]
    Left = 297
    Top = 56
    Caption = #1053#1086#1084#1077#1088' '#1088#1077#1094#1077#1087#1090#1072
  end
  object edInvNumberSP: TcxTextEdit [9]
    Left = 297
    Top = 74
    Properties.ReadOnly = False
    TabOrder = 7
    Width = 116
  end
  object cxLabel17: TcxLabel [10]
    Left = 297
    Top = 8
    Caption = #8470' '#1072#1084#1073#1091#1083#1072#1090#1086#1088#1080#1080' '
  end
  object edAmbulance: TcxTextEdit [11]
    Left = 297
    Top = 27
    Properties.ReadOnly = False
    TabOrder = 9
    Width = 116
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Top = 104
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Top = 104
  end
  inherited ActionList: TActionList
    Top = 103
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'PartnerMedicalId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerMedicalName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Ambulance'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MedicSP'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberSP'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDateSP'
        Value = 'NULL'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 104
    Top = 104
  end
  object PartnerMedicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePartnerMedical
    FormNameParam.Value = 'TPartnerMedicalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartnerMedicalForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PartnerMedicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PartnerMedicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 192
    Top = 8
  end
end
