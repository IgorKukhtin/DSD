object IncomeCheckDialogForm: TIncomeCheckDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1091#1087#1086#1083#1085#1086#1084#1086#1095#1077#1085#1085#1099#1084' '#1083#1080#1094#1086#1084
  ClientHeight = 154
  ClientWidth = 307
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
    Top = 115
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 192
    Top = 115
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deCheckDate: TcxDateEdit
    Left = 160
    Top = 16
    EditValue = 42705d
    Properties.DateButtons = [btnClear, btnNow, btnToday]
    Properties.PostPopupValueOnTab = True
    TabOrder = 2
    Width = 97
  end
  object cxLabel6: TcxLabel
    Left = 21
    Top = 17
    Caption = #1044#1072#1090#1072' '#1087#1088#1086#1074#1077#1088#1082#1080' '#1091#1087'. '#1083#1080#1094#1086#1084':'
  end
  object cxLabel16: TcxLabel
    Left = 21
    Top = 51
    Caption = #1060#1048#1054' '#1091#1087#1086#1083#1085#1086#1084#1086#1095'. '#1083#1080#1094#1072
  end
  object edMemberIncomeCheck: TcxButtonEdit
    Left = 21
    Top = 74
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 236
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 279
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
    Left = 256
    Top = 87
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'CheckDate'
        Value = 41579d
        Component = deCheckDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberIncomeCheckId'
        Value = Null
        Component = MemberIncomeCheckGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberIncomeCheckName'
        Value = Null
        Component = MemberIncomeCheckGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 151
    Top = 113
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deCheckDate
    Left = 144
    Top = 51
  end
  object MemberIncomeCheckGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMemberIncomeCheck
    FormNameParam.Value = 'TMemberIncomeCheckForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMemberIncomeCheckForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = MemberIncomeCheckGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = MemberIncomeCheckGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 192
    Top = 73
  end
end
