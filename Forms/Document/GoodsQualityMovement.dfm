inherited GoodsQualityMovementForm: TGoodsQualityMovementForm
  ActiveControl = ceAmountDebet
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077'>'
  ClientHeight = 436
  ClientWidth = 605
  AddOnFormData.isSingle = False
  ExplicitWidth = 611
  ExplicitHeight = 468
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 168
    Top = 402
    Height = 26
    ExplicitLeft = 168
    ExplicitTop = 402
    ExplicitHeight = 26
  end
  inherited bbCancel: TcxButton
    Left = 312
    Top = 402
    Height = 26
    ExplicitLeft = 312
    ExplicitTop = 402
    ExplicitHeight = 26
  end
  object cxLabel1: TcxLabel [2]
    Left = 184
    Top = 5
    Caption = #1044#1072#1090#1072
  end
  object Код: TcxLabel [3]
    Left = 8
    Top = 5
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object cxLabel4: TcxLabel [4]
    Left = 9
    Top = 140
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object cxLabel5: TcxLabel [5]
    Left = 295
    Top = 51
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object ceUnit: TcxButtonEdit [6]
    Left = 8
    Top = 159
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 273
  end
  object ceInfoMoney: TcxButtonEdit [7]
    Left = 295
    Top = 69
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 304
  end
  object ceOperDate: TcxDateEdit [8]
    Left = 184
    Top = 24
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 2
    Width = 97
  end
  object ceAmountDebet: TcxCurrencyEdit [9]
    Left = 293
    Top = 24
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 4
    Width = 142
  end
  object cxLabel7: TcxLabel [10]
    Left = 293
    Top = 5
    Caption = #1044#1077#1073#1077#1090', '#1089#1091#1084#1084#1072' ('#1084#1099' '#1086#1082#1072#1079#1072#1083#1080')'
  end
  object ceJuridical: TcxButtonEdit [11]
    Left = 8
    Top = 114
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 273
  end
  object cxLabel6: TcxLabel [12]
    Left = 8
    Top = 95
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
  end
  object ceAmountKredit: TcxCurrencyEdit [13]
    Left = 447
    Top = 24
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 5
    Width = 152
  end
  object cxLabel3: TcxLabel [14]
    Left = 447
    Top = 5
    Caption = #1050#1088#1077#1076#1080#1090', '#1089#1091#1084#1084#1072' ('#1084#1099' '#1087#1086#1083#1091#1095#1080#1083#1080')'
  end
  object cxLabel9: TcxLabel [15]
    Left = 8
    Top = 49
    Caption = #1042#1077#1090#1077#1088#1080#1085#1072#1088#1085#1077' '#1089#1074#1110#1076#1086#1094#1090#1074#1086' '#1076#1072#1090#1072
  end
  object ceOperDateCertificate: TcxDateEdit [16]
    Left = 8
    Top = 68
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 16
    Width = 151
  end
  object edInvNumberPartner: TcxTextEdit [17]
    Left = 447
    Top = 159
    TabOrder = 17
    Width = 152
  end
  object cxLabel11: TcxLabel [18]
    Left = 447
    Top = 140
    Caption = #1053#1086#1084#1077#1088' '#1072#1082#1090#1072' ('#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072')'
  end
  object edInvNumber: TcxTextEdit [19]
    Left = 8
    Top = 24
    Properties.ReadOnly = True
    TabOrder = 19
    Text = '0'
    Width = 156
  end
  object cePartner: TcxButtonEdit [20]
    Left = 296
    Top = 114
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 20
    Width = 303
  end
  object cxLabel12: TcxLabel [21]
    Left = 296
    Top = 95
    Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
  end
  object ceComment: TcxMemo [22]
    Left = 8
    Top = 256
    Lines.Strings = (
      '')
    TabOrder = 22
    Height = 89
    Width = 185
  end
  object cxLabel2: TcxLabel [23]
    Left = 8
    Top = 233
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 379
    Top = 324
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 512
    Top = 316
  end
  inherited ActionList: TActionList
    Left = 423
    Top = 217
    inherited InsertUpdateGuides: TdsdInsertUpdateGuides [0]
    end
    inherited actRefresh: TdsdDataSetRefresh [1]
    end
    inherited FormClose: TdsdFormClose [2]
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = '0'
        ParamType = ptInput
      end
      item
        Name = 'inMovementId_Value'
        Value = '0'
        ParamType = ptInput
      end>
    Left = 488
    Top = 316
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_GoodsQuality'
    Params = <
      item
        Name = 'ioid'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'ininvnumber'
        Value = '0'
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inoperdate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inOperDatePartner'
        Value = 0d
        Component = ceOperDateCertificate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inInvNumberPartner'
        Value = ''
        Component = edInvNumberPartner
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inamountIn'
        Value = 0.000000000000000000
        Component = ceAmountDebet
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inamountOut'
        Value = 0.000000000000000000
        Component = ceAmountKredit
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'incomment'
        Value = ''
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inbusinessid'
        Value = ''
        ParamType = ptInput
      end
      item
        Name = 'incontractid'
        Value = ''
        ParamType = ptInput
      end
      item
        Name = 'ininfomoneyid'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'injuridicalid'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPartnerId'
        Value = ''
        Component = PartnerGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'injuridicalbasisid'
        Value = ''
        ParamType = ptInput
      end
      item
        Name = 'inpaidkindid'
        Value = ''
        ParamType = ptInput
      end
      item
        Name = 'inunitid'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 488
    Top = 224
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_GoodsQuality'
    Params = <
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'Id'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
      end
      item
        Name = 'InvNumber'
        Value = '0'
        Component = edInvNumber
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
      end
      item
        Name = 'OperDateCertificate'
        Value = 0d
        Component = ceOperDateCertificate
        DataType = ftDateTime
      end
      item
        Name = 'InvNumberPartner'
        Value = ''
        Component = edInvNumberPartner
        DataType = ftString
      end
      item
        Name = 'AmountIn'
        Value = 0.000000000000000000
        Component = ceAmountDebet
        DataType = ftFloat
      end
      item
        Name = 'AmountOut'
        Value = 0.000000000000000000
        Component = ceAmountKredit
        DataType = ftFloat
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
      end
      item
        Name = 'JuridicalBasisId'
        Value = ''
      end
      item
        Name = 'JuridicalBasisName'
        Value = ''
        DataType = ftString
      end
      item
        Name = 'BusinessId'
        Value = ''
      end
      item
        Name = 'BusinessName'
        Value = ''
        DataType = ftString
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'InfoMoneyName'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'UnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'Comment'
        Value = ''
        DataType = ftString
      end
      item
        Name = 'PartnerId'
        Value = ''
        Component = PartnerGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PartnerName'
        Value = ''
        Component = PartnerGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Value = '0'
        ParamType = ptUnknown
      end
      item
        Value = ''
        ParamType = ptUnknown
      end
      item
        Value = ''
        ParamType = ptUnknown
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
      end>
    Left = 544
    Top = 216
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 128
    Top = 145
  end
  object InfoMoneyGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoney
    FormNameParam.Value = 'TInfoMoney_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TInfoMoney_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 456
    Top = 49
  end
  object JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridical
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'PaidKindId'
        Value = ''
        ParamType = ptInput
      end
      item
        Name = 'PaidKindName'
        Value = ''
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'InfoMoneyName_all'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'PartnerId'
        Value = ''
        Component = PartnerGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'PartnerName'
        Value = ''
        Component = PartnerGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'MasterJuridicalId'
        Value = 0
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        DataType = ftString
      end>
    Left = 160
    Top = 97
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Name = 'Id'
    IdParam.Value = '0'
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    GuidesList = <
      item
        Guides = JuridicalGuides
      end
      item
      end
      item
      end
      item
        Guides = InfoMoneyGuides
      end>
    ActionItemList = <>
    Left = 264
    Top = 178
  end
  object PartnerGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePartner
    FormNameParam.Value = 'TPartner_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TPartner_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PartnerGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PartnerGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'MasterJuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 456
    Top = 97
  end
end
