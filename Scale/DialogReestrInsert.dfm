inherited DialogReestrInsertForm: TDialogReestrInsertForm
  Left = 0
  Top = 0
  Caption = #1056#1077#1077#1089#1090#1088' '#1085#1072#1082#1083#1072#1076#1085#1099#1093' <'#1042#1099#1074#1077#1079#1077#1085#1086' '#1089#1086' '#1089#1082#1083#1072#1076#1072'>'
  ClientHeight = 535
  ClientWidth = 790
  Font.Charset = RUSSIAN_CHARSET
  Font.Height = -13
  Font.Name = 'Tahoma'
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  ExplicitWidth = 806
  ExplicitHeight = 570
  PixelsPerInch = 96
  TextHeight = 16
  inherited bbPanel: TPanel
    Top = 494
    Width = 790
    TabOrder = 2
    ExplicitTop = 494
    ExplicitWidth = 790
    inherited bbOk: TBitBtn
      Visible = False
    end
  end
  object InfoPanel: TPanel
    Left = 0
    Top = 0
    Width = 790
    Height = 105
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object infoPanelPartner: TPanel
      Left = 0
      Top = 47
      Width = 790
      Height = 58
      Align = alClient
      Alignment = taLeftJustify
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitLeft = 192
      ExplicitTop = 25
      ExplicitWidth = 598
      ExplicitHeight = 46
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 115
        Height = 58
        Align = alLeft
        Alignment = taLeftJustify
        BevelOuter = bvSpace
        TabOrder = 0
        ExplicitHeight = 46
        object Label2: TLabel
          Left = 1
          Top = 1
          Width = 113
          Height = 16
          Align = alTop
          Caption = '  '#1050#1086#1076' '#1072#1074#1090#1086
          ExplicitWidth = 60
        end
        object EditPartnerCode: TcxButtonEdit
          Left = 6
          Top = 19
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = False
          Properties.OnButtonClick = EditPartnerCodePropertiesButtonClick
          TabOrder = 0
          Text = 'EditPartnerCode'
          OnEnter = EditPartnerCodeEnter
          OnExit = EditPartnerCodeExit
          OnKeyDown = EditPartnerCodeKeyDown
          Width = 102
        end
      end
      object Panel4: TPanel
        Left = 115
        Top = 0
        Width = 675
        Height = 58
        Align = alClient
        Alignment = taLeftJustify
        BevelOuter = bvSpace
        TabOrder = 1
        ExplicitWidth = 483
        ExplicitHeight = 46
        object Label3: TLabel
          Left = 1
          Top = 1
          Width = 673
          Height = 16
          Align = alTop
          Caption = '  '#1053#1072#1079#1074#1072#1085#1080#1077
          ExplicitWidth = 64
        end
        object PanelPartnerName: TPanel
          Left = 1
          Top = 17
          Width = 673
          Height = 40
          Align = alClient
          Alignment = taLeftJustify
          AutoSize = True
          BevelOuter = bvNone
          Caption = 'PanelPartnerName'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          ExplicitLeft = -1
          ExplicitTop = 12
          ExplicitWidth = 474
        end
      end
      object Panel5: TPanel
        Left = 115
        Top = 0
        Width = 675
        Height = 58
        Align = alClient
        Alignment = taLeftJustify
        BevelOuter = bvSpace
        TabOrder = 2
        ExplicitLeft = 0
        ExplicitWidth = 192
        ExplicitHeight = 39
        object ScaleLabel: TLabel
          Left = 1
          Top = 1
          Width = 673
          Height = 16
          Align = alTop
          Caption = '  '#8470' '#1053#1072#1082#1083#1072#1076#1085#1086#1081' '#1080#1083#1080' '#1077#1075#1086' '#1064'/'#1050' '
          ExplicitWidth = 170
        end
        object EditBarCode: TEdit
          Left = 8
          Top = 19
          Width = 176
          Height = 24
          TabOrder = 0
          Text = 'EditBarCode'
          OnChange = EditBarCodeChange
          OnEnter = EditBarCodeEnter
          OnExit = EditBarCodeExit
        end
      end
    end
    object MessagePanel: TPanel
      Left = 0
      Top = 0
      Width = 790
      Height = 47
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object infoPanelContract: TPanel
        Left = 199
        Top = 0
        Width = 256
        Height = 47
        Align = alLeft
        BevelInner = bvRaised
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitLeft = 233
        ExplicitHeight = 38
        object LabelContract: TLabel
          Left = 1
          Top = 1
          Width = 254
          Height = 13
          Align = alTop
          Alignment = taCenter
          Caption = #8470' '#1087#1091#1090#1077#1074#1086#1081
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitLeft = 5
          ExplicitTop = -5
        end
        object PanelContract: TPanel
          Left = 1
          Top = 14
          Width = 254
          Height = 32
          Align = alClient
          Alignment = taLeftJustify
          BevelOuter = bvNone
          Caption = 'PanelContract'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          ExplicitWidth = 170
          ExplicitHeight = 23
        end
      end
      object Panel2: TPanel
        Left = 455
        Top = 0
        Width = 233
        Height = 47
        Align = alLeft
        BevelInner = bvRaised
        BevelOuter = bvNone
        TabOrder = 1
        ExplicitLeft = 0
        ExplicitHeight = 38
        object Label1: TLabel
          Left = 1
          Top = 1
          Width = 231
          Height = 13
          Align = alTop
          Alignment = taCenter
          Caption = #8470' '#1088#1077#1077#1089#1090#1088#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitLeft = -3
          ExplicitTop = -5
        end
        object Panel6: TPanel
          Left = 1
          Top = 14
          Width = 231
          Height = 32
          Align = alClient
          Alignment = taLeftJustify
          BevelOuter = bvNone
          Caption = 'PanelContract'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          ExplicitWidth = 170
          ExplicitHeight = 23
        end
      end
      object Panel7: TPanel
        Left = 0
        Top = 0
        Width = 199
        Height = 47
        Align = alLeft
        Alignment = taLeftJustify
        BevelOuter = bvSpace
        TabOrder = 2
        object Label4: TLabel
          Left = 1
          Top = 1
          Width = 197
          Height = 16
          Align = alTop
          Caption = '  '#8470' '#1055#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090' '#1080#1083#1080' '#1077#1075#1086' '#1064'/'#1050' '
          ExplicitWidth = 185
        end
        object Edit1: TEdit
          Left = 8
          Top = 19
          Width = 176
          Height = 24
          TabOrder = 0
          Text = 'EditBarCode'
          OnChange = EditBarCodeChange
          OnEnter = EditBarCodeEnter
          OnExit = EditBarCodeExit
        end
      end
    end
  end
  object GridPanel: TPanel
    Left = 0
    Top = 105
    Width = 790
    Height = 389
    Align = alClient
    Alignment = taLeftJustify
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 71
    ExplicitHeight = 423
    object cxDBGrid: TcxGrid
      Left = 0
      Top = 0
      Width = 790
      Height = 389
      Align = alClient
      TabOrder = 0
      ExplicitHeight = 423
      object cxDBGridDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = DataSource
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnMoving = False
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.GroupByBox = False
        OptionsView.HeaderAutoHeight = True
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object LineNum: TcxGridDBColumn
          Caption = #8470' '#1087'.'#1087'.'
          DataBinding.FieldName = 'LineNum'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 37
        end
        object BarCode_Sale: TcxGridDBColumn
          Caption = #1064#1090#1088#1080#1093#1082#1086#1076
          DataBinding.FieldName = 'BarCode_Sale'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
        object ReestrKindName: TcxGridDBColumn
          Caption = #1042#1080#1079#1072' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1077
          DataBinding.FieldName = 'ReestrKindName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 80
        end
        object colStatus: TcxGridDBColumn
          Caption = #1057#1090#1072#1090#1091#1089
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
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 55
        end
        object OperDate_Sale: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' ('#1089#1082#1083#1072#1076')'
          DataBinding.FieldName = 'OperDate_Sale'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object OperDatePartner: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1091' '#1087#1086#1082#1091#1087'.'
          DataBinding.FieldName = 'OperDatePartner'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 60
        end
        object InvNumber_Sale: TcxGridDBColumn
          Caption = #8470' '#1076#1086#1082'.'
          DataBinding.FieldName = 'InvNumber_Sale'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 80
        end
        object InvNumberPartner: TcxGridDBColumn
          Caption = #8470' '#1076#1086#1082'. '#1091' '#1087#1086#1082#1091#1087'.'
          DataBinding.FieldName = 'InvNumberPartner'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 55
        end
        object InvNumberOrder: TcxGridDBColumn
          Caption = #8470' '#1076#1086#1082'. '#1079#1072#1103#1074#1082#1072
          DataBinding.FieldName = 'InvNumberOrder'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object RouteName: TcxGridDBColumn
          Caption = #1052#1072#1088#1096#1088#1091#1090
          DataBinding.FieldName = 'RouteName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 80
        end
        object FromName: TcxGridDBColumn
          Caption = #1054#1090' '#1082#1086#1075#1086
          DataBinding.FieldName = 'FromName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 80
        end
        object ToName: TcxGridDBColumn
          Caption = #1050#1086#1084#1091
          DataBinding.FieldName = 'ToName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 120
        end
        object colOKPO_To: TcxGridDBColumn
          Caption = #1054#1050#1055#1054
          DataBinding.FieldName = 'OKPO_To'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 45
        end
        object colJuridicalName_To: TcxGridDBColumn
          Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
          DataBinding.FieldName = 'JuridicalName_To'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 100
        end
        object colTotalSumm: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057' ('#1080#1090#1086#1075')'
          DataBinding.FieldName = 'TotalSumm'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 80
        end
        object Checked: TcxGridDBColumn
          Caption = #1055#1088#1086#1074#1077#1088#1077#1085
          DataBinding.FieldName = 'Checked'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 55
        end
        object colPaidKindName: TcxGridDBColumn
          Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
          DataBinding.FieldName = 'PaidKindName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 60
        end
        object colContractCode: TcxGridDBColumn
          Caption = #1050#1086#1076' '#1076#1086#1075'.'
          DataBinding.FieldName = 'ContractCode'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 50
        end
        object colContractName: TcxGridDBColumn
          Caption = #8470' '#1076#1086#1075'.'
          DataBinding.FieldName = 'ContractName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 55
        end
        object colContractTagName: TcxGridDBColumn
          Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
          DataBinding.FieldName = 'ContractTagName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 60
        end
        object InsertDate: TcxGridDBColumn
          Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1074#1080#1079#1072' '#1042#1099#1074#1077#1079#1077#1085#1086' '#1089#1086' '#1089#1082#1083#1072#1076#1072')'
          DataBinding.FieldName = 'InsertDate'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 150
        end
        object MemberCode: TcxGridDBColumn
          Caption = #1050#1086#1076' '#1082#1083#1072#1076#1086#1074#1097#1080#1082#1072
          DataBinding.FieldName = 'MemberCode'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 55
        end
        object MemberName: TcxGridDBColumn
          Caption = #1050#1083#1072#1076#1086#1074#1097#1080#1082' ('#1074#1080#1079#1072' '#1042#1099#1074#1077#1079#1077#1085#1086' '#1089#1086' '#1089#1082#1083#1072#1076#1072')'
          DataBinding.FieldName = 'MemberName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 150
        end
      end
      object cxDBGridLevel: TcxGridLevel
        GridView = cxDBGridDBTableView
      end
    end
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 272
    Top = 384
  end
  object DataSource: TDataSource
    DataSet = CDS
    Left = 336
    Top = 384
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_Reestr'
    DataSet = CDS
    DataSets = <
      item
        DataSet = CDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 264
    Top = 296
  end
  object DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxDBGridDBTableView
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 384
    Top = 264
  end
end
