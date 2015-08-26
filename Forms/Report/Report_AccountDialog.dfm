object Report_AccountDialogForm: TReport_AccountDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1089#1095#1077#1090#1091'>'
  ClientHeight = 309
  ClientWidth = 482
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
    Left = 111
    Top = 267
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 285
    Top = 267
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 128
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
    Left = 128
    Top = 7
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
  end
  object cxLabel8: TcxLabel
    Left = 250
    Top = 204
    Caption = #1060#1080#1083#1080#1072#1083':'
  end
  object edBranch: TcxButtonEdit
    Left = 250
    Top = 223
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 220
  end
  object cxLabel20: TcxLabel
    Left = 8
    Top = 155
    Caption = #1057#1095#1077#1090' '#1085#1072#1079#1074#1072#1085#1080#1077':'
  end
  object edAccount: TcxButtonEdit
    Left = 8
    Top = 175
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 220
  end
  object cxLabel5: TcxLabel
    Left = 8
    Top = 204
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103':'
  end
  object edInfoMoney: TcxButtonEdit
    Left = 8
    Top = 223
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 220
  end
  object cxLabel4: TcxLabel
    Left = 8
    Top = 58
    Caption = #1057#1095#1077#1090' '#1075#1088#1091#1087#1087#1072
  end
  object ceAccountGroup: TcxButtonEdit
    Left = 8
    Top = 77
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 220
  end
  object cxLabel3: TcxLabel
    Left = 250
    Top = 58
    Caption = #1054#1055#1080#1059' '#1075#1088#1091#1087#1087#1072
  end
  object ceProfitLossGroup: TcxButtonEdit
    Left = 250
    Top = 77
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 170
  end
  object cxLabel10: TcxLabel
    Left = 8
    Top = 105
    Caption = #1057#1095#1077#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077':'
  end
  object ceAccountDirection: TcxButtonEdit
    Left = 8
    Top = 125
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 220
  end
  object cxLabel12: TcxLabel
    Left = 250
    Top = 105
    Caption = #1054#1055#1080#1059' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
  end
  object ceProfitLossDirection: TcxButtonEdit
    Left = 250
    Top = 125
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 180
  end
  object cxLabel13: TcxLabel
    Left = 250
    Top = 155
    Caption = #1054#1055#1080#1059' '#1089#1090#1072#1090#1100#1103
  end
  object ceProfitLoss: TcxButtonEdit
    Left = 250
    Top = 175
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 21
    Width = 220
  end
  object cxLabel1: TcxLabel
    Left = 250
    Top = 7
    Caption = #1041#1080#1079#1085#1077#1089
  end
  object ceBusiness: TcxButtonEdit
    Left = 250
    Top = 27
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 23
    Width = 220
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 136
    Top = 16
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 224
    Top = 263
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
    Left = 400
    Top = 265
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
        Name = 'BusinessId'
        Value = Null
        Component = BusinessGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'BusinessName'
        Value = Null
        Component = BusinessGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'AccountGroupId'
        Value = ''
        Component = AccountGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'AccountGroupName'
        Value = ''
        Component = AccountGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ProfitLossGroupId'
        Value = ''
        Component = ProfitLossGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'ProfitLossGroupName'
        Value = ''
        Component = ProfitLossGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'AccountDirectionId'
        Value = Null
        Component = AccountDirectionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'AccountDirectionName'
        Value = Null
        Component = AccountDirectionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ProfitLossDirectionId'
        Value = Null
        Component = ProfitLossDirectionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'ProfitLossDirectionName'
        Value = Null
        Component = ProfitLossDirectionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'AccountId'
        Value = ''
        Component = GuidesAccount
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'AccountName'
        Value = ''
        Component = GuidesAccount
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'InfoMoneyId'
        Value = Null
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'InfoMoneyName'
        Value = Null
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ProfitLossId'
        Value = Null
        Component = ProfitLossGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'ProfitLossName'
        Value = Null
        Component = ProfitLossGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 40
    Top = 224
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
    Left = 304
    Top = 199
  end
  object GuidesAccount: TdsdGuides
    KeyField = 'Id'
    LookupControl = edAccount
    FormNameParam.Value = 'TAccount_ObjectDescForm'
    FormNameParam.DataType = ftString
    FormName = 'TAccount_ObjectDescForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesAccount
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesAccount
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 112
    Top = 165
  end
  object GuidesInfoMoney: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInfoMoney
    FormNameParam.Value = 'TInfoMoney_ObjectDescForm'
    FormNameParam.DataType = ftString
    FormName = 'TInfoMoney_ObjectDescForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'inDescCode'
        Value = 'zc_Object_Juridical'
        DataType = ftString
      end>
    Left = 126
    Top = 213
  end
  object AccountGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceAccountGroup
    FormNameParam.Value = 'TAccountGroup_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TAccountGroup_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = AccountGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = AccountGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'AccountDirectionId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'AccountDirectionName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'AccountId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'AccountName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 72
    Top = 53
  end
  object ProfitLossGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceProfitLossGroup
    FormNameParam.Value = 'TProfitLossGroup_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TProfitLossGroup_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ProfitLossGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ProfitLossGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ProfitLossDirectionId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'ProfitLossDirectionName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ProfitLossId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'ProfitLossName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 352
    Top = 61
  end
  object AccountDirectionGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceAccountDirection
    FormNameParam.Value = 'TAccountDirection_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TAccountDirection_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = AccountDirectionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = AccountDirectionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'AccountGroupId'
        Value = ''
        Component = AccountGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'AccountGroupName'
        Value = ''
        Component = AccountGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'AccountId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'AccountName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 128
    Top = 101
  end
  object ProfitLossDirectionGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceProfitLossDirection
    FormNameParam.Value = 'TProfitLossDirection_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TProfitLossDirection_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ProfitLossDirectionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ProfitLossDirectionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ProfitLossGroupId'
        Value = ''
        Component = ProfitLossGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'ProfitLossGroupName'
        Value = ''
        Component = ProfitLossGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ProfitLossId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'ProfitLossName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 376
    Top = 109
  end
  object ProfitLossGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceProfitLoss
    FormNameParam.Value = 'TProfitLoss_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TProfitLoss_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ProfitLossGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ProfitLossGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ProfitLossGroupId'
        Value = ''
        Component = ProfitLossGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'ProfitLossGroupName'
        Value = ''
        Component = ProfitLossGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ProfitLossDirectionId'
        Value = ''
        Component = ProfitLossDirectionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'ProfitLossDirectionName'
        Value = ''
        Component = ProfitLossDirectionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 404
    Top = 162
  end
  object BusinessGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBusiness
    FormNameParam.Value = 'TBusiness_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TBusiness_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BusinessGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BusinessGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 336
    Top = 15
  end
end
