inherited CheckDeferred_SearchForm: TCheckDeferred_SearchForm
  Caption = #1055#1086#1080#1089#1082' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1086#1074' '#1074' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1093' '#1095#1077#1082#1072#1093
  ClientHeight = 405
  ClientWidth = 668
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 684
  ExplicitHeight = 444
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 668
    Height = 379
    ExplicitWidth = 668
    ExplicitHeight = 379
    ClientRectBottom = 379
    ClientRectRight = 668
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 668
      ExplicitHeight = 379
      inherited cxGrid: TcxGrid
        Left = 328
        Width = 340
        Height = 379
        Align = alRight
        TabOrder = 1
        ExplicitLeft = 328
        ExplicitWidth = 340
        ExplicitHeight = 379
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsBehavior.IncSearch = True
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
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
            Options.Editing = False
            Width = 20
          end
          object TypeChech: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1095#1077#1082#1072
            DataBinding.FieldName = 'TypeChech'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object ConfirmedKindName: TcxGridDBColumn
            Caption = #1057#1090#1072#1090'. '#1079'.'
            DataBinding.FieldName = 'ConfirmedKindName'
            HeaderHint = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072' ('#1089#1072#1081#1090')'
            Options.Editing = False
            Width = 55
          end
          object CashMember: TcxGridDBColumn
            Caption = #1052#1077#1085#1077#1076#1078#1077#1088
            DataBinding.FieldName = 'CashMember'
            Options.Editing = False
            Width = 83
          end
          object Bayer: TcxGridDBColumn
            Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'Bayer'
            Options.Editing = False
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
            Options.Editing = False
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
            Width = 94
          end
          object CashRegisterName: TcxGridDBColumn
            Caption = #1050#1072#1089#1089#1072
            DataBinding.FieldName = 'CashRegisterName'
            Options.Editing = False
            Width = 57
          end
          object InvNumber: TcxGridDBColumn
            AlternateCaption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            Options.Editing = False
            Width = 50
          end
          object NumberOrder: TcxGridDBColumn
            Caption = #8470' '#1079'.'
            DataBinding.FieldName = 'InvNumberOrder'
            HeaderHint = #8470' '#1079#1072#1082#1072#1079#1072' ('#1089#1072#1081#1090')'
            Options.Editing = False
            Width = 45
          end
          object UnitName: TcxGridDBColumn
            Caption = #1040#1087#1090#1077#1082#1072
            DataBinding.FieldName = 'UnitName'
            Options.Editing = False
            Width = 55
          end
          object BayerPhone: TcxGridDBColumn
            Caption = #1058#1077#1083'. '#1087#1086#1082'.'
            DataBinding.FieldName = 'BayerPhone'
            Options.Editing = False
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
            Options.Editing = False
            Width = 70
          end
          object DiscountExternalName: TcxGridDBColumn
            Caption = #1055#1088#1086#1077#1082#1090
            DataBinding.FieldName = 'DiscountExternalName'
            Options.Editing = False
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
            Width = 62
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
      object cxGrid1: TcxGrid
        Left = 0
        Top = 0
        Width = 320
        Height = 379
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
          OptionsBehavior.IncSearch = True
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
          Styles.Content = dmMain.cxContentStyle
          Styles.Inactive = dmMain.cxSelection
          Styles.Selection = dmMain.cxSelection
          Styles.Footer = dmMain.cxFooterStyle
          Styles.Header = dmMain.cxHeaderStyle
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
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
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
        Left = 320
        Top = 0
        Width = 8
        Height = 379
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salRight
        Control = cxGrid
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
          Name = 'PartnerMedicalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerMedicalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerMedicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerMedicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Ambulance'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Ambulance'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MedicSP'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MedicSP'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumberSP'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumberSP'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDateSP'
          Value = 'NULL'
          Component = MasterCDS
          ComponentItem = 'OperDateSP'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'SPKindId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'SPKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'SPKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'SPKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'SPTax'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'SPTax'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'ManualDiscount'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ManualDiscount'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeID'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PromoCodeID'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PromoName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeGUID'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PromoCodeGUID'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeChangePercent'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PromoCodeChangePercent'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberSPId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberSPId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'SiteDiscount'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'SiteDiscount'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionDateKindId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionDateKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionDateKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionDateKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'AmountMonth'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AmountMonth'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'LoyaltyChangeSumma'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LoyaltyChangeSumma'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'SummCard'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'SummCard'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isBanAdd'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'isBanAdd'
          DataType = ftBoolean
          MultiSelectSeparator = ','
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
    object actShowMessage: TShowMessageAction
      Category = 'DSDLib'
      MoveParams = <>
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
        #1059#1076#1072#1083#1080#1090#1100' '#1095#1077#1082' "'#1058#1072#1073#1083#1077#1090#1082#1080'" ('#1091#1082#1072#1079#1072#1090#1100' '#1087#1088#1080#1095#1080#1085#1091' '#1086#1090#1082#1072#1079#1072' - '#1090#1086#1074#1072#1088' '#1074#1077#1088#1085#1077#1090#1089#1103' ' +
        #1074' '#1082#1072#1089#1089#1091')'
      ImageIndex = 13
      Status = mtDelete
      DataSource = MasterDS
      QuestionBeforeExecute = 
        #1059#1076#1072#1083#1080#1090#1100' '#1095#1077#1082' "'#1058#1072#1073#1083#1077#1090#1082#1080'" ('#1091#1082#1072#1079#1072#1090#1100' '#1087#1088#1080#1095#1080#1085#1091' '#1086#1090#1082#1072#1079#1072' - '#1090#1086#1074#1072#1088' '#1074#1077#1088#1085#1077#1090#1089#1103' ' +
        #1074' '#1082#1072#1089#1089#1091')?'
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
    IndexFieldNames = 'Id'
    MasterFields = 'MovementId'
    MasterSource = DataSource1
    PacketRecords = 0
    Left = 8
    Top = 88
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_CheckCashDeferred'
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
          ItemName = 'dxBarButton4'
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
      Action = actDeleteCheck
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
    object dxBarButton4: TdxBarButton
      Action = actDeleteCheckSite
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
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
    IndexFieldNames = 'GoodsName'
    Params = <>
    Left = 344
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
    SearchAsFilter = False
    PropertiesCellList = <>
    Left = 544
    Top = 256
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
        Value = Null
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
    Left = 536
    Top = 112
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
    Left = 528
    Top = 168
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
        Value = Null
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
end
