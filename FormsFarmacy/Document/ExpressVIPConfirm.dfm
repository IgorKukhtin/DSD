inherited ExpressVIPConfirmForm: TExpressVIPConfirmForm
  Caption = #1069#1082#1089#1087#1088#1077#1089#1089' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' '#1095#1077#1082#1086#1074
  ClientHeight = 459
  ClientWidth = 736
  ExplicitWidth = 752
  ExplicitHeight = 498
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 736
    Height = 433
    ExplicitWidth = 736
    ExplicitHeight = 433
    ClientRectBottom = 433
    ClientRectRight = 736
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 736
      ExplicitHeight = 433
      inherited cxGrid: TcxGrid
        Width = 273
        Height = 433
        Align = alLeft
        ExplicitWidth = 273
        ExplicitHeight = 433
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
          object TypeChech: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1095#1077#1082#1072
            DataBinding.FieldName = 'TypeChech'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
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
          object SummCard: TcxGridDBColumn
            Caption = #1055#1088#1077#1076#1086#1087#1083#1072#1090#1072' ('#1092#1072#1082#1090#1080#1095#1077#1089#1082#1072#1103')'
            DataBinding.FieldName = 'SummCard'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Styles.Content = dmMain.cxHeaderL3Style
            Width = 99
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
            Options.Editing = False
            Width = 70
          end
          object MedicSP: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1074#1088#1072#1095#1072
            DataBinding.FieldName = 'MedicSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
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
            Options.Editing = False
            Width = 62
          end
          object DateDelay: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1087#1088#1086#1089#1088#1086#1095#1082#1080
            DataBinding.FieldName = 'DateDelay'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object CommentCustomer: TcxGridDBColumn
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081' '#1082#1083#1080#1077#1085#1090#1072
            DataBinding.FieldName = 'CommentCustomer'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object isAutoVIPforSales: TcxGridDBColumn
            Caption = #1042#1048#1055' '#1095#1077#1082' '#1076#1083#1103' '#1087#1088#1086#1076#1072#1078
            DataBinding.FieldName = 'isAutoVIPforSales'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object isMobileApplication: TcxGridDBColumn
            Caption = #1052#1086#1073'. '#1087#1088#1080#1083'.'
            DataBinding.FieldName = 'isMobileApplication'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 53
          end
          object Color_CalcDoc: TcxGridDBColumn
            DataBinding.FieldName = 'Color_CalcDoc'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 273
        Top = 0
        Width = 8
        Height = 433
        HotZoneClassName = 'TcxMediaPlayer8Style'
        Control = cxGrid
      end
      object Panel1: TPanel
        Left = 281
        Top = 0
        Width = 455
        Height = 433
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel1'
        TabOrder = 2
        object cxGrid1: TcxGrid
          Left = 0
          Top = 0
          Width = 455
          Height = 433
          Align = alClient
          PopupMenu = PopupMenu
          TabOrder = 0
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
            object AccommodationName: TcxGridDBColumn
              Caption = #1050#1086#1076' '#1087#1088#1080#1074'.'
              DataBinding.FieldName = 'AccommodationName'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 87
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
      end
    end
  end
  inherited ActionList: TActionList
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
    object actSetConfirmedKind_Complete: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProc = spConfirmedKind_Complete
      StoredProcList = <
        item
          StoredProc = spConfirmedKind_Complete
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072' - <'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085'>'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072' - <'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085'>'
      ImageIndex = 77
    end
    object actSetConfirmedKind_UnComplete: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProc = spConfirmedKind_UnComplete
      StoredProcList = <
        item
          StoredProc = spConfirmedKind_UnComplete
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072' - <'#1053#1077' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085'>'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072' - <'#1053#1077' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085'>'
      ImageIndex = 58
    end
    object actShowMessage: TShowMessageAction
      Category = 'DSDLib'
      MoveParams = <>
    end
    object actUpdateMovementItemAmount: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMovementItemAmount
      StoredProcList = <
        item
          StoredProc = spUpdateMovementItemAmount
        end>
      Caption = 'actUpdateMovementItemAmount'
      DataSource = DataSource1
    end
    object actUpdateOperDate: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateOperDate
      StoredProcList = <
        item
          StoredProc = spUpdateOperDate
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1085#1072' '#1095#1077#1082' '#1090#1077#1082#1091#1097#1091#1102' '#1076#1072#1090#1091
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1085#1072' '#1095#1077#1082' '#1090#1077#1082#1091#1097#1091#1102' '#1076#1072#1090#1091
      ImageIndex = 35
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1085#1072' '#1095#1077#1082' '#1090#1077#1082#1091#1097#1091#1102' '#1076#1072#1090#1091'?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086'.'
    end
    object actDeleteCheckSite: TdsdChangeMovementStatus
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actChoiceCancelReason
      StoredProc = spMovementSetErasedSite
      StoredProcList = <
        item
          StoredProc = spMovementSetErasedSite
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1095#1077#1082
      Hint = 
        #1059#1076#1072#1083#1080#1090#1100' '#1095#1077#1082' '#1089' '#1089#1072#1081#1090#1072' "'#1053#1077' '#1073#1086#1083#1077#1081'" '#1080' "'#1058#1072#1073#1083#1077#1090#1082#1080'" ('#1091#1082#1072#1079#1072#1090#1100' '#1087#1088#1080#1095#1080#1085#1091' '#1086#1090#1082 +
        #1072#1079#1072' - '#1090#1086#1074#1072#1088' '#1074#1077#1088#1085#1077#1090#1089#1103' '#1074' '#1082#1072#1089#1089#1091')'
      ImageIndex = 13
      Status = mtDelete
      DataSource = MasterDS
      QuestionBeforeExecute = 
        #1059#1076#1072#1083#1080#1090#1100' '#1095#1077#1082' '#1089' '#1089#1072#1081#1090#1072' "'#1053#1077' '#1073#1086#1083#1077#1081'" '#1080' "'#1058#1072#1073#1083#1077#1090#1082#1080'" ('#1091#1082#1072#1079#1072#1090#1100' '#1087#1088#1080#1095#1080#1085#1091' '#1086#1090#1082 +
        #1072#1079#1072' - '#1090#1086#1074#1072#1088' '#1074#1077#1088#1085#1077#1090#1089#1103' '#1074' '#1082#1072#1089#1089#1091')?'
    end
    object actChoiceCancelReason: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceCancelReason'
      FormName = 'TCancelReasonForm'
      FormNameParam.Value = 'TCancelReasonForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'CancelReasonId'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
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
    StoredProcName = 'gpSelect_Movement_CheckExpressVIPConfirm'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = ClientDataSet1
      end>
    OutputType = otMultiDataSet
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
          ItemName = 'bbConfirmedKind_Complete'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbConfirmedKind_UnComplete'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateOperDate'
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
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
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
      Action = actSetConfirmedKind_Complete
      Caption = 'VIP '#1095#1077#1082'  - <'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085'>'
      Category = 0
    end
    object bbConfirmedKind_UnComplete: TdxBarButton
      Action = actSetConfirmedKind_UnComplete
      Caption = 'VIP '#1095#1077#1082'  - <'#1053#1077' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085'>'
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1082' '#1076#1083#1103' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103
      Category = 0
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1082' '#1076#1083#1103' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103
      Visible = ivAlways
      ImageIndex = 1
    end
    object dxBarButton5: TdxBarButton
      Caption = #1056#1072#1079#1073#1080#1077#1085#1080#1077' '#1095#1077#1082#1072' '#1087#1086' '#1085#1072#1083#1080#1095#1080#1102
      Category = 0
      Hint = #1056#1072#1079#1073#1080#1077#1085#1080#1077' '#1095#1077#1082#1072' '#1087#1086' '#1085#1072#1083#1080#1095#1080#1102
      Visible = ivAlways
      ImageIndex = 27
    end
    object bbUpdateOperDate: TdxBarButton
      Action = actUpdateOperDate
      Category = 0
    end
    object dxBarButton6: TdxBarButton
      Action = actDeleteCheckSite
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1095#1077#1082' '#1089' '#1089#1072#1081#1090#1072' "'#1058#1072#1073#1083#1077#1090#1082#1080'"'
    end
    object bbUpdateNotMCS: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077' '#1076#1083#1103' '#1053#1058#1047'"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077' '#1076#1083#1103' '#1053#1058#1047'"'
      Visible = ivAlways
      ImageIndex = 36
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
    ChartList = <>
    ColorRuleList = <
      item
        BackGroundValueColumn = Color_Calc
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 560
    Top = 296
  end
  object spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_CheckVIP'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = 0
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCancelReasonId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 208
    Top = 128
  end
  object spConfirmedKind_Complete: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check_ConfirmedKind'
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
        Name = 'inDescName'
        Value = 'zc_Enum_ConfirmedKind_Complete'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ouConfirmedKindName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ConfirmedKindName'
        DataType = ftString
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
    Left = 552
    Top = 96
  end
  object spConfirmedKind_UnComplete: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check_ConfirmedKind'
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
        Name = 'inDescName'
        Value = 'zc_Enum_ConfirmedKind_UnComplete'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ouConfirmedKindName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ConfirmedKindName'
        DataType = ftString
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
    Left = 552
    Top = 168
  end
  object spUpdateMovementItemAmount: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_Check_Amount'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ClientDataSet1
        ComponentItem = 'ID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = ClientDataSet1
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ClientDataSet1
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = ClientDataSet1
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outTotalSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TotalSumm'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inId'
    Left = 408
    Top = 112
  end
  object spSmashCheck: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_SmashCheck'
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
      end>
    PackSize = 1
    Left = 312
    Top = 176
  end
  object spUpdateOperDate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check_CurrentOperDate'
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
      end>
    PackSize = 1
    Left = 560
    Top = 232
  end
  object spMovementSetErasedSite: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_CheckVIP'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
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
        Name = 'inCancelReasonId'
        Value = 0
        Component = FormParams
        ComponentItem = 'CancelReasonId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 208
    Top = 200
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'CancelReasonId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 40
    Top = 144
  end
  object spPUSHSetErased: TdsdStoredProc
    StoredProcName = 'gpSelect_ShowPUSH_ChechSetErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementID'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outShowMessage'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPUSHType'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outText'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 314
    Top = 256
  end
  object SPUpdate_NotMCS: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check__NotMCS'
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
        Name = 'inisNotMCS'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isNotMCS'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisNotMCS'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isNotMCS'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 306
    Top = 312
  end
end
