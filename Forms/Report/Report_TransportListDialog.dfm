object Report_TransportListDialogForm: TReport_TransportListDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1056#1077#1077#1089#1090#1088' '#1087#1091#1090#1077#1074#1099#1093' + '#1085#1072#1077#1084#1085#1099#1081' '#1090#1088#1072#1085#1089#1087#1086#1088#1090'>'
  ClientHeight = 169
  ClientWidth = 270
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
    Left = 15
    Top = 124
    Width = 75
    Height = 23
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 149
    Top = 124
    Width = 75
    Height = 23
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 140
    Top = 27
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
    Left = 140
    Top = 7
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
  end
  object cxLabel8: TcxLabel
    Left = 8
    Top = 56
    Caption = #1060#1080#1083#1080#1072#1083':'
  end
  object edBranch: TcxButtonEdit
    Left = 8
    Top = 77
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 232
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 56
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 120
    Top = 112
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
    Left = 168
    Top = 17
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
        Name = 'BranchId'
        Value = ''
        Component = GuidesBranch
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'BranchName'
        Value = ''
        Component = GuidesBranch
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'PersonalDriverId'
        Value = ''
        ParamType = ptInput
      end
      item
        Name = 'PersonalDriverName'
        Value = ''
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 208
    Top = 56
  end
  object GuidesBranch: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBranch
    FormNameParam.Value = 'TBranch_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TBranch_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBranch
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBranch
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 112
    Top = 55
  end
end
