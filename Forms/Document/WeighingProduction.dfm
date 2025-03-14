object WeighingProductionForm: TWeighingProductionForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077' ('#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')>'
  ClientHeight = 629
  ClientWidth = 1289
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
    Width = 1289
    Height = 129
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object edInvNumber: TcxTextEdit
      Left = 113
      Top = 23
      Enabled = False
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 75
    end
    object cxLabel1: TcxLabel
      Left = 113
      Top = 5
      Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    end
    object edOperDate: TcxDateEdit
      Left = 277
      Top = 23
      EditValue = 42182d
      Enabled = False
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 96
    end
    object cxLabel2: TcxLabel
      Left = 277
      Top = 5
      Caption = #1044#1072#1090#1072' ('#1089#1082#1083#1072#1076')'
    end
    object edFrom: TcxButtonEdit
      Left = 379
      Top = 23
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 3
      Width = 176
    end
    object edTo: TcxButtonEdit
      Left = 560
      Top = 23
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 2
      Width = 231
    end
    object cxLabel3: TcxLabel
      Left = 379
      Top = 5
      Caption = #1054#1090' '#1082#1086#1075#1086
    end
    object cxLabel4: TcxLabel
      Left = 560
      Top = 5
      Caption = #1050#1086#1084#1091
    end
    object cxLabel5: TcxLabel
      Left = 560
      Top = 45
      Caption = #1050#1086#1076' '#1086#1087#1077#1088#1072#1094#1080#1080'('#1074#1079#1074#1077#1096'.)'
    end
    object cxLabel6: TcxLabel
      Left = 379
      Top = 45
      Hint = #1053#1072#1095'.'#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1103
      Caption = #1053#1072#1095'.'#1074#1079#1074#1077#1096'.'
      ParentShowHint = False
      ShowHint = True
    end
    object edStartWeighing: TcxDateEdit
      Left = 379
      Top = 62
      EditValue = 42182d
      Enabled = False
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 5
      Width = 83
    end
    object edMovementDescNumber: TcxTextEdit
      Left = 560
      Top = 62
      Enabled = False
      TabOrder = 4
      Width = 118
    end
    object cxLabel7: TcxLabel
      Left = 683
      Top = 45
      Caption = #1042#1080#1076' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    end
    object cxLabel11: TcxLabel
      Left = 8
      Top = 45
      Caption = #1057#1090#1072#1090#1091#1089
    end
    object ceStatus: TcxButtonEdit
      Left = 9
      Top = 61
      Enabled = False
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
      TabOrder = 14
      Width = 179
    end
    object cxLabel9: TcxLabel
      Left = 472
      Top = 45
      Hint = #1054#1082#1086#1085'. '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1103
      Caption = #1054#1082#1086#1085'. '#1074#1079#1074#1077#1096'.'
      ParentShowHint = False
      ShowHint = True
    end
    object edEndWeighing: TcxDateEdit
      Left = 472
      Top = 62
      EditValue = 42182d
      Enabled = False
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 16
      Width = 83
    end
    object cxLabel8: TcxLabel
      Left = 795
      Top = 5
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
    end
    object edUser: TcxButtonEdit
      Left = 795
      Top = 23
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 18
      Width = 146
    end
    object cxLabel14: TcxLabel
      Left = 192
      Top = 45
      Caption = #8470' '#1076#1086#1082'.('#1075#1083#1072#1074#1085')'
    end
    object edInvNumber_parent: TcxTextEdit
      Left = 192
      Top = 61
      Enabled = False
      Properties.ReadOnly = True
      TabOrder = 20
      Width = 80
    end
    object cxLabel12: TcxLabel
      Left = 277
      Top = 45
      Caption = #1044#1072#1090#1072' '#1076#1086#1082'. ('#1075#1083#1072#1074#1085')'
    end
    object cxLabel10: TcxLabel
      Left = 192
      Top = 5
      Caption = #8470' '#1074#1079#1074#1077#1096'.'
    end
    object edWeighingNumber: TcxCurrencyEdit
      Left = 192
      Top = 23
      Enabled = False
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      Properties.ReadOnly = True
      TabOrder = 23
      Width = 80
    end
    object edisIncome: TcxCheckBox
      Left = 881
      Top = 44
      Caption = #1055#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
      Properties.ReadOnly = True
      TabOrder = 24
      Width = 104
    end
    object edIsAuto: TcxCheckBox
      Left = 881
      Top = 65
      Hint = #1057#1086#1079#1076#1072#1085' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080
      Caption = #1057#1086#1079#1076#1072#1085' '#1072#1074#1090#1086#1084#1072#1090'.'
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 25
      Width = 113
    end
    object cxLabel17: TcxLabel
      Left = 9
      Top = 5
      Caption = #8470' '#1076#1086#1082'. '#1086#1089#1085#1086#1074#1072#1085#1080#1077
    end
    object edInvNumberOrder: TcxButtonEdit
      Left = 9
      Top = 22
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 27
      Width = 99
    end
    object cxLabel22: TcxLabel
      Left = 1008
      Top = 45
      Caption = #8470' '#1073#1088#1080#1075#1072#1076#1099
    end
    object edPersonalGroup: TcxButtonEdit
      Left = 1008
      Top = 61
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 29
      Width = 108
    end
    object cxLabel19: TcxLabel
      Left = 473
      Top = 81
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object ceComment: TcxTextEdit
      Left = 472
      Top = 96
      Enabled = False
      Properties.ReadOnly = True
      TabOrder = 31
      Width = 319
    end
    object cbisList: TcxCheckBox
      Left = 797
      Top = 96
      Hint = #1057#1086#1079#1076#1072#1085' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080
      Caption = #1048#1085#1074#1077#1085#1090'. '#1076#1083#1103' '#1089#1087#1080#1089#1082#1072
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 32
      Width = 129
    end
    object edBranchCode: TcxCurrencyEdit
      Left = 9
      Top = 96
      Enabled = False
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 3
      Properties.DisplayFormat = ',0.'
      Properties.ReadOnly = True
      TabOrder = 33
      Width = 179
    end
    object cxLabel21: TcxLabel
      Left = 9
      Top = 81
      Hint = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100', '#1082#1075
      Caption = #1050#1086#1076' '#1060#1080#1083#1080#1072#1083#1072
      ParentShowHint = False
      ShowHint = True
    end
    object cbisRePack: TcxCheckBox
      Left = 935
      Top = 96
      Caption = #1055#1077#1088#1077#1087#1072#1082
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 35
      Width = 69
    end
  end
  object cxPageControl: TcxPageControl
    Left = 0
    Top = 155
    Width = 1289
    Height = 474
    Align = alClient
    TabOrder = 1
    Properties.ActivePage = cxTabSheetMain
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 474
    ClientRectRight = 1289
    ClientRectTop = 24
    object cxTabSheetMain: TcxTabSheet
      Caption = #1057#1090#1088#1086#1095#1085#1072#1103' '#1095#1072#1089#1090#1100
      ImageIndex = 0
      object cxGrid: TcxGrid
        Left = 0
        Top = 0
        Width = 1289
        Height = 450
        Align = alClient
        TabOrder = 0
        object cxGridDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = MasterDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00;-,0.00;'
              Position = spFooter
              Column = CountSkewer1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = UpdateDate
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = WeightTare
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountSkewer1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = LiveWeight
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
              Column = CountPack
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountSkewer2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = WeightOther
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare5
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountSkewer1
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
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = UpdateDate
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = LiveWeight
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
              Column = CountPack
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountSkewer2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = WeightOther
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare5
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
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
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 82
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 33
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 38
          end
          object PartionGoods: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'PartionGoods'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object PartionGoodsDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1072#1088#1090#1080#1080
            DataBinding.FieldName = 'PartionGoodsDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 67
          end
          object StartWeighing: TcxGridDBColumn
            Caption = #1056#1077#1078#1080#1084' '#1085#1072#1095'. '#1074#1079#1074#1077#1096'.'
            DataBinding.FieldName = 'StartWeighing'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 54
          end
          object isAuto: TcxGridDBColumn
            Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080
            DataBinding.FieldName = 'isAuto'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
          end
          object UpdateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1080
            DataBinding.FieldName = 'UpdateDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object InsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1089#1086#1079#1076#1072#1085#1080#1103
            DataBinding.FieldName = 'InsertDate'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 53
          end
          object RealWeight: TcxGridDBColumn
            Caption = #1056#1077#1072#1083'. '#1074#1077#1089
            DataBinding.FieldName = 'RealWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 47
          end
          object CountTare: TcxGridDBColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1090#1072#1088#1099
            DataBinding.FieldName = 'CountTare'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object WeightTare: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1090#1072#1088#1099
            DataBinding.FieldName = 'WeightTare'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object LiveWeight: TcxGridDBColumn
            Caption = #1046#1080#1074#1086#1081' '#1074#1077#1089
            DataBinding.FieldName = 'LiveWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object HeadCount: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1075#1086#1083#1086#1074
            DataBinding.FieldName = 'HeadCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 42
          end
          object Count: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1073#1072#1090#1086#1085#1086#1074
            DataBinding.FieldName = 'Count'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 51
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
          object IsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountSkewer1: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1096#1087'.1/'#1082#1088'.'
            DataBinding.FieldName = 'CountSkewer1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object CountSkewer2: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1096#1087'. 2'
            DataBinding.FieldName = 'CountSkewer2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 47
          end
          object WeightOther: TcxGridDBColumn
            Caption = #1042#1077#1089', '#1087#1088#1086#1095#1077#1077
            DataBinding.FieldName = 'WeightOther'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 42
          end
          object WeightSkewer1: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1086#1076#1085'. '#1096#1087'.1/'#1082#1088'.'
            DataBinding.FieldName = 'WeightSkewer1'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object WeightSkewer2: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1086#1076#1085'. '#1096#1087'.2'
            DataBinding.FieldName = 'WeightSkewer2'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 59
          end
          object StorageLineName: TcxGridDBColumn
            Caption = #1051#1080#1085#1080#1103' '#1087#1088'-'#1074#1072
            DataBinding.FieldName = 'StorageLineName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object PersonalKVKName: TcxGridDBColumn
            Caption = #1054#1087#1077#1088#1072#1090#1086#1088' '#1050#1042#1050' ('#1060'.'#1048'.'#1054')'
            DataBinding.FieldName = 'PersonalKVKName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1087#1077#1088#1072#1090#1086#1088' '#1050#1042#1050' ('#1060'.'#1048'.'#1054')'
            Options.Editing = False
            Width = 70
          end
          object PositionName_KVK: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1054#1087'. '#1050#1042#1050')'
            DataBinding.FieldName = 'PositionName_KVK'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1054#1087#1077#1088#1072#1090#1086#1088' '#1050#1042#1050')'
            Options.Editing = False
            Width = 78
          end
          object UnitName_KVK: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1054#1087'. '#1050#1042#1050')'
            DataBinding.FieldName = 'UnitName_KVK'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1054#1087#1077#1088#1072#1090#1086#1088' '#1050#1042#1050')'
            Options.Editing = False
            Width = 83
          end
          object KVK: TcxGridDBColumn
            Caption = #8470' '#1050#1042#1050
            DataBinding.FieldName = 'KVK'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1050#1042#1050
            Options.Editing = False
            Width = 70
          end
          object AssetName: TcxGridDBColumn
            Caption = #1042#1099#1088#1072#1073#1086#1090#1082#1072' '#1085#1072' '#1054#1057'-1'
            DataBinding.FieldName = 'AssetName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1099#1088#1072#1073#1086#1090#1082#1072' '#1085#1072' '#1086#1073#1086#1088#1091#1076#1086#1074#1072#1085#1080#1080'-1'
            Options.Editing = False
            Width = 80
          end
          object AssetName_two: TcxGridDBColumn
            Caption = #1042#1099#1088#1072#1073#1086#1090#1082#1072' '#1085#1072' '#1054#1057'-2'
            DataBinding.FieldName = 'AssetName_two'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1099#1088#1072#1073#1086#1090#1082#1072' '#1085#1072' '#1086#1073#1086#1088#1091#1076#1086#1074#1072#1085#1080#1080'-2'
            Options.Editing = False
            Width = 80
          end
          object BoxName_1: TcxGridDBColumn
            Caption = #1058#1072#1088#1072'-1'
            DataBinding.FieldName = 'BoxName_1'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object BoxName_2: TcxGridDBColumn
            Caption = #1058#1072#1088#1072'-2'
            DataBinding.FieldName = 'BoxName_2'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object BoxName_3: TcxGridDBColumn
            Caption = #1058#1072#1088#1072'-3'
            DataBinding.FieldName = 'BoxName_3'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object BoxName_4: TcxGridDBColumn
            Caption = #1058#1072#1088#1072'-4'
            DataBinding.FieldName = 'BoxName_4'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object BoxName_5: TcxGridDBColumn
            Caption = #1058#1072#1088#1072'-5'
            DataBinding.FieldName = 'BoxName_5'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object CountTare1: TcxGridDBColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1090#1072#1088#1099' '#1074#1080#1076#1072' 1'
            DataBinding.FieldName = 'CountTare1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object CountTare2: TcxGridDBColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1090#1072#1088#1099' '#1074#1080#1076#1072' 2'
            DataBinding.FieldName = 'CountTare2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object CountTare3: TcxGridDBColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1090#1072#1088#1099' '#1074#1080#1076#1072' 3'
            DataBinding.FieldName = 'CountTare3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object CountTare4: TcxGridDBColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1090#1072#1088#1099' '#1074#1080#1076#1072' 4'
            DataBinding.FieldName = 'CountTare4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object CountTare5: TcxGridDBColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1090#1072#1088#1099' '#1074#1080#1076#1072' 5'
            DataBinding.FieldName = 'CountTare5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object PartionCellName: TcxGridDBColumn
            Caption = #1071#1095#1077#1081#1082#1072' '#1093#1088#1072#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'PartionCellName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object PartionNum: TcxGridDBColumn
            Caption = #8470' '#1087#1072#1089#1087#1086#1088#1090#1072
            DataBinding.FieldName = 'PartionNum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
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
    end
    object cxTabSheetPartionCell: TcxTabSheet
      Caption = #1054#1089#1090#1072#1090#1082#1080' '#1087#1086' '#1071#1095#1077#1081#1082#1072#1084' '#1093#1088#1072#1085#1077#1085#1080#1103
      ImageIndex = 1
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object cxGrid_PartionCell: TcxGrid
        Left = 0
        Top = 0
        Width = 1289
        Height = 450
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 0
        object cxGridDBTableView_PartionCell: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = PartionCellDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_ch4
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_ch4
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName_ch4
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
          object GoodsGroupNameFull_ch4: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object GoodsCode_ch4: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object GoodsName_ch4: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' / '#1054#1057
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 182
          end
          object GoodsKindName_ch4: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object MeasureName_ch4: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object PartionGoodsDate_ch4: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1072#1088#1090#1080#1080
            DataBinding.FieldName = 'PartionGoodsDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.SaveTime = False
            Properties.ShowTime = False
            Properties.UseNullString = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
          object Amount_ch4: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PartionCellName_1_ch4: TcxGridDBColumn
            Caption = '1.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_1'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-1 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_2_ch4: TcxGridDBColumn
            Caption = '2.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_2'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-2 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_3_ch4: TcxGridDBColumn
            Caption = '3.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_3'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-3 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_4_ch4: TcxGridDBColumn
            Caption = '4.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_4'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-4 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_5_ch4: TcxGridDBColumn
            Caption = '5.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_5'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-5 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_6_ch4: TcxGridDBColumn
            Caption = '6.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_6'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-6 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_7_ch4: TcxGridDBColumn
            Caption = '7.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_7'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-7 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_8_ch4: TcxGridDBColumn
            Caption = '8.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_8'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-8 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_9_ch4: TcxGridDBColumn
            Caption = '9.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_9'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-9 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_10_ch4: TcxGridDBColumn
            Caption = '10.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_10'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-10 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_11_ch4: TcxGridDBColumn
            Caption = '11.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_11'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-11 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_12_ch4: TcxGridDBColumn
            Caption = '12.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_12'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-12 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_13_ch4: TcxGridDBColumn
            Caption = '13.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_13'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-13 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_14_ch4: TcxGridDBColumn
            Caption = '14.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_14'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-14 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_15_ch4: TcxGridDBColumn
            Caption = '15.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_15'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-15 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_16_ch4: TcxGridDBColumn
            Caption = '16.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_16'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-16 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_17_ch4: TcxGridDBColumn
            Caption = '17.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_17'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-17 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_18_ch4: TcxGridDBColumn
            Caption = '18.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_18'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-18 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_19_ch4: TcxGridDBColumn
            Caption = '19.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_19'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-19 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_20_ch4: TcxGridDBColumn
            Caption = '20.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_20'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-20 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_21_ch4: TcxGridDBColumn
            Caption = '21.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_21'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-21 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_22_ch4: TcxGridDBColumn
            Caption = '22.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_22'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-22 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_1_ch4: TcxGridDBColumn
            Caption = '1.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_1'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-51 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_2_ch4: TcxGridDBColumn
            Caption = '2.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_2'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-2 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_3_ch4: TcxGridDBColumn
            Caption = '3.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_3'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-3 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_4_ch4: TcxGridDBColumn
            Caption = '4.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_4'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-4 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_5_ch4: TcxGridDBColumn
            Caption = '5.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_5'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-5 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_6_ch4: TcxGridDBColumn
            Caption = '6.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_6'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-6 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_7_ch4: TcxGridDBColumn
            Caption = '7.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_7'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-7 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_8_ch4: TcxGridDBColumn
            Caption = '8.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_8'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-8 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_9_ch4: TcxGridDBColumn
            Caption = '9.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_9'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-9 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_10_ch4: TcxGridDBColumn
            Caption = '10.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_10'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-10 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_11_ch4: TcxGridDBColumn
            Caption = '11.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_11'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-11 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_12_ch4: TcxGridDBColumn
            Caption = '12.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_12'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-12 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_13_ch4: TcxGridDBColumn
            Caption = '13.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_13'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-13 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_14_ch4: TcxGridDBColumn
            Caption = '14.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_14'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-14 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_15_ch4: TcxGridDBColumn
            Caption = '15.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_15'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-15 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_16_ch4: TcxGridDBColumn
            Caption = '16.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_16'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-16 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_17_ch4: TcxGridDBColumn
            Caption = '17.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_17'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-17 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_18_ch4: TcxGridDBColumn
            Caption = '18.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_18'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-18 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_19_ch4: TcxGridDBColumn
            Caption = '19.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_19'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-19 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_20_ch4: TcxGridDBColumn
            Caption = '20.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_20'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-20 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_21_ch4: TcxGridDBColumn
            Caption = '21.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_21'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-21 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_22_ch4: TcxGridDBColumn
            Caption = '22.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_22'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-22 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_1_ch4: TcxGridDBColumn
            Caption = '1.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_1'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-1('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_2_ch4: TcxGridDBColumn
            Caption = '2.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_2'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-2('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_3_ch4: TcxGridDBColumn
            Caption = '3.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_3'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-3('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_4_ch4: TcxGridDBColumn
            Caption = '4.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_4'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-4('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_5_ch4: TcxGridDBColumn
            Caption = '5.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_5'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-5('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_6_ch4: TcxGridDBColumn
            Caption = '6.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_6'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-6('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_7_ch4: TcxGridDBColumn
            Caption = '7.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_7'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-7('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_8_ch4: TcxGridDBColumn
            Caption = '8.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_8'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-8('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_9_ch4: TcxGridDBColumn
            Caption = '9.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_9'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-9('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_10_ch4: TcxGridDBColumn
            Caption = '10.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_10'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-10('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_11_ch4: TcxGridDBColumn
            Caption = '11.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_11'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-11('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_12_ch4: TcxGridDBColumn
            Caption = '12.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_12'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-12('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_13_ch4: TcxGridDBColumn
            Caption = '13.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_13'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-13 ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_14_ch4: TcxGridDBColumn
            Caption = '14.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_14'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-14 ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_15_ch4: TcxGridDBColumn
            Caption = '15.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_15'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-15 ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_16_ch4: TcxGridDBColumn
            Caption = '16.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_16'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-16 ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_17_ch4: TcxGridDBColumn
            Caption = '17.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_17'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-17 ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_18_ch4: TcxGridDBColumn
            Caption = '18.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_18'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-18 ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_19_ch4: TcxGridDBColumn
            Caption = '19.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_19'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-19 ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_20_ch4: TcxGridDBColumn
            Caption = '20.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_20'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-20 ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_21_ch4: TcxGridDBColumn
            Caption = '21.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_21'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-21 ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_22_ch4: TcxGridDBColumn
            Caption = '22.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_22'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-22 ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isErased_ch4: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
        end
        object cxGridLevel_PartionCell: TcxGridLevel
          GridView = cxGridDBTableView_PartionCell
        end
      end
    end
  end
  object edOperDate_parent: TcxDateEdit
    Left = 277
    Top = 62
    EditValue = 42182d
    Enabled = False
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 3
    Width = 96
  end
  object cxLabel18: TcxLabel
    Left = 795
    Top = 45
    Caption = #1055#1072#1088#1090#1080#1103' '#1090#1086#1074#1072#1088#1072
  end
  object edPartionGoods: TcxTextEdit
    Left = 795
    Top = 62
    Enabled = False
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 83
  end
  object cxLabel13: TcxLabel
    Left = 946
    Top = 5
    Caption = #1058#1080#1087' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object edDocumentKind: TcxButtonEdit
    Left = 946
    Top = 23
    Enabled = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 170
  end
  object edMovementDescName: TcxButtonEdit
    Left = 680
    Top = 62
    Enabled = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 111
  end
  object cxLabel15: TcxLabel
    Left = 1122
    Top = 5
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1090#1086#1074#1072#1088#1072
  end
  object edGoodsTypeKind: TcxButtonEdit
    Left = 1122
    Top = 23
    Enabled = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 160
  end
  object cxLabel16: TcxLabel
    Left = 1122
    Top = 45
    Caption = #1064'/'#1050' '#1076#1083#1103' '#1103#1097#1080#1082#1086#1074
  end
  object edBarCodeBox: TcxButtonEdit
    Left = 1122
    Top = 61
    Enabled = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 160
  end
  object cxLabel20: TcxLabel
    Left = 192
    Top = 81
    Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
  end
  object ed: TcxButtonEdit
    Left = 192
    Top = 96
    Enabled = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 270
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
        Name = 'ShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormName'
        Value = 'TWeighingProductionEditForm'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 262
    Top = 375
  end
  object spSelectMI: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_WeighingProduction'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
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
        Component = FormParams
        ComponentItem = 'ShowAll'
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
    Left = 264
    Top = 287
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
    Left = 22
    Top = 231
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
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStatic'
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
          ItemName = 'bbOpenDocument'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateParams'
        end
        item
          Visible = True
          ItemName = 'bbUpdateBox'
        end
        item
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
          ItemName = 'bbOpenDocumentMain'
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
          ItemName = 'sbbPrint'
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
          ItemName = 'bbProtocol'
        end
        item
          Visible = True
          ItemName = 'bbMIProtocolOpenFormCell'
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
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
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
    end
    object bbErased: TdxBarButton
      Action = SetErased
      Category = 0
    end
    object bbUnErased: TdxBarButton
      Action = SetUnErased
      Category = 0
    end
    object bbProtocol: TdxBarButton
      Action = MovementItemProtocolOpenForm
      Category = 0
    end
    object bbOpenDocument: TdxBarButton
      Action = actUpdateDocument
      Category = 0
    end
    object bbUpdateParams: TdxBarButton
      Action = macUpdateParams
      Category = 0
      ImageIndex = 43
    end
    object bbPrintNoGroup: TdxBarButton
      Action = actPrintNoGroup
      Category = 0
    end
    object bbPrintBarCode: TdxBarButton
      Action = actPrintBarCode
      Category = 0
    end
    object bbOpenDocumentMain: TdxBarButton
      Action = macOpenDocument
      Category = 0
    end
    object bbPrintStikerKVK: TdxBarButton
      Action = actPrintStikerKVK
      Category = 0
    end
    object bbMIProtocolOpenFormCell: TdxBarButton
      Action = MIProtocolOpenFormCell
      Category = 0
    end
    object bbUpdateBox: TdxBarButton
      Action = macUpdateBox
      Category = 0
    end
    object bbSelectMIPrintPassport: TdxBarButton
      Action = actSelectMIPrintPassport
      Category = 0
    end
    object sbbPrint: TdxBarSubItem
      Caption = #1055#1077#1095#1072#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 3
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'bbPrintNoGroup'
        end
        item
          Visible = True
          ItemName = 'bbPrintBarCode'
        end
        item
          Visible = True
          ItemName = 'bbPrintStikerKVK'
        end
        item
          Visible = True
          ItemName = 'bbSelectMIPrintPassport'
        end>
    end
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
    Left = 81
    Top = 232
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 51
    Top = 231
    object actInsertUpdateMovement: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 14
      ShortCut = 113
    end
    object actShowErased: TBooleanStoredProcAction
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spSelectMI
      StoredProcList = <
        item
          StoredProc = spSelectMI
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
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spSelectMI
      StoredProcList = <
        item
          StoredProc = spSelectMI
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actUpdateMasterDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actUpdateMasterDS'
      DataSource = MasterDS
    end
    object actRefreshMI: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectMI
      StoredProcList = <
        item
          StoredProc = spSelectMI
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
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
          StoredProc = spSelect_MI_PartionCell
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintCeh
      StoredProcList = <
        item
          StoredProc = spSelectPrintCeh
        end>
      Caption = #1055#1077#1095#1072#1090#1100' - '#1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077' '#1087'/'#1092' '#1092#1072#1082#1090' '#1082#1091#1090#1090#1077#1088#1072
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 17
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
      Params = <>
      ReportName = #1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1087#1086' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1102' '#1082#1091#1090#1090#1077#1088#1072
      ReportNameParam.Value = #1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1087#1086' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1102' '#1082#1091#1090#1090#1077#1088#1072
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object GridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
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
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
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
    object UnCompleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end
        item
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
        end
        item
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
        end
        item
        end
        item
        end>
      Caption = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      Hint = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      ImageIndex = 13
      Status = mtDelete
      Guides = StatusGuides
    end
    object MIProtocolOpenFormCell: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = cxTabSheetPartionCell
      MoveParams = <>
      Enabled = False
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'> '#1103#1095'.'#1086#1090#1073'.'
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object MovementItemProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
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
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdateDocument: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TWeighingProductionEditForm'
      FormNameParam.Value = 'TWeighingProductionEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
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
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object ExecuteDialogUpdateParams: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1082#1072#1090#1077#1075#1086#1088#1080#1102' '#1090#1086#1074'. '#1080#1083#1080' '#1064'/'#1082' '#1076#1083#1103' '#1103#1097'.'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1082#1072#1090#1077#1075#1086#1088#1080#1102' '#1090#1086#1074'. '#1080#1083#1080' '#1064'/'#1082' '#1076#1083#1103' '#1103#1097'.'
      ImageIndex = 55
      FormName = 'TWeighingProductionParamEditForm'
      FormNameParam.Value = 'TWeighingProductionParamEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inBarCodeBoxId'
          Value = '0'
          Component = GuidesBarCodeBox
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inBarCodeBoxName'
          Value = Null
          Component = GuidesBarCodeBox
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsTypeKindId'
          Value = '0'
          Component = GuidesGoodsTypeKind
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsTypeKindName'
          Value = ''
          Component = GuidesGoodsTypeKind
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdateParams: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Param
      StoredProcList = <
        item
          StoredProc = spUpdate_Param
        end>
      Caption = 'actExecStoredUpdateUnit'
      ImageIndex = 55
    end
    object macUpdateParams: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogUpdateParams
        end
        item
          Action = actUpdateParams
        end>
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1082#1072#1090#1077#1075#1086#1088#1080#1102' '#1090#1086#1074'. '#1080#1083#1080' '#1064'/'#1082' '#1076#1083#1103' '#1103#1097'.?'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1082#1072#1090#1077#1075#1086#1088#1080#1102' '#1090#1086#1074'. '#1080#1083#1080' '#1064'/'#1082' '#1076#1083#1103' '#1103#1097'.'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1082#1072#1090#1077#1075#1086#1088#1080#1102' '#1090#1086#1074'. '#1080#1083#1080' '#1064'/'#1082' '#1076#1083#1103' '#1103#1097'.'
      ImageIndex = 55
    end
    object actPrintNoGroup: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintNoGroup
      StoredProcList = <
        item
          StoredProc = spSelectPrintNoGroup
        end>
      Caption = #1055#1077#1095#1072#1090#1100' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      Hint = #1055#1077#1095#1072#1090#1100' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      ImageIndex = 16
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
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_WeighingProduction'
      ReportNameParam.Value = 'PrintMovement_WeighingProduction'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintStikerKVK: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintBarCode
      StoredProcList = <
        item
          StoredProc = spSelectPrintBarCode
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072' '#1050#1042#1050
      Hint = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072' '#1050#1042#1050
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDItems'
        end>
      Params = <
        item
          Name = 'isPrintTermo'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_WeighingProductionStikerKVK'
      ReportNameParam.Value = 'PrintMovement_WeighingProductionStikerKVK'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actSelectMIPrintPassport: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectMIPrintPassport
      StoredProcList = <
        item
          StoredProc = spSelectMIPrintPassport
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1055#1072#1089#1087#1086#1088#1090#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1055#1072#1089#1087#1086#1088#1090#1072
      ImageIndex = 23
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDItems'
        end>
      Params = <
        item
          Name = 'isPrintTermo'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMI_WeighingProductionPassport'
      ReportNameParam.Value = 'PrintMI_WeighingProductionPassport'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintBarCode: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintBarCode
      StoredProcList = <
        item
          StoredProc = spSelectPrintBarCode
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1064'/'#1050
      Hint = #1055#1077#1095#1072#1090#1100' '#1064'/'#1050
      ImageIndex = 20
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDItems'
        end>
      Params = <
        item
          Name = 'isPrintTermo'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_WeighingProductionBarCode'
      ReportNameParam.Value = 'PrintMovement_WeighingProductionBarCode'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actGetForm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = getMovementForm
      StoredProcList = <
        item
          StoredProc = getMovementForm
        end>
      Caption = 'actGetForm'
    end
    object actOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      FormName = 'TWeighingProductionEditForm'
      FormNameParam.Value = 'TWeighingProductionEditForm'
      FormNameParam.Component = FormParams
      FormNameParam.ComponentItem = 'FormName'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'MovementId_parent'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          ComponentItem = 'OperDate_parent'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object macOpenDocument: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetForm
        end
        item
          Action = actOpenForm
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1075#1083'. '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1075#1083#1072#1074#1085#1086#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 28
    end
    object actUpdateBox: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1090#1072#1088#1099
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1090#1072#1088#1099
      ImageIndex = 69
      FormName = 'TWeighingProductionBoxEditForm'
      FormNameParam.Value = 'TWeighingProductionBoxEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inId'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'Id'
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
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsKindId'
          Value = Null
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
          Name = 'PartionGoodsDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionGoodsDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'RealWeight'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RealWeight'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object macUpdateBox: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateBox
        end
        item
          Action = actRefreshMI
        end
        item
          Action = actSelectMIPrintPassport
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1090#1072#1088#1099
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1090#1072#1088#1099
      ImageIndex = 69
    end
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 46
    Top = 303
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 16
    Top = 303
  end
  object dsdGuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = dsdGuidesFrom
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdGuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 360
    Top = 80
  end
  object dsdGuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = dsdGuidesTo
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdGuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 688
    Top = 65528
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 768
    Top = 216
    object N1: TMenuItem
      Action = actRefresh
    end
  end
  object MasterViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <
      item
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
    Left = 347
    Top = 337
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 806
    Top = 263
  end
  object HeaderSaver: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edOperDate
      end
      item
        Control = edStartWeighing
      end
      item
        Control = edMovementDescNumber
      end
      item
        Control = edFrom
      end
      item
        Control = edTo
      end
      item
        Control = edDocumentKind
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    GetStoredProc = spGet
    Left = 296
    Top = 217
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_WeighingProduction'
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
        Name = 'StatusCode'
        Value = Null
        Component = StatusGuides
        ComponentItem = 'Key'
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
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_parent'
        Value = ''
        Component = edInvNumber_parent
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate_parent'
        Value = 0d
        Component = edOperDate_parent
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartWeighing'
        Value = Null
        Component = edStartWeighing
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndWeighing'
        Value = Null
        Component = edEndWeighing
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Order'
        Value = Null
        Component = OrderChoiceGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberOrder'
        Value = Null
        Component = OrderChoiceGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementDescNumber'
        Value = ''
        Component = edMovementDescNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementDesc'
        Value = ''
        Component = MovementDescGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementDescName'
        Value = 0.000000000000000000
        Component = MovementDescGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'WeighingNumber'
        Value = 0.000000000000000000
        Component = edWeighingNumber
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionGoods'
        Value = ''
        Component = edPartionGoods
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isProductionIn'
        Value = False
        Component = edisIncome
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAuto'
        Value = Null
        Component = edIsAuto
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isList'
        Value = Null
        Component = cbisList
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isRePack'
        Value = Null
        Component = cbisRePack
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromId'
        Value = ''
        Component = dsdGuidesFrom
        ComponentItem = 'Key'
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName'
        Value = ''
        Component = dsdGuidesFrom
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = ''
        Component = dsdGuidesTo
        ComponentItem = 'Key'
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = ''
        Component = dsdGuidesTo
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'DocumentKindId'
        Value = ''
        Component = GuidesDocumentKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'DocumentKindName'
        Value = ''
        Component = GuidesDocumentKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName'
        Value = ''
        Component = UserGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsTypeKindId'
        Value = Null
        Component = GuidesGoodsTypeKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsTypeKindName'
        Value = Null
        Component = GuidesGoodsTypeKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BarCodeBoxId'
        Value = Null
        Component = GuidesBarCodeBox
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BarCodeBoxName'
        Value = Null
        Component = GuidesBarCodeBox
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Parent'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId_Parent'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalGroupId'
        Value = Null
        Component = GuidesPersonalGroup
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalGroupName'
        Value = Null
        Component = GuidesPersonalGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SubjectDocId'
        Value = Null
        Component = GuidesSubjectDoc
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'SubjectDocName'
        Value = Null
        Component = GuidesSubjectDoc
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 216
    Top = 224
  end
  object RefreshAddOn: TRefreshAddOn
    DataSet = 'ClientDataSet'
    KeyField = 'Id'
    RefreshAction = 'actRefresh'
    FormParams = 'FormParams'
    Left = 422
    Top = 306
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    GuidesList = <
      item
        Guides = dsdGuidesFrom
      end
      item
        Guides = dsdGuidesTo
      end>
    ActionItemList = <
      item
        Action = actInsertUpdateMovement
      end>
    Left = 144
    Top = 200
  end
  object ChangeStatus: TChangeStatus
    KeyField = 'Code'
    LookupControl = ceStatus
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    StoredProcName = 'gpUpdate_Status_WeighingProduction'
    Left = 8
    Top = 184
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
    Left = 630
    Top = 224
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
    Left = 638
    Top = 288
  end
  object StatusGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceStatus
    FormNameParam.Value = ''
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 87
    Top = 24
  end
  object spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_WeighingProduction'
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
    Left = 140
    Top = 16
  end
  object UserGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUser
    FormNameParam.Value = 'TUserForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUserForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UserGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UserGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 743
  end
  object GuidesDocumentKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edDocumentKind
    FormNameParam.Value = 'TDocumentKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TDocumentKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesDocumentKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesDocumentKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 1032
    Top = 8
  end
  object spSelectPrintCeh: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ProductionUnion_Ceh_Print'
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
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Weighing'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsAll'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 384
    Top = 256
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 484
    Top = 217
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 412
    Top = 222
  end
  object MovementDescGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMovementDescName
    FormNameParam.Value = 'TMovementDescForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMovementDescForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = MovementDescGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = MovementDescGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 536
    Top = 32
  end
  object GuidesGoodsTypeKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsTypeKind
    FormNameParam.Value = 'TGoodsTypeKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsTypeKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsTypeKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsTypeKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 1248
  end
  object GuidesBarCodeBox: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBarCodeBox
    FormNameParam.Value = 'TBarCodeBoxForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBarCodeBoxForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBarCodeBox
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBarCodeBox
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 1208
    Top = 56
  end
  object spUpdate_Param: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_WeighingProduction_Param'
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
        Name = 'inBarCodeBoxId'
        Value = '0'
        Component = GuidesBarCodeBox
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsTypeKindId'
        Value = '0'
        Component = GuidesGoodsTypeKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 522
    Top = 344
  end
  object spSelectPrintNoGroup: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_WeighingProduction_Print'
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
        Value = 'true'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 759
    Top = 344
  end
  object spSelectPrintBarCode: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_WeighingProduction_PrintBarCode'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
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
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 903
    Top = 344
  end
  object OrderChoiceGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInvNumberOrder
    Key = '0'
    FormNameParam.Value = 'TOrderExternal_SendOnPriceJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TOrderExternal_SendOnPriceJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = OrderChoiceGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = OrderChoiceGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPartnerId'
        Value = ''
        Component = dsdGuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPartnerName'
        Value = ''
        Component = dsdGuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 42184d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDateEnd'
        Value = 42184d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 52
    Top = 24
  end
  object getMovementForm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form_Process'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId_parent'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormName'
        Value = Null
        Component = FormParams
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 624
    Top = 360
  end
  object GuidesPersonalGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalGroup
    FormNameParam.Value = 'TPersonalGroupForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 960
    Top = 120
  end
  object GuidesSubjectDoc: TdsdGuides
    KeyField = 'Id'
    LookupControl = ed
    FormNameParam.Value = 'TDocumentKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TDocumentKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesSubjectDoc
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesSubjectDoc
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 286
    Top = 96
  end
  object PartionCellCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 1096
    Top = 224
  end
  object PartionCellDS: TDataSource
    DataSet = PartionCellCDS
    Left = 1032
    Top = 224
  end
  object DBViewAddOn_PartionCell: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView_PartionCell
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 1094
    Top = 281
  end
  object spSelect_MI_PartionCell: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_WeighingProduction_PartionCell'
    DataSet = PartionCellCDS
    DataSets = <
      item
        DataSet = PartionCellCDS
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
        Name = 'inIsErased'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1032
    Top = 280
  end
  object spSelectMIPrintPassport: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_WeighingProduction_PrintPassport'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
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
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 903
    Top = 432
  end
end
