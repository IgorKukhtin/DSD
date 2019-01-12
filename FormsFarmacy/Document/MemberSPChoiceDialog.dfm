object MemberSPChoiceDialogForm: TMemberSPChoiceDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1086#1088' '#1087#1072#1094#1080#1077#1085#1090#1072
  ClientHeight = 124
  ClientWidth = 351
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
    Left = 33
    Top = 79
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 192
    Top = 79
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel6: TcxLabel
    Left = 8
    Top = 30
    Caption = #1060#1048#1054' '#1087#1072#1094#1080#1077#1085#1090#1072':'
  end
  object edMemberSP: TcxButtonEdit
    Left = 96
    Top = 29
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 237
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 255
    Top = 54
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
    Left = 248
    Top = 20
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inMemberSPId'
        Value = 41579d
        Component = GuidesMemberSP
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerMedicalId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerMedicalName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 39
    Top = 54
  end
  object GuidesMemberSP: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMemberSP
    FormNameParam.Value = 'TMemberSPForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMemberSPForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMemberSP
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMemberSP
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPartnerMedicalId'
        Value = ''
        Component = FormParams
        ComponentItem = 'inPartnerMedicalId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPartnerMedicalName'
        Value = ''
        Component = FormParams
        ComponentItem = 'inPartnerMedicalName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 176
    Top = 16
  end
end
