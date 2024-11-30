object WeighingPartnerJournalForm: TWeighingPartnerJournalForm
  Left = 0
  Top = 0
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077' ('#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090')>'
  ClientHeight = 427
  ClientWidth = 1240
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
    Top = 0
    Width = 1240
    Height = 31
    Align = alTop
    TabOrder = 1
    object deStart: TcxDateEdit
      Left = 107
      Top = 5
      EditValue = 45292d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 310
      Top = 5
      EditValue = 45292d
      Properties.ReadOnly = True
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
    Width = 1240
    Height = 370
    Align = alClient
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
          Column = TotalCount
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = TotalCountPartner
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = TotalCountTare
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = TotalSumm
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = TotalSummVAT
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = TotalSummMVAT
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = TotalSummPVAT
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = diffBegin_sec
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = TotalCountKg
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = TotalCountSh
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.####'
          Kind = skSum
          Column = TotalCount
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = TotalCountPartner
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = TotalCountTare
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = TotalSumm
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = TotalSummVAT
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = TotalSummMVAT
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = TotalSummPVAT
        end
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = FromName
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = diffBegin_sec
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = TotalCountKg
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = TotalCountSh
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
          end
          item
            Description = '--'#1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
            ImageIndex = 12
            Value = 4
          end>
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object BranchCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1060#1080#1083#1080#1072#1083#1072
        DataBinding.FieldName = 'BranchCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object MovementDescNumber: TcxGridDBColumn
        Caption = #8470' '#1086#1087#1077#1088'.'
        DataBinding.FieldName = 'MovementDescNumber'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object MovementDescName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
        DataBinding.FieldName = 'MovementDescName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object OperDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
        DataBinding.FieldName = 'OperDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object OperDatePartner: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1091' '#1082#1086#1085#1090#1088'.'
        DataBinding.FieldName = 'OperDatePartner'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1072#1090#1072' '#1076#1086#1082'. '#1091' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
        Options.Editing = False
        Width = 69
      end
      object isDocPartner: TcxGridDBColumn
        Caption = #1044#1086#1082'. '#1087#1086#1089#1090#1072#1074#1097'.'
        DataBinding.FieldName = 'isDocPartner'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1076#1072'/'#1085#1077#1090')'
        Options.Editing = False
        Width = 80
      end
      object InvNumberPartner: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1082'. '#1091' '#1082#1086#1085#1090#1088'.'
        DataBinding.FieldName = 'InvNumberPartner'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
        Options.Editing = False
        Width = 55
      end
      object OperDate_parent: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1076#1086#1082'. ('#1075#1083#1072#1074#1085#1099#1081')'
        DataBinding.FieldName = 'OperDate_parent'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object OperDate_TransportGoods: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1058#1058#1053
        DataBinding.FieldName = 'OperDate_TransportGoods'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object WeighingNumber: TcxGridDBColumn
        Caption = #8470' '#1074#1079#1074#1077#1096'.'
        DataBinding.FieldName = 'WeighingNumber'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 50
      end
      object InvNumber: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1082'.'
        DataBinding.FieldName = 'InvNumber'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object InvNumber_parent: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1082'. ('#1075#1083#1072#1074#1085#1099#1081')'
        DataBinding.FieldName = 'InvNumber_parent'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 65
      end
      object InvNumberOrder: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1082'. '#1086#1089#1085#1086#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'InvNumberOrder'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object InvNumber_ReturnInFull: TcxGridDBColumn
        Caption = #1053#1072' '#1086#1089#1085'. '#8470' ('#1074#1086#1079#1074#1088#1072#1090')'
        DataBinding.FieldName = 'InvNumber_ReturnInFull'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1053#1072' '#1086#1089#1085#1086#1074#1072#1085#1080#1080' '#8470' ('#1074#1086#1079#1074#1088#1072#1090')'
        Options.Editing = False
        Width = 78
      end
      object InvNumberPartner_Tax: TcxGridDBColumn
        Caption = #8470' '#1085#1072#1083#1086#1075'.'
        DataBinding.FieldName = 'InvNumberPartner_Tax'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object OperDate_Tax: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1085#1072#1083#1086#1075'.'
        DataBinding.FieldName = 'OperDate_Tax'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object InvNumber_TransportGoods: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1082'. '#1058#1058#1053
        DataBinding.FieldName = 'InvNumber_TransportGoods'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object InvNumber_Transport: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1082'. '#1055'.'#1083'.'
        DataBinding.FieldName = 'InvNumber_Transport'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 61
      end
      object OperDate_Transport: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1055'.'#1083'.'
        DataBinding.FieldName = 'OperDate_Transport'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object CarModelName: TcxGridDBColumn
        Caption = #1052#1072#1088#1082'a '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
        DataBinding.FieldName = 'CarModelName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 89
      end
      object CarName: TcxGridDBColumn
        Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100
        DataBinding.FieldName = 'CarName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object PersonalDriverName: TcxGridDBColumn
        Caption = #1042#1086#1076#1080#1090#1077#1083#1100'/ '#1069#1082#1089#1087#1077#1076#1080#1090#1086#1088
        DataBinding.FieldName = 'PersonalDriverName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object RouteGroupName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1084'. / '#1052#1072#1088#1096#1088#1091#1090
        DataBinding.FieldName = 'RouteGroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object RouteName: TcxGridDBColumn
        Caption = #1052#1072#1088#1096#1088#1091#1090
        DataBinding.FieldName = 'RouteName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 73
      end
      object RouteSortingName: TcxGridDBColumn
        Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1084#1072#1088#1096#1088#1091#1090#1072
        DataBinding.FieldName = 'RouteSortingName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object StartWeighing: TcxGridDBColumn
        Caption = #1053#1072#1095'. '#1074#1079#1074#1077#1096'.'
        DataBinding.FieldName = 'StartWeighing'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object EndWeighing: TcxGridDBColumn
        Caption = #1054#1082#1086#1085#1095'. '#1074#1079#1074#1077#1096'.'
        DataBinding.FieldName = 'EndWeighing'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object FromName: TcxGridDBColumn
        Caption = #1054#1090' '#1082#1086#1075#1086
        DataBinding.FieldName = 'FromName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object lToName: TcxGridDBColumn
        Caption = #1050#1086#1084#1091
        DataBinding.FieldName = 'ToName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object SubjectDocName: TcxGridDBColumn
        Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
        DataBinding.FieldName = 'SubjectDocName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 109
      end
      object UserName: TcxGridDBColumn
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
        DataBinding.FieldName = 'UserName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object RouteSorting: TcxGridDBColumn
        Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1084#1072#1088#1096#1088#1091#1090#1072
        DataBinding.FieldName = 'RouteSortingName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object PersonalGroupName: TcxGridDBColumn
        Caption = #8470' '#1073#1088#1080#1075#1072#1076#1099
        DataBinding.FieldName = 'PersonalGroupName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object UnitName_PersonalGroup: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076'. ('#8470#1073#1088#1080#1075#1072#1076#1099')'
        DataBinding.FieldName = 'UnitName_PersonalGroup'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#8470' '#1073#1088#1080#1075#1072#1076#1099')'
        Options.Editing = False
        Width = 81
      end
      object PaidKindName: TcxGridDBColumn
        Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
        DataBinding.FieldName = 'PaidKindName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 50
      end
      object TotalCount: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' ('#1089#1082#1083#1072#1076')'
        DataBinding.FieldName = 'TotalCount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object TotalCountPartner: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
        DataBinding.FieldName = 'TotalCountPartner'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object TotalCountKg: TcxGridDBColumn
        Caption = #1048#1090#1086#1075#1086' '#1050#1086#1083'-'#1074#1086' '#1074#1077#1089
        DataBinding.FieldName = 'TotalCountKg'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object TotalCountSh: TcxGridDBColumn
        Caption = #1048#1090#1086#1075#1086' '#1050#1086#1083'-'#1074#1086' '#1096#1090'.'
        DataBinding.FieldName = 'TotalCountSh'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object TotalCountTare: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1090#1072#1088#1099
        DataBinding.FieldName = 'TotalCountTare'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object TotalSumm: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057' ('#1080#1090#1086#1075')'
        DataBinding.FieldName = 'TotalSumm'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object ChangePercent: TcxGridDBColumn
        Caption = '(-)% '#1089#1082'. (+)% '#1085#1072#1094
        DataBinding.FieldName = 'ChangePercent'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object ChangePercentAmount: TcxGridDBColumn
        Caption = '% '#1089#1082#1080#1076#1082#1080' '#1082#1086#1083'.'
        DataBinding.FieldName = 'ChangePercentAmount'
        Options.Editing = False
        Width = 70
      end
      object isReason1: TcxGridDBColumn
        Caption = #1057#1082'. '#1087#1086' '#1058#1077#1084#1087#1077#1088#1072#1090#1091#1088#1077
        DataBinding.FieldName = 'isReason1'
        HeaderHint = #1055#1088#1080#1095#1080#1085#1072' '#1089#1082#1080#1076#1082#1080' '#1058#1077#1084#1087#1077#1088#1072#1090#1091#1088#1072
        Options.Editing = False
        Width = 70
      end
      object isReason2: TcxGridDBColumn
        Caption = #1057#1082'. '#1087#1086' '#1050#1072#1095#1077#1089#1090#1074#1091
        DataBinding.FieldName = 'isReason2'
        HeaderHint = #1055#1088#1080#1095#1080#1085#1072' '#1089#1082#1080#1076#1082#1080' '#1050#1072#1095#1077#1089#1090#1074#1086
        Options.Editing = False
        Width = 70
      end
      object PriceWithVAT: TcxGridDBColumn
        Caption = #1062#1077#1085#1099' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
        DataBinding.FieldName = 'PriceWithVAT'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object VATPercent: TcxGridDBColumn
        Caption = '% '#1053#1044#1057
        DataBinding.FieldName = 'VATPercent'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 36
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
        Width = 80
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
        Width = 70
      end
      object ContractName: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1075'.'
        DataBinding.FieldName = 'ContractName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object ContractTagName: TcxGridDBColumn
        Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
        DataBinding.FieldName = 'ContractTagName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
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
        Width = 80
      end
      object PersonalCode1_Stick: TcxGridDBColumn
        Caption = #1050#1086#1076'1 '#1089#1086#1090#1088'. '#1089#1090#1080#1082'.'
        DataBinding.FieldName = 'PersonalCode1_Stick'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object PersonalName1_Stick: TcxGridDBColumn
        Caption = 'C'#1090#1080#1082#1077#1088#1086#1074#1097#1080#1082' 1'
        DataBinding.FieldName = 'PersonalName1_Stick'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object PositionName1_Stick: TcxGridDBColumn
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' c'#1090#1080#1082'.1'
        DataBinding.FieldName = 'PositionName1_Stick'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object PersonalCode1: TcxGridDBColumn
        Caption = #1050#1086#1076'1 '#1089#1086#1090#1088'. '#1082#1086#1084#1087#1083'.'
        DataBinding.FieldName = 'PersonalCode1'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object PersonalName1: TcxGridDBColumn
        Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082' 1'
        DataBinding.FieldName = 'PersonalName1'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 120
      end
      object PersonalCode2: TcxGridDBColumn
        Caption = #1050#1086#1076'2 '#1089#1086#1090#1088'. '#1082#1086#1084#1087#1083'.'
        DataBinding.FieldName = 'PersonalCode2'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object PersonalName2: TcxGridDBColumn
        Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082' 2'
        DataBinding.FieldName = 'PersonalName2'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 120
      end
      object PersonalCode3: TcxGridDBColumn
        Caption = #1050#1086#1076'3 '#1089#1086#1090#1088'. '#1082#1086#1084#1087#1083'.'
        DataBinding.FieldName = 'PersonalCode3'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object PersonalName3: TcxGridDBColumn
        Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082' 3'
        DataBinding.FieldName = 'PersonalName3'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 120
      end
      object PersonalCode4: TcxGridDBColumn
        Caption = #1050#1086#1076'4 '#1089#1086#1090#1088'. '#1082#1086#1084#1087#1083'.'
        DataBinding.FieldName = 'PersonalCode4'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object PersonalName4: TcxGridDBColumn
        Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082' 4'
        DataBinding.FieldName = 'PersonalName4'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 120
      end
      object PersonalCode5: TcxGridDBColumn
        Caption = #1050#1086#1076'5 '#1089#1086#1090#1088'. '#1082#1086#1084#1087#1083'.'
        DataBinding.FieldName = 'PersonalCode5'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object PersonalName5: TcxGridDBColumn
        Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082' 5'
        DataBinding.FieldName = 'PersonalName5'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 120
      end
      object PositionName1: TcxGridDBColumn
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' '#1082#1086#1084#1087#1083'.1'
        DataBinding.FieldName = 'PositionName1'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object PositionName2: TcxGridDBColumn
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' '#1082#1086#1084#1087#1083'.2'
        DataBinding.FieldName = 'PositionName2'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object PositionName3: TcxGridDBColumn
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' '#1082#1086#1084#1087#1083'.3'
        DataBinding.FieldName = 'PositionName3'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object PositionName4: TcxGridDBColumn
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' '#1082#1086#1084#1087#1083'.4'
        DataBinding.FieldName = 'PositionName4'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object PositionName5: TcxGridDBColumn
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' '#1082#1086#1084#1087#1083'.5'
        DataBinding.FieldName = 'PositionName5'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object StartBegin: TcxGridDBColumn
        Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1085#1072#1095#1072#1083#1086
        DataBinding.FieldName = 'StartBegin'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1085#1072#1095#1072#1083#1086' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1103' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
        Width = 70
      end
      object EndBegin: TcxGridDBColumn
        Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1077
        DataBinding.FieldName = 'EndBegin'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1077' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1103' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
        Width = 70
      end
      object diffBegin_sec: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1089#1077#1082'.'
        DataBinding.FieldName = 'diffBegin_sec'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'-'#1074#1086' '#1089#1077#1082#1091#1085#1076' '#1087#1088#1080' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
        Width = 70
      end
      object isList: TcxGridDBColumn
        Caption = #1048#1085#1074#1077#1085#1090'. '#1076#1083#1103' '#1089#1087#1080#1089#1082#1072
        DataBinding.FieldName = 'isList'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 57
      end
      object isPromo: TcxGridDBColumn
        Caption = #1040#1082#1094#1080#1103
        DataBinding.FieldName = 'isPromo'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 56
      end
      object MovementPromo: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1082'. '#1072#1082#1094#1080#1103
        DataBinding.FieldName = 'MovementPromo'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object Comment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 132
      end
      object IP: TcxGridDBColumn
        DataBinding.FieldName = 'IP'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object cxLabel27: TcxLabel
    Left = 708
    Top = 6
    Caption = #1055#1088#1077#1076#1087#1088#1080#1103#1090#1080#1077':'
  end
  object edJuridicalBasis: TcxButtonEdit
    Left = 786
    Top = 5
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
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdatePersonalComlete'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbWeighingPartner_ActDiffF'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbsPrint'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementProtocol'
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
      Enabled = False
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
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
    object bbGridToExcel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
    end
    object bbReCompleteAll: TdxBarButton
      Caption = #1055#1077#1088#1077#1087#1088#1086#1074#1077#1089#1090#1080' '#1074#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      Category = 0
      Hint = #1055#1077#1088#1077#1087#1088#1086#1074#1077#1089#1090#1080' '#1074#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      Visible = ivAlways
      ImageIndex = 10
    end
    object bbShowErased: TdxBarButton
      Action = actShowErased
      Category = 0
    end
    object bbMovementProtocol: TdxBarButton
      Action = actMovementProtocol
      Category = 0
    end
    object bbUpdatePersonalComlete: TdxBarButton
      Action = macUpdatePersonalComlete
      Category = 0
    end
    object bbPrint_diff: TdxBarButton
      Action = actPrint_diff
      Category = 0
    end
    object bbPrint_all: TdxBarButton
      Action = actPrint_all
      Category = 0
    end
    object bbsPrint: TdxBarSubItem
      Caption = #1055#1077#1095#1072#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 3
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbPrint_diff'
        end
        item
          Visible = True
          ItemName = 'bbPrint_all'
        end>
    end
    object bbWeighingPartner_ActDiffF: TdxBarButton
      Action = actWeighingPartner_ActDiffF
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 96
    Top = 64
    object actPrint_all: TdsdPrintAction
      Category = 'Print'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrint_all
      StoredProcList = <
        item
          StoredProc = spSelectPrint_all
        end>
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
      Hint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
      ImageIndex = 17
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName;GoodsKindName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isAll'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_WeighingPartner'
      ReportNameParam.Value = 'PrintMovement_WeighingPartner'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
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
    object dsdGridToExcel: TdsdGridToExcel
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
      FormName = 'TIncomeForm'
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
      FormName = 'TWeighingPartnerForm'
      FormNameParam.Value = 'TWeighingPartnerForm'
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
    object actMovementProtocol: TdsdOpenForm
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
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
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
    object ExecuteDialogPersonalComlete: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1050#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082#1072#1084' / '#1057#1090#1080#1082#1077#1088#1086#1074#1097#1080#1082#1072#1084
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1050#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082#1072#1084' / '#1057#1090#1080#1082#1077#1088#1086#1074#1097#1080#1082#1072#1084
      ImageIndex = 55
      FormName = 'TWeighingPartnerDialogForm'
      FormNameParam.Value = 'TWeighingPartnerDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inPersonalId1'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PersonalId1'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPersonalName1'
          Value = '0'
          Component = ClientDataSet
          ComponentItem = 'PersonalName1'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPersonalId2'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PersonalId2'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPersonalName2'
          Value = '0'
          Component = ClientDataSet
          ComponentItem = 'PersonalName2'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPersonalId3'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PersonalId3'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPersonalName3'
          Value = '0'
          Component = ClientDataSet
          ComponentItem = 'PersonalName3'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPersonalId4'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PersonalId4'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPersonalName4'
          Value = '0'
          Component = ClientDataSet
          ComponentItem = 'PersonalName4'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPersonalId5'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PersonalId5'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPersonalName5'
          Value = '0'
          Component = ClientDataSet
          ComponentItem = 'PersonalName5'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPositionId1'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PositionId1'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPositionName1'
          Value = '0'
          Component = ClientDataSet
          ComponentItem = 'PositionName1'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPositionId2'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PositionId2'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPositionName2'
          Value = '0'
          Component = ClientDataSet
          ComponentItem = 'PositionName2'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPositionId3'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PositionId3'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPositionName3'
          Value = '0'
          Component = ClientDataSet
          ComponentItem = 'PositionName3'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPositionId4'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PositionId4'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPositionName4'
          Value = '0'
          Component = ClientDataSet
          ComponentItem = 'PositionName4'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPositionId5'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PositionId5'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPositionName5'
          Value = '0'
          Component = ClientDataSet
          ComponentItem = 'PositionName5'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPersonalId1_Stick'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PersonalId1_Stick'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPersonalName1_Stick'
          Value = '0'
          Component = ClientDataSet
          ComponentItem = 'PersonalName1_Stick'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPositionId1_Stick'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PositionId1_Stick'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPositionName1_Stick'
          Value = '0'
          Component = ClientDataSet
          ComponentItem = 'PositionName1_Stick'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdatePersonalComlete: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdate_PersonalComlete
      StoredProcList = <
        item
          StoredProc = spUpdate_PersonalComlete
        end>
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 55
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object macUpdatePersonalComlete: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogPersonalComlete
        end
        item
          Action = actUpdatePersonalComlete
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1050#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082#1072#1084' / '#1057#1090#1080#1082#1077#1088#1086#1074#1097#1080#1082#1072#1084
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1050#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082#1072#1084' / '#1057#1090#1080#1082#1077#1088#1086#1074#1097#1080#1082#1072#1084
      ImageIndex = 55
    end
    object actPrint_diff: TdsdPrintAction
      Category = 'Print'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrint_diff
      StoredProcList = <
        item
          StoredProc = spSelectPrint_diff
        end>
      Caption = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1087#1086' '#1094#1077#1085#1077
      Hint = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1087#1086' '#1094#1077#1085#1077
      ImageIndex = 20
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName;GoodsKindName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isAll'
          Value = 'false'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_WeighingPartner'
      ReportNameParam.Value = 'PrintMovement_WeighingPartner'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actWeighingPartner_ActDiffF: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1040#1082#1090' '#1088#1072#1079#1085#1086#1075#1083#1072#1089#1080#1081
      Hint = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1040#1082#1090' '#1088#1072#1079#1085#1086#1075#1083#1072#1089#1080#1081
      ImageIndex = 43
      FormName = 'TWeighingPartner_ActDiffForm'
      FormNameParam.Value = 'TWeighingPartner_ActDiffForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_WeighingPartner'
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
        Value = 41670d
        Component = deEnd
        DataType = ftDateTime
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
      end
      item
        Name = 'inJuridicalBasisId'
        Value = Null
        Component = JuridicalBasisGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 48
    Top = 184
  end
  object spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_WeighingPartner'
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
    Left = 64
    Top = 232
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 128
    Top = 64
    object N1: TMenuItem
      Action = actComplete
    end
    object N2: TMenuItem
      Action = actUnComplete
    end
  end
  object spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_WeighingPartner'
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
    StoredProcName = 'gpSetErased_Movement_WeighingPartner'
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
    Left = 472
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
    Left = 552
    Top = 24
  end
  object spMovementReCompleteAll: TdsdStoredProc
    DataSets = <>
    OutputType = otResult
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
        Name = 'inEndtDate'
        Value = 41670d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 248
    Top = 272
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
    Left = 880
    Top = 64
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 400
    Top = 200
  end
  object spUpdate_PersonalComlete: TdsdStoredProc
    StoredProcName = 'gpUpdate_Scale_Movement_PersonalComlete'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = '0'
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId1'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'PersonalId1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId2'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'PersonalId2'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId3'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'PersonalId3'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId4'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'PersonalId4'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId5'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'PersonalId5'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId1'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'PositionId1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId2'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'PositionId2'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId3'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'PositionId3'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId4'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'PositionId4'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId5'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'PositionId5'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId1_Stick'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'PersonalId1_Stick'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId1_Stick'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'PositionId1_Stick'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 602
    Top = 184
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 860
    Top = 230
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 860
    Top = 185
  end
  object spSelectPrint_diff: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_WeighingPartner_Print'
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
      end
      item
        Name = 'inisShowAll'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 935
    Top = 216
  end
  object spSelectPrint_all: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_WeighingPartner_Print'
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
      end
      item
        Name = 'inisShowAll'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 935
    Top = 264
  end
end
