object WeighingPartnerItemJournalForm: TWeighingPartnerItemJournalForm
  Left = 0
  Top = 0
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1055#1088#1086#1090#1086#1082#1086#1083' <'#1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077' ('#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090')>'
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
      Left = 101
      Top = 5
      EditValue = 43466d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 310
      Top = 5
      EditValue = 43466d
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
          Column = miAmount
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = HeadCount
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Count
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = RealWeight
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountTare
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = WeightTare
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = AmountPartner
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = BoxCount
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = diffBegin_sec
        end
        item
          Format = ',0.####'
          Column = Count_Doc
        end
        item
          Kind = skSum
          Position = spFooter
          Column = Count_Doc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Count_Item
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = diffBegin_sec_movement
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = MIAmount_Weight
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = AmountPartner_Weight
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = RealWeight_Weight
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.####'
          Kind = skSum
          Column = miAmount
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = HeadCount
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Count
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = RealWeight
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountTare
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = WeightTare
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = AmountPartner
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = BoxCount
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
          Column = Count_Doc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Count_Item
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = diffBegin_sec_movement
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = MIAmount_Weight
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = AmountPartner_Weight
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = RealWeight_Weight
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
      object Count_Doc: TcxGridDBColumn
        Caption = #1050#1086#1083'. '#1076#1086#1082'.'
        DataBinding.FieldName = 'Count_Doc'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object Count_Item: TcxGridDBColumn
        Caption = #1050#1086#1083'. '#1089#1090#1088#1086#1082' '#1076#1086#1082'.'
        DataBinding.FieldName = 'Count_Item'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
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
      object MovementDescNumber: TcxGridDBColumn
        Caption = #8470' '#1086#1087#1077#1088'.'
        DataBinding.FieldName = 'MovementDescNumber'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 50
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
      object OperDate_parent: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1076#1086#1082'. ('#1075#1083#1072#1074#1085#1099#1081')'
        DataBinding.FieldName = 'OperDate_parent'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object OperDatePartner: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1091' '#1082#1086#1085#1090#1088'.'
        DataBinding.FieldName = 'OperDatePartner'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1072#1090#1072' '#1076#1086#1082'. '#1091' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
        Width = 72
      end
      object InvNumberPartner: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1082'. '#1091' '#1082#1086#1085#1090#1088'.'
        DataBinding.FieldName = 'InvNumberPartner'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
        Options.Editing = False
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
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1053#1072' '#1086#1089#1085#1086#1074#1072#1085#1080#1080' '#8470' ('#1074#1086#1079#1074#1088#1072#1090')'
        Options.Editing = False
        Width = 78
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
        Caption = #1053#1072#1095'. '#1074#1079#1074#1077#1096'. ('#1080#1090#1086#1075')'
        DataBinding.FieldName = 'StartWeighing'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object EndWeighing: TcxGridDBColumn
        Caption = #1054#1082#1086#1085#1095'. '#1074#1079#1074#1077#1096'. ('#1080#1090#1086#1075')'
        DataBinding.FieldName = 'EndWeighing'
        Visible = False
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
      object ToName: TcxGridDBColumn
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
      object UserName: TcxGridDBColumn
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
        DataBinding.FieldName = 'UserName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object isList: TcxGridDBColumn
        Caption = #1048#1085#1074#1077#1085#1090'. '#1076#1083#1103' '#1089#1087#1080#1089#1082#1072
        DataBinding.FieldName = 'isList'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 57
      end
      object Comment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 119
      end
      object PaidKindName: TcxGridDBColumn
        Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
        DataBinding.FieldName = 'PaidKindName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 50
      end
      object ChangePercent: TcxGridDBColumn
        Caption = '(-)% '#1089#1082'. (+)% '#1085#1072#1094
        DataBinding.FieldName = 'ChangePercent'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object PriceWithVAT: TcxGridDBColumn
        Caption = #1062#1077#1085#1099' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
        DataBinding.FieldName = 'PriceWithVAT'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object VATPercent: TcxGridDBColumn
        Caption = '% '#1053#1044#1057
        DataBinding.FieldName = 'VATPercent'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 36
      end
      object ContractName: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1075'.'
        DataBinding.FieldName = 'ContractName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object ContractTagName: TcxGridDBColumn
        Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
        DataBinding.FieldName = 'ContractTagName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object GoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object GoodsName: TcxGridDBColumn
        Caption = #1058#1086#1074#1072#1088
        DataBinding.FieldName = 'GoodsName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object GoodsKindName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsKindName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object MeasureName: TcxGridDBColumn
        Caption = #1045#1076'. '#1080#1079#1084'.'
        DataBinding.FieldName = 'MeasureName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 36
      end
      object isBarCode: TcxGridDBColumn
        Caption = #1057#1082#1072#1085
        DataBinding.FieldName = 'isBarCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 35
      end
      object InsertDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1089#1086#1079#1076#1072#1085#1080#1103
        DataBinding.FieldName = 'InsertDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object UpdateDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1080
        DataBinding.FieldName = 'UpdateDate'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object PartionGoodsDate: TcxGridDBColumn
        Caption = #1055#1072#1088#1090#1080#1103' '#1076#1072#1090#1072
        DataBinding.FieldName = 'PartionGoodsDate'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 64
      end
      object ChangePercent_mi: TcxGridDBColumn
        Caption = '(-)% '#1057#1082'. (+)% '#1053#1072#1094'. - '#1101#1083#1077#1084#1077#1085#1090
        DataBinding.FieldName = 'ChangePercent_mi'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object MovementPromo: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1082'. '#1072#1082#1094#1080#1103
        DataBinding.FieldName = 'MovementPromo'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object miAmount: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086
        DataBinding.FieldName = 'MIAmount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 51
      end
      object RealWeight: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088#1080' '#1074#1079#1074#1077#1096'.'
        DataBinding.FieldName = 'RealWeight'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object RealWeight_Weight: TcxGridDBColumn
        Caption = #1042#1077#1089' '#1087#1088#1080' '#1074#1079#1074#1077#1096'.'
        DataBinding.FieldName = 'RealWeight_Weight'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
      end
      object CountTare: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1090#1072#1088#1099
        DataBinding.FieldName = 'CountTare'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 60
      end
      object WeightTare: TcxGridDBColumn
        Caption = #1042#1077#1089' '#1090#1072#1088#1099
        DataBinding.FieldName = 'WeightTare'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 55
      end
      object CountTare1: TcxGridDBColumn
        Caption = #1050#1086#1083'. '#1103#1097'. '#1074#1080#1076#1072'1'
        DataBinding.FieldName = 'CountTare1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1103#1097'. '#1074#1080#1076#1072'1'
        Width = 70
      end
      object WeightTare1: TcxGridDBColumn
        Caption = #1042#1077#1089' '#1103#1097'. '#1074#1080#1076#1072'1'
        DataBinding.FieldName = 'WeightTare1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1090#1086#1075#1086' '#1074#1077#1089' '#1103#1097'. '#1074#1080#1076#1072'1'
        Width = 55
      end
      object CountTare2: TcxGridDBColumn
        Caption = #1050#1086#1083'. '#1103#1097'. '#1074#1080#1076#1072'2'
        DataBinding.FieldName = 'CountTare2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1103#1097'. '#1074#1080#1076#1072'2'
        Width = 70
      end
      object WeightTare2: TcxGridDBColumn
        Caption = #1042#1077#1089' '#1103#1097'. '#1074#1080#1076#1072'2'
        DataBinding.FieldName = 'WeightTare2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1090#1086#1075#1086' '#1074#1077#1089' '#1103#1097'. '#1074#1080#1076#1072'2'
        Width = 55
      end
      object CountTare3: TcxGridDBColumn
        Caption = #1050#1086#1083'. '#1103#1097'. '#1074#1080#1076#1072'3'
        DataBinding.FieldName = 'CountTare3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1103#1097'. '#1074#1080#1076#1072'3'
        Width = 70
      end
      object WeightTare3: TcxGridDBColumn
        Caption = #1042#1077#1089' '#1103#1097'. '#1074#1080#1076#1072'3'
        DataBinding.FieldName = 'WeightTare3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1090#1086#1075#1086' '#1074#1077#1089' '#1103#1097'. '#1074#1080#1076#1072'3'
        Width = 55
      end
      object CountTare4: TcxGridDBColumn
        Caption = #1050#1086#1083'. '#1103#1097'. '#1074#1080#1076#1072'4'
        DataBinding.FieldName = 'CountTare4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1103#1097'. '#1074#1080#1076#1072'4'
        Width = 70
      end
      object WeightTare4: TcxGridDBColumn
        Caption = #1042#1077#1089' '#1103#1097'. '#1074#1080#1076#1072'4'
        DataBinding.FieldName = 'WeightTare4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1090#1086#1075#1086' '#1074#1077#1089' '#1103#1097'. '#1074#1080#1076#1072'4'
        Width = 55
      end
      object CountTare5: TcxGridDBColumn
        Caption = #1050#1086#1083'. '#1103#1097'. '#1074#1080#1076#1072'5'
        DataBinding.FieldName = 'CountTare5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1103#1097'. '#1074#1080#1076#1072'5'
        Width = 70
      end
      object WeightTare5: TcxGridDBColumn
        Caption = #1042#1077#1089' '#1103#1097'. '#1074#1080#1076#1072'5'
        DataBinding.FieldName = 'WeightTare5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1090#1086#1075#1086' '#1074#1077#1089' '#1103#1097'. '#1074#1080#1076#1072'5'
        Width = 55
      end
      object CountTare6: TcxGridDBColumn
        Caption = #1050#1086#1083'. '#1103#1097'. '#1074#1080#1076#1072'6'
        DataBinding.FieldName = 'CountTare6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1103#1097'. '#1074#1080#1076#1072'6'
        Width = 70
      end
      object WeightTare6: TcxGridDBColumn
        Caption = #1042#1077#1089' '#1103#1097'. '#1074#1080#1076#1072'6'
        DataBinding.FieldName = 'WeightTare6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1090#1086#1075#1086' '#1074#1077#1089' '#1103#1097'. '#1074#1080#1076#1072'6'
        Width = 55
      end
      object ChangePercentAmount: TcxGridDBColumn
        Caption = '% '#1089#1082#1080#1076#1082#1080' '#1074#1077#1089
        DataBinding.FieldName = 'ChangePercentAmount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 50
      end
      object AmountPartner: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
        DataBinding.FieldName = 'AmountPartner'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 70
      end
      object MIAmount_Weight: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' ('#1074#1077#1089')'
        DataBinding.FieldName = 'MIAmount_Weight'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
      end
      object AmountPartner_Weight: TcxGridDBColumn
        Caption = #1042#1077#1089' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
        DataBinding.FieldName = 'AmountPartner_Weight'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
      end
      object Count: TcxGridDBColumn
        Caption = #1050#1086#1083'. '#1073#1072#1090#1086#1085#1086#1074
        DataBinding.FieldName = 'Count'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 50
      end
      object CountPack: TcxGridDBColumn
        Caption = #1050#1086#1083'. '#1091#1087#1072#1082#1086#1074#1086#1082
        DataBinding.FieldName = 'CountPack'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 49
      end
      object WeightPack: TcxGridDBColumn
        Caption = #1042#1077#1089'  1-'#1086#1081' '#1091#1087'.'
        DataBinding.FieldName = 'WeightPack'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 60
      end
      object BoxCount: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1075#1086#1092'. '#1103#1097'.'
        DataBinding.FieldName = 'BoxCount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 70
      end
      object BoxNumber: TcxGridDBColumn
        Caption = #8470' '#1103#1097#1080#1082#1072
        DataBinding.FieldName = 'BoxNumber'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 70
      end
      object BoxName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1075#1086#1092'. '#1103#1097'.'
        DataBinding.FieldName = 'BoxName'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 70
      end
      object LevelNumber: TcxGridDBColumn
        Caption = #8470' '#1089#1083#1086#1103
        DataBinding.FieldName = 'LevelNumber'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 49
      end
      object HeadCount: TcxGridDBColumn
        Caption = #1050#1086#1083'. '#1075#1086#1083#1086#1074
        DataBinding.FieldName = 'HeadCount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 40
      end
      object PriceListName: TcxGridDBColumn
        Caption = #1055#1088#1072#1081#1089
        DataBinding.FieldName = 'PriceListName'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 46
      end
      object Price: TcxGridDBColumn
        Caption = #1062#1077#1085#1072
        DataBinding.FieldName = 'Price'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object StartBegin_movement: TcxGridDBColumn
        Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1085#1072#1095#1072#1083#1086' ('#1076#1086#1082'.)'
        DataBinding.FieldName = 'StartBegin_movement'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object EndBegin_movement: TcxGridDBColumn
        Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1077' ('#1076#1086#1082'.)'
        DataBinding.FieldName = 'EndBegin_movement'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object diffBegin_sec_movement: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1089#1077#1082'. ('#1076#1086#1082'.)'
        DataBinding.FieldName = 'diffBegin_sec_movement'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object StartBegin: TcxGridDBColumn
        Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1085#1072#1095#1072#1083#1086
        DataBinding.FieldName = 'StartBegin'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object EndBegin: TcxGridDBColumn
        Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1077
        DataBinding.FieldName = 'EndBegin'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object diffBegin_sec: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1089#1077#1082'.'
        DataBinding.FieldName = 'diffBegin_sec'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object IP: TcxGridDBColumn
        DataBinding.FieldName = 'IP'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object IsErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
        DataBinding.FieldName = 'isErased'
        Visible = False
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
  object edGoodsGroup: TcxButtonEdit
    Left = 492
    Top = 5
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 200
  end
  object cxLabel3: TcxLabel
    Left = 403
    Top = 6
    Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074':'
  end
  object cxLabel4: TcxLabel
    Left = 701
    Top = 6
    Caption = #1058#1086#1074#1072#1088':'
  end
  object edGoods: TcxButtonEdit
    Left = 741
    Top = 5
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 200
  end
  object cxLabel27: TcxLabel
    Left = 972
    Top = 6
    Caption = #1055#1088#1077#1076#1087#1088#1080#1103#1090#1080#1077':'
  end
  object edJuridicalBasis: TcxButtonEdit
    Left = 1050
    Top = 5
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
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
      Enabled = False
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
      Enabled = False
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
      Enabled = False
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
      Enabled = False
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
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_WeighingPartner_Item'
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
        Name = 'inGoodsGroupId'
        Value = Null
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
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
    Left = 48
    Top = 184
  end
  object spMovementComplete: TdsdStoredProc
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
    Left = 112
    Top = 64
    object N1: TMenuItem
      Action = actComplete
    end
    object N2: TMenuItem
      Action = actUnComplete
    end
  end
  object spMovementUnComplete: TdsdStoredProc
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
        Component = GuidesGoodsGroup
      end
      item
        Component = GuidesGoods
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
    Left = 256
    Top = 288
  end
  object GuidesGoodsGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroup
    FormNameParam.Value = 'TGoodsGroupForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 608
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsFuel_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsFuel_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 856
    Top = 65535
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
    Left = 1135
    Top = 8
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
    Left = 1088
    Top = 32
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 400
    Top = 200
  end
end
