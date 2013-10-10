inherited ContractEditForm: TContractEditForm
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1044#1086#1075#1086#1074#1086#1088#1072
  ClientHeight = 309
  ClientWidth = 531
  ExplicitWidth = 539
  ExplicitHeight = 336
  PixelsPerInch = 96
  TextHeight = 13
  object edInvNumber: TcxTextEdit
    Left = 40
    Top = 24
    TabOrder = 0
    Width = 273
  end
  object LbInvNumber: TcxLabel
    Left = 40
    Top = 7
    Caption = #1053#1086#1084#1077#1088' '#1076#1086#1075#1086#1074#1086#1088#1072
  end
  object cxButton1: TcxButton
    Left = 138
    Top = 264
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 304
    Top = 264
    Width = 75
    Height = 25
    Action = dsdFormClose1
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object cxLabel3: TcxLabel
    Left = 40
    Top = 90
    Caption = #1042#1080#1076#1099' '#1076#1086#1075#1086#1074#1086#1088#1086#1074
  end
  object cxLabel4: TcxLabel
    Left = 42
    Top = 135
    Caption = #1045#1076'. '#1080#1079#1084#1077#1088#1077#1085#1080#1103
  end
  object ceComment: TcxTextEdit
    Left = 40
    Top = 63
    TabOrder = 6
    Width = 273
  end
  object cxLabel5: TcxLabel
    Left = 45
    Top = 49
    Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
  end
  object edContractKind: TcxButtonEdit
    Left = 40
    Top = 108
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 8
    Width = 137
  end
  object edJuridical: TcxButtonEdit
    Left = 40
    Top = 158
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 9
    Width = 137
  end
  object edSigningDate: TcxDateEdit
    Left = 42
    Top = 213
    EditValue = 0d
    TabOrder = 10
    Width = 121
  end
  object cxLabel1: TcxLabel
    Left = 42
    Top = 190
    Caption = #1044#1072#1090#1072' '#1079#1072#1082#1083#1102#1095#1077#1085#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072
  end
  object cxLabel2: TcxLabel
    Left = 202
    Top = 190
    Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1076#1086#1075#1086#1074#1086#1088#1072
  end
  object edStartDate: TcxDateEdit
    Left = 202
    Top = 213
    EditValue = 0d
    TabOrder = 13
    Width = 121
  end
  object edEndDate: TcxDateEdit
    Left = 362
    Top = 213
    EditValue = 0d
    TabOrder = 14
    Width = 121
  end
  object cxLabel6: TcxLabel
    Left = 362
    Top = 190
    Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1076#1086#1075#1086#1074#1086#1088#1072
  end
  object ActionList: TActionList
    Left = 416
    Top = 80
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
    end
    object dsdFormClose1: TdsdFormClose
    end
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = #1054#1082
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Contract'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inInvNumber'
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inContractKindId'
        Component = edContractKind
      end
      item
        Name = 'inJuridicalId'
        Component = edJuridical
      end
      item
        Name = 'inSigningDate'
        Component = edSigningDate
        DataType = ftDateTime
      end
      item
        Name = 'inStartDate'
        Component = edStartDate
        DataType = ftDateTime
      end
      item
        Name = 'inEndDate'
        Component = edEndDate
        DataType = ftDateTime
      end>
    Left = 376
    Top = 8
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        ParamType = ptInputOutput
      end>
    Left = 304
    Top = 112
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Contract'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inInvNumber'
        Component = edInvNumber
        DataType = ftString
      end
      item
        Name = 'inComment'
        Component = ceComment
        DataType = ftString
      end
      item
        Name = 'inContractKindId'
        Component = edContractKind
      end
      item
        Name = 'inJuridicalId'
        Component = edJuridical
      end
      item
        Name = 'inSigningDate'
        Component = edSigningDate
        DataType = ftDateTime
      end
      item
        Name = 'inStartDate'
        Component = edStartDate
        DataType = ftDateTime
      end
      item
        Name = 'inEndDate'
        Component = edStartDate
        DataType = ftDateTime
      end>
    Left = 448
    Top = 8
  end
end
