inherited TransportForm: TTransportForm
  Caption = #1055#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090
  ClientHeight = 442
  ClientWidth = 995
  KeyPreview = True
  PopupMenu = PopupMenu
  ExplicitWidth = 1011
  ExplicitHeight = 477
  PixelsPerInch = 96
  TextHeight = 13
  object DataPanel: TPanel
    Left = 0
    Top = 0
    Width = 995
    Height = 84
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 1028
    object edInvNumber: TcxTextEdit
      Left = 8
      Top = 56
      TabOrder = 0
      Width = 101
    end
    object cxLabel1: TcxLabel
      Left = 8
      Top = 40
      Caption = #1053#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    end
    object edOperDate: TcxDateEdit
      Left = 8
      Top = 20
      TabOrder = 2
      Width = 101
    end
    object cxLabel2: TcxLabel
      Left = 8
      Top = 4
      Caption = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    end
    object edUnitForwarding: TcxButtonEdit
      Left = 812
      Top = 20
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 4
      Width = 182
    end
    object edCar: TcxButtonEdit
      Left = 121
      Top = 20
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 145
    end
    object cxLabel3: TcxLabel
      Left = 812
      Top = 4
      Caption = #1052#1077#1089#1090#1086' '#1086#1090#1087#1088#1072#1074#1082#1080
    end
    object cxLabel4: TcxLabel
      Left = 121
      Top = 4
      Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100' '
    end
    object edPersonalDriver: TcxButtonEdit
      Left = 121
      Top = 56
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 8
      Width = 145
    end
    object cxLabel5: TcxLabel
      Left = 121
      Top = 40
      Caption = #1042#1086#1076#1080#1090#1077#1083#1100
    end
    object edPersonalDriverMore: TcxButtonEdit
      Left = 659
      Top = 56
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 10
      Width = 145
    end
    object cxLabel6: TcxLabel
      Left = 659
      Top = 40
      Caption = #1042#1086#1076#1080#1090#1077#1083#1100', '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081
    end
    object edCarTrailer: TcxButtonEdit
      Left = 659
      Top = 20
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 12
      Width = 145
    end
    object cxLabel7: TcxLabel
      Left = 659
      Top = 4
      Caption = #1055#1088#1080#1094#1077#1087
    end
    object edStartRunPlan: TcxDateEdit
      Left = 275
      Top = 20
      TabOrder = 14
      Width = 145
    end
    object cxLabel8: TcxLabel
      Left = 275
      Top = 4
      Caption = #1044#1072#1090#1072'/'#1042#1088'.'#1074#1099#1077#1079#1076#1072' '#1087#1083#1072#1085' '
    end
    object edEndRunPlan: TcxDateEdit
      Left = 275
      Top = 56
      TabOrder = 16
      Width = 145
    end
    object cxLabel9: TcxLabel
      Left = 275
      Top = 40
      Caption = #1044#1072#1090#1072'/'#1042#1088'.'#1074#1086#1079#1074#1088#1072#1097#1077#1085#1080#1103' '#1087#1083#1072#1085
    end
    object cxLabel10: TcxLabel
      Left = 426
      Top = 4
      Caption = #1044#1072#1090#1072'/'#1042#1088'.'#1074#1099#1077#1079#1076#1072' '#1092#1072#1082#1090
    end
    object edStartRun: TcxDateEdit
      Left = 426
      Top = 20
      TabOrder = 19
      Width = 147
    end
    object cxLabel11: TcxLabel
      Left = 426
      Top = 40
      Caption = #1044#1072#1090#1072'/'#1042#1088'.'#1074#1086#1079#1074#1088#1072#1097#1077#1085#1080#1103' '#1092#1072#1082#1090
    end
    object edEndRun: TcxDateEdit
      Left = 426
      Top = 56
      TabOrder = 21
      Width = 147
    end
    object edComment: TcxTextEdit
      Left = 812
      Top = 56
      TabOrder = 22
      Width = 182
    end
    object cxLabel12: TcxLabel
      Left = 812
      Top = 40
      Caption = ' '#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '
    end
    object edHoursWork: TcxCurrencyEdit
      Left = 580
      Top = 20
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      TabOrder = 24
      Width = 71
    end
    object cxLabel13: TcxLabel
      Left = 580
      Top = 4
      Caption = #1050#1086#1083'-'#1074#1086' '#1095#1072#1089#1086#1074
    end
    object edHoursAdd: TcxCurrencyEdit
      Left = 580
      Top = 56
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      TabOrder = 26
      Width = 71
    end
    object cxLabel14: TcxLabel
      Left = 580
      Top = 40
      Caption = #1044#1086#1087'. '#1095#1072#1089#1099
    end
  end
  object cxPageControl1: TcxPageControl
    Left = 0
    Top = 110
    Width = 995
    Height = 332
    Align = alClient
    TabOrder = 5
    Properties.ActivePage = cxTabSheet1
    Properties.CustomButtons.Buttons = <>
    ExplicitWidth = 1028
    ExplicitHeight = 286
    ClientRectBottom = 332
    ClientRectRight = 995
    ClientRectTop = 24
    object cxTabSheet1: TcxTabSheet
      Caption = #1057#1090#1088#1086#1095#1085#1072#1103' '#1095#1072#1089#1090#1100
      ImageIndex = 0
      ExplicitWidth = 1028
      ExplicitHeight = 262
      object cxGrid: TcxGrid
        Left = 0
        Top = 0
        Width = 995
        Height = 152
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 1028
        ExplicitHeight = 154
        object cxGridDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = MasterDS
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
              Column = colCount
            end
            item
              Kind = skSum
              Position = spFooter
              Column = colAmount
            end
            item
              Kind = skSum
              Position = spFooter
              Column = colСuterCount
            end
            item
              Kind = skSum
              Position = spFooter
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Kind = skSum
              Column = colCount
            end
            item
              Kind = skSum
              Column = colAmount
            end
            item
              Kind = skSum
              Column = colСuterCount
            end
            item
              Kind = skSum
            end>
          DataController.Summary.SummaryGroups = <>
          OptionsView.ColumnAutoWidth = True
          object colCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            Width = 56
          end
          object colName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            Width = 236
          end
          object colGoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            Width = 86
          end
          object colAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            HeaderAlignmentHorz = taCenter
            Width = 84
          end
          object colPartionClose: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103' '#1079#1072#1082#1088#1099#1090#1072
            DataBinding.FieldName = 'Price'
            HeaderAlignmentHorz = taCenter
            Width = 91
          end
          object colPartionGoods: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'PartionGoods'
            HeaderAlignmentHorz = taCenter
            Width = 103
          end
          object colCount: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1073#1072#1090#1086#1085#1086#1074
            DataBinding.FieldName = 'Count'
            HeaderAlignmentHorz = taCenter
            Width = 56
          end
          object colRealWeight: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1092#1072#1082#1090
            DataBinding.FieldName = 'RealWeight'
            Width = 55
          end
          object colСuterCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1082#1091#1090#1077#1088#1086#1074
            DataBinding.FieldName = #1057'uterCount'
            HeaderAlignmentHorz = taCenter
            Width = 69
          end
          object colReceiptName: TcxGridDBColumn
            Caption = #1056#1077#1094#1077#1087#1090#1091#1088#1072
            DataBinding.FieldName = 'ReceiptName'
            HeaderAlignmentHorz = taCenter
            Width = 56
          end
          object colComment: TcxGridDBColumn
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            Width = 55
          end
          object colId: TcxGridDBColumn
            DataBinding.FieldName = 'Id'
            Width = 30
          end
        end
        object cxGridLevel: TcxGridLevel
          GridView = cxGridDBTableView
        end
      end
      object cxGridChild: TcxGrid
        Left = 0
        Top = 160
        Width = 995
        Height = 148
        Align = alBottom
        TabOrder = 1
        ExplicitWidth = 1028
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
              Column = colChildAmount
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Kind = skSum
              Column = colChildAmount
            end
            item
              Kind = skSum
            end
            item
              Kind = skSum
            end>
          DataController.Summary.SummaryGroups = <>
          OptionsView.ColumnAutoWidth = True
          object colChildGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            Width = 56
          end
          object colChildGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            Width = 236
          end
          object colChildGoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            Width = 86
          end
          object colChildAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            HeaderAlignmentHorz = taCenter
            Width = 84
          end
          object colChildAmountReceipt: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1085#1072' 1 '#1082#1091#1090#1077#1088' '
            DataBinding.FieldName = 'AmountReceipt'
            HeaderAlignmentHorz = taCenter
            Width = 70
          end
          object colChildPartionGoods: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'PartionGoods'
            HeaderAlignmentHorz = taCenter
            Width = 103
          end
          object colChildComment: TcxGridDBColumn
            Caption = ' '#1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081' '
            DataBinding.FieldName = 'Comment'
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitterChild: TcxSplitter
        Left = 0
        Top = 152
        Width = 995
        Height = 8
        AlignSplitter = salBottom
        Control = cxGridChild
        ExplicitTop = 154
        ExplicitWidth = 1028
      end
    end
    object cxTabSheet2: TcxTabSheet
      Caption = #1055#1088#1086#1074#1086#1076#1082#1080
      ImageIndex = 1
      ExplicitWidth = 1028
      ExplicitHeight = 262
      object cxGridEntry: TcxGrid
        Left = 0
        Top = 0
        Width = 995
        Height = 308
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 1028
        ExplicitHeight = 262
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
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          object colDebetAccountGroupCode: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1044' '#1043#1088#1091#1087#1087#1072' '#1082#1086#1076
            DataBinding.FieldName = 'DebetAccountGroupCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            Width = 40
          end
          object colDebetAccountGroupName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1044' '#1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'DebetAccountGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            Width = 90
          end
          object colDebetAccountDirectionCode: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1044' '#1053#1072#1087#1088#1072#1074#1083' '#1082#1086#1076
            DataBinding.FieldName = 'DebetAccountDirectionCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            Width = 40
          end
          object colDebetAccountDirectionName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1044' '#1053#1072#1087#1088#1072#1074#1083
            DataBinding.FieldName = 'DebetAccountDirectionName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            Width = 90
          end
          object colDebetAccountCode: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1044' '#1082#1086#1076
            DataBinding.FieldName = 'DebetAccountCode'
            HeaderAlignmentHorz = taCenter
            Width = 40
          end
          object colDebetAccountName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1044
            DataBinding.FieldName = 'DebetAccountName'
            HeaderAlignmentHorz = taCenter
            Width = 120
          end
          object colKreditAccountGroupCode: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1050' '#1043#1088#1091#1087#1087#1072' '#1082#1086#1076
            DataBinding.FieldName = 'KreditAccountGroupCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            Width = 40
          end
          object colKreditAccountGroupName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1050' '#1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'KreditAccountGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            Width = 80
          end
          object colKreditAccountDirectionCode: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1050' '#1053#1072#1087#1088#1072#1074#1083' '#1082#1086#1076
            DataBinding.FieldName = 'KreditAccountDirectionCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            Width = 40
          end
          object colKreditAccountDirectionName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1050' '#1053#1072#1087#1088#1072#1074#1083
            DataBinding.FieldName = 'KreditAccountDirectionName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            Width = 80
          end
          object colKreditAccountCode: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1050' '#1082#1086#1076
            DataBinding.FieldName = 'KreditAccountCode'
            HeaderAlignmentHorz = taCenter
            Width = 40
          end
          object colKreditAccountName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1050
            DataBinding.FieldName = 'KreditAccountName'
            HeaderAlignmentHorz = taCenter
            Width = 120
          end
          object colByObjectCode: TcxGridDBColumn
            Caption = #1054#1073'.'#1082#1086#1076
            DataBinding.FieldName = 'ByObjectCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            Width = 40
          end
          object colByObjectName: TcxGridDBColumn
            Caption = #1054#1073#1098#1077#1082#1090' '#1085#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'ByObjectName'
            HeaderAlignmentHorz = taCenter
            Width = 80
          end
          object colGoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            Width = 80
          end
          object colGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'.'
            DataBinding.FieldName = 'GoodsCode'
            Width = 40
          end
          object colGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            Width = 80
          end
          object colGoodsKindName_comlete: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            Width = 60
          end
          object colAccountOnComplete: TcxGridDBColumn
            Caption = '***'
            DataBinding.FieldName = 'AccountOnComplete'
            HeaderAlignmentHorz = taCenter
            Width = 25
          end
          object colDebetAmount: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1076#1077#1073#1077#1090
            DataBinding.FieldName = 'DebetAmount'
            HeaderAlignmentHorz = taCenter
            Width = 70
          end
          object colKreditAmount: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1082#1088#1077#1076#1080#1090
            DataBinding.FieldName = 'KreditAmount'
            HeaderAlignmentHorz = taCenter
            Width = 70
          end
          object colPrice_comlete: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            Width = 40
          end
          object colInfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1089#1090'. '#1085#1072#1079#1085#1072#1095'.'
            DataBinding.FieldName = 'InfoMoneyCode'
            Width = 40
          end
          object colInfoMoneyName: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            Width = 55
          end
          object colInfoMoneyCode_Detail: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1089#1090'. '#1085#1072#1079#1085#1072#1095'.'#1076#1077#1090'.'
            DataBinding.FieldName = 'InfoMoneyCode_Detail'
            Width = 40
          end
          object colInfoMoneyName_Detail: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103' '#1076#1077#1090#1072#1083#1100#1085#1086
            DataBinding.FieldName = 'InfoMoneyName_Detail'
            Width = 55
          end
          object colGoodsCode_Parent: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'.'#1075#1083'.'
            DataBinding.FieldName = 'GoodsCode_Parent'
            Width = 40
          end
          object colGoodsName_Parent: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' '#1075#1083#1072#1074#1085#1099#1081
            DataBinding.FieldName = 'GoodsName_Parent'
            Width = 55
          end
          object colGoodsKindName_Parent: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' '#1075#1083'.'
            DataBinding.FieldName = 'GoodsKindName_Parent'
            Width = 50
          end
          object colObjectCostId: TcxGridDBColumn
            DataBinding.FieldName = 'ObjectCostId'
          end
          object colMIId_Parent: TcxGridDBColumn
            DataBinding.FieldName = 'MIId_Parent'
            Width = 40
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
    Left = 200
    Top = 80
  end
  object spSelectMovementItem: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_Transport'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = ChildCDS
      end>
    OutputType = otMultiDataSet
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
        DataType = ftBoolean
        ParamType = ptInput
        Value = 'False'
      end>
    Left = 97
    Top = 207
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
    Left = 184
    Top = 250
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar: TdxBar
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
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
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
    object bbGridToExcel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
    end
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = cxSplitterChild
        Properties.Strings = (
          'Top')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    Left = 377
    Top = 190
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 318
    Top = 206
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
          StoredProc = spSelectMIContainer
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      StoredProc = spInsertUpdateMI
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMI
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16464
      Params = <>
      ReportName = #1055#1088#1080#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
    end
    object dsdGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 45
    Top = 200
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 16
    Top = 200
  end
  object GuidesCar: TdsdGuides
    LookupControl = edCar
    FormName = 'TCarForm'
    PositionDataSet = 'GridDataSet'
    Params = <>
    Left = 298
    Top = 67
  end
  object GuidesPersonalDriver: TdsdGuides
    LookupControl = edPersonalDriver
    FormName = 'TPersonalForm'
    PositionDataSet = 'GridDataSet'
    Params = <>
    Left = 362
    Top = 82
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_ProductionUnion'
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
        Name = 'CarId'
        Component = GuidesCar
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'CarName'
        Component = GuidesCar
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'CarTrailerId'
        Component = GuidesCarTrailer
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'CarTrailerName'
        Component = GuidesCarTrailer
        ComponentItem = 'TextValue'
        DataType = ftInteger
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
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'PersonalDriverMoreId'
        Component = GuidesPersonalDriverMore
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'PersonalDriverMoreName'
        Component = GuidesPersonalDriverMore
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'UnitForwardingId'
        Component = GuidesUnitForwarding
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'UnitForwardingName'
        Component = GuidesUnitForwarding
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'StartRunPlan'
        Component = edStartRunPlan
        DataType = ftDateTime
        ParamType = ptOutput
        Value = 0d
      end
      item
        Name = 'EndRunPlan'
        Component = edEndRunPlan
        DataType = ftDateTime
        ParamType = ptOutput
        Value = 0d
      end
      item
        Name = 'StartRun'
        Component = edStartRun
        DataType = ftDateTime
        ParamType = ptOutput
        Value = 0d
      end
      item
        Name = 'EndRun'
        Component = edEndRun
        DataType = ftDateTime
        ParamType = ptOutput
        Value = 0d
      end
      item
        Name = 'HoursWork'
        Component = edHoursWork
        DataType = ftInteger
        ParamType = ptOutput
        Value = 0.000000000000000000
      end
      item
        Name = 'HoursAdd'
        Component = edHoursAdd
        DataType = ftInteger
        ParamType = ptOutput
        Value = 0.000000000000000000
      end
      item
        Name = 'Comment'
        Component = edComment
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end>
    Left = 152
    Top = 80
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 278
    Top = 222
    object N1: TMenuItem
      Action = actRefresh
    end
  end
  object spSelectMIContainer: TdsdStoredProc
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
    Left = 578
    Top = 216
  end
  object EntryCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 505
    Top = 240
  end
  object EntryDS: TDataSource
    DataSet = EntryCDS
    Left = 525
    Top = 192
  end
  object spInsertUpdateMI: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_TransportMaster'
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
        Name = 'inAmountPartner'
        DataType = ftFloat
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inPrice'
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inCountForPrice'
        DataType = ftFloat
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inLiveWeight'
        DataType = ftFloat
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inHeadCount'
        DataType = ftFloat
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inGoodsKindId'
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end>
    Left = 150
    Top = 192
  end
  object frxDBDataset: TfrxDBDataset
    UserName = 'frxDBDataset'
    CloseDataSource = False
    DataSet = MasterCDS
    BCDToCurrency = False
    Left = 233
    Top = 235
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ParentId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 16
    Top = 249
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 44
    Top = 250
  end
  object GuidesPersonalDriverMore: TdsdGuides
    LookupControl = edPersonalDriverMore
    FormName = 'TPersonalForm'
    PositionDataSet = 'GridDataSet'
    Params = <>
    Left = 716
    Top = 84
  end
  object GuidesCarTrailer: TdsdGuides
    LookupControl = edCarTrailer
    FormName = 'TCarForm'
    PositionDataSet = 'GridDataSet'
    Params = <>
    Left = 666
    Top = 67
  end
  object GuidesUnitForwarding: TdsdGuides
    LookupControl = edUnitForwarding
    FormName = 'TUnitForm'
    PositionDataSet = 'GridDataSet'
    Params = <>
    Left = 850
    Top = 75
  end
  object spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Transport'
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
        Name = 'inOperDatePartner'
        DataType = ftDateTime
        ParamType = ptInput
        Value = 0d
      end
      item
        Name = 'inInvNumberPartner'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inPriceWithVAT'
        DataType = ftBoolean
        ParamType = ptInput
        Value = 'False'
      end
      item
        Name = 'inVATPercent'
        DataType = ftFloat
        ParamType = ptInput
        Value = 0.000000000000000000
      end
      item
        Name = 'inChangePercent'
        DataType = ftFloat
        ParamType = ptInput
        Value = 0.000000000000000000
      end
      item
        Name = 'inFromId'
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inToId'
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inPaidKindId'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inContractId'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inCarId'
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inPersonalDriverId'
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inPersonalPackerId'
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end>
    Left = 496
    Top = 80
  end
end
