inherited Report_GoodsPartionHistoryForm: TReport_GoodsPartionHistoryForm
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1076#1074#1080#1078#1077#1085#1080#1102' '#1087#1072#1088#1090#1080#1080' '#1090#1086#1074#1072#1088#1072
  ClientHeight = 359
  ClientWidth = 763
  AddOnFormData.RefreshAction = actRefreshStart
  ExplicitWidth = 779
  ExplicitHeight = 397
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 75
    Width = 763
    Height = 284
    TabOrder = 3
    ExplicitTop = 75
    ExplicitWidth = 763
    ExplicitHeight = 284
    ClientRectBottom = 284
    ClientRectRight = 763
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 763
      ExplicitHeight = 284
      inherited cxGrid: TcxGrid
        Width = 763
        Height = 284
        ExplicitWidth = 763
        ExplicitHeight = 284
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colMovementId: TcxGridDBColumn
            Caption = #1048#1044' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'MovementId'
            Visible = False
            HeaderAlignmentHorz = taCenter
            VisibleForCustomization = False
          end
          object colOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            Width = 76
          end
          object colInvNumber: TcxGridDBColumn
            Caption = #8470
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            Width = 55
          end
          object colMovementDescId: TcxGridDBColumn
            DataBinding.FieldName = 'MovementDescId'
            Visible = False
            HeaderAlignmentHorz = taCenter
            VisibleForCustomization = False
          end
          object colMovementDescName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'MovementDescName'
            HeaderAlignmentHorz = taCenter
            Width = 70
          end
          object colFromId: TcxGridDBColumn
            DataBinding.FieldName = 'FromId'
            Visible = False
            HeaderAlignmentHorz = taCenter
          end
          object colFromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            Width = 104
          end
          object colToId: TcxGridDBColumn
            DataBinding.FieldName = 'ToId'
            Visible = False
            HeaderAlignmentHorz = taCenter
          end
          object colToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentHorz = taCenter
            Width = 104
          end
          object colPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##'
            HeaderAlignmentHorz = taCenter
            Width = 52
          end
          object colSumma: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1077
            DataBinding.FieldName = 'Summa'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
          end
          object colAmountIn: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'AmountIn'
            HeaderAlignmentHorz = taCenter
            Width = 52
          end
          object colAmountOut: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076
            DataBinding.FieldName = 'AmountOut'
            HeaderAlignmentHorz = taCenter
            Width = 55
          end
          object colAmountInvent: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1091#1095#1077#1090
            DataBinding.FieldName = 'AmountInvent'
            HeaderAlignmentHorz = taCenter
            Width = 54
          end
          object colSaldo: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Saldo'
            Width = 44
          end
          object colMCSValue: TcxGridDBColumn
            Caption = #1053#1058#1047
            DataBinding.FieldName = 'MCSValue'
            HeaderAlignmentHorz = taCenter
            Width = 54
          end
          object colCheckMember: TcxGridDBColumn
            Caption = #1052#1077#1085#1077#1076#1078#1077#1088
            DataBinding.FieldName = 'CheckMember'
            Width = 80
          end
          object colBayer: TcxGridDBColumn
            Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100' (VIP)'
            DataBinding.FieldName = 'Bayer'
            Width = 95
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 763
    Height = 49
    ExplicitWidth = 763
    ExplicitHeight = 49
    object cxLabel4: TcxLabel
      Left = 16
      Top = 29
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object edUnit: TcxButtonEdit
      Left = 101
      Top = 27
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 184
    end
    object cxLabel3: TcxLabel
      Left = 291
      Top = 29
      Caption = #1058#1086#1074#1072#1088
    end
    object edGoods: TcxButtonEdit
      Left = 329
      Top = 27
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 184
    end
    object cxLabel5: TcxLabel
      Left = 522
      Top = 29
      Caption = #1055#1072#1088#1090#1080#1103
    end
    object edParty: TcxButtonEdit
      Left = 569
      Top = 27
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 184
    end
  end
  inherited ActionList: TActionList
    object actGet_UserUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end>
      Caption = 'actGet_UserUnit'
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actOpenDocument: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      FormNameParam.Name = 'FormClass'
      FormNameParam.Value = ''
      FormNameParam.Component = FormParams
      FormNameParam.ComponentItem = 'FormClass'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptInput
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          ParamType = ptInput
        end>
      isShowModal = False
    end
    object actGet_MovementFormClass: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_MovementFormClass
      StoredProcList = <
        item
          StoredProc = spGet_MovementFormClass
        end>
      Caption = 'actGet_MovementFormClass'
    end
    object mactOpenDocument: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_MovementFormClass
        end
        item
          Action = actOpenDocument
        end>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 1
    end
  end
  inherited MasterDS: TDataSource
    Top = 136
  end
  inherited MasterCDS: TClientDataSet
    Top = 136
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_GoodsPartionHistory'
    Params = <
      item
        Name = 'inPartyId'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartyId'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitId'
        ParamType = ptInput
      end
      item
        Name = 'inStartDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41395d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end>
    Top = 136
  end
  inherited BarManager: TdxBarManager
    Top = 136
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = mactOpenDocument
      end
      item
      end>
  end
  inherited PopupMenu: TPopupMenu
    object N2: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Action = actOpenDocument
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Top = 168
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Top = 176
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 232
    Top = 24
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsLiteForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsLiteForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 424
    Top = 24
  end
  object GuidesParty: TdsdGuides
    KeyField = 'Id'
    LookupControl = edParty
    FormNameParam.Value = 'TPartionGoodsChoiceForm'
    FormNameParam.DataType = ftString
    FormName = 'TPartionGoodsChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesParty
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesParty
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
      end
      item
        Name = 'inGoodsId'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
      end>
    Left = 632
    Top = 24
  end
  object spGet_UserUnit: TdsdStoredProc
    StoredProcName = 'gpGet_UserUnit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'UnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    PackSize = 1
    Left = 432
    Top = 96
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'FormClass'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'GoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'PartyId'
        Value = Null
        Component = GuidesParty
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 232
    Top = 240
  end
  object spGet_MovementFormClass: TdsdStoredProc
    StoredProcName = 'gpGet_MovementFormClass'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
      end
      item
        Name = 'outFormClass'
        Value = ''
        Component = FormParams
        ComponentItem = 'FormClass'
        DataType = ftString
      end>
    PackSize = 1
    Left = 272
    Top = 160
  end
  object rgUnit: TRefreshDispatcher
    IdParam.Value = Null
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = GuidesUnit
      end>
    Left = 232
    Top = 104
  end
  object rdGoods: TRefreshDispatcher
    IdParam.Value = Null
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = GuidesGoods
      end>
    Left = 424
    Top = 136
  end
  object rdParty: TRefreshDispatcher
    IdParam.Value = Null
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = GuidesParty
      end>
    Left = 624
    Top = 112
  end
end
