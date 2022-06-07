inherited OrderExternalForm: TOrderExternalForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1047#1072#1082#1072#1079' '#1087#1086' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072#1091'>'
  ClientHeight = 611
  ClientWidth = 1227
  AddOnFormData.PUSHMessage = actPUSHInfo
  ExplicitWidth = 1243
  ExplicitHeight = 650
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 221
    Width = 1227
    Height = 390
    ExplicitTop = 221
    ExplicitWidth = 1222
    ExplicitHeight = 390
    ClientRectBottom = 390
    ClientRectRight = 1227
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1222
      ExplicitHeight = 366
      inherited cxGrid: TcxGrid
        Width = 1227
        Height = 366
        ExplicitWidth = 1222
        ExplicitHeight = 366
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
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
              Column = Summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummWithNDS
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
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
              Column = Summ
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummWithNDS
            end>
          OptionsBehavior.CellHints = True
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupSummaryLayout = gslStandard
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object isResolution_224: TcxGridDBColumn [0]
            Caption = #1055#1086#1089#1090'. 224'
            DataBinding.FieldName = 'isResolution_224'
            FooterAlignmentHorz = taCenter
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1055#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224'
            Options.Editing = False
            Width = 53
          end
          object PartnerGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
            DataBinding.FieldName = 'PartnerGoodsCode'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 76
          end
          object PartnerGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1091' '#1087#1088#1086#1076#1072#1074#1094#1072
            DataBinding.FieldName = 'PartnerGoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 93
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 42
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 210
          end
          object NDS_PriceList: TcxGridDBColumn
            Caption = #1053#1044#1057' ('#1087#1088#1072#1081#1089')'
            DataBinding.FieldName = 'NDS_PriceList'
            FooterAlignmentHorz = taCenter
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1053#1044#1057' ('#1080#1079' '#1087#1088#1072#1081#1089#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072')'
            Options.Editing = False
            Width = 55
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 42
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 43
          end
          object Summ: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1072' '#1073#1077#1079' '#1053#1044#1057
            DataBinding.FieldName = 'Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 88
          end
          object SummWithNDS: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1072' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'SummWithNDS'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 88
          end
          object PartionGoodsDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'PartionGoodsDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 69
          end
          object MinimumLot: TcxGridDBColumn
            Caption = #1052#1080#1085'. '#1086#1082#1088#1091#1075#1083'.'
            DataBinding.FieldName = 'MinimumLot'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 54
          end
          object isSp: TcxGridDBColumn
            Caption = #1057#1086#1094'. '#1087#1088#1086#1077#1082#1090
            DataBinding.FieldName = 'isSp'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042' '#1089#1087#1080#1089#1082#1077' '#1087#1088#1086#1077#1082#1090#1072' '#171#1044#1086#1089#1090#1091#1087#1085#1099#1077' '#1083#1077#1082#1072#1088#1089#1090#1074#1072#187
            Options.Editing = False
            Width = 47
          end
          object Comment: TcxGridDBColumn
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object CommonCode: TcxGridDBColumn
            Caption = #1082#1086#1076' '#1052#1086#1088#1080#1086#1085
            DataBinding.FieldName = 'CommonCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 62
          end
          object PartionGoodsDateColor: TcxGridDBColumn
            DataBinding.FieldName = 'PartionGoodsDateColor'
            Visible = False
            VisibleForCustomization = False
            Width = 60
          end
          object AreaName: TcxGridDBColumn
            Caption = #1056#1077#1075#1080#1086#1085' ('#1090#1086#1074#1072#1088')'
            DataBinding.FieldName = 'AreaName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object RetailName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1089#1077#1090#1080
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1053#1072#1079#1074#1072#1085#1080#1077' '#1089#1077#1090#1080
            Options.Editing = False
            Width = 66
          end
          object IsClose: TcxGridDBColumn
            Caption = #1047#1072#1082#1088#1099#1090' '#1082#1086#1076' '#1087#1086' '#1074#1089#1077#1081' '#1089#1077#1090#1080
            DataBinding.FieldName = 'IsClose'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 56
          end
          object isFirst: TcxGridDBColumn
            Caption = '1-'#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isFirst'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 60
          end
          object isSecond: TcxGridDBColumn
            Caption = #1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isSecond'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 60
          end
          object isTOP: TcxGridDBColumn
            Caption = #1058#1054#1055' '#1089#1077#1090#1080
            DataBinding.FieldName = 'isTOP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 60
          end
          object OrderShedule_Color: TcxGridDBColumn
            DataBinding.FieldName = 'OrderShedule_Color'
            Visible = False
            VisibleForCustomization = False
          end
          object isSupplierFailures: TcxGridDBColumn
            Caption = #1054#1090#1082#1072#1079' '#1087#1086#1089#1090'.'
            DataBinding.FieldName = 'isSupplierFailures'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 51
          end
          object SupplierFailuresColor: TcxGridDBColumn
            DataBinding.FieldName = 'SupplierFailuresColor'
            Visible = False
            VisibleForCustomization = False
          end
          object Layout: TcxGridDBColumn
            Caption = #1042#1099#1082#1083#1072#1076#1082#1072
            DataBinding.FieldName = 'Layout'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
        end
      end
      object cxGridExport: TcxGrid
        Left = 567
        Top = 120
        Width = 250
        Height = 200
        TabOrder = 1
        Visible = False
        object cxGridExportDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ExportDS
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
        end
        object cxGridExportLevel1: TcxGridLevel
          GridView = cxGridExportDBTableView
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1227
    Height = 195
    TabOrder = 3
    ExplicitWidth = 1222
    ExplicitHeight = 195
    inherited edInvNumber: TcxTextEdit
      Left = 12
      ExplicitLeft = 12
      ExplicitWidth = 74
      Width = 74
    end
    inherited cxLabel1: TcxLabel
      Left = 12
      ExplicitLeft = 12
    end
    inherited edOperDate: TcxDateEdit
      Left = 93
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 93
    end
    inherited cxLabel2: TcxLabel
      Left = 93
      ExplicitLeft = 93
    end
    inherited cxLabel15: TcxLabel
      Left = 12
      Top = 45
      ExplicitLeft = 12
      ExplicitTop = 45
    end
    inherited ceStatus: TcxButtonEdit
      Left = 12
      Top = 60
      ExplicitLeft = 12
      ExplicitTop = 60
      ExplicitWidth = 181
      ExplicitHeight = 22
      Width = 181
    end
    object cxLabel3: TcxLabel
      Left = 202
      Top = 5
      Caption = #1070#1088' '#1083#1080#1094#1086' '#1087#1086#1089#1090#1072#1074#1097#1080#1082
    end
    object edFrom: TcxButtonEdit
      Left = 202
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 190
    end
    object edTo: TcxButtonEdit
      Left = 400
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 8
      Width = 250
    end
    object cxLabel4: TcxLabel
      Left = 400
      Top = 5
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object cxLabel6: TcxLabel
      Left = 202
      Top = 45
      Caption = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1079#1072#1082#1072#1079
    end
    object edOrderInternal: TcxButtonEdit
      Left = 202
      Top = 60
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 190
    end
    object edisDeferred: TcxCheckBox
      Left = 663
      Top = 58
      Caption = #1054#1090#1083#1086#1078#1077#1085
      TabOrder = 12
      Width = 70
    end
    object cxLabel13: TcxLabel
      Left = 664
      Top = 83
      Caption = #1055#1088#1080#1084#1077#1095'. '#1082' '#1084#1080#1085'. '#1089#1091#1084#1084#1077' '#1079#1072#1082#1072#1079#1072
    end
    object edOrderSummComment: TcxTextEdit
      Left = 663
      Top = 99
      Properties.ReadOnly = True
      TabOrder = 14
      Width = 149
    end
    object cbDifferent: TcxCheckBox
      Left = 663
      Top = 123
      Hint = #1072#1087#1090#1077#1082#1072' '#1076#1088'. '#1102#1088'.'#1083#1080#1094#1072
      Caption = #1072#1087#1090'. '#1076#1088'. '#1102#1088'.'#1083#1080#1094#1072
      ParentShowHint = False
      ShowHint = True
      TabOrder = 15
      Width = 133
    end
    object edLetterSubject: TcxTextEdit
      Left = 12
      Top = 172
      Properties.ReadOnly = False
      TabOrder = 16
      Width = 799
    end
    object cxLabel14: TcxLabel
      Left = 12
      Top = 120
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object cxLabel16: TcxLabel
      Left = 818
      Top = 5
      Caption = #1040#1076#1088#1077#1089' '#1072#1087#1090#1077#1082#1080
    end
    object edPhone: TcxTextEdit
      Left = 818
      Top = 60
      Properties.ReadOnly = True
      TabOrder = 19
      Width = 391
    end
    object edAddress: TcxTextEdit
      Left = 818
      Top = 23
      Properties.ReadOnly = True
      TabOrder = 20
      Width = 391
    end
    object edTimeWork: TcxTextEdit
      Left = 818
      Top = 99
      Properties.ReadOnly = True
      TabOrder = 21
      Width = 391
    end
    object cxLabel17: TcxLabel
      Left = 818
      Top = 45
      Caption = #1058#1077#1083#1077#1092#1086#1085#1099' '#1072#1087#1090#1077#1082#1080
    end
    object cxLabel18: TcxLabel
      Left = 818
      Top = 83
      Caption = #1042#1088#1077#1084#1103' '#1056#1072#1073#1086#1090#1099
    end
    object edPharmacyManager: TcxTextEdit
      Left = 818
      Top = 135
      Properties.ReadOnly = True
      TabOrder = 24
      Width = 391
    end
    object cxLabel19: TcxLabel
      Left = 818
      Top = 119
      Caption = #1060#1048#1054' '#1047#1072#1074'. '#1072#1087#1090#1077#1082#1086#1081
    end
    object cbUseSubject: TcxCheckBox
      Left = 817
      Top = 172
      Hint = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1090#1077#1084#1091' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1087#1088#1080' '#1086#1090#1087#1088#1072#1074#1082#1077' '#1087#1080#1089#1100#1084#1072' '#1087#1086#1089#1090#1072#1097#1080#1082#1091
      Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1090#1077#1084#1091' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ParentShowHint = False
      ShowHint = True
      TabOrder = 26
      Width = 202
    end
    object cbSupplierFailures: TcxCheckBox
      Left = 1025
      Top = 172
      Hint = #1047#1072#1075#1088#1091#1078#1077#1085' '#1086#1090#1082#1072#1079
      Caption = #1054#1090#1082#1072#1079#1099' '#1087#1088#1086#1089#1090#1072#1074#1083#1077#1085#1099
      ParentShowHint = False
      Properties.ReadOnly = False
      ShowHint = True
      TabOrder = 27
      Width = 133
    end
  end
  object cxLabel5: TcxLabel [2]
    Left = 656
    Top = 5
    Caption = #1059#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072' '#1087#1086#1089#1090'-'#1082#1072' '
  end
  object edContract: TcxButtonEdit [3]
    Left = 656
    Top = 23
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 7
    Width = 156
  end
  object edComment: TcxTextEdit [4]
    Left = 12
    Top = 135
    Properties.ReadOnly = False
    TabOrder = 8
    Width = 380
  end
  object cxLabel7: TcxLabel [5]
    Left = 12
    Top = 156
    Caption = #1058#1077#1084#1072' '#1087#1080#1089#1100#1084#1072' '
  end
  object cxLabel8: TcxLabel [6]
    Left = 400
    Top = 45
    Caption = #1042#1080#1076' '#1079#1072#1082#1072#1079#1072
  end
  object edOrderKind: TcxButtonEdit [7]
    Left = 400
    Top = 60
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 250
  end
  object cxLabel9: TcxLabel [8]
    Left = 12
    Top = 83
    Caption = #1044#1085#1080' '#1079#1072#1082#1072#1079#1072
  end
  object edZakaz_Text: TcxTextEdit [9]
    Left = 12
    Top = 99
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 181
  end
  object cxLabel10: TcxLabel [10]
    Left = 202
    Top = 83
    Caption = #1044#1085#1080' '#1087#1086#1089#1090#1072#1074#1082#1080
  end
  object edDostavka_Text: TcxTextEdit [11]
    Left = 202
    Top = 99
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 190
  end
  object cxLabel11: TcxLabel [12]
    Left = 400
    Top = 83
    Caption = #1052#1080#1085'. '#1089#1091#1084#1084#1072' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072
  end
  object edOrderSumm: TcxTextEdit [13]
    Left = 400
    Top = 99
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 119
  end
  object cxLabel12: TcxLabel [14]
    Left = 533
    Top = 83
    Caption = #1052#1072#1082#1089'. '#1074#1088#1077#1084#1103' '#1086#1090#1087#1088#1072#1074#1082#1080
  end
  object edOrderTime: TcxTextEdit [15]
    Left = 533
    Top = 99
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 117
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 187
    Top = 512
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 48
    Top = 432
  end
  inherited ActionList: TActionList
    Left = 55
    Top = 303
    object actUpdateUserSend: TdsdExecStoredProc [0]
      Category = 'SendEMail'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMovementUserSend
      StoredProcList = <
        item
          StoredProc = spUpdateMovementUserSend
        end
        item
          StoredProc = spSelectExport
        end>
      Caption = 'actExportStoredproc'
    end
    object actExportStoredproc: TdsdExecStoredProc [1]
      Category = 'SendEMail'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetExportParam
      StoredProcList = <
        item
          StoredProc = spGetExportParam
        end
        item
          StoredProc = spSelectExport
        end>
      Caption = 'actExportStoredproc'
    end
    inherited actRefresh: TdsdDataSetRefresh
      RefreshOnTabSetChanges = True
    end
    object actExportToPartner: TExportGrid [4]
      Category = 'SendEMail'
      TabSheet = tsMain
      MoveParams = <>
      ColumnNameDataSet = PrintHeaderCDS
      Grid = cxGridExport
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080
      OpenAfterCreate = False
    end
    object spUpdateisDeferredYes: TdsdExecStoredProc [7]
      Category = 'Deferred'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isDeferred_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_isDeferred_Yes
        end>
      Caption = #1054#1090#1083#1086#1078#1077#1085' - '#1044#1072
      Hint = #1054#1090#1083#1086#1078#1077#1085' - '#1044#1072
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
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
      ReportName = 'PrintMovement_Sale2'
      ReportNameParam.Name = #1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = 'PrintMovement_Sale2'
      ReportNameParam.ParamType = ptInput
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    inherited actCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    object actGoodsKindChoice: TOpenChoiceForm [17]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actRefreshPrice: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actGetDocumentDataForEmail: TdsdExecStoredProc
      Category = 'SendEMail'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetDocumentDataForEmail
      StoredProcList = <
        item
          StoredProc = spGetDocumentDataForEmail
        end>
      Caption = 'actGetDocumentDataForEmail'
    end
    object SMTPFileAction: TdsdSMTPFileAction
      Category = 'SendEMail'
      MoveParams = <>
      Host.Value = Null
      Host.Component = FormParams
      Host.ComponentItem = 'Host'
      Host.MultiSelectSeparator = ','
      Port.Value = 25
      Port.Component = FormParams
      Port.ComponentItem = 'Port'
      Port.MultiSelectSeparator = ','
      UserName.Value = Null
      UserName.Component = FormParams
      UserName.ComponentItem = 'UserName'
      UserName.MultiSelectSeparator = ','
      Password.Value = Null
      Password.Component = FormParams
      Password.ComponentItem = 'Password'
      Password.MultiSelectSeparator = ','
      Body.Value = Null
      Body.Component = FormParams
      Body.ComponentItem = 'Body'
      Body.DataType = ftWideString
      Body.MultiSelectSeparator = ','
      Subject.Value = Null
      Subject.Component = FormParams
      Subject.ComponentItem = 'Subject'
      Subject.MultiSelectSeparator = ','
      FromAddress.Value = Null
      FromAddress.Component = FormParams
      FromAddress.ComponentItem = 'AddressFrom'
      FromAddress.MultiSelectSeparator = ','
      ToAddress.Value = Null
      ToAddress.Component = FormParams
      ToAddress.ComponentItem = 'AddressTo'
      ToAddress.MultiSelectSeparator = ','
    end
    object mactSMTPSend: TMultiAction
      Category = 'SendEMail'
      MoveParams = <>
      ActionList = <
        item
          Action = actPUSH
        end
        item
          Action = actExportStoredproc
        end
        item
          Action = actExportToPartner
        end
        item
          Action = actGetDocumentDataForEmail
        end
        item
          Action = SMTPFileAction
        end
        item
          Action = actUpdateUserSend
        end
        item
          Action = spUpdateisDeferredYes
        end
        item
          Action = actCompleteMovement
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1086#1090#1089#1083#1099#1082#1077' E-mail?'
      InfoAfterExecute = 'E-mail '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' '#1086#1090#1087#1088#1072#1074#1083#1077#1085
      Caption = #1054#1090#1087#1088#1072#1074#1082#1072' E-mail'
      Hint = #1054#1090#1087#1088#1072#1074#1082#1072' E-mail'
      ImageIndex = 53
      ShortCut = 16467
    end
    object actPUSH: TdsdShowPUSHMessage
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spPUSHError
      StoredProcList = <
        item
          StoredProc = spPUSHError
        end>
      Caption = 'actPUSH'
      PUSHMessageType = pmtError
    end
    object actPUSHInfo: TdsdShowPUSHMessage
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spPUSHInfo
      StoredProcList = <
        item
          StoredProc = spPUSHInfo
        end>
      Caption = 'actPUSHInfo'
      PUSHMessageType = pmtInformation
    end
    object actInsertUpdate_SupplierFailures: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_SupplierFailures
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_SupplierFailures
        end>
      Caption = #1055#1086#1084#1077#1089#1090#1080#1090#1100' '#1090#1086#1074#1072#1088' '#1074' "'#1054#1090#1082#1072#1079#1099' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074'"'
      Hint = #1055#1086#1084#1077#1089#1090#1080#1090#1100' '#1090#1086#1074#1072#1088' '#1074' "'#1054#1090#1082#1072#1079#1099' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074'"'
      ImageIndex = 76
      ShortCut = 16463
      QuestionBeforeExecute = #1055#1086#1084#1077#1089#1090#1080#1090#1100' '#1090#1086#1074#1072#1088' '#1074' "'#1054#1090#1082#1072#1079#1099' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074'"?'
    end
    object mactSupplierFailuresLoad: TMultiAction
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSettingId
        end
        item
          Action = actDoLoad
        end
        item
          Action = actUpdate_SetSupplierFailures
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1086#1090#1082#1072#1079#1099' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074'?'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1086#1090#1082#1072#1079#1099' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1086#1090#1082#1072#1079#1099' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
      ImageIndex = 41
    end
    object actGetImportSettingId: TdsdExecStoredProc
      Category = 'Load'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId
        end>
      Caption = 'actGetImportSettingId'
    end
    object actDoLoad: TExecuteImportSettingsAction
      Category = 'Load'
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
    end
    object actUpdate_SetSupplierFailures: TdsdExecStoredProc
      Category = 'Load'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_SetSupplierFailures
      StoredProcList = <
        item
          StoredProc = spUpdate_SetSupplierFailures
        end>
      Caption = 'actUpdate_SetSupplierFailures'
    end
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 512
  end
  inherited MasterCDS: TClientDataSet
    Left = 88
    Top = 512
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_OrderExternal'
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
        Component = actShowAll
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
      end
      item
        Value = ''
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 272
  end
  inherited BarManager: TdxBarManager
    Left = 88
    Top = 223
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbAddMask'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbSendEMail'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdate_SupplierFailures'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbSupplierFailuresLoad'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end>
    end
    inherited bbPrint: TdxBarButton
      Visible = ivNever
    end
    object bbPrint_Bill: TdxBarButton [5]
      Caption = #1057#1095#1077#1090
      Category = 0
      Hint = #1057#1095#1077#1090
      Visible = ivAlways
      ImageIndex = 21
    end
    object bbPrintTax: TdxBarButton [6]
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Category = 0
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Visible = ivAlways
      ImageIndex = 16
    end
    object bbPrintTax_Client: TdxBarButton [7]
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Category = 0
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Visible = ivAlways
      ImageIndex = 18
    end
    inherited bbAddMask: TdxBarButton
      Visible = ivNever
    end
    object bbTax: TdxBarButton
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>'
      Category = 0
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>'
      Visible = ivAlways
      ImageIndex = 41
    end
    object bbSendEMail: TdxBarButton
      Action = mactSMTPSend
      Category = 0
    end
    object bbInsertUpdate_SupplierFailures: TdxBarButton
      Action = actInsertUpdate_SupplierFailures
      Category = 0
    end
    object bbSupplierFailuresLoad: TdxBarButton
      Action = mactSupplierFailuresLoad
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1086#1090#1082#1072#1079#1086#1074' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        ValueColumn = PartionGoodsDateColor
        BackGroundValueColumn = OrderShedule_Color
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsName
        BackGroundValueColumn = SupplierFailuresColor
        ColorValueList = <>
      end>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    Left = 766
    Top = 273
  end
  inherited PopupMenu: TPopupMenu
    Left = 800
    Top = 464
    object N2: TMenuItem
      Action = actMISetErased
    end
    object N3: TMenuItem
      Action = actMISetUnErased
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
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
        Name = 'ReportNameOrderExternal'
        Value = 'PrintMovement_Sale1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameOrderExternalTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameOrderExternalBill'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Body'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AddressFrom'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'AddressTo'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'Subject'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'Host'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'Port'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'Password'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 43831d
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 288
    Top = 504
  end
  inherited StatusGuides: TdsdGuides
    Left = 80
    Top = 48
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_OrderExternal'
    Left = 136
    Top = 56
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_OrderExternal'
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
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
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
        Name = 'FromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterId'
        Value = Null
        Component = OrderInternalGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterInvNumber'
        Value = Null
        Component = OrderInternalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OrderKindName'
        Value = Null
        Component = GuidesOrderKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDeferred'
        Value = Null
        Component = edisDeferred
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Dostavka_Text'
        Value = Null
        Component = edDostavka_Text
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Zakaz_Text'
        Value = Null
        Component = edZakaz_Text
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OrderSumm'
        Value = Null
        Component = edOrderSumm
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OrderTime'
        Value = Null
        Component = edOrderTime
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OrderSummComment'
        Value = Null
        Component = edOrderSummComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDifferent'
        Value = Null
        Component = cbDifferent
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'LetterSubject'
        Value = Null
        Component = edLetterSubject
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Address'
        Value = Null
        Component = edAddress
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Phone'
        Value = Null
        Component = edPhone
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TimeWork'
        Value = Null
        Component = edTimeWork
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PharmacyManager'
        Value = Null
        Component = edPharmacyManager
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isUseSubject'
        Value = Null
        Component = cbUseSubject
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSupplierFailures'
        Value = Null
        Component = cbSupplierFailures
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 296
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_OrderExternal'
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
        Name = 'inFromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInternalOrderId'
        Value = Null
        Component = OrderInternalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDeferred'
        Value = Null
        Component = edisDeferred
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDifferent'
        Value = Null
        Component = cbDifferent
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLetterSubject'
        Value = Null
        Component = edLetterSubject
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisUseSubject'
        Value = Null
        Component = cbUseSubject
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 162
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesFrom
      end
      item
        Guides = GuidesTo
      end>
    Left = 128
    Top = 280
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edOperDate
      end
      item
        Control = edFrom
      end
      item
        Control = edTo
      end
      item
        Control = edComment
      end
      item
        Control = cbDifferent
      end
      item
        Control = edLetterSubject
      end
      item
        Control = cbUseSubject
      end>
    Top = 305
  end
  inherited RefreshAddOn: TRefreshAddOn
    FormName = 'OrderExternalJournalForm'
    DataSet = 'MasterCDS'
    Left = 33
    Top = 25
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderExternal_SetErased'
    Left = 718
    Top = 512
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderExternal_SetUnErased'
    Left = 662
    Top = 496
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_OrderExternal'
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
        Name = 'inMainGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartnerGoodsId'
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
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Summ'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 368
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 368
    Top = 272
  end
  inherited spGetTotalSumm: TdsdStoredProc
    Left = 420
    Top = 300
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefreshPrice
    ComponentList = <
      item
      end>
    Left = 512
    Top = 328
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 500
    Top = 209
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 508
    Top = 246
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_Print'
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
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 319
    Top = 208
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 360
    Top = 8
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'TreeDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 528
  end
  object ContractGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContract
    FormNameParam.Value = 'TContractForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractForm'
    PositionDataSet = 'MasterDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 744
    Top = 8
  end
  object spGetDocumentDataForEmail: TdsdStoredProc
    StoredProcName = 'gpGet_DocumentDataForEmail'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Subject'
        Value = Null
        Component = FormParams
        ComponentItem = 'Subject'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Body'
        Value = Null
        Component = FormParams
        ComponentItem = 'Body'
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AddressFrom'
        Value = Null
        Component = FormParams
        ComponentItem = 'AddressFrom'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AddressTo'
        Value = Null
        Component = FormParams
        ComponentItem = 'AddressTo'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Host'
        Value = Null
        Component = FormParams
        ComponentItem = 'Host'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Port'
        Value = Null
        Component = FormParams
        ComponentItem = 'Port'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName'
        Value = Null
        Component = FormParams
        ComponentItem = 'UserName'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Password'
        Value = Null
        Component = FormParams
        ComponentItem = 'Password'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 8
    Top = 248
  end
  object spSelectExport: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_OrderExternal_Export'
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
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 607
    Top = 192
  end
  object ExportDS: TDataSource
    DataSet = PrintItemsCDS
    Left = 688
    Top = 192
  end
  object spGetExportParam: TdsdStoredProc
    StoredProcName = 'gpGet_OrderExternal_ExportParam'
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
        Name = 'DefaultFileName'
        Value = Null
        Component = actExportToPartner
        ComponentItem = 'DefaultFileName'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ExportType'
        Value = Null
        Component = actExportToPartner
        ComponentItem = 'ExportType'
        MultiSelectSeparator = ','
      end
      item
        Name = 'DefaultFileName'
        Value = Null
        Component = SMTPFileAction
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 608
    Top = 232
  end
  object OrderInternalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edOrderInternal
    FormNameParam.Value = 'TOrderInternalJournalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TOrderInternalJournalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = OrderInternalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = OrderInternalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 296
    Top = 56
  end
  object GuidesOrderKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edOrderKind
    FormNameParam.Value = 'TOrderKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TOrderKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesOrderKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesOrderKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 488
    Top = 16
  end
  object spUpdateMovementUserSend: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_OrderExternal_UserSend'
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
      end>
    PackSize = 1
    Left = 282
    Top = 344
  end
  object spUpdate_isDeferred_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_isDeferred'
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
        Name = 'inisDeferred'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisDeferred'
        Value = Null
        Component = edisDeferred
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 312
    Top = 435
  end
  object spPUSHInfo: TdsdStoredProc
    StoredProcName = 'gpSelect_ShowPUSH_OrderExternal'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inSupplierID'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitID'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outShowMessage'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPUSHType'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outText'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 450
    Top = 432
  end
  object spPUSHError: TdsdStoredProc
    StoredProcName = 'gpSelect_ShowPUSHError_OrderExternal'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inSupplierID'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitID'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outShowMessage'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPUSHType'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outText'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 450
    Top = 488
  end
  object spInsertUpdate_SupplierFailures: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_PriceList_SupplierFailures'
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
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartnerGoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperdate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = ContractGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 176
    Top = 424
  end
  object spGetImportSettingId: TdsdStoredProc
    StoredProcName = 'gpGet_OrderExternal_ImportSettings'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inJuridicalId'
        Value = '0'
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_OrderExternal_ImportSettings'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 856
    Top = 320
  end
  object spUpdate_SetSupplierFailures: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_OrderExternal_SupplierFailures'
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
        Name = 'inisSupplierFailures'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 410
    Top = 360
  end
  object HeaderSaverSupplierFailures: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    StoredProc = spUpdate_isSupplierFailures
    ControlList = <
      item
        Control = cbSupplierFailures
      end>
    GetStoredProc = spGet
    Left = 1008
    Top = 321
  end
  object spUpdate_isSupplierFailures: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_OrderExternal_SupplierFailures'
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
        Name = 'inisSupplierFailures'
        Value = True
        Component = cbSupplierFailures
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1010
    Top = 384
  end
end
