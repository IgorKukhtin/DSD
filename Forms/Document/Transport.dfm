object TransportForm: TTransportForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090'>'
  ClientHeight = 563
  ClientWidth = 1253
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = PopupMenu
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object DataPanel: TPanel
    Left = 0
    Top = 0
    Width = 1253
    Height = 130
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object edInvNumber: TcxTextEdit
      Left = 8
      Top = 23
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 92
    end
    object cxLabel1: TcxLabel
      Left = 8
      Top = 5
      Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    end
    object edOperDate: TcxDateEdit
      Left = 105
      Top = 23
      EditValue = 42244d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 90
    end
    object cxLabel2: TcxLabel
      Left = 105
      Top = 5
      Caption = #1044#1072#1090#1072
    end
    object edBranchForwarding: TcxButtonEdit
      Left = 1011
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 12
      Width = 176
    end
    object edCar: TcxButtonEdit
      Left = 200
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 100
    end
    object cxLabel3: TcxLabel
      Left = 1012
      Top = 45
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1052#1077#1089#1090#1086' '#1086#1090#1087#1088#1072#1074#1082#1080')'
    end
    object cxLabel4: TcxLabel
      Left = 200
      Top = 5
      Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100' '
    end
    object edPersonalDriver: TcxButtonEdit
      Left = 165
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 135
    end
    object cxLabel5: TcxLabel
      Left = 165
      Top = 45
      Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1042#1086#1076#1080#1090#1077#1083#1100')'
    end
    object edPersonalDriverMore: TcxButtonEdit
      Left = 690
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 150
    end
    object cxLabel6: TcxLabel
      Left = 690
      Top = 45
      Caption = #1042#1086#1076#1080#1090#1077#1083#1100', '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081
    end
    object edCarTrailer: TcxButtonEdit
      Left = 690
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 150
    end
    object cxLabel7: TcxLabel
      Left = 690
      Top = 5
      Caption = #1055#1088#1080#1094#1077#1087
    end
    object edStartRunPlan: TcxDateEdit
      Left = 305
      Top = 23
      EditValue = 42244d
      Properties.DateButtons = [btnClear, btnToday]
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.EditFormat = 'dd.mm.yyyy hh:mm'
      Properties.InputKind = ikMask
      Properties.Kind = ckDateTime
      TabOrder = 4
      Width = 145
    end
    object cxLabel8: TcxLabel
      Left = 305
      Top = 5
      Caption = #1044#1072#1090#1072'/'#1042#1088'.'#1074#1099#1077#1079#1076#1072' '#1087#1083#1072#1085' '
    end
    object edEndRunPlan: TcxDateEdit
      Left = 305
      Top = 63
      EditValue = 42244d
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.EditFormat = 'dd.mm.yyyy hh:mm'
      Properties.Kind = ckDateTime
      TabOrder = 5
      Width = 145
    end
    object cxLabel9: TcxLabel
      Left = 305
      Top = 45
      Caption = #1044#1072#1090#1072'/'#1042#1088'.'#1074#1086#1079#1074#1088#1072#1097#1077#1085#1080#1103' '#1087#1083#1072#1085
    end
    object cxLabel10: TcxLabel
      Left = 455
      Top = 5
      Caption = #1044#1072#1090#1072'/'#1042#1088'.'#1074#1099#1077#1079#1076#1072' '#1092#1072#1082#1090
    end
    object edStartRun: TcxDateEdit
      Left = 455
      Top = 23
      EditValue = 42244d
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.EditFormat = 'dd.mm.yyyy hh:mm'
      Properties.InputKind = ikMask
      Properties.Kind = ckDateTime
      TabOrder = 6
      Width = 150
    end
    object cxLabel11: TcxLabel
      Left = 455
      Top = 45
      Caption = #1044#1072#1090#1072'/'#1042#1088'.'#1074#1086#1079#1074#1088#1072#1097#1077#1085#1080#1103' '#1092#1072#1082#1090
    end
    object edEndRun: TcxDateEdit
      Left = 455
      Top = 63
      EditValue = 42244d
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.EditFormat = 'dd.mm.yyyy hh:mm'
      Properties.Kind = ckDateTime
      TabOrder = 7
      Width = 150
    end
    object edComment: TcxTextEdit
      Left = 845
      Top = 23
      TabOrder = 13
      Width = 340
    end
    object cxLabel12: TcxLabel
      Left = 845
      Top = 5
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '
    end
    object edHoursWork: TcxCurrencyEdit
      Left = 610
      Top = 23
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      TabOrder = 8
      Width = 75
    end
    object cxLabel13: TcxLabel
      Left = 610
      Top = 5
      Caption = #1050#1086#1083'-'#1074#1086' '#1095#1072#1089#1086#1074
    end
    object edHoursAdd: TcxCurrencyEdit
      Left = 610
      Top = 63
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      TabOrder = 9
      Width = 75
    end
    object cxLabel14: TcxLabel
      Left = 610
      Top = 45
      Caption = #1044#1086#1087'. '#1095#1072#1089#1099
    end
    object ceStatus: TcxButtonEdit
      Left = 9
      Top = 63
      Properties.Buttons = <
        item
          Action = CompleteMovement
          Kind = bkGlyph
        end
        item
          Action = UnCompleteMovement
          Default = True
          Kind = bkGlyph
        end
        item
          Action = DeleteMovement
          Kind = bkGlyph
        end>
      Properties.Images = dmMain.ImageList
      Properties.ReadOnly = True
      TabOrder = 28
      Width = 152
    end
    object cxLabel15: TcxLabel
      Left = 8
      Top = 45
      Caption = #1057#1090#1072#1090#1091#1089
    end
    object cxLabel16: TcxLabel
      Left = 847
      Top = 45
      Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1101#1082#1089#1087#1077#1076#1080#1090#1086#1088')'
    end
    object edPersonal: TcxButtonEdit
      Left = 845
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 31
      Width = 160
    end
    object cxLabel23: TcxLabel
      Left = 1011
      Top = 86
      Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1087#1086#1076#1090#1074'.)'
    end
    object edDate_UserConfirmedKind: TcxDateEdit
      Left = 1011
      Top = 103
      Hint = #1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' "'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1086' '#1087#1088#1080#1095#1080#1085#1072#1093' '#1087#1088#1086#1089#1090#1086#1103'"'
      EditValue = 42132d
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.EditFormat = 'dd.mm.yyyy hh:mm'
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 33
      Width = 110
    end
    object cxLabel24: TcxLabel
      Left = 1127
      Top = 86
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1087#1086#1076#1090#1074'.)'
    end
    object edUserName_ConfirmedKind: TcxButtonEdit
      Left = 1127
      Top = 103
      Hint = #1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' "'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1086' '#1087#1088#1080#1095#1080#1085#1072#1093' '#1087#1088#1086#1089#1090#1086#1103'"'
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 35
      Width = 121
    end
  end
  object cxPageControl: TcxPageControl
    Left = 0
    Top = 156
    Width = 1253
    Height = 407
    Align = alClient
    TabOrder = 1
    Properties.ActivePage = cxTabSheetMain
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 407
    ClientRectRight = 1253
    ClientRectTop = 24
    object cxTabSheetMain: TcxTabSheet
      Caption = #1057#1090#1088#1086#1095#1085#1072#1103' '#1095#1072#1089#1090#1100
      ImageIndex = 0
      object cxGrid: TcxGrid
        Left = 0
        Top = 0
        Width = 1253
        Height = 238
        Align = alClient
        TabOrder = 0
        object cxGridDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = MasterDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = DistanceFuelChild
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Weight
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = WeightTranspor
            end
            item
              Kind = skSum
              Position = spFooter
              Column = WeightTranspor
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = DistanceWeightTransport
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RateSumma
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Taxi
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RatePrice_Calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TaxiMore
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RateSummaAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RateSummaExp
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Weight
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Amount
            end
            item
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = DistanceFuelChild
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = WeightTranspor
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = DistanceWeightTransport
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RateSumma
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Taxi
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RatePrice_Calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TaxiMore
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RateSummaAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RateSummaExp
            end>
          DataController.Summary.SummaryGroups = <>
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.CancelOnExit = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object RouteCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'RouteCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object RouteName: TcxGridDBColumn
            Caption = #1052#1072#1088#1096#1088#1091#1090
            DataBinding.FieldName = 'RouteName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = RouteChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 97
          end
          object StartRunPlan: TcxGridDBColumn
            Caption = #1042#1088#1077#1084#1103' '#1074#1099#1077#1079#1076#1072' '#1087#1083#1072#1085
            DataBinding.FieldName = 'StartRunPlan'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'HH:MM'
            Properties.Kind = ckDateTime
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1088#1077#1084#1103' '#1074#1099#1077#1079#1076#1072' '#1087#1083#1072#1085
            Options.Editing = False
            Width = 90
          end
          object EndRunPlan: TcxGridDBColumn
            Caption = #1042#1088#1077#1084#1103' '#1074#1086#1079#1074#1088'. '#1087#1083#1072#1085
            DataBinding.FieldName = 'EndRunPlan'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'HH:MM'
            Properties.Kind = ckDateTime
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1088#1077#1084#1103' '#1074#1086#1079#1074#1088#1072#1097#1077#1085#1080#1103' '#1087#1083#1072#1085
            Options.Editing = False
            Width = 90
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = UnitChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 71
          end
          object FreightName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1075#1088#1091#1079#1072
            DataBinding.FieldName = 'FreightName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = FreightChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 59
          end
          object Amount: TcxGridDBColumn
            Caption = #1055#1088#1086#1073#1077#1075', '#1082#1084' ('#1086#1089#1085#1086#1074#1085#1086#1081')'
            DataBinding.FieldName = 'Amount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 52
          end
          object DistanceFuelChild: TcxGridDBColumn
            Caption = #1055#1088#1086#1073#1077#1075', '#1082#1084' ('#1076#1086#1087#1086#1083#1085#1080#1090'.)'
            DataBinding.FieldName = 'DistanceFuelChild'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 51
          end
          object DistanceWeightTransport: TcxGridDBColumn
            Caption = #1055#1088#1086#1073#1077#1075', '#1082#1084' ('#1089' '#1075#1088#1091#1079#1086#1084', '#1087#1077#1088#1077#1074#1077#1079#1077#1085#1086')'
            DataBinding.FieldName = 'DistanceWeightTransport'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 86
          end
          object StartOdometre: TcxGridDBColumn
            Caption = #1057#1087#1080#1076#1086#1084#1077#1090#1088' '#1085#1072#1095'. '#1087#1086#1082#1072#1079#1072#1085#1080#1077', '#1082#1084
            DataBinding.FieldName = 'StartOdometre'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 66
          end
          object EndOdometre: TcxGridDBColumn
            Caption = #1057#1087#1080#1076#1086#1084#1077#1090#1088' '#1082#1086#1085#1077#1095'. '#1087#1086#1082#1072#1079#1072#1085#1080#1077', '#1082#1084
            DataBinding.FieldName = 'EndOdometre'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 71
          end
          object Weight: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1075#1088#1091#1079#1072', '#1082#1075' ('#1088#1072#1079#1075#1088#1091#1079#1082#1072')'
            DataBinding.FieldName = 'Weight'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 54
          end
          object WeightTranspor: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1075#1088#1091#1079#1072', '#1082#1075' ('#1087#1077#1088#1077#1074#1077#1079#1077#1085#1086')'
            DataBinding.FieldName = 'WeightTransport'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 84
          end
          object RouteKindName_Freight: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1075#1088#1091#1079#1072
            DataBinding.FieldName = 'RouteKindName_Freight'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = RouteKindFreightChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 42
          end
          object RouteKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1084#1072#1088#1096#1088#1091#1090#1072
            DataBinding.FieldName = 'RouteKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 43
          end
          object TimePrice: TcxGridDBColumn
            Caption = #1057#1090#1072#1074#1082#1072' '#1075#1088#1085'/'#1095' '#1082#1086#1084#1084#1072#1085#1076#1080#1088#1086#1074#1086#1095#1085#1099#1093
            DataBinding.FieldName = 'TimePrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1082#1086#1084#1084#1072#1085#1076#1080#1088#1086#1074#1086#1095#1085#1099#1093
            Width = 59
          end
          object RateSumma: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1082#1086#1084#1072#1085#1076#1080#1088#1086#1074#1086#1095#1085#1099#1077', '#1075#1088#1085'.'
            DataBinding.FieldName = 'RateSumma'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1082#1086#1084#1084#1072#1085#1076#1080#1088#1086#1074#1086#1095#1085#1099#1093
            Width = 54
          end
          object RatePrice: TcxGridDBColumn
            Caption = #1057#1090#1072#1074#1082#1072' '#1075#1088#1085'/'#1082#1084' ('#1076#1072#1083#1100#1085#1086#1073#1086#1081#1085#1099#1077')'
            DataBinding.FieldName = 'RatePrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1057#1090#1072#1074#1082#1072' '#1075#1088#1085'/'#1082#1084' ('#1076#1072#1083#1100#1085#1086#1073#1086#1081#1085#1099#1077')'
            Width = 59
          end
          object RatePrice_Calc: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1076#1072#1083#1100#1085#1086#1073#1086#1081#1085#1099#1077',  '#1075#1088#1085
            DataBinding.FieldName = 'RatePrice_Calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1057#1091#1084#1084#1072',  '#1075#1088#1085' ('#1076#1072#1083#1100#1085#1086#1073#1086#1081#1085#1099#1077')'
            Options.Editing = False
            Width = 61
          end
          object RateSummaAdd: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1076#1086#1087#1083#1072#1090#1072' ('#1076#1072#1083#1100#1085#1086#1073'.), '#1075#1088#1085'.'
            DataBinding.FieldName = 'RateSummaAdd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1082#1086#1084#1084#1072#1085#1076#1080#1088#1086#1074#1086#1095#1085#1099#1093
            Width = 67
          end
          object RateSummaExp: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1082#1086#1084#1072#1085#1076'. '#1101#1082#1089#1087'., '#1075#1088#1085'.'
            DataBinding.FieldName = 'RateSummaExp'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1082#1086#1084#1072#1085#1076#1080#1088#1086#1074#1086#1095#1085#1099#1093' '#1101#1082#1089#1087#1077#1076#1080#1090#1086#1088#1091
            Width = 67
          end
          object Taxi: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1085#1072' '#1090#1072#1082#1089#1080', '#1075#1088#1085'.'
            DataBinding.FieldName = 'Taxi'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1085#1072' '#1090#1072#1082#1089#1080
            Width = 59
          end
          object TaxiMore: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1085#1072' '#1090#1072#1082#1089#1080' ('#1074#1086#1076#1080#1090'. '#1076#1086#1087'.), '#1075#1088#1085'.'
            DataBinding.FieldName = 'TaxiMore'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1085#1072' '#1090#1072#1082#1089#1080' ('#1074#1086#1076#1080#1090#1077#1083#1100', '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081'), '#1075#1088#1085'.'
            Width = 69
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 107
          end
          object IsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
        end
        object cxGridLevel: TcxGridLevel
          GridView = cxGridDBTableView
        end
      end
      object cxGridChild: TcxGrid
        Left = 0
        Top = 243
        Width = 1253
        Height = 140
        Align = alBottom
        TabOrder = 1
        object cxGridChildDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colсhAmount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Amount_calc
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Amount_Distance_calc
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Amount_ColdHour_calc
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Amount_ColdDistance_calc
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = ColdHour
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = ColdDistance
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colсhAmount
            end
            item
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Amount_calc
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Amount_Distance_calc
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Amount_ColdHour_calc
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Amount_ColdDistance_calc
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = ColdHour
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = ColdDistance
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
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
          object Number: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'Number'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 36
          end
          object isMasterFuel: TcxGridDBColumn
            Caption = #1054#1089#1085#1086#1074#1085#1086#1081' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isMasterFuel'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object FuelCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'FuelCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object FuelName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1087#1083#1080#1074#1072
            DataBinding.FieldName = 'FuelName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object IsCalculated: TcxGridDBColumn
            Caption = #1060#1072#1082#1090' '#1088#1072#1089#1095#1077#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isCalculated'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 64
          end
          object colсhAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1092#1072#1082#1090
            DataBinding.FieldName = 'Amount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object Amount_calc: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1088#1072#1089#1095#1077#1090
            DataBinding.FieldName = 'Amount_calc'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Amount_Distance_calc: TcxGridDBColumn
            Caption = #1056#1072#1089#1095#1077#1090' '#1085#1072' '#1087#1088#1086#1073#1077#1075
            DataBinding.FieldName = 'Amount_Distance_calc'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Amount_ColdHour_calc: TcxGridDBColumn
            Caption = #1056#1072#1089#1095#1077#1090' '#1085#1072' '#1093#1086#1083#1086#1076' '#1095'.'
            DataBinding.FieldName = 'Amount_ColdHour_calc'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Amount_ColdDistance_calc: TcxGridDBColumn
            Caption = #1056#1072#1089#1095#1077#1090' '#1085#1072' '#1093#1086#1083#1086#1076' '#1082#1084'.'
            DataBinding.FieldName = 'Amount_ColdDistance_calc'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object ColdHour: TcxGridDBColumn
            Caption = #1063#1072#1089#1086#1074' '#1092#1072#1082#1090', '#1093#1086#1083#1086#1076
            DataBinding.FieldName = 'ColdHour'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object ColdDistance: TcxGridDBColumn
            Caption = #1050#1084'. '#1092#1072#1082#1090', '#1093#1086#1083#1086#1076
            DataBinding.FieldName = 'ColdDistance'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object AmountFuel: TcxGridDBColumn
            Caption = #1053#1086#1088#1084#1072' '#1085#1072' 100 '#1082#1084
            DataBinding.FieldName = 'AmountFuel'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountColdHour: TcxGridDBColumn
            Caption = #1053#1086#1088#1084#1072' '#1085#1072' '#1093#1086#1083#1086#1076', '#1074' '#1095#1072#1089
            DataBinding.FieldName = 'AmountColdHour'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountColdDistance: TcxGridDBColumn
            Caption = #1053#1086#1088#1084#1072' '#1085#1072' '#1093#1086#1083#1086#1076', '#1079#1072' 100 '#1082#1084
            DataBinding.FieldName = 'AmountColdDistance'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object RateFuelKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1085#1086#1088#1084#1099
            DataBinding.FieldName = 'RateFuelKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object RateFuelKindTax: TcxGridDBColumn
            Caption = '% '#1089#1077#1079#1086#1085', '#1090#1077#1084#1087'.'
            DataBinding.FieldName = 'RateFuelKindTax'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object RatioFuel: TcxGridDBColumn
            Caption = #1050#1086#1101#1092#1092'. '#1087#1077#1088#1077#1074#1086#1076#1072' '#1085#1086#1088#1084#1099
            DataBinding.FieldName = 'RatioFuel'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colchUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1079#1072#1090#1088#1072#1090#1099')'
            DataBinding.FieldName = 'UnitName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object BranchName: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083' ('#1079#1072#1090#1088#1072#1090#1099')'
            DataBinding.FieldName = 'BranchName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colchisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
        end
        object cxGridChildLevel: TcxGridLevel
          GridView = cxGridChildDBTableView
        end
      end
      object cxSplitterChild: TcxSplitter
        Left = 0
        Top = 238
        Width = 1253
        Height = 5
        AlignSplitter = salBottom
        Control = cxGridChild
      end
    end
    object cxTabSheetIncome: TcxTabSheet
      Caption = #1047#1072#1087#1088#1072#1074#1082#1072
      ImageIndex = 2
      object cxGridIncome: TcxGrid
        Left = 0
        Top = 0
        Width = 1253
        Height = 383
        Align = alClient
        TabOrder = 0
        object cxGridIncomeDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = IncomeDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = clincAmountSumm
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = clincAmount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = clincAmountSummTotal
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = clincAmount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = clincAmountSumm
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = clincAmountSummTotal
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.CancelOnExit = False
          OptionsData.Inserting = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object clincStatusCode: TcxGridDBColumn
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
            Options.Editing = False
            Width = 68
          end
          object clincInvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object clincInvNumberPartner: TcxGridDBColumn
            Caption = #8470' '#1095#1077#1082#1072
            DataBinding.FieldName = 'InvNumberPartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object clincOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1079#1072#1087#1088#1072#1074#1082#1080
            DataBinding.FieldName = 'OperDatePartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object clincFromName: TcxGridDBColumn
            Caption = #1048#1089#1090#1086#1095#1085#1080#1082' '#1079#1072#1087#1088#1072#1074#1082#1080
            DataBinding.FieldName = 'FromName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = SourceFuel_ObjectChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object clincPaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = PaidKindChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object clincRouteName: TcxGridDBColumn
            Caption = #1052#1072#1088#1096#1088#1091#1090
            DataBinding.FieldName = 'RouteName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = RouteIncomeChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object clincGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object clincGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = GoodsChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object clincFuelName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1087#1083#1080#1074#1072
            DataBinding.FieldName = 'FuelName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object clincAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object clincPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object clincAmountSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'AmountSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clincAmountSummTotal: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057' ('#1080#1090#1086#1075')'
            DataBinding.FieldName = 'AmountSummTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clincContractName: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractName'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clincChangePrice: TcxGridDBColumn
            Caption = #1057#1082#1080#1076#1082#1072' '#1074' '#1094#1077#1085#1077', '#1075#1088#1085' '#1079#1072' 1'#1083'.'
            DataBinding.FieldName = 'ChangePrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object clincisChangePriceUser: TcxGridDBColumn
            Caption = #1056#1091#1095#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1074' '#1094#1077#1085#1077' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isChangePriceUser'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1091#1095#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1074' '#1094#1077#1085#1077' ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 88
          end
          object clincPriceWithVAT: TcxGridDBColumn
            Caption = #1062#1077#1085#1099' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'PriceWithVAT'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object clincVATPercent: TcxGridDBColumn
            Caption = '% '#1053#1044#1057
            DataBinding.FieldName = 'VATPercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object clincCountForPrice: TcxGridDBColumn
            Caption = #1050#1086#1083' '#1074' '#1094#1077#1085#1077
            DataBinding.FieldName = 'CountForPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object clincIsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
        end
        object cxGridIncomeLevel: TcxGridLevel
          GridView = cxGridIncomeDBTableView
        end
      end
    end
    object cxTabSheetReport: TcxTabSheet
      Caption = #1048#1090#1086#1075#1080
      ImageIndex = 3
      object cxGridReport: TcxGrid
        Left = 0
        Top = 0
        Width = 1253
        Height = 383
        Align = alClient
        TabOrder = 0
        object cxGridReportDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ReportDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Kind = skSum
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.CancelOnExit = False
          OptionsData.Inserting = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object clrpStatusCode: TcxGridDBColumn
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
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object clrpKindName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'KindName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object clrpAmount_20401: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1085#1072' '#1050#1086#1084#1084#1072#1085#1076#1080#1088#1086#1074#1086#1095#1085#1099#1077
            DataBinding.FieldName = 'Amount_20401'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clrpAmount_Start: TcxGridDBColumn
            Caption = #1053#1072#1095#1072#1083#1100#1085#1099#1081' '#1086#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Amount_Start'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clrpAmount_In: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'Amount_In'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clrpAmount_Out: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076
            DataBinding.FieldName = 'Amount_Out'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clrpAmount_End: TcxGridDBColumn
            Caption = #1050#1086#1085#1077#1095#1085#1099#1081' '#1086#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Amount_End'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
        end
        object cxGridReportLevel: TcxGridLevel
          GridView = cxGridReportDBTableView
        end
      end
    end
  end
  object cxLabel17: TcxLabel
    Left = 165
    Top = 85
    Caption = #1050#1086#1083'-'#1074#1086' '#1058#1058
  end
  object edPartnerCount: TcxCurrencyEdit
    Left = 165
    Top = 103
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 135
  end
  object cxLabel18: TcxLabel
    Left = 305
    Top = 85
    Caption = #1044#1072#1090#1072'/'#1042#1088'. '#1085#1072#1095'.'#1087#1088#1086#1089#1090#1086#1103
  end
  object edStartStop: TcxDateEdit
    Left = 305
    Top = 103
    EditValue = 42244d
    Properties.DateButtons = [btnClear, btnToday]
    Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
    Properties.EditFormat = 'dd.mm.yyyy hh:mm'
    Properties.InputKind = ikMask
    Properties.Kind = ckDateTime
    TabOrder = 6
    Width = 145
  end
  object cxLabel19: TcxLabel
    Left = 455
    Top = 85
    Caption = #1044#1072#1090#1072'/'#1042#1088'. '#1086#1082#1086#1085#1095'. '#1087#1088#1086#1089#1090#1086#1103
  end
  object edEndStop: TcxDateEdit
    Left = 455
    Top = 103
    EditValue = 42244d
    Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
    Properties.EditFormat = 'dd.mm.yyyy hh:mm'
    Properties.Kind = ckDateTime
    TabOrder = 8
    Width = 145
  end
  object cxLabel20: TcxLabel
    Left = 610
    Top = 86
    Caption = #1056#1077#1084#1086#1085#1090', '#1095'.'
  end
  object edHoursStop: TcxCurrencyEdit
    Left = 610
    Top = 103
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 75
  end
  object cxLabel21: TcxLabel
    Left = 690
    Top = 86
    Caption = #1042' '#1076#1074#1080#1078#1077#1085#1080#1080', '#1095'.'
  end
  object edHoursMove: TcxCurrencyEdit
    Left = 690
    Top = 103
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 147
  end
  object edCommentStop: TcxTextEdit
    Left = 847
    Top = 103
    TabOrder = 16
    Width = 158
  end
  object cxLabel22: TcxLabel
    Left = 847
    Top = 85
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1087#1088#1080#1095#1080#1085#1072' '#1087#1088#1086#1089#1090#1086#1103')'
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPositionId'
        Value = '8466 '
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChangePrice'
        Value = '0'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isChangePriceUser'
        Value = 'false'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 336
  end
  object spSelectMI: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_Transport'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = ChildCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 169
    Top = 226
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = cxGrid
        Properties.Strings = (
          'Height')
      end
      item
        Component = cxGridChild
        Properties.Strings = (
          'Height')
      end
      item
        Component = cxSplitterChild
        Properties.Strings = (
          'Top')
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
    Left = 80
    Top = 182
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 53
    Top = 182
    object actInsertUpdateMovement: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMovement
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
        end>
      Caption = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 14
      ShortCut = 113
    end
    object actUpdateChangePriceUser: TdsdDataSetRefresh
      Category = 'Update'
      MoveParams = <>
      StoredProc = spUpdateChangePriceUser
      StoredProcList = <
        item
          StoredProc = spUpdateChangePriceUser
        end>
      Caption = 'actUpdateChangePriceUser'
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 43
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object actShowErased: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectMI
      StoredProcList = <
        item
          StoredProc = spSelectMI
        end
        item
          StoredProc = spSelectMIIncome
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
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelectMI
        end
        item
          StoredProc = spSelectMIIncome
        end
        item
          TabSheet = cxTabSheetReport
          StoredProc = spSelectMiReport
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actPrintRoadList: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintHeader
      StoredProcList = <
        item
          StoredProc = spSelectPrintHeader
        end
        item
          StoredProc = spSelectPrintHeader
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1055#1091#1090#1077#1074#1086#1075#1086' '#1083#1080#1089#1090#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1055#1091#1090#1077#1074#1086#1075#1086' '#1083#1080#1089#1090#1072
      ImageIndex = 15
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDMaster'
        end
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end>
      Params = <
        item
          Name = 'isFrom'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090' ('#1090#1080#1087'. '#1092#1086#1088#1084#1072' 2)'
      ReportNameParam.Value = #1055#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090' ('#1090#1080#1087'. '#1092#1086#1088#1084#1072' 2)'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintFrom: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spInsertUpdateMovement
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
        end
        item
          StoredProc = spSelectPrintHeader
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1076#1083#1103' '#1052#1072#1088#1096#1088#1091#1090'-'#1054#1090' '#1082#1086#1075#1086
      Hint = #1055#1077#1095#1072#1090#1100' '#1076#1083#1103' '#1052#1072#1088#1096#1088#1091#1090'-'#1054#1090' '#1082#1086#1075#1086
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDMaster'
        end
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end>
      Params = <
        item
          Name = 'isFrom'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090' - '#1057#1073#1099#1090
      ReportNameParam.Value = ''
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintTo: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spInsertUpdateMovement
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
        end
        item
          StoredProc = spSelectPrintHeader
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1076#1083#1103' '#1052#1072#1088#1096#1088#1091#1090'-'#1050#1086#1084#1091
      Hint = #1055#1077#1095#1072#1090#1100' '#1076#1083#1103' '#1052#1072#1088#1096#1088#1091#1090'-'#1050#1086#1084#1091
      ImageIndex = 16
      ShortCut = 16464
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDMaster'
        end
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end>
      Params = <
        item
          Name = 'isFrom'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090' - '#1057#1073#1099#1090
      ReportNameParam.Value = ''
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintAdmin: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintHeader
      StoredProcList = <
        item
          StoredProc = spSelectPrintHeader
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1076#1083#1103' '#1040#1076#1084#1080#1085
      Hint = #1055#1077#1095#1072#1090#1100' '#1076#1083#1103' '#1040#1076#1084#1080#1085
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDMaster'
        end
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end>
      Params = <>
      ReportName = #1055#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090' - '#1040#1076#1084#1080#1085
      ReportNameParam.Value = ''
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object GridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
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
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdateMasterDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIMaster
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
          StoredProc = spSelectMI
        end
        item
          StoredProc = spGet
        end>
      Caption = 'actUpdateMasterDS'
      DataSource = MasterDS
    end
    object actUpdateChildDS: TdsdUpdateDataSet
      Category = 'DSDLibChild'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIChild
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIChild
        end>
      Caption = 'actUpdateChildDS'
      DataSource = ChildDS
    end
    object actPrintCost: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintCost
      StoredProcList = <
        item
          StoredProc = spSelectPrintCost
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1047#1072#1090#1088#1072#1090
      Hint = #1055#1077#1095#1072#1090#1100' '#1047#1072#1090#1088#1072#1090
      ImageIndex = 23
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
          IndexFieldNames = 'PartnerName;MovemenId_Sale;GoodsName;GoodsKindName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090' ('#1079#1072#1090#1088#1072#1090#1099')'
      ReportNameParam.Name = #1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = #1055#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090' ('#1079#1072#1090#1088#1072#1090#1099')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actUpdateIncomeDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIIncome
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIIncome
        end>
      Caption = 'actUpdateIncomeDS'
      DataSource = IncomeDS
    end
    object InsertRecord: TInsertRecord
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Action = RouteChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1052#1072#1088#1096#1088#1091#1090'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1052#1072#1088#1096#1088#1091#1090'>'
      ShortCut = 45
      ImageIndex = 0
    end
    object SetUnErasedChild: TdsdUpdateErased
      Category = 'DSDLibChild'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spUnErasedMIChild
      StoredProcList = <
        item
          StoredProc = spUnErasedMIChild
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = ChildDS
    end
    object SetErased: TdsdUpdateErased
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1052#1072#1088#1096#1088#1091#1090'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1052#1072#1088#1096#1088#1091#1090'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = MasterDS
    end
    object SetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spUnErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spUnErasedMIMaster
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = MasterDS
    end
    object RouteChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'RouteChoiceForm'
      FormName = 'TRouteForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RouteId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RouteCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RouteName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'RouteKindId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RouteKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'RouteKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RouteKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'FreightId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'FreightId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'FreightName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'FreightName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'RouteKindId2'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RouteKindId_Freight'
          MultiSelectSeparator = ','
        end
        item
          Name = 'RouteKindName2'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RouteKindName_Freight'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'RateSumma'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RateSumma'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'RatePrice'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RatePrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'TimePrice'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'TimePrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'RateSummaAdd'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RateSummaAdd'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'RateSummaExp'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RateSummaExp'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object UnitChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'UnitChoiceForm'
      FormName = 'TUnit_ObjectForm'
      FormNameParam.Value = 'TUnit_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object SetErasedChild: TdsdUpdateErased
      Category = 'DSDLibChild'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spErasedMIChild
      StoredProcList = <
        item
          StoredProc = spErasedMIChild
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1058#1086#1087#1083#1080#1074#1086'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1058#1086#1087#1083#1080#1074#1086'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = ChildDS
    end
    object FreightChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'FreightChoiceForm'
      FormName = 'TFreightForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'FreightId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'FreightName'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object RouteKindFreightChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'RouteKindFreightChoiceForm'
      FormName = 'TRouteKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RouteKindId_Freight'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RouteKindName_Freight'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object InsertRecordIncome: TInsertRecord
      Category = 'DSDLib'
      TabSheet = cxTabSheetIncome
      MoveParams = <>
      Enabled = False
      PostDataSetBeforeExecute = False
      View = cxGridIncomeDBTableView
      Action = SourceFuel_ObjectChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1055#1088#1080#1093#1086#1076' ('#1047#1072#1087#1088#1072#1074#1082#1072' '#1072#1074#1090#1086')>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1055#1088#1080#1093#1086#1076' ('#1047#1072#1087#1088#1072#1074#1082#1072' '#1072#1074#1090#1086')>'
      ShortCut = 45
      ImageIndex = 0
    end
    object SetErasedIncome: TdsdUpdateErased
      Category = 'DSDLib'
      TabSheet = cxTabSheetIncome
      MoveParams = <>
      Enabled = False
      StoredProc = spErasedMIIncome
      StoredProcList = <
        item
          StoredProc = spErasedMIIncome
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1055#1088#1080#1093#1086#1076' ('#1047#1072#1087#1088#1072#1074#1082#1072' '#1072#1074#1090#1086')>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1055#1088#1080#1093#1086#1076' ('#1047#1072#1087#1088#1072#1074#1082#1072' '#1072#1074#1090#1086')>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = IncomeDS
    end
    object SetUnErasedIncome: TdsdUpdateErased
      Category = 'DSDLib'
      TabSheet = cxTabSheetIncome
      MoveParams = <>
      Enabled = False
      StoredProc = spUnErasedMIIncome
      StoredProcList = <
        item
          StoredProc = spUnErasedMIIncome
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = IncomeDS
    end
    object SourceFuel_ObjectChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ObjectFrom_byIncomeFuelChoiceForm'
      FormName = 'TSourceFuel_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = IncomeCDS
          ComponentItem = 'FromId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = IncomeCDS
          ComponentItem = 'FromCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = IncomeCDS
          ComponentItem = 'FromName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindId'
          Value = Null
          Component = IncomeCDS
          ComponentItem = 'PaidKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindName'
          Value = Null
          Component = IncomeCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractId'
          Value = Null
          Component = IncomeCDS
          ComponentItem = 'ContractId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = Null
          Component = IncomeCDS
          ComponentItem = 'ContractName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ChangePrice'
          Value = Null
          Component = IncomeCDS
          ComponentItem = 'ChangePrice'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = IncomeCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsCode'
          Value = Null
          Component = IncomeCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = IncomeCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'FuelName'
          Value = Null
          Component = IncomeCDS
          ComponentItem = 'FuelName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = IncomeCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object PaidKindChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PaidKindChoiceForm'
      FormName = 'TPaidKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = IncomeCDS
          ComponentItem = 'PaidKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = IncomeCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object GoodsChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsChoiceForm'
      FormName = 'TGoods_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = IncomeCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = IncomeCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = IncomeCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'FuelName'
          Value = Null
          Component = IncomeCDS
          ComponentItem = 'FuelName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object RouteIncomeChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'RouteChoiceForm'
      FormName = 'TRouteForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = IncomeCDS
          ComponentItem = 'RouteId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = IncomeCDS
          ComponentItem = 'RouteName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUnCompleteIncome: TdsdChangeMovementStatus
      Category = 'DSDLib'
      TabSheet = cxTabSheetIncome
      MoveParams = <>
      Enabled = False
      StoredProc = spMovementUnCompleteIncome
      StoredProcList = <
        item
          StoredProc = spMovementUnCompleteIncome
        end
        item
          StoredProc = spSelectMIIncome
        end
        item
          StoredProc = spSelectMiReport
        end
        item
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 11
      Status = mtUncomplete
      DataSource = IncomeDS
    end
    object actCompleteIncome: TdsdChangeMovementStatus
      Category = 'DSDLib'
      TabSheet = cxTabSheetIncome
      MoveParams = <>
      Enabled = False
      StoredProc = spMovementCompleteIncome
      StoredProcList = <
        item
          StoredProc = spMovementCompleteIncome
        end
        item
          StoredProc = spSelectMIIncome
        end
        item
          StoredProc = spSelectMiReport
        end
        item
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 12
      Status = mtComplete
      DataSource = IncomeDS
    end
    object actSetErasedIncome: TdsdChangeMovementStatus
      Category = 'DSDLib'
      TabSheet = cxTabSheetIncome
      MoveParams = <>
      Enabled = False
      StoredProc = spMovementSetErasedIncome
      StoredProcList = <
        item
          StoredProc = spMovementSetErasedIncome
        end
        item
          StoredProc = spSelectMIIncome
        end
        item
          StoredProc = spSelectMiReport
        end
        item
        end>
      Caption = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      Hint = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      ImageIndex = 13
      Status = mtDelete
      DataSource = IncomeDS
    end
    object UnCompleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 11
      Status = mtUncomplete
      Guides = StatusGuides
    end
    object CompleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
          StoredProc = spSelectMI
        end
        item
          StoredProc = spSelectMiReport
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 12
      Status = mtComplete
      Guides = StatusGuides
    end
    object DeleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end>
      Caption = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      Hint = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      ImageIndex = 13
      Status = mtDelete
      Guides = StatusGuides
    end
    object actUpdate_PartnerCount: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_PartnerCount
      StoredProcList = <
        item
          StoredProc = spUpdate_PartnerCount
        end
        item
          StoredProc = spGet
        end>
      Caption = #1056#1072#1089#1095#1077#1090' "'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1058#1058'"'
      Hint = #1056#1072#1089#1095#1077#1090' "'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1058#1058'"'
      ImageIndex = 28
    end
    object TotalRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      TabSheet = cxTabSheetReport
      MoveParams = <>
      Enabled = False
      StoredProc = spSelectMiReport
      StoredProcList = <
        item
          StoredProc = spSelectMiReport
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object MIChildProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLibChild'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1087#1086#1076#1095#1080#1085#1077#1085#1085#1099#1093' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1087#1086#1076#1095#1080#1085#1077#1085#1085#1099#1093' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FuelName'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'FuelName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object MIProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'RouteName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RouteName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdate_Confirmed_No: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Confirmed_No
      StoredProcList = <
        item
          StoredProc = spUpdate_Confirmed_No
        end
        item
          StoredProc = spGet
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' "'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1086' '#1087#1088#1080#1095#1080#1085#1072#1093' '#1087#1088#1086#1089#1090#1086#1103'"'
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' "'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1086' '#1087#1088#1080#1095#1080#1085#1072#1093' '#1087#1088#1086#1089#1090#1086#1103'"'
      ImageIndex = 52
    end
    object actUpdate_Confirmed_Yes: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Confirmed_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_Confirmed_Yes
        end
        item
          StoredProc = spGet
        end>
      Caption = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' "'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1086' '#1087#1088#1080#1095#1080#1085#1072#1093' '#1087#1088#1086#1089#1090#1086#1103'"'
      Hint = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' "'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1086' '#1087#1088#1080#1095#1080#1085#1072#1093' '#1087#1088#1086#1089#1090#1086#1103'"'
      ImageIndex = 77
    end
    object actUpdateChangePriceUserDialog: TExecuteDialog
      Category = 'Update'
      MoveParams = <>
      Caption = 'actUpdateChangePriceUserDialog'
      ImageIndex = 43
      FormName = 'TChangePriceUserDialogForm'
      FormNameParam.Value = 'TChangePriceUserDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'ChangePrice'
          Value = 0.000000000000000000
          Component = FormParams
          ComponentItem = 'ChangePrice'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'isChangePriceUser'
          Value = False
          Component = FormParams
          ComponentItem = 'isChangePriceUser'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'ChangePrice'
          Value = Null
          Component = IncomeCDS
          ComponentItem = 'ChangePrice'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isChangePriceUser'
          Value = Null
          Component = IncomeCDS
          ComponentItem = 'isChangePriceUser'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object macUpdateChangePriceUserDialog: TMultiAction
      Category = 'Update'
      TabSheet = cxTabSheetIncome
      MoveParams = <>
      Enabled = False
      ActionList = <
        item
          Action = actUpdateChangePriceUserDialog
        end
        item
          Action = actUpdateChangePriceUser
        end
        item
          Action = actRefresh
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1056#1091#1095#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1074' '#1094#1077#1085#1077'>'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1056#1091#1095#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1074' '#1094#1077#1085#1077'>'
      ImageIndex = 43
    end
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 45
    Top = 226
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 16
    Top = 226
  end
  object GuidesCar: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCar
    FormNameParam.Value = 'TCarForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCarForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCar
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCar
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 250
    Top = 11
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Transport'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarId'
        Value = ''
        Component = GuidesCar
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarName'
        Value = ''
        Component = GuidesCar
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarTrailerId'
        Value = ''
        Component = GuidesCarTrailer
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarTrailerName'
        Value = ''
        Component = GuidesCarTrailer
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalDriverId'
        Value = ''
        Component = GuidesPersonalDriver
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalDriverName'
        Value = ''
        Component = GuidesPersonalDriver
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalDriverMoreId'
        Value = ''
        Component = GuidesPersonalDriverMore
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalDriverMoreName'
        Value = ''
        Component = GuidesPersonalDriverMore
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalId'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalName'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitForwardingId'
        Value = ''
        Component = GuidesBranchForwarding
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitForwardingName'
        Value = ''
        Component = GuidesBranchForwarding
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartRunPlan'
        Value = 0d
        Component = edStartRunPlan
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndRunPlan'
        Value = 0d
        Component = edEndRunPlan
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartRun'
        Value = 0d
        Component = edStartRun
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndRun'
        Value = 0d
        Component = edEndRun
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'HoursWork'
        Value = 0.000000000000000000
        Component = edHoursWork
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'HoursAdd'
        Value = 0.000000000000000000
        Component = edHoursAdd
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = ''
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerCount'
        Value = Null
        Component = edPartnerCount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartStop'
        Value = Null
        Component = edStartStop
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndStop'
        Value = Null
        Component = edEndStop
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'HoursStop'
        Value = Null
        Component = edHoursStop
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'HoursMove'
        Value = Null
        Component = edHoursMove
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CommentStop'
        Value = Null
        Component = edCommentStop
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Date_UserConfirmedKind'
        Value = Null
        Component = edDate_UserConfirmedKind
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName_ConfirmedKind'
        Value = Null
        Component = edUserName_ConfirmedKind
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 205
    Top = 206
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 222
    Top = 294
    object N1: TMenuItem
      Action = actRefresh
    end
  end
  object spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_Transport_Master'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RouteId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDistanceFuelChild'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DistanceFuelChild'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDistanceWeightTransport'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DistanceWeightTransport'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeight'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Weight'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeightTransport'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightTransport'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartOdometre'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StartOdometre'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndOdometre'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'EndOdometre'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioRateSumma'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RateSumma'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRatePrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RatePrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTimePrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TimePrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxi'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Taxi'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxiMore'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TaxiMore'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioRateSummaAdd'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RateSummaAdd'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRateSummaExp'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RateSummaExp'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outRatePrice_Calc'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RatePrice_Calc'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFreightId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'FreightId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteKindId_Freight'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RouteKindId_Freight'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RouteKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioUnitId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outUnitName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 83
    Top = 218
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ParentId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 16
    Top = 270
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 44
    Top = 278
  end
  object spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Transport'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartRunPlan'
        Value = 0d
        Component = edStartRunPlan
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndRunPlan'
        Value = 0d
        Component = edEndRunPlan
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartRun'
        Value = 0d
        Component = edStartRun
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndRun'
        Value = 0d
        Component = edEndRun
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartStop'
        Value = Null
        Component = edStartStop
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndStop'
        Value = Null
        Component = edEndStop
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHoursAdd'
        Value = 0.000000000000000000
        Component = edHoursAdd
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outHoursWork'
        Value = 0.000000000000000000
        Component = edHoursWork
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = ''
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCommentStop'
        Value = Null
        Component = edCommentStop
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCarId'
        Value = ''
        Component = GuidesCar
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCarTrailerId'
        Value = ''
        Component = GuidesCarTrailer
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalDriverId'
        Value = ''
        Component = GuidesPersonalDriver
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalDriverMoreId'
        Value = ''
        Component = GuidesPersonalDriverMore
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitForwardingId'
        Value = ''
        Component = GuidesBranchForwarding
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 460
    Top = 298
  end
  object GuidesCarTrailer: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCarTrailer
    FormNameParam.Value = 'TCarForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCarForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCarTrailer
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCarTrailer
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 730
    Top = 83
  end
  object GuidesPersonalDriver: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalDriver
    FormNameParam.Value = 'TPersonalPosition_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalPosition_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalDriver
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalDriver
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPositionId'
        Value = 8466
        MultiSelectSeparator = ','
      end>
    Left = 194
    Top = 11
  end
  object GuidesPersonalDriverMore: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalDriverMore
    FormNameParam.Value = 'TPersonalPosition_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalPosition_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalDriverMore
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalDriverMore
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPositionId'
        Value = 8466
        MultiSelectSeparator = ','
      end>
    Left = 778
    Top = 35
  end
  object GuidesBranchForwarding: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBranchForwarding
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBranchForwarding
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBranchForwarding
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 1066
    Top = 43
  end
  object spInsertUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_Transport_Child'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'ParentId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFuelId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'FuelId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsCalculated'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isCalculated'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsMasterFuel'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isMasterFuel'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmount'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmount_calc'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Amount_calc'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmount_Distance_calc'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Amount_Distance_calc'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmount_ColdHour_calc'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Amount_ColdHour_calc'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmount_ColdDistance_calc'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Amount_ColdDistance_calc'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inColdHour'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'ColdHour'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inColdDistance'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'ColdDistance'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountFuel'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'AmountFuel'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountColdHour'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'AmountColdHour'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountColdDistance'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'AmountColdDistance'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNumber'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Number'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRateFuelKindTax'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'RateFuelKindTax'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRateFuelKindId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'RateFuelKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 154
    Top = 317
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    GuidesList = <
      item
        Guides = GuidesCar
      end
      item
        Guides = GuidesPersonalDriver
      end
      item
        Guides = GuidesBranchForwarding
      end>
    ActionItemList = <
      item
        Action = actInsertUpdateMovement
      end>
    Left = 256
    Top = 196
  end
  object HeaderSaver: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    StoredProc = spInsertUpdateMovement
    ControlList = <
      item
        Control = edOperDate
      end
      item
        Control = edCar
      end
      item
        Control = edPersonalDriver
      end
      item
        Control = edStartRun
      end
      item
        Control = edStartRunPlan
      end
      item
        Control = edEndRun
      end
      item
        Control = edEndRunPlan
      end
      item
        Control = edHoursAdd
      end
      item
        Control = edCarTrailer
      end
      item
        Control = edPersonalDriverMore
      end
      item
        Control = edPersonal
      end
      item
        Control = edBranchForwarding
      end
      item
        Control = edComment
      end
      item
        Control = edEndStop
      end
      item
        Control = edStartStop
      end
      item
        Control = edCommentStop
      end>
    GetStoredProc = spGet
    Left = 299
    Top = 211
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
    Left = 25
    Top = 182
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
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbAddRoute'
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
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbAddIncome'
        end
        item
          Visible = True
          ItemName = 'bbErasedIncome'
        end
        item
          Visible = True
          ItemName = 'bbUnErasedIncome'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedChild'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErasedChild'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbCompleteIncome'
        end
        item
          Visible = True
          ItemName = 'bbUnCompleteIncome'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedIncome'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStatic'
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
          ItemName = 'bbInsertUpdate_Confirmed_Yes'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdate_Confirmed_No'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_PartnerCount'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateChangePriceUserDialog'
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
          ItemName = 'bbPrintFrom'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintTo'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintRoadList'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintCost'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbMIProtocol'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbMIChildProtocol'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExel'
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
    object bbInsertUpdateMovement: TdxBarButton
      Action = actInsertUpdateMovement
      Category = 0
    end
    object bbShowErased: TdxBarButton
      Action = actShowErased
      Category = 0
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object bbPrintFrom: TdxBarButton
      Action = actPrintFrom
      Category = 0
    end
    object bbPrintTo: TdxBarButton
      Action = actPrintTo
      Category = 0
    end
    object bbPrintAdmin: TdxBarButton
      Action = actPrintAdmin
      Category = 0
    end
    object bbGridToExel: TdxBarButton
      Action = GridToExcel
      Category = 0
    end
    object bbStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
    object bbAddRoute: TdxBarButton
      Action = InsertRecord
      Category = 0
    end
    object bbErased: TdxBarButton
      Action = SetErased
      Category = 0
    end
    object bbUnErased: TdxBarButton
      Action = SetUnErased
      Category = 0
    end
    object bbAddIncome: TdxBarButton
      Action = InsertRecordIncome
      Category = 0
    end
    object bbErasedIncome: TdxBarButton
      Action = SetErasedIncome
      Category = 0
    end
    object bbUnErasedIncome: TdxBarButton
      Action = SetUnErasedIncome
      Category = 0
    end
    object bbCompleteIncome: TdxBarButton
      Action = actCompleteIncome
      Category = 0
    end
    object bbUnCompleteIncome: TdxBarButton
      Action = actUnCompleteIncome
      Category = 0
    end
    object bbSetErasedIncome: TdxBarButton
      Action = actSetErasedIncome
      Category = 0
    end
    object bbMIContainer: TdxBarButton
      Action = actMIContainer
      Category = 0
    end
    object bbMIProtocol: TdxBarButton
      Action = MIProtocolOpenForm
      Category = 0
    end
    object bbMIChildProtocol: TdxBarButton
      Action = MIChildProtocolOpenForm
      Category = 0
    end
    object bbSetErasedChild: TdxBarButton
      Action = SetErasedChild
      Category = 0
    end
    object bbSetUnErasedChild: TdxBarButton
      Action = SetUnErasedChild
      Category = 0
    end
    object bbPrintRoadList: TdxBarButton
      Action = actPrintRoadList
      Category = 0
    end
    object bbInsertUpdate_Confirmed_Yes: TdxBarButton
      Action = actUpdate_Confirmed_Yes
      Category = 0
    end
    object bbInsertUpdate_Confirmed_No: TdxBarButton
      Action = actUpdate_Confirmed_No
      Category = 0
    end
    object bbUpdate_PartnerCount: TdxBarButton
      Action = actUpdate_PartnerCount
      Category = 0
    end
    object bbPrintCost: TdxBarButton
      Action = actPrintCost
      Category = 0
    end
    object bbUpdateChangePriceUserDialog: TdxBarButton
      Action = macUpdateChangePriceUserDialog
      Category = 0
    end
  end
  object RefreshAddOn: TRefreshAddOn
    DataSet = 'ClientDataSet'
    KeyField = 'Id'
    RefreshAction = 'actRefresh'
    FormParams = 'FormParams'
    Left = 506
    Top = 275
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 191
    Top = 254
  end
  object MasterViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = True
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 285
    Top = 326
  end
  object ChildViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridChildDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = True
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 368
    Top = 334
  end
  object IncomeCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 16
    Top = 314
  end
  object IncomeDS: TDataSource
    DataSet = IncomeCDS
    Left = 45
    Top = 314
  end
  object spSelectMIIncome: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_TransportIncome'
    DataSet = IncomeCDS
    DataSets = <
      item
        DataSet = IncomeCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 154
    Top = 274
  end
  object spInsertUpdateMIIncome: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_TransportIncome'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inParentId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioMovementId'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'MovementId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioInvNumber'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'InvNumber'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioOperDatePartner'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'OperDatePartner'
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumberPartner'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'InvNumberPartner'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPriceWithVAT'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'PriceWithVAT'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioVATPercent'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'VATPercent'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChangePrice'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'ChangePrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'FromId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesCar
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPaidKindId'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'PaidKindId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPaidKindName'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'PaidKindName'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioContractId'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'ContractId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioContractName'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'ContractName'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioRouteId'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'RouteId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioRouteName'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'RouteName'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalDriverId'
        Value = ''
        Component = GuidesPersonalDriver
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioMovementItemId'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'MovementItemId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioGoodsId'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioGoodsCode'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'GoodsCode'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioGoodsName'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'GoodsName'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioFuelName'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'FuelName'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPrice'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCountForPrice'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'CountForPrice'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountSumm'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'AmountSumm'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountSummTotal'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'AmountSummTotal'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 115
    Top = 306
  end
  object spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpSetErased_MovementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 814
    Top = 209
  end
  object spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpSetUnErased_MovementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 678
    Top = 201
  end
  object spErasedMIIncome: TdsdStoredProc
    StoredProcName = 'gpSetErased_MovementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'MovementItemId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 612
    Top = 244
  end
  object spUnErasedMIIncome: TdsdStoredProc
    StoredProcName = 'gpSetUnErased_MovementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'MovementItemId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 684
    Top = 260
  end
  object IncomeViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridIncomeDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = True
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 271
    Top = 388
  end
  object spMovementCompleteIncome: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_Income'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'MovementId'
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
    Left = 552
    Top = 329
  end
  object spMovementUnCompleteIncome: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 624
    Top = 345
  end
  object spMovementSetErasedIncome: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 696
    Top = 329
  end
  object StatusGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceStatus
    FormNameParam.Value = ''
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 40
    Top = 16
  end
  object spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Transport'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 64
    Top = 16
  end
  object ReportCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 16
    Top = 357
  end
  object ReportDS: TDataSource
    DataSet = ReportCDS
    Left = 45
    Top = 357
  end
  object spSelectMiReport: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_TransportReport'
    DataSet = ReportCDS
    DataSets = <
      item
        DataSet = ReportCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 162
    Top = 365
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 420
    Top = 210
  end
  object spSelectPrintHeader: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Transport'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 530
    Top = 210
  end
  object GuidesPersonal: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonal
    FormNameParam.Value = 'TPersonalPosition_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalPosition_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPositionId'
        Value = 81178
        MultiSelectSeparator = ','
      end>
    Left = 938
    Top = 43
  end
  object spErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpSetErased_MovementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 846
    Top = 321
  end
  object spUnErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpSetUnErased_MovementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 798
    Top = 329
  end
  object spUpdate_Confirmed_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Transport_Confirmed'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisConfirmed'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 348
    Top = 250
  end
  object spUpdate_Confirmed_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Transport_Confirmed'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisConfirmed'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 348
    Top = 274
  end
  object spUpdate_PartnerCount: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Transport_PartnerCount'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 348
    Top = 293
  end
  object spSelectPrintCost: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_TransportCost_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 967
    Top = 272
  end
  object spUpdateChangePriceUser: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_IncomeFuel_ChangePriceUser'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId '
        Value = Null
        Component = IncomeCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChangePrice'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'ChangePrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChangePriceUser'
        Value = False
        Component = FormParams
        ComponentItem = 'isChangePriceUser'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 208
    Top = 473
  end
end
