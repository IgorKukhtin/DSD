object OrderClientDialogForm: TOrderClientDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088
  ClientHeight = 327
  ClientWidth = 329
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  ShowHint = True
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 73
    Top = 281
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    OptionsImage.ImageIndex = 80
    OptionsImage.Images = dmMain.ImageList
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 201
    Top = 281
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    OptionsImage.ImageIndex = 52
    OptionsImage.Images = dmMain.ImageList
    TabOrder = 1
  end
  object edNPP: TcxCurrencyEdit
    Left = 34
    Top = 46
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.EditFormat = '0'
    TabOrder = 2
    Width = 144
  end
  object cxLabel19: TcxLabel
    Left = 34
    Top = 23
    Caption = #1054#1095#1077#1088#1077#1076#1085#1086#1089#1090#1100
  end
  object edDateBegin: TcxDateEdit
    Left = 210
    Top = 46
    EditValue = 42160d
    ParentShowHint = False
    Properties.SaveTime = False
    Properties.ShowTime = False
    ShowHint = True
    TabOrder = 4
    Width = 82
  end
  object cxLabel4: TcxLabel
    Left = 210
    Top = 23
    Hint = #1055#1083#1072#1085#1080#1088#1091#1077#1084#1072#1103' '#1076#1072#1090#1072' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1103' '#1089#1073#1086#1088#1082#1080
    Caption = #1044#1072#1090#1072' '#1087#1083#1072#1085
    ParentShowHint = False
    ShowHint = True
  end
  object edInvNumber: TcxTextEdit
    Left = 34
    Top = 101
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 144
  end
  object cxLabel5: TcxLabel
    Left = 34
    Top = 82
    Caption = #8470' '#1076#1086#1082'. '#1079#1072#1082#1072#1079#1072
  end
  object cxLabel2: TcxLabel
    Left = 208
    Top = 82
    Caption = #1044#1072#1090#1072' '#1079#1072#1082#1072#1079#1072
  end
  object edOperDate: TcxDateEdit
    Left = 208
    Top = 101
    EditValue = 42160d
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 9
    Width = 84
  end
  object cxLabel3: TcxLabel
    Left = 34
    Top = 128
    Hint = #1054#1090' '#1082#1086#1075#1086
    Caption = 'Kunden'
    ParentShowHint = False
    ShowHint = True
  end
  object cxLabel1: TcxLabel
    Left = 144
    Top = 175
    Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
  end
  object edStateText: TcxTextEdit
    Left = 144
    Top = 194
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 148
  end
  object edCIN: TcxTextEdit
    Left = 34
    Top = 238
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 98
  end
  object cxLabel13: TcxLabel
    Left = 34
    Top = 219
    Caption = 'CIN Nr.'
  end
  object cxLabel6: TcxLabel
    Left = 144
    Top = 219
    Caption = #1052#1086#1076#1077#1083#1100
  end
  object edModelName: TcxTextEdit
    Left = 144
    Top = 238
    Properties.ReadOnly = True
    TabOrder = 16
    Width = 148
  end
  object edFrom: TcxTextEdit
    Left = 34
    Top = 148
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 258
  end
  object edNPP_2_text: TcxLabel
    Left = 34
    Top = 175
    Caption = #8470' '#1087'/'#1087' '#1055#1083#1072#1085
  end
  object edNPP_2: TcxTextEdit
    Left = 34
    Top = 194
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 98
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 164
    Top = 39
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
    Left = 29
    Top = 301
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'NPP'
        Value = 'NULL'
        Component = edNPP
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateBegin'
        Value = Null
        Component = edDateBegin
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = Null
        Component = edInvNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName'
        Value = Null
        Component = edFrom
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StateText'
        Value = Null
        Component = edStateText
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CIN'
        Value = Null
        Component = edCIN
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ModelName'
        Value = Null
        Component = edModelName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'NPP_2'
        Value = Null
        Component = edNPP_2
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 95
    Top = 15
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 8
    Top = 123
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_OrderClient_NPP'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioNPP'
        Value = Null
        Component = edNPP
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioOperDate'
        Value = Null
        Component = edDateBegin
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 283
    Top = 12
  end
end
