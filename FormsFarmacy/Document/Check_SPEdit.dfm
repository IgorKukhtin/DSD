object Check_SPEditForm: TCheck_SPEditForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1055
  ClientHeight = 253
  ClientWidth = 323
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
    Left = 45
    Top = 218
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 206
    Top = 218
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deOperDateSP: TcxDateEdit
    Left = 124
    Top = 11
    EditValue = 42705d
    Properties.DateButtons = [btnClear, btnNow, btnToday]
    Properties.PostPopupValueOnTab = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 2
    Width = 82
  end
  object cxLabel6: TcxLabel
    Left = 34
    Top = 12
    Caption = #1044#1072#1090#1072' '#1088#1077#1094#1077#1087#1090#1072
  end
  object cxLabel14: TcxLabel
    Left = 34
    Top = 48
    Caption = #1053#1086#1084#1077#1088' '#1088#1077#1094#1077#1087#1090#1072
  end
  object edInvNumberSP: TcxTextEdit
    Left = 124
    Top = 47
    TabOrder = 5
    Width = 160
  end
  object cxLabel16: TcxLabel
    Left = 34
    Top = 88
    Caption = #1060#1048#1054' '#1074#1088#1072#1095#1072
  end
  object cxLabel17: TcxLabel
    Left = 34
    Top = 128
    Caption = #8470' '#1072#1084#1073#1091#1083#1072#1090#1086#1088#1080#1080' '
  end
  object edAmbulance: TcxTextEdit
    Left = 124
    Top = 127
    TabOrder = 8
    Width = 160
  end
  object edMedicSP: TcxTextEdit
    Left = 124
    Top = 87
    TabOrder = 9
    Width = 160
  end
  object cxLabel12: TcxLabel
    Left = 34
    Top = 163
    Caption = #1052#1077#1076#1080#1094#1080#1085#1089#1082#1086#1077' '#1091#1095#1088#1077#1078#1076'.('#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090')'
  end
  object edPartnerMedical: TcxButtonEdit
    Left = 34
    Top = 182
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 250
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 263
    Top = 113
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
    Left = 264
    Top = 44
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inOperDateSP'
        Value = 41579d
        Component = deOperDateSP
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumberSP'
        Value = Null
        Component = edInvNumberSP
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMedicSPName'
        Value = Null
        Component = edMedicSP
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmbulance'
        Value = Null
        Component = edAmbulance
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerMedicalId'
        Value = Null
        Component = PartnerMedicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerMedicalName'
        Value = Null
        Component = PartnerMedicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 39
    Top = 65
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deOperDateSP
    Left = 96
    Top = 67
  end
  object PartnerMedicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartnerMedical
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
    Left = 176
    Top = 176
  end
end
