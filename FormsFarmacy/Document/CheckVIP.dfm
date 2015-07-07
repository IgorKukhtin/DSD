inherited CheckVIPForm: TCheckVIPForm
  Caption = 'VIP '#1095#1077#1082#1080
  ClientHeight = 382
  ClientWidth = 668
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 676
  ExplicitHeight = 409
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
          object colCashMember: TcxGridDBColumn
            Caption = #1052#1077#1085#1077#1076#1078#1077#1088
            DataBinding.FieldName = 'CashMember'
            Width = 83
          end
          object colBayer: TcxGridDBColumn
            Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'Bayer'
            Width = 77
          end
          object colOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            Width = 48
          end
          object colTotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'TotalSumm'
            Width = 50
          end
          object colCashRegisterName: TcxGridDBColumn
            Caption = #1050#1072#1089#1089#1072
            DataBinding.FieldName = 'CashRegisterName'
            Width = 57
          end
          object colInvNumber: TcxGridDBColumn
            AlternateCaption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            Width = 42
          end
          object colUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            Width = 80
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
          OptionsData.CancelOnExit = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object colGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            Width = 190
          end
          object colAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            Width = 47
          end
          object colPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            Width = 46
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
          StoredProc = dsdStoredProc1
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
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'CashRegisterName'
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1074' '#1088#1072#1073#1086#1090#1091
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1074' '#1088#1072#1073#1086#1090#1091
      ImageIndex = 7
      DataSource = MasterDS
    end
    object actDeleteCheck: TdsdChangeMovementStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spMovementSetErased
      StoredProcList = <
        item
          StoredProc = spMovementSetErased
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1095#1077#1082
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1095#1077#1082' '#1080' '#1074#1077#1088#1085#1091#1090#1100' '#1090#1086#1074#1072#1088' '#1074' '#1082#1072#1089#1089#1091
      ImageIndex = 13
      Status = mtDelete
      DataSource = MasterDS
      QuestionBeforeExecute = #1059#1076#1072#1083#1080#1090#1100' '#1095#1077#1082' '#1080' '#1074#1077#1088#1085#1091#1090#1100' '#1090#1086#1074#1072#1088' '#1074' '#1082#1072#1089#1089#1091'?'
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
    StoredProcName = 'gpSelect_Movement_CheckVIP'
    Params = <
      item
        Name = 'inIsErased'
        Value = Null
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
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
          ItemName = 'dxBarButton2'
        end
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
          ItemName = 'dxBarButton1'
        end>
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
      Action = actDeleteCheck
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end>
    Left = 440
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
    Top = 32
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 376
    Top = 32
  end
  object dsdStoredProc1: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_CheckDeferred'
    DataSet = ClientDataSet1
    DataSets = <
      item
        DataSet = ClientDataSet1
      end>
    Params = <>
    PackSize = 1
    Left = 408
    Top = 32
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 520
    Top = 264
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
      end>
    PackSize = 1
    Left = 208
    Top = 128
  end
end
