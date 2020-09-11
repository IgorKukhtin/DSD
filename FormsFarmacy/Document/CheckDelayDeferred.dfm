inherited CheckDelayDeferredForm: TCheckDelayDeferredForm
  Caption = #1055#1088#1086#1089#1088#1086#1095#1077#1085#1085#1099#1077' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1077' '#1095#1077#1082#1080
  ClientHeight = 382
  ClientWidth = 668
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
        Width = 313
        Height = 356
        Align = alLeft
        ExplicitWidth = 313
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
            Caption = 'X'
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
            HeaderHint = #1059#1076#1072#1083#1077#1085
            Width = 20
          end
          object ConfirmedKindName: TcxGridDBColumn
            Caption = #1057#1090#1072#1090'. '#1079'.'
            DataBinding.FieldName = 'ConfirmedKindName'
            HeaderHint = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072' ('#1089#1072#1081#1090')'
            Width = 55
          end
          object CashMember: TcxGridDBColumn
            Caption = #1052#1077#1085#1077#1076#1078#1077#1088
            DataBinding.FieldName = 'CashMember'
            Width = 83
          end
          object Bayer: TcxGridDBColumn
            Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'Bayer'
            Width = 77
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            Width = 48
          end
          object TotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'TotalSumm'
            Width = 50
          end
          object CashRegisterName: TcxGridDBColumn
            Caption = #1050#1072#1089#1089#1072
            DataBinding.FieldName = 'CashRegisterName'
            Width = 57
          end
          object InvNumber: TcxGridDBColumn
            AlternateCaption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            Width = 50
          end
          object NumberOrder: TcxGridDBColumn
            Caption = #8470' '#1079'.'
            DataBinding.FieldName = 'InvNumberOrder'
            HeaderHint = #8470' '#1079#1072#1082#1072#1079#1072' ('#1089#1072#1081#1090')'
            Width = 45
          end
          object UnitName: TcxGridDBColumn
            Caption = #1040#1087#1090#1077#1082#1072
            DataBinding.FieldName = 'UnitName'
            Width = 55
          end
          object BayerPhone: TcxGridDBColumn
            Caption = #1058#1077#1083'. '#1087#1086#1082'.'
            DataBinding.FieldName = 'BayerPhone'
            Width = 65
          end
          object ConfirmedKindClientName: TcxGridDBColumn
            Caption = #1057#1084#1089
            DataBinding.FieldName = 'ConfirmedKindClientName'
            HeaderHint = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072' ('#1054#1090#1087#1088#1072#1074#1083#1077#1085' '#1082#1083#1080#1077#1085#1090#1091')'
            Options.Editing = False
            Width = 50
          end
          object DiscountCardNumber: TcxGridDBColumn
            Caption = #8470' '#1082#1072#1088#1090#1099
            DataBinding.FieldName = 'DiscountCardNumber'
            Width = 70
          end
          object DiscountExternalName: TcxGridDBColumn
            Caption = #1055#1088#1086#1077#1082#1090
            DataBinding.FieldName = 'DiscountExternalName'
            Width = 70
          end
          object InvNumberSP: TcxGridDBColumn
            Caption = #8470' '#1088#1077#1094#1077#1087#1090#1072
            DataBinding.FieldName = 'InvNumberSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object MedicSP: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1074#1088#1072#1095#1072
            DataBinding.FieldName = 'MedicSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object SPKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1057#1055
            DataBinding.FieldName = 'SPKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SPTax: TcxGridDBColumn
            Caption = '% '#1089#1082#1080#1076#1082#1080' '#1076#1083#1103' '#1057#1055
            DataBinding.FieldName = 'SPTax'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PartionDateKindName: TcxGridDBColumn
            Caption = #1058#1080#1087#1099' '#1089#1088#1086#1082'/'#1085#1077' '#1089#1088#1086#1082
            DataBinding.FieldName = 'PartionDateKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 62
          end
          object DateDelay: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1087#1088#1086#1089#1088#1086#1095#1082#1080
            DataBinding.FieldName = 'DateDelay'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object Color_CalcDoc: TcxGridDBColumn
            DataBinding.FieldName = 'Color_CalcDoc'
            Visible = False
            VisibleForCustomization = False
            Width = 30
          end
        end
      end
      object cxGrid1: TcxGrid
        Left = 321
        Top = 0
        Width = 347
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
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
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
          object ListPartionDateKindName: TcxGridDBColumn
            Caption = #1058#1080#1087#1099' '#1089#1088#1086#1082'/'#1085#1077' '#1089#1088#1086#1082
            DataBinding.FieldName = 'PartionDateKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 62
          end
          object Color_Calc: TcxGridDBColumn
            DataBinding.FieldName = 'Color_Calc'
            Visible = False
            VisibleForCustomization = False
            Width = 20
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 313
        Top = 0
        Width = 8
        Height = 356
        HotZoneClassName = 'TcxMediaPlayer8Style'
        Control = cxGrid
      end
    end
  end
  inherited ActionList: TActionList
    object actDeleteCheck: TdsdChangeMovementStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spMovementUnComplete
      StoredProcList = <
        item
          StoredProc = spMovementUnComplete
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1091#1076#1072#1083#1077#1085#1080#1077' '#1095#1077#1082#1072
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1091#1076#1072#1083#1077#1085#1080#1077' '#1095#1077#1082#1072' '#1080' '#1079#1072#1088#1077#1079#1077#1088#1074#1080#1088#1086#1074#1072#1090#1100' '#1090#1086#1074#1072#1088
      ImageIndex = 12
      Status = mtUncomplete
      DataSource = MasterDS
      QuestionBeforeExecute = #1054#1090#1084#1077#1085#1080#1090#1100' '#1091#1076#1072#1083#1077#1085#1080#1077' '#1095#1077#1082#1072' '#1080' '#1079#1072#1088#1077#1079#1077#1088#1074#1080#1088#1086#1074#1072#1090#1100' '#1090#1086#1074#1072#1088
    end
    object actIsShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1079#1072' '#1087#1086#1089#1083#1077#1076#1085#1080#1080' 10 '#1076#1085#1077#1081
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1079#1072' '#1087#1086#1089#1083#1077#1076#1085#1080#1080' 10 '#1076#1085#1077#1081
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 65
      ImageIndexFalse = 64
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
    StoredProcName = 'gpSelect_Movement_CheckDelayDeferred'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = ClientDataSet1
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inType'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsShowAll'
        Value = Null
        Component = actIsShowAll
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
          ItemName = 'dxBarButton5'
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Category = 0
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Visible = ivAlways
      ImageIndex = 63
    end
    object dxBarButton2: TdxBarButton
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1074' '#1088#1072#1073#1086#1090#1091
      Category = 0
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1074' '#1088#1072#1073#1086#1090#1091
      Visible = ivAlways
      ImageIndex = 7
    end
    object dxBarButton3: TdxBarButton
      Action = actDeleteCheck
      Category = 0
    end
    object bbConfirmedKind_Complete: TdxBarButton
      Caption = 'VIP '#1095#1077#1082'  - <'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085'>'
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072' - <'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085'>'
      Visible = ivAlways
      ImageIndex = 77
    end
    object bbConfirmedKind_UnComplete: TdxBarButton
      Caption = 'VIP '#1095#1077#1082'  - <'#1053#1077' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085'>'
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072' - <'#1053#1077' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085'>'
      Visible = ivAlways
      ImageIndex = 58
    end
    object dxBarButton4: TdxBarButton
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1082' '#1076#1083#1103' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103
      Category = 0
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1082' '#1076#1083#1103' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103
      Visible = ivAlways
      ImageIndex = 1
    end
    object dxBarButton5: TdxBarButton
      Action = actIsShowAll
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
      end>
    ColorRuleList = <
      item
        BackGroundValueColumn = Color_CalcDoc
        ColorValueList = <>
      end>
    Left = 400
    Top = 248
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'MovementId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 312
    Top = 56
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 376
    Top = 56
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
        BackGroundValueColumn = Color_Calc
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    PropertiesCellList = <>
    Left = 544
    Top = 248
  end
  object spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_Check'
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
      end
      item
        Name = 'inUsersession'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 208
    Top = 128
  end
end
