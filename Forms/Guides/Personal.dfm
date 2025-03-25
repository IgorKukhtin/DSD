object PersonalForm: TPersonalForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1057#1086#1090#1088#1091#1076#1085#1080#1082#1080'>'
  ClientHeight = 448
  ClientWidth = 1346
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
    Width = 1346
    Height = 422
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
          Column = MemberName
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsSelection.InvertSelect = False
      OptionsView.Footer = True
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object isIrna: TcxGridDBColumn
        Caption = #1048#1088#1085#1072
        DataBinding.FieldName = 'isIrna'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1088#1085#1072' ('#1044#1072'/'#1053#1077#1090')'
        Options.Editing = False
        Width = 45
      end
      object MemberCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'MemberCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object Code1C: TcxGridDBColumn
        Caption = #1050#1086#1076' 1'#1057
        DataBinding.FieldName = 'Code1C'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 58
      end
      object MemberName: TcxGridDBColumn
        Caption = #1060#1048#1054
        DataBinding.FieldName = 'MemberName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 155
      end
      object Birthday_Month: TcxGridDBColumn
        Caption = #1052#1077#1089#1103#1094' '#1088#1086#1078#1076#1077#1085#1080#1103
        DataBinding.FieldName = 'Birthday_Date'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object INN: TcxGridDBColumn
        Caption = #1048#1053#1053
        DataBinding.FieldName = 'INN'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 89
      end
      object PositionCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1076#1086#1078#1085'.'
        DataBinding.FieldName = 'PositionCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1076' '#1076#1086#1078#1085#1086#1089#1090#1080
        Options.Editing = False
        Width = 70
      end
      object PositionName: TcxGridDBColumn
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
        DataBinding.FieldName = 'PositionName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actPositionChoice
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 142
      end
      object PositionLevelCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1088#1072#1079#1088#1103#1076
        DataBinding.FieldName = 'PositionLevelCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1076' '#1088#1072#1079#1088#1103#1076' '#1076#1086#1083#1078#1085#1086#1089#1090#1080
        Options.Editing = False
        Width = 70
      end
      object PositionLevelName: TcxGridDBColumn
        Caption = #1056#1072#1079#1088#1103#1076' '#1076#1086#1083#1078#1085#1086#1089#1090#1080
        DataBinding.FieldName = 'PositionLevelName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 113
      end
      object PersonalGroupName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1080#1088#1086#1074#1082#1072
        DataBinding.FieldName = 'PersonalGroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 133
      end
      object Card: TcxGridDBColumn
        Caption = #8470' '#1082#1072#1088#1090'. '#1089#1095#1077#1090#1072' '#1047#1055' ('#1060'1)'
        DataBinding.FieldName = 'Card'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 115
      end
      object BankName: TcxGridDBColumn
        Caption = #1041#1072#1085#1082' ('#1060'1)'
        DataBinding.FieldName = 'BankName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object CardSecond: TcxGridDBColumn
        Caption = #8470' '#1082#1072#1088#1090'.'#1089#1095#1077#1090#1072' '#1047#1055' ('#1060'2) ('#1042#1086#1089#1090#1086#1082')'
        DataBinding.FieldName = 'CardSecond'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 115
      end
      object BankSecondName: TcxGridDBColumn
        Caption = #1041#1072#1085#1082' ('#1060'2) ('#1042#1086#1089#1090#1086#1082')'
        DataBinding.FieldName = 'BankSecondName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object DepartmentName: TcxGridDBColumn
        Caption = #1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090' 1 '#1088#1110#1074#1085#1103
        DataBinding.FieldName = 'DepartmentName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object Department_twoName: TcxGridDBColumn
        Caption = #1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090' 2 '#1088#1110#1074#1085#1103
        DataBinding.FieldName = 'Department_twoName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 88
      end
      object UnitName: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
        DataBinding.FieldName = 'UnitName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actUnitChoice
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 128
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
      object DateIn: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1087#1088#1080#1077#1084#1072
        DataBinding.FieldName = 'DateIn'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 60
      end
      object DateOut: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1091#1074#1086#1083#1100#1085#1077#1085#1080#1103
        DataBinding.FieldName = 'DateOut'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object IsDateOut: TcxGridDBColumn
        Caption = #1059#1074#1086#1083#1077#1085
        DataBinding.FieldName = 'isDateOut'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object DateSend: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1087#1077#1088#1077#1074#1086#1076#1072
        DataBinding.FieldName = 'DateSend'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object IsDateSend: TcxGridDBColumn
        Caption = #1055#1077#1088#1077#1074#1077#1076#1077#1085
        DataBinding.FieldName = 'isDateSend'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object IsMain: TcxGridDBColumn
        Caption = #1054#1089#1085#1086#1074#1085#1086#1077' '#1084#1077#1089#1090#1086' '#1088'.'
        DataBinding.FieldName = 'isMain'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object IsOfficial: TcxGridDBColumn
        Caption = #1054#1092#1086#1088#1084#1083#1077#1085' '#1086#1092#1080#1094#1080#1072#1083#1100#1085#1086
        DataBinding.FieldName = 'isOfficial'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object PersonalServiceListName: TcxGridDBColumn
        Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103'('#1075#1083#1072#1074#1085#1072#1103')'
        DataBinding.FieldName = 'PersonalServiceListName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 104
      end
      object PersonalServiceListOfficialName: TcxGridDBColumn
        Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103'('#1041#1053')'
        DataBinding.FieldName = 'PersonalServiceListOfficialName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = PersonalServiceListOfficialChoice
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object ServiceListCardSecondName: TcxGridDBColumn
        Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103'('#1082#1072#1088#1090#1072' '#1092'2)'
        DataBinding.FieldName = 'ServiceListCardSecondName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = PersonalServiceListCardSecondChoice
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object ServiceListName_AvanceF2: TcxGridDBColumn
        Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103'('#1072#1074#1072#1085#1089' '#1050#1072#1088#1090#1072' '#1060'2)'
        DataBinding.FieldName = 'ServiceListName_AvanceF2'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = PersonalServiceListAvanceF2
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 101
      end
      object SheetWorkTimeName: TcxGridDBColumn
        Caption = #1056#1077#1078#1080#1084' '#1088#1072#1073#1086#1090#1099' ('#1064#1072#1073#1083#1086#1085' '#1090#1072#1073#1077#1083#1103' '#1088'.'#1074#1088'.)'
        DataBinding.FieldName = 'SheetWorkTimeName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1056#1077#1078#1080#1084' '#1088#1072#1073#1086#1090#1099' ('#1064#1072#1073#1083#1086#1085' '#1090#1072#1073#1077#1083#1103' '#1088'.'#1074#1088'.)'
        Options.Editing = False
        Width = 120
      end
      object StorageLineName: TcxGridDBColumn
        Caption = #1051#1080#1085#1080#1103' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072
        DataBinding.FieldName = 'StorageLineName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actStorageLine
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 90
      end
      object isErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 35
      end
      object isPastMain: TcxGridDBColumn
        Caption = #1055#1088#1077#1076#1099#1076#1091#1097#1077#1077' '#1075#1083#1072#1074#1085#1086#1077
        DataBinding.FieldName = 'isPastMain'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1088#1077#1076#1099#1076#1091#1097#1077#1077' '#1075#1083#1072#1074#1085#1086#1077' '#1044#1072'/'#1053#1077#1090
        Options.Editing = False
        Width = 70
      end
      object Member_ReferCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1088#1077#1082#1086#1084#1077#1085#1076#1072#1090#1077#1083#1103
        DataBinding.FieldName = 'Member_ReferCode'
        Visible = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 60
      end
      object Member_ReferName: TcxGridDBColumn
        Caption = #1060#1048#1054' '#1088#1077#1082#1086#1084#1077#1085#1076#1072#1090#1077#1083#1103
        DataBinding.FieldName = 'Member_ReferName'
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1060#1072#1084#1080#1083#1080#1103' '#1088#1077#1082#1086#1084#1077#1085#1076#1072#1090#1077#1083#1103
        Options.Editing = False
        Width = 70
      end
      object Member_MentorCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1085#1072#1089#1090#1072#1074#1085#1080#1082#1072
        DataBinding.FieldName = 'Member_MentorCode'
        Visible = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 60
      end
      object Member_MentorName: TcxGridDBColumn
        Caption = #1060#1048#1054' '#1085#1072#1089#1090#1072#1074#1085#1080#1082#1072
        DataBinding.FieldName = 'Member_MentorName'
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1060#1072#1084#1080#1083#1080#1103' '#1085#1072#1089#1090#1072#1074#1085#1080#1082#1072
        Options.Editing = False
        Width = 70
      end
      object CardBank: TcxGridDBColumn
        Caption = #8470' '#1073#1072#1085#1082'. '#1082#1072#1088#1090#1086#1095#1082#1080' '#1047#1055' ('#1060'1)'
        DataBinding.FieldName = 'CardBank'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 115
      end
      object CardBankSecond: TcxGridDBColumn
        Caption = #8470' '#1073#1072#1085#1082'. '#1082#1072#1088#1090#1086#1095#1082#1080' '#1047#1055' ('#1060'2) ('#1042#1086#1089#1090#1086#1082')'
        DataBinding.FieldName = 'CardBankSecond'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 115
      end
      object ReasonOutName: TcxGridDBColumn
        Caption = #1055#1088#1080#1095#1080#1085#1072' '#1091#1074#1086#1083#1100#1085#1077#1085#1080#1103
        DataBinding.FieldName = 'ReasonOutName'
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object Comment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object cbPeriod: TcxCheckBox
    Left = 256
    Top = 26
    Action = actRefresh
    Caption = '<'#1056#1072#1073#1086#1090#1072#1083'> '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089
    TabOrder = 1
    Width = 145
  end
  object deStart: TcxDateEdit
    Left = 445
    Top = 26
    EditValue = 42948d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 3
    Width = 80
  end
  object cxlEnd: TcxLabel
    Left = 536
    Top = 26
    AutoSize = False
    Caption = #1087#1086
    Properties.Alignment.Vert = taVCenter
    Height = 21
    Width = 21
    AnchorY = 37
  end
  object deEnd: TcxDateEdit
    Left = 563
    Top = 26
    EditValue = 42948d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 5
    Width = 79
  end
  object cxLabel8: TcxLabel
    Left = 664
    Top = 46
    Caption = #1053#1086#1074#1072#1103' '#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083'.('#1075#1083#1072#1074#1085#1072#1103')'
  end
  object cePersonalServiceList: TcxButtonEdit
    Left = 664
    Top = 26
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 161
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
    Left = 288
    Top = 104
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
          Visible = True
          ItemName = 'bbCopy'
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
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateIsMain'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_isIrna'
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
          ItemName = 'dxBarControlContainerItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem2'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem3'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem4'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bcPersonalServiceList_text'
        end
        item
          Visible = True
          ItemName = 'bcPersonalServiceList'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_PersonalServiceList'
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
          ItemName = 'bbProtocolOpenForm'
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
      Caption = '  '
      Category = 0
      Hint = '  '
      Visible = ivAlways
      ShowCaption = False
    end
    object bbChoiceGuides: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object bbUpdateIsMain: TdxBarButton
      Action = actUpdateIsMain
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbCopy: TdxBarButton
      Action = actInsertMask
      Category = 0
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cbPeriod
    end
    object dxBarControlContainerItem2: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = deStart
    end
    object dxBarControlContainerItem3: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxlEnd
    end
    object dxBarControlContainerItem4: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = deEnd
    end
    object bbProtocolOpenForm: TdxBarButton
      Action = ProtocolOpenForm
      Category = 0
    end
    object bbUpdate_isIrna: TdxBarButton
      Action = macUpdate_isIrna
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1047#1085#1072#1095#1077#1085#1080#1077' <'#1048#1088#1085#1072'> '#1044#1072'/'#1053#1077#1090
      Category = 0
    end
    object bcPersonalServiceList: TdxBarControlContainerItem
      Caption = #1053#1086#1074#1072#1103' '#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083'.('#1075#1083#1072#1074#1085#1072#1103')'
      Category = 0
      Hint = #1053#1086#1074#1072#1103' '#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083'.('#1075#1083#1072#1074#1085#1072#1103')'
      Visible = ivAlways
      Control = cePersonalServiceList
    end
    object bcPersonalServiceList_text: TdxBarControlContainerItem
      Caption = #1053#1086#1074#1072#1103' '#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083'.('#1075#1083#1072#1074#1085#1072#1103') (text)'
      Category = 0
      Hint = #1053#1086#1074#1072#1103' '#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083'.('#1075#1083#1072#1074#1085#1072#1103') (text)'
      Visible = ivAlways
      Control = cxLabel8
    end
    object bbUpdate_PersonalServiceList: TdxBarButton
      Action = macUpdate_PersonalServiceList
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1085#1086#1074'. '#1079#1085#1072#1095#1077#1085#1080#1077' '#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083'. '#1075#1083#1072#1074#1085#1072#1103
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 288
    Top = 160
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
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
      FormName = 'TPersonalEditForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'MaskId'
          Value = Null
          ParamType = ptInput
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
      ShortCut = 16429
      ImageIndex = 54
      FormName = 'TPersonalEditForm'
      FormNameParam.Value = 'TPersonalEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MaskId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
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
      FormName = 'TPersonalEditForm'
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
    object ProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083' <'#1057#1086#1090#1088#1091#1076#1085#1080#1082#1080'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083' <'#1057#1086#1090#1088#1091#1076#1085#1080#1082#1080'>'
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
          ComponentItem = 'MemberName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
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
          Name = 'Code'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'MemberCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'MemberName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PositionId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PositionName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'UnitName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'InfoMoneyId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName_all'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'InfoMoneyName_all'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractId'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractName'
          Value = ''
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
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
    object actUpdateIsMain: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateIsMain
      StoredProcList = <
        item
          StoredProc = spUpdateIsMain
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1054#1089#1085#1086#1074#1085#1086#1077' '#1084#1077#1089#1090#1086' '#1088'.  '#1044#1072'/'#1053#1077#1090'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1054#1089#1085#1086#1074#1085#1086#1077' '#1084#1077#1089#1090#1086' '#1088'.  '#1044#1072'/'#1053#1077#1090'"'
      ImageIndex = 52
    end
    object actUnitChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TUnit_ObjectForm'
      FormName = 'TUnit_ObjectForm'
      FormNameParam.Value = 'TUnit_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'UnitName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object PersonalServiceListAvanceF2: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TPositionForm'
      FormName = 'TPersonalServiceListForm'
      FormNameParam.Value = 'TPersonalServiceListForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'ServiceListId_AvanceF2'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'ServiceListName_AvanceF2'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object PersonalServiceListCardSecondChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TPositionForm'
      FormName = 'TPersonalServiceListForm'
      FormNameParam.Value = 'TPersonalServiceListForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'ServiceListCardSecondId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'ServiceListCardSecondName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object PersonalServiceListOfficialChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TPositionForm'
      FormName = 'TPersonalServiceListForm'
      FormNameParam.Value = 'TPersonalServiceListForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PersonalServiceListOfficialId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PersonalServiceListOfficialName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actStorageLine: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TStorageLineForm'
      FormName = 'TStorageLineForm'
      FormNameParam.Value = 'TStorageLineForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'StorageLineId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'StorageLineName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actPositionChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TPositionForm'
      FormName = 'TPositionForm'
      FormNameParam.Value = 'TPositionForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PositionId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PositionName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
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
    object macUpdate_isIrna: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_isIrna_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1083#1103' '#1042#1099#1073#1088#1072#1085#1085#1099#1093' '#1101#1083#1077#1084#1077#1085#1090#1086#1074' '#1047#1085#1072#1095#1077#1085#1080#1077' <'#1048#1088#1085#1072'> '#1085#1072' '#1087#1088#1086#1090#1080#1074#1086#1087#1086#1083#1086#1078 +
        #1085#1086#1077'?'
      InfoAfterExecute = #1047#1085#1072#1095#1077#1085#1080#1077' '#1080#1079#1084#1077#1085#1077#1085#1086
      Caption = 'macUpdate_isIrna'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1047#1085#1072#1095#1077#1085#1080#1077' <'#1048#1088#1085#1072'> '#1044#1072'/'#1053#1077#1090
      ImageIndex = 66
    end
    object macUpdate_isIrna_list: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_isIrna
        end>
      View = cxGridDBTableView
      Caption = 'macUpdate_isIrna_list'
      ImageIndex = 66
    end
    object actUpdate_isIrna: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isIrna
      StoredProcList = <
        item
          StoredProc = spUpdate_isIrna
        end>
      Caption = 'actUpdate_isIrna'
      ImageIndex = 66
    end
    object actUpdate_PersonalServiceList: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_PersonalServiceList
      StoredProcList = <
        item
          StoredProc = spUpdate_PersonalServiceList
        end>
      Caption = 'actUpdate_PersonalServiceList'
    end
    object macUpdate_PersonalServiceList_list: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_PersonalServiceList
        end>
      View = cxGridDBTableView
      Caption = 'macUpdate_PersonalServiceList_list'
    end
    object macUpdate_PersonalServiceList: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_PersonalServiceList_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1085#1086#1074'. '#1079#1085#1072#1095#1077#1085#1080#1077' '#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083' '#1075#1083#1072#1074#1085#1072#1103' '#1074#1099#1073#1088#1072#1085#1085#1099#1084' '#1089#1086#1090#1088 +
        #1091#1076#1085#1080#1082#1072#1084'?'
      InfoAfterExecute = #1047#1085#1072#1095#1077#1085#1080#1103' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1099
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1085#1086#1074'. '#1079#1085#1072#1095#1077#1085#1080#1077' '#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083' '#1075#1083#1072#1074#1085#1072#1103
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1085#1086#1074'. '#1079#1085#1072#1095#1077#1085#1080#1077' '#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083' '#1075#1083#1072#1074#1085#1072#1103
      ImageIndex = 82
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Personal'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 41852d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41852d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPeriod'
        Value = False
        Component = cbPeriod
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
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
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 480
    Top = 97
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice
      end>
    Left = 536
    Top = 160
  end
  object spUpdateIsMain: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Personal_isMain'
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
        Name = 'ioIsMain'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isMain'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 240
    Top = 347
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Personal_Property'
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
        Name = 'inPositionId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'PositionId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalServiceListOfficialId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'PersonalServiceListOfficialId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalServiceListCardSecondId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'ServiceListCardSecondId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalServiceListId_AvanceF2'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'ServiceListId_AvanceF2'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStorageLineId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'StorageLineId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode1C'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Code1C'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsMain'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isMain'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 531
    Top = 310
  end
  object spUpdate_isIrna: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Guide_Irna'
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
        Name = 'inisIrna'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isIrna'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 416
    Top = 152
  end
  object GuidesPersonalServiceList: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePersonalServiceList
    FormNameParam.Value = 'TPersonalServiceListForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalServiceListForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalServiceList
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalServiceList
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 775
    Top = 97
  end
  object spUpdate_PersonalServiceList: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Personal_PersonalServiceList'
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
        Name = 'inPersonalServiceListId'
        Value = Null
        Component = GuidesPersonalServiceList
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 768
    Top = 152
  end
end
