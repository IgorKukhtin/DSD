object SendVIP_VIPDialogForm: TSendVIP_VIPDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1086#1088' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074' '#1076#1083#1103' VIP '#1095#1077#1082#1086#1074
  ClientHeight = 184
  ClientWidth = 304
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 40
    Top = 147
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 174
    Top = 145
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object ceMember: TcxButtonEdit
    Left = 16
    Top = 27
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    Properties.UseNullString = True
    TabOrder = 2
    Width = 265
  end
  object edBayerName: TcxTextEdit
    Left = 16
    Top = 70
    TabOrder = 3
    Width = 265
  end
  object edBayerPhone: TcxTextEdit
    Left = 16
    Top = 114
    TabOrder = 4
    Width = 265
  end
  object cxLabel1: TcxLabel
    Left = 16
    Top = 4
    Caption = #1052#1077#1085#1077#1076#1078#1077#1088':'
  end
  object cxLabel2: TcxLabel
    Left = 16
    Top = 47
    Caption = #1060#1072#1084#1080#1083#1080#1103' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103':'
  end
  object cxLabel3: TcxLabel
    Left = 16
    Top = 94
    Caption = #1058#1077#1083#1077#1092#1086#1085' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103':'
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 262
    Top = 17
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
    Left = 255
    Top = 87
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ManagerId'
        Value = 'NULL'
        Component = MemberGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BayerName'
        Value = 'NULL'
        Component = edBayerName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BayerPhone'
        Value = ''
        Component = edBayerPhone
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 46
    Top = 81
  end
  object MemberGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMember
    FormNameParam.Value = 'TMemberForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMemberForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 184
    Top = 24
  end
end
