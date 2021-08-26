object PayrollTypeDialogForm: TPayrollTypeDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1058#1080#1087#1099' '#1088#1072#1089#1095#1077#1090#1072' '#1079#1072#1088#1072#1073#1086#1090#1085#1086#1081' '#1087#1083#1072#1090#1099'>'
  ClientHeight = 126
  ClientWidth = 342
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
    Left = 50
    Top = 82
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 224
    Top = 82
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel3: TcxLabel
    Left = 8
    Top = 10
    Caption = #1058#1080#1087' '#1088#1072#1089#1095#1077#1090#1072' '#1079#1072#1088#1072#1073#1086#1090#1085#1086#1081' '#1087#1083#1072#1090#1099
  end
  object cePayrollType: TcxButtonEdit
    Left = 8
    Top = 33
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1090#1080#1087' '#1088#1072#1089#1095#1077#1090#1072' '#1101'.'#1087'.>'
    Properties.ReadOnly = True
    Properties.UseNullString = True
    TabOrder = 3
    Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1090#1080#1087' '#1088#1072#1089#1095#1077#1090#1072' '#1101'.'#1087'.>'
    Width = 314
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 279
    Top = 17
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPayrollType
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPayrollType
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 215
    Top = 9
  end
  object GuidesPayrollType: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePayrollType
    FormNameParam.Value = 'TPayrollTypeChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPayrollTypeChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPayrollType
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPayrollType
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 144
    Top = 11
  end
end
