object Movement_Inventory_scaleDialogForm: TMovement_Inventory_scaleDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#8470' '#1086#1093#1072#1085#1085#1080#1082#1072'>'
  ClientHeight = 208
  ClientWidth = 298
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
    Left = 41
    Top = 148
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 182
    Top = 148
    Width = 75
    Height = 25
    Action = dsdFormClose
    ModalResult = 2
    TabOrder = 1
  end
  object edIsSecurity: TcxCheckBox
    Left = 25
    Top = 100
    Caption = #1054#1093#1088#1072#1085#1072' ('#1076#1072'/'#1085#1077#1090')'
    Properties.ReadOnly = True
    TabOrder = 2
    Width = 109
  end
  object edNumSecurity: TcxTextEdit
    Left = 140
    Top = 100
    TabOrder = 3
    Width = 117
  end
  object cxLabel1: TcxLabel
    Left = 140
    Top = 77
    Caption = #8470' '#1086#1093#1088#1072#1085#1085#1080#1082#1072
  end
  object edInvNumber: TcxTextEdit
    Left = 140
    Top = 29
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 117
  end
  object cxLabel2: TcxLabel
    Left = 140
    Top = 6
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object edOperDate: TcxDateEdit
    Left = 19
    Top = 29
    EditValue = 42156d
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 7
    Width = 97
  end
  object cxLabel3: TcxLabel
    Left = 19
    Top = 6
    Caption = #1044#1072#1090#1072
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 80
    Top = 157
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
    Left = 232
    Top = 84
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'isSecurity'
        Value = Null
        Component = edIsSecurity
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = Null
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 42156d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'NumSecurity'
        Value = Null
        Component = edNumSecurity
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 32
    Top = 160
  end
  object spUpdate_NumSecurity: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_WeighingProduction_NumSecurity'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNumSecurity'
        Value = Null
        Component = edNumSecurity
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsSecurity'
        Value = Null
        Component = edIsSecurity
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 232
    Top = 16
  end
  object ActionList: TActionList
    Left = 152
    Top = 152
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_NumSecurity
      StoredProcList = <
        item
          StoredProc = spUpdate_NumSecurity
        end>
      Caption = 'Ok'
    end
    object dsdFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1054#1090#1084#1077#1085#1072
    end
  end
end
