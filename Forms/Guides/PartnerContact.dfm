object PartnerContactForm: TPartnerContactForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' ('#1080#1079#1084#1077#1085#1077#1085#1080#1077' '#1050#1086#1085#1090#1072#1082#1090#1086#1074')>'
  ClientHeight = 464
  ClientWidth = 1362
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
    Top = 61
    Width = 1362
    Height = 403
    Align = alClient
    TabOrder = 0
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1057#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = Name
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsSelection.InvertSelect = False
      OptionsView.Footer = True
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object Id: TcxGridDBColumn
        Caption = #1050#1083#1102#1095'-2'
        DataBinding.FieldName = 'Id'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Default = True
            Enabled = False
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object LastDocName: TcxGridDBColumn
        Caption = #1044#1086#1082#1091#1084#1077#1085#1090' ('#1085#1072#1079#1074#1072#1085#1080#1077')'
        DataBinding.FieldName = 'LastDocName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object PaidKindName: TcxGridDBColumn
        Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099' ('#1076#1086#1082#1091#1084#1077#1085#1090')'
        DataBinding.FieldName = 'PaidKindName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object DocBranchName: TcxGridDBColumn
        Caption = #1060#1080#1083#1080#1072#1083' ('#1076#1086#1082#1091#1084#1077#1085#1090')'
        DataBinding.FieldName = 'DocBranchName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object Code: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 40
      end
      object Name: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 120
      end
      object Address: TcxGridDBColumn
        Caption = #1040#1076#1088#1077#1089
        DataBinding.FieldName = 'Address'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 200
      end
      object ShortName: TcxGridDBColumn
        Caption = #1059#1089#1083#1086#1074#1085#1086#1077' '#1086#1073#1086#1079#1085#1072#1095#1077#1085#1080#1077
        DataBinding.FieldName = 'ShortName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object JuridicalGroupName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1102#1088'. '#1083'.'
        DataBinding.FieldName = 'JuridicalGroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object JuridicalName: TcxGridDBColumn
        Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
        DataBinding.FieldName = 'JuridicalName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 120
      end
      object OKPO: TcxGridDBColumn
        Caption = #1054#1050#1055#1054
        DataBinding.FieldName = 'OKPO'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object AreaName: TcxGridDBColumn
        Caption = #1056#1077#1075#1080#1086#1085
        DataBinding.FieldName = 'AreaName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = AreaChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object RetailName: TcxGridDBColumn
        Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
        DataBinding.FieldName = 'RetailName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object RouteName: TcxGridDBColumn
        Caption = #1052#1072#1088#1096#1088#1091#1090
        DataBinding.FieldName = 'RouteName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object PartnerTagName: TcxGridDBColumn
        Caption = #1055#1088#1080#1079#1085#1072#1082' '#1090#1086#1088#1075#1086#1074#1086#1081' '#1090#1086#1095#1082#1080
        DataBinding.FieldName = 'PartnerTagName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = PartnerTagChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 120
      end
      object BranchName_Personal: TcxGridDBColumn
        Caption = #1060#1080#1083#1080#1072#1083' ('#1089#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088')'
        DataBinding.FieldName = 'BranchName_Personal'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object UnitName_Personal: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1089#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088')'
        DataBinding.FieldName = 'UnitName_Personal'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object PersonalName: TcxGridDBColumn
        Caption = #1060#1048#1054' '#1089#1086#1090#1088#1091#1076#1085#1080#1082' ('#1089#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088')'
        DataBinding.FieldName = 'PersonalName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = PersonalChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 120
      end
      object PositionName_Personal: TcxGridDBColumn
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1089#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088')'
        DataBinding.FieldName = 'PositionName_Personal'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object UnitName_PersonalTrade: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1058#1055')'
        DataBinding.FieldName = 'UnitName_PersonalTrade'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object PersonalTradeName: TcxGridDBColumn
        Caption = #1060#1048#1054' '#1089#1086#1090#1088#1091#1076#1085#1080#1082' ('#1058#1055')'
        DataBinding.FieldName = 'PersonalTradeName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = PersonalTradeChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 120
      end
      object PositionName_PersonalTrade: TcxGridDBColumn
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1058#1055')'
        DataBinding.FieldName = 'PositionName_PersonalTrade'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object PersonalMerchName: TcxGridDBColumn
        Caption = #1060#1048#1054' '#1089#1086#1090#1088#1091#1076#1085#1080#1082' ('#1084#1077#1088#1095#1072#1085#1076#1072#1081#1079#1077#1088')'
        DataBinding.FieldName = 'PersonalMerchName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 120
      end
      object PositionName_PersonalMerch: TcxGridDBColumn
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1084#1077#1088#1095#1072#1085#1076#1072#1081#1079#1077#1088')'
        DataBinding.FieldName = 'PositionName_PersonalMerch'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object UnitName_PersonalMerch: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1084#1077#1088#1095#1072#1085#1076#1072#1081#1079#1077#1088')'
        DataBinding.FieldName = 'UnitName_PersonalMerch'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object MemberTakeName: TcxGridDBColumn
        Caption = #1060#1048#1054' ('#1101#1082#1089#1087#1077#1076#1080#1090#1086#1088')'
        DataBinding.FieldName = 'MemberTakeName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = MemberTakeChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object RegionName: TcxGridDBColumn
        Caption = #1054#1073#1083#1072#1089#1090#1100
        DataBinding.FieldName = 'RegionName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object ProvinceName: TcxGridDBColumn
        Caption = #1056#1072#1081#1086#1085
        DataBinding.FieldName = 'ProvinceName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object CityKindName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1085'.'#1087'.'
        DataBinding.FieldName = 'CityKindName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = CityKindChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 40
      end
      object CityName: TcxGridDBColumn
        Caption = #1053#1072#1089#1077#1083#1077#1085#1085#1099#1081' '#1087#1091#1085#1082#1090
        DataBinding.FieldName = 'CityName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object ProvinceCityName: TcxGridDBColumn
        Caption = #1052#1080#1082#1088#1086#1088#1072#1081#1086#1085
        DataBinding.FieldName = 'ProvinceCityName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object StreetKindName: TcxGridDBColumn
        Caption = #1042#1080#1076
        DataBinding.FieldName = 'StreetKindName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = StreetKindChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 40
      end
      object PostalCode: TcxGridDBColumn
        Caption = #1055#1086#1095#1090#1086#1074#1099#1081' '#1080#1085#1076#1077#1082#1089
        DataBinding.FieldName = 'PostalCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object StreetName: TcxGridDBColumn
        Caption = #1059#1083#1080#1094#1072'/'#1087#1088#1086#1089#1087#1077#1082#1090
        DataBinding.FieldName = 'StreetName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object HouseNumber: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1084#1072
        DataBinding.FieldName = 'HouseNumber'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object CaseNumber: TcxGridDBColumn
        Caption = #8470' '#1082#1086#1088#1087'.'
        DataBinding.FieldName = 'CaseNumber'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object RoomNumber: TcxGridDBColumn
        Caption = #8470' '#1082#1074'.'
        DataBinding.FieldName = 'RoomNumber'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object Order_Name: TcxGridDBColumn
        Caption = #1047#1072#1082#1072#1079' '#1060#1048#1054
        DataBinding.FieldName = 'Order_Name'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = ContactPersonChoiceOrderForm
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object Order_Phone: TcxGridDBColumn
        Caption = #1047#1072#1082#1072#1079' '#1090#1077#1083'.'
        DataBinding.FieldName = 'Order_Phone'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = ContactPersonChoiceOrderForm
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 75
      end
      object Order_Mail: TcxGridDBColumn
        Caption = #1047#1072#1082#1072#1079' Email'
        DataBinding.FieldName = 'Order_Mail'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = ContactPersonChoiceOrderForm
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object Doc_Name: TcxGridDBColumn
        Caption = #1055#1077#1088#1074#1080#1095#1082#1072' '#1060#1048#1054
        DataBinding.FieldName = 'Doc_Name'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = ContactPersonChoiceDocForm
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object Doc_Phone: TcxGridDBColumn
        Caption = #1055#1077#1088#1074#1080#1095#1082#1072' '#1090#1077#1083'.'
        DataBinding.FieldName = 'Doc_Phone'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = ContactPersonChoiceDocForm
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 75
      end
      object Doc_Mail: TcxGridDBColumn
        Caption = #1055#1077#1088#1074#1080#1095#1082#1072' Email'
        DataBinding.FieldName = 'Doc_Mail'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = ContactPersonChoiceDocForm
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object Act_Name: TcxGridDBColumn
        Caption = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080' '#1060#1048#1054
        DataBinding.FieldName = 'Act_Name'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = ContactPersonChoiceActForm
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object Act_Phone: TcxGridDBColumn
        Caption = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080' '#1090#1077#1083'.'
        DataBinding.FieldName = 'Act_Phone'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = ContactPersonChoiceActForm
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 75
      end
      object Act_Mail: TcxGridDBColumn
        Caption = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080' Email'
        DataBinding.FieldName = 'Act_Mail'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = ContactPersonChoiceActForm
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object InfoMoneyCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1059#1055
        DataBinding.FieldName = 'InfoMoneyCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 40
      end
      object InfoMoneyGroupName: TcxGridDBColumn
        Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'InfoMoneyGroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 107
      end
      object InfoMoneyDestinationName: TcxGridDBColumn
        Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
        DataBinding.FieldName = 'InfoMoneyDestinationName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 124
      end
      object InfoMoneyName: TcxGridDBColumn
        Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'InfoMoneyName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 115
      end
      object InfoMoneyName_all: TcxGridDBColumn
        Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103
        DataBinding.FieldName = 'InfoMoneyName_all'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object NameInteger: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' Integer'
        DataBinding.FieldName = 'NameInteger'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Default = True
            Enabled = False
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Visible = False
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
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object deStart: TcxDateEdit
    Left = 544
    Top = 36
    EditValue = 41852d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 3
    Width = 85
  end
  object cxlEnd: TcxLabel
    Left = 629
    Top = 36
    AutoSize = False
    Caption = #1087#1086
    Properties.Alignment.Vert = taVCenter
    Height = 21
    Width = 21
    AnchorY = 47
  end
  object deEnd: TcxDateEdit
    Left = 654
    Top = 36
    EditValue = 41852d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 6
    Width = 85
  end
  object cbPeriod: TcxCheckBox
    Left = 394
    Top = 36
    Action = actRefreshPeriod
    TabOrder = 1
    Width = 148
  end
  object Panel: TPanel
    Left = 0
    Top = 0
    Width = 1362
    Height = 35
    Align = alTop
    TabOrder = 4
    object edRetail: TcxButtonEdit
      Left = 669
      Top = 8
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 129
    end
    object cxLabel3: TcxLabel
      Left = 588
      Top = 9
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100':'
    end
    object cxLabel5: TcxLabel
      Left = 991
      Top = 9
      AutoSize = False
      Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103':'
      Height = 17
      Width = 60
    end
    object ceInfoMoney: TcxButtonEdit
      Left = 1051
      Top = 8
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 306
    end
    object cxLabel6: TcxLabel
      Left = 6
      Top = 9
      AutoSize = False
      Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086':'
      Height = 17
      Width = 110
    end
    object edJuridical: TcxButtonEdit
      Left = 111
      Top = 8
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 221
    end
    object cxLabel2: TcxLabel
      Left = 335
      Top = 9
      Caption = #1060#1048#1054' ('#1058#1055'):'
    end
    object edPersonalTrade: TcxButtonEdit
      Left = 390
      Top = 8
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 194
    end
    object cxLabel4: TcxLabel
      Left = 803
      Top = 9
      Caption = #1052#1072#1088#1096#1088#1091#1090':'
    end
    object edRoute: TcxButtonEdit
      Left = 855
      Top = 8
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 130
    end
  end
  object DataSource: TDataSource
    DataSet = MasterCDS
    Left = 40
    Top = 120
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 152
    Top = 192
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
        Component = InfoMoneyGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = JuridicalGuides
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
      end
      item
        Component = GuidesPersonalTrade
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesRetail
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesRoute
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
    StorageName = 'cxPropertiesStore'
    Left = 296
    Top = 120
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
    Top = 112
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
          ItemName = 'bbInsertMask'
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
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbShowCurPartnerOnMap'
        end
        item
          Visible = True
          ItemName = 'bbShowAllPartnerOnMap'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbPrint_byPartner'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'chkByDoc'
        end
        item
          Visible = True
          ItemName = 'deStartDate'
        end
        item
          Visible = True
          ItemName = 'textTo'
        end
        item
          Visible = True
          ItemName = 'deEndDate'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbChoiceGuides'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbGridToExel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
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
    object bbGridToExel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
    end
    object bbChoiceGuides: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
      Enabled = False
    end
    object dxBarStatic1: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
    end
    object bbJuridicalLabel: TdxBarControlContainerItem
      Caption = 'JuridicalLabel'
      Category = 0
      Hint = 'JuridicalLabel'
      Visible = ivAlways
      Control = cxLabel6
    end
    object bbJuridicalGuides: TdxBarControlContainerItem
      Caption = 'JuridicalGuides'
      Category = 0
      Hint = 'JuridicalGuides'
      Visible = ivAlways
      Control = edJuridical
    end
    object dxBarStatic2: TdxBarStatic
      Category = 0
      Visible = ivAlways
    end
    object chkByDoc: TdxBarControlContainerItem
      Caption = #1086#1075#1088#1072#1085#1080#1095#1080#1090#1100' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089
      Category = 0
      Hint = #1086#1075#1088#1072#1085#1080#1095#1080#1090#1100' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089
      Visible = ivAlways
      Control = cbPeriod
    end
    object deStartDate: TdxBarControlContainerItem
      Caption = 'deStartDate'
      Category = 0
      Hint = 'deStartDate'
      Visible = ivAlways
      Control = deStart
    end
    object textTo: TdxBarControlContainerItem
      Caption = 'textTo'
      Category = 0
      Hint = 'textTo'
      Visible = ivAlways
      Control = cxlEnd
    end
    object deEndDate: TdxBarControlContainerItem
      Caption = 'deEndDate'
      Category = 0
      Hint = 'deEndDate'
      Visible = ivAlways
      Control = deEnd
    end
    object bbPrint_byPartner: TdxBarButton
      Action = actPrint_byPartner
      Category = 0
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel5
    end
    object dxBarControlContainerItem2: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = ceInfoMoney
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbInsertMask: TdxBarButton
      Action = actInsertMask
      Category = 0
    end
    object bbShowCurPartnerOnMap: TdxBarButton
      Action = actShowCurPartnerOnMap
      Category = 0
    end
    object bbShowAllPartnerOnMap: TdxBarButton
      Action = mactShowAllPartnerOnMap
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 232
    Top = 144
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end>
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
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
      FormName = 'TPartnerEditForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'MaskId'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = ''
          Component = JuridicalGuides
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actInsertMask: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077
      ImageIndex = 54
      FormName = 'TPartnerEditForm'
      FormNameParam.Value = 'TPartnerEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'MaskId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = 0
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TPartnerEditForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MaskId'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = 0
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
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
      ShortCut = 32776
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DataSource
    end
    object PriceListPromoChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PriceListPromoChoiceForm'
      FormName = 'TPriceListForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PriceListPromoId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PriceListPromoName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object StreetKindChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'StreetChoiceForm'
      FormName = 'TStreetKindForm'
      FormNameParam.Value = 'TStreetKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StreetKindId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StreetKindName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object CityKindChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'CityKindChoiceForm'
      FormName = 'TCityKindForm'
      FormNameParam.Value = 'TCityKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'CityKindId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'CityKindName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
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
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
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
    object ContactPersonChoiceActForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ContactPersonChoiceForm'
      FormName = 'TContactPersonChoiceForm'
      FormNameParam.Value = 'TContactPersonChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'PartnerId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContactPersonKindId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Act_ContactPersonKindId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContactPersonKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Act_ContactPersonKindName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Act_Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'phone'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Act_phone'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'mail'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Act_mail'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object ContactPersonChoiceOrderForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ContactPersonChoiceForm'
      FormName = 'TContactPersonChoiceForm'
      FormNameParam.Value = 'TContactPersonChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'PartnerId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContactPersonKindId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Order_ContactPersonKindId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContactPersonKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Order_ContactPersonKindName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Order_Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'phone'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Order_phone'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'mail'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Order_mail'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object ContactPersonChoiceDocForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ContactPersonChoiceForm'
      FormName = 'TContactPersonChoiceForm'
      FormNameParam.Value = 'TContactPersonChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'PartnerId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContactPersonKindId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Doc_ContactPersonKindId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContactPersonKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Doc_ContactPersonKindName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'doc_Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'phone'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Doc_phone'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'mail'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'doc_mail'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object MemberTakeChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Member_ObjectForm'
      FormName = 'TMember_ObjectForm'
      FormNameParam.Value = 'TMember_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberTakeId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberTakeName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object PersonalChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Personal_ObjectForm'
      FormName = 'TPersonal_ObjectForm'
      FormNameParam.Value = 'TPersonal_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object PersonalTradeChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Personal_ObjectForm'
      FormName = 'TPersonal_ObjectForm'
      FormNameParam.Value = 'TPersonal_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalTradeId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalTradeName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object PartnerTagChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartnerTagForm'
      FormName = 'TPartnerTagForm'
      FormNameParam.Value = 'TPartnerTagForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerTagId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerTagName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object AreaChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'AreaForm'
      FormName = 'TAreaForm'
      FormNameParam.Value = 'TAreaForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AreaId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AreaName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actPrint_byPartner: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1064#1072#1073#1083#1086#1085' '#1087#1086' '#1090#1086#1095#1082#1072#1084' '#1076#1086#1089#1090#1072#1074#1082#1080
      Hint = #1064#1072#1073#1083#1086#1085' '#1087#1086' '#1090#1086#1095#1082#1072#1084' '#1076#1086#1089#1090#1072#1074#1082#1080
      ImageIndex = 21
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'partnername'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41852d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41852d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      ReportName = #1064#1072#1073#1083#1086#1085' '#1087#1086' '#1090#1086#1095#1082#1072#1084' '#1076#1086#1089#1090#1072#1074#1082#1080
      ReportNameParam.Value = #1064#1072#1073#1083#1086#1085' '#1087#1086' '#1090#1086#1095#1082#1072#1084' '#1076#1086#1089#1090#1072#1074#1082#1080
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
    end
    object actRefreshPeriod: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end>
      Caption = #1086#1075#1088#1072#1085#1080#1095#1080#1090#1100' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089
      Hint = #1086#1075#1088#1072#1085#1080#1095#1080#1090#1100' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
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
    object actShowCurPartnerOnMap: TdsdPartnerMapAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1050#1072#1088#1090#1072' Google - '#1090#1086#1083#1100#1082#1086' '#1054#1044#1048#1053' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090
      Hint = #1050#1072#1088#1090#1072' Google - '#1090#1086#1083#1100#1082#1086' '#1054#1044#1048#1053' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090
      ImageIndex = 74
      FormName = 'TPartnerMapForm'
      FormNameParam.Value = 'TPartnerMapForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
      DataSet = MasterCDS
    end
    object actCheckShowAllPartnerOnMap: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spCheck
      StoredProcList = <
        item
          StoredProc = spCheck
        end>
      Caption = 'actCheckShowAllPartnerOnMap'
    end
    object actShowAllPartnerOnMap: TdsdPartnerMapAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1082#1072#1088#1090#1091' '#1076#1083#1103' '#1087#1088#1086#1089#1084#1086#1090#1088#1072' '#1042#1057#1045#1061' '#1072#1076#1088#1077#1089#1086#1074
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1082#1072#1088#1090#1091' '#1076#1083#1103' '#1087#1088#1086#1089#1084#1086#1090#1088#1072' '#1042#1057#1045#1061' '#1072#1076#1088#1077#1089#1086#1074
      FormName = 'TPartnerMapForm'
      FormNameParam.Value = 'TPartnerMapForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
      MapType = acShowAll
      DataSet = MasterCDS
    end
    object mactShowAllPartnerOnMap: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actCheckShowAllPartnerOnMap
        end
        item
          Action = actShowAllPartnerOnMap
        end>
      QuestionBeforeExecute = 
        #1054#1090#1082#1088#1099#1090#1080#1077' '#1082#1072#1088#1090#1099' '#1076#1083#1103' '#1073#1086#1083#1100#1096#1086#1075#1086' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1072' '#1072#1076#1088#1077#1089#1086#1074' '#1084#1086#1078#1077#1090' '#1074#1099#1087#1086#1083#1085#1103#1090#1100#1089#1103 +
        ' '#1076#1086#1083#1075#1086'.'#1055#1088#1086#1076#1086#1083#1078#1080#1090#1100'? '
      Caption = #1050#1072#1088#1090#1072' Google - '#1042#1057#1045' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099
      Hint = #1050#1072#1088#1090#1072' Google - '#1042#1057#1045' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099
      ImageIndex = 40
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Partner_Address'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 'NULL'
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 'NULL'
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPeriod'
        Value = Null
        Component = cbPeriod
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = 'False'
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId'
        Value = Null
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalTradeId'
        Value = Null
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteId'
        Value = Null
        Component = GuidesRoute
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 80
    Top = 216
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 424
    Top = 216
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
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 464
    Top = 288
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 424
    Top = 152
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Partner_Contact'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOrdeName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Order_Name'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOrderPhone'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Order_Phone'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOrderMail'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Order_Mail'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 88
    Top = 344
  end
  object JuridicalGuides: TdsdGuides
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
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 8
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = JuridicalGuides
      end
      item
        Component = PeriodChoice
      end
      item
        Component = InfoMoneyGuides
      end
      item
        Component = GuidesPersonalTrade
      end
      item
        Component = GuidesRetail
      end
      item
        Component = GuidesRoute
      end>
    Left = 288
    Top = 184
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'MasterJuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 384
    Top = 112
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 480
    Top = 120
  end
  object InfoMoneyGuides: TdsdGuides
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
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 1080
    Top = 13
  end
  object GuidesRetail: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 672
    Top = 8
  end
  object GuidesPersonalTrade: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalTrade
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalTrade
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 495
    Top = 8
  end
  object GuidesRoute: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRoute
    FormNameParam.Value = 'TRoute_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRoute_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPositionId'
        Value = '149831'
        MultiSelectSeparator = ','
      end>
    Left = 911
  end
  object spCheck: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Partner_checkMap'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalTradeId'
        Value = ''
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteId'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 289
    Top = 290
  end
end
