object TaxJournalDialogForm: TTaxJournalDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' <'#1044#1072#1085#1085#1099#1077' '#1086' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080' '#1052#1077#1076#1086#1082'>'
  ClientHeight = 245
  ClientWidth = 418
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
    Left = 61
    Top = 212
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 207
    Top = 212
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object edDateRegistered: TcxDateEdit
    Left = 19
    Top = 99
    EditValue = 42216d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 101
  end
  object cxLabel6: TcxLabel
    Left = 19
    Top = 79
    Caption = #1044#1072#1090#1072' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080':'
  end
  object edIsElectron: TcxCheckBox
    Left = 144
    Top = 99
    Caption = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1072#1103' ('#1076#1072'/'#1085#1077#1090')'
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 166
  end
  object edInvNumberRegistered: TcxTextEdit
    Left = 19
    Top = 153
    TabOrder = 5
    Width = 278
  end
  object cxLabel1: TcxLabel
    Left = 19
    Top = 130
    Caption = #8470' '#1074' '#1044#1055#1040':'
  end
  object edInvNumber: TcxTextEdit
    Left = 8
    Top = 25
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 74
  end
  object cxLabel2: TcxLabel
    Left = 8
    Top = 5
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object edOperDate: TcxDateEdit
    Left = 116
    Top = 25
    EditValue = 42156d
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 9
    Width = 97
  end
  object cxLabel3: TcxLabel
    Left = 116
    Top = 5
    Caption = #1044#1072#1090#1072
  end
  object cxLabel9: TcxLabel
    Left = 235
    Top = 5
    Caption = #1044#1086#1075#1086#1074#1086#1088
  end
  object edContract: TcxButtonEdit
    Left = 235
    Top = 25
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 166
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 296
    Top = 141
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
    Left = 272
    Top = 84
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'DateRegistered'
        Value = 42156d
        Component = edDateRegistered
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'isElectron'
        Value = Null
        Component = edIsElectron
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'InvNumberRegistered'
        Value = Null
        Component = edInvNumberRegistered
        DataType = ftString
      end
      item
        Name = 'InvNumber'
        Value = Null
        Component = edInvNumber
        DataType = ftString
      end
      item
        Name = 'OperDate'
        Value = 42156d
        Component = edOperDate
        DataType = ftDateTime
      end
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'ContractId'
        Value = Null
        Component = ContractGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ContractName'
        Value = Null
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 32
    Top = 160
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Tax_Params'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'ininInvNumber'
        Value = 0.000000000000000000
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = ''
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inDateRegistered'
        Value = Null
        Component = edDateRegistered
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inIsElectron'
        Value = Null
        Component = edIsElectron
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inInvNumberRegistered'
        Value = Null
        Component = edInvNumberRegistered
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = ContractGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 184
    Top = 56
  end
  object ActionList: TActionList
    Left = 152
    Top = 152
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'Ok'
    end
    object dsdFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'dsdFormClose'
    end
  end
  object ContractGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContract
    FormNameParam.Value = 'TContractForm'
    FormNameParam.DataType = ftString
    FormName = 'TContractForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 296
    Top = 8
  end
end
