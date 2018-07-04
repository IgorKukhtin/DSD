inherited CheckVIP_ErrorForm: TCheckVIP_ErrorForm
  Caption = #1063#1077#1082#1080' '#1089' '#1090#1086#1074#1072#1088#1072#1084#1080' "'#1085#1077#1090' '#1074' '#1085#1072#1083#1080#1095#1080#1080'"'
  ClientHeight = 382
  ClientWidth = 668
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 684
  ExplicitHeight = 421
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 668
    Height = 356
    ExplicitWidth = 668
    ExplicitHeight = 356
    ClientRectBottom = 356
    ClientRectRight = 668
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 668
      ExplicitHeight = 356
      inherited cxGrid: TcxGrid
        Width = 369
        Height = 356
        Align = alLeft
        ExplicitWidth = 369
        ExplicitHeight = 356
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object StatusCode: TcxGridDBColumn
            AlternateCaption = #1059#1076#1072#1083#1077#1085
            Caption = #1057#1090#1072#1090#1091#1089
            DataBinding.FieldName = 'StatusCode'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Images = dmMain.ImageList
            Properties.Items = <
              item
                Description = #1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 11
                Value = 1
              end
              item
                Description = #1055#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 12
                Value = 2
              end
              item
                Description = #1059#1076#1072#1083#1077#1085
                ImageIndex = 13
                Value = 3
              end>
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1076#1072#1083#1077#1085
            Width = 27
          end
          object CommentError: TcxGridDBColumn
            Caption = #1054#1096#1080#1073#1082#1072
            DataBinding.FieldName = 'CommentError'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1096#1080#1073#1082#1072' '#1086#1089#1090#1072#1090#1086#1082' - '#1058#1086#1074#1072#1088'/'#1088#1072#1089#1095'/'#1092#1072#1082#1090' '#1082#1086#1083'-'#1074#1086
            Width = 60
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentVert = vaCenter
            Width = 48
          end
          object TotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'TotalSumm'
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object CashRegisterName: TcxGridDBColumn
            Caption = #1050#1072#1089#1089#1072
            DataBinding.FieldName = 'CashRegisterName'
            HeaderAlignmentVert = vaCenter
            Width = 57
          end
          object InvNumber: TcxGridDBColumn
            AlternateCaption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            Width = 50
          end
          object CashMember: TcxGridDBColumn
            Caption = #1052#1077#1085#1077#1076#1078#1077#1088
            DataBinding.FieldName = 'CashMember'
            HeaderAlignmentVert = vaCenter
            Width = 83
          end
          object UnitName: TcxGridDBColumn
            Caption = #1040#1087#1090#1077#1082#1072
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
        end
      end
      object cxGrid1: TcxGrid
        Left = 369
        Top = 0
        Width = 299
        Height = 356
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 1
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DataSource1
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 35
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 47
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 46
          end
          object PriceSale: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1073#1077#1079' '#1089#1082'.'
            DataBinding.FieldName = 'PriceSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
          end
          object ChangePercent: TcxGridDBColumn
            Caption = '% '#1089#1082'.'
            DataBinding.FieldName = 'ChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object SummChangePercent: TcxGridDBColumn
            Caption = #1089#1091#1084#1084#1072' '#1089#1082'.'
            DataBinding.FieldName = 'SummChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountOrder: TcxGridDBColumn
            Caption = #1047#1072#1082#1072#1079
            DataBinding.FieldName = 'AmountOrder'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object Color_CalcError: TcxGridDBColumn
            DataBinding.FieldName = 'Color_CalcError'
            Visible = False
            VisibleForCustomization = False
            Width = 30
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
    end
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectMI
        end>
    end
    object actShowErased: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 63
      Value = False
      HintTrue = #1042' '#1088#1072#1073#1086#1090#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      CaptionTrue = #1042' '#1088#1072#1073#1086#1090#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object dsdChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Bayer'
          MultiSelectSeparator = ','
        end
        item
          Name = 'CashMemberId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'CashMemberId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'CashMember'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'CashMember'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DiscountExternalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'DiscountExternalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'DiscountExternalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'DiscountExternalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DiscountCardNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'DiscountCardNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ConfirmedKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ConfirmedKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'BayerPhone'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BayerPhone'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumberOrder'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumberOrder'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ConfirmedKindClientName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ConfirmedKindClientName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ManualDiscount'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ManualDiscount'
          MultiSelectSeparator = ','
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1074' '#1088#1072#1073#1086#1090#1091
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1074' '#1088#1072#1073#1086#1090#1091
      ImageIndex = 7
      DataSource = MasterDS
    end
    object actCompleteCheck: TdsdChangeMovementStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spMovementComplete
      StoredProcList = <
        item
          StoredProc = spMovementComplete
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 12
      Status = mtComplete
      DataSource = MasterDS
    end
    object actSetConfirmedKind_Complete: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spConfirmedKind_Complete
      StoredProcList = <
        item
          StoredProc = spConfirmedKind_Complete
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072' - <'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085'>'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072' - <'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085'>'
    end
    object actSetConfirmedKind_UnComplete: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spConfirmedKind_UnComplete
      StoredProcList = <
        item
          StoredProc = spConfirmedKind_UnComplete
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072' - <'#1053#1077' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085'>'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072' - <'#1053#1077' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085'>'
    end
    object actSimpleCompleteList: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spCompete
        end>
      View = cxGridDBTableView
      Caption = #1055#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
      Hint = #1055#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
    end
    object actCompleteList: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSimpleCompleteList
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1080' '#1042#1089#1077#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'? '
      InfoAfterExecute = #1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1087#1088#1086#1074#1077#1076#1077#1085#1099
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      ImageIndex = 12
    end
    object spCompete: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spMovementComplete
      StoredProcList = <
        item
          StoredProc = spMovementComplete
        end>
      Caption = 'spCompete'
    end
    object actShowMessage: TShowMessageAction
      Category = 'DSDLib'
      MoveParams = <>
    end
  end
  inherited MasterDS: TDataSource
    Left = 40
    Top = 88
  end
  inherited MasterCDS: TClientDataSet
    Left = 8
    Top = 88
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_CheckVIP_Error'
    Params = <
      item
        Name = 'inIsErased'
        Value = Null
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 88
  end
  inherited BarManager: TdxBarManager
    Left = 104
    Top = 88
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
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
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      ShowCaption = False
    end
    object dxBarButton1: TdxBarButton
      Action = actShowErased
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actCompleteCheck
      Category = 0
    end
    object bbConfirmedKind_Complete: TdxBarButton
      Action = actSetConfirmedKind_Complete
      Caption = 'VIP '#1095#1077#1082'  - <'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085'>'
      Category = 0
      ImageIndex = 77
    end
    object bbConfirmedKind_UnComplete: TdxBarButton
      Action = actSetConfirmedKind_UnComplete
      Caption = 'VIP '#1095#1077#1082'  - <'#1053#1077' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085'>'
      Category = 0
      ImageIndex = 58
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end>
    Left = 440
  end
  inherited PopupMenu: TPopupMenu
    object N2: TMenuItem [0]
      Action = actCompleteList
    end
    object N3: TMenuItem [1]
      Caption = '-'
    end
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'MovementId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 344
    Top = 56
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 376
    Top = 56
  end
  object spSelectMI: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_CheckDeferred'
    DataSet = ClientDataSet1
    DataSets = <
      item
        DataSet = ClientDataSet1
      end>
    Params = <>
    PackSize = 1
    Left = 488
    Top = 72
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <
      item
        ValueColumn = Color_CalcError
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 544
    Top = 256
  end
  object spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_Check'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 208
    Top = 128
  end
  object spConfirmedKind_Complete: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Check_ConfirmedKind'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisComplete'
        Value = 'True'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outConfirmedKindName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ConfirmedKindName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 536
    Top = 112
  end
  object spConfirmedKind_UnComplete: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Check_ConfirmedKind'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisComplete'
        Value = 'False'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outConfirmedKindName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ConfirmedKindName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 528
    Top = 168
  end
  object spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_Check'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStatusCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StatusCode'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMessageText'
        Value = Null
        Component = actShowMessage
        ComponentItem = 'MessageText'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 248
    Top = 200
  end
end
