inherited IncomeFuelForm: TIncomeFuelForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1055#1088#1080#1093#1086#1076' ('#1047#1072#1087#1088#1072#1074#1082#1072' '#1072#1074#1090#1086')'
  ClientHeight = 396
  ClientWidth = 773
  KeyPreview = True
  PopupMenu = PopupMenu
  ExplicitWidth = 789
  ExplicitHeight = 431
  PixelsPerInch = 96
  TextHeight = 13
  object DataPanel: TPanel
    Left = 0
    Top = 0
    Width = 773
    Height = 89
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object edInvNumber: TcxTextEdit
      Left = 8
      Top = 25
      Enabled = False
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 121
    end
    object cxLabel1: TcxLabel
      Left = 8
      Top = 7
      Caption = #1053#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    end
    object edOperDate: TcxDateEdit
      Left = 142
      Top = 25
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 121
    end
    object cxLabel2: TcxLabel
      Left = 142
      Top = 7
      Caption = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    end
    object edFrom: TcxButtonEdit
      Left = 276
      Top = 25
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 3
      Width = 150
    end
    object edTo: TcxButtonEdit
      Left = 276
      Top = 66
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 2
      Width = 150
    end
    object cxLabel3: TcxLabel
      Left = 276
      Top = 7
      Caption = #1054#1090' '#1082#1086#1075#1086' ('#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090')'
    end
    object cxLabel4: TcxLabel
      Left = 276
      Top = 48
      Caption = #1050#1086#1084#1091' ('#1040#1074#1090#1086#1084#1086#1073#1080#1083#1100')'
    end
    object edPriceWithVAT: TcxCheckBox
      Left = 8
      Top = 66
      Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
      TabOrder = 6
      Width = 129
    end
    object edVATPercent: TcxCurrencyEdit
      Left = 142
      Top = 66
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      TabOrder = 7
      Width = 65
    end
    object cxLabel7: TcxLabel
      Left = 142
      Top = 51
      Caption = '% '#1053#1044#1057
    end
    object cxLabel9: TcxLabel
      Left = 600
      Top = 7
      Caption = #1044#1086#1075#1086#1074#1086#1088
    end
    object edContract: TcxButtonEdit
      Left = 600
      Top = 25
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 4
      Width = 150
    end
    object cxLabel10: TcxLabel
      Left = 600
      Top = 49
      Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
    end
    object edPaidKind: TcxButtonEdit
      Left = 600
      Top = 66
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 150
    end
    object cxLabel12: TcxLabel
      Left = 440
      Top = 51
      Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1042#1086#1076#1080#1090#1077#1083#1100')'
    end
    object edDriver: TcxButtonEdit
      Left = 440
      Top = 66
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 8
      Width = 150
    end
    object edRoute: TcxButtonEdit
      Left = 440
      Top = 25
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 17
      Width = 150
    end
    object cxLabel5: TcxLabel
      Left = 440
      Top = 7
      Caption = #1052#1072#1088#1096#1088#1091#1090
    end
  end
  object cxPageControl: TcxPageControl
    Left = 0
    Top = 115
    Width = 773
    Height = 281
    Align = alClient
    TabOrder = 2
    Properties.ActivePage = cxTabSheet1
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 281
    ClientRectRight = 773
    ClientRectTop = 24
    object cxTabSheet1: TcxTabSheet
      Caption = #1057#1090#1088#1086#1095#1085#1072#1103' '#1095#1072#1089#1090#1100
      ImageIndex = 0
      object cxGrid: TcxGrid
        Left = 0
        Top = 0
        Width = 773
        Height = 257
        Align = alClient
        TabOrder = 0
        object cxGridDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DataSource
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00;-,0.00;'
              Kind = skSum
              Position = spFooter
              Column = colAmountSumm
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.###;-,0.###; ;'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.###;-,0.###; ;'
              Kind = skSum
            end
            item
              Format = ',0.###;-,0.###; ;'
              Kind = skSum
            end
            item
              Format = ',0.###;-,0.###; ;'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00;-,0.00;'
              Kind = skSum
              Column = colAmountSumm
            end
            item
              Kind = skSum
            end
            item
              Format = ',0.###;-,0.###; ;'
              Kind = skSum
            end
            item
              Format = ',0.###;-,0.###; ;'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.###;-,0.###; ;'
              Kind = skSum
            end
            item
              Format = ',0.###;-,0.###; ;'
              Kind = skSum
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object colCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object colName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 200
          end
          object colAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-0.00;'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colCountForPrice: TcxGridDBColumn
            Caption = #1050#1086#1083' '#1074' '#1094#1077#1085#1077
            DataBinding.FieldName = 'CountForPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0;;'
            Visible = False
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object colAmountSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'AmountSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
        end
        object cxGridLevel: TcxGridLevel
          GridView = cxGridDBTableView
        end
      end
    end
    object cxTabSheet2: TcxTabSheet
      Caption = #1055#1088#1086#1074#1086#1076#1082#1080
      ImageIndex = 1
      object cxGridEntry: TcxGrid
        Left = 0
        Top = 0
        Width = 773
        Height = 257
        Align = alClient
        TabOrder = 0
        object cxGridEntryDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = EntryDS
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = colKreditAmount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colDebetAmount
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object colAccountCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1089#1095#1077#1090#1072
            DataBinding.FieldName = 'AccountCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 73
          end
          object colDebetAccountGroupName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1044' '#1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'DebetAccountGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object colDebetAccountDirectionName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1044' '#1053#1072#1087#1088#1072#1074#1083
            DataBinding.FieldName = 'DebetAccountDirectionName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object colDebetAccountName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1044#1077#1073#1077#1090
            DataBinding.FieldName = 'DebetAccountName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object colKreditAccountGroupName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1050' '#1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'KreditAccountGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colKreditAccountDirectionName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1050' '#1053#1072#1087#1088#1072#1074#1083
            DataBinding.FieldName = 'KreditAccountDirectionName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colKreditAccountName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1050#1088#1077#1076#1080#1090
            DataBinding.FieldName = 'KreditAccountName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 88
          end
          object colByObjectCode: TcxGridDBColumn
            Caption = #1054#1073'.'#1082#1086#1076
            DataBinding.FieldName = 'ByObjectCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object colByObjectName: TcxGridDBColumn
            Caption = #1054#1073#1098#1077#1082#1090' '#1085#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'ByObjectName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 98
          end
          object colGoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'.'
            DataBinding.FieldName = 'GoodsCode'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object colGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colGoodsKindName_comlete: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object colAccountOnComplete: TcxGridDBColumn
            Caption = '***'
            DataBinding.FieldName = 'AccountOnComplete'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 32
          end
          object colDebetAmount: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1076#1077#1073#1077#1090
            DataBinding.FieldName = 'DebetAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 66
          end
          object colKreditAmount: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1082#1088#1077#1076#1080#1090
            DataBinding.FieldName = 'KreditAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Properties.Nullable = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object colPrice_comlete: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;,0.00##; ;'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Width = 58
          end
          object colInfoMoneyName: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Width = 93
          end
          object colInfoMoneyName_Detail: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1100#1103' '#1076#1077#1090#1072#1083#1100#1085#1086
            DataBinding.FieldName = 'InfoMoneyName_Detail'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
        end
        object cxGridEntryLevel: TcxGridLevel
          GridView = cxGridEntryDBTableView
        end
      end
    end
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        DataType = ftInteger
        ParamType = ptInputOutput
        Value = '0'
      end>
    Left = 48
    Top = 144
  end
  object spSelectMovementItem: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_IncomeFuel'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Component = FormParams
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inShowAll'
        Component = BooleanStoredProcAction
        DataType = ftBoolean
        ParamType = ptInput
        Value = False
      end>
    Left = 64
    Top = 272
  end
  object dxBarManager: TdxBarManager
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
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 16
    Top = 144
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar: TdxBar
      AllowClose = False
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 51
      FloatClientHeight = 71
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbBooleanAction'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'bbGridToExel'
        end
        item
          Visible = True
          ItemName = 'bbEntryToGrid'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbBooleanAction: TdxBarButton
      Action = BooleanStoredProcAction
      Category = 0
    end
    object bbStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Visible = ivAlways
    end
    object bbGridToExel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
    end
    object bbEntryToGrid: TdxBarButton
      Action = dsdEntryToExcel
      Category = 0
    end
    object bbInsertUpdateMovement: TdxBarButton
      Action = actInsertUpdateMovement
      Category = 0
    end
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 112
    Top = 144
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 80
    Top = 144
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelectMovementItem
        end
        item
          StoredProc = spSelectMovementContainerItem
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      StoredProc = spInsertUpdateMovementItem
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovementItem
        end>
      Caption = 'actUpdateDataSet'
      DataSource = DataSource
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16464
      Params = <
        item
          Name = 'InvNumber'
          Component = edInvNumber
          DataType = ftString
          ParamType = ptInput
          Value = ''
        end
        item
          Name = 'From'
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          Value = ''
        end
        item
          Name = 'OperDate'
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          Value = 0d
        end>
      ReportName = #1055#1088#1080#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
    end
    object BooleanStoredProcAction: TBooleanStoredProcAction
      Category = 'DSDLib'
      StoredProc = spSelectMovementItem
      StoredProcList = <
        item
          StoredProc = spSelectMovementItem
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object dsdGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      TabSheet = cxTabSheet1
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object dsdEntryToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      TabSheet = cxTabSheet2
      Grid = cxGridEntry
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actInsertUpdateMovement: TdsdExecStoredProc
      Category = 'DSDLib'
      StoredProc = spInsertUpdateMovement
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
        end>
      Caption = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 14
      ShortCut = 113
    end
  end
  object DataSource: TDataSource
    DataSet = MasterCDS
    Left = 48
    Top = 200
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 136
    Top = 200
  end
  object GuidesFrom: TdsdGuides
    LookupControl = edFrom
    FormName = 'TPartnerForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Component = GuidesFrom
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'TextValue'
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    Left = 352
  end
  object GuidesTo: TdsdGuides
    LookupControl = edTo
    FormName = 'TCarForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Component = GuidesTo
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'TextValue'
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'DriverId'
        Component = GuidesPersonalDriver
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'DriverName'
        Component = GuidesPersonalDriver
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end>
    Left = 320
    Top = 64
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 456
    Top = 120
    object N1: TMenuItem
      Action = actRefresh
    end
  end
  object spSelectMovementContainerItem: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItemContainer_Movement'
    DataSet = EntryCDS
    DataSets = <
      item
        DataSet = EntryCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Component = FormParams
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end>
    Left = 536
    Top = 256
  end
  object EntryCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 576
    Top = 240
  end
  object EntryDS: TDataSource
    DataSet = EntryCDS
    Left = 608
    Top = 240
  end
  object spInsertUpdateMovementItem: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_IncomeFuel'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = MasterCDS
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptInputOutput
      end
      item
        Name = 'inMovementId'
        Component = FormParams
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inGoodsId'
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Name = 'inAmount'
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPrice'
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'ioCountForPrice'
        Component = MasterCDS
        ComponentItem = 'CountForPrice'
        DataType = ftFloat
        ParamType = ptInputOutput
      end
      item
        Name = 'outAmountSumm'
        Component = MasterCDS
        ComponentItem = 'AmountSumm'
        DataType = ftFloat
        ParamType = ptOutput
      end>
    Left = 272
    Top = 216
  end
  object frxDBDataset: TfrxDBDataset
    UserName = 'frxDBDataset'
    CloseDataSource = False
    DataSet = MasterCDS
    BCDToCurrency = False
    Left = 360
    Top = 88
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <
      item
      end>
    SortImages = dmMain.SortImageList
    Left = 96
    Top = 248
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 232
    Top = 304
  end
  object EntryViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridEntryDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    Left = 480
    Top = 256
  end
  object spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_IncomeFuel'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = FormParams
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptInputOutput
        Value = '0'
      end
      item
        Name = 'inInvNumber'
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inOperDate'
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        Value = 0d
      end
      item
        Name = 'inPriceWithVAT'
        Component = edPriceWithVAT
        DataType = ftBoolean
        ParamType = ptInput
        Value = 'False'
      end
      item
        Name = 'inVATPercent'
        Component = edVATPercent
        DataType = ftFloat
        ParamType = ptInput
        Value = 0.000000000000000000
      end
      item
        Name = 'inFromId'
        Component = GuidesFrom
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inToId'
        Component = GuidesTo
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inPaidKindId'
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inContractId'
        Component = GuidesContract
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inRouteId'
        Component = GuidesRoute
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inPersonalDriverId'
        Component = GuidesPersonalDriver
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end>
    Left = 304
    Top = 120
  end
  object HeaderSaver: THeaderSaver
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.DataType = ftInteger
    IdParam.ParamType = ptOutput
    IdParam.Value = '0'
    StoredProc = spInsertUpdateMovement
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edOperDate
      end
      item
        Control = edFrom
      end
      item
        Control = edTo
      end
      item
        Control = edRoute
      end
      item
        Control = edDriver
      end
      item
        Control = edContract
      end
      item
        Control = edPaidKind
      end
      item
        Control = edPriceWithVAT
      end
      item
        Control = edVATPercent
      end>
    Left = 408
    Top = 200
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_IncomeFuel'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Component = FormParams
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'InvNumber'
        Component = edInvNumber
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'OperDate'
        Component = edOperDate
        DataType = ftInteger
        ParamType = ptOutput
        Value = 0d
      end
      item
        Name = 'FromId'
        Component = GuidesFrom
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'FromName'
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'ToId'
        Component = GuidesTo
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'ToName'
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'ToParentId'
        Component = GuidesTo
        ComponentItem = 'ParentId'
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'PriceWithVAT'
        Component = edPriceWithVAT
        DataType = ftBoolean
        ParamType = ptOutput
        Value = 'False'
      end
      item
        Name = 'VATPercent'
        Component = edVATPercent
        DataType = ftFloat
        ParamType = ptOutput
        Value = 0.000000000000000000
      end
      item
        Name = 'ContractId'
        Component = GuidesContract
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'ContarctName'
        Component = GuidesContract
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'PaidKindId'
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'PaidKindName'
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'PersonalDriverId'
        Component = GuidesPersonalDriver
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'PersonalDriverName'
        Component = GuidesPersonalDriver
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'RouteId'
        Component = edRoute
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
      end
      item
        Name = 'RouteName'
        Component = edRoute
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptOutput
      end>
    Left = 176
    Top = 120
  end
  object RefreshAddOn: TRefreshAddOn
    FormName = 'IncomeJournalForm'
    DataSet = 'ClientDataSet'
    RefreshAction = 'actRefresh'
    FormParams = 'FormParams'
    Left = 584
    Top = 88
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.DataType = ftInteger
    IdParam.ParamType = ptOutput
    IdParam.Value = '0'
    GuidesList = <
      item
        Guides = GuidesFrom
      end
      item
        Guides = GuidesRoute
      end
      item
        Guides = GuidesTo
      end
      item
        Guides = GuidesPaidKind
      end>
    ActionItemList = <
      item
        Action = actInsertUpdateMovement
      end>
    Left = 248
    Top = 96
  end
  object GuidesContract: TdsdGuides
    LookupControl = edContract
    FormName = 'TContractForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Component = GuidesContract
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'TextValue'
        Component = GuidesContract
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    Left = 648
  end
  object GuidesPaidKind: TdsdGuides
    LookupControl = edPaidKind
    FormName = 'TPaidKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'TextValue'
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    Left = 656
    Top = 72
  end
  object GuidesPersonalDriver: TdsdGuides
    LookupControl = edDriver
    FormName = 'TPersonalForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Component = GuidesPersonalDriver
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'TextValue'
        Component = GuidesPersonalDriver
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    Left = 488
    Top = 80
  end
  object GuidesRoute: TdsdGuides
    LookupControl = edRoute
    FormName = 'TRouteForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Component = GuidesRoute
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'TextValue'
        Component = GuidesRoute
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    Left = 511
    Top = 5
  end
end
