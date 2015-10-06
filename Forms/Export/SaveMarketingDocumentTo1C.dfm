inherited SaveMarketingDocumentTo1CForm: TSaveMarketingDocumentTo1CForm
  ActiveControl = deStart
  Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1087#1086' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1091' '#1074' 1'#1057
  ClientHeight = 116
  ClientWidth = 533
  AddOnFormData.RefreshAction = nil
  AddOnFormData.isSingle = False
  ExplicitWidth = 539
  ExplicitHeight = 141
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 156
    Top = 61
    Action = MultiAction
    ExplicitLeft = 156
    ExplicitTop = 61
  end
  inherited bbCancel: TcxButton
    Left = 300
    Top = 61
    Action = actClose
    ExplicitLeft = 300
    ExplicitTop = 61
  end
  object deStart: TcxDateEdit [2]
    Left = 131
    Top = 16
    Properties.ShowTime = False
    TabOrder = 2
    Width = 121
  end
  object deEnd: TcxDateEdit [3]
    Left = 371
    Top = 16
    Properties.ShowTime = False
    TabOrder = 3
    Width = 121
  end
  object cxLabel1: TcxLabel [4]
    Left = 38
    Top = 18
    Caption = #1053#1072#1095#1072#1083#1100#1085#1072#1103' '#1076#1072#1090#1072':'
  end
  object cxLabel2: TcxLabel [5]
    Left = 278
    Top = 18
    Caption = #1050#1086#1085#1077#1095#1085#1072#1103' '#1076#1072#1090#1072':'
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 91
    Top = 64
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    Left = 64
    Top = 64
  end
  inherited ActionList: TActionList
    Left = 119
    Top = 63
    inherited actRefresh: TdsdDataSetRefresh
      Category = 'macPeriodSave'
      StoredProc = spReport_AccountExternal
      StoredProcList = <
        item
          StoredProc = spReport_AccountExternal
        end>
      ShortCut = 0
    end
    object MultiAction: TMultiAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.DataType = ftString
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'FileName'
          ToParam.DataType = ftString
        end
        item
          FromParam.Value = Null
          ToParam.Value = Null
        end>
      ActionList = <
        item
          Action = actRefresh
        end
        item
          Action = ExternalSaveAction
        end>
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1076#1083#1103' 1C '#1091#1089#1087#1077#1096#1085#1086' '#1074#1099#1075#1088#1091#1078#1077#1085#1099
      Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100
    end
    object ExternalSaveAction: TExternalSaveAction
      Category = 'macPeriodSave'
      MoveParams = <>
      FieldDefs = <
        item
          Name = 'INVNUMBER'
          DataType = ftString
          Size = 20
        end
        item
          Name = 'OPERDATE'
          DataType = ftString
          Size = 10
        end
        item
          Name = 'CLIENTCODE'
          DataType = ftString
          Size = 9
        end
        item
          Name = 'CLIENTINN'
          DataType = ftString
          Size = 10
        end
        item
          Name = 'CLIENTOKPO'
          DataType = ftString
          Size = 10
        end
        item
          Name = 'CLIENTNAME'
          DataType = ftString
          Size = 50
        end
        item
          Name = 'SUMA'
          DataType = ftString
          Size = 10
        end
        item
          Name = 'PDV'
          DataType = ftString
          Size = 10
        end
        item
          Name = 'SUMAPDV'
          DataType = ftString
          Size = 10
        end
        item
          Name = 'OPERDATEC'
          DataType = ftString
          Size = 10
        end
        item
          Name = 'INVNUMBERC'
          DataType = ftString
          Size = 20
        end
        item
          Name = 'COMMENT'
          DataType = ftString
          Size = 100
        end>
      DataSet = AccountExternal
      OpenFileDialog = False
      FileName.Value = Null
      FileName.Component = FormParams
      FileName.ComponentItem = 'FileName'
      FileName.DataType = ftString
    end
    object actClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1054#1090#1084#1077#1085#1072
      Hint = #1054#1090#1084#1077#1085#1072
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'FileName'
        Value = Null
        DataType = ftString
      end>
    Left = 48
    Top = 48
  end
  object AccountExternal: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 256
    Top = 8
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 472
  end
  object spReport_AccountExternal: TdsdStoredProc
    StoredProcName = 'gpReport_AccountExternal'
    DataSet = AccountExternal
    DataSets = <
      item
        DataSet = AccountExternal
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 0d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 0d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inAccountId'
        Value = Null
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 16
    Top = 16
  end
end
