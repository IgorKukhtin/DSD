inherited TestingTuningForm: TTestingTuningForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1089#1090#1088#1086#1082#1072' '#1090#1077#1089#1090#1080#1088#1086#1074#1072#1085#1080#1103' '#1060#1072#1088#1084#1072#1094#1077#1074#1090#1086#1074'>'
  ClientHeight = 686
  ClientWidth = 1026
  AddOnFormData.AddOnFormRefresh.ParentList = 'TestingTuning'
  ExplicitWidth = 1042
  ExplicitHeight = 725
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 175
    Width = 1026
    Height = 511
    ExplicitTop = 175
    ExplicitWidth = 1026
    ExplicitHeight = 511
    ClientRectBottom = 511
    ClientRectRight = 1026
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1026
      ExplicitHeight = 487
      inherited cxGrid: TcxGrid
        Width = 576
        Height = 487
        ExplicitWidth = 576
        ExplicitHeight = 487
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.DataSource = ChildDS
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = '0.#'
              Kind = skSum
              Column = chReplies
            end
            item
              Format = '0.#'
              Kind = skSum
              Column = chCorrectAnswer
            end>
          OptionsBehavior.IncSearch = True
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.ColumnHiding = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = True
          OptionsView.CellEndEllipsis = True
          OptionsView.CellAutoHeight = True
          OptionsView.GroupSummaryLayout = gslStandard
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object chOrders: TcxGridDBColumn [0]
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'Orders'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 36
          end
          object chReplies: TcxGridDBColumn [1]
            Caption = #1050#1086#1083'-'#1074#1086' '#1086#1090#1074#1077#1090#1086#1074
            DataBinding.FieldName = 'Replies'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 62
          end
          object chCorrectAnswer: TcxGridDBColumn [2]
            Caption = #1055#1088#1072#1074'. '#1086#1090#1074#1077#1090#1086#1074
            DataBinding.FieldName = 'CorrectAnswer'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object chisMandatoryQuestion: TcxGridDBColumn [3]
            Caption = #1054#1073#1103#1079'. '#1074#1086#1087#1088#1086#1089
            DataBinding.FieldName = 'isMandatoryQuestion'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1073#1103#1079#1072#1090#1077#1083#1100#1085#1099#1081' '#1074#1086#1087#1088#1086#1089
            Options.Editing = False
            Width = 49
          end
          object chisStorekeeper: TcxGridDBColumn [4]
            Caption = #1050#1083#1072#1076'- '#1082#1091
            DataBinding.FieldName = 'isStorekeeper'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1086#1087#1088#1086#1089' '#1080' '#1082#1083#1072#1076#1086#1074#1097#1080#1082#1091
            Options.Editing = False
            Width = 46
          end
          object chQuestion: TcxGridDBColumn [5]
            Caption = #1042#1086#1087#1088#1086#1089
            DataBinding.FieldName = 'Question'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 339
          end
          inherited colIsErased: TcxGridDBColumn
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
          end
        end
      end
      object cxGridSecond: TcxGrid
        Left = 584
        Top = 0
        Width = 442
        Height = 487
        Align = alRight
        PopupMenu = PopupMenu
        TabOrder = 1
        object cxGridDBTableView2: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = SecondDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.SummaryGroups = <>
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.CellEndEllipsis = True
          OptionsView.CellAutoHeight = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object seOrders: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'Orders'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object seisCorrectAnswer: TcxGridDBColumn
            Caption = #1042#1077#1088#1085#1099#1081' '#1086#1090#1074#1077#1090
            DataBinding.FieldName = 'isCorrectAnswer'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 68
          end
          object sePossibleAnswer: TcxGridDBColumn
            Caption = #1042#1072#1088#1080#1072#1085#1090' '#1086#1090#1074#1077#1090#1072
            DataBinding.FieldName = 'PossibleAnswer'
            PropertiesClassName = 'TcxMemoProperties'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 290
          end
          object seisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isErased'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 50
          end
          object sePropertiesId: TcxGridDBColumn
            DataBinding.FieldName = 'PropertiesId'
            Visible = False
            VisibleForCustomization = False
          end
        end
        object cxGridLevel2: TcxGridLevel
          GridView = cxGridDBTableView2
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 576
        Top = 0
        Width = 8
        Height = 487
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salRight
        Control = cxGridSecond
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1026
    Height = 149
    TabOrder = 3
    ExplicitWidth = 1026
    ExplicitHeight = 149
    inherited edInvNumber: TcxTextEdit
      Left = 831
      Top = 18
      Anchors = [akTop, akRight]
      ExplicitLeft = 831
      ExplicitTop = 18
      ExplicitWidth = 74
      Width = 74
    end
    inherited cxLabel1: TcxLabel
      Left = 831
      Top = 0
      Anchors = [akTop, akRight]
      ExplicitLeft = 831
      ExplicitTop = 0
    end
    inherited edOperDate: TcxDateEdit
      Left = 915
      Top = 18
      Anchors = [akTop, akRight]
      EditValue = 42951d
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 915
      ExplicitTop = 18
      ExplicitWidth = 86
      Width = 86
    end
    inherited cxLabel2: TcxLabel
      Left = 915
      Top = 0
      Anchors = [akTop, akRight]
      ExplicitLeft = 915
      ExplicitTop = 0
    end
    inherited cxLabel15: TcxLabel
      Left = 657
      Top = 0
      Anchors = [akTop, akRight]
      ExplicitLeft = 657
      ExplicitTop = 0
    end
    inherited ceStatus: TcxButtonEdit
      Left = 657
      Top = 18
      Anchors = [akTop, akRight]
      ExplicitLeft = 657
      ExplicitTop = 18
      ExplicitWidth = 166
      ExplicitHeight = 22
      Width = 166
    end
    object edComment: TcxTextEdit
      Left = 657
      Top = 56
      Anchors = [akTop, akRight]
      Properties.ReadOnly = False
      TabOrder = 6
      Width = 249
    end
    object cxLabel7: TcxLabel
      Left = 657
      Top = 38
      Anchors = [akTop, akRight]
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object cxTopicsTestingTuning: TcxGrid
      Left = 0
      Top = 0
      Width = 638
      Height = 149
      Align = alLeft
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 8
      LookAndFeel.Kind = lfStandard
      LookAndFeel.NativeStyle = False
      LookAndFeel.SkinName = ''
      object cxGridDBTableView1: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = MasterDS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Filter.Active = True
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        Images = dmMain.SortImageList
        OptionsBehavior.IncSearch = True
        OptionsBehavior.IncSearchItem = maTopicsTestingTuningName
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Inserting = False
        OptionsSelection.InvertSelect = False
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        OptionsView.HeaderHeight = 40
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object maTopicsTestingTuningName: TcxGridDBColumn
          Caption = #1058#1077#1084#1099' '#1090#1077#1089#1090#1080#1088#1086#1074#1072#1085#1080#1103
          DataBinding.FieldName = 'TopicsTestingTuningName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 206
        end
        object maQuestion: TcxGridDBColumn
          Caption = #1042#1086#1087#1088#1086#1089#1086#1074
          DataBinding.FieldName = 'Question'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 100
        end
        object maTestQuestions: TcxGridDBColumn
          Caption = #1044#1083#1103' '#1090#1077#1089#1090#1072' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1091
          DataBinding.FieldName = 'TestQuestions'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 100
        end
        object maMandatoryQuestion: TcxGridDBColumn
          Caption = #1054#1073#1103#1079'. '#1074#1086#1087#1088'. '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1091
          DataBinding.FieldName = 'MandatoryQuestion'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1054#1073#1103#1079#1072#1090#1077#1083#1100#1085#1099#1093' '#1074#1086#1087#1088#1086#1089
          Options.Editing = False
          Width = 100
        end
        object maQuestionStorekeeper: TcxGridDBColumn
          Caption = #1042#1086#1087#1088#1086#1089#1086#1074' '#1082#1083#1072#1076#1086#1074#1097#1080#1082#1091
          DataBinding.FieldName = 'QuestionStorekeeper'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 100
        end
        object meTestQuestionsStorekeeper: TcxGridDBColumn
          Caption = #1044#1083#1103' '#1090#1077#1089#1090#1072' '#1082#1083#1072#1076#1086#1074#1097#1080#1082#1091
          DataBinding.FieldName = 'TestQuestionsStorekeeper'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 100
        end
      end
      object cxGridLevel1: TcxGridLevel
        GridView = cxGridDBTableView1
      end
    end
    object edTotalCount: TcxTextEdit
      Left = 915
      Top = 56
      Anchors = [akTop, akRight]
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 86
    end
    object cxLabel3: TcxLabel
      Left = 915
      Top = 38
      Anchors = [akTop, akRight]
      Caption = #1042#1086#1087#1088#1086#1089#1086#1074
    end
    object edQuestion: TcxTextEdit
      Left = 816
      Top = 107
      Anchors = [akTop, akRight]
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 74
    end
    object cxLabel4: TcxLabel
      Left = 816
      Top = 76
      Anchors = [akTop, akRight]
      Caption = #1042#1086#1087#1088#1086#1089#1086#1074
    end
    object edTimeTest: TcxTextEdit
      Left = 726
      Top = 107
      Anchors = [akTop, akRight]
      TabOrder = 13
      Width = 74
    end
    object cxLabel5: TcxLabel
      Left = 726
      Top = 76
      Anchors = [akTop, akRight]
      Caption = #1042#1088#1077#1084#1103' '#1085#1072
    end
    object edTimeTestStorekeeper: TcxTextEdit
      Left = 726
      Top = 127
      Anchors = [akTop, akRight]
      TabOrder = 15
      Width = 74
    end
    object edQuestionStorekeeper: TcxTextEdit
      Left = 816
      Top = 127
      Anchors = [akTop, akRight]
      Properties.ReadOnly = True
      TabOrder = 16
      Width = 74
    end
    object cxLabel6: TcxLabel
      Left = 657
      Top = 108
      Anchors = [akTop, akRight]
      Caption = #1060#1072#1088#1084#1072#1094#1077#1074#1090
    end
    object cxLabel8: TcxLabel
      Left = 657
      Top = 127
      Anchors = [akTop, akRight]
      Caption = #1050#1083#1072#1076#1086#1074#1097#1080#1082
    end
    object cxLabel9: TcxLabel
      Left = 726
      Top = 90
      Anchors = [akTop, akRight]
      Caption = #1090#1077#1089#1090' ('#1089#1077#1082')'
    end
    object cxLabel10: TcxLabel
      Left = 816
      Top = 90
      Anchors = [akTop, akRight]
      Caption = #1076#1083#1103' '#1090#1077#1089#1090#1072
    end
    object edWrongАnswersStorekeeper: TcxTextEdit
      Left = 904
      Top = 127
      Anchors = [akTop, akRight]
      TabOrder = 21
      Width = 74
    end
    object edWrongАnswers: TcxTextEdit
      Left = 904
      Top = 107
      Anchors = [akTop, akRight]
      TabOrder = 22
      Width = 74
    end
    object cxLabel11: TcxLabel
      Left = 904
      Top = 90
      Anchors = [akTop, akRight]
      Caption = #1086#1090#1074#1077#1090#1086#1074
    end
    object cxLabel12: TcxLabel
      Left = 904
      Top = 76
      Anchors = [akTop, akRight]
      Caption = #1053#1077#1087#1088#1072#1074#1077#1083#1100#1085#1099#1093
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 291
    Top = 448
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end
      item
        Component = cxGridSecond
        Properties.Strings = (
          'Width')
      end>
    Left = 184
    Top = 448
  end
  inherited ActionList: TActionList
    Left = 39
    Top = 311
    inherited actRefresh: TdsdDataSetRefresh
      AfterAction = actPreparePictures
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelectChild
        end
        item
          StoredProc = spSelectSecond
        end>
      RefreshOnTabSetChanges = True
    end
    inherited actMISetErased: TdsdUpdateErased
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1058#1077#1084#1091' '#1090#1077#1089#1090#1080#1088#1086#1074#1072#1085#1080#1103'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1058#1077#1084#1091' '#1090#1077#1089#1090#1080#1088#1086#1074#1072#1085#1080#1103'>'
    end
    inherited actMISetUnErased: TdsdUpdateErased
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1058#1077#1084#1091' '#1090#1077#1089#1090#1080#1088#1086#1074#1072#1085#1080#1103'>'
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1058#1077#1084#1091' '#1090#1077#1089#1090#1080#1088#1086#1074#1072#1085#1080#1103'>'
    end
    inherited actPrint: TdsdPrintAction
      StoredProcList = <
        item
        end>
      DataSets = <
        item
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = ChildCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1057#1087#1080#1089#1072#1085#1080#1077
      ReportNameParam.Value = #1057#1087#1080#1089#1072#1085#1080#1077
      ReportNameParam.ParamType = ptInput
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    inherited actCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
          StoredProc = spGet
        end>
    end
    object actGoodsKindChoice: TOpenChoiceForm [13]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actRefreshPrice: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actComplete: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spMovementComplete
      StoredProcList = <
        item
          StoredProc = spMovementComplete
        end
        item
          StoredProc = spGet
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1076#1085#1080#1084' '#1095#1080#1089#1083#1086#1084
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1076#1085#1080#1084' '#1095#1080#1089#1083#1086#1084
      ImageIndex = 12
    end
    object actUpdateChildDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIChild
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIChild
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectChild
        end>
      Caption = 'actUpdateChildDS'
      DataSource = ChildDS
    end
    object actUpdateSecondDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMISecond
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMISecond
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelectChild
        end
        item
          StoredProc = spSelectSecond
        end>
      Caption = 'actUpdateSecondDS'
      DataSource = SecondDS
    end
    object actMISetErasedChild: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedMIChild
      StoredProcList = <
        item
          StoredProc = spErasedMIChild
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1042#1086#1087#1088#1086#1089'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1042#1086#1087#1088#1086#1089'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = ChildDS
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080'?'
    end
    object actMISetUnErasedChild: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUnErasedMIChild
      StoredProcList = <
        item
          StoredProc = spUnErasedMIChild
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = ChildDS
    end
    object actMISetErasedSecond: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedMISecond
      StoredProcList = <
        item
          StoredProc = spErasedMISecond
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1042#1072#1088#1080#1072#1085#1090' '#1086#1090#1074#1077#1090#1072'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1042#1072#1088#1080#1072#1085#1090' '#1086#1090#1074#1077#1090#1072'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = SecondDS
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080'?'
    end
    object actMISetUnErasedSecond: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUnErasedMISecond
      StoredProcList = <
        item
          StoredProc = spUnErasedMISecond
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = SecondDS
    end
    object actExecuteDialogQuestion: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actExecuteDialogQuestion'
      FormName = 'TTextDialogForm'
      FormNameParam.Value = 'TTextDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Text'
          Value = Null
          Component = FormParams
          ComponentItem = 'Question'
          DataType = ftWideString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = Null
          Component = FormParams
          ComponentItem = 'QuestionLabel'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actAddQuestion: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actExecuteDialogQuestion
      PostDataSetBeforeExecute = False
      StoredProc = spInsertMIChild
      StoredProcList = <
        item
          StoredProc = spInsertMIChild
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectChild
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074#1086#1087#1088#1086#1089' '#1074' '#1090#1077#1084#1091
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074#1086#1087#1088#1086#1089' '#1074' '#1090#1077#1084#1091
      ImageIndex = 54
    end
    object actExecuteDialogPossibleAnswerTrue: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actExecuteDialogPossibleAnswerTrue'
      FormName = 'TTextDialogForm'
      FormNameParam.Value = 'TTextDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Text'
          Value = ''
          Component = FormParams
          ComponentItem = 'PossibleAnswer'
          DataType = ftWideString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = #1042#1074#1077#1076#1080#1090#1077' '#1085#1086#1074#1099#1081' '#1074#1086#1087#1088#1086#1089' '#1074' '#1090#1077#1084#1091
          Component = FormParams
          ComponentItem = 'PossibleAnswerLabelTrue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actInsertMISecondTrue: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actPreparePictures
      BeforeAction = actExecuteDialogPossibleAnswerTrue
      PostDataSetBeforeExecute = False
      StoredProc = spInsertMISecondTrue
      StoredProcList = <
        item
          StoredProc = spInsertMISecondTrue
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelectChild
        end
        item
          StoredProc = spSelectSecond
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1088#1072#1074#1080#1083#1100#1085#1099#1081' '#1086#1090#1074#1077#1090' '#1085#1072' '#1074#1086#1087#1088#1086#1089
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1088#1072#1074#1080#1083#1100#1085#1099#1081' '#1086#1090#1074#1077#1090' '#1085#1072' '#1074#1086#1087#1088#1086#1089
      ImageIndex = 79
    end
    object actExecuteDialogPossibleAnswerFalse: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actExecuteDialogPossibleAnswerTrue'
      FormName = 'TTextDialogForm'
      FormNameParam.Value = 'TTextDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Text'
          Value = Null
          Component = FormParams
          ComponentItem = 'PossibleAnswer'
          DataType = ftWideString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = #1042#1074#1077#1076#1080#1090#1077' '#1087#1088#1072#1074#1080#1083#1100#1085#1099#1081' '#1086#1090#1074#1077#1090' '#1085#1072' '#1074#1086#1087#1088#1086#1089
          Component = FormParams
          ComponentItem = 'PossibleAnswerLabelFalse'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actInsertMISecondFalse: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actPreparePictures
      BeforeAction = actExecuteDialogPossibleAnswerFalse
      PostDataSetBeforeExecute = False
      StoredProc = spInsertMISecondFalse
      StoredProcList = <
        item
          StoredProc = spInsertMISecondFalse
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelectChild
        end
        item
          StoredProc = spSelectSecond
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1077' '#1087#1088#1072#1074#1080#1083#1100#1085#1099#1081' '#1086#1090#1074#1077#1090' '#1085#1072' '#1074#1086#1087#1088#1086#1089
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1077' '#1087#1088#1072#1074#1080#1083#1100#1085#1099#1081' '#1086#1090#1074#1077#1090' '#1085#1072' '#1074#1086#1087#1088#1086#1089
      ImageIndex = 7
    end
    object actPreparePictures: TdsdPreparePicturesAction
      Category = 'DSDLib'
      MoveParams = <>
      DataSet = SecondCDS
      PictureFields.Strings = (
        'PossibleAnswer')
      Caption = 'actPreparePictures'
    end
    object actLoadPhotoFile: TdsdSetDefaultParams
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.Component = Photo
          FromParam.ComponentItem = 'Name'
          FromParam.DataType = ftString
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = Null
          FromParam.Component = Photo
          FromParam.ComponentItem = 'Data'
          FromParam.DataType = ftWideString
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'PossibleAnswer'
          ToParam.DataType = ftWideString
          ToParam.MultiSelectSeparator = ','
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1092#1086#1090#1086' '#1074#1072#1088#1080#1072#1085#1090#1072' '#1086#1090#1074#1077#1090#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1092#1086#1090#1086' '#1074#1072#1088#1080#1072#1085#1090#1072' '#1086#1090#1074#1077#1090#1072
      DefaultParams = <>
    end
    object actLoadPhoto: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actPreparePictures
      BeforeAction = actLoadPhotoFile
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_PossibleAnswerPhoto
      StoredProcList = <
        item
          StoredProc = spUpdate_PossibleAnswerPhoto
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelectChild
        end
        item
          StoredProc = spSelectSecond
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1092#1086#1090#1086' '#1074#1072#1088#1080#1072#1085#1090#1072' '#1086#1090#1074#1077#1090#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1092#1086#1090#1086' '#1074#1072#1088#1080#1072#1085#1090#1072' '#1086#1090#1074#1077#1090#1072
      ImageIndex = 60
    end
    object actUpdate_CorrectAnswer: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actPreparePictures
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_CorrectAnswer
      StoredProcList = <
        item
          StoredProc = spUpdate_CorrectAnswer
        end
        item
          StoredProc = spSelectSecond
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1086#1090#1074#1077#1090' '#1082#1072#1082' '#1087#1088#1072#1074#1077#1083#1100#1085#1099#1081
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1086#1090#1074#1077#1090' '#1082#1072#1082' '#1087#1088#1072#1074#1077#1083#1100#1085#1099#1081
      ImageIndex = 80
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1086#1090#1074#1077#1090' '#1082#1072#1082' '#1087#1088#1072#1074#1077#1083#1100#1085#1099#1081'?'
    end
    object actExecuteDialogPossibleAnswerUpdate: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actExecuteDialogPossibleAnswerUpdate'
      FormName = 'TTextDialogForm'
      FormNameParam.Value = 'TTextDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Text'
          Value = ''
          Component = FormParams
          ComponentItem = 'PossibleAnswer'
          DataType = ftWideString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = #1042#1074#1077#1076#1080#1090#1077' '#1087#1088#1072#1074#1080#1083#1100#1085#1099#1081' '#1086#1090#1074#1077#1090' '#1085#1072' '#1074#1086#1087#1088#1086#1089
          Component = FormParams
          ComponentItem = 'PossibleAnswerLabelUpdate'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdate_PossibleAnswer: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actPreparePictures
      BeforeAction = actExecuteDialogPossibleAnswerUpdate
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_PossibleAnswer
      StoredProcList = <
        item
          StoredProc = spUpdate_PossibleAnswer
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelectChild
        end
        item
          StoredProc = spSelectSecond
        end>
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1090#1077#1082#1089#1090#1086#1074#1099#1081' '#1074#1072#1088#1080#1072#1085#1090' '#1086#1090#1074#1077#1090#1072
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1090#1077#1082#1089#1090#1086#1074#1099#1081' '#1074#1072#1088#1080#1072#1085#1090' '#1086#1090#1074#1077#1090#1072
      ImageIndex = 43
    end
    object actInsertMISecondPhotoTrue: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actPreparePictures
      BeforeAction = actLoadPhotoFile
      PostDataSetBeforeExecute = False
      StoredProc = spInsertMISecondPhotoTrue
      StoredProcList = <
        item
          StoredProc = spInsertMISecondPhotoTrue
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelectChild
        end
        item
          StoredProc = spSelectSecond
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1088#1072#1074#1080#1083#1100#1085#1099#1081' '#1092#1086#1090#1086' '#1086#1090#1074#1077#1090' '#1085#1072' '#1074#1086#1087#1088#1086#1089
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1088#1072#1074#1080#1083#1100#1085#1099#1081' '#1092#1086#1090#1086' '#1086#1090#1074#1077#1090' '#1085#1072' '#1074#1086#1087#1088#1086#1089
      ImageIndex = 79
    end
    object actInsertMISecondPhotoFalse: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actPreparePictures
      BeforeAction = actLoadPhotoFile
      PostDataSetBeforeExecute = False
      StoredProc = spInsertMISecondPhotoFalse
      StoredProcList = <
        item
          StoredProc = spInsertMISecondPhotoFalse
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelectChild
        end
        item
          StoredProc = spSelectSecond
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1077' '#1087#1088#1072#1074#1080#1083#1100#1085#1099#1081' '#1092#1086#1090#1086' '#1086#1090#1074#1077#1090' '#1085#1072' '#1074#1086#1087#1088#1086#1089
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1077' '#1087#1088#1072#1074#1080#1083#1100#1085#1099#1081' '#1092#1086#1090#1086' '#1086#1090#1074#1077#1090' '#1085#1072' '#1074#1086#1087#1088#1086#1089
      ImageIndex = 7
    end
    object actUpdate_MandatoryQuestion: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefreshSmall
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_MandatoryQuestion
      StoredProcList = <
        item
          StoredProc = spUpdate_MandatoryQuestion
        end
        item
          StoredProc = spSelectSecond
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1054#1073#1103#1079#1072#1090#1077#1083#1100#1085#1099#1081' '#1074#1086#1087#1088#1086#1089'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1054#1073#1103#1079#1072#1090#1077#1083#1100#1085#1099#1081' '#1074#1086#1087#1088#1086#1089'"'
      ImageIndex = 80
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1054#1073#1103#1079#1072#1090#1077#1083#1100#1085#1099#1081' '#1074#1086#1087#1088#1086#1089'"?'
    end
    object actUpdate_Storekeeper: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefreshSmall
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Storekeeper
      StoredProcList = <
        item
          StoredProc = spUpdate_Storekeeper
        end
        item
          StoredProc = spSelectSecond
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1042#1086#1087#1088#1086#1089' '#1080' '#1082#1083#1072#1076#1086#1074#1097#1080#1082#1091'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1042#1086#1087#1088#1086#1089' '#1080' '#1082#1083#1072#1076#1086#1074#1097#1080#1082#1091'"'
      ImageIndex = 79
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1042#1086#1087#1088#1086#1089' '#1080' '#1082#1083#1072#1076#1086#1074#1097#1080#1082#1091'"?'
    end
    object actRefreshSmall: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actPreparePictures
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectChild
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
  end
  inherited MasterDS: TDataSource
    Top = 448
  end
  inherited MasterCDS: TClientDataSet
    Left = 96
    Top = 448
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_TestingTuning_Master'
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
        Name = 'inShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    ParamKeyField = 'Id'
    Left = 192
    Top = 256
  end
  inherited BarManager: TdxBarManager
    Left = 40
    Top = 255
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
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          BeginGroup = True
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
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarButton6'
        end
        item
          Visible = True
          ItemName = 'dxBarButton7'
        end
        item
          Visible = True
          ItemName = 'dxBarButton10'
        end
        item
          Visible = True
          ItemName = 'dxBarButton18'
        end
        item
          Visible = True
          ItemName = 'dxBarButton19'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarButton8'
        end
        item
          Visible = True
          ItemName = 'dxBarButton9'
        end
        item
          Visible = True
          ItemName = 'dxBarButton11'
        end
        item
          Visible = True
          ItemName = 'dxBarButton12'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton16'
        end
        item
          Visible = True
          ItemName = 'dxBarButton17'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton14'
        end
        item
          Visible = True
          ItemName = 'dxBarButton13'
        end
        item
          Visible = True
          ItemName = 'dxBarButton15'
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
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end>
    end
    object bbComplete: TdxBarButton
      Action = actComplete
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1081' '#1095#1077#1082
      Category = 0
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1081' '#1095#1077#1082
      Visible = ivAlways
      ImageIndex = 29
    end
    object dxBarButton2: TdxBarButton
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1087#1077#1088#1077#1084#1077#1097#1072#1085#1080#1103
      Category = 0
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1087#1077#1088#1077#1084#1077#1097#1072#1085#1080#1103
      Visible = ivAlways
      ImageIndex = 24
    end
    object dxBarButton3: TdxBarButton
      Caption = #1057#1087#1080#1089#1072#1090#1100' '#1074#1077#1089#1100' '#1086#1089#1090#1072#1090#1086#1082' '#1089' '#1090#1086#1095#1082#1080
      Category = 0
      Hint = #1057#1087#1080#1089#1072#1090#1100' '#1074#1077#1089#1100' '#1086#1089#1090#1072#1090#1086#1082' '#1089' '#1090#1086#1095#1082#1080
      Visible = ivAlways
      ImageIndex = 30
    end
    object bbUpdateSummaFund: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1089#1091#1084#1084#1091' '#1080#1079' '#1092#1086#1085#1076#1072
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1089#1091#1084#1084#1091' '#1080#1079' '#1092#1086#1085#1076#1072
      Visible = ivAlways
      ImageIndex = 75
    end
    object dxBarButton4: TdxBarButton
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1044#1074#1080#1078#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1072' '#1087#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1091'>'
      Category = 0
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1044#1074#1080#1078#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1072' '#1087#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1091'>'
      Visible = ivAlways
      ImageIndex = 67
    end
    object dxBarButton5: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1087#1088#1080#1079#1085#1072#1082#1072' "'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1086' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1086#1084'"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1087#1088#1080#1079#1085#1072#1082#1072' "'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1086' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1086#1084'"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object dxBarButton6: TdxBarButton
      Action = actMISetErasedChild
      Category = 0
    end
    object dxBarButton7: TdxBarButton
      Action = actMISetUnErasedChild
      Category = 0
    end
    object dxBarButton8: TdxBarButton
      Action = actMISetErasedSecond
      Category = 0
    end
    object dxBarButton9: TdxBarButton
      Action = actMISetUnErasedSecond
      Category = 0
    end
    object dxBarButton10: TdxBarButton
      Action = actAddQuestion
      Category = 0
    end
    object dxBarButton11: TdxBarButton
      Action = actInsertMISecondTrue
      Category = 0
    end
    object dxBarButton12: TdxBarButton
      Action = actInsertMISecondFalse
      Category = 0
    end
    object dxBarButton13: TdxBarButton
      Action = actLoadPhoto
      Category = 0
    end
    object dxBarButton14: TdxBarButton
      Action = actUpdate_CorrectAnswer
      Category = 0
    end
    object dxBarButton15: TdxBarButton
      Action = actUpdate_PossibleAnswer
      Category = 0
    end
    object dxBarButton16: TdxBarButton
      Action = actInsertMISecondPhotoTrue
      Category = 0
    end
    object dxBarButton17: TdxBarButton
      Action = actInsertMISecondPhotoFalse
      Category = 0
    end
    object dxBarButton18: TdxBarButton
      Action = actUpdate_MandatoryQuestion
      Category = 0
    end
    object dxBarButton19: TdxBarButton
      Action = actUpdate_Storekeeper
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    View = cxGridDBTableView1
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    SearchAsFilter = False
    Left = 526
    Top = 193
  end
  inherited PopupMenu: TPopupMenu
    Left = 712
    Top = 408
    object N2: TMenuItem
      Action = actMISetErased
    end
    object N3: TMenuItem
      Action = actMISetUnErased
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Question'
        Value = ''
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'QuestionLabel'
        Value = #1042#1074#1077#1076#1080#1090#1077' '#1085#1086#1074#1099#1081' '#1074#1086#1087#1088#1086#1089' '#1074' '#1090#1077#1084#1091
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PossibleAnswer'
        Value = ''
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PossibleAnswerLabelTrue'
        Value = #1042#1074#1077#1076#1080#1090#1077' '#1087#1088#1072#1074#1080#1083#1100#1085#1099#1081' '#1086#1090#1074#1077#1090' '#1085#1072' '#1074#1086#1087#1088#1086#1089
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PossibleAnswerLabelFalse'
        Value = #1042#1074#1077#1076#1080#1090#1077' '#1085#1077' '#1087#1088#1072#1074#1080#1083#1100#1085#1099#1081' '#1086#1090#1074#1077#1090' '#1085#1072' '#1074#1086#1087#1088#1086#1089
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PossibleAnswerLabelUpdate'
        Value = #1042#1074#1077#1076#1080#1090#1077' '#1074#1072#1088#1080#1072#1085#1090' '#1086#1090#1074#1077#1090#1072' '#1085#1072' '#1074#1086#1087#1088#1086#1089
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CheckID'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 440
    Top = 352
  end
  inherited StatusGuides: TdsdGuides
    Left = 736
    Top = 0
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_TestingTuning'
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 768
    Top = 0
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_TestingTuning'
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
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
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
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalCount'
        Value = ''
        Component = edTotalCount
        MultiSelectSeparator = ','
      end
      item
        Name = 'Question'
        Value = ''
        Component = edQuestion
        MultiSelectSeparator = ','
      end
      item
        Name = 'TimeTest'
        Value = ''
        Component = edTimeTest
        MultiSelectSeparator = ','
      end
      item
        Name = 'QuestionStorekeeper'
        Value = Null
        Component = edQuestionStorekeeper
        MultiSelectSeparator = ','
      end
      item
        Name = 'TimeTestStorekeeper'
        Value = Null
        Component = edTimeTestStorekeeper
        MultiSelectSeparator = ','
      end
      item
        Name = 'Wrong'#1040'nswers'
        Value = Null
        Component = edWrongАnswers
        MultiSelectSeparator = ','
      end
      item
        Name = 'Wrong'#1040'nswersStorekeeper'
        Value = Null
        Component = edWrongАnswersStorekeeper
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = ''
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 240
    Top = 256
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_TestingTuning'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTimeTest'
        Value = ''
        Component = edTimeTest
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTimeTestStorekeeper'
        Value = Null
        Component = edTimeTestStorekeeper
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWrong'#1040'nswers'
        Value = Null
        Component = edWrongАnswers
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWrong'#1040'nswersStorekeeper'
        Value = Null
        Component = edWrongАnswersStorekeeper
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = ''
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    NeedResetData = True
    ParamKeyField = 'ioId'
    Left = 186
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
      end
      item
      end
      item
      end>
    Left = 112
    Top = 256
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edOperDate
      end
      item
        Control = edTimeTest
      end
      item
        Control = edComment
      end
      item
        Control = edTimeTestStorekeeper
      end
      item
        Control = edWrongАnswers
      end
      item
        Control = edWrongАnswersStorekeeper
      end>
    Left = 368
    Top = 249
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 528
    Top = 272
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_TestingTuning_SetErased'
    Left = 614
    Top = 288
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_TestingTuning_SetUnErased'
    Left = 614
    Top = 240
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_TestingTuning'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTopicsTestingTuningId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TopicsTestingTuningId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTestQuestions'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TestQuestions'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTestQuestionsStorekeeper'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TestQuestionsStorekeeper'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 184
    Top = 368
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_TestingTuning'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = '0'
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = '0'
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 328
    Top = 272
  end
  inherited spGetTotalSumm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_TotalSummTestingTuning'
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
        Name = 'TotalCount'
        Value = Null
        Component = edTotalCount
        MultiSelectSeparator = ','
      end
      item
        Name = 'Question'
        Value = Null
        Component = edQuestion
        MultiSelectSeparator = ','
      end>
    Left = 428
    Top = 196
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefreshPrice
    ComponentList = <
      item
      end>
    Left = 424
    Top = 272
  end
  object spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_TestingTuning'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsCurrentData'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outOperDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 48
    Top = 368
  end
  object spUpdate_ConfirmedMarketing: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_TestingTuning_ConfirmedMarketing'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioisConfirmedMarketing'
        Value = ''
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'ioId'
    Left = 330
    Top = 336
  end
  object spSelectChild: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_TestingTuning_Child'
    DataSet = ChildCDS
    DataSets = <
      item
        DataSet = ChildCDS
      end>
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
        Name = 'inShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    ParamKeyField = 'Id'
    Left = 48
    Top = 512
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'ParentId'
    MasterFields = 'ID'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 168
    Top = 512
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 288
    Top = 512
  end
  object DBViewAddOnChild: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    SearchAsFilter = False
    PropertiesCellList = <>
    Left = 382
    Top = 513
  end
  object spInsertUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_TestingTuning_Child'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        Component = ChildCDS
        MultiSelectSeparator = ','
      end
      item
        Name = 'inQuestion'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Question'
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 528
    Top = 512
  end
  object spInsertUpdateMISecond: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_TestingTuning_Second'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = SecondCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCorrectAnswer'
        Value = Null
        Component = SecondCDS
        ComponentItem = 'isCorrectAnswer'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPossibleAnswer'
        Value = Null
        Component = SecondCDS
        ComponentItem = 'PossibleAnswer'
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPhoto'
        Value = Null
        Component = SecondCDS
        ComponentItem = 'isPhoto'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 528
    Top = 576
  end
  object DBViewAddOnSecond: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView2
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    SearchAsFilter = False
    PropertiesCellList = <
      item
        Column = sePossibleAnswer
        ValueColumn = sePropertiesId
        EditRepository = erPossibleAnswer
      end
      item
        Column = seisCorrectAnswer
        ValueColumn = sePropertiesId
        EditRepository = erCorrectAnswer
      end>
    Left = 382
    Top = 577
  end
  object SecondDS: TDataSource
    DataSet = SecondCDS
    Left = 288
    Top = 576
  end
  object SecondCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'ParentId'
    MasterFields = 'ID'
    MasterSource = ChildDS
    PacketRecords = 0
    Params = <>
    Left = 168
    Top = 576
  end
  object spSelectSecond: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_TestingTuning_Second'
    DataSet = SecondCDS
    DataSets = <
      item
        DataSet = SecondCDS
      end>
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
        Name = 'inShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    ParamKeyField = 'Id'
    Left = 48
    Top = 576
  end
  object spUnErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_TestingTuning_SetUnErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 694
    Top = 256
  end
  object spErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_TestingTuning_SetErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 694
    Top = 304
  end
  object spUnErasedMISecond: TdsdStoredProc
    StoredProcName = 'gpMovementItem_TestingTuning_SetUnErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = SecondCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = SecondCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 782
    Top = 232
  end
  object spErasedMISecond: TdsdStoredProc
    StoredProcName = 'gpMovementItem_TestingTuning_SetErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = SecondCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = SecondCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 782
    Top = 280
  end
  object spInsertMIChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_TestingTuning_Child'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inQuestion'
        Value = Null
        Component = FormParams
        ComponentItem = 'Question'
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 656
    Top = 511
  end
  object spInsertMISecondTrue: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_TestingTuning_Second'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCorrectAnswer'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPossibleAnswer'
        Value = Null
        Component = FormParams
        ComponentItem = 'PossibleAnswer'
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPhoto'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 656
    Top = 576
  end
  object spInsertMISecondFalse: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_TestingTuning_Second'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCorrectAnswer'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPossibleAnswer'
        Value = Null
        Component = FormParams
        ComponentItem = 'PossibleAnswer'
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPhoto'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 784
    Top = 576
  end
  object Photo: TDocument
    Left = 528
    Top = 352
  end
  object erPossibleAnswer: TcxEditRepository
    Left = 328
    Top = 400
    object erPossibleAnswerBlobItem1: TcxEditRepositoryMemoItem
    end
    object erPossibleAnswerBlobItem2: TcxEditRepositoryImageItem
      Properties.GraphicClassName = 'TJPEGImage'
      Properties.ReadOnly = True
    end
  end
  object erCorrectAnswer: TcxEditRepository
    Left = 432
    Top = 400
    object erCorrectAnswerCheckBoxItem1: TcxEditRepositoryCheckBoxItem
    end
    object erCorrectAnswerCheckBoxItem2: TcxEditRepositoryCheckBoxItem
      Properties.ReadOnly = True
    end
  end
  object spUpdate_CorrectAnswer: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_TestingTuning_CorrectAnswer'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = '0'
        Component = SecondCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 920
    Top = 344
  end
  object spUpdate_PossibleAnswer: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_TestingTuning_Second'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        Component = SecondCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCorrectAnswer'
        Value = True
        Component = SecondCDS
        ComponentItem = 'isCorrectAnswer'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPossibleAnswer'
        Value = ''
        Component = FormParams
        ComponentItem = 'PossibleAnswer'
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPhoto'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 920
    Top = 400
  end
  object spUpdate_PossibleAnswerPhoto: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_TestingTuning_Second'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = SecondCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCorrectAnswer'
        Value = Null
        Component = SecondCDS
        ComponentItem = 'isCorrectAnswer'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPossibleAnswer'
        Value = ''
        Component = FormParams
        ComponentItem = 'PossibleAnswer'
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPhoto'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 920
    Top = 456
  end
  object spInsertMISecondPhotoFalse: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_TestingTuning_Second'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCorrectAnswer'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPossibleAnswer'
        Value = ''
        Component = FormParams
        ComponentItem = 'PossibleAnswer'
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPhoto'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 920
    Top = 568
  end
  object spInsertMISecondPhotoTrue: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_TestingTuning_Second'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCorrectAnswer'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPossibleAnswer'
        Value = ''
        Component = FormParams
        ComponentItem = 'PossibleAnswer'
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPhoto'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 920
    Top = 512
  end
  object spUpdate_MandatoryQuestion: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_TestingTuning_MandatoryQuestion'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMandatoryQuestion'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isMandatoryQuestion'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 432
    Top = 464
  end
  object spUpdate_Storekeeper: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_TestingTuning_Storekeeper'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisStorekeeper'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isStorekeeper'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 520
    Top = 440
  end
end
