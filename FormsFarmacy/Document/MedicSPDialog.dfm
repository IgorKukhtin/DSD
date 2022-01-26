object MedicSPDialogForm: TMedicSPDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1060#1048#1054' '#1074#1088#1072#1095#1072
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
  object cxLabel16: TcxLabel
    Left = 20
    Top = 15
    Caption = #1060#1048#1054' '#1074#1088#1072#1095#1072
  end
  object edMedicSP: TcxButtonEdit
    Left = 20
    Top = 38
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 301
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
        Name = 'MedicSPId'
        Value = ''
        Component = GuidesMedicSP
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MedicSPName'
        Value = ''
        Component = GuidesMedicSP
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MedicSPForm'
        Value = 'TMedicSP_ObjectForm'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPartnerMedicalId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPartnerMedicalName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterOperDate'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 230
    Top = 12
  end
  object GuidesMedicSP: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMedicSP
    FormNameParam.Value = 'TMedicSP_ObjectForm'
    FormNameParam.Component = FormParams
    FormNameParam.ComponentItem = 'MedicSPForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMedicSP_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMedicSP
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMedicSP
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPartnerMedicalId'
        Value = ''
        Component = FormParams
        ComponentItem = 'MasterPartnerMedicalId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPartnerMedicalName'
        Value = ''
        Component = FormParams
        ComponentItem = 'MasterPartnerMedicalName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterOperDate'
        Value = 42132d
        Component = FormParams
        ComponentItem = 'MasterOperDate'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitId'
        Value = ''
        Component = FormParams
        ComponentItem = 'MasterUnitId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitName'
        Value = ''
        Component = FormParams
        ComponentItem = 'MasterUnitName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 8
  end
end
