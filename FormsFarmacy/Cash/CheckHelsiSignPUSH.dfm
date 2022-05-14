inherited CheckHelsiSignPUSHForm: TCheckHelsiSignPUSHForm
  BorderIcons = [biSystemMenu]
  Caption = #1063#1077#1082#1080' '#1089' '#1085#1077#1087#1086#1075#1072#1096#1077#1085#1085#1099#1084#1080' '#1088#1077#1094#1077#1087#1090#1072#1084' '#1087#1086' '#1057#1055' "'#1044#1086#1089#1090#1091#1087#1085#1110' '#1051#1110#1082#1080'"'
  ClientHeight = 518
  ClientWidth = 921
  OnCloseQuery = ParentFormCloseQuery
  OnCreate = ParentFormCreate
  AddOnFormData.RefreshAction = nil
  ExplicitWidth = 937
  ExplicitHeight = 557
  PixelsPerInch = 96
  TextHeight = 13
  object cxCheckHelsiSignPUSHGrid: TcxGrid [0]
    Left = 0
    Top = 28
    Width = 921
    Height = 490
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object cxCheckHelsiSignPUSHGridDBBandedTableView1: TcxGridDBBandedTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.00'
          Kind = skSum
          Column = colSumm
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = colTotalSumm
        end
        item
          Format = ',0.###'
          Kind = skSum
          Column = colAmount
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsData.Deleting = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 20
      Bands = <
        item
          Caption = #1063#1077#1082
        end
        item
          Caption = #1056#1077#1094#1077#1087#1090
          Width = 132
        end
        item
          Caption = #1058#1086#1074#1072#1088
        end
        item
          Caption = #1055#1086#1075#1072#1096#1077#1085#1080#1077
          Width = 85
        end>
      object colOrd: TcxGridDBBandedColumn
        Caption = #8470
        DataBinding.FieldName = 'Ord'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 35
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object colInvNumber: TcxGridDBBandedColumn
        Caption = #1053#1086#1084#1077#1088
        DataBinding.FieldName = 'InvNumber'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 82
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object colTotalSumm: TcxGridDBBandedColumn
        Caption = #1057#1091#1084#1084#1072
        DataBinding.FieldName = 'TotalSumm'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 80
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object colInvNumberSP: TcxGridDBBandedColumn
        Caption = #1053#1086#1084#1077#1088
        DataBinding.FieldName = 'InvNumberSP'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Position.BandIndex = 1
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object colGoodsCode: TcxGridDBBandedColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 49
        Position.BandIndex = 2
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object colGoodsName: TcxGridDBBandedColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'GoodsName'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 220
        Position.BandIndex = 2
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object colAmount: TcxGridDBBandedColumn
        AlternateCaption = #1050#1086#1083'-'#1074#1086
        Caption = #1050#1086#1083'-'#1074#1086
        DataBinding.FieldName = 'Amount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.###'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 55
        Position.BandIndex = 2
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object colPrice: TcxGridDBBandedColumn
        Caption = #1062#1077#1085#1072
        DataBinding.FieldName = 'Price'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 80
        Position.BandIndex = 2
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object colSumm: TcxGridDBBandedColumn
        Caption = #1057#1091#1084#1084#1072
        DataBinding.FieldName = 'Summ'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 80
        Position.BandIndex = 2
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object colBonusAmountTab: TcxGridDBBandedColumn
        Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
        DataBinding.FieldName = 'State'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 80
        Position.BandIndex = 3
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object colColor_calc: TcxGridDBBandedColumn
        Caption = #1059#1095#1080#1090#1099#1074#1072#1090#1100' '#1076#1083#1103' '#1085#1077#1086#1073#1093#1086#1076#1080#1084#1086#1075#1086' % '#1087#1086#1089#1090#1088#1086#1095#1085#1086#1075#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103
        DataBinding.FieldName = 'Color_calc'
        Visible = False
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Styles.Content = dmMain.cxGreenEdit
        Width = 80
        Position.BandIndex = 3
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
    end
    object cxCheckHelsiSignPUSHGridLevel1: TcxGridLevel
      GridView = cxCheckHelsiSignPUSHGridDBBandedTableView1
    end
  end
  object ClientDataSet: TClientDataSet [1]
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    AfterOpen = ClientDataSetAfterOpen
    Left = 64
    Top = 208
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 304
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = cxCheckHelsiSignPUSHGrid
        Properties.Strings = (
          'Width')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    Left = 264
    Top = 304
  end
  inherited ActionList: TActionList
    Images = dmMain.ImageList
    Left = 159
    Top = 303
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end>
      ShortCut = 0
    end
    object actLoadState: TAction
      Category = 'DSDLib'
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1089#1090#1072#1090#1091#1089' '#1087#1086' '#1074#1089#1077#1084' '#1095#1077#1082#1072#1084
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1089#1090#1072#1090#1091#1089' '#1087#1086' '#1074#1089#1077#1084' '#1095#1077#1082#1072#1084
      ImageIndex = 41
      OnExecute = actLoadStateExecute
    end
    object actLoadStateCurr: TAction
      Category = 'DSDLib'
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1089#1090#1072#1090#1091#1089' '#1087#1086' '#1095#1077#1082#1091
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1089#1090#1072#1090#1091#1089' '#1087#1086' '#1095#1077#1082#1091
      ImageIndex = 29
      OnExecute = actLoadStateCurrExecute
    end
    object actSign: TAction
      Category = 'DSDLib'
      Caption = #1055#1086#1075#1072#1089#1080#1090#1100' '#1088#1077#1094#1077#1087#1090
      Hint = #1055#1086#1075#1072#1089#1080#1090#1100' '#1088#1077#1094#1077#1087#1090
      ImageIndex = 12
      OnExecute = actSignExecute
    end
    object actGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxCheckHelsiSignPUSHGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
  end
  object BarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 376
    Top = 312
    PixelsPerInch = 96
    DockControlHeights = (
      0
      0
      28
      0)
    object Bar: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton6'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton5'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbRefresh: TdxBarButton
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Category = 0
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Visible = ivAlways
      ImageIndex = 4
      ShortCut = 116
      Left = 280
    end
    object dxBarStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
      Left = 208
      Top = 65528
    end
    object bbGridToExcel: TdxBarButton
      Caption = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1074' '#1087#1088#1072#1081#1089' - '#1083#1080#1089#1090#1072#1093'  '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
      Category = 0
      Hint = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1074' '#1087#1088#1072#1081#1089' - '#1083#1080#1089#1090#1072#1093'  '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
      Visible = ivAlways
      ImageIndex = 28
      Left = 232
    end
    object bbOpen: TdxBarButton
      Caption = #1054#1090#1082#1088#1099#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 1
      Left = 160
    end
    object dxBarButton1: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Visible = ivAlways
      ImageIndex = 35
    end
    object dxBarButton2: TdxBarButton
      Action = actLoadState
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actLoadStateCurr
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actSign
      Category = 0
    end
    object dxBarButton5: TdxBarButton
      Action = actGridToExcel
      Category = 0
    end
    object dxBarButton6: TdxBarButton
      Action = actRefresh
      Category = 0
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 168
    Top = 208
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_CheckHelsiPUSU'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end
      item
      end
      item
      end
      item
      end
      item
        DataSet = ClientDataSet
      end>
    Params = <>
    PackSize = 1
    Left = 288
    Top = 208
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxCheckHelsiSignPUSHGridDBBandedTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        BackGroundValueColumn = colColor_calc
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 600
    Top = 320
  end
end
