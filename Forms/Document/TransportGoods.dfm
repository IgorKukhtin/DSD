inherited TransportGoodsForm: TTransportGoodsForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1058#1086#1074#1072#1088#1086'-'#1090#1088#1072#1085#1089#1087#1086#1088#1090#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>'
  ClientHeight = 358
  ClientWidth = 547
  AddOnFormData.isSingle = False
  ExplicitWidth = 553
  ExplicitHeight = 383
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 154
    Top = 317
    Height = 26
    ExplicitLeft = 154
    ExplicitTop = 317
    ExplicitHeight = 26
  end
  inherited bbCancel: TcxButton
    Left = 295
    Top = 317
    Height = 26
    ExplicitLeft = 295
    ExplicitTop = 317
    ExplicitHeight = 26
  end
  object cxLabel1: TcxLabel [2]
    Left = 88
    Top = 7
    Caption = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object Код: TcxLabel [3]
    Left = 8
    Top = 7
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object edOperDate: TcxDateEdit [4]
    Left = 88
    Top = 27
    EditValue = 42092d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 2
    Width = 88
  end
  object edInvNumber_Sale: TcxButtonEdit [5]
    Left = 270
    Top = 27
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 130
  end
  object cxLabel6: TcxLabel [6]
    Left = 270
    Top = 7
    Caption = #8470' '#1076#1086#1082'. ('#1089#1082#1083#1072#1076')'
  end
  object edInvNumber: TcxTextEdit [7]
    Left = 8
    Top = 27
    Properties.ReadOnly = True
    TabOrder = 7
    Text = '0'
    Width = 75
  end
  object edOperDate_Sale: TcxDateEdit [8]
    Left = 407
    Top = 27
    EditValue = 42092d
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 8
    Width = 130
  end
  object edRoute: TcxButtonEdit [9]
    Left = 8
    Top = 177
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 247
  end
  object cxLabel67: TcxLabel [10]
    Left = 8
    Top = 157
    Caption = #1052#1072#1088#1096#1088#1091#1090
  end
  object cxLabel2: TcxLabel [11]
    Left = 407
    Top = 7
    Caption = #1044#1072#1090#1072' ('#1089#1082#1083#1072#1076')'
  end
  object edFrom: TcxButtonEdit [12]
    Left = 8
    Top = 77
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 247
  end
  object cxLabel3: TcxLabel [13]
    Left = 8
    Top = 57
    Caption = #1054#1090' '#1082#1086#1075#1086
  end
  object cxLabel9: TcxLabel [14]
    Left = 135
    Top = 107
    Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100
  end
  object edCar: TcxButtonEdit [15]
    Left = 135
    Top = 127
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 120
  end
  object cxLabel5: TcxLabel [16]
    Left = 270
    Top = 157
    Caption = #1060#1048#1054' ('#1042#1086#1076#1080#1090#1077#1083#1100')'
  end
  object edPersonalDriver: TcxButtonEdit [17]
    Left = 270
    Top = 177
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = False
    TabOrder = 17
    Width = 267
  end
  object cxLabel7: TcxLabel [18]
    Left = 407
    Top = 107
    Caption = #1055#1088#1080#1094#1077#1087
  end
  object edCarTrailer: TcxButtonEdit [19]
    Left = 407
    Top = 125
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 130
  end
  object cxLabel4: TcxLabel [20]
    Left = 8
    Top = 107
    Caption = #1052#1072#1088#1082#1072' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
  end
  object edCarModel: TcxButtonEdit [21]
    Left = 8
    Top = 125
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 21
    Width = 120
  end
  object cxLabel8: TcxLabel [22]
    Left = 270
    Top = 107
    Caption = #1052#1072#1088#1082#1072' '#1087#1088#1080#1094#1077#1087#1072
  end
  object edCarTrailerModel: TcxButtonEdit [23]
    Left = 270
    Top = 127
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 23
    Width = 130
  end
  object cxLabel10: TcxLabel [24]
    Left = 270
    Top = 57
    Caption = #1050#1086#1084#1091
  end
  object edTo: TcxButtonEdit [25]
    Left = 270
    Top = 77
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 25
    Width = 267
  end
  object cxLabel14: TcxLabel [26]
    Left = 8
    Top = 207
    Caption = #1054#1090#1088#1080#1084#1072#1074' '#1074#1086#1076#1110#1081'/'#1077#1082#1089#1087#1077#1076#1080#1090#1086#1088
  end
  object edMember1: TcxButtonEdit [27]
    Left = 8
    Top = 230
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 27
    Width = 247
  end
  object cxLabel11: TcxLabel [28]
    Left = 270
    Top = 207
    Caption = #1041#1091#1093#1075#1072#1083#1090#1077#1088' ('#1074#1110#1076#1087#1086#1074#1110#1076#1072#1083#1100#1085#1072' '#1086#1089#1086#1073#1072' '#1074#1072#1085#1090#1072#1078#1086#1074#1110#1076#1087#1088#1072#1074'.)'
  end
  object edMember2: TcxButtonEdit [29]
    Left = 270
    Top = 227
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 29
    Width = 267
  end
  object edInvNumberMark: TcxTextEdit [30]
    Left = 183
    Top = 27
    TabOrder = 30
    Width = 72
  end
  object cxLabel12: TcxLabel [31]
    Left = 183
    Top = 7
    Caption = #8470' '#1087#1083#1086#1084#1073#1099
  end
  object cxLabel13: TcxLabel [32]
    Left = 8
    Top = 257
    Caption = #1042#1110#1076#1087#1091#1089#1082' '#1076#1086#1079#1074#1086#1083#1080#1074
  end
  object edMember3: TcxButtonEdit [33]
    Left = 8
    Top = 277
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 33
    Width = 247
  end
  object edMember4: TcxButtonEdit [34]
    Left = 270
    Top = 277
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 34
    Width = 267
  end
  object cxLabel15: TcxLabel [35]
    Left = 270
    Top = 257
    Caption = #1047#1076#1072#1074' ('#1074#1110#1076#1087#1086#1074#1110#1076#1072#1083#1100#1085#1072' '#1086#1089#1086#1073#1072' '#1074#1072#1085#1090#1072#1078#1086#1074#1110#1076#1087#1088#1072#1074#1085#1080#1082#1072') '
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 67
    Top = 298
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 104
    Top = 312
  end
  inherited ActionList: TActionList
    Left = 239
    Top = 316
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
        Name = 'MovementId_Sale'
        Value = '0'
        ParamType = ptInput
      end
      item
        Name = 'OperDate'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
      end>
    Left = 20
    Top = 313
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_TransportGoods'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inInvNumber'
        Value = '0'
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inMovementId_Sale'
        Value = ''
        Component = GuideSaleJournalChoice
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inInvNumberMark'
        Value = 0.000000000000000000
        Component = edInvNumberMark
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inCarId'
        Value = ''
        Component = GuideCar
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inCarTrailerId'
        Value = ''
        Component = GuideCarTrailer
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPersonalDriverId'
        Value = ''
        Component = GuidePersonalDriver
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPersonalDriverName'
        Value = ''
        Component = edPersonalDriver
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inRouteId'
        Value = ''
        Component = GuideRoute
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inMemberId1'
        Value = '0'
        Component = GuideMember1
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inMemberName1'
        Value = Null
        Component = edMember1
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inMemberId2'
        Value = Null
        Component = GuideMember2
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inMemberName2'
        Value = Null
        Component = edMember2
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inMemberId3'
        Value = Null
        Component = GuideMember3
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inMemberName3'
        Value = Null
        Component = edMember3
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inMemberId4'
        Value = Null
        Component = GuideMember4
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inMemberName4'
        Value = Null
        Component = edMember4
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inMemberId5'
        Value = 0d
        Component = GuideMember1
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inMemberName5'
        Value = ''
        Component = edMember1
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inMemberId6'
        Value = ''
        Component = GuideMember1
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inMemberName6'
        Value = Null
        Component = edMember1
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inMemberId7'
        Value = 0
        ParamType = ptInput
      end
      item
        Name = 'inMemberName7'
        Value = ''
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 384
    Top = 307
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_TransportGoods'
    Params = <
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inMovementId_Sale'
        Value = ''
        Component = FormParams
        ComponentItem = 'MovementId_Sale'
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'OperDate'
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
        DataType = ftString
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
      end
      item
        Name = 'InvNumberMark'
        Value = 0.000000000000000000
        Component = edInvNumberMark
        DataType = ftString
      end
      item
        Name = 'MovementId_Sale'
        Value = 0d
        Component = GuideSaleJournalChoice
        ComponentItem = 'Key'
      end
      item
        Name = 'InvNumber_Sale'
        Value = ''
        Component = GuideSaleJournalChoice
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'OperDate_Sale'
        Value = ''
        Component = edOperDate_Sale
        DataType = ftDateTime
      end
      item
        Name = 'FromName'
        Value = 0.000000000000000000
        Component = edFrom
        DataType = ftString
      end
      item
        Name = 'ToId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
      end
      item
        Name = 'ToName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'RouteId'
        Value = ''
        Component = GuideRoute
        ComponentItem = 'Key'
      end
      item
        Name = 'RouteName'
        Value = ''
        Component = GuideRoute
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'CarId'
        Value = ''
        Component = GuideCar
        ComponentItem = 'Key'
      end
      item
        Name = 'CarName'
        Value = ''
        Component = GuideCar
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'CarModelId'
        Value = ''
        Component = GuideCarModel
        ComponentItem = 'Key'
      end
      item
        Name = 'CarModelName'
        Value = ''
        Component = GuideCarModel
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'CarTrailerId'
        Value = ''
        Component = GuideCarTrailer
        ComponentItem = 'Key'
      end
      item
        Name = 'CarTrailerName'
        Value = ''
        Component = GuideCarTrailer
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'CarTrailerModelId'
        Value = ''
        Component = GuideCarTrailerModel
        ComponentItem = 'Key'
      end
      item
        Name = 'CarTrailerModelName'
        Value = ''
        Component = GuideCarTrailerModel
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'PersonalDriverId'
        Value = ''
        Component = GuidePersonalDriver
        ComponentItem = 'Key'
      end
      item
        Name = 'PersonalDriverName'
        Value = ''
        Component = GuidePersonalDriver
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'MemberId1'
        Value = '0'
        Component = GuideMember1
        ComponentItem = 'Key'
      end
      item
        Name = 'MemberName1'
        Value = Null
        Component = GuideMember1
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'MemberId2'
        Value = Null
        Component = GuideMember2
        ComponentItem = 'Key'
      end
      item
        Name = 'MemberName2'
        Value = Null
        Component = GuideMember2
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'MemberId3'
        Value = Null
        Component = GuideMember3
        ComponentItem = 'Key'
      end
      item
        Name = 'MemberName3'
        Value = Null
        Component = GuideMember4
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'MemberId4'
        Value = Null
        Component = GuideMember4
        ComponentItem = 'Key'
      end
      item
        Name = 'MemberName4'
        Value = Null
        Component = GuideMember4
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 312
    Top = 315
  end
  object GuideSaleJournalChoice: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInvNumber_Sale
    FormNameParam.Value = 'TSaleJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormName = 'TSaleJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuideSaleJournalChoice
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuideSaleJournalChoice
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'OperDate'
        Value = Null
        Component = edOperDate_Sale
        DataType = ftDateTime
      end
      item
        Name = 'FromName'
        Value = Null
        Component = edFrom
        DataType = ftString
      end
      item
        Name = 'ToId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
      end
      item
        Name = 'ToName'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'inStartDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
      end
      item
        Name = 'PartnerId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
      end
      item
        Name = 'PartnerName'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 344
    Top = 23
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Name = 'Id'
    IdParam.Value = '0'
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    GuidesList = <
      item
        Guides = GuideSaleJournalChoice
      end
      item
        Guides = GuideCar
      end
      item
        Guides = GuidePersonalDriver
      end
      item
        Guides = GuideMember1
      end>
    ActionItemList = <>
    Left = 464
    Top = 307
  end
  object GuideRoute: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRoute
    FormNameParam.Value = 'TRouteForm'
    FormNameParam.DataType = ftString
    FormName = 'TRouteForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuideRoute
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuideRoute
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 132
    Top = 154
  end
  object GuideCar: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCar
    FormNameParam.Value = 'TCarForm'
    FormNameParam.DataType = ftString
    FormName = 'TCarForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuideCar
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuideCar
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'CarModelName'
        Value = Null
        Component = GuideCarModel
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 200
    Top = 106
  end
  object GuidePersonalDriver: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalDriver
    FormNameParam.Value = 'TMemberPlace_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TMemberPlace_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidePersonalDriver
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidePersonalDriver
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 434
    Top = 147
  end
  object GuideCarTrailer: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCarTrailer
    FormNameParam.Value = 'TCarForm'
    FormNameParam.DataType = ftString
    FormName = 'TCarForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuideCarTrailer
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuideCarTrailer
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'CarModelName'
        Value = Null
        Component = GuideCarTrailerModel
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 466
    Top = 99
  end
  object GuideMember1: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMember1
    FormNameParam.Value = 'TMemberPlace_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TMemberPlace_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuideMember1
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuideMember1
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 176
    Top = 203
  end
  object GuideMember2: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMember2
    FormNameParam.Value = 'TMemberPlace_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TMemberPlace_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuideMember2
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuideMember2
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 430
    Top = 211
  end
  object GuideCarModel: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCarModel
    FormNameParam.Value = 'TCarForm'
    FormNameParam.DataType = ftString
    FormName = 'TCarForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuideCar
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuideCar
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'CarModelName'
        Value = Null
        Component = GuideCarModel
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 72
    Top = 98
  end
  object GuideCarTrailerModel: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCarTrailerModel
    FormNameParam.Value = 'TCarForm'
    FormNameParam.DataType = ftString
    FormName = 'TCarForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuideCarTrailer
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuideCarTrailer
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'CarModelName'
        Value = Null
        Component = GuideCarTrailerModel
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 344
    Top = 98
  end
  object GuideMember3: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMember3
    FormNameParam.Value = 'TMemberPlace_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TMemberPlace_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuideMember3
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuideMember3
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 168
    Top = 254
  end
  object GuideMember4: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMember4
    FormNameParam.Value = 'TMemberPlace_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TMemberPlace_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuideMember4
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuideMember4
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 422
    Top = 253
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TForm_NULL'
    FormNameParam.DataType = ftString
    FormName = 'TForm_NULL'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'CarModelName'
        Value = ''
        Component = GuideCarModel
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 400
    Top = 74
  end
end
