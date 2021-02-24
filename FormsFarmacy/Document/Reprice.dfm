inherited RepriceForm: TRepriceForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1077#1088#1077#1086#1094#1077#1085#1082#1072'>'
  ClientWidth = 1040
  ExplicitWidth = 1056
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 76
    Width = 1040
    Height = 340
    ExplicitTop = 76
    ExplicitWidth = 1040
    ExplicitHeight = 340
    ClientRectBottom = 340
    ClientRectRight = 1040
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1040
      ExplicitHeight = 316
      inherited cxGrid: TcxGrid
        Width = 1040
        Height = 316
        ExplicitWidth = 1040
        ExplicitHeight = 316
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
            end
            item
              Format = #1058#1086#1074#1072#1088#1086#1074': ,0'
              Kind = skCount
              FieldName = 'GoodsName'
              Column = GoodsName
            end
            item
              Format = ',0.00'
              Kind = skSum
              FieldName = 'SummReprice'
              Column = SummReprice
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colIsErased: TcxGridDBColumn
            DataBinding.FieldName = ''
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 46
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 181
          end
          object NDS: TcxGridDBColumn
            Caption = #1053#1044#1057' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'NDS'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.## %'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 52
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object PriceOld: TcxGridDBColumn
            Caption = #1057#1090#1072#1088#1072#1103' '#1094#1077#1085#1072
            DataBinding.FieldName = 'PriceOld'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 49
          end
          object PriceNew: TcxGridDBColumn
            Caption = #1053#1086#1074#1072#1103' '#1094#1077#1085#1072
            DataBinding.FieldName = 'PriceNew'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 47
          end
          object PriceDiff: TcxGridDBColumn
            Caption = '% '#1080#1079#1084#1077#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'PriceDiff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '+0.0%;-0.0%; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object SummReprice: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'SummReprice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object ExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'ExpirationDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 63
          end
          object MinExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1086#1089#1090#1072#1090#1082#1072
            DataBinding.FieldName = 'MinExpirationDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 64
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 101
          end
          object Juridical_Percent: TcxGridDBColumn
            Caption = '% '#1050#1086#1088#1088'. '#1085#1072#1094#1077#1085#1082#1080' ('#1087#1086#1089#1090'.)'
            DataBinding.FieldName = 'Juridical_Percent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1080' '#1085#1072#1094#1077#1085#1082#1080' ('#1087#1086#1089#1090#1072#1074#1097#1080#1082')'
            Width = 71
          end
          object ContractName: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088
            DataBinding.FieldName = 'ContractName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 49
          end
          object Contract_Percent: TcxGridDBColumn
            Caption = '% '#1050#1086#1088#1088'. '#1085#1072#1094#1077#1085#1082#1080' ('#1076#1086#1075#1086#1074#1086#1088')'
            DataBinding.FieldName = 'Contract_Percent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1080' '#1085#1072#1094#1077#1085#1082#1080' ('#1076#1086#1075#1086#1074#1086#1088')'
            Width = 71
          end
          object Juridical_GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072' '#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'Juridical_GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 113
          end
          object MakerName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'MakerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 107
          end
          object MarginPercent: TcxGridDBColumn
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1090#1086#1095#1082#1077
            DataBinding.FieldName = 'MarginPercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 71
          end
          object Juridical_Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'Juridical_Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 79
          end
          object IsTop_Goods: TcxGridDBColumn
            Caption = #1058#1086#1087' '#1089#1077#1090#1080
            DataBinding.FieldName = 'IsTop_Goods'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 44
          end
          object isResolution_224: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224'
            DataBinding.FieldName = 'isResolution_224'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 86
          end
          object isPromoBonus: TcxGridDBColumn
            Caption = #1055#1086' '#1084#1072#1088#1082#1077#1090'. '#1073#1086#1085#1091#1089#1091
            DataBinding.FieldName = 'isPromoBonus'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object Color_calc: TcxGridDBColumn
            DataBinding.FieldName = 'Color_calc'
            Visible = False
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1040
    Height = 50
    TabOrder = 3
    ExplicitWidth = 1040
    ExplicitHeight = 50
    inherited edInvNumber: TcxTextEdit
      Left = 7
      ExplicitLeft = 7
    end
    inherited cxLabel1: TcxLabel
      Left = 7
      Top = 4
      ExplicitLeft = 7
      ExplicitTop = 4
    end
    inherited edOperDate: TcxDateEdit
      Left = 101
      Properties.ReadOnly = True
      ExplicitLeft = 101
      ExplicitWidth = 81
      Width = 81
    end
    inherited cxLabel2: TcxLabel
      Left = 101
      Top = 4
      ExplicitLeft = 101
      ExplicitTop = 4
    end
    inherited cxLabel15: TcxLabel
      Left = 297
      Top = 0
      Visible = False
      ExplicitLeft = 297
      ExplicitTop = 0
    end
    inherited ceStatus: TcxButtonEdit
      Left = 343
      Top = -5
      Visible = False
      ExplicitLeft = 343
      ExplicitTop = -5
      ExplicitWidth = 94
      ExplicitHeight = 22
      Width = 94
    end
    object edUnit: TcxButtonEdit
      Left = 188
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 277
    end
    object lblUnit: TcxLabel
      Left = 188
      Top = 4
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object cxLabel3: TcxLabel
      Left = 581
      Top = 5
      Caption = #1057#1091#1084#1084#1072
    end
    object edTotalSumm: TcxTextEdit
      Left = 581
      Top = 23
      Properties.Alignment.Horz = taRightJustify
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 103
    end
    object cxLabel8: TcxLabel
      Left = 471
      Top = 6
      Hint = '(-)% '#1057#1082#1080#1076#1082#1080' (+)% '#1053#1072#1094#1077#1085#1082#1080
      Caption = '(-)% '#1057#1082'. (+)% '#1053#1072#1094'.'
    end
    object edChangePercent: TcxCurrencyEdit
      Left = 471
      Top = 23
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 103
    end
  end
  object cxLabel4: TcxLabel [2]
    Left = 690
    Top = 4
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1086#1089#1085#1086#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1088#1072#1074#1077#1085#1089#1090#1074#1072' '#1094#1077#1085')'
  end
  object edUnitForwarding: TcxButtonEdit [3]
    Left = 690
    Top = 23
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 322
  end
  inherited ActionList: TActionList
    inherited actMISetErased: TdsdUpdateErased
      Enabled = False
    end
    inherited actMISetUnErased: TdsdUpdateErased
      Enabled = False
    end
    inherited actInsertUpdateMovement: TdsdExecStoredProc
      Enabled = False
    end
    inherited actShowErased: TBooleanStoredProcAction
      Enabled = False
    end
    inherited actShowAll: TBooleanStoredProcAction
      Enabled = False
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      Enabled = False
    end
    inherited actPrint: TdsdPrintAction
      Enabled = False
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus
      Enabled = False
    end
    inherited actCompleteMovement: TChangeGuidesStatus
      Enabled = False
    end
    inherited actDeleteMovement: TChangeGuidesStatus
      Enabled = False
    end
    inherited actMovementItemContainer: TdsdOpenForm
      Enabled = False
    end
    inherited MovementItemProtocolOpenForm: TdsdOpenForm
      Enabled = False
    end
    inherited MultiAction: TMultiAction
      Enabled = False
    end
    inherited actNewDocument: TdsdInsertUpdateAction
      Enabled = False
    end
    inherited actAddMask: TdsdExecStoredProc
      Enabled = False
    end
    object actRepriceMI: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecRepriceMI
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1087#1077#1088#1077#1086#1094#1077#1085#1082#1091' '#1090#1077#1082#1091#1097#1077#1081' '#1087#1086#1079#1080#1094#1080#1080'?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1055#1077#1088#1077#1086#1094#1077#1085#1080#1090#1100' '#1090#1077#1082#1091#1097#1091#1102' '#1087#1086#1079#1080#1094#1080#1102
      Hint = #1055#1077#1088#1077#1086#1094#1077#1085#1080#1090#1100' '#1090#1077#1082#1091#1097#1091#1102' '#1087#1086#1079#1080#1094#1080#1102
      ImageIndex = 27
    end
    object actExecRepriceMI: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spExecRepriceMI
      StoredProcList = <
        item
          StoredProc = spExecRepriceMI
        end>
      Caption = 'actExecRepriceMI'
    end
    object actRepriceMIAll: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecRepriceMIAll
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1087#1077#1088#1077#1086#1094#1077#1085#1082#1091' '#1090#1077#1082#1091#1097#1077#1081' '#1087#1086#1079#1080#1094#1080#1080' '#1090#1086#1074#1072#1088#1072' '#1087#1086' '#1074#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084' '#1087 +
        #1077#1088#1077#1086#1094#1077#1085#1082#1080' '#1079#1072' '#1076#1077#1085#1100' '#1075#1076#1077' '#1086#1085#1072' '#1086#1090#1089#1077#1077#1085#1072'?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = 
        #1055#1077#1088#1077#1086#1094#1077#1085#1080#1090#1100' '#1090#1077#1082#1091#1097#1091#1102' '#1087#1086#1079#1080#1094#1080#1102' '#1090#1086#1074#1072#1088#1072' '#1087#1086' '#1074#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084' '#1087#1077#1088#1077#1086#1094#1077#1085#1082#1080 +
        ' '#1079#1072' '#1076#1077#1085#1100
      Hint = 
        #1055#1077#1088#1077#1086#1094#1077#1085#1080#1090#1100' '#1090#1077#1082#1091#1097#1091#1102' '#1087#1086#1079#1080#1094#1080#1102' '#1090#1086#1074#1072#1088#1072' '#1087#1086' '#1074#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084' '#1087#1077#1088#1077#1086#1094#1077#1085#1082#1080 +
        ' '#1079#1072' '#1076#1077#1085#1100
      ImageIndex = 28
    end
    object actExecRepriceMIAll: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spExecRepriceMIAll
      StoredProcList = <
        item
          StoredProc = spExecRepriceMIAll
        end>
      Caption = 'actExecRepriceMIAll'
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Reprice'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = False
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = False
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbAddMask'
        end
        item
          Visible = True
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemContainer'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRepriceMI'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbRepriceMIAll'
        end>
    end
    inherited bbPrint: TdxBarButton
      Visible = ivNever
    end
    inherited bbShowAll: TdxBarButton
      Visible = ivNever
    end
    inherited bbInsertUpdateMovement: TdxBarButton
      Visible = ivNever
    end
    inherited bbErased: TdxBarButton
      Visible = ivNever
    end
    inherited bbUnErased: TdxBarButton
      Visible = ivNever
    end
    inherited bbShowErased: TdxBarButton
      Visible = ivNever
    end
    inherited bbAddMask: TdxBarButton
      Visible = ivNever
    end
    inherited bbMovementItemContainer: TdxBarButton
      Visible = ivNever
    end
    inherited bbMovementItemProtocol: TdxBarButton
      Visible = ivNever
    end
    object bbRepriceMI: TdxBarButton
      Action = actRepriceMI
      Category = 0
    end
    object bbRepriceMIAll: TdxBarButton
      Action = actRepriceMIAll
      Category = 0
    end
    object dxBarSubItem1: TdxBarSubItem
      Caption = 'New SubItem'
      Category = 0
      Visible = ivAlways
      ItemLinks = <>
    end
    object dxBarStatic1: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 0
      end>
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Reprice'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = ''
        Component = edTotalSumm
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitForwardingId'
        Value = ''
        Component = UnitForwardingGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitForwardingName'
        Value = Null
        Component = UnitForwardingGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChangePercent'
        Value = Null
        Component = edChangePercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    Left = 218
    Top = 320
  end
  inherited HeaderSaver: THeaderSaver
    StoredProc = nil
    Left = 584
    Top = 177
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    Left = 430
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    Left = 496
    Top = 248
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 352
    Top = 16
  end
  object UnitForwardingGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitForwarding
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitForwardingGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitForwardingGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 784
    Top = 16
  end
  object spExecRepriceMI: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_Reprice'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 662
    Top = 176
  end
  object spExecRepriceMIAll: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_RepriceAll'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 662
    Top = 256
  end
end
