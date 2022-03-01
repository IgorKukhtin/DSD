object ReportCollation_ObjectForm: TReportCollation_ObjectForm
  Left = 0
  Top = 0
  Caption = #1040#1082#1090#1099' '#1089#1074#1077#1088#1086#1082
  ClientHeight = 537
  ClientWidth = 1128
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 91
    Width = 1128
    Height = 301
    Align = alClient
    TabOrder = 0
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    LookAndFeel.SkinName = ''
    ExplicitHeight = 446
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = 'C'#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = idBarCode
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsBehavior.IncSearchItem = EndDate
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.FooterAutoHeight = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object isDiff: TcxGridDBColumn
        Caption = #1054#1096#1080#1073#1082#1072' '#1074' '#1087#1077#1088#1080#1086#1076#1077
        DataBinding.FieldName = 'isDiff'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 64
      end
      object ObjectCode: TcxGridDBColumn
        Caption = #8470' '#1087'/'#1087
        DataBinding.FieldName = 'ObjectCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object StartDate: TcxGridDBColumn
        Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072
        DataBinding.FieldName = 'StartDate'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 61
      end
      object EndDate: TcxGridDBColumn
        Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072
        DataBinding.FieldName = 'EndDate'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 72
      end
      object idBarCode: TcxGridDBColumn
        Caption = #1064#1090#1088#1080#1093#1082#1086#1076
        DataBinding.FieldName = 'idBarCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 102
      end
      object isBuh: TcxGridDBColumn
        Caption = #1057#1076#1072#1083#1080' '#1074' '#1073#1091#1093#1075#1072#1083#1090#1077#1088#1080#1102
        DataBinding.FieldName = 'isBuh'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 85
      end
      object JuridicalName: TcxGridDBColumn
        Caption = #1070#1088'.'#1083#1080#1094#1086
        DataBinding.FieldName = 'JuridicalName'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 195
      end
      object OKPO: TcxGridDBColumn
        Caption = #1054#1050#1055#1054
        DataBinding.FieldName = 'OKPO'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 60
      end
      object AreaContractName: TcxGridDBColumn
        Caption = #1056#1077#1075#1080#1086#1085' ('#1076#1086#1075#1086#1074#1086#1088')'
        DataBinding.FieldName = 'AreaContractName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object BranchName: TcxGridDBColumn
        Caption = #1060#1080#1083#1080#1072#1083' ('#1044#1086#1075#1086#1074#1086#1088' - '#1056#1077#1075#1080#1086#1085')'
        DataBinding.FieldName = 'BranchName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 120
      end
      object BranchName_personal: TcxGridDBColumn
        Caption = #1060#1080#1083#1080#1072#1083' ('#1086#1090#1074#1077#1090#1089#1090#1074'. '#1079#1072' '#1076#1086#1075'.)'
        DataBinding.FieldName = 'BranchName_personal'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1060#1080#1083#1080#1072#1083' ('#1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' '#1079#1072' '#1076#1086#1075#1086#1074#1086#1088')'
        Options.Editing = False
        Width = 82
      end
      object PersonalName: TcxGridDBColumn
        Caption = #1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' '#1079#1072' '#1076#1086#1075'.'
        DataBinding.FieldName = 'PersonalName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' '#1079#1072' '#1076#1086#1075#1086#1074#1086#1088')'
        Options.Editing = False
        Width = 113
      end
      object UnitName: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1086#1090#1074#1077#1090#1089#1090#1074'. '#1079#1072' '#1076#1086#1075'.)'
        DataBinding.FieldName = 'UnitName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' '#1079#1072' '#1076#1086#1075#1086#1074#1086#1088')'
        Options.Editing = False
        Width = 98
      end
      object PositionName: TcxGridDBColumn
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1086#1090#1074#1077#1090#1089#1090#1074'. '#1079#1072' '#1076#1086#1075'.)'
        DataBinding.FieldName = 'PositionName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' '#1079#1072' '#1076#1086#1075#1086#1074#1086#1088')'
        Options.Editing = False
        Width = 89
      end
      object PartnerName: TcxGridDBColumn
        Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
        DataBinding.FieldName = 'PartnerName'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 134
      end
      object ContractName: TcxGridDBColumn
        Caption = #8470' '#1044#1086#1075#1086#1074#1086#1088#1072
        DataBinding.FieldName = 'ContractName'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 66
      end
      object PaidKindName: TcxGridDBColumn
        Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
        DataBinding.FieldName = 'PaidKindName'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 55
      end
      object InfoMoneyName: TcxGridDBColumn
        Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'InfoMoneyName'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        Options.Editing = False
        Width = 140
      end
      object StartRemainsRep: TcxGridDBColumn
        Caption = #1085#1072#1095'. '#1089#1072#1083#1100#1076#1086' ('#1054#1090#1095#1077#1090')'
        DataBinding.FieldName = 'StartRemainsRep'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1085#1072#1095'. '#1089#1072#1083#1100#1076#1086' '#1087#1086' '#1076#1072#1085#1085#1099#1084' '#1054#1090#1095#1077#1090#1072
        Options.Editing = False
        Width = 70
      end
      object EndRemainsRep: TcxGridDBColumn
        Caption = #1082#1086#1085'. '#1089#1072#1083#1100#1076#1086' ('#1054#1090#1095#1077#1090')'
        DataBinding.FieldName = 'EndRemainsRep'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1082#1086#1085'. '#1089#1072#1083#1100#1076#1086' '#1087#1086' '#1076#1072#1085#1085#1099#1084' '#1054#1090#1095#1077#1090#1072
        Options.Editing = False
        Width = 70
      end
      object StartRemains: TcxGridDBColumn
        Caption = #1085#1072#1095'. '#1089#1072#1083#1100#1076#1086' ('#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090')'
        DataBinding.FieldName = 'StartRemains'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = ' '#9#1085#1072#1095'. '#1089#1072#1083#1100#1076#1086' '#1087#1086' '#1076#1072#1085#1085#1099#1084' '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
        Width = 70
      end
      object EndRemains: TcxGridDBColumn
        Caption = #1082#1086#1085'. '#1089#1072#1083#1100#1076#1086' ('#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090')'
        DataBinding.FieldName = 'EndRemains'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1082#1086#1085'. '#1089#1072#1083#1100#1076#1086' '#1087#1086' '#1076#1072#1085#1085#1099#1084' '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
        Width = 70
      end
      object StartRemainsCalc: TcxGridDBColumn
        Caption = #1085#1072#1095'. '#1089#1072#1083#1100#1076#1086' ('#1088#1072#1089#1095'.)'
        DataBinding.FieldName = 'StartRemainsCalc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1085#1072#1095'. '#1089#1072#1083#1100#1076#1086' '#1087#1086' '#1076#1072#1085#1085#1099#1084' '#1054#1090#1095#1077#1090#1072' ('#1088#1072#1089#1095#1077#1090')'
        Options.Editing = False
        Width = 70
      end
      object EndRemainsCalc: TcxGridDBColumn
        Caption = #1082#1086#1085'. '#1089#1072#1083#1100#1076#1086' ('#1088#1072#1089#1095'.)'
        DataBinding.FieldName = 'EndRemainsCalc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1082#1086#1085'. '#1089#1072#1083#1100#1076#1086' '#1087#1086' '#1076#1072#1085#1085#1099#1084' '#1054#1090#1095#1077#1090#1072' ('#1088#1072#1089#1095#1077#1090')'
        Options.Editing = False
        Width = 70
      end
      object isStartRemainsRep: TcxGridDBColumn
        Caption = #1054#1090#1082#1083'. '#1085#1072#1095'. '#1089#1072#1083#1100#1076#1086
        DataBinding.FieldName = 'isStartRemainsRep'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1054#1090#1082#1083'. '#1085#1072#1095'. '#1089#1072#1083#1100#1076#1086' '#1054#1090#1095#1077#1090' '#1086#1090' '#1056#1072#1089#1095#1077#1090
        Options.Editing = False
        Width = 50
      end
      object isEndRemainsRep: TcxGridDBColumn
        Caption = #1054#1090#1082#1083'. '#1082#1086#1085'. '#1089#1072#1083#1100#1076#1086
        DataBinding.FieldName = 'isEndRemainsRep'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1054#1090#1082#1083'. '#1082#1086#1085'. '#1089#1072#1083#1100#1076#1086' '#1054#1090#1095#1077#1090' '#1086#1090' '#1056#1072#1089#1095#1077#1090
        Options.Editing = False
        Width = 50
      end
      object InsertName: TcxGridDBColumn
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
        DataBinding.FieldName = 'InsertName'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 99
      end
      object InsertDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
        DataBinding.FieldName = 'InsertDate'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 83
      end
      object BuhName: TcxGridDBColumn
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1076#1072#1083#1080' '#1074' '#1073#1091#1093#1075'.)'
        DataBinding.FieldName = 'BuhName'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1076#1072#1083#1080' '#1074' '#1073#1091#1093#1075#1072#1083#1090#1077#1088#1080#1102')'
        Options.Editing = False
        Width = 106
      end
      object BuhDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' ('#1089#1076#1072#1083#1080' '#1074' '#1073#1091#1093#1075'.)'
        DataBinding.FieldName = 'BuhDate'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        HeaderHint = #1044#1072#1090#1072' ('#1089#1076#1072#1083#1080' '#1074' '#1073#1091#1093#1075#1072#1083#1090#1077#1088#1080#1102')'
        Options.Editing = False
        Width = 87
      end
      object ReCalcDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' ('#1087#1077#1088#1077#1089#1095#1077#1090#1072')'
        DataBinding.FieldName = 'ReCalcDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 96
      end
      object ReCalcName: TcxGridDBColumn
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1087#1077#1088#1077#1089#1095#1077#1090#1072')'
        DataBinding.FieldName = 'ReCalcName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object isErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Visible = False
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 30
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1128
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 5
    object deStart: TcxDateEdit
      Left = 119
      Top = 5
      EditValue = 43101d
      Properties.DateButtons = [btnClear, btnToday]
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 79
    end
    object cxlEnd: TcxLabel
      Left = 8
      Top = 32
      AutoSize = False
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
      Properties.Alignment.Vert = taVCenter
      Height = 21
      Width = 111
      AnchorY = 43
    end
    object deEnd: TcxDateEdit
      Left = 119
      Top = 32
      EditValue = 43101d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 2
      Width = 79
    end
    object cxLabel1: TcxLabel
      Left = 28
      Top = 5
      AutoSize = False
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
      Properties.Alignment.Vert = taVCenter
      Height = 21
      Width = 91
      AnchorY = 16
    end
    object cxLabel6: TcxLabel
      Left = 207
      Top = 6
      Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086':'
    end
    object edJuridical: TcxButtonEdit
      Left = 314
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 210
    end
    object cxLabel3: TcxLabel
      Left = 244
      Top = 30
      Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090':'
    end
    object edPartner: TcxButtonEdit
      Left = 314
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 210
    end
    object cxLabel8: TcxLabel
      Left = 602
      Top = 9
      Caption = #1044#1086#1075#1086#1074#1086#1088':'
    end
    object ceContract: TcxButtonEdit
      Left = 658
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 143
    end
    object cxLabel5: TcxLabel
      Left = 807
      Top = 30
      Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099':'
    end
    object edPaidKind: TcxButtonEdit
      Left = 888
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 90
    end
    object cxLabel20: TcxLabel
      Left = 817
      Top = 6
      Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075':'
    end
    object edContractTag: TcxButtonEdit
      Left = 888
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 90
    end
    object cxLabel7: TcxLabel
      Left = 530
      Top = 30
      Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103':'
    end
    object ceInfoMoney: TcxButtonEdit
      Left = 658
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 15
      Width = 143
    end
  end
  object cxGrid1: TcxGrid
    Left = 0
    Top = 392
    Width = 1128
    Height = 145
    Align = alBottom
    TabOrder = 6
    Visible = False
    object cxGridDBTableView1: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Format = ',0.00##'
          Kind = skSum
          Column = Debet
        end
        item
          Format = ',0.00##'
          Kind = skSum
          Column = Kredit
        end
        item
          Format = ',0.00##'
          Kind = skSum
          Column = cxGridDBColumn2
        end
        item
          Format = ',0.00##'
          Kind = skSum
          Column = cxGridDBColumn3
        end
        item
          Format = ',0.00##'
          Kind = skSum
          Column = StartRemains_Currency
        end
        item
          Format = ',0.00##'
          Kind = skSum
          Column = Debet_Currency
        end
        item
          Format = ',0.00##'
          Kind = skSum
          Column = Kredit_Currency
        end
        item
          Format = ',0.00##'
          Kind = skSum
          Column = EndRemains_Currency
        end
        item
          Format = ',0.00##'
          Kind = skSum
          Column = MovementSumm
        end
        item
          Format = ',0.00##'
          Kind = skSum
          Column = MovementSumm_Currency
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.00##'
          Kind = skSum
          Column = Debet
        end
        item
          Format = ',0.00##'
          Kind = skSum
          Column = Kredit
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
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00##'
          Kind = skSum
          Column = cxGridDBColumn2
        end
        item
          Format = ',0.00##'
          Kind = skSum
          Column = cxGridDBColumn3
        end
        item
          Format = ',0.00##'
          Kind = skSum
          Column = StartRemains_Currency
        end
        item
          Format = ',0.00##'
          Kind = skSum
          Column = Debet_Currency
        end
        item
          Format = ',0.00##'
          Kind = skSum
          Column = Kredit_Currency
        end
        item
          Format = ',0.00##'
          Kind = skSum
          Column = EndRemains_Currency
        end
        item
          Format = ',0.00##'
          Kind = skSum
          Column = MovementSumm
        end
        item
          Format = ',0.00##'
          Kind = skSum
          Column = MovementSumm_Currency
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.GoToNextCellOnEnter = True
      OptionsBehavior.FocusCellOnCycle = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsCustomize.DataRowSizing = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupSummaryLayout = gslAlignWithColumns
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object ItemName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1076#1086#1082'.'
        DataBinding.FieldName = 'ItemName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 95
      end
      object InvNumber: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1082'.'
        DataBinding.FieldName = 'InvNumber'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object InvNumberPartner: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1082'.'#1091' '#1087#1086#1082#1091#1087'.'
        DataBinding.FieldName = 'InvNumberPartner'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object MovementComment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1080#1079' '#1076#1086#1082'.'
        DataBinding.FieldName = 'MovementComment'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object OperDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072
        DataBinding.FieldName = 'OperDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object PartionMovementName: TcxGridDBColumn
        Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'PartionMovementName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object PaymentDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099
        DataBinding.FieldName = 'PaymentDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object cxGridDBColumn1: TcxGridDBColumn
        Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
        DataBinding.FieldName = 'PaidKindName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object InvNumber_Transport: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1082'. '#1055'.'#1083'.'
        DataBinding.FieldName = 'InvNumber_Transport'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1072#1085#1085#1099#1077' '#1080#1079' '#1044#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080
        Options.Editing = False
        Width = 61
      end
      object OperDate_Transport: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1055'.'#1083'.'
        DataBinding.FieldName = 'OperDate_Transport'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1072#1085#1085#1099#1077' '#1080#1079' '#1044#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080
        Options.Editing = False
        Width = 70
      end
      object CarName: TcxGridDBColumn
        Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100' '#1055'.'#1083'.'
        DataBinding.FieldName = 'CarName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1072#1085#1085#1099#1077' '#1080#1079' '#1044#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080
        Options.Editing = False
        Width = 80
      end
      object PersonalDriverName: TcxGridDBColumn
        Caption = #1042#1086#1076#1080#1090#1077#1083#1100' '#1055'.'#1083'.'
        DataBinding.FieldName = 'PersonalDriverName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1072#1085#1085#1099#1077' '#1080#1079' '#1044#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080
        Options.Editing = False
        Width = 70
      end
      object cxGridDBColumn2: TcxGridDBColumn
        Caption = #1053#1072#1095'. '#1076#1086#1083#1075' ('#1040#1082#1090#1080#1074')'
        DataBinding.FieldName = 'StartRemains'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object Debet: TcxGridDBColumn
        Caption = #1044#1077#1073#1077#1090
        DataBinding.FieldName = 'Debet'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object Kredit: TcxGridDBColumn
        Caption = #1050#1088#1077#1076#1080#1090
        DataBinding.FieldName = 'Kredit'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object cxGridDBColumn3: TcxGridDBColumn
        Caption = #1050#1086#1085'. '#1076#1086#1083#1075' ('#1040#1082#1090#1080#1074')'
        DataBinding.FieldName = 'EndRemains'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object StartRemains_Currency: TcxGridDBColumn
        Caption = #1053#1072#1095'. '#1076#1086#1083#1075' '#1074' '#1074#1072#1083'. ('#1040#1082#1090#1080#1074')'
        DataBinding.FieldName = 'StartRemains_Currency'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object Debet_Currency: TcxGridDBColumn
        Caption = #1044#1077#1073#1077#1090' '#1074' '#1074#1072#1083'. '
        DataBinding.FieldName = 'Debet_Currency'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object Kredit_Currency: TcxGridDBColumn
        Caption = #1050#1088#1077#1076#1080#1090' '#1074' '#1074#1072#1083'. '
        DataBinding.FieldName = 'Kredit_Currency'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object EndRemains_Currency: TcxGridDBColumn
        Caption = #1050#1086#1085'. '#1076#1086#1083#1075' '#1074' '#1074#1072#1083'. ('#1040#1082#1090#1080#1074')'
        DataBinding.FieldName = 'EndRemains_Currency'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object CurrencyName: TcxGridDBColumn
        Caption = #1042#1072#1083#1102#1090#1072
        DataBinding.FieldName = 'CurrencyName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object FromName: TcxGridDBColumn
        Caption = #1054#1090' '#1050#1086#1075#1086
        DataBinding.FieldName = 'FromName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object ToName: TcxGridDBColumn
        Caption = #1050#1086#1084#1091
        DataBinding.FieldName = 'ToName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object ContractStateKindCode: TcxGridDBColumn
        Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1076#1086#1075'.'
        DataBinding.FieldName = 'ContractStateKindCode'
        PropertiesClassName = 'TcxImageComboBoxProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.Alignment.Vert = taVCenter
        Properties.Images = dmMain.ImageList
        Properties.Items = <
          item
            Description = #1055#1086#1076#1087#1080#1089#1072#1085
            ImageIndex = 12
            Value = 1
          end
          item
            Description = #1053#1077' '#1087#1086#1076#1087#1080#1089#1072#1085
            ImageIndex = 11
            Value = 2
          end
          item
            Description = #1047#1072#1074#1077#1088#1096#1077#1085
            ImageIndex = 13
            Value = 3
          end
          item
            Description = #1059' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
            ImageIndex = 66
            Value = 4
          end>
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object ContractCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1076#1086#1075'.'
        DataBinding.FieldName = 'ContractCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object cxGridDBColumn4: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1075'.'
        DataBinding.FieldName = 'ContractName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 60
      end
      object ContractTagName: TcxGridDBColumn
        Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
        DataBinding.FieldName = 'ContractTagName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 60
      end
      object ContractComment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1076#1086#1075'.'
        DataBinding.FieldName = 'ContractComment'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object InfoMoneyGroupCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1059#1055' '#1075#1088#1091#1087#1087#1099
        DataBinding.FieldName = 'InfoMoneyGroupCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object InfoMoneyGroupName: TcxGridDBColumn
        Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'InfoMoneyGroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object InfoMoneyDestinationCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1059#1055' '#1085#1072#1079#1085#1072#1095'.'
        DataBinding.FieldName = 'InfoMoneyDestinationCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object InfoMoneyDestinationName: TcxGridDBColumn
        Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
        DataBinding.FieldName = 'InfoMoneyDestinationName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object InfoMoneyCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1059#1055
        DataBinding.FieldName = 'InfoMoneyCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object cxGridDBColumn5: TcxGridDBColumn
        Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'InfoMoneyName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object AccountName: TcxGridDBColumn
        Caption = #1057#1095#1077#1090
        DataBinding.FieldName = 'AccountName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 86
      end
      object MovementSumm: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' '#1054#1073#1086#1088#1086#1090
        DataBinding.FieldName = 'MovementSumm'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        Visible = False
        Options.Editing = False
        VisibleForCustomization = False
        Width = 55
      end
      object MovementSumm_Currency: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' '#1054#1073#1086#1088#1086#1090' '#1074' '#1074#1072#1083'. '
        DataBinding.FieldName = 'MovementSumm_Currency'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        Visible = False
        Options.Editing = False
        VisibleForCustomization = False
        Width = 55
      end
      object OperationSort: TcxGridDBColumn
        Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072
        DataBinding.FieldName = 'OperationSort'
        Visible = False
        Options.Editing = False
        VisibleForCustomization = False
        Width = 55
      end
    end
    object cxGridLevel1: TcxGridLevel
      GridView = cxGridDBTableView1
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 56
    Top = 152
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 104
    Top = 160
  end
  object cxPropertiesStore: TcxPropertiesStore
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
        Component = GuidesContract
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesJuridical
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesPaidKind
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesPartner
        Properties.Strings = (
          'Key'
          'TextValue')
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
    StorageType = stStream
    Left = 304
    Top = 160
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
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 152
    Top = 232
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar1: TdxBar
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
          ItemName = 'bbExecuteDialog'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbSetErased'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErased'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbChoiceGuides'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateRemainsCalc'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateRemainsByRep'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Buh_Yes'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Buh_No'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenReportForm'
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
          ItemName = 'bbPrintPack_two'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintPack_one'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bb'
        end
        item
          Visible = True
          ItemName = 'bbPrintPackList_ff'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpenForm'
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
    object bbGridToExcel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
      ShowCaption = False
    end
    object bbChoiceGuides: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbUpdateRemainsCalc: TdxBarButton
      Action = macUpdateRemainsCalc
      Caption = #1056#1072#1089#1095#1080#1090#1072#1090#1100' '#1085#1072#1095'./ '#1082#1086#1085'. '#1089#1072#1083#1100#1076#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
      Category = 0
    end
    object bbProtocolOpenForm: TdxBarButton
      Action = ProtocolOpenForm
      Category = 0
    end
    object bbUpdateRemainsByRep: TdxBarButton
      Action = macUpdateRemainsByRep
      Category = 0
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbUpdate_Buh_Yes: TdxBarButton
      Action = actUpdate_Buh_Yes
      Category = 0
    end
    object bbUpdate_Buh_No: TdxBarButton
      Action = actUpdate_Buh_No
      Category = 0
    end
    object bbSetErased: TdxBarButton
      Action = dsdSetErased
      Category = 0
    end
    object bbSetUnErased: TdxBarButton
      Action = dsdSetUnErased
      Category = 0
    end
    object bbOpenReportForm: TdxBarButton
      Action = actOpenReportForm
      Category = 0
    end
    object bbPrintPack_two: TdxBarButton
      Action = mactPrintPack_two
      Category = 0
    end
    object bbPrintPack_one: TdxBarButton
      Action = mactPrintPack_one
      Category = 0
    end
    object bbPrintPackList_ff: TdxBarButton
      Action = mactPrintPackList_ff_one
      Caption = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080' ('#1085#1072#1083') '#1087#1072#1082#1077#1090#1085#1072#1103' '#1087#1077#1095#1072#1090#1100
      Category = 0
      ImageIndex = 23
    end
    object bb: TdxBarButton
      Action = mactPrintPackList_ff_two
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 320
    Top = 320
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object dsdChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
      DataSource = DataSource
    end
    object dsdGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actUpdateRemains: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateRemains
      StoredProcList = <
        item
          StoredProc = spUpdateRemains
        end>
      Caption = 'actUpdateRemains'
      DataSource = DataSource
    end
    object macUpdateRemainsByRep: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateRemainsByRep
        end
        item
          Action = actRefresh
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = 
        #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1086' '#1074#1099#1073#1088#1072#1085#1085#1099#1084' '#1072#1082#1090#1072#1084' "'#1089#1072#1083#1100#1076#1086' '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090'" = "'#1089#1072#1083#1100#1076#1086' '#1054#1090#1095#1077 +
        #1090'"'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1087#1077#1088#1077#1085#1077#1089#1077#1085#1099
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1072#1083#1100#1076#1086' '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' = '#1089#1072#1083#1100#1076#1086' '#1054#1090#1095#1077#1090
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1072#1083#1100#1076#1086' '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' = '#1089#1072#1083#1100#1076#1086' '#1054#1090#1095#1077#1090
      ImageIndex = 74
    end
    object macUpdateRemainsCalc: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateRemainsCalc
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1056#1072#1089#1095#1080#1090#1072#1090#1100' '#1085#1072#1095'./ '#1082#1086#1085'. '#1089#1072#1083#1100#1076#1086' '#1087#1086' '#1072#1082#1090#1072#1084' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1074#1099#1073#1088'. '#1087#1072#1088#1072#1084#1077#1090#1088#1072#1084'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1088#1072#1089#1095#1080#1090#1072#1085#1099
      Caption = #1056#1072#1089#1095#1080#1090#1072#1090#1100' '#1089#1072#1083#1100#1076#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
      Hint = #1056#1072#1089#1095#1080#1090#1072#1090#1100' '#1085#1072#1095'./ '#1082#1086#1085'. '#1089#1072#1083#1100#1076#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
      ImageIndex = 45
    end
    object actUpdateRemainsByRep: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateRemainsByRep
      StoredProcList = <
        item
          StoredProc = spUpdateRemainsByRep
        end>
      Caption = 'UpdateRemainsByRep'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1072#1083#1100#1076#1086' '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' = '#1089#1072#1083#1100#1076#1086' '#1054#1090#1095#1077#1090
    end
    object actUpdateRemainsCalc: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateRemainsCalc
      StoredProcList = <
        item
          StoredProc = spUpdateRemainsCalc
        end>
      Caption = 'actUpdateRemainsCalc'
      Hint = #1056#1072#1089#1095#1080#1090#1072#1090#1100' '#1085#1072#1095'./ '#1082#1086#1085'. '#1089#1072#1083#1100#1076#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
    end
    object ProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'JuridicalName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 20
      DataSets = <
        item
          UserName = 'DataSet'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 43101d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 43101d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountName'
          Value = ''
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindName'
          Value = ''
          Component = GuidesPaidKind
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartBalance'
          Value = Null
          ComponentItem = 'StartBalance'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartBalanceCurrency'
          Value = Null
          ComponentItem = 'StartBalanceCurrency'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          ComponentItem = 'JuridicalName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalShortName'
          Value = Null
          ComponentItem = 'JuridicalShortName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = Null
          ComponentItem = 'PartnerName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'CurrencyName'
          Value = Null
          ComponentItem = 'CurrencyName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionMovementName'
          Value = Null
          ComponentItem = 'PartionMovementName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccounterName'
          Value = Null
          ComponentItem = 'AccounterName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContracNumber'
          Value = Null
          ComponentItem = 'ContracNumber'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractTagName'
          Value = Null
          ComponentItem = 'ContractTagName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractSigningDate'
          Value = 42005d
          ComponentItem = 'ContractSigningDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName_Basis'
          Value = Null
          ComponentItem = 'JuridicalName_Basis'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalShortName_Basis'
          Value = Null
          ComponentItem = 'JuridicalShortName_Basis'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccounterName_Basis'
          Value = Null
          ComponentItem = 'AccounterName_Basis'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1056#1077
      ReportNameParam.Value = #1056#1077
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReportCollation_ObjectDialogForm'
      FormNameParam.Value = 'TReportCollation_ObjectDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 43101d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 43101d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = ''
          Component = GuidesJuridical
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = ''
          Component = GuidesJuridical
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerId'
          Value = ''
          Component = GuidesPartner
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = ''
          Component = GuidesPartner
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindId'
          Value = ''
          Component = GuidesPaidKind
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindName'
          Value = ''
          Component = GuidesPaidKind
          ComponentItem = 'TextValue'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractId'
          Value = ''
          Component = GuidesContract
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractName'
          Value = ''
          Component = GuidesContract
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractTagId'
          Value = Null
          Component = ContractTagGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractTagName'
          Value = Null
          Component = ContractTagGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyId'
          Value = Null
          Component = GuidesInfoMoney
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = GuidesInfoMoney
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actUpdate_Buh_No: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Buh_No
      StoredProcList = <
        item
          StoredProc = spUpdate_Buh_No
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1057#1076#1072#1083#1080' '#1074' '#1073#1091#1093#1075#1072#1083#1090#1077#1088#1080#1102' - '#1053#1077#1090
      Hint = #1057#1076#1072#1083#1080' '#1074' '#1073#1091#1093#1075#1072#1083#1090#1077#1088#1080#1102' - '#1053#1077#1090
      ImageIndex = 58
    end
    object actUpdate_Buh_Yes: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Buh_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_Buh_Yes
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1057#1076#1072#1083#1080' '#1074' '#1073#1091#1093#1075#1072#1083#1090#1077#1088#1080#1102' - '#1044#1072
      Hint = #1057#1076#1072#1083#1080' '#1074' '#1073#1091#1093#1075#1072#1083#1090#1077#1088#1080#1102' - '#1044#1072
      ImageIndex = 76
    end
    object macUpdate_Buh_No: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Buh_No
        end
        item
          Action = actRefresh
        end>
      Caption = #1057#1076#1072#1083#1080' '#1074' '#1073#1091#1093#1075#1072#1083#1090#1077#1088#1080#1102' - '#1053#1077#1090
      Hint = #1057#1076#1072#1083#1080' '#1074' '#1073#1091#1093#1075#1072#1083#1090#1077#1088#1080#1102' - '#1053#1077#1090
      ImageIndex = 58
    end
    object macUpdate_Buh_Yes: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Buh_Yes
        end
        item
          Action = actRefresh
        end>
      Caption = #1057#1076#1072#1083#1080' '#1074' '#1073#1091#1093#1075#1072#1083#1090#1077#1088#1080#1102' - '#1044#1072
      Hint = #1057#1076#1072#1083#1080' '#1074' '#1073#1091#1093#1075#1072#1083#1090#1077#1088#1080#1102' - '#1044#1072
      ImageIndex = 76
    end
    object dsdSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErased
      StoredProcList = <
        item
          StoredProc = spErasedUnErased
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = DataSource
    end
    object dsdSetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErased
      StoredProcList = <
        item
          StoredProc = spErasedUnErased
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DataSource
    end
    object actOpenReportForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1040#1082#1090' '#1089#1074#1077#1088#1082#1080'>'
      Hint = #1054#1090#1095#1077#1090' <'#1040#1082#1090' '#1089#1074#1077#1088#1082#1080'>'
      ImageIndex = 25
      FormName = 'TReport_JuridicalCollationForm'
      FormNameParam.Value = 'TReport_JuridicalCollationForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inStartDate'
          Value = 43101d
          Component = ClientDataSet
          ComponentItem = 'StartDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inEndDate'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'EndDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inInfoMoneyId'
          Value = ''
          Component = ClientDataSet
          ComponentItem = 'InfoMoneyId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inInfoMoneyName'
          Value = ''
          Component = ClientDataSet
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'JuridicalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PartnerId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PartnerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inContractId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'ContractId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inContractName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'ContractName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPaidKindId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PaidKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPaidKindName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PaidKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object mactPrintPack_two: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actPrintPack_two
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1087#1077#1095#1072#1090#1080' '#1087#1072#1082#1077#1090#1072' ('#1073#1091#1093#1075#1072#1083#1090#1077#1088#1089#1082#1080#1081') '#1074' '#1076#1074#1091#1093' '#1101#1082#1079#1077#1084#1087#1083#1103#1088#1072#1093'?'
      Caption = #1055#1072#1082#1077#1090#1085#1072#1103' '#1087#1077#1095#1072#1090#1100' (2 '#1101#1082#1079#1077#1084#1087#1083#1103#1088#1072') ('#1073#1091#1093'.)'
      Hint = #1055#1072#1082#1077#1090#1085#1072#1103' '#1087#1077#1095#1072#1090#1100' (2 '#1101#1082#1079#1077#1084#1087#1083#1103#1088#1072')'
      ImageIndex = 15
    end
    object actPrintPack_two: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintPack
      StoredProcList = <
        item
          StoredProc = spSelectPrintPack
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 15
      WithOutPreview = True
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDataset'
        end
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end>
      CopiesCount = 2
      Params = <>
      ReportName = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080' ('#1073#1091#1093#1075#1072#1083#1090#1077#1088#1089#1082#1080#1081')'#1055#1072#1082#1077#1090
      ReportNameParam.Value = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080' ('#1073#1091#1093#1075#1072#1083#1090#1077#1088#1089#1082#1080#1081')'#1055#1072#1082#1077#1090
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object mactPrintPack_one: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actPrintPack_one
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1087#1077#1095#1072#1090#1080' '#1087#1072#1082#1077#1090#1072' ('#1073#1091#1093#1075#1072#1083#1090#1077#1088#1089#1082#1080#1081') '#1074' '#1086#1076#1085#1086#1084' '#1101#1082#1079#1077#1084#1087#1083#1103#1088#1077'?'
      Caption = #1055#1072#1082#1077#1090#1085#1072#1103' '#1087#1077#1095#1072#1090#1100' (1 '#1101#1082#1079#1077#1084#1087#1083#1103#1088') ('#1073#1091#1093'.)'
      Hint = #1055#1072#1082#1077#1090#1085#1072#1103' '#1087#1077#1095#1072#1090#1100' (1 '#1101#1082#1079#1077#1084#1087#1083#1103#1088')'
      ImageIndex = 17
    end
    object actPrintPack_one_ff: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintPack
      StoredProcList = <
        item
          StoredProc = spSelectPrintPack
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 15
      WithOutPreview = True
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDataset'
        end
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end>
      Params = <>
      ReportName = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080' ('#1085#1072#1083') '#1055#1072#1082#1077#1090
      ReportNameParam.Value = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080' ('#1085#1072#1083') '#1055#1072#1082#1077#1090
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintPack_one: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintPack
      StoredProcList = <
        item
          StoredProc = spSelectPrintPack
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 15
      WithOutPreview = True
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDataset'
        end
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end>
      Params = <>
      ReportName = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080' ('#1073#1091#1093#1075#1072#1083#1090#1077#1088#1089#1082#1080#1081')'#1055#1072#1082#1077#1090
      ReportNameParam.Value = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080' ('#1073#1091#1093#1075#1072#1083#1090#1077#1088#1089#1082#1080#1081')'#1055#1072#1082#1077#1090
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintPack_ff_two: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spJuridicalBalance
      StoredProcList = <
        item
          StoredProc = spJuridicalBalance
        end>
      Caption = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080
      Hint = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080
      ImageIndex = 3
      WithOutPreview = True
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDataset'
          IndexFieldNames = 'ItemName;OperDate;InvNumber'
        end>
      CopiesCount = 2
      Params = <
        item
          Name = 'StartDate'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'StartDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'EndDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PaidKindName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartBalance'
          Value = Null
          Component = FormParams
          ComponentItem = 'StartBalance'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartBalanceCurrency'
          Value = Null
          Component = FormParams
          ComponentItem = 'StartBalanceCurrency'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = FormParams
          ComponentItem = 'JuridicalName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalShortName'
          Value = Null
          Component = FormParams
          ComponentItem = 'JuridicalShortName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = Null
          Component = FormParams
          ComponentItem = 'PartnerName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'CurrencyName'
          Value = Null
          Component = FormParams
          ComponentItem = 'CurrencyName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionMovementName'
          Value = Null
          Component = FormParams
          ComponentItem = 'PartionMovementName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccounterName'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccounterName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContracNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'ContracNumber'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractTagName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ContractTagName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractSigningDate'
          Value = 42005d
          Component = FormParams
          ComponentItem = 'ContractSigningDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName_Basis'
          Value = Null
          Component = FormParams
          ComponentItem = 'JuridicalName_Basis'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalShortName_Basis'
          Value = Null
          Component = FormParams
          ComponentItem = 'JuridicalShortName_Basis'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccounterName_Basis'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccounterName_Basis'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = FormParams
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BarCodeId'
          Value = Null
          Component = FormParams
          ComponentItem = 'BarCodeId'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ReportCollationCode'
          Value = '0'
          Component = FormParams
          ComponentItem = 'ReportCollationCode'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' ('#1040#1082#1090' '#1089#1074#1077#1088#1082#1080')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' ('#1040#1082#1090' '#1089#1074#1077#1088#1082#1080')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintPack_ff_one: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spJuridicalBalance
      StoredProcList = <
        item
          StoredProc = spJuridicalBalance
        end>
      Caption = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080
      Hint = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080
      ImageIndex = 3
      WithOutPreview = True
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDataset'
          IndexFieldNames = 'ItemName;OperDate;InvNumber'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 43101d
          Component = ClientDataSet
          ComponentItem = 'StartDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 43101d
          Component = ClientDataSet
          ComponentItem = 'EndDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindName'
          Value = ''
          Component = ClientDataSet
          ComponentItem = 'PaidKindName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartBalance'
          Value = Null
          Component = FormParams
          ComponentItem = 'StartBalance'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartBalanceCurrency'
          Value = Null
          Component = FormParams
          ComponentItem = 'StartBalanceCurrency'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = FormParams
          ComponentItem = 'JuridicalName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalShortName'
          Value = Null
          Component = FormParams
          ComponentItem = 'JuridicalShortName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = Null
          Component = FormParams
          ComponentItem = 'PartnerName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'CurrencyName'
          Value = Null
          Component = FormParams
          ComponentItem = 'CurrencyName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionMovementName'
          Value = Null
          Component = FormParams
          ComponentItem = 'PartionMovementName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccounterName'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccounterName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContracNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'ContracNumber'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractTagName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ContractTagName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractSigningDate'
          Value = 42005d
          Component = FormParams
          ComponentItem = 'ContractSigningDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName_Basis'
          Value = Null
          Component = FormParams
          ComponentItem = 'JuridicalName_Basis'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalShortName_Basis'
          Value = Null
          Component = FormParams
          ComponentItem = 'JuridicalShortName_Basis'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccounterName_Basis'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccounterName_Basis'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = ''
          Component = FormParams
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BarCodeId'
          Value = Null
          Component = FormParams
          ComponentItem = 'BarCodeId'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ReportCollationCode'
          Value = '0'
          Component = FormParams
          ComponentItem = 'ReportCollationCode'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' ('#1040#1082#1090' '#1089#1074#1077#1088#1082#1080')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' ('#1040#1082#1090' '#1089#1074#1077#1088#1082#1080')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object mactPrintPackList_ff_two: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actspSelectReport
        end
        item
          Action = actPrintPack_ff_two
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1087#1077#1095#1072#1090#1080'  '#1087#1072#1082#1077#1090#1072' ('#1085#1072#1083') '#1074' '#1076#1074#1091#1093' '#1101#1082#1079#1077#1084#1087#1083#1103#1088#1072#1093'?'
      Caption = #1055#1072#1082#1077#1090#1085#1072#1103' '#1087#1077#1095#1072#1090#1100' (2 '#1101#1082#1079#1077#1084#1087#1083#1103#1088#1072') ('#1085#1072#1083')'
      Hint = #1055#1072#1082#1077#1090#1085#1072#1103' '#1087#1077#1095#1072#1090#1100' (2 '#1101#1082#1079#1077#1084#1087#1083#1103#1088#1072') ('#1085#1072#1083')'
      ImageIndex = 19
    end
    object mactPrintPackList_ff_one: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actspSelectReport
        end
        item
          Action = actPrintPack_ff_one
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1087#1077#1095#1072#1090#1080'  '#1087#1072#1082#1077#1090#1072' ('#1085#1072#1083') '#1074' '#1086#1076#1085#1086#1084' '#1101#1082#1079#1077#1084#1087#1083#1103#1088#1077'?'
      Caption = #1055#1072#1082#1077#1090#1085#1072#1103' '#1087#1077#1095#1072#1090#1100' (1 '#1101#1082#1079#1077#1084#1087#1083#1103#1088') ('#1085#1072#1083')'
      Hint = #1055#1072#1082#1077#1090#1085#1072#1103' '#1087#1077#1095#1072#1090#1100' (1 '#1101#1082#1079#1077#1084#1087#1083#1103#1088') ('#1085#1072#1083')'
      ImageIndex = 19
    end
    object actspSelectReport: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelectReport
      StoredProcList = <
        item
          StoredProc = spSelectReport
        end
        item
          StoredProc = spSelect
        end>
      Caption = 'spSelectReport'
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ReportCollation'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = False
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42736d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = Null
        Component = GuidesPartner
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = GuidesContract
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = Null
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId'
        Value = Null
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsShowAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 48
    Top = 216
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 208
    Top = 168
  end
  object DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 328
    Top = 264
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 240
    Top = 264
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesContract
      end
      item
        Component = GuidesJuridical
      end
      item
        Component = GuidesPaidKind
      end
      item
        Component = GuidesPartner
      end
      item
        Component = GuidesInfoMoney
      end>
    Left = 376
    Top = 216
  end
  object spUpdateRemains: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_ReportCollation_Remains'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId '
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartRemains'
        Value = 0.000000000000000000
        Component = ClientDataSet
        ComponentItem = 'StartRemains'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndRemains'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'EndRemains'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 88
    Top = 297
  end
  object spUpdateRemainsCalc: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_ReportCollation_RemainsCalc'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inStartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = Null
        Component = GuidesPartner
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = GuidesContract
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = Null
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId'
        Value = Null
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 152
    Top = 361
  end
  object spUpdateRemainsByRep: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_ReportCollation_RemainsByRep'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId '
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartRemainsRep'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'StartRemainsRep'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndRemainsRep'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'EndRemainsRep'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 200
    Top = 289
  end
  object GuidesJuridical: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 392
  end
  object GuidesPartner: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartner
    FormNameParam.Value = 'TPartner_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartner_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalId'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 440
    Top = 24
  end
  object GuidesContract: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceContract
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindId'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalId'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTagId'
        Value = Null
        Component = ContractTagGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTagName'
        Value = Null
        Component = ContractTagGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 680
    Top = 62
  end
  object GuidesPaidKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPaidKind
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPaidKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 648
    Top = 16
  end
  object ContractTagGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContractTag
    FormNameParam.Value = 'TContractTagForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractTagForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractTagGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractTagGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 899
    Top = 60
  end
  object spUpdate_Buh_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_ReportCollation_Buh'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsBuh'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 680
    Top = 208
  end
  object spUpdate_Buh_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_ReportCollation_Buh'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsBuh'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 680
    Top = 264
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_ReportCollation_IsErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 496
    Top = 184
  end
  object GuidesInfoMoney: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoney
    FormNameParam.Value = 'TInfoMoney_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoney_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 768
    Top = 13
  end
  object spSelectPrintPack: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ReportCollation_PrintPack'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 504
    Top = 288
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 772
    Top = 217
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 772
    Top = 270
  end
  object spSelectReport: TdsdStoredProc
    StoredProcName = 'gpReport_JuridicalCollation'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 43101d
        Component = ClientDataSet
        ComponentItem = 'StartDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 43101d
        Component = ClientDataSet
        ComponentItem = 'EndDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = ClientDataSet
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = '0'
        Component = ClientDataSet
        ComponentItem = 'PartnerId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = ''
        Component = ClientDataSet
        ComponentItem = 'ContractId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAccountId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = ''
        Component = ClientDataSet
        ComponentItem = 'PaidKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId'
        Value = ''
        Component = ClientDataSet
        ComponentItem = 'InfoMoneyId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Partion'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 640
    Top = 376
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 832
    Top = 452
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'OperationSort;ItemName;OperDate'
    Params = <>
    Left = 800
    Top = 420
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <
      item
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 752
    Top = 448
  end
  object spJuridicalBalance: TdsdStoredProc
    StoredProcName = 'gpReport_JuridicalBalance'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOperDate'
        Value = 43101d
        Component = ClientDataSet
        ComponentItem = 'StartDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 43101d
        Component = ClientDataSet
        ComponentItem = 'EndDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = ClientDataSet
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = '0'
        Component = ClientDataSet
        ComponentItem = 'PartnerId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = ''
        Component = ClientDataSet
        ComponentItem = 'ContractId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAccountId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = ''
        Component = ClientDataSet
        ComponentItem = 'PaidKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId'
        Value = ''
        Component = ClientDataSet
        ComponentItem = 'InfoMoneyId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStartBalance'
        Value = Null
        Component = FormParams
        ComponentItem = 'StartBalance'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStartBalanceCurrency'
        Value = Null
        Component = FormParams
        ComponentItem = 'StartBalanceCurrency'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outJuridicalName'
        Value = Null
        Component = FormParams
        ComponentItem = 'JuridicalName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outJuridicalShortName'
        Value = Null
        Component = FormParams
        ComponentItem = 'JuridicalShortName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPartnerName'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartnerName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCurrencyName'
        Value = Null
        Component = FormParams
        ComponentItem = 'CurrencyName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outInternalCurrencyName'
        Value = Null
        Component = FormParams
        ComponentItem = 'InternalCurrencyName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAccounterName'
        Value = Null
        Component = FormParams
        ComponentItem = 'AccounterName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outContracNumber'
        Value = Null
        Component = FormParams
        ComponentItem = 'ContracNumber'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outContractTagName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ContractTagName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outContractSigningDate'
        Value = 42005d
        Component = FormParams
        ComponentItem = 'ContractSigningDate'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outJuridicalName_Basis'
        Value = Null
        Component = FormParams
        ComponentItem = 'JuridicalName_Basis'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outJuridicalShortName_Basis'
        Value = Null
        Component = FormParams
        ComponentItem = 'JuridicalShortName_Basis'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAccounterName_Basis'
        Value = Null
        Component = FormParams
        ComponentItem = 'AccounterName_Basis'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outReportCollationCode'
        Value = '0'
        Component = FormParams
        ComponentItem = 'ReportCollationCode'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 632
    Top = 440
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'FormName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractSigningDate'
        Value = 42005d
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate'
        Value = 43101d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 43101d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAccountId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAccountName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyName'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalName'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = '0'
        Component = GuidesPartner
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerName'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindName'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractName'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 448
  end
end
