object Report_Goods_inventoryForm: TReport_Goods_inventoryForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' <'#1054#1089#1090#1072#1090#1082#1080' '#1087#1086' '#1090#1086#1074#1072#1088#1072#1084' ('#1090#1077#1082#1091#1097#1080#1077')>'
  ClientHeight = 671
  ClientWidth = 1344
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
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 80
    Width = 1344
    Height = 591
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 590
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = MasterDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountStart
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountEnd_calc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_ProductionSeparate_un
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_Income
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_Loss_un
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_Sale
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_Loss
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_Sale_un
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_Send
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_ProductionSeparate
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_Income_un
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_ProductionSeparate
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_ProductionUnion
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_ProductionUnion_un
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_ReturnIn
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_ReturnIn_un
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_Loss
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_Loss_un
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_Send
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_Send_un
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_ProductionSeparate_un
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_ProductionUnion
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_ProductionUnion_un
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_Send_un
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountEnd
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountStart
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountEnd_calc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_ProductionSeparate_un
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_Income
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_Loss_un
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_Sale
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_Loss
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_Sale_un
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_Send
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_ProductionSeparate
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_Income_un
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_ProductionSeparate
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_ProductionUnion
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_ProductionUnion_un
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_ReturnIn
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_ReturnIn_un
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_Loss
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_Loss_un
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_Send
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountIn_Send_un
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_ProductionSeparate_un
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_ProductionUnion
        end
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = GoodsName
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_ProductionUnion_un
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountOut_Send_un
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = CountEnd
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
      object OperDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1048#1085#1074#1077#1085#1090'. ('#1080#1085#1092'.)'
        DataBinding.FieldName = 'OperDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 73
      end
      object AccountCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1089#1095'.'
        DataBinding.FieldName = 'AccountCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
      object AccountName_All: TcxGridDBColumn
        Caption = #1057#1095#1077#1090
        DataBinding.FieldName = 'AccountName_All'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object LocationDescName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1084#1077#1089#1090#1072' '#1091#1095#1077#1090#1072
        DataBinding.FieldName = 'LocationDescName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object LocationCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1084#1077#1089#1090#1072' '#1091#1095'.'
        DataBinding.FieldName = 'LocationCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object LocationName: TcxGridDBColumn
        Caption = #1052#1077#1089#1090#1086' '#1091#1095#1077#1090#1072
        DataBinding.FieldName = 'LocationName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object GoodsGroupNameFull: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072' ('#1074#1089#1077')'
        DataBinding.FieldName = 'GoodsGroupNameFull'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 126
      end
      object GoodsGroupName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsGroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object GoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object GoodsName: TcxGridDBColumn
        Caption = #1058#1086#1074#1072#1088
        DataBinding.FieldName = 'GoodsName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 118
      end
      object GoodsKindName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsKindName'
        Visible = False
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
        Options.Editing = False
        Width = 35
      end
      object CountStart: TcxGridDBColumn
        Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountStart'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1054#1089#1090'. '#1085#1072#1095'. '#1082#1086#1083'. ('#1087#1077#1088#1077#1086#1094#1077#1085#1082#1072')'
        Options.Editing = False
        Width = 80
      end
      object CountEnd: TcxGridDBColumn
        Caption = #1054#1089#1090'. '#1082#1086#1085#1077#1095'. '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountEnd'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1054#1089#1090'. '#1082#1086#1085#1077#1095'. '#1082#1086#1083'. ('#1088#1072#1089#1095#1077#1090')'
        Options.Editing = False
        Width = 80
      end
      object CountEnd_calc: TcxGridDBColumn
        Caption = #1054#1089#1090'. '#1082#1086#1085#1077#1095'. '#1082#1086#1083'. ('#1088#1072#1089#1095#1077#1090')'
        DataBinding.FieldName = 'CountEnd_calc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1054#1089#1090'. '#1082#1086#1085#1077#1095'. '#1082#1086#1083'. ('#1088#1072#1089#1095#1077#1090')'
        Options.Editing = False
        Width = 80
      end
      object CountIn_Income: TcxGridDBColumn
        Caption = #1055#1088#1080#1093#1086#1076' '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountIn_Income'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object CountIn_Income_un: TcxGridDBColumn
        Caption = #1055#1088#1080#1093#1086#1076'* '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountIn_Income_un'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1088#1080#1093#1086#1076'* '#1082#1086#1083'. ('#1085#1077#1087#1088#1086#1074#1077#1076'.)'
        Width = 80
      end
      object CountIn_Loss: TcxGridDBColumn
        Caption = #1057#1087#1080#1089#1072#1085#1080#1077' '#1087#1088#1080#1093#1086#1076' '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountIn_Loss'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object CountIn_Loss_un: TcxGridDBColumn
        Caption = #1057#1087#1080#1089#1072#1085#1080#1077'* '#1087#1088#1080#1093#1086#1076' '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountIn_Loss_un'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1057#1087#1080#1089#1072#1085#1080#1077'* '#1082#1086#1083'.('#1085#1077#1087#1088#1086#1074#1077#1076'.)'
        Width = 80
      end
      object CountIn_Send: TcxGridDBColumn
        Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1088#1080#1093#1086#1076' '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountIn_Send'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object CountIn_Send_un: TcxGridDBColumn
        Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'* '#1087#1088#1080#1093#1086#1076' '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountIn_Send_un'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'* '#1082#1086#1083'.'
        Width = 80
      end
      object CountIn_ReturnIn: TcxGridDBColumn
        Caption = #1042#1086#1079#1074#1088#1072#1090' '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountIn_ReturnIn'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1086#1079#1074#1088#1072#1090' '#1082#1086#1083'.'
        Width = 80
      end
      object CountIn_ReturnIn_un: TcxGridDBColumn
        Caption = #1042#1086#1079#1074#1088#1072#1090'* '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountIn_ReturnIn_un'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1086#1079#1074#1088#1072#1090' '#1082#1086#1083'.'
        Width = 80
      end
      object CountIn_ProductionSeparate: TcxGridDBColumn
        Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1087#1088#1080#1093#1086#1076' '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountIn_ProductionSeparate'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object CountIn_ProductionSeparate_un: TcxGridDBColumn
        Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'* '#1087#1088#1080#1093#1086#1076' '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountIn_ProductionSeparate_un'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object CountIn_ProductionUnion: TcxGridDBColumn
        Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1089#1084#1077#1096#1080#1074#1072#1085#1080#1077' '#1087#1088#1080#1093#1086#1076' '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountIn_ProductionUnion'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object CountIn_ProductionUnion_un: TcxGridDBColumn
        Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1089#1084#1077#1096#1080#1074#1072#1085#1080#1077'* '#1087#1088#1080#1093#1086#1076' '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountIn_ProductionUnion_un'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object CountOut_Sale: TcxGridDBColumn
        Caption = #1055#1088#1086#1076#1072#1078#1072' '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountOut_Sale'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object CountOut_Sale_un: TcxGridDBColumn
        Caption = #1055#1088#1086#1076#1072#1078#1072'* '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountOut_Sale_un'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object CountOut_Loss: TcxGridDBColumn
        Caption = #1057#1087#1080#1089#1072#1085#1080#1077' '#1088#1072#1089#1093#1086#1076' '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountOut_Loss'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object CountOut_Loss_un: TcxGridDBColumn
        Caption = #1057#1087#1080#1089#1072#1085#1080#1077' '#1088#1072#1089#1093#1086#1076'* '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountOut_Loss_un'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object CountOut_Send: TcxGridDBColumn
        Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1088#1072#1089#1093#1086#1076' '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountOut_Send'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object CountOut_Send_un: TcxGridDBColumn
        Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1088#1072#1089#1093#1086#1076'* '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountOut_Send_un'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object CountOut_ProductionSeparate: TcxGridDBColumn
        Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1088#1072#1089#1093#1086#1076' '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountOut_ProductionSeparate'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object CountOut_ProductionSeparate_un: TcxGridDBColumn
        Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'* '#1088#1072#1089#1093#1086#1076' '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountOut_ProductionSeparate_un'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object CountOut_ProductionUnion: TcxGridDBColumn
        Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1089#1084#1077#1096#1080#1074#1072#1085#1080#1077' '#1088#1072#1089#1093#1086#1076' '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountOut_ProductionUnion'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object CountOut_ProductionUnion_un: TcxGridDBColumn
        Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1089#1084#1077#1096#1080#1074#1072#1085#1080#1077'* '#1088#1072#1089#1093#1086#1076' '#1082#1086#1083'.'
        DataBinding.FieldName = 'CountOut_ProductionUnion_un'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object OperDate_byReport: TcxGridDBColumn
        DataBinding.FieldName = 'OperDate_byReport'
        Visible = False
        VisibleForCustomization = False
        Width = 70
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1344
    Height = 54
    Align = alTop
    TabOrder = 1
    object edGoodsGroup: TcxButtonEdit
      Left = 853
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 192
    end
    object deStart: TcxDateEdit
      Left = 60
      Top = 5
      EditValue = 43101d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 2
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 60
      Top = 30
      EditValue = 43101d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 4
      Width = 85
    end
    object edUnitGroup: TcxButtonEdit
      Left = 555
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 203
    end
    object cxLabel3: TcxLabel
      Left = 427
      Top = 6
      Caption = #1043#1088#1091#1087#1087#1072' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081':'
    end
    object cxLabel1: TcxLabel
      Left = 762
      Top = 6
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074':'
    end
    object edGoods: TcxButtonEdit
      Left = 853
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 192
    end
    object edLocation: TcxButtonEdit
      Left = 555
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 203
    end
    object cxLabel4: TcxLabel
      Left = 481
      Top = 31
      Caption = #1052#1077#1089#1090#1086' '#1091#1095#1077#1090#1072':'
    end
    object cxLabel5: TcxLabel
      Left = 13
      Top = 6
      Caption = #1044#1072#1090#1072' '#1089' :'
    end
    object cxLabel6: TcxLabel
      Left = 6
      Top = 31
      Caption = #1044#1072#1090#1072' '#1087#1086' :'
    end
    object cxLabel7: TcxLabel
      Left = 813
      Top = 31
      Caption = #1058#1086#1074#1072#1088':'
    end
    object ceAccountGroup: TcxButtonEdit
      Left = 221
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 12
      Width = 200
    end
    object cxLabel2: TcxLabel
      Left = 148
      Top = 6
      Caption = #1057#1095#1077#1090' '#1075#1088#1091#1087#1087#1072':'
    end
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 48
    Top = 248
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 88
    Top = 200
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
        Component = GuidesAccountGroup
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesGoods
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesGoodsGroup
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesLocation
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesUnitGroup
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
    Left = 312
    Top = 232
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
    Left = 128
    Top = 264
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar1: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 2
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
          ItemName = 'bbDialogForm'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbReport_Goods'
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
          ItemName = 'bbToExcel'
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
    object bbToExcel: TdxBarButton
      Action = actExportToExcel
      Category = 0
    end
    object bbDialogForm: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrintBy_Goods: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Caption = '   '
      Category = 0
      Hint = '   '
      Visible = ivAlways
    end
    object bbGoodsKind: TdxBarControlContainerItem
      Caption = #1087#1086' '#1042#1080#1076#1072#1084
      Category = 0
      Hint = #1087#1086' '#1042#1080#1076#1072#1084
      Visible = ivAlways
    end
    object bbPartionGoods: TdxBarControlContainerItem
      Caption = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      Category = 0
      Hint = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      Visible = ivAlways
    end
    object bbAmount: TdxBarControlContainerItem
      Caption = #1090#1086#1083#1100#1082#1086' '#1050#1086#1083'-'#1074#1086
      Category = 0
      Hint = #1090#1086#1083#1100#1082#1086' '#1050#1086#1083'-'#1074#1086
      Visible = ivAlways
    end
    object bbPrint2: TdxBarButton
      Action = actPrint2
      Category = 0
    end
    object bbPrint3: TdxBarButton
      Action = actPrint3
      Category = 0
    end
    object bbPrint_Loss: TdxBarButton
      Action = actPrint_Loss
      Category = 0
    end
    object bbPrint_Inventory: TdxBarButton
      Action = actPrint_Inventory
      Category = 0
    end
    object bbPrintBarCode: TdxBarButton
      Action = actPrintBarCode
      Category = 0
      ImageIndex = 15
    end
    object bbReport_Goods: TdxBarButton
      Action = actReport_Goods
      Category = 0
    end
    object bbPrint_MOAuto: TdxBarButton
      Action = actPrint_MOAuto
      Category = 0
    end
    object bbPrintCount: TdxBarButton
      Action = actPrintCount
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 256
    Top = 232
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actExportToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_Goods_inventoryDialogForm'
      FormNameParam.Value = 'TReport_Goods_inventoryDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'Key'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = ''
          Component = GuidesGoodsGroup
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GuidesGoodsGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupId'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationId'
          Value = ''
          Component = GuidesLocation
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          Component = GuidesLocation
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupId'
          Value = Null
          Component = GuidesAccountGroup
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupName'
          Value = Null
          Component = GuidesAccountGroup
          ComponentItem = 'TextValue'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actPrintBarCode: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1096#1090#1088#1080#1093'-'#1082#1086#1076')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1096#1090#1088#1080#1093'-'#1082#1086#1076')'
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          Component = GuidesLocation
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GuidesGoodsGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoodsKind'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isAmount'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1096#1090#1088#1080#1093#1082#1086#1076')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1096#1090#1088#1080#1093#1082#1086#1076')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintCount: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1076#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1073#1072#1090#1086#1085#1072#1084')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1076#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1073#1072#1090#1086#1085#1072#1084')'
      ImageIndex = 20
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsGroupName;GoodsName;GoodsKindName;Partio' +
            'nGoodsName;AssetToName;InfoMoneyName_all;InfoMoneyName_all_Detai' +
            'l'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 43101d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 43101d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          Component = GuidesLocation
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GuidesGoodsGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoodsKind'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartionGoods'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isAmount'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isInfoMoney'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1076#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1073#1072#1090#1086#1085#1072#1084')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1076#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1073#1072#1090#1086#1085#1072#1084')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsGroupName;GoodsName;GoodsKindName;Partio' +
            'nGoodsName;AssetToName;InfoMoneyName_all;InfoMoneyName_all_Detai' +
            'l'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = Null
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          Component = GuidesLocation
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = GuidesGoodsGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoodsKind'
          Value = Null
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartionGoods'
          Value = Null
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isAmount'
          Value = Null
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isInfoMoney'
          Value = Null
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1076#1074#1080#1078#1077#1085#1080#1077')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1076#1074#1080#1078#1077#1085#1080#1077')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object SaleJournal: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'SaleJournal'
      FormName = 'TMovementGoodsJournalForm'
      FormNameParam.Value = 'TMovementGoodsJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsKindId'
          Value = 0
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionGoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionGoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionGoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionGoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LocationId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'LocationName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupId'
          Value = Null
          Component = GuidesAccountGroup
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupName'
          Value = Null
          Component = GuidesAccountGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId_Detail'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName_Detail'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupId'
          Value = Null
          Component = GuidesUnitGroup
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = Null
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DescSet'
          Value = Null
          Component = FormParams
          ComponentItem = 'SaleDesc'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actIsInfoMoney: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = #1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1059#1055' '#1089#1090#1072#1090#1100#1103#1084
      Hint = #1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1059#1055' '#1089#1090#1072#1090#1100#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actPrint2: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' <'#1054#1089#1090#1072#1090#1086#1082' '#1090#1086#1074#1072#1088#1072' '#1079#1072' '#1087#1077#1088#1080#1086#1076' ('#1088#1072#1089#1095#1077#1090#1085#1099#1081')>'
      Hint = #1054#1090#1095#1077#1090' <'#1054#1089#1090#1072#1090#1086#1082' '#1090#1086#1074#1072#1088#1072' '#1079#1072' '#1087#1077#1088#1080#1086#1076' ('#1088#1072#1089#1095#1077#1090#1085#1099#1081')>'
      ImageIndex = 18
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsName;GoodsKindName;PartionGoodsName;Asse' +
            'tToName;InfoMoneyName_all;InfoMoneyName_all_Detail'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          Component = GuidesLocation
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GuidesGoodsGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoodsKind'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartionGoods'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isAmount'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isInfoMoney'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1076#1074#1080#1078#1077#1085#1080#1077')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1076#1074#1080#1078#1077#1085#1080#1077')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint3: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1074#1099#1093#1086#1076' '#1043#1055')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1074#1099#1093#1086#1076' '#1043#1055')'
      ImageIndex = 19
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsGroupName;GoodsName;GoodsKindName;Partio' +
            'nGoodsName;AssetToName;InfoMoneyName_all;InfoMoneyName_all_Detai' +
            'l'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          Component = GuidesLocation
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GuidesGoodsGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoodsKind'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartionGoods'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isAmount'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isInfoMoney'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1074#1099#1093#1086#1076' '#1043#1055')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1074#1099#1093#1086#1076' '#1043#1055')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_Loss: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' <% '#1089#1087#1080#1089#1072#1085#1080#1103'>'
      Hint = #1054#1090#1095#1077#1090' <% '#1089#1087#1080#1089#1072#1085#1080#1103'>'
      ImageIndex = 17
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsGroupName;GoodsName;GoodsKindName;Partio' +
            'nGoodsName;AssetToName;InfoMoneyName_all;InfoMoneyName_all_Detai' +
            'l'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          Component = GuidesLocation
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GuidesGoodsGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoodsKind'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartionGoods'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isAmount'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isInfoMoney'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName_by'
          Value = ''
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName_by'
          Value = ''
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isLoss'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1087#1088#1086#1094#1077#1085#1090' '#1089#1087#1080#1089#1072#1085#1080#1103')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1087#1088#1086#1094#1077#1085#1090' '#1089#1087#1080#1089#1072#1085#1080#1103')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_MOAuto: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1052#1054' '#1080#1083#1080' '#1040#1074#1090#1086
      Hint = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1052#1054' '#1080#1083#1080' '#1040#1074#1090#1086
      ImageIndex = 16
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'LocationName;UnitName_to;DriverName;GoodsGroupNameFull;GoodsGrou' +
            'pName;GoodsName;GoodsKindName;PartionGoodsName;AssetToName;InfoM' +
            'oneyName_all;InfoMoneyName_all_Detail'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 43101d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 43101d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          Component = GuidesLocation
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GuidesGoodsGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoodsKind'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartionGoods'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isAmount'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isInfoMoney'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName_by'
          Value = ''
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName_by'
          Value = ''
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1087#1086' '#1052#1054' '#1080#1083#1080' '#1040#1074#1090#1086')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1087#1086' '#1052#1054' '#1080#1083#1080' '#1040#1074#1090#1086')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_Inventory: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' <'#1040#1082#1090' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080'>'
      Hint = #1054#1090#1095#1077#1090' <'#1040#1082#1090' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080'>'
      ImageIndex = 17
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsGroupName;GoodsName;GoodsKindName;Partio' +
            'nGoodsName;AssetToName;InfoMoneyName_all;InfoMoneyName_all_Detai' +
            'l'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          Component = GuidesLocation
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GuidesGoodsGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoodsKind'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartionGoods'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isAmount'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isInfoMoney'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName_by'
          Value = ''
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName_by'
          Value = ''
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isLoss'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1087#1088#1086#1094#1077#1085#1090' '#1089#1087#1080#1089#1072#1085#1080#1103')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1090#1086#1074#1072#1088#1072' ('#1087#1088#1086#1094#1077#1085#1090' '#1089#1087#1080#1089#1072#1085#1080#1103')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actIsAllMO: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = #1042#1089#1077' '#1052#1054
      Hint = #1042#1089#1077' '#1052#1054
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actIsAllAuto: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = #1042#1089#1077' '#1040#1074#1090#1086
      Hint = #1042#1089#1077' '#1040#1074#1090#1086
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actReport_Goods: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1090#1086#1074#1072#1088#1091'>'
      Hint = #1054#1090#1095#1077#1090' <'#1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1090#1086#1074#1072#1088#1091'>'
      ImageIndex = 26
      FormName = 'TReport_GoodsForm'
      FormNameParam.Value = 'TReport_GoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = MasterCDS
          ComponentItem = 'OperDate_byReport'
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
        end
        item
          Name = 'UnitGroupId'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LocationId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LocationName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsPartner'
          Value = True
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  object spReport: TdsdStoredProc
    StoredProcName = 'gpReport_Goods_inventory'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
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
        Name = 'inAccountGroupId'
        Value = Null
        Component = GuidesAccountGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitGroupId'
        Value = ''
        Component = GuidesUnitGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLocationId'
        Value = ''
        Component = GuidesLocation
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupId'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 256
    Top = 176
  end
  object DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        ColorColumn = CountIn_ProductionSeparate_un
        ColorValueList = <>
      end
      item
        ColorColumn = CountIn_ProductionUnion
        ColorValueList = <>
      end
      item
        ColorColumn = CountIn_ProductionUnion_un
        ColorValueList = <>
      end
      item
        ColorColumn = CountIn_Income
        ColorValueList = <>
      end
      item
        ColorColumn = CountIn_Income_un
        ColorValueList = <>
      end
      item
        ColorColumn = CountIn_ProductionSeparate
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end
      item
        ColorColumn = CountIn_ReturnIn
        ColorValueList = <>
      end
      item
        ColorColumn = CountIn_ReturnIn_un
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end
      item
        ColorValueList = <>
      end>
    ColumnAddOnList = <
      item
        Action = SaleJournal
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 456
    Top = 392
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 344
    Top = 288
  end
  object GuidesGoodsGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroup
    FormNameParam.Value = 'TGoodsGroup_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroup_ObjectForm'
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
    Left = 968
  end
  object GuidesLocation: TdsdGuides
    KeyField = 'Id'
    LookupControl = edLocation
    FormNameParam.Value = 'TStoragePlace_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TStoragePlace_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesLocation
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesLocation
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 728
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 176
    Top = 176
  end
  object GuidesUnitGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitGroup
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'TreeDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnitGroup
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnitGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 600
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
    Left = 904
    Top = 27
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ShowDialogAction = ExecuteDialog
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesAccountGroup
      end
      item
        Component = GuidesUnitGroup
      end
      item
        Component = GuidesLocation
      end
      item
        Component = GuidesGoodsGroup
      end
      item
        Component = GuidesGoods
      end>
    Left = 144
    Top = 344
  end
  object GuidesAccountGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceAccountGroup
    FormNameParam.Value = 'TAccountGroup_ObjectDescForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAccountGroup_ObjectDescForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesAccountGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesAccountGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescCode'
        Value = 'zc_Object_Goods'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 416
    Top = 85
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'IncomeDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnOutDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SaleDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnInDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MoneyDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ServiceDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SendDebtDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OtherDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SaleRealDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnInRealDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TransferDebtDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 424
    Top = 224
  end
  object spGetDescSets: TdsdStoredProc
    StoredProcName = 'gpGetDescSets'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'IncomeDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'IncomeDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnOutDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReturnOutDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SaleDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'SaleDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnInDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReturnInDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MoneyDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'MoneyDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ServiceDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ServiceDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SendDebtDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'SendDebtDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OtherDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'OtherDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SaleRealDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'SaleRealDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnInRealDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReturnInRealDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TransferDebtDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'TransferDebtDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceCorrectiveDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'PriceCorrectiveDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ServiceRealDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ServiceRealDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChangeCurrencyDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ChangeCurrencyDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 528
    Top = 272
  end
end
