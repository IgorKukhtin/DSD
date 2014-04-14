inherited Report_CheckBonusForm: TReport_CheckBonusForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1074#1077#1088#1082#1072' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1073#1086#1085#1091#1089#1086#1074'>'
  ClientHeight = 324
  ClientWidth = 1102
  ExplicitWidth = 1118
  ExplicitHeight = 359
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1102
    Height = 267
    TabOrder = 3
    ExplicitWidth = 1102
    ExplicitHeight = 267
    ClientRectBottom = 267
    ClientRectRight = 1102
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1102
      ExplicitHeight = 267
      inherited cxGrid: TcxGrid
        Width = 1102
        Height = 267
        ExplicitWidth = 1102
        ExplicitHeight = 267
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.##'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.##'
              Kind = skSum
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = clSum_CheckBonus
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = clSum_Bonus
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = clSum_BonusFact
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.##'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.##'
              Kind = skSum
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = clSum_CheckBonus
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = clSum_Bonus
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = clSum_BonusFact
            end>
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object cContract_InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075#1086#1074#1086#1088#1072
            DataBinding.FieldName = 'Contract_InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 85
          end
          object clContract_InvNumberChild: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075#1086#1074#1086#1088#1072' ('#1073#1072#1079#1086#1074#1099#1081')'
            DataBinding.FieldName = 'Contract_InvNumberChild'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 102
          end
          object clJuridicalName: TcxGridDBColumn
            Caption = #1070#1088'.'#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 155
          end
          object clContractConditionKindName: TcxGridDBColumn
            Caption = #1058#1080#1087#1099' '#1091#1089#1083#1086#1074#1080#1081' '#1076#1086#1075#1086#1074#1086#1088#1072
            DataBinding.FieldName = 'ContractConditionKindName'
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 129
          end
          object clValue: TcxGridDBColumn
            Caption = #1047#1085#1072#1095#1077#1085#1080#1077' '#1073#1086#1085#1091#1089#1072
            DataBinding.FieldName = 'Value'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 55
          end
          object clBonusKindName: TcxGridDBColumn
            AlternateCaption = #1058#1080#1087' '#1085#1072#1083#1086#1075'.'#1076#1086#1082'.'
            Caption = #1058#1080#1087' '#1073#1086#1085#1091#1089#1072
            DataBinding.FieldName = 'BonusKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 103
          end
          object clInfoMoneyName: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentVert = vaCenter
            Width = 152
          end
          object clPaidKindName: TcxGridDBColumn
            Caption = #1060#1054
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 29
          end
          object clSum_CheckBonus: TcxGridDBColumn
            Caption = #1056#1072#1089#1095#1077#1090#1085#1072#1103' '#1073#1072#1079#1072' '#1073#1086#1085#1091#1089#1072
            DataBinding.FieldName = 'Sum_CheckBonus'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 106
          end
          object clSum_Bonus: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1073#1086#1085#1091#1089#1072' ('#1088#1072#1089#1095#1077#1090')'
            DataBinding.FieldName = 'Sum_Bonus'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 94
          end
          object clSum_BonusFact: TcxGridDBColumn
            Caption = #1041#1086#1085#1091#1089' ('#1092#1072#1082#1090')'
            DataBinding.FieldName = 'Sum_BonusFact'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 78
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1102
    ExplicitWidth = 1102
    inherited deStart: TcxDateEdit
      EditValue = 41640d
      Properties.SaveTime = False
    end
    inherited deEnd: TcxDateEdit
      EditValue = 41640d
      Properties.SaveTime = False
    end
    object cxLabel4: TcxLabel
      Left = 441
      Top = 6
      Caption = #1042#1080#1076' '#1041#1086#1085#1091#1089#1072':'
      Visible = False
    end
    object edBonusKind: TcxButtonEdit
      Left = 561
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Visible = False
      Width = 200
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
    StoredProcName = 'gpReport_CheckBonus'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
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
    LookupControl = edBonusKind
    FormNameParam.Value = 'TDocumentBonusKindForm'
    FormNameParam.DataType = ftString
    FormName = 'TDocumentBonusKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 640
    Top = 65528
  end
end
