inherited Report_GoodsOnUnitRemainsMarketingForm: TReport_GoodsOnUnitRemainsMarketingForm
  Caption = #1054#1089#1090#1072#1090#1082#1080' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1102' '#1089' '#1073#1086#1085#1091#1089#1086#1084
  ClientHeight = 525
  ClientWidth = 1010
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1032
  ExplicitHeight = 581
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 64
    Width = 1010
    Height = 461
    TabOrder = 3
    ExplicitTop = 64
    ExplicitWidth = 1010
    ExplicitHeight = 461
    ClientRectBottom = 461
    ClientRectRight = 1010
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1010
      ExplicitHeight = 461
      inherited cxGrid: TcxGrid
        Width = 1010
        Height = 461
        ExplicitWidth = 1010
        ExplicitHeight = 461
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummaWithOutVAT
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummaWithVAT
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Summa
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummaSale
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
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
              Format = ',0.00'
              Kind = skSum
              Column = SummaWithOutVAT
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummaWithVAT
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Summa
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummaSale
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Amount
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
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SommaBonus
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 52
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 214
          end
          object NDS: TcxGridDBColumn
            Caption = #1053#1044#1057
            DataBinding.FieldName = 'NDS'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 42
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object MinExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1086#1089#1090#1072#1090#1082#1072
            DataBinding.FieldName = 'MinExpirationDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 118
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object PriceWithOutVAT: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1080#1093#1086#1076#1072' ('#1073#1077#1079' '#1053#1044#1057')'
            DataBinding.FieldName = 'PriceWithOutVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PriceWithVAT: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1080#1093#1086#1076#1072' ('#1089' '#1053#1044#1057')'
            DataBinding.FieldName = 'PriceWithVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1080#1093#1086#1076#1072' '#1089' '#1091#1095'. % '#1082#1086#1088#1088'. ('#1089' '#1053#1044#1057')'
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object PriceSale: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'PriceSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object SummaWithOutVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1080#1093#1086#1076#1072' ('#1073#1077#1079' '#1053#1044#1057')'
            DataBinding.FieldName = 'SummaWithOutVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object SummaWithVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1080#1093#1086#1076#1072' ('#1089' '#1053#1044#1057')'
            DataBinding.FieldName = 'SummaWithVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object Summa: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1080#1093#1086#1076#1072' '#1089' '#1091#1095'. % '#1082#1086#1088#1088'. ('#1089' '#1053#1044#1057')'
            DataBinding.FieldName = 'Summa'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 102
          end
          object SummaSale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'SummaSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PartionDescName: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103' '#1042#1080#1076
            DataBinding.FieldName = 'PartionDescName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object PartionInvNumber: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103' '#8470
            DataBinding.FieldName = 'PartionInvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PartionOperDate: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103' '#1044#1072#1090#1072
            DataBinding.FieldName = 'PartionOperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PartionPriceDescName: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103' '#1089'/'#1089' '#1042#1080#1076
            DataBinding.FieldName = 'PartionPriceDescName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object PartionPriceInvNumber: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103' '#1089'/'#1089' '#8470
            DataBinding.FieldName = 'PartionPriceInvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PartionPriceOperDate: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103' '#1089'/'#1089' '#1044#1072#1090#1072
            DataBinding.FieldName = 'PartionPriceOperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072')'
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 108
          end
          object OurJuridicalName: TcxGridDBColumn
            Caption = #1070#1088'.'#1083#1080#1094#1086' ('#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072')'
            DataBinding.FieldName = 'OurJuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object ConditionsKeepName: TcxGridDBColumn
            Caption = #1059#1089#1083#1086#1074#1080#1103' '#1093#1088#1072#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'ConditionsKeepName'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object isSP: TcxGridDBColumn
            Caption = #1057#1086#1094'. '#1087#1088#1086#1077#1082#1090
            DataBinding.FieldName = 'isSP'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
          end
          object isPromo: TcxGridDBColumn
            Caption = #1052#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1081' '#1082#1086#1085#1090#1088#1072#1082#1090
            DataBinding.FieldName = 'isPromo'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object MakerName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'MakerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 105
          end
          object GoodsGroupPromoName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1084#1072#1088#1082'. '#1082#1086#1085#1090#1088#1072#1082#1090#1072
            DataBinding.FieldName = 'GoodsGroupPromoName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 112
          end
          object PriceSip: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1089#1080#1087
            DataBinding.FieldName = 'PriceSip'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 66
          end
          object ChangePercent: TcxGridDBColumn
            Caption = '% '#1073#1086#1085#1091#1089#1072
            DataBinding.FieldName = 'ChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
          end
          object SommaBonus: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1073#1086#1085#1091#1089#1072' '#1086#1089#1090#1072#1090#1082#1072
            DataBinding.FieldName = 'SommaBonus'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1010
    Height = 38
    ExplicitWidth = 1010
    ExplicitHeight = 38
    inherited deStart: TcxDateEdit
      Left = 131
      Top = 4
      ExplicitLeft = 131
      ExplicitTop = 4
    end
    inherited deEnd: TcxDateEdit
      Left = 118
      Top = 32
      Visible = False
      ExplicitLeft = 118
      ExplicitTop = 32
    end
    inherited cxLabel1: TcxLabel
      Left = 19
      Caption = #1054#1089#1090#1072#1090#1086#1082' '#1085#1072' '#1085#1072#1095#1072#1083#1086':'
      ExplicitLeft = 19
      ExplicitWidth = 105
    end
    inherited cxLabel2: TcxLabel
      Left = 8
      Top = 33
      Visible = False
      ExplicitLeft = 8
      ExplicitTop = 33
    end
    object cxLabel4: TcxLabel
      Left = 230
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edUnit: TcxButtonEdit
      Left = 320
      Top = 4
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 201
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = GuidesUnit
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Tag'
          'Width')
      end>
  end
  inherited ActionList: TActionList
    object actOpenPartionReport: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1072#1088#1090#1080#1103#1084
      ImageIndex = 39
      FormName = 'TReport_GoodsPartionMoveForm'
      FormNameParam.Value = 'TReport_GoodsPartionMoveForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartyId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartyName'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'RemainsDate'
          Value = Null
          Component = deStart
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actRefreshPartionPrice: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1087#1072#1088#1090#1080#1080' '#1094#1077#1085#1099
      Hint = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshJuridical: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084
      Hint = #1087#1086' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshIsPartion: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      Hint = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actClearMainPromoBonus
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_GoodsOnUnitRemainsMarketingDialogForm'
      FormNameParam.Value = 'TReport_GoodsOnUnitRemainsMarketingDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41395d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actOverdueChange: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1103' '#1089#1088#1086#1082#1086#1074' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1087#1072#1088#1090#1080#1081' '#1090#1086#1074#1072#1088#1072
      Hint = #1048#1079#1084#1077#1085#1077#1085#1080#1103' '#1089#1088#1086#1082#1086#1074' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1087#1072#1088#1090#1080#1081' '#1090#1086#1074#1072#1088#1072
      ImageIndex = 42
      FormName = 'TOverdueChangeJournalForm'
      FormNameParam.Value = 'TOverdueChangeJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitID'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsCode'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actClearMainPromoBonus: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spClearMainPromoBonus
      StoredProcList = <
        item
          StoredProc = spClearMainPromoBonus
        end>
      Caption = 'actClearMainPromoBonus'
    end
    object actMainPromoBonus: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spMainPromoBonus
      StoredProcList = <
        item
          StoredProc = spMainPromoBonus
        end>
      Caption = 'actMainPromoBonus'
    end
    object actExecuteSummaDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actExecuteSummaDialog'
      FormName = 'TSummaDialogForm'
      FormNameParam.Value = 'TSummaDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Summa'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoBonus'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = #1042#1074#1077#1076#1080#1090#1077' '#1087#1088#1086#1094#1077#1085#1090' '#1073#1086#1085#1091#1089#1072
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object mactMainPromoBonus: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actExecuteSummaDialog
      ActionList = <
        item
          Action = actMainPromoBonus
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1086#1094#1077#1085#1090' '#1073#1086#1085#1091#1089#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1086#1094#1077#1085#1090' '#1073#1086#1085#1091#1089#1072
      ImageIndex = 38
    end
  end
  inherited MasterDS: TDataSource
    Left = 16
    Top = 160
  end
  inherited MasterCDS: TClientDataSet
    Left = 208
    Top = 168
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_GoodsOnUnitRemainsMarketing'
    Params = <
      item
        Name = 'inUnitId'
        Value = 41395d
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRemainsDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 216
  end
  inherited BarManager: TdxBarManager
    Left = 152
    Top = 144
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
          ItemName = 'bbExecuteDialog'
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end>
    end
    object bbGoodsPartyReport: TdxBarButton
      Action = actOpenPartionReport
      Category = 0
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = actOverdueChange
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = mactMainPromoBonus
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 424
    Top = 256
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 272
    Top = 152
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = GuidesUnit
      end
      item
        Component = deStart
      end>
    Left = 96
    Top = 144
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 392
  end
  object spClearMainPromoBonus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_ClearMainPromoBonus'
    DataSets = <>
    OutputType = otResult
    Params = <>
    PackSize = 1
    Left = 240
    Top = 256
  end
  object spMainPromoBonus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_MainPromoBonus'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPromoBonus'
        Value = 42370d
        Component = FormParams
        ComponentItem = 'PromoBonus'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 240
    Top = 328
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'PromoBonus'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 328
  end
end
