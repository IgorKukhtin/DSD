object SendForm: TSendForm
  Left = 0
  Top = 0
  Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
  ClientHeight = 396
  ClientWidth = 1028
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = PopupMenu
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.Params = dsdFormParams
  PixelsPerInch = 96
  TextHeight = 13
  object DataPanel: TPanel
    Left = 0
    Top = 0
    Width = 1028
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object edInvNumber: TcxTextEdit
      Left = 8
      Top = 27
      Enabled = False
      TabOrder = 0
      Width = 121
    end
    object cxLabel1: TcxLabel
      Left = 8
      Top = 5
      Caption = #1053#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    end
    object edOperDate: TcxDateEdit
      Left = 300
      Top = 27
      TabOrder = 2
      Width = 121
    end
    object cxLabel2: TcxLabel
      Left = 300
      Top = 4
      Caption = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    end
    object edFrom: TcxButtonEdit
      Left = 427
      Top = 27
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 4
      Width = 196
    end
    object edTo: TcxButtonEdit
      Left = 630
      Top = 27
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 209
    end
    object cxLabel3: TcxLabel
      Left = 427
      Top = 4
      Caption = #1054#1090' '#1082#1086#1075#1086
    end
    object cxLabel4: TcxLabel
      Left = 630
      Top = 4
      Caption = #1050#1086#1084#1091
    end
  end
  object cxPageControl1: TcxPageControl
    Left = 0
    Top = 75
    Width = 1028
    Height = 321
    Align = alClient
    TabOrder = 2
    Properties.ActivePage = cxTabSheet1
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 321
    ClientRectRight = 1028
    ClientRectTop = 24
    object cxTabSheet1: TcxTabSheet
      Caption = #1057#1090#1088#1086#1095#1085#1072#1103' '#1095#1072#1089#1090#1100
      ImageIndex = 0
      object cxGrid: TcxGrid
        Left = 0
        Top = 0
        Width = 1028
        Height = 297
        Align = alClient
        TabOrder = 0
        object cxGridDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DataSource
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
              Column = colHeadCount
            end
            item
              Kind = skSum
              Position = spFooter
              Column = colAmount
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
              Column = colHeadCount
            end
            item
              Kind = skSum
              Column = colAmount
            end
            item
              Kind = skSum
            end
            item
              Kind = skSum
            end>
          DataController.Summary.SummaryGroups = <>
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsView.ColumnAutoWidth = True
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
          object colGoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object colPartionGoods: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'PartionGoods'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object colAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colHeadCount: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1075#1086#1083#1086#1074
            DataBinding.FieldName = 'HeadCount'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
          end
          object colAssetName: TcxGridDBColumn
            Caption = #1054#1089#1085'.'#1089#1088#1077#1076#1089#1090#1074#1072
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
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
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object cxGridEntry: TcxGrid
        Left = 0
        Top = 0
        Width = 1028
        Height = 297
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
          object colObjectCostId: TcxGridDBColumn
            DataBinding.FieldName = 'ObjectCostId'
          end
        end
        object cxGridEntryLevel: TcxGridLevel
          GridView = cxGridEntryDBTableView
        end
      end
    end
  end
  object cxLabel15: TcxLabel
    Left = 141
    Top = 5
    Caption = #1057#1090#1072#1090#1091#1089
  end
  object ceStatus: TcxButtonEdit
    Left = 142
    Top = 27
    Properties.Buttons = <
      item
        Action = CompleteMovement
        Default = True
        Kind = bkGlyph
      end
      item
        Action = UnCompleteMovement
        Kind = bkGlyph
      end
      item
        Action = DeleteMovement
        Kind = bkGlyph
      end>
    Properties.Images = dmMain.ImageList
    TabOrder = 3
    Width = 152
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
      end>
    Left = 40
    Top = 88
  end
  object spSelectMovementItem: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Send'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inShowAll'
        Value = False
        Component = BooleanStoredProcAction
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = ShowErasedAction
        DataType = ftBoolean
        ParamType = ptInput
      end>
    Left = 88
    Top = 280
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
    Left = 72
    Top = 96
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 104
    Top = 80
    object EntryToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      Grid = cxGridEntry
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object SetErased: TdsdUpdateErased
      Category = 'DSDLib'
      StoredProc = spErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080'?'
    end
    object SetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      StoredProc = spUnErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spUnErasedMIMaster
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
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
    object ShowErasedAction: TBooleanStoredProcAction
      Category = 'DSDLib'
      StoredProc = spSelectMovementItem
      StoredProcList = <
        item
          StoredProc = spSelectMovementItem
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 65
      ImageIndexFalse = 64
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
    object actUpdateMasterDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      StoredProcList = <>
      Caption = 'actUpdateMasterDS'
    end
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
      RefreshOnTabSetChanges = False
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
    object UnCompleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      StoredProc = StatusStoredProc
      StoredProcList = <
        item
          StoredProc = StatusStoredProc
        end>
      Caption = 'UnCompleteMovement'
      ImageIndex = 11
      Status = mtUncomplete
      Guides = StatusGuides
    end
    object CompleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      StoredProc = StatusStoredProc
      StoredProcList = <
        item
          StoredProc = StatusStoredProc
        end>
      Caption = 'CompleteMovement'
      ImageIndex = 12
      Status = mtComplete
      Guides = StatusGuides
    end
    object DeleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      StoredProc = StatusStoredProc
      StoredProcList = <
        item
          StoredProc = StatusStoredProc
        end>
      Caption = 'DeleteMovement'
      ImageIndex = 13
      Status = mtDelete
      Guides = StatusGuides
    end
    object MultiAction: TMultiAction
      Category = 'DSDLib'
      ActionList = <
        item
          Action = dsdFormClose
        end
        item
          Action = actNewDocument
        end>
      Caption = #1053#1086#1074#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1053#1086#1074#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 29
      ShortCut = 16462
    end
    object actNewDocument: TdsdInsertUpdateAction
      Category = 'DSDLib'
      Caption = #1053#1086#1074#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1053#1086#1074#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
      FormName = 'TSendForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          ParamType = ptInput
        end>
      isShowModal = False
    end
    object dsdFormClose: TdsdFormClose
      Category = 'DSDLib'
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 32
    Top = 208
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 80
    Top = 144
  end
  object dsdGuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormName = 'TObject_StoragePlace'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = dsdGuidesFrom
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdGuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 376
    Top = 56
  end
  object dsdGuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormName = 'TObject_StoragePlace'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = dsdGuidesTo
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdGuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 448
    Top = 56
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Send'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
      end
      item
        Name = 'FromId'
        Value = ''
        Component = dsdGuidesFrom
        ComponentItem = 'Key'
      end
      item
        Name = 'FromName'
        Value = ''
        Component = dsdGuidesFrom
        ComponentItem = 'TextValue'
      end
      item
        Name = 'ToId'
        Value = ''
        Component = dsdGuidesTo
        ComponentItem = 'Key'
      end
      item
        Name = 'ToName'
        Value = ''
        Component = dsdGuidesTo
        ComponentItem = 'TextValue'
      end>
    Left = 136
    Top = 72
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 384
    Top = 312
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
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 560
    Top = 216
  end
  object EntryCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 424
    Top = 176
  end
  object EntryDS: TDataSource
    DataSet = EntryCDS
    Left = 440
    Top = 224
  end
  object spInsertUpdateMovementItem: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Send'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Component = ClientDataSet
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end
      item
        Name = 'inAmount'
        Component = ClientDataSet
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inCount'
        Value = '0'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inHeadCount'
        Value = '0'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPartionGoods'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGoodsKindId'
        Component = ClientDataSet
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
      end
      item
        Name = 'inAssetId'
        Value = '0'
        ParamType = ptInput
      end>
    Left = 520
    Top = 120
  end
  object frxDBDataset: TfrxDBDataset
    UserName = 'frxDBDataset'
    CloseDataSource = False
    DataSet = ClientDataSet
    BCDToCurrency = False
    Left = 232
    Top = 216
  end
  object RefreshAddOn: TRefreshAddOn
    FormName = 'SendJournalForm'
    DataSet = 'ClientDataSet'
    KeyField = 'Id'
    RefreshAction = 'actRefresh'
    FormParams = 'FormParams'
    Left = 552
    Top = 56
  end
  object StatusGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceStatus
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 144
    Top = 32
  end
  object StatusStoredProc: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Send'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'StatusCode'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 176
    Top = 32
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
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
    Left = 22
    Top = 231
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
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'bbBooleanAction'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStatic'
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
      Action = EntryToExcel
      Category = 0
    end
    object bbInsertUpdateMovement: TdxBarButton
      Action = actInsertUpdateMovement
      Category = 0
    end
    object bbErased: TdxBarButton
      Action = SetErased
      Category = 0
    end
    object bbUnErased: TdxBarButton
      Action = SetUnErased
      Category = 0
    end
    object bbShowErased: TdxBarButton
      Action = ShowErasedAction
      Category = 0
    end
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Value = Null
    IdParam.Component = dsdFormParams
    IdParam.ComponentItem = 'Id'
    GuidesList = <
      item
        Guides = dsdGuidesFrom
      end
      item
        Guides = dsdGuidesTo
      end>
    ActionItemList = <
      item
        Action = actInsertUpdateMovement
      end>
    Left = 272
    Top = 80
  end
  object HeaderSaver: THeaderSaver
    IdParam.Value = Null
    IdParam.ComponentItem = 'Id'
    StoredProc = spInsertUpdateMovement
    ControlList = <
      item
        Control = edOperDate
      end
      item
        Control = ceStatus
      end
      item
        Control = edFrom
      end
      item
        Control = edTo
      end>
    GetStoredProc = spGet
    Left = 320
    Top = 89
  end
  object spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Send'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inInvNumber'
        Value = ''
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
        Name = 'inFromId'
        Value = ''
        Component = dsdGuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inToId'
        Value = ''
        Component = dsdGuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 274
    Top = 120
  end
  object spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpSetErased_MovementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'outIsErased'
        Value = Null
        ComponentItem = 'isErased'
        DataType = ftBoolean
      end>
    Left = 174
    Top = 168
  end
  object spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpSetUnErased_MovementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'outIsErased'
        Value = Null
        ComponentItem = 'isErased'
        DataType = ftBoolean
      end>
    Left = 238
    Top = 184
  end
end
