object IncomeFuelJournalForm: TIncomeFuelJournalForm
  Left = 0
  Top = 0
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1047#1072#1087#1088#1072#1074#1082#1072' '#1072#1074#1090#1086')>'
  ClientHeight = 391
  ClientWidth = 1189
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 26
    Width = 1189
    Height = 31
    Align = alTop
    TabOrder = 1
    object deStart: TcxDateEdit
      Left = 101
      Top = 5
      EditValue = 42370d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 310
      Top = 5
      EditValue = 42370d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 85
    end
    object cxLabel1: TcxLabel
      Left = 10
      Top = 6
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
    end
    object cxLabel2: TcxLabel
      Left = 200
      Top = 6
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
    end
  end
  object cxGrid: TcxGrid
    Left = 0
    Top = 57
    Width = 1189
    Height = 334
    Align = alClient
    PopupMenu = PopupMenu
    TabOrder = 0
    LookAndFeel.NativeStyle = False
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive, fcoShowOperatorDescription]
      DataController.Filter.TranslateBetween = True
      DataController.Filter.TranslateIn = True
      DataController.Filter.TranslateLike = True
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Format = ',0.####'
          Kind = skSum
          Column = LimitMoney
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = LimitDistance
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = LimitMoneyChange
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = LimitDistanceChange
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Distance
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = DistanceReal
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = FuelCalc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = FuelRealCalc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = FuelReal
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummReal
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = FuelDiff
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = FuelSummDiff
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummDiff
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummDiffTotal
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummReparation
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummPersonal
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummaExp
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.####'
          Kind = skSum
          Column = LimitMoney
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = LimitDistance
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = LimitMoneyChange
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = LimitDistanceChange
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Distance
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = DistanceReal
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = FuelCalc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = FuelRealCalc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = FuelReal
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummReal
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = FuelDiff
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = FuelSummDiff
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummDiff
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummDiffTotal
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummReparation
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummPersonal
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SummaExp
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupSummaryLayout = gslAlignWithColumns
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object StatusCode: TcxGridDBColumn
        Caption = '*'#1057#1090#1072#1090#1091#1089
        DataBinding.FieldName = 'StatusCode'
        PropertiesClassName = 'TcxImageComboBoxProperties'
        Properties.Images = dmMain.ImageList
        Properties.Items = <
          item
            Description = #1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
            ImageIndex = 11
            Value = 4
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
          end
          item
            Description = '***'#1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
            ImageIndex = 32
            Value = 1
          end>
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object InvNumber: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1082'.'
        DataBinding.FieldName = 'InvNumber'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 50
      end
      object OperDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072
        DataBinding.FieldName = 'OperDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 59
      end
      object InvNumberPartner: TcxGridDBColumn
        Caption = #8470' '#1095#1077#1082#1072
        DataBinding.FieldName = 'InvNumberPartner'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object OperDatePartner: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1079#1072#1087#1088#1072#1074'.'
        DataBinding.FieldName = 'OperDatePartner'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
      end
      object InvNumberMaster: TcxGridDBColumn
        Caption = #8470' '#1055#1091#1090'. '#1083#1080#1089#1090
        DataBinding.FieldName = 'InvNumberMaster'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object OperDateMaster: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1055#1091#1090'. '#1083#1080#1089#1090
        DataBinding.FieldName = 'OperDateMaster'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 50
      end
      object JuridicalName_from: TcxGridDBColumn
        Caption = #1054#1090' '#1082#1086#1075#1086' ('#1070#1088'. '#1083#1080#1094#1086')'
        DataBinding.FieldName = 'JuridicalName_from'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object FromName: TcxGridDBColumn
        Caption = #1054#1090' '#1082#1086#1075#1086' ('#1048#1089#1090#1086#1095#1085#1080#1082' '#1079#1072#1087#1088#1072#1074#1082#1080')'
        DataBinding.FieldName = 'FromName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object ItemName: TcxGridDBColumn
        Caption = #1069#1083#1077#1084#1077#1085#1090' '#1082#1086#1084#1091
        DataBinding.FieldName = 'ItemName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 67
      end
      object ToName: TcxGridDBColumn
        Caption = #1050#1086#1084#1091' ('#1040#1074#1090#1086#1084#1086#1073#1080#1083#1100', '#1060#1080#1079'.'#1083'.)'
        DataBinding.FieldName = 'ToName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object RouteName: TcxGridDBColumn
        Caption = #1052#1072#1088#1096#1088#1091#1090
        DataBinding.FieldName = 'RouteName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object PersonalDriverName: TcxGridDBColumn
        Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1042#1086#1076#1080#1090#1077#1083#1100')'
        DataBinding.FieldName = 'PersonalDriverName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object BranchCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1092#1080#1083#1080#1072#1083#1072
        DataBinding.FieldName = 'BranchCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object BranchName: TcxGridDBColumn
        Caption = #1060#1080#1083#1080#1072#1083
        DataBinding.FieldName = 'BranchName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object PaidKindName: TcxGridDBColumn
        Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
        DataBinding.FieldName = 'PaidKindName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object ContractName: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1075'.'
        DataBinding.FieldName = 'ContractName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 50
      end
      object ChangePrice: TcxGridDBColumn
        Caption = #1057#1082#1080#1076#1082#1072' '#1074' '#1094#1077#1085#1077
        DataBinding.FieldName = 'ChangePrice'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 50
      end
      object isChangePriceUser: TcxGridDBColumn
        Caption = #1056#1091#1095#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1074' '#1094#1077#1085#1077' ('#1076#1072'/'#1085#1077#1090')'
        DataBinding.FieldName = 'isChangePriceUser'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1056#1091#1095#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1074' '#1094#1077#1085#1077' ('#1076#1072'/'#1085#1077#1090')'
        Options.Editing = False
        Width = 88
      end
      object TotalCount: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086
        DataBinding.FieldName = 'TotalCount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object TotalCountPartner: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' ('#1091' '#1087#1086#1089#1090'.)'
        DataBinding.FieldName = 'TotalCountPartner'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object TotalSumm: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057' ('#1080#1090#1086#1075')'
        DataBinding.FieldName = 'TotalSumm'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object TotalSummPVAT: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
        DataBinding.FieldName = 'TotalSummPVAT'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object TotalSummMVAT: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057
        DataBinding.FieldName = 'TotalSummMVAT'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object TotalSummVAT: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' '#1053#1044#1057
        DataBinding.FieldName = 'TotalSummVAT'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 50
      end
      object PriceWithVAT: TcxGridDBColumn
        Caption = #1062#1077#1085#1099' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
        DataBinding.FieldName = 'PriceWithVAT'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object VATPercent: TcxGridDBColumn
        Caption = '% '#1053#1044#1057
        DataBinding.FieldName = 'VATPercent'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 40
      end
      object InfoMoneyCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1059#1055
        DataBinding.FieldName = 'InfoMoneyCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 50
      end
      object InfoMoneyGroupName: TcxGridDBColumn
        Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'InfoMoneyGroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object InfoMoneyDestinationName: TcxGridDBColumn
        Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
        DataBinding.FieldName = 'InfoMoneyDestinationName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object InfoMoneyName: TcxGridDBColumn
        Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'InfoMoneyName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object GoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1090#1086#1074'.'
        DataBinding.FieldName = 'GoodsCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object GoodsName: TcxGridDBColumn
        Caption = #1058#1086#1074#1072#1088
        DataBinding.FieldName = 'GoodsName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 75
      end
      object FuelCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1074#1080#1076#1072' '#1090#1086#1087#1083'.'
        DataBinding.FieldName = 'FuelCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object FuelName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1090#1086#1087#1083#1080#1074#1072
        DataBinding.FieldName = 'FuelName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 75
      end
      object StartOdometre: TcxGridDBColumn
        Caption = #1057#1087#1080#1076#1086#1084#1077#1090#1088' '#1085#1072#1095'. '#1082#1084
        DataBinding.FieldName = 'StartOdometre'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 75
      end
      object EndOdometre: TcxGridDBColumn
        Caption = #1057#1087#1080#1076#1086#1084#1077#1090#1088' '#1082#1086#1085'. '#1082#1084
        DataBinding.FieldName = 'EndOdometre'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 75
      end
      object AmountFuel: TcxGridDBColumn
        Caption = #1053#1086#1088#1084#1072' '#1072#1074#1090#1086#1084'.'
        DataBinding.FieldName = 'AmountFuel'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
      object Reparation: TcxGridDBColumn
        Caption = #1040#1084#1086#1088#1090'. '#1079#1072' 1 '#1082#1084', '#1075#1088#1085'.'
        DataBinding.FieldName = 'Reparation'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object LimitDistance: TcxGridDBColumn
        Caption = #1051#1080#1084#1080#1090' '#1082#1084
        DataBinding.FieldName = 'LimitDistance'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object LimitDistanceChange: TcxGridDBColumn
        Caption = #1051#1080#1084#1080#1090' ('#1089#1083#1091#1078'.) '#1082#1084
        DataBinding.FieldName = 'LimitDistanceChange'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object LimitMoney: TcxGridDBColumn
        Caption = #1051#1080#1084#1080#1090' '#1075#1088#1085
        DataBinding.FieldName = 'LimitMoney'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object LimitMoneyChange: TcxGridDBColumn
        Caption = #1051#1080#1084#1080#1090' ('#1089#1083#1091#1078'.) '#1075#1088#1085
        DataBinding.FieldName = 'LimitMoneyChange'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object DistanceReal: TcxGridDBColumn
        Caption = #1055#1088#1086#1073#1077#1075' '#1086#1073#1097#1080#1081' '#1082#1084
        DataBinding.FieldName = 'DistanceReal'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object Distance: TcxGridDBColumn
        Caption = #1055#1088#1086#1073#1077#1075' '#1092#1072#1082#1090' '#1082#1084
        DataBinding.FieldName = 'Distance'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object FuelCalc: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1083'. ('#1088#1072#1089#1095'. '#1085#1072' '#1087#1088#1086#1073#1077#1075' '#1092'.)'
        DataBinding.FieldName = 'FuelCalc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object FuelRealCalc: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1083'. ('#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1086')'
        DataBinding.FieldName = 'FuelRealCalc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object FuelReal: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1083'. ('#1079#1072#1087#1088#1072#1074#1082#1072')'
        DataBinding.FieldName = 'FuelReal'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object PriceCalc: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' '#1079#1072#1087#1088#1072#1074'.'
        DataBinding.FieldName = 'PriceCalc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object SummReal: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' '#1079#1072#1087#1088#1072#1074#1082#1080
        DataBinding.FieldName = 'SummReal'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object SummaExp: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' '#1079#1072#1090#1088#1072#1090
        DataBinding.FieldName = 'SummaExp'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object FuelDiff: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1083'. ('#1086#1089#1090#1072#1090#1086#1082' '#1083#1080#1084'. '#1082#1084'.)'
        DataBinding.FieldName = 'FuelDiff'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object FuelSummDiff: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' '#1075#1088#1085' ('#1086#1089#1090#1072#1090#1086#1082' '#1083#1080#1084'. '#1082#1084'.)'
        DataBinding.FieldName = 'FuelSummDiff'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object SummDiff: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' '#1075#1088#1085' ('#1086#1089#1090#1072#1090#1086#1082' '#1083#1080#1084'. '#1075#1088#1085')'
        DataBinding.FieldName = 'SummDiff'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object SummDiffTotal: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' '#1075#1088#1085' ('#1086#1089#1090#1072#1090#1086#1082' '#1048#1058#1054#1043#1054')'
        DataBinding.FieldName = 'SummDiffTotal'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object SummReparation: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' '#1075#1088#1085' ('#1072#1084#1086#1088#1090#1080#1079#1072#1094#1080#1103')'
        DataBinding.FieldName = 'SummReparation'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object SummPersonal: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' '#1075#1088#1085' ('#1047#1055' '#1080#1090#1086#1075')'
        DataBinding.FieldName = 'SummPersonal'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object strSign: TcxGridDBColumn
        Caption = #1060#1048#1054' '#1087#1086#1083#1100#1079'. - '#1077#1089#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
        DataBinding.FieldName = 'strSign'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object strSignNo: TcxGridDBColumn
        Caption = #1060#1048#1054' '#1087#1086#1083#1100#1079'. - '#1086#1078#1080#1076#1072#1077#1090#1089#1103' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
        DataBinding.FieldName = 'strSignNo'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object cxLabel27: TcxLabel
    Left = 822
    Top = 32
    Caption = #1055#1088#1077#1076#1087#1088#1080#1103#1090#1080#1077':'
  end
  object edJuridicalBasis: TcxButtonEdit
    Left = 900
    Top = 32
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 150
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 24
    Top = 136
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 64
    Top = 136
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
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 16
    Top = 64
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
    Left = 48
    Top = 64
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar: TdxBar
      AllowClose = False
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 51
      FloatClientHeight = 71
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
          BeginGroup = True
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbComplete'
        end
        item
          Visible = True
          ItemName = 'bbUnComplete'
        end
        item
          Visible = True
          ItemName = 'bbDelete'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_ChangePrice'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdateMISignYesList'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdateMISignNoList'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbMIContainer'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocol'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
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
      ImageIndex = 0
    end
    object bbEdit: TdxBarButton
      Action = actUpdate
      Category = 0
      ImageIndex = 1
    end
    object bbComplete: TdxBarButton
      Action = actComplete
      Category = 0
    end
    object bbUnComplete: TdxBarButton
      Action = actUnComplete
      Category = 0
    end
    object bbDelete: TdxBarButton
      Action = actSetErased
      Category = 0
    end
    object bbStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
    object bbGridToExcel: TdxBarButton
      Action = actGridToExcel
      Category = 0
    end
    object bbReCompleteAll: TdxBarButton
      Action = actReCompleteAll
      Category = 0
    end
    object bbMIContainer: TdxBarButton
      Action = actMIContainer
      Category = 0
    end
    object bbProtocol: TdxBarButton
      Action = MovementProtocolOpenForm
      Category = 0
    end
    object bbShowErased: TdxBarButton
      Action = actShowErased
      Category = 0
    end
    object bbUpdate_ChangePrice: TdxBarButton
      Action = macUpdate_ChangePriceList
      Category = 0
    end
    object bbInsertUpdateMISignYesList: TdxBarButton
      Action = mactInsertUpdateMISignYesList
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbInsertUpdateMISignNoList: TdxBarButton
      Action = mactInsertUpdateMISignNoList
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 80
    Top = 64
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
    object actGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      FormName = 'TIncomeFuelForm'
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
          Name = 'ShowAll'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
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
      FormName = 'TIncomeFuelForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUnComplete: TdsdChangeMovementStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spMovementUnComplete
      StoredProcList = <
        item
          StoredProc = spMovementUnComplete
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 11
      Status = mtUncomplete
      DataSource = DataSource
    end
    object actComplete: TdsdChangeMovementStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spMovementComplete
      StoredProcList = <
        item
          StoredProc = spMovementComplete
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 12
      Status = mtComplete
      DataSource = DataSource
    end
    object actSetErased: TdsdChangeMovementStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spMovementSetErased
      StoredProcList = <
        item
          StoredProc = spMovementSetErased
        end>
      Caption = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      Hint = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      ImageIndex = 13
      Status = mtDelete
      DataSource = DataSource
    end
    object actReCompleteAll: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = #1055#1077#1088#1077#1087#1088#1086#1074#1077#1089#1090#1080' '#1074#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      Hint = #1055#1077#1088#1077#1087#1088#1086#1074#1077#1089#1090#1080' '#1074#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      ImageIndex = 10
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1087#1077#1088#1077#1087#1088#1086#1074#1077#1089#1090#1080' '#1074#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1079#1072' '#1087#1077#1088#1080#1086#1076'?'
      InfoAfterExecute = #1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1087#1077#1088#1077#1087#1088#1086#1074#1077#1076#1077#1085#1099'.'
    end
    object actMIContainer: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1074#1086#1076#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1074#1086#1076#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 57
      FormName = 'TMovementItemContainerForm'
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
    end
    object MovementProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 34
      FormName = 'TMovementProtocolForm'
      FormNameParam.Value = 'TMovementProtocolForm'
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
          Name = 'InvNumber'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'InvNumber'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actShowErased: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
    object spCompete: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spMovementComplete
      StoredProcList = <
        item
          StoredProc = spMovementComplete
        end>
      Caption = 'spCompete'
    end
    object actSimpleCompleteList: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spCompete
        end>
      View = cxGridDBTableView
      Caption = #1055#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
      Hint = #1055#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
    end
    object mactUpdate_ChangePrice: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_ChangePrice
        end>
      View = cxGridDBTableView
    end
    object macUpdate_ChangePriceList: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = mactUpdate_ChangePrice
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1080#1079#1084#1077#1085#1077#1085#1080#1080' '#1089#1082#1080#1076#1082#1080' '#1074' '#1094#1077#1085#1077' '#1074#1086' '#1074#1089#1077#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1093'? '
      InfoAfterExecute = #1057#1082#1080#1076#1082#1072' '#1074' '#1094#1077#1085#1077' '#1080#1079#1084#1077#1085#1077#1085#1072
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1089#1082#1080#1076#1082#1091' '#1074' '#1094#1077#1085#1077' '#1074#1086' '#1074#1089#1077#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1093
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1089#1082#1080#1076#1082#1091' '#1074' '#1094#1077#1085#1077' '#1074#1086' '#1074#1089#1077#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1093
      ImageIndex = 27
    end
    object actCompleteList: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSimpleCompleteList
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1080' '#1042#1057#1045#1061' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'? '
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1087#1088#1086#1074#1077#1076#1077#1085#1099
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      Hint = #1055#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
      ImageIndex = 12
    end
    object spUncomplete: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spMovementUnComplete
      StoredProcList = <
        item
          StoredProc = spMovementUnComplete
        end>
      Caption = 'spUncomplete'
    end
    object actSimpleUncompleteList: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spUncomplete
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      Hint = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
    end
    object actUnCompleteList: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSimpleUncompleteList
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1088#1072#1089#1087#1088#1086#1074#1077#1076#1077#1085#1080#1080' '#1042#1057#1045#1061' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'? '
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1088#1072#1089#1087#1088#1086#1074#1077#1076#1077#1085#1099
      Caption = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1042#1057#1045'  '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      Hint = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      ImageIndex = 11
    end
    object spErased: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spMovementSetErased
      StoredProcList = <
        item
          StoredProc = spMovementSetErased
        end>
      Caption = 'spErased'
    end
    object actSimpleErased: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spErased
        end>
      View = cxGridDBTableView
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
    end
    object actSetErasedList: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSimpleErased
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080' '#1042#1057#1045#1061' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'? '
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1091#1076#1072#1083#1077#1085#1099
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1042#1057#1045' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      ImageIndex = 13
    end
    object spReCompete: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spMovementReComplete
      StoredProcList = <
        item
          StoredProc = spMovementReComplete
        end>
      Caption = 'spReCompete'
    end
    object actSimpleReCompleteList: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spReCompete
        end>
      View = cxGridDBTableView
      Caption = #1055#1077#1088#1077#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
      Hint = #1055#1077#1088#1077#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TMovement_PeriodDialogForm'
      FormNameParam.Value = 'TMovement_PeriodDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actReCompleteList: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSimpleReCompleteList
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1087#1077#1088#1077#1087#1088#1086#1074#1077#1076#1077#1085#1080#1080' '#1042#1089#1077#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'? '
      InfoAfterExecute = #1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1087#1077#1088#1077#1087#1088#1086#1074#1077#1076#1077#1085#1099
      Caption = #1055#1077#1088#1077#1087#1088#1086#1074#1077#1089#1090#1080' '#1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      Hint = #1055#1077#1088#1077#1087#1088#1086#1074#1077#1089#1090#1080' '#1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      ImageIndex = 12
    end
    object actUpdate_ChangePrice: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_ChangePrice
      StoredProcList = <
        item
          StoredProc = spUpdate_ChangePrice
        end>
      Caption = 'ChangePrice'
    end
    object actInsertUpdateMISignYes: TdsdExecStoredProc
      Category = 'Sign'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMISign_Yes
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMISign_Yes
        end
        item
        end>
      Caption = #1055#1086#1089#1090#1072#1074#1080#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
      Hint = #1055#1086#1089#1090#1072#1074#1080#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
    end
    object mactInsertUpdateMISignYes: TMultiAction
      Category = 'Sign'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdateMISignYes
        end>
      View = cxGridDBTableView
      Caption = #1055#1086#1089#1090#1072#1074#1080#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
      Hint = #1055#1086#1089#1090#1072#1074#1080#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
    end
    object mactInsertUpdateMISignYesList: TMultiAction
      Category = 'Sign'
      MoveParams = <>
      ActionList = <
        item
          Action = mactInsertUpdateMISignYes
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1074#1080#1090#1077#1083#1100#1085#1086' '#1087#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1042#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084'? '
      InfoAfterExecute = #1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1087#1086#1076#1087#1080#1089#1072#1085#1099' '#1091#1089#1087#1077#1096#1085#1086
      Caption = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1042#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
      Hint = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1042#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
      ImageIndex = 58
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'InvNumber'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'From'
          Value = ''
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 42370d
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_IncomeFuel'
      ReportNameParam.Value = 'PrintMovement_IncomeFuel'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actInsertUpdateMISignNo: TdsdExecStoredProc
      Category = 'Sign'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMISign_No
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMISign_No
        end
        item
        end>
      Caption = #1059#1073#1088#1072#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
      Hint = #1059#1073#1088#1072#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
    end
    object mactInsertUpdateMISignNo: TMultiAction
      Category = 'Sign'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdateMISignNo
        end>
      View = cxGridDBTableView
      Caption = #1059#1073#1088#1072#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
      Hint = #1059#1073#1088#1072#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
    end
    object mactInsertUpdateMISignNoList: TMultiAction
      Category = 'Sign'
      MoveParams = <>
      ActionList = <
        item
          Action = mactInsertUpdateMISignNo
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1084#1077#1085#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1042#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084'? '
      InfoAfterExecute = #1042#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084' '#1087#1086#1076#1087#1080#1089#1100' '#1086#1090#1084#1077#1085#1077#1085#1072' '#1091#1089#1087#1077#1096#1085#1086
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1042#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1042#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
      ImageIndex = 52
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_UserJuridicalBasis
      StoredProcList = <
        item
          StoredProc = spGet_UserJuridicalBasis
        end
        item
          StoredProc = dsdStoredProc
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_IncomeFuel'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
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
        Name = 'inJuridicalBasisId'
        Value = Null
        Component = JuridicalBasisGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = Null
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 24
    Top = 176
  end
  object spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_Income'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsLastComplete'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 64
    Top = 232
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 112
    Top = 64
    object N1: TMenuItem
      Action = actComplete
    end
    object N2: TMenuItem
      Action = actUnComplete
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object N7: TMenuItem
      Action = actReCompleteList
    end
    object N4: TMenuItem
      Action = actCompleteList
    end
    object N5: TMenuItem
      Action = actUnCompleteList
    end
    object N6: TMenuItem
      Action = actSetErasedList
    end
  end
  object spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 72
    Top = 272
  end
  object spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 72
    Top = 320
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 240
    Top = 168
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = actUpdate
      end>
    ActionItemList = <
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
    Left = 248
    Top = 216
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 488
    Top = 24
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
        Component = JuridicalBasisGuides
      end>
    Left = 576
    Top = 24
  end
  object spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_Income'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsLastComplete'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 225
    Top = 289
  end
  object spUpdate_ChangePrice: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_IncomeFuel_ChangePrice'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = 42370d
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 440
    Top = 184
  end
  object spInsertUpdateMISign_Yes: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_IncomeFuel_Sign'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSign'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 712
    Top = 179
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 812
    Top = 177
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 812
    Top = 230
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_IncomeFuel_Print'
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
        Name = 'inMovementId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 911
    Top = 192
  end
  object spInsertUpdateMISign_No: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_IncomeFuel_Sign'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSign'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 704
    Top = 227
  end
  object JuridicalBasisGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridicalBasis
    Key = '0'
    FormNameParam.Value = 'TJuridical_BasisForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_BasisForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = JuridicalBasisGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalBasisGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 943
  end
  object spGet_UserJuridicalBasis: TdsdStoredProc
    StoredProcName = 'gpGet_User_JuridicalBasis'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'JuridicalBasisId'
        Value = '0'
        Component = JuridicalBasisGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalBasisName'
        Value = ''
        Component = JuridicalBasisGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 824
    Top = 48
  end
end
