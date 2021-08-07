object MemberForm: TMemberForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1060#1080#1079#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072'>'
  ClientHeight = 458
  ClientWidth = 777
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
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 26
    Width = 777
    Height = 432
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
      object Name: TcxGridDBColumn
        Caption = #1060#1048#1054
        DataBinding.FieldName = 'Name'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 126
      end
      object Card: TcxGridDBColumn
        Caption = #8470' '#1082#1072#1088#1090'. '#1089#1095#1077#1090#1072' '#1047#1055' ('#1060'1)'
        DataBinding.FieldName = 'Card'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 115
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
      object CardSecond: TcxGridDBColumn
        Caption = #8470' '#1082#1072#1088#1090'.'#1089#1095#1077#1090#1072' '#1047#1055' ('#1060'2)'
        DataBinding.FieldName = 'CardSecond'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 140
      end
      object BankSecondName: TcxGridDBColumn
        Caption = #1041#1072#1085#1082' ('#1060'2)'
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
      object CardIBAN: TcxGridDBColumn
        Caption = #8470' '#1082#1072#1088#1090'. '#1089#1095#1077#1090#1072' IBAN '#1047#1055' ('#1060'1)'
        DataBinding.FieldName = 'CardIBAN'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 115
      end
      object CardIBANSecond: TcxGridDBColumn
        Caption = #8470' '#1082#1072#1088#1090'. '#1089#1095#1077#1090#1072' IBAN '#1047#1055' ('#1060'2)'
        DataBinding.FieldName = 'CardIBANSecond'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 140
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
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object cxLabel6: TcxLabel
    Left = 241
    Top = 77
    Caption = #1091#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1074#1089#1077#1084':'
  end
  object edBank: TcxButtonEdit
    Left = 340
    Top = 76
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Text = #1042#1099#1073#1077#1088#1080#1090#1077' '#1073#1072#1085#1082
    Width = 151
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
          ItemName = 'bbStartLoad'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbStartLoadSecond'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbStartLoadIBAN'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbStartLoadIBANSecond'
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
      Control = edBank
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
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 288
    Top = 160
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
          Component = BankGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
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
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1082#1083#1103' '#8470' '#1082#1072#1088#1090' '#1089#1095#1077#1090#1072' '#1047#1055' ('#1060'1)'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1082#1083#1103' '#8470' '#1082#1072#1088#1090' '#1089#1095#1077#1090#1072' '#1047#1055' ('#1060'1)'
      ImageIndex = 41
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
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1082#1083#1103' '#8470' '#1082#1072#1088#1090' '#1089#1095#1077#1090#1072' '#1047#1055' ('#1060'2)'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1082#1083#1103' '#8470' '#1082#1072#1088#1090' '#1089#1095#1077#1090#1072' '#1047#1055' ('#1060'2)'
      ImageIndex = 41
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
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1082#1083#1103' '#8470' '#1082#1072#1088#1090' '#1089#1095#1077#1090#1072' IBAN '#1047#1055' ('#1060'1)'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1082#1083#1103' '#8470' '#1082#1072#1088#1090' '#1089#1095#1077#1090#1072' IBAN '#1047#1055' ('#1060'1)'
      ImageIndex = 69
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
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1082#1083#1103' '#8470' '#1082#1072#1088#1090' '#1089#1095#1077#1090#1072' IBAN '#1047#1055' ('#1060'2)'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1082#1083#1103' '#8470' '#1082#1072#1088#1090' '#1089#1095#1077#1090#1072' IBAN '#1047#1055' ('#1060'2)'
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
        Name = 'inComment'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Comment'
        DataType = ftString
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
        Name = 'inInfoMoneyId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'InfoMoneyId'
        ParamType = ptInput
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
        Component = BankGuides
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
  object BankGuides: TdsdGuides
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
        Component = BankGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BankGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 352
    Top = 80
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
        Component = BankGuides
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
    Left = 488
    Top = 216
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
    Left = 672
    Top = 72
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
    Left = 680
    Top = 128
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
    Left = 680
    Top = 216
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
    Left = 672
    Top = 272
  end
end
