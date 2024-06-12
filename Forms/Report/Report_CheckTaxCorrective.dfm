inherited Report_CheckTaxCorrectiveForm: TReport_CheckTaxCorrectiveForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1074#1077#1088#1082#1072' '#1056#1077#1077#1089#1090#1088#1072' '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1086#1082' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1099#1084' '#1085#1072#1082#1083#1072#1076#1085#1099#1084'>'
  ClientHeight = 319
  ClientWidth = 990
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1006
  ExplicitHeight = 358
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 990
    Height = 262
    TabOrder = 3
    ExplicitWidth = 990
    ExplicitHeight = 262
    ClientRectBottom = 262
    ClientRectRight = 990
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 990
      ExplicitHeight = 262
      inherited cxGrid: TcxGrid
        Width = 990
        Height = 262
        ExplicitWidth = 990
        ExplicitHeight = 262
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_ReturnIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_TaxCorrective
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_ReturnIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_TaxCorrective
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_Diff
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_ReturnIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_TaxCorrective
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_ReturnIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_TaxCorrective
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_Diff
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = InvNumber_ReturnIn
            end>
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object InvNumber_ReturnIn: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'#1074#1086#1079#1074#1088'.'
            DataBinding.FieldName = 'InvNumber_ReturnIn'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 70
          end
          object InvNumberPartner_ReturnIn: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1087#1086#1082'. '#1074#1086#1079#1074#1088'.'
            DataBinding.FieldName = 'InvNumberPartner_ReturnIn'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object InvNumber_TaxCorrective: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1082#1086#1088#1088'.'
            DataBinding.FieldName = 'InvNumber_TaxCorrective'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object InvNumberPartner_TaxCorrective: TcxGridDBColumn
            Caption = #8470' '#1082#1086#1088#1088'.'
            DataBinding.FieldName = 'InvNumberPartner_TaxCorrective'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object OperDate_TaxCorrective: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1082#1086#1088#1088'.'
            DataBinding.FieldName = 'OperDate_TaxCorrective'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object InvNumber_Tax: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'InvNumber_Tax'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object InvNumberPartner_Tax: TcxGridDBColumn
            Caption = #8470' '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'InvNumberPartner_Tax'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object OperDate_Tax: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'OperDate_Tax'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object isDate_Err: TcxGridDBColumn
            Caption = #1054#1096#1080#1073#1082#1072' '#1076#1072#1090#1099
            DataBinding.FieldName = 'isDate_Err'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1096#1080#1073#1082#1072' '#1044#1072#1090#1072' '#1082#1086#1088'. '#1088#1072#1085#1100#1096#1077' '#1076#1072#1090#1099' '#1085#1072#1083#1086#1075'.'
            Width = 30
          end
          object DocumentTaxKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1085#1072#1083#1086#1075'.'#1076#1086#1082'.'
            DataBinding.FieldName = 'DocumentTaxKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object BranchName: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'BranchName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object ContractName: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object ContractTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractTagName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PartnerCode: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072')'
            DataBinding.FieldName = 'PartnerCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object PartnerName: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
            DataBinding.FieldName = 'PartnerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object FromCode: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1086#1090' '#1082#1086#1075#1086')'
            DataBinding.FieldName = 'FromCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 35
          end
          object FromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 58
          end
          object ToCode: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1082#1086#1084#1091')'
            DataBinding.FieldName = 'ToCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 35
          end
          object ToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 60
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'.'
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 39
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 61
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 45
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 45
          end
          object Amount_ReturnIn: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1074#1086#1079#1074#1088#1072#1090')'
            DataBinding.FieldName = 'Amount_ReturnIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 60
          end
          object Amount_TaxCorrective: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'Amount_TaxCorrective'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 53
          end
          object Summ_ReturnIn: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' ('#1074#1086#1079#1074#1088#1072#1090')'
            DataBinding.FieldName = 'Summ_ReturnIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object Summ_TaxCorrective: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'Summ_TaxCorrective'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object Summ_Diff: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' ('#1088#1072#1079#1085#1080#1094#1072')'
            DataBinding.FieldName = 'Summ_Diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object Difference: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072
            DataBinding.FieldName = 'Difference'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 42
          end
          object InfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object InfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 990
    ExplicitWidth = 990
    inherited deStart: TcxDateEdit
      EditValue = 45292d
      Properties.SaveTime = False
    end
    inherited deEnd: TcxDateEdit
      EditValue = 45292d
      Properties.SaveTime = False
    end
    object cxLabel3: TcxLabel
      Left = 432
      Top = 6
      Caption = #1058#1080#1087' '#1085#1072#1083#1086#1075#1086#1074#1086#1075#1086' '#1076#1086#1082'.:'
    end
    object edDocumentTaxKind: TcxButtonEdit
      Left = 549
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 340
    end
  end
  inherited ActionList: TActionList
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_CheckTaxDialogForm'
      FormNameParam.Value = 'TReport_CheckTaxDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'DocumentTaxKindId'
          Value = ''
          Component = DocumentTaxKindGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'DocumentTaxKindName'
          Value = ''
          Component = DocumentTaxKindGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 72
    Top = 208
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_CheckTaxCorrective'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDocumentTaxKindID'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 208
  end
  inherited BarManager: TdxBarManager
    Left = 144
    Top = 208
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 368
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 80
    Top = 144
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = DocumentTaxKindGuides
      end>
    Left = 184
    Top = 136
  end
  object DocumentTaxKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edDocumentTaxKind
    FormNameParam.Value = 'TDocumentTaxKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TDocumentTaxKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 640
    Top = 65528
  end
end
