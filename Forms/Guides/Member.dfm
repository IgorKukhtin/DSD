object MemberForm: TMemberForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1060#1080#1079#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072'>'
  ClientHeight = 458
  ClientWidth = 1056
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.isAlwaysRefresh = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 96
    Width = 1056
    Height = 362
    Align = alClient
    TabOrder = 0
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    LookAndFeel.SkinName = ''
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1057#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = Name
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsBehavior.IncSearchItem = Name
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object Code: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 52
      end
      object Code1C: TcxGridDBColumn
        Caption = #1050#1086#1076' 1'#1057
        DataBinding.FieldName = 'Code1C'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object Name: TcxGridDBColumn
        Caption = #1060#1048#1054
        DataBinding.FieldName = 'Name'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 126
      end
      object GLN: TcxGridDBColumn
        DataBinding.FieldName = 'GLN'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
      object BankName: TcxGridDBColumn
        Caption = #1041#1072#1085#1082' ('#1060'1)'
        DataBinding.FieldName = 'BankName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoiceBankForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object Card: TcxGridDBColumn
        Caption = #8470' '#1082#1072#1088#1090'. '#1089#1095#1077#1090#1072' '#1047#1055' ('#1060'1)'
        DataBinding.FieldName = 'Card'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 115
      end
      object CardBank: TcxGridDBColumn
        Caption = #8470' '#1073#1072#1085#1082'. '#1082#1072#1088#1090#1086#1095#1082#1080' '#1047#1055' ('#1060'1)'
        DataBinding.FieldName = 'CardBank'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 115
      end
      object CardIBAN: TcxGridDBColumn
        Caption = #8470' '#1082#1072#1088#1090'. '#1089#1095#1077#1090#1072' IBAN '#1047#1055' ('#1060'1)'
        DataBinding.FieldName = 'CardIBAN'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 115
      end
      object BankSecondName: TcxGridDBColumn
        Caption = #1041#1072#1085#1082' - '#1060'2 ('#1042#1086#1089#1090#1086#1082')'
        DataBinding.FieldName = 'BankSecondName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoiceBankSecondForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object CardBankSecond: TcxGridDBColumn
        Caption = #8470' '#1073#1072#1085#1082'. '#1082#1072#1088#1090#1086#1095#1082#1080' '#1047#1055' ('#1060'2) ('#1042#1086#1089#1090#1086#1082')'
        DataBinding.FieldName = 'CardBankSecond'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 115
      end
      object CardIBANSecond: TcxGridDBColumn
        Caption = #8470' '#1082#1072#1088#1090'. '#1089#1095#1077#1090#1072' IBAN '#1047#1055' ('#1060'2) ('#1042#1086#1089#1090#1086#1082')'
        DataBinding.FieldName = 'CardIBANSecond'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 140
      end
      object CardSecond: TcxGridDBColumn
        Caption = #8470' '#1082#1072#1088#1090'.'#1089#1095#1077#1090#1072' '#1047#1055' ('#1060'2) ('#1042#1086#1089#1090#1086#1082')'
        DataBinding.FieldName = 'CardSecond'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 140
      end
      object BankSecondTwoName: TcxGridDBColumn
        Caption = #1041#1072#1085#1082' - '#1060'2 ('#1054#1058#1055')'
        DataBinding.FieldName = 'BankSecondTwoName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoiceBankSecondTwoForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object CardBankSecondTwo: TcxGridDBColumn
        Caption = #8470' '#1073#1072#1085#1082'. '#1082#1072#1088#1090#1086#1095#1082#1080' '#1047#1055' ('#1060'2)('#1054#1058#1055')'
        DataBinding.FieldName = 'CardBankSecondTwo'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 115
      end
      object CardIBANSecondTwo: TcxGridDBColumn
        Caption = #8470' '#1082#1072#1088#1090'. '#1089#1095#1077#1090#1072' IBAN '#1047#1055' ('#1060'2) ('#1054#1058#1055')'
        DataBinding.FieldName = 'CardIBANSecondTwo'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 115
      end
      object CardSecondTwo: TcxGridDBColumn
        Caption = #8470' '#1082#1072#1088#1090'.'#1089#1095#1077#1090#1072' '#1047#1055' ('#1060'2) ('#1054#1058#1055')'
        DataBinding.FieldName = 'CardSecondTwo'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 115
      end
      object BankSecondDiffName: TcxGridDBColumn
        Caption = #1041#1072#1085#1082' - '#1060'2 ('#1083#1080#1095#1085#1099#1081')'
        DataBinding.FieldName = 'BankSecondDiffName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoiceBankSecondDiffForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object CardBankSecondDiff: TcxGridDBColumn
        Caption = #8470' '#1073#1072#1085#1082'. '#1082#1072#1088#1090#1086#1095#1082#1080' '#1047#1055' ('#1060'2)('#1083#1080#1095#1085#1099#1081')'
        DataBinding.FieldName = 'CardBankSecondDiff'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 115
      end
      object CardIBANSecondDiff: TcxGridDBColumn
        Caption = #8470' '#1082#1072#1088#1090'. '#1089#1095#1077#1090#1072' IBAN '#1047#1055' ('#1060'2) ('#1083#1080#1095#1085'.)'
        DataBinding.FieldName = 'CardIBANSecondDiff'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 115
      end
      object CardSecondDiff: TcxGridDBColumn
        Caption = #8470' '#1082#1072#1088#1090'.'#1089#1095#1077#1090#1072' '#1047#1055' ('#1060'2) ('#1083#1080#1095#1085'.)'
        DataBinding.FieldName = 'CardSecondDiff'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 115
      end
      object CardChild: TcxGridDBColumn
        Caption = #8470' '#1082#1072#1088#1090'. '#1089#1095#1077#1090#1072' '#1072#1083#1080#1084#1077#1085#1090#1099' ('#1091#1076#1077#1088#1078#1072#1085#1080#1077')'
        DataBinding.FieldName = 'CardChild'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 115
      end
      object BankChildName: TcxGridDBColumn
        Caption = #1041#1072#1085#1082' '#1072#1083#1080#1084#1077#1085#1090#1099' ('#1091#1076#1077#1088#1078'.)'
        DataBinding.FieldName = 'BankChildName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoiceBankChildForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object INN: TcxGridDBColumn
        Caption = #1048#1053#1053
        DataBinding.FieldName = 'INN'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 89
      end
      object DriverCertificate: TcxGridDBColumn
        Caption = #1042#1086#1076#1080#1090#1077#1083#1100#1089#1082#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077
        DataBinding.FieldName = 'DriverCertificate'
        HeaderAlignmentVert = vaCenter
        Width = 102
      end
      object IsOfficial: TcxGridDBColumn
        Caption = #1054#1092#1086#1088#1084#1083#1077#1085' '#1086#1092#1080#1094#1080#1072#1083#1100#1085#1086
        DataBinding.FieldName = 'isOfficial'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 78
      end
      object isDateOut: TcxGridDBColumn
        Caption = #1059#1074#1086#1083#1077#1085
        DataBinding.FieldName = 'isDateOut'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object isNotCompensation: TcxGridDBColumn
        Caption = #1048#1089#1082#1083'. '#1080#1079' '#1082#1086#1084#1087#1077#1085#1089'.'
        DataBinding.FieldName = 'isNotCompensation'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1089#1082#1083#1102#1095#1080#1090#1100' '#1080#1079' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080' '#1086#1090#1087#1091#1089#1082#1072
        Options.Editing = False
        Width = 70
      end
      object BranchCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1092#1080#1083'.'
        DataBinding.FieldName = 'BranchCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object BranchName: TcxGridDBColumn
        Caption = #1060#1080#1083#1080#1072#1083
        DataBinding.FieldName = 'BranchName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object UnitName: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
        DataBinding.FieldName = 'UnitName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object UnitMobileName: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1079#1072#1103#1074#1082#1080' '#1084#1086#1073'.)'
        DataBinding.FieldName = 'UnitMobileName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'('#1079#1072#1103#1074#1082#1080' '#1084#1086#1073#1080#1083#1100#1085#1099#1081')'
        Options.Editing = False
        Width = 70
      end
      object PositionName: TcxGridDBColumn
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
        DataBinding.FieldName = 'PositionName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object InfoMoneyCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1059#1055
        DataBinding.FieldName = 'InfoMoneyCode'
        Visible = False
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 52
      end
      object InfoMoneyName_all: TcxGridDBColumn
        Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103
        DataBinding.FieldName = 'InfoMoneyName_all'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoiceInfoMoneyForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentVert = vaCenter
        Width = 126
      end
      object Comment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        HeaderAlignmentVert = vaCenter
        Width = 150
      end
      object isErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Visible = False
        HeaderAlignmentVert = vaCenter
        Width = 58
      end
      object GenderName: TcxGridDBColumn
        Caption = #1055#1086#1083
        DataBinding.FieldName = 'GenderName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object MemberSkillName: TcxGridDBColumn
        Caption = #1050#1074#1072#1083#1080#1092#1080#1082#1072#1094#1080#1103
        DataBinding.FieldName = 'MemberSkillName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object JobSourceName: TcxGridDBColumn
        Caption = #1048#1089#1090#1086#1095#1085#1080#1082' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1080' '#1086' '#1074#1072#1082#1072#1085#1089#1080#1080
        DataBinding.FieldName = 'JobSourceName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object RegionName: TcxGridDBColumn
        Caption = #1054#1073#1083#1072#1089#1090#1100', '#1072#1076#1088#1077#1089' '#1087#1088#1086#1087#1080#1089#1082#1080
        DataBinding.FieldName = 'RegionName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1054#1073#1083#1072#1089#1090#1100', '#1072#1076#1088#1077#1089' '#1087#1088#1086#1087#1080#1089#1082#1080
        Options.Editing = False
        Width = 80
      end
      object RegionName_Real: TcxGridDBColumn
        Caption = #1054#1073#1083#1072#1089#1090#1100', '#1072#1076#1088#1077#1089' '#1087#1088#1086#1078#1080#1074#1072#1085#1080#1103
        DataBinding.FieldName = 'RegionName_Real'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1054#1073#1083#1072#1089#1090#1100', '#1072#1076#1088#1077#1089' '#1087#1088#1086#1078#1080#1074#1072#1085#1080#1103
        Options.Editing = False
        Width = 80
      end
      object CityName: TcxGridDBColumn
        Caption = #1043#1086#1088#1086#1076'/'#1089#1077#1083#1086'/'#1087#1075#1090', '#1072#1076#1088#1077#1089' '#1087#1088#1086#1087#1080#1089#1082#1080
        DataBinding.FieldName = 'CityName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1043#1086#1088#1086#1076'/'#1089#1077#1083#1086'/'#1087#1075#1090', '#1072#1076#1088#1077#1089' '#1087#1088#1086#1087#1080#1089#1082#1080
        Options.Editing = False
        Width = 80
      end
      object CityName_Real: TcxGridDBColumn
        Caption = #1043#1086#1088#1086#1076'/'#1089#1077#1083#1086'/'#1087#1075#1090', '#1072#1076#1088#1077#1089' '#1087#1088#1086#1078#1080#1074#1072#1085#1080#1103
        DataBinding.FieldName = 'CityName_Real'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1043#1086#1088#1086#1076'/'#1089#1077#1083#1086'/'#1087#1075#1090', '#1072#1076#1088#1077#1089' '#1087#1088#1086#1078#1080#1074#1072#1085#1080#1103
        Options.Editing = False
        Width = 80
      end
      object Street: TcxGridDBColumn
        Caption = #1059#1083#1080#1094#1072', '#1072#1076#1088#1077#1089' '#1087#1088#1086#1087#1080#1089#1082#1080
        DataBinding.FieldName = 'Street'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1059#1083#1080#1094#1072', '#1085#1086#1084#1077#1088' '#1076#1086#1084#1072', '#1085#1086#1084#1077#1088' '#1082#1074#1072#1088#1090#1080#1088#1099', '#1072#1076#1088#1077#1089' '#1087#1088#1086#1087#1080#1089#1082#1080
        Options.Editing = False
        Width = 80
      end
      object Street_Real: TcxGridDBColumn
        Caption = #1059#1083#1080#1094#1072', '#1085#1086#1084#1077#1088' '#1076#1086#1084#1072', '#1072#1076#1088#1077#1089' '#1087#1088#1086#1078#1080#1074#1072#1085#1080#1103
        DataBinding.FieldName = 'Street_Real'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1059#1083#1080#1094#1072', '#1085#1086#1084#1077#1088' '#1076#1086#1084#1072', '#1085#1086#1084#1077#1088' '#1082#1074#1072#1088#1090#1080#1088#1099', '#1072#1076#1088#1077#1089' '#1087#1088#1086#1078#1080#1074#1072#1085#1080#1103
        Options.Editing = False
        Width = 80
      end
      object Children1: TcxGridDBColumn
        Caption = #1056#1077#1073#1077#1085#1086#1082' 1, '#1060#1048#1054
        DataBinding.FieldName = 'Children1'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object Children2: TcxGridDBColumn
        Caption = #1056#1077#1073#1077#1085#1086#1082' 2, '#1060#1048#1054
        DataBinding.FieldName = 'Children2'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object Children3: TcxGridDBColumn
        Caption = #1056#1077#1073#1077#1085#1086#1082' 3, '#1060#1048#1054
        DataBinding.FieldName = 'Children3'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object Children4: TcxGridDBColumn
        Caption = #1056#1077#1073#1077#1085#1086#1082' 4, '#1060#1048#1054
        DataBinding.FieldName = 'Children4'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object Children5: TcxGridDBColumn
        Caption = #1056#1077#1073#1077#1085#1086#1082' 5, '#1060#1048#1054
        DataBinding.FieldName = 'Children5'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object Birthday_Date: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1088#1086#1078#1076#1077#1085#1080#1103
        DataBinding.FieldName = 'Birthday_Date'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1072#1089#1087#1086#1088#1090', '#1076#1072#1090#1072' '#1088#1086#1078#1076#1077#1085#1080#1103
        Options.Editing = False
        Width = 80
      end
      object Birthday_Month: TcxGridDBColumn
        Caption = #1052#1077#1089#1103#1094' '#1088#1086#1078#1076#1077#1085#1080#1103
        DataBinding.FieldName = 'Birthday_Date'
        PropertiesClassName = 'TcxDateEditProperties'
        Properties.DisplayFormat = 'MMMM'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object Children1_Date: TcxGridDBColumn
        Caption = #1056#1077#1073#1077#1085#1086#1082' 1, '#1076#1072#1090#1072' '#1088#1086#1078#1076#1077#1085#1080#1103
        DataBinding.FieldName = 'Children1_Date'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object Children2_Date: TcxGridDBColumn
        Caption = #1056#1077#1073#1077#1085#1086#1082' 2, '#1076#1072#1090#1072' '#1088#1086#1078#1076#1077#1085#1080#1103
        DataBinding.FieldName = 'Children2_Date'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object Children3_Date: TcxGridDBColumn
        Caption = #1056#1077#1073#1077#1085#1086#1082' 3, '#1076#1072#1090#1072' '#1088#1086#1078#1076#1077#1085#1080#1103
        DataBinding.FieldName = 'Children3_Date'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object Children4_Date: TcxGridDBColumn
        Caption = #1056#1077#1073#1077#1085#1086#1082' 4, '#1076#1072#1090#1072' '#1088#1086#1078#1076#1077#1085#1080#1103
        DataBinding.FieldName = 'Children4_Date'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object Children5_Date: TcxGridDBColumn
        Caption = #1056#1077#1073#1077#1085#1086#1082' 5, '#1076#1072#1090#1072' '#1088#1086#1078#1076#1077#1085#1080#1103
        DataBinding.FieldName = 'Children5_Date'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object PSP_StartDate: TcxGridDBColumn
        Caption = #1055#1072#1089#1087#1086#1088#1090', '#1089#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1089
        DataBinding.FieldName = 'PSP_StartDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1072#1089#1087#1086#1088#1090', '#1089#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1089
        Options.Editing = False
        Width = 80
      end
      object PSP_EndDate: TcxGridDBColumn
        Caption = #1055#1072#1089#1087#1086#1088#1090', '#1089#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1087#1086
        DataBinding.FieldName = 'PSP_EndDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1072#1089#1087#1086#1088#1090', '#1089#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1087#1086
        Options.Editing = False
        Width = 80
      end
      object Dekret_StartDate: TcxGridDBColumn
        Caption = #1044#1077#1082#1088#1077#1090' '#1089
        DataBinding.FieldName = 'Dekret_StartDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1077#1082#1088#1077#1090' '#1089
        Options.Editing = False
        Width = 80
      end
      object Dekret_EndDate: TcxGridDBColumn
        Caption = #1044#1077#1082#1088#1077#1090' '#1087#1086
        DataBinding.FieldName = 'Dekret_EndDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1077#1082#1088#1077#1090' '#1087#1086
        Options.Editing = False
        Width = 80
      end
      object Law: TcxGridDBColumn
        Caption = #1057#1091#1076#1080#1084#1086#1089#1090#1080
        DataBinding.FieldName = 'Law'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1057#1091#1076#1080#1084#1086#1089#1090#1080
        Options.Editing = False
        Width = 80
      end
      object DriverCertificateAdd: TcxGridDBColumn
        Caption = #1042#1086#1076#1080#1090'. '#1091#1076#1086#1089#1090'-'#1085#1080#1077' '#1076#1083#1103' '#1074#1086#1078#1076#1077#1085#1080#1103' '#1082#1072#1088#1099' '#1080' '#1090'.'#1087'.'
        DataBinding.FieldName = 'DriverCertificateAdd'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1086#1076#1080#1090#1077#1083#1100#1089#1082#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077' '#1076#1083#1103' '#1074#1086#1078#1076#1077#1085#1080#1103' '#1082#1072#1088#1099' '#1080' '#1090'.'#1087'.'
        Options.Editing = False
        Width = 80
      end
      object PSP_S: TcxGridDBColumn
        Caption = #1055#1072#1089#1087#1086#1088#1090', '#1089#1077#1088#1080#1103
        DataBinding.FieldName = 'PSP_S'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1072#1089#1087#1086#1088#1090', '#1089#1077#1088#1080#1103
        Options.Editing = False
        Width = 80
      end
      object PSP_N: TcxGridDBColumn
        Caption = #1055#1072#1089#1087#1086#1088#1090', '#1085#1086#1084#1077#1088
        DataBinding.FieldName = 'PSP_N'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1072#1089#1087#1086#1088#1090', '#1085#1086#1084#1077#1088
        Options.Editing = False
        Width = 80
      end
      object PSP_W: TcxGridDBColumn
        Caption = #1055#1072#1089#1087#1086#1088#1090', '#1082#1077#1084' '#1074#1099#1076#1072#1085
        DataBinding.FieldName = 'PSP_W'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1072#1089#1087#1086#1088#1090', '#1082#1077#1084' '#1074#1099#1076#1072#1085
        Options.Editing = False
        Width = 80
      end
      object PSP_D: TcxGridDBColumn
        Caption = #1055#1072#1089#1087#1086#1088#1090', '#1076#1072#1090#1072' '#1074#1099#1076#1072#1095#1080
        DataBinding.FieldName = 'PSP_D'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1072#1089#1087#1086#1088#1090', '#1076#1072#1090#1072' '#1074#1099#1076#1072#1095#1080
        Options.Editing = False
        Width = 80
      end
      object Card_search: TcxGridDBColumn
        Caption = #8470' '#1073#1072#1085#1082'. '#1082#1072#1088#1090#1086#1095#1082#1080' '#1047#1055' ('#1087#1086#1080#1089#1082')'
        DataBinding.FieldName = 'Card_search'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object CardIBAN_search: TcxGridDBColumn
        Caption = #8470' '#1082#1072#1088#1090'. '#1089#1095#1077#1090#1072' IBAN '#1047#1055' ('#1087#1086#1080#1089#1082')'
        DataBinding.FieldName = 'CardIBAN_search'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object CardBank_search: TcxGridDBColumn
        Caption = #8470' '#1073#1072#1085#1082'. '#1082#1072#1088#1090#1086#1095#1082#1080' '#1047#1055' ('#1087#1086#1080#1089#1082')'
        DataBinding.FieldName = 'CardBank_search'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object Phone: TcxGridDBColumn
        Caption = #1058#1077#1083#1077#1092#1086#1085
        DataBinding.FieldName = 'Phone'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object RouteNumName: TcxGridDBColumn
        Caption = #1052#1072#1088#1096#1088#1091#1090#1082#1072
        DataBinding.FieldName = 'RouteNumName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object cxLabel6: TcxLabel
    Left = 796
    Top = 101
    Caption = #1091#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1074#1089#1077#1084':'
  end
  object edBankUpDate: TcxButtonEdit
    Left = 796
    Top = 116
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 2
    Text = #1042#1099#1073#1077#1088#1080#1090#1077' '#1073#1072#1085#1082
    Width = 117
  end
  object Panel: TPanel
    Left = 0
    Top = 0
    Width = 1056
    Height = 70
    Align = alTop
    TabOrder = 7
    object cxLabel13: TcxLabel
      Left = 193
      Top = 9
      Caption = #1041#1072#1085#1082' -'#1060'2 ('#1042#1086#1089#1090#1086#1082')'
    end
    object edBankSecond: TcxButtonEdit
      Left = 292
      Top = 8
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 131
    end
    object cxLabel1: TcxLabel
      Left = 3
      Top = 9
      Caption = #1041#1072#1085#1082' ('#1060'1)'
    end
    object edBank: TcxButtonEdit
      Left = 56
      Top = 8
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 131
    end
    object cxLabel2: TcxLabel
      Left = 429
      Top = 9
      Caption = #1041#1072#1085#1082' - '#1060'2('#1054#1058#1055')'
    end
    object edBankSecondTwo: TcxButtonEdit
      Left = 509
      Top = 8
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 131
    end
    object cxLabel3: TcxLabel
      Left = 646
      Top = 9
      Caption = #1041#1072#1085#1082' - '#1060'2('#1083#1080#1095#1085#1099#1081')'
    end
    object edBankSecondDiff: TcxButtonEdit
      Left = 746
      Top = 8
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 131
    end
    object cxLabel4: TcxLabel
      Left = 11
      Top = 42
      Caption = #1055#1086#1080#1089#1082' '#8470' '#1082#1072#1088#1090'. '#1089#1095#1077#1090#1072':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edCard_search: TcxTextEdit
      Left = 164
      Top = 43
      TabOrder = 9
      DesignSize = (
        132
        21)
      Width = 132
    end
    object cxLabel5: TcxLabel
      Left = 310
      Top = 42
      Caption = #8470' '#1082#1072#1088#1090'. '#1089#1095#1077#1090#1072' IBAN:'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edCardIBAN_search: TcxTextEdit
      Left = 453
      Top = 43
      TabOrder = 11
      DesignSize = (
        120
        21)
      Width = 120
    end
    object edCardBank_search: TcxTextEdit
      Left = 717
      Top = 43
      TabOrder = 12
      DesignSize = (
        120
        21)
      Width = 120
    end
    object cxLabel7: TcxLabel
      Left = 584
      Top = 42
      Caption = #8470' '#1073#1072#1085#1082'. '#1082#1072#1088#1090#1086#1095#1082#1080':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 56
    Top = 104
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 48
    Top = 160
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
    Left = 256
    Top = 112
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
    Left = 168
    Top = 104
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
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'bbEdit'
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
          BeginGroup = True
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
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateIsOfficial'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_GLN'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateBank'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateBankSecond'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbsLoad'
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
    object bbInsert: TdxBarButton
      Action = actInsert
      Category = 0
    end
    object bbEdit: TdxBarButton
      Action = actUpdate
      Category = 0
    end
    object bbErased: TdxBarButton
      Action = dsdSetErased
      Category = 0
    end
    object bbUnErased: TdxBarButton
      Action = dsdSetUnErased
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
    object bbUpdateIsOfficial: TdxBarButton
      Action = actUpdateIsOfficial
      Category = 0
    end
    object bbProtocolOpenForm: TdxBarButton
      Action = ProtocolOpenForm
      Category = 0
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel6
    end
    object dxBarControlContainerItem2: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = edBankUpDate
    end
    object bbUpdateBank: TdxBarButton
      Action = macUpdateBankAll
      Category = 0
    end
    object bbUpdateBankSecond: TdxBarButton
      Action = macUpdateBankSecondAll
      Category = 0
    end
    object bbStartLoad: TdxBarButton
      Action = macStartLoad
      Category = 0
      ImageIndex = 49
    end
    object bbStartLoadSecond: TdxBarButton
      Action = macStartLoadSecond
      Category = 0
      ImageIndex = 68
    end
    object bbStartLoadIBAN: TdxBarButton
      Action = macStartLoadIBAN
      Category = 0
    end
    object bbStartLoadIBANSecond: TdxBarButton
      Action = macStartLoadIBANSecond
      Category = 0
    end
    object bbUpdate_GLN: TdxBarButton
      Action = actUpdateActionGLN
      Category = 0
    end
    object bbsLoad: TdxBarSubItem
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 27
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbStartLoad'
        end
        item
          Visible = True
          ItemName = 'bbStartLoadSecond'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbStartLoadIBAN'
        end
        item
          Visible = True
          ItemName = 'bbStartLoadIBANSecond'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbStartLoadCardF1'
        end
        item
          Visible = True
          ItemName = 'bbStartLoadCardF2'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbStartLoadPhone'
        end>
    end
    object bbStartLoadCardF1: TdxBarButton
      Action = macStartLoadCardF1
      Category = 0
    end
    object bbStartLoadCardF2: TdxBarButton
      Action = macStartLoadCardF2
      Category = 0
    end
    object dxBarSeparator1: TdxBarSeparator
      Caption = 'Separator1'
      Category = 0
      Hint = 'Separator1'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbStartLoadPhone: TdxBarButton
      Action = macStartLoadPhone
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 288
    Top = 160
    object actRefreshedit: TdsdDataSetRefresh
      Category = 'GLN'
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
      RefreshOnTabSetChanges = True
    end
    object actDoLoad: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inBankId'
          Value = '0'
          Component = GuidesBankUpdate
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actUpdateActionGLN: TdsdInsertUpdateAction
      Category = 'GLN'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' GLN'
      ImageIndex = 77
      FormName = 'TMemberGLNEditForm'
      FormNameParam.Value = 'TMemberGLNEditForm'
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
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object macStartLoad: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#8470' '#1082#1072#1088#1090' '#1089#1095#1077#1090#1072' '#1047#1055' ('#1060'1)?'
      InfoAfterExecute = #1047#1072#1075#1088#1091#1079#1082#1072' '#1074#1099#1087#1086#1083#1085#1077#1085#1072
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1077#1083#1103' '#8470' '#1082#1072#1088#1090' '#1089#1095#1077#1090#1072' '#1047#1055' ('#1060'1)'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1077#1083#1103' '#8470' '#1082#1072#1088#1090' '#1089#1095#1077#1090#1072' '#1047#1055' ('#1060'1)'
      ImageIndex = 41
    end
    object actGetImportSettingIBAN: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingIdIBAN
      StoredProcList = <
        item
          StoredProc = spGetImportSettingIdIBAN
        end>
      Caption = 'actGetImportSettingIBAN'
    end
    object actGetImportSetting: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId
        end>
      Caption = 'actGetImportSetting'
    end
    object macStartLoadSecond: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSettingSecond
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#8470' '#1082#1072#1088#1090' '#1089#1095#1077#1090#1072' '#1047#1055' ('#1060'2)?'
      InfoAfterExecute = #1047#1072#1075#1088#1091#1079#1082#1072' '#1074#1099#1087#1086#1083#1085#1077#1085#1072
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1077#1083#1103' '#8470' '#1082#1072#1088#1090' '#1089#1095#1077#1090#1072' '#1047#1055' ('#1060'2)'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1077#1083#1103' '#8470' '#1082#1072#1088#1090' '#1089#1095#1077#1090#1072' '#1047#1055' ('#1060'2)'
      ImageIndex = 41
    end
    object macStartLoadIBAN: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSettingIBAN
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#8470' '#1082#1072#1088#1090'. '#1089#1095#1077#1090#1072' IBAN '#1047#1055' ('#1060'1)?'
      InfoAfterExecute = #1047#1072#1075#1088#1091#1079#1082#1072' '#1074#1099#1087#1086#1083#1085#1077#1085#1072
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1077#1083#1103' '#8470' '#1082#1072#1088#1090' '#1089#1095#1077#1090#1072' IBAN '#1047#1055' ('#1060'1)'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1077#1083#1103' '#8470' '#1082#1072#1088#1090' '#1089#1095#1077#1090#1072' IBAN '#1047#1055' ('#1060'1)'
      ImageIndex = 69
    end
    object actGetImportSettingSecond: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingIdSecond
      StoredProcList = <
        item
          StoredProc = spGetImportSettingIdSecond
        end>
      Caption = 'actGetImportSetting'
    end
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
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TMemberEditForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TMemberEditForm'
      FormNameParam.Value = ''
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
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actChoiceBankChildForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'BankChildChoiceForm'
      FormName = 'TBankForm'
      FormNameParam.Value = 'TBankForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'BankChildId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'BankChildName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoiceBankSecondForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'BankSecondChoiceForm'
      FormName = 'TBankForm'
      FormNameParam.Value = 'TBankForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'BankSecondId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'BankSecondName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoiceBankSecondTwoForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'BankSecondTwoChoiceForm'
      FormName = 'TBankForm'
      FormNameParam.Value = 'TBankForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'BankSecondTwoId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'BankSecondTwoName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoiceBankSecondDiffForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'BankSecondDiffChoiceForm'
      FormName = 'TBankForm'
      FormNameParam.Value = 'TBankForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'BankSecondDiffId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'BankSecondDiffName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoiceBankForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'BankChoiceForm'
      FormName = 'TBankForm'
      FormNameParam.Value = 'TBankForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'BankId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'BankName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoiceInfoMoneyForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'InfoMoneyChoiceForm'
      FormName = 'TInfoMoney_ObjectForm'
      FormNameParam.Value = 'TInfoMoney_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'InfoMoneyId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'InfoMoneyName_all'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyCode'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'InfoMoneyCode'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
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
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
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
      ShortCut = 32776
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DataSource
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
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Code'
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
    object macUpdate_GLN: TMultiAction
      Category = 'GLN'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogGLN
        end
        item
          Action = actUpdate_GLN
        end
        item
          Action = actRefresh
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' GLN '#1092#1080#1079'.'#1083#1080#1094#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' GLN '#1092#1080#1079'.'#1083#1080#1094#1072
      ImageIndex = 77
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'actUpdateDataSet'
      DataSource = DataSource
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
    object actUpdateIsOfficial: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateIsOfficial
      StoredProcList = <
        item
          StoredProc = spUpdateIsOfficial
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1054#1092#1080#1094#1080#1072#1083#1100#1085#1086' '#1044#1072'/'#1053#1077#1090'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1054#1092#1080#1094#1080#1072#1083#1100#1085#1086' '#1044#1072'/'#1053#1077#1090'"'
      ImageIndex = 52
    end
    object actUpdateBankSecond: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateBankSecond
      StoredProcList = <
        item
          StoredProc = spUpdateBankSecond
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1073#1072#1085#1082' '#1060'1'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1073#1072#1085#1082' '#1060'1'
    end
    object ExecuteDialogGLN: TExecuteDialog
      Category = 'GLN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = 'GLN '
      Hint = 'GLN'
      ImageIndex = 77
      FormName = 'TMemberGLNDialogForm'
      FormNameParam.Value = 'TMemberGLNDialogForm'
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
          Name = 'inGLN'
          Value = Null
          Component = FormParams
          ComponentItem = 'inGLN'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Code'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Value = Null
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdateBank: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateBank
      StoredProcList = <
        item
          StoredProc = spUpdateBank
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1073#1072#1085#1082' '#1060'1'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1073#1072#1085#1082' '#1060'1'
    end
    object macUpdateBankSecondAll: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdateBankSecond
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1091#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' <'#1041#1072#1085#1082' ('#1060'2)> '#1076#1083#1103' '#1042#1057#1045#1061' ?'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1041#1072#1085#1082' ('#1060'2)'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1041#1072#1085#1082' ('#1060'2)'
      ImageIndex = 48
    end
    object macUpdateBankSecond: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateBankSecond
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1041#1072#1085#1082' ('#1060'2)'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1041#1072#1085#1082' ('#1060'2)'
      ImageIndex = 77
    end
    object macUpdateBankAll: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdateBank
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1091#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' <'#1041#1072#1085#1082' ('#1060'1)> '#1076#1083#1103' '#1042#1057#1045#1061' ?'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1041#1072#1085#1082' ('#1060'1)'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1041#1072#1085#1082' ('#1060'1)'
      ImageIndex = 47
    end
    object macUpdateBank: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateBank
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1041#1072#1085#1082' ('#1060'1)'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1041#1072#1085#1082' ('#1060'1)'
      ImageIndex = 76
    end
    object macStartLoadIBANSecond: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSettingIBANSecond
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#8470' '#1082#1072#1088#1090' '#1089#1095#1077#1090#1072' IBAN '#1047#1055' ('#1060'2)?'
      InfoAfterExecute = #1047#1072#1075#1088#1091#1079#1082#1072' '#1074#1099#1087#1086#1083#1085#1077#1085#1072
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1077#1083#1103' '#8470' '#1082#1072#1088#1090' '#1089#1095#1077#1090#1072' IBAN '#1047#1055' ('#1060'2)'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1077#1083#1103' '#8470' '#1082#1072#1088#1090' '#1089#1095#1077#1090#1072' IBAN '#1047#1055' ('#1060'2)'
      ImageIndex = 70
    end
    object actGetImportSettingIBANSecond: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingIdIBANSecond
      StoredProcList = <
        item
          StoredProc = spGetImportSettingIdIBANSecond
        end>
      Caption = 'actGetImportSetting'
    end
    object actUpdate_GLN: TdsdExecStoredProc
      Category = 'GLN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_GLN
      StoredProcList = <
        item
          StoredProc = spUpdate_GLN
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' GLN '#1092#1080#1079'.'#1083#1080#1094#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' GLN '#1092#1080#1079'.'#1083#1080#1094#1072
      ImageIndex = 77
    end
    object macStartLoadCardF1: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSettingIdCard1
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#8470' '#1073#1072#1085#1082'. '#1082#1072#1088#1090#1086#1095#1082#1080' ('#1060'1)?'
      InfoAfterExecute = #1047#1072#1075#1088#1091#1079#1082#1072' '#1074#1099#1087#1086#1083#1085#1077#1085#1072
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1077#1083#1103' '#8470' '#1073#1072#1085#1082'. '#1082#1072#1088#1090#1086#1095#1082#1080' ('#1060'1)'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1077#1083#1103' '#8470' '#1073#1072#1085#1082'. '#1082#1072#1088#1090#1086#1095#1082#1080' ('#1060'1)'
      ImageIndex = 71
    end
    object actGetImportSettingIdCard1: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingIdCardF1
      StoredProcList = <
        item
          StoredProc = spGetImportSettingIdCardF1
        end>
      Caption = 'actGetImportSettingIBAN'
    end
    object macStartLoadCardF2: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSettingIdCard2
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#8470' '#1073#1072#1085#1082'. '#1082#1072#1088#1090#1086#1095#1082#1080' ('#1060'2)?'
      InfoAfterExecute = #1047#1072#1075#1088#1091#1079#1082#1072' '#1074#1099#1087#1086#1083#1085#1077#1085#1072
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1077#1083#1103' '#8470' '#1073#1072#1085#1082'. '#1082#1072#1088#1090#1086#1095#1082#1080' ('#1060'2)'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1077#1083#1103' '#8470' '#1073#1072#1085#1082'. '#1082#1072#1088#1090#1086#1095#1082#1080' ('#1060'2)'
      ImageIndex = 73
    end
    object actGetImportSettingIdCard2: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingIdCardF2
      StoredProcList = <
        item
          StoredProc = spGetImportSettingIdCardF2
        end>
      Caption = 'actGetImportSettingIBAN'
    end
    object macStartLoadPhone: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSettingId_Phone
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1085#1086#1084#1077#1088#1086#1074' '#1090#1077#1083#1077#1092#1086#1085#1086#1074'?'
      InfoAfterExecute = #1047#1072#1075#1088#1091#1079#1082#1072' '#1074#1099#1087#1086#1083#1085#1077#1085#1072
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1077#1083#1103' '#1085#1086#1084#1077#1088' '#1090#1077#1083#1077#1092#1086#1085#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1077#1083#1103' '#1085#1086#1084#1077#1088' '#1090#1077#1083#1077#1092#1086#1085#1072
      ImageIndex = 50
    end
    object actGetImportSettingId_Phone: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId_phone
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId_phone
        end>
      Caption = 'actGetImportSettingPhone'
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Member'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inIsShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 48
    Top = 216
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 168
    Top = 160
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
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
    Left = 288
    Top = 208
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
        Action = actUpdate
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        Action = actUpdate
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
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 328
    Top = 264
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Member'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Code'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsOfficial'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isOfficial'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsNotCompensation'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'IsNotCompensation'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inINN'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'INN'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDriverCertificate'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'DriverCertificate'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCard'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Card'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCardSecond'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'CardSecond'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCardChild'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'CardChild'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCardIBAN'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'CardIBAN'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCardIBANSecond'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'CardIBANSecond'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCardBank'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'CardBank'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCardBankSecond'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'CardBankSecond'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCardBankSecondTwo'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'CardBankSecondTwo'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCardIBANSecondTwo'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'CardIBANSecondTwo'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCardSecondTwo'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'CardSecondTwo'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCardBankSecondDiff'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'CardBankSecondDiff'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCardIBANSecondDiff'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'CardIBANSecondDiff'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCardSecondDiff'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'CardSecondDiff'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPhone'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Phone'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankId_Top'
        Value = Null
        Component = GuidesBank
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankSecondId_Top'
        Value = Null
        Component = GuidesBankSecond
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankSecondTwoId_Top'
        Value = Null
        Component = GuidesBankSecondTwo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankSecondDiffId_Top'
        Value = Null
        Component = GuidesBankSecondDiff
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BankId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankSecondId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BankSecondId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankChildId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BankChildId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankSecondTwoId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BankSecondTwoId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankSecondDiffId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BankSecondDiffId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'InfoMoneyId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitMobileId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'UnitMobileId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBankName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BankName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBankSecondName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BankSecondName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBankSecondTwoName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BankSecondTwoName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBankSecondDiffName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BankSecondDiffName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 560
    Top = 152
  end
  object spUpdateIsOfficial: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Member_isOfficial'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId '
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioIsOfficial'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'IsOfficial'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 232
    Top = 379
  end
  object spUpdateBank: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Member_Banks'
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
        Name = 'inBankId'
        Value = Null
        Component = GuidesBankUpdate
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = 'zc_ObjectLink_Member_Bank'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBankName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BankName'
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 576
    Top = 267
  end
  object GuidesBankUpdate: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBankUpDate
    FormNameParam.Value = 'TBankForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBankUpdate
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBankUpdate
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 840
    Top = 120
  end
  object spUpdateBankSecond: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Member_Banks'
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
        Name = 'inBankId'
        Value = ''
        Component = GuidesBankUpdate
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = 'zc_ObjectLink_Member_BankSecond'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBankName'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BankSecondName'
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 576
    Top = 315
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingIsUploadId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingIsSpecConditionId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 360
    Top = 336
  end
  object spGetImportSettingId: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TMemberForm;zc_Object_ImportSetting_MemberZP1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 960
    Top = 200
  end
  object spGetImportSettingIdSecond: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TMemberForm;zc_Object_ImportSetting_MemberZP2'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 448
    Top = 144
  end
  object spGetImportSettingIdIBAN: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TMemberForm;zc_Object_ImportSetting_MemberIBANZP1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 664
    Top = 200
  end
  object spGetImportSettingIdIBANSecond: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TMemberForm;zc_Object_ImportSetting_MemberIBANZP2'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 688
    Top = 256
  end
  object spUpdate_GLN: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Member_GLN'
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
        Name = 'inGLN'
        Value = Null
        Component = FormParams
        ComponentItem = 'inGLN'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 448
    Top = 296
  end
  object spGetImportSettingIdCardF1: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TMemberForm;zc_Object_ImportSetting_MemberCardF1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 856
    Top = 216
  end
  object spGetImportSettingIdCardF2: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TMemberForm;zc_Object_ImportSetting_MemberCardF2'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 856
    Top = 288
  end
  object GuidesBankSecond: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBankSecond
    FormNameParam.Value = 'TBankForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBankSecond
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBankSecond
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 296
    Top = 65535
  end
  object GuidesBank: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBank
    FormNameParam.Value = 'TBankForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBank
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBank
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 80
    Top = 65535
  end
  object GuidesBankSecondTwo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBankSecondTwo
    FormNameParam.Value = 'TBankForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBankSecondTwo
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBankSecondTwo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 536
    Top = 65535
  end
  object GuidesBankSecondDiff: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBankSecondDiff
    FormNameParam.Value = 'TBankForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBankSecondDiff
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBankSecondDiff
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 776
    Top = 7
  end
  object FieldFilter_Card: TdsdFieldFilter
    TextEdit = edCard_search
    DataSet = ClientDataSet
    Column = Card_search
    ColumnList = <
      item
        Column = Card_search
      end
      item
        Column = CardIBAN_search
        TextEdit = edCardIBAN_search
      end
      item
        Column = CardBank_search
        TextEdit = edCardBank_search
      end>
    ActionNumber1 = dsdChoiceGuides
    CheckBoxList = <>
    Left = 144
    Top = 280
  end
  object spGetImportSettingId_phone: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TMemberForm;zc_Object_ImportSetting_MemberPhone'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 960
    Top = 264
  end
end
