object OrderFinanceMovementSBForm: TOrderFinanceMovementSBForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1077' '#1087#1083#1072#1090#1077#1078#1077#1081'> ('#1057#1095#1077#1090#1072')'
  ClientHeight = 612
  ClientWidth = 1160
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
    Width = 1160
    Height = 196
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object edInvNumber: TcxTextEdit
      Left = 232
      Top = 19
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 85
    end
    object cxLabel1: TcxLabel
      Left = 232
      Top = 2
      Caption = #8470' '#1076#1086#1082'.'
    end
    object edOperDate: TcxDateEdit
      Left = 323
      Top = 19
      EditValue = 42160d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 85
    end
    object cxLabel2: TcxLabel
      Left = 323
      Top = 2
      Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
    end
    object cxLabel11: TcxLabel
      Left = 9
      Top = 2
      Caption = #1057#1090#1072#1090#1091#1089
    end
    object ceStatus: TcxButtonEdit
      Left = 9
      Top = 19
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
      TabOrder = 5
      Width = 214
    end
    object cxLabel16: TcxLabel
      Left = 599
      Top = 82
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object ceComment: TcxTextEdit
      Left = 599
      Top = 99
      TabOrder = 7
      Width = 175
    end
    object cxLabel4: TcxLabel
      Left = 418
      Top = 2
      Caption = #1042#1080#1076' '#1055#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1103
    end
    object edOrderFinance: TcxButtonEdit
      Left = 418
      Top = 19
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 175
    end
    object cxLabel3: TcxLabel
      Left = 780
      Top = 82
      Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090' ('#1086#1087#1083#1072#1090#1072')'
      Visible = False
    end
    object edBankAccount: TcxButtonEdit
      Left = 780
      Top = 99
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Visible = False
      Width = 277
    end
    object edInsertUser: TcxButtonEdit
      Left = 9
      Top = 59
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 12
      Width = 144
    end
    object cxLabel5: TcxLabel
      Left = 9
      Top = 42
      Caption = #1040#1074#1090#1086#1088' '#1079#1072#1103#1074#1082#1080
    end
    object cxLabel7: TcxLabel
      Left = 9
      Top = 82
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object ceUnit: TcxButtonEdit
      Left = 9
      Top = 99
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 15
      Width = 214
    end
    object cxLabel8: TcxLabel
      Left = 232
      Top = 83
      Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
    end
    object cePosition: TcxButtonEdit
      Left = 232
      Top = 99
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 17
      Width = 176
    end
    object cxLabel9: TcxLabel
      Left = 159
      Top = 42
      Caption = #8470' '#1085#1077#1076#1077#1083#1080
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edWeekNumber: TcxCurrencyEdit
      Left = 159
      Top = 59
      ParentFont = False
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      Properties.ReadOnly = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      TabOrder = 19
      Width = 64
    end
    object cxLabel10: TcxLabel
      Left = 599
      Top = 2
      Caption = #1060#1048#1054' - '#1085#1072' '#1082#1086#1085#1090#1088#1086#1083#1077'-1'
    end
    object ceMember_1: TcxButtonEdit
      Left = 599
      Top = 19
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 21
      Width = 170
    end
    object cxLabel13: TcxLabel
      Left = 780
      Top = 42
      Hint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1080')'
      Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
      ParentShowHint = False
      ShowHint = True
      Visible = False
    end
    object edInsertDate: TcxDateEdit
      Left = 418
      Top = 99
      Hint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076#1072#1085#1080#1077' '#1079#1072#1103#1074#1082#1080')'
      EditValue = 42132d
      ParentShowHint = False
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.EditFormat = 'dd.mm.yyyy hh:mm'
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 23
      Width = 175
    end
    object cxLabel14: TcxLabel
      Left = 418
      Top = 82
      Hint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076#1072#1085#1080#1077' '#1079#1072#1103#1074#1082#1080')'
      Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076#1072#1085#1080#1077')'
      ParentShowHint = False
      ShowHint = True
    end
    object edUpdatetDate: TcxDateEdit
      Left = 780
      Top = 59
      Hint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1080')'
      EditValue = 42132d
      ParentShowHint = False
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.EditFormat = 'dd.mm.yyyy hh:mm'
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 25
      Visible = False
      Width = 109
    end
    object edUpdatetDate_report: TcxDateEdit
      Left = 780
      Top = 19
      Hint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1103' '#1076#1072#1085#1085#1099#1093' '#1080#1079' '#1086#1090#1095#1077#1090#1072
      EditValue = 42132d
      ParentShowHint = False
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.EditFormat = 'dd.mm.yyyy hh:mm'
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      Properties.ValidateOnEnter = False
      ShowHint = True
      TabOrder = 26
      Width = 109
    end
    object cxLabel15: TcxLabel
      Left = 780
      Top = 2
      Hint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1103' '#1076#1072#1085#1085#1099#1093' '#1080#1079' '#1086#1090#1095#1077#1090#1072
      Caption = #1044#1072#1090#1072' ('#1086#1090#1095#1077#1090')'
      ParentShowHint = False
      ShowHint = True
    end
    object deStart: TcxDateEdit
      Left = 232
      Top = 59
      EditValue = 45971d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 28
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 323
      Top = 59
      EditValue = 45971d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 29
      Width = 85
    end
    object cxLabel18: TcxLabel
      Left = 232
      Top = 42
      Caption = #1085#1077#1076#1077#1083#1103' '#1089
    end
    object cxLabel19: TcxLabel
      Left = 323
      Top = 42
      Caption = #1085#1077#1076#1077#1083#1103' '#1076#1086
    end
    object edTotalSumm_1: TcxCurrencyEdit
      Left = 811
      Top = 146
      Hint = #1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1072' '#1089#1091#1084#1084#1072' '#1085#1072' '#1085#1077#1076#1077#1083#1102
      ParentFont = False
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = ',0.##'
      Properties.ReadOnly = False
      ShowHint = True
      Style.Color = clWindow
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      TabOrder = 32
      Visible = False
      Width = 135
    end
    object cxLabel23: TcxLabel
      Left = 9
      Top = 173
      Caption = #1055#1086#1080#1089#1082' '#1087#1086' '#1054#1050#1055#1054':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edOKPO_search: TcxTextEdit
      Left = 123
      Top = 174
      TabOrder = 34
      DesignSize = (
        103
        21)
      Width = 103
    end
    object cxLabel24: TcxLabel
      Left = 232
      Top = 173
      Caption = #1070#1088'. '#1083#1080#1094#1086':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edJuridicalName_search: TcxTextEdit
      Left = 310
      Top = 173
      TabOrder = 36
      DesignSize = (
        116
        21)
      Width = 116
    end
    object ceDateSignWait_1: TcxDateEdit
      Left = 9
      Top = 124
      EditValue = 42132d
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.EditFormat = 'dd.mm.yyyy hh:mm'
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      Properties.ValidateOnEnter = False
      TabOrder = 37
      Width = 116
    end
    object cbSignWait_1: TcxCheckBox
      Left = 131
      Top = 124
      Caption = #1044#1072#1090#1072' ('#1057#1090#1072#1088#1090' '#1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1080#1103')'
      Properties.ReadOnly = True
      TabOrder = 38
      Width = 214
    end
    object cbSign_1: TcxCheckBox
      Left = 131
      Top = 146
      Caption = #1044#1072#1090#1072' ('#1047#1072#1103#1074#1082#1072' '#1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1072')'
      Properties.ReadOnly = True
      TabOrder = 39
      Width = 198
    end
    object edTotalText_1: TcxTextEdit
      Left = 811
      Top = 126
      Hint = #1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1072' '#1089#1091#1084#1084#1072' '#1085#1072' '#1085#1077#1076#1077#1083#1102
      TabStop = False
      ParentFont = False
      Style.Color = clBtnFace
      Style.Edges = []
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      TabOrder = 40
      Text = 'edTotalText_1'
      Visible = False
      Width = 134
    end
    object edTotalText_2: TcxTextEdit
      Left = 903
      Top = 126
      Hint = #1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1072' '#1089#1091#1084#1084#1072' '#1085#1072' '#1085#1077#1076#1077#1083#1102
      TabStop = False
      ParentFont = False
      Style.Color = clBtnFace
      Style.Edges = []
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      TabOrder = 41
      Text = 'edTotalText_2'
      Visible = False
      Width = 140
    end
    object edTotalText_3: TcxTextEdit
      Left = 1022
      Top = 126
      Hint = #1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1072' '#1089#1091#1084#1084#1072' '#1085#1072' '#1085#1077#1076#1077#1083#1102
      TabStop = False
      ParentFont = False
      Style.Color = clBtnFace
      Style.Edges = []
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      TabOrder = 42
      Text = 'edTotalText_3'
      Visible = False
      Width = 134
    end
    object cxLabel20: TcxLabel
      Left = 490
      Top = 125
      Caption = '***'#1055#1083#1072#1085' '#1085#1072' '#1085#1077#1076'.:'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edOperDate_Amount: TcxDateEdit
      Left = 490
      Top = 146
      EditValue = 42160d
      ParentFont = False
      Properties.SaveTime = False
      Properties.ShowTime = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      TabOrder = 44
      Width = 103
    end
    object ceDate_SignSB: TcxDateEdit
      Left = 310
      Top = 146
      EditValue = 42132d
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.EditFormat = 'dd.mm.yyyy hh:mm'
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      Properties.ValidateOnEnter = False
      TabOrder = 45
      Width = 116
    end
    object cbSignSB: TcxCheckBox
      Left = 310
      Top = 126
      Caption = #1044#1072#1090#1072' ('#1042#1080#1079#1072' '#1057#1041')'
      ParentFont = False
      Properties.ReadOnly = True
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      TabOrder = 46
      Width = 116
    end
    object cxLabel21: TcxLabel
      Left = 599
      Top = 127
      Caption = #1050#1072#1089#1089#1072' ('#1084#1077#1089#1090#1086' '#1074#1099#1076#1072#1095#1080')'
    end
    object ceCash: TcxButtonEdit
      Left = 600
      Top = 146
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 48
      Width = 169
    end
  end
  object cxPageControl: TcxPageControl
    Left = 0
    Top = 222
    Width = 1160
    Height = 390
    Align = alClient
    TabOrder = 1
    Properties.ActivePage = cxTabSheetMain
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 390
    ClientRectRight = 1160
    ClientRectTop = 24
    object cxTabSheetMain: TcxTabSheet
      Caption = #1057#1090#1088#1086#1095#1085#1072#1103' '#1095#1072#1089#1090#1100
      ImageIndex = 0
      object cxGrid: TcxGrid
        Left = 0
        Top = 0
        Width = 1160
        Height = 184
        Align = alClient
        TabOrder = 0
        object cxGridDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = MasterDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRemains
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPartner
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_1
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_2
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_3
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_4
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_5
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_total
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Amount_old
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_1_old
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_2_old
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_3_old
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_4_old
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_5_old
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_total_old
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountReal_1_old
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountReal_2_old
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountReal_3_old
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountReal_4_old
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountReal_5_old
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountReal_total_old
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Amount_Child
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRemains
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPartner
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = JuridicalName
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_1
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_2
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_3
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_4
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_5
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Amount_old
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_1_old
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_2_old
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_3_old
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_4_old
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_5_old
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_total_old
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountReal_1_old
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountReal_2_old
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountReal_3_old
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountReal_4_old
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountReal_5_old
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountReal_total_old
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_total
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Amount_Child
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
          object OKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object PaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object ContractStateKindCode: TcxGridDBColumn
            Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractStateKindCode'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Alignment.Horz = taLeftJustify
            Properties.Alignment.Vert = taVCenter
            Properties.Images = dmMain.ImageList
            Properties.Items = <
              item
                Description = #1055#1086#1076#1087#1080#1089#1072#1085
                ImageIndex = 12
                Value = 1
              end
              item
                Description = #1053#1077' '#1087#1086#1076#1087#1080#1089#1072#1085
                ImageIndex = 11
                Value = 2
              end
              item
                Description = #1047#1072#1074#1077#1088#1096#1077#1085
                ImageIndex = 13
                Value = 3
              end
              item
                Description = #1059' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
                ImageIndex = 66
                Value = 4
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object ContractCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object ContractName: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actContractChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object PersonalName_contract: TcxGridDBColumn
            Caption = #1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' '#1079#1072' '#1076#1086#1075'. ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            DataBinding.FieldName = 'PersonalName_contract'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' '#1079#1072' '#1076#1086#1075'. ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            Options.Editing = False
            Width = 100
          end
          object StartDate: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088' '#1089
            DataBinding.FieldName = 'StartDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1075#1086#1074#1086#1088' '#1089
            Options.Editing = False
            Width = 78
          end
          object EndDate: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088' '#1076#1086
            DataBinding.FieldName = 'EndDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1075#1086#1074#1086#1088' '#1076#1086
            Options.Editing = False
            Width = 79
          end
          object EndDate_real: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088' '#1076#1086' ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'EndDate_real'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1075#1086#1074#1086#1088' '#1076#1086' ('#1080#1085#1092'.)'
            Options.Editing = False
            Width = 60
          end
          object Condition: TcxGridDBColumn
            Caption = #1059#1089#1083#1086#1074#1080#1077
            DataBinding.FieldName = 'Condition'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1089#1083#1086#1074#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072
            Options.Editing = False
            Width = 100
          end
          object JuridicalCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1102#1088'.'#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actJuridicalChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object ObjectDesc_ItemName: TcxGridDBColumn
            Caption = #1069#1083#1077#1084#1077#1085#1090
            DataBinding.FieldName = 'ObjectDesc_ItemName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object JuridicalName_inf: TcxGridDBColumn
            Caption = #1070#1088'.'#1083#1080#1094#1086' ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'JuridicalName_inf'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object NumGroup: TcxGridDBColumn
            Caption = #8470' '#1059#1055
            DataBinding.FieldName = 'NumGroup'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object CashName: TcxGridDBColumn
            Caption = #1050#1072#1089#1089#1072
            DataBinding.FieldName = 'CashName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actCashChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1072#1089#1089#1072' ('#1084#1077#1089#1090#1086' '#1074#1099#1076#1072#1095#1080')'
            Width = 92
          end
          object AmountRemains: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1076#1086#1083#1075
            DataBinding.FieldName = 'AmountRemains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountPartner: TcxGridDBColumn
            Caption = #1044#1086#1083#1075' '#1089' '#1086#1090#1089#1088#1086#1095#1082#1086#1081
            DataBinding.FieldName = 'AmountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object Sign_Child: TcxGridDBColumn
            Caption = #1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1086' '#1057#1041' ('#1044#1072'/'#1053#1077#1090')'
            DataBinding.FieldName = 'Sign_Child'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object InvNumber_Child: TcxGridDBColumn
            Caption = #8470' '#1079#1072#1103#1074#1082#1080' (1'#1057')'
            DataBinding.FieldName = 'InvNumber_Child'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1079#1072#1103#1074#1082#1080' '#1058#1052#1062' '#1074' 1'#1057
            Width = 80
          end
          object InvNumber_Invoice_Child: TcxGridDBColumn
            Caption = #8470' '#1089#1095#1077#1090#1072
            DataBinding.FieldName = 'InvNumber_Invoice_Child'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object GoodsName_Child: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' ('#1047#1072#1103#1074#1082#1072' '#1058#1052#1062')'
            DataBinding.FieldName = 'GoodsName_Child'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object Amount_Child: TcxGridDBColumn
            Caption = '***'#1055#1083#1072#1085' '#1048#1058#1054#1043#1054' ('#1088#1072#1089#1095#1077#1090')'
            DataBinding.FieldName = 'Amount_Child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object Amount: TcxGridDBColumn
            Caption = '***'#1055#1083#1072#1085' '#1085#1072' '#1085#1077#1076#1077#1083#1102
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1081' '#1055#1083#1072#1085' '#1085#1072' '#1085#1077#1076#1077#1083#1102
            Width = 80
          end
          object Amount_old: TcxGridDBColumn
            Caption = '***'#1055#1083#1072#1085' '#1085#1072' '#1085#1077#1076#1077#1083#1102' ('#1080#1085#1092#1086'.)'
            DataBinding.FieldName = 'Amount_old'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1081' '#1055#1083#1072#1085' '#1085#1072' '#1085#1077#1076#1077#1083#1102' ('#1080#1085#1092#1086#1088#1084#1072#1090#1080#1074#1085#1086')'
            Options.Editing = False
            Width = 70
          end
          object OperDate_Amount: TcxGridDBColumn
            Caption = '***'#1044#1072#1090#1072' '#1087#1083#1072#1085
            DataBinding.FieldName = 'OperDate_Amount'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'DD.MM.YYYY'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1055#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1081' '#1055#1083#1072#1085' '#1085#1072' '#1085#1077#1076#1077#1083#1102
            Width = 70
          end
          object OperDate_Amount_old: TcxGridDBColumn
            Caption = '***'#1044#1072#1090#1072' '#1087#1083#1072#1085' ('#1080#1085#1092#1086'.)'
            DataBinding.FieldName = 'OperDate_Amount_old'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1055#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1081' '#1055#1083#1072#1085' '#1085#1072' '#1085#1077#1076#1077#1083#1102' ('#1080#1085#1092#1086#1088#1084#1072#1090#1080#1074#1085#1086')'
            Options.Editing = False
            Width = 70
          end
          object AmountPlan_total: TcxGridDBColumn
            Caption = #1055#1083#1072#1085' '#1048#1058#1054#1043#1054
            DataBinding.FieldName = 'AmountPlan_total'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085' '#1086#1087#1083#1072#1090' '#1048#1058#1054#1043#1054
            Options.Editing = False
            Width = 80
          end
          object AmountPlan_1: TcxGridDBColumn
            Caption = #1055#1083#1072#1085' 1.'#1087#1085'.'
            DataBinding.FieldName = 'AmountPlan_1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085' '#1086#1087#1083#1072#1090' '#1085#1072' 1.'#1087#1085'.'
            Options.Editing = False
            Width = 70
          end
          object AmountPlan_2: TcxGridDBColumn
            Caption = #1055#1083#1072#1085' 2.'#1074#1090'.'
            DataBinding.FieldName = 'AmountPlan_2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085' '#1086#1087#1083#1072#1090' '#1085#1072' 2.'#1074#1090'.'
            Options.Editing = False
            Width = 70
          end
          object AmountPlan_3: TcxGridDBColumn
            Caption = #1055#1083#1072#1085' 3.'#1089#1088'.'
            DataBinding.FieldName = 'AmountPlan_3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085' '#1086#1087#1083#1072#1090' '#1085#1072' 3.'#1089#1088'.'
            Options.Editing = False
            Width = 70
          end
          object AmountPlan_4: TcxGridDBColumn
            Caption = #1055#1083#1072#1085' 4.'#1095#1090'.'
            DataBinding.FieldName = 'AmountPlan_4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085' '#1086#1087#1083#1072#1090' '#1085#1072' 4.'#1095#1090'.'
            Options.Editing = False
            Width = 70
          end
          object AmountPlan_5: TcxGridDBColumn
            Caption = #1055#1083#1072#1085' 5.'#1087#1090'.'
            DataBinding.FieldName = 'AmountPlan_5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085' '#1086#1087#1083#1072#1090' '#1085#1072' 5.'#1087#1090'.'
            Options.Editing = False
            Width = 70
          end
          object isAmountPlan_1: TcxGridDBColumn
            Caption = #1055#1083#1072#1090#1080#1084' ('#1076#1072'/'#1085#1077#1090') 1.'#1087#1085'.'
            DataBinding.FieldName = 'isAmountPlan_1'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1090#1080#1084' ('#1076#1072'/'#1085#1077#1090') 1.'#1087#1085'.'
            Options.Editing = False
            Width = 70
          end
          object isAmountPlan_2: TcxGridDBColumn
            Caption = #1055#1083#1072#1090#1080#1084' ('#1076#1072'/'#1085#1077#1090') 2.'#1074#1090'.'
            DataBinding.FieldName = 'isAmountPlan_2'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1090#1080#1084' ('#1076#1072'/'#1085#1077#1090') 2.'#1074#1090'.'
            Options.Editing = False
            Width = 70
          end
          object isAmountPlan_3: TcxGridDBColumn
            Caption = #1055#1083#1072#1090#1080#1084' ('#1076#1072'/'#1085#1077#1090') 3.'#1089#1088'.'
            DataBinding.FieldName = 'isAmountPlan_3'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1090#1080#1084' ('#1076#1072'/'#1085#1077#1090') 3.'#1089#1088'.'
            Options.Editing = False
            Width = 70
          end
          object isAmountPlan_4: TcxGridDBColumn
            Caption = #1055#1083#1072#1090#1080#1084' ('#1076#1072'/'#1085#1077#1090') 4.'#1095#1090'.'
            DataBinding.FieldName = 'isAmountPlan_4'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1090#1080#1084' ('#1076#1072'/'#1085#1077#1090') 4.'#1095#1090'.'
            Options.Editing = False
            Width = 70
          end
          object isAmountPlan_5: TcxGridDBColumn
            Caption = #1055#1083#1072#1090#1080#1084' ('#1076#1072'/'#1085#1077#1090') 5.'#1087#1090'.'
            DataBinding.FieldName = 'isAmountPlan_5'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1090#1080#1084' ('#1076#1072'/'#1085#1077#1090') 5.'#1087#1090'.'
            Options.Editing = False
            Width = 70
          end
          object AmountPlan_total_old: TcxGridDBColumn
            Caption = '*'#1055#1083#1072#1085' *'#1048#1058#1054#1043#1054
            DataBinding.FieldName = 'AmountPlan_total_old'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085' '#1087#1088#1086#1096#1083#1086#1081' '#1085#1077#1076#1077#1083#1080' *'#1048#1058#1054#1043#1054
            Options.Editing = False
            Width = 70
          end
          object AmountPlan_1_old: TcxGridDBColumn
            Caption = '*'#1055#1083#1072#1085' *1.'#1087#1085'.'
            DataBinding.FieldName = 'AmountPlan_1_old'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085' '#1087#1088#1086#1096#1083#1086#1081' '#1085#1077#1076#1077#1083#1080' '#1085#1072' *1.'#1087#1085'.'
            Options.Editing = False
            Width = 70
          end
          object AmountPlan_2_old: TcxGridDBColumn
            Caption = '*'#1055#1083#1072#1085' *2.'#1074#1090'.'
            DataBinding.FieldName = 'AmountPlan_2_old'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085' '#1087#1088#1086#1096#1083#1086#1081' '#1085#1077#1076#1077#1083#1080' '#1085#1072' *2.'#1074#1090'.'
            Options.Editing = False
            Width = 70
          end
          object AmountPlan_3_old: TcxGridDBColumn
            Caption = '*'#1055#1083#1072#1085' *3.'#1089#1088'.'
            DataBinding.FieldName = 'AmountPlan_3_old'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085' '#1087#1088#1086#1096#1083#1086#1081' '#1085#1077#1076#1077#1083#1080' '#1085#1072' *3.'#1089#1088'.'
            Options.Editing = False
            Width = 70
          end
          object AmountPlan_4_old: TcxGridDBColumn
            Caption = '*'#1055#1083#1072#1085' *4.'#1095#1090'.'
            DataBinding.FieldName = 'AmountPlan_4_old'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085' '#1087#1088#1086#1096#1083#1086#1081' '#1085#1077#1076#1077#1083#1080' '#1085#1072' *4.'#1095#1090'.'
            Options.Editing = False
            Width = 70
          end
          object AmountPlan_5_old: TcxGridDBColumn
            Caption = '*'#1055#1083#1072#1085' *5.'#1087#1090'.'
            DataBinding.FieldName = 'AmountPlan_5_old'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085' '#1087#1088#1086#1096#1083#1086#1081' '#1085#1077#1076#1077#1083#1080' '#1085#1072' *5.'#1087#1090'.'
            Options.Editing = False
            Width = 70
          end
          object AmountReal_total_old: TcxGridDBColumn
            Caption = '*'#1060#1072#1082#1090' *'#1048#1058#1054#1043#1054
            DataBinding.FieldName = 'AmountReal_total_old'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1072#1082#1090' '#1086#1087#1083#1072#1090' '#1087#1088#1086#1096#1083#1086#1081' '#1085#1077#1076#1077#1083#1080' *'#1048#1058#1054#1043#1054
            Options.Editing = False
            Width = 70
          end
          object AmountReal_1_old: TcxGridDBColumn
            Caption = '*'#1060#1072#1082#1090' *1.'#1087#1085'.'
            DataBinding.FieldName = 'AmountReal_1_old'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1072#1082#1090' '#1086#1087#1083#1072#1090' '#1087#1088#1086#1096#1083#1086#1081' '#1085#1077#1076#1077#1083#1080' '#1085#1072' 1.'#1087#1085'.'
            Options.Editing = False
            Width = 70
          end
          object AmountReal_2_old: TcxGridDBColumn
            Caption = '*'#1060#1072#1082#1090' *2.'#1074#1090'.'
            DataBinding.FieldName = 'AmountReal_2_old'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1072#1082#1090' '#1086#1087#1083#1072#1090' '#1087#1088#1086#1096#1083#1086#1081' '#1085#1077#1076#1077#1083#1080' '#1085#1072' 2.'#1074#1090'.'
            Options.Editing = False
            Width = 70
          end
          object AmountReal_3_old: TcxGridDBColumn
            Caption = '*'#1060#1072#1082#1090' *3.'#1089#1088'.'
            DataBinding.FieldName = 'AmountReal_3_old'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1072#1082#1090' '#1086#1087#1083#1072#1090' '#1087#1088#1086#1096#1083#1086#1081' '#1085#1077#1076#1077#1083#1080' '#1085#1072' *3.'#1089#1088'.'
            Options.Editing = False
            Width = 70
          end
          object AmountReal_4_old: TcxGridDBColumn
            Caption = '*'#1060#1072#1082#1090' *4.'#1095#1090'.'
            DataBinding.FieldName = 'AmountReal_4_old'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1072#1082#1090' '#1086#1087#1083#1072#1090' '#1087#1088#1086#1096#1083#1086#1081' '#1085#1077#1076#1077#1083#1080' '#1085#1072' *4.'#1095#1090'.'
            Options.Editing = False
            Width = 70
          end
          object AmountReal_5_old: TcxGridDBColumn
            Caption = '*'#1060#1072#1082#1090' *5.'#1087#1090'.'
            DataBinding.FieldName = 'AmountReal_5_old'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1072#1082#1090' '#1086#1087#1083#1072#1090' '#1087#1088#1086#1096#1083#1086#1081' '#1085#1077#1076#1077#1083#1080' '#1085#1072' *5.'#1087#1090'.'
            Options.Editing = False
            Width = 70
          end
          object Comment_pay: TcxGridDBColumn
            Caption = #1053#1072#1079#1085#1072#1095#1077#1085#1080#1077' '#1087#1083#1072#1090#1077#1078#1072
            DataBinding.FieldName = 'Comment_pay'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 200
          end
          object InsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object InsertName: TcxGridDBColumn
            Caption = #1040#1074#1090#1086#1088' ('#1079#1072#1103#1074#1082#1080')'
            DataBinding.FieldName = 'InsertName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object UpdateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' / '#1074#1088#1077#1084#1103' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object UpdateName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object ColorFon_record: TcxGridDBColumn
            DataBinding.FieldName = 'ColorFon_record'
            Visible = False
            VisibleForCustomization = False
            Width = 80
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
      object ExportXmlGrid: TcxGrid
        Left = 0
        Top = 331
        Width = 1160
        Height = 35
        Align = alBottom
        Anchors = [akTop, akRight, akBottom]
        TabOrder = 1
        Visible = False
        object ExportXmlGridDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ExportDS
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsBehavior.IncSearch = True
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.CellAutoHeight = True
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          OptionsView.Header = False
          object RowData: TcxGridDBColumn
            DataBinding.FieldName = 'RowData'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
        end
        object ExportXmlGridLevel: TcxGridLevel
          GridView = ExportXmlGridDBTableView
        end
      end
      object cxGridChild: TcxGrid
        Left = 0
        Top = 192
        Width = 1160
        Height = 139
        Align = alBottom
        TabOrder = 2
        LookAndFeel.Kind = lfStandard
        LookAndFeel.NativeStyle = False
        LookAndFeel.SkinName = ''
        object cxGridDBTableViewChild: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Filter.Active = True
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_ch2
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_ch2
            end
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName_ch2
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.IncSearch = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderHeight = 40
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object InvNumber_ch2: TcxGridDBColumn
            Caption = #8470' '#1079#1072#1103#1074#1082#1080' (1'#1057')'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object InvNumber_Invoice_Child_ch2: TcxGridDBColumn
            Caption = #8470' '#1089#1095#1077#1090#1072
            DataBinding.FieldName = 'InvNumber_Invoice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 142
          end
          object GoodsName_ch2: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' ('#1047#1072#1103#1074#1082#1072' '#1058#1052#1062')'
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 271
          end
          object Amount_ch2: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 103
          end
          object Comment_ch2: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 218
          end
          object Comment_SB: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1057#1041')'
            DataBinding.FieldName = 'Comment_SB'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object IsErased_ch2: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            Options.Editing = False
            Width = 60
          end
          object isSign_ch2: TcxGridDBColumn
            Caption = #1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1086' '#1057#1041' ('#1044#1072'/'#1053#1077#1090')'
            DataBinding.FieldName = 'isSign'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 112
          end
        end
        object cxGridLevel2: TcxGridLevel
          GridView = cxGridDBTableViewChild
        end
      end
      object cxSplitter_Bottom: TcxSplitter
        Left = 0
        Top = 184
        Width = 1160
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = cxGridChild
      end
    end
    object cxTabSheet1: TcxTabSheet
      Caption = #1089#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1070#1088'.'#1083#1080#1094#1072
      ImageIndex = 1
      object cxGrid1: TcxGrid
        Left = 0
        Top = 0
        Width = 1160
        Height = 366
        Align = alClient
        TabOrder = 0
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = JuridicalDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Sorted = True
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
              Column = chSummOrderFinance
            end>
          DataController.Summary.FooterSummaryItems = <
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
              Column = chSummOrderFinance
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = chJuridicalName
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Appending = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object chJuridicalCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1102#1088'.'#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object chJuridicalName: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actContractChoiceForm_JurOrdFin
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object chOKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chINN: TcxGridDBColumn
            Caption = #1048#1053#1053
            DataBinding.FieldName = 'INN'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chBankName_main: TcxGridDBColumn
            Caption = #1041#1072#1085#1082' ('#1055#1083#1072#1090#1077#1083#1100#1097#1080#1082')'
            DataBinding.FieldName = 'BankName_main'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actBankChoiceForm_JurMain
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object chBankAccountName_main: TcxGridDBColumn
            Caption = #1056'/'#1057#1095#1077#1090' ('#1055#1083#1072#1090#1077#1083#1100#1097#1080#1082')'
            DataBinding.FieldName = 'BankAccountName_main'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actBankAccountChoiceFormJurMain
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1088'/'#1089#1095#1077#1090', '#1089' '#1082#1086#1090#1086#1088#1086#1075#1086' '#1087#1088#1086#1080#1089#1093#1086#1076#1080#1090' '#1086#1087#1083#1072#1090#1072
            Width = 100
          end
          object chBankName: TcxGridDBColumn
            Caption = #1041#1072#1085#1082' ('#1055#1086#1083#1091#1095#1072#1090#1077#1083#1100')'
            DataBinding.FieldName = 'BankName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actBankChoiceForm_Jur
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 95
          end
          object chBankAccountName: TcxGridDBColumn
            Caption = #1056'/'#1089#1095#1077#1090' ('#1055#1086#1083#1091#1095#1072#1090#1077#1083#1100')'
            DataBinding.FieldName = 'BankAccountName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actBankAccountChoiceFormJur
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 107
          end
          object chRetailName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object chNumGroup: TcxGridDBColumn
            Caption = #8470' '#1059#1055
            DataBinding.FieldName = 'NumGroup'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object chInfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object chInfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chInfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chInfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object chInfoMoneyName_all: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103
            DataBinding.FieldName = 'InfoMoneyName_all'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object chPaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099' '#1076#1086#1075'.'
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object chContractStateKindCode_Send: TcxGridDBColumn
            Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractStateKindCode'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Alignment.Horz = taLeftJustify
            Properties.Alignment.Vert = taVCenter
            Properties.Images = dmMain.ImageList
            Properties.Items = <
              item
                Description = #1055#1086#1076#1087#1080#1089#1072#1085
                ImageIndex = 12
                Value = 1
              end
              item
                Description = #1053#1077' '#1087#1086#1076#1087#1080#1089#1072#1085
                ImageIndex = 11
                Value = 2
              end
              item
                Description = #1047#1072#1074#1077#1088#1096#1077#1085
                ImageIndex = 13
                Value = 3
              end
              item
                Description = #1059' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
                ImageIndex = 66
                Value = 4
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object chContractCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object chContractName: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088
            DataBinding.FieldName = 'ContractName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actContractChoiceForm_JurOrdFin
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object chSummOrderFinance: TcxGridDBColumn
            Caption = #1051#1080#1084#1080#1090' '#1087#1086' '#1089#1091#1084#1084#1077' '#1086#1090#1089#1088#1086#1095#1082#1080
            DataBinding.FieldName = 'SummOrderFinance'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 135
          end
          object chComment_pay: TcxGridDBColumn
            Caption = #1053#1072#1079#1085#1072#1095#1077#1085#1080#1077' '#1087#1083#1072#1090#1077#1078#1072
            DataBinding.FieldName = 'Comment_pay'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 200
          end
          object chIsCorporate: TcxGridDBColumn
            Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088'.'#1083'.'
            DataBinding.FieldName = 'isCorporate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object chisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
    end
  end
  object cxLabel6: TcxLabel
    Left = 898
    Top = 42
    Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
    Visible = False
  end
  object edUpdateUser: TcxButtonEdit
    Left = 898
    Top = 59
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Visible = False
    Width = 159
  end
  object ceMember_2: TcxButtonEdit
    Left = 599
    Top = 59
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 170
  end
  object cxLabel12: TcxLabel
    Left = 600
    Top = 42
    Caption = #1060#1048#1054' - '#1085#1072' '#1082#1086#1085#1090#1088#1086#1083#1077'-2'
  end
  object edUserUpdate_report: TcxButtonEdit
    Left = 898
    Top = 19
    Hint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1103' '#1076#1072#1085#1085#1099#1093' '#1080#1079' '#1086#1090#1095#1077#1090#1072
    ParentShowHint = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 7
    Width = 159
  end
  object cxLabel17: TcxLabel
    Left = 898
    Top = 2
    Hint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1103' '#1076#1072#1085#1085#1099#1093' '#1080#1079' '#1086#1090#1095#1077#1090#1072
    Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1086#1090#1095#1077#1090')'
    ParentShowHint = False
    ShowHint = True
  end
  object edTotalSumm_2: TcxCurrencyEdit
    Left = 903
    Top = 146
    Hint = #1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1072' '#1089#1091#1084#1084#1072' '#1085#1072' '#1085#1077#1076#1077#1083#1102
    ParentFont = False
    ParentShowHint = False
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.##'
    Properties.ReadOnly = False
    ShowHint = True
    Style.Color = clWindow
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlue
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
    TabOrder = 8
    Visible = False
    Width = 135
  end
  object edTotalSumm_3: TcxCurrencyEdit
    Left = 1022
    Top = 146
    Hint = #1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1072' '#1089#1091#1084#1084#1072' '#1085#1072' '#1085#1077#1076#1077#1083#1102
    ParentFont = False
    ParentShowHint = False
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.##'
    Properties.ReadOnly = False
    ShowHint = True
    Style.Color = clWindow
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlue
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
    TabOrder = 9
    Visible = False
    Width = 135
  end
  object ceDateSign_1: TcxDateEdit
    Left = 9
    Top = 146
    EditValue = 42132d
    Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
    Properties.EditFormat = 'dd.mm.yyyy hh:mm'
    Properties.Kind = ckDateTime
    Properties.ReadOnly = True
    Properties.ValidateOnEnter = False
    TabOrder = 14
    Width = 116
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
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameOrderFinance'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 238
    Top = 343
  end
  object spSelectMI: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_OrderFinanceSB'
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
        Value = Null
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
      end>
    PackSize = 1
    Left = 264
    Top = 311
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
    Left = 62
    Top = 183
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
          Visible = True
          ItemName = 'bbShowErasedJur'
        end
        item
          Visible = True
          ItemName = 'bbShowAllJur'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecord'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbInfoMoney_InsertRecord'
        end
        item
          Visible = True
          ItemName = 'bbInfoMoney_UpdeteRecord'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecord_Partner'
        end
        item
          Visible = True
          ItemName = 'bbPartner_UpdeteRecord'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErased'
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
          ItemName = 'bbInsertRecordChild'
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
          ItemName = 'bbInsertRecord_JurOrdFin'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedJurOrdFin'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErasedJurOrdFin'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsert_byMovBankAccount'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Sign_1_Yes'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbSign'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbOut'
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
          ItemName = 'bbMovementItemProtocol'
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpenFormJOF'
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
    object bbStatic: TdxBarStatic
      Category = 0
      Visible = ivAlways
      ShowCaption = False
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
    object bbErased: TdxBarButton
      Action = SetErased
      Category = 0
    end
    object bbSetUnErased: TdxBarButton
      Action = SetUnErased
      Category = 0
    end
    object bbMIContainer: TdxBarButton
      Action = actMIContainer
      Category = 0
    end
    object bbMovementItemProtocol: TdxBarButton
      Action = MovementItemProtocolOpenForm
      Category = 0
    end
    object bbCalcAmountPartner: TdxBarControlContainerItem
      Caption = #1040#1074#1090#1086' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1077'  <'#1050#1086#1083'-'#1074#1086' '#1091' '#1087#1086#1089#1090'.>'
      Category = 0
      Hint = #1040#1074#1090#1086' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1077'  <'#1050#1086#1083'-'#1074#1086' '#1091' '#1087#1086#1089#1090'.>'
      Visible = ivAlways
    end
    object bbAddMask: TdxBarButton
      Action = actAddMask
      Category = 0
    end
    object bbInsertRecord: TdxBarButton
      Action = actInsertRecord
      Category = 0
    end
    object bbCompleteCost: TdxBarButton
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1090#1088#1072#1090#1099
      Category = 0
      Enabled = False
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1090#1088#1072#1090#1099
      Visible = ivNever
      ImageIndex = 12
    end
    object bbactUnCompleteCost: TdxBarButton
      Caption = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1090#1088#1072#1090#1099
      Category = 0
      Enabled = False
      Hint = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1090#1088#1072#1090#1099
      Visible = ivNever
      ImageIndex = 11
    end
    object bbactSetErasedCost: TdxBarButton
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1090#1088#1072#1090#1099
      Category = 0
      Enabled = False
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1090#1088#1072#1090#1099
      Visible = ivNever
      ImageIndex = 13
    end
    object bbShowErasedCost: TdxBarButton
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Category = 0
      Enabled = False
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Visible = ivAlways
      ImageIndex = 64
    end
    object bbUpdate_AmountByReport: TdxBarButton
      Action = actUpdate_AmountByReport
      Category = 0
    end
    object bbShowAllJur: TdxBarButton
      Action = actShowAllJur
      Category = 0
    end
    object bbShowErasedJur: TdxBarButton
      Action = actShowErasedJur
      Category = 0
    end
    object bbSetErasedJurOrdFin: TdxBarButton
      Action = actSetErasedJurOrdFin
      Category = 0
    end
    object bbSetUnErasedJurOrdFin: TdxBarButton
      Action = actSetUnErasedJurOrdFin
      Category = 0
    end
    object bbInsertRecord_JurOrdFin: TdxBarButton
      Action = InsertRecord_JurOrdFin
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1101#1083#1077#1084#1077#1085#1090' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Category = 0
    end
    object bbProtocolOpenFormJOF: TdxBarButton
      Action = ProtocolOpenFormJOF
      Category = 0
    end
    object bbInsert_byMovBankAccount: TdxBarButton
      Action = macInsert_byMovBankAccount
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = mactExport_xls
      Category = 0
    end
    object bbOut: TdxBarSubItem
      Caption = #1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbtExport_fr3'
        end
        item
          Visible = True
          ItemName = 'bbmactExport_group'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator'
        end
        item
          Visible = True
          ItemName = 'bbExport_msg'
        end>
    end
    object dxBarSeparator: TdxBarSeparator
      Caption = 'dxBarSeparator'
      Category = 0
      Hint = 'dxBarSeparator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbUpdate_Sign_1_Yes: TdxBarButton
      Action = mactSign_1_Yes
      Category = 0
    end
    object bbUpdate_Sign_1_No: TdxBarButton
      Action = actUpdate_Sign_1_No
      Category = 0
    end
    object bbSign: TdxBarSubItem
      Caption = #1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1080#1077
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbUpdate_SignWait_1_Yes'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_SignWait_1_No'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Sign_1_No'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_SignSB_Yes'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_SignSB_No'
        end>
    end
    object bbUpdate_SignWait_1_Yes: TdxBarButton
      Action = actUpdate_SignWait_1_Yes
      Category = 0
    end
    object bbUpdate_SignWait_1_No: TdxBarButton
      Action = actUpdate_SignWait_1_No
      Category = 0
    end
    object dxBarSeparator1: TdxBarSeparator
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
    object bbmactExport_group: TdxBarButton
      Action = mactExportGroup_fr3
      Category = 0
    end
    object bbtExport_fr3: TdxBarButton
      Action = mactExport_fr3
      Category = 0
    end
    object bbPrint_xls: TdxBarButton
      Action = actPrint_xls
      Category = 0
    end
    object bbsPrint: TdxBarSubItem
      Caption = #1055#1077#1095#1072#1090#1100
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'bbPrint_xls'
        end>
    end
    object bbmactLoadExcel: TdxBarButton
      Action = mactLoadExcel
      Category = 0
    end
    object bbInsertRecordChild: TdxBarButton
      Action = actInsertRecordChild
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
    object bbUpdate_SignSB_Yes: TdxBarButton
      Action = actUpdate_SignSB_Yes
      Category = 0
    end
    object bbUpdate_SignSB_No: TdxBarButton
      Action = actUpdate_SignSB_No
      Category = 0
    end
    object bbExport_msg: TdxBarButton
      Action = mactExport_msg
      Category = 0
    end
    object bbInfoMoney_InsertRecord: TdxBarButton
      Action = actInsertRecord_Infomoney
      Category = 0
    end
    object bbInfoMoney_UpdeteRecord: TdxBarButton
      Action = actInfoMoney_OrderFinanceChoiceForm
      Category = 0
    end
    object bbInsertRecord_Partner: TdxBarButton
      Action = actInsertRecord_Partner
      Category = 0
    end
    object bbPartner_UpdeteRecord: TdxBarButton
      Action = actPartnerChoiceForm
      Category = 0
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
    Left = 121
    Top = 280
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 99
    Top = 191
    object actExport_Grid_groupCSV: TExportGrid
      Category = 'Export_mail_group'
      MoveParams = <>
      ExportType = cxegExportToText
      Grid = ExportXmlGrid
      Caption = 'actExport_Grid_groupCSV'
      OpenAfterCreate = False
      DefaultFileName = 'Report_'
      Separator = ';'
      DefaultFileExt = 'XLS'
    end
    object actExport_Grid_xls1: TExportGrid
      Category = 'Export_mail_ok'
      MoveParams = <>
      Grid = ExportXmlGrid
      Caption = 'actExport_Grid_xls1'
      OpenAfterCreate = False
      DefaultFileName = 'Report_'
      Separator = ';'
      DefaultFileExt = 'XLS'
    end
    object actGet_Export_EmailGroup: TdsdExecStoredProc
      Category = 'Export_Email_fr3'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_EmailGroup
      StoredProcList = <
        item
          StoredProc = spGet_Export_EmailGroup
        end>
      Caption = 'actGet_Export_Email'
    end
    object actGet_Export_Email_gr: TdsdExecStoredProc
      Category = 'Export_mail_group'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_Email_gr
      StoredProcList = <
        item
          StoredProc = spGet_Export_Email_gr
        end>
      Caption = 'actGet_Export_Email_xls'
    end
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
    object actSelect_Export_gr: TdsdExecStoredProc
      Category = 'Export_mail_group'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelectOrderFinance_XLS
      StoredProcList = <
        item
          StoredProc = spSelectOrderFinance_XLS
        end>
      Caption = 'actSelect_Export_xls'
    end
    object actShowErasedJur: TBooleanStoredProcAction
      Category = 'DSDLib'
      TabSheet = cxTabSheet1
      MoveParams = <>
      Enabled = False
      StoredProc = spSelectJuridicalOrderFinance
      StoredProcList = <
        item
          StoredProc = spSelectJuridicalOrderFinance
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
    object actUpdateChildDS: TdsdUpdateDataSet
      Category = 'Child'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIChild
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIChild
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = 'actUpdateChildDS'
      DataSource = ChildDS
    end
    object actUpdateJuridicalDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Juridical_OrderFinance
      StoredProcList = <
        item
          StoredProc = spUpdate_Juridical_OrderFinance
        end>
      Caption = 'actUpdateJuridicalDS'
      DataSource = JuridicalDS
    end
    object mactExportGroup_fr3: TMultiAction
      Category = 'Export_Email_fr3'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Export_EmailGroup
        end
        item
          Action = actGet_Export_FileName_xls
        end
        item
          Action = actSPPrintOrderFinanceProcName
        end
        item
          Action = actExport_fr3
        end
        item
          Action = actSMTPFile
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1087#1086#1095#1090#1077'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1091#1089#1087#1077#1096#1085#1086' '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1099' '#1087#1086' '#1087#1086#1095#1090#1077
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1055#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1081' '#1087#1083#1072#1085' '#1087#1086' '#1087#1086#1095#1090#1077' '#1075#1088#1091#1087#1087#1077
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1055#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1081' '#1087#1083#1072#1085' '#1087#1086' '#1087#1086#1095#1090#1077' '#1075#1088#1091#1087#1087#1077
      ImageIndex = 53
    end
    object actPrint_xls: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' (xls)'
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'NumGroup;NumGroupRes;InfoMoneyName;JuridicalName'
        end>
      Params = <
        item
          Name = 'InvNumber'
          Value = ''
          Component = edInvNumber
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'From'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 42160d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_OrderFinance_xls'
      ReportNameParam.Value = 'PrintMovement_OrderFinance_xls'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actInsertRecord_Partner: TInsertRecord
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Action = actPartnerChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1050#1086#1085#1090#1072#1075#1077#1085#1090#1072'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1050#1086#1085#1090#1072#1075#1077#1085#1090#1072'>'
      ImageIndex = 0
    end
    object actGetImportSetting: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSetting
      StoredProcList = <
        item
          StoredProc = spGetImportSetting
        end>
      Caption = 'actGetImportSetting'
    end
    object actPartnerChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1050#1086#1085#1090#1072#1075#1077#1085#1090#1072'>'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072'>'
      ImageIndex = 1
      FormName = 'TContractChoicePartnerForm'
      FormNameParam.Value = 'TContractChoicePartnerForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractCode'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName_inf'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object SetErasedChild: TdsdUpdateErased
      Category = 'Child'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spErasedMIchild
      StoredProcList = <
        item
          StoredProc = spErasedMIchild
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1058#1086#1074#1072#1088' ('#1047#1072#1103#1074#1082#1072' '#1058#1052#1062')>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1058#1086#1074#1072#1088' ('#1047#1072#1103#1074#1082#1072' '#1058#1052#1062')>'
      ImageIndex = 2
      ShortCut = 49217
      ErasedFieldName = 'isErased'
      DataSource = ChildDS
    end
    object SetUnErasedChild: TdsdUpdateErased
      Category = 'Child'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spUnErasedMIchild
      StoredProcList = <
        item
          StoredProc = spUnErasedMIchild
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 49217
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = ChildDS
    end
    object actShowErased: TBooleanStoredProcAction
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spSelectMI
      StoredProcList = <
        item
          StoredProc = spSelectMI
        end
        item
          StoredProc = spSelectMIChild
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
    object mactExport_group: TMultiAction
      Category = 'Export_mail_group'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Export_Email_gr
        end
        item
          Action = actGet_Export_FileName_gr
        end
        item
          Action = actSelect_Export_gr
        end
        item
          Action = actExport_Grid_groupCSV
        end
        item
          Action = actSMTPFile_xls
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1087#1086#1095#1090#1077'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1091#1089#1087#1077#1096#1085#1086' '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1099' '#1087#1086' '#1087#1086#1095#1090#1077
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1055#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1081' '#1087#1083#1072#1085' '#1087#1086' '#1087#1086#1095#1090#1077
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1055#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1081' '#1087#1083#1072#1085' '#1087#1086' '#1087#1086#1095#1090#1077' (XLS)'
      ImageIndex = 53
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
    object actExport_New: TMultiAction
      Category = 'Export_file'
      MoveParams = <>
      Enabled = False
      ActionList = <
        item
          Action = actGet_Export_FileName
        end
        item
          Action = actExport_file
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1074#1099#1075#1088#1091#1079#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090'?'
      InfoAfterExecute = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1091#1089#1087#1077#1096#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085
      Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1087#1083#1072#1085' '#1086#1087#1083#1072#1090
      Hint = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1074' '#1092#1072#1081#1083
      ImageIndex = 53
    end
    object actRefreshGet: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshOFJ: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectJuridicalOrderFinance
      StoredProcList = <
        item
          StoredProc = spSelectJuridicalOrderFinance
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actCashChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Cash_BranchChoiceForm'
      FormName = 'TCash_BranchForm'
      FormNameParam.Value = 'TCash_BranchForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'CashId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'CashName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object ProtocolOpenFormJOF: TdsdOpenForm
      Category = #1055#1088#1086#1090#1086#1082#1086#1083
      TabSheet = cxTabSheet1
      MoveParams = <>
      Enabled = False
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = JuridicalCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = JuridicalCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
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
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelectMIChild
        end>
      Caption = 'actUpdateMasterDS'
      DataSource = MasterDS
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
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelectMI
        end
        item
          StoredProc = spSelectJuridicalOrderFinance
        end
        item
          StoredProc = spSelectMIChild
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actInsertRecord_Infomoney: TInsertRecord
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Action = actInfoMoney_OrderFinanceChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1059#1055' '#1089#1090#1072#1090#1100#1102'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1059#1055' '#1089#1090#1072#1090#1100#1102'>'
      ImageIndex = 0
    end
    object actInfoMoney_OrderFinanceChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1059#1055' '#1089#1090#1072#1090#1100#1102'>'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1059#1055' '#1089#1090#1072#1090#1100#1102'>'
      ImageIndex = 1
      FormName = 'TInfoMoney_OrderFinanceForm'
      FormNameParam.Value = 'TInfoMoney_OrderFinanceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalCode'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
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
          IndexFieldNames = 'NumGroup;NumGroupRes;InfoMoneyName;JuridicalName'
        end>
      Params = <
        item
          Name = 'InvNumber'
          Value = ''
          Component = edInvNumber
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'From'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 0d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_OrderFinance'
      ReportNameParam.Value = 'PrintMovement_OrderFinance'
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
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1070#1088'. '#1083#1080#1094#1086'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1070#1088'. '#1083#1080#1094#1086'>'
      ImageIndex = 2
      ShortCut = 49220
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
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 49220
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
    object actInsertRecordChild: TInsertRecord
      Category = 'Child'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewChild
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088' ('#1047#1072#1103#1074#1082#1072' '#1058#1052#1062')>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088' ('#1047#1072#1103#1074#1082#1072' '#1058#1052#1062')>'
      ImageIndex = 0
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
    object actUpdate_SignSB_No: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      Enabled = False
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_SignSB_No
      StoredProcList = <
        item
          StoredProc = spUpdate_SignSB_No
        end
        item
          StoredProc = spGet
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' <'#1042#1080#1079#1072' '#1057#1041'>'
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' <'#1042#1080#1079#1072' '#1057#1041'>'
    end
    object actUpdate_SignSB_Yes: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      Enabled = False
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_SignSB_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_SignSB_Yes
        end
        item
          StoredProc = spGet
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1042#1080#1079#1072' '#1057#1041'>'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1042#1080#1079#1072' '#1057#1041'>'
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
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actBankAccountChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ContractChoiceForm'
      FormName = 'TBankAccount_ObjectForm'
      FormNameParam.Value = 'TBankAccount_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankAccountId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankAccountName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BankName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actBankAccountChoiceFormJurMain: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'BankAccount_ObjectChoiceForm'
      FormName = 'TBankAccount_ObjectForm'
      FormNameParam.Value = 'TBankAccount_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = JuridicalCDS
          ComponentItem = 'BankAccountId_main'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = JuridicalCDS
          ComponentItem = 'BankAccountName_main'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BankName'
          Value = Null
          Component = JuridicalCDS
          ComponentItem = 'BankName_main'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actContractChoiceForm_JurOrdFin: TOpenChoiceForm
      Category = 'JuridicalOrderFinance'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ContractChoiceForm'
      FormName = 'TContractChoiceForm'
      FormNameParam.Value = 'TContractChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'JuridicalId'
          Value = Null
          Component = JuridicalCDS
          ComponentItem = 'JuridicalId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = JuridicalCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyId'
          Value = Null
          Component = JuridicalCDS
          ComponentItem = 'InfoMoneyId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyCode'
          Value = Null
          Component = JuridicalCDS
          ComponentItem = 'InfoMoneyCode'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = JuridicalCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Key'
          Value = Null
          Component = JuridicalCDS
          ComponentItem = 'ContractId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = JuridicalCDS
          ComponentItem = 'ContractName'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actBankAccountChoiceFormJur: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'BankAccount_ObjectChoiceForm'
      FormName = 'TBankAccount_ChoiceForm'
      FormNameParam.Value = 'TBankAccount_ChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = JuridicalCDS
          ComponentItem = 'BankAccountId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = JuridicalCDS
          ComponentItem = 'BankAccountName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BankName'
          Value = Null
          Component = JuridicalCDS
          ComponentItem = 'BankName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MFO'
          Value = Null
          DataType = ftString
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actContractChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ContractChoiceForm'
      FormName = 'TContractChoiceForm'
      FormNameParam.Value = 'TContractChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractCode'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StartDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'EndDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyCode'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyCode'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalName_contract'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actJuridicalChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'JuridicalChoiceForm'
      FormName = 'TContractJuridicalChoiceForm'
      FormNameParam.Value = 'TContractJuridicalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'JuridicalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractCode'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyCode'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyCode'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalName_contract'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StartDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'EndDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'EndDate'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPaidKindId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PaidKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'OKPO'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OKPO'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Condition'
          Value = ' '
          Component = MasterCDS
          ComponentItem = 'Condition'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PaidKindId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actAddMask: TdsdExecStoredProc
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertMaskMIMaster2
      StoredProcList = <
        item
          StoredProc = spInsertMaskMIMaster2
        end
        item
          StoredProc = spSelectMI
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077
      ImageIndex = 54
    end
    object actInsertRecord: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Action = actJuridicalChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1070#1088'. '#1083#1080#1094#1086'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1070#1088'. '#1083#1080#1094#1086'>'
      ShortCut = 16429
      ImageIndex = 0
    end
    object actShowAllJur: TBooleanStoredProcAction
      Category = 'DSDLib'
      TabSheet = cxTabSheet1
      MoveParams = <>
      Enabled = False
      StoredProc = spSelectJuridicalOrderFinance
      StoredProcList = <
        item
          StoredProc = spSelectJuridicalOrderFinance
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
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
    object actUpdate_AmountByReport: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMI_byReport
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMI_byReport
        end
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelectMI
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1086#1090#1095#1077#1090
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1086#1090#1095#1077#1090
    end
    object actGet_Export_FileName: TdsdExecStoredProc
      Category = 'Export_file'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_FileName
      StoredProcList = <
        item
          StoredProc = spGet_Export_FileName
        end>
      Caption = 'actGet_Export_FileName'
    end
    object actSelect_Export: TdsdExecStoredProc
      Category = 'Export_file'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelect_Export
      StoredProcList = <
        item
          StoredProc = spSelect_Export
        end>
      Caption = 'actSelect_Export'
    end
    object actExport_Grid_file: TExportGrid
      Category = 'Export_file'
      MoveParams = <>
      ExportType = cxegExportToText
      Grid = ExportXmlGrid
      Caption = 'actExport_Grid_file'
      OpenAfterCreate = False
      DefaultFileName = 'Report_'
      DefaultFileExt = 'XML'
      EncodingANSI = True
    end
    object actSMTPFile_file: TdsdSMTPFileAction
      Category = 'Export_file'
      MoveParams = <>
      Host.Value = Null
      Host.ComponentItem = 'Host'
      Host.DataType = ftString
      Host.MultiSelectSeparator = ','
      Port.Value = 25
      Port.ComponentItem = 'Port'
      Port.DataType = ftString
      Port.MultiSelectSeparator = ','
      UserName.Value = Null
      UserName.ComponentItem = 'UserName'
      UserName.DataType = ftString
      UserName.MultiSelectSeparator = ','
      Password.Value = Null
      Password.ComponentItem = 'Password'
      Password.DataType = ftString
      Password.MultiSelectSeparator = ','
      Body.Value = Null
      Body.ComponentItem = 'Body'
      Body.DataType = ftString
      Body.MultiSelectSeparator = ','
      Subject.Value = Null
      Subject.ComponentItem = 'Subject'
      Subject.DataType = ftString
      Subject.MultiSelectSeparator = ','
      FromAddress.Value = Null
      FromAddress.ComponentItem = 'AddressFrom'
      FromAddress.DataType = ftString
      FromAddress.MultiSelectSeparator = ','
      ToAddress.Value = Null
      ToAddress.ComponentItem = 'AddressTo'
      ToAddress.DataType = ftString
      ToAddress.MultiSelectSeparator = ','
    end
    object actExport: TMultiAction
      Category = 'Export_file'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Export_FileName
        end
        item
          Action = actSelect_Export
        end
        item
          Action = actExport_Grid_file
        end
        item
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1074#1099#1075#1088#1091#1079#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090'?'
      InfoAfterExecute = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1091#1089#1087#1077#1096#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085
      Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1074' '#1092#1072#1081#1083
      Hint = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1074' '#1092#1072#1081#1083
      ImageIndex = 53
    end
    object actExport_file: TdsdStoredProcExportToFile
      Category = 'Export_file'
      MoveParams = <>
      dsdStoredProcName = spSelect_Export
      FilePathParam.Value = ''
      FilePathParam.DataType = ftString
      FilePathParam.MultiSelectSeparator = ','
      FileNameParam.Value = ''
      FileNameParam.DataType = ftString
      FileNameParam.MultiSelectSeparator = ','
      FileExt = '.xml'
      FileExtParam.Value = ''
      FileExtParam.DataType = ftString
      FileExtParam.MultiSelectSeparator = ','
      FileNamePrefixParam.Value = ''
      FileNamePrefixParam.DataType = ftString
      FileNamePrefixParam.MultiSelectSeparator = ','
      FieldDefs = <>
      Left = 1208
      Top = 168
    end
    object actSetErasedJurOrdFin: TdsdUpdateErased
      Category = 'JuridicalOrderFinance'
      TabSheet = cxTabSheet1
      MoveParams = <>
      Enabled = False
      StoredProc = spErasedUnErased_JurOrdFin
      StoredProcList = <
        item
          StoredProc = spErasedUnErased_JurOrdFin
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      ShortCut = 49220
      ErasedFieldName = 'isErased'
      DataSource = JuridicalDS
    end
    object actSetUnErasedJurOrdFin: TdsdUpdateErased
      Category = 'JuridicalOrderFinance'
      TabSheet = cxTabSheet1
      MoveParams = <>
      Enabled = False
      StoredProc = spErasedUnErased_JurOrdFin
      StoredProcList = <
        item
          StoredProc = spErasedUnErased_JurOrdFin
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 49220
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = JuridicalDS
    end
    object InsertRecord_JurOrdFin: TInsertRecord
      Category = 'JuridicalOrderFinance'
      TabSheet = cxTabSheet1
      MoveParams = <>
      Enabled = False
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView1
      Action = actContractChoiceForm_JurOrdFin
      Params = <>
      Caption = 'InsertRecord_JurOrdFin'
      ImageIndex = 0
    end
    object ExecuteDialogPeriod: TExecuteDialog
      Category = 'JuridicalOrderFinance'
      MoveParams = <>
      Caption = 'ExecuteDialogPeriod'
      FormName = 'TDatePeriodDialogForm'
      FormNameParam.Value = 'TDatePeriodDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inStartDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'inStartDate'
          DataType = ftDateTime
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inEndDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'inEndDate'
          DataType = ftDateTime
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actInsert_byMovBankAccount: TdsdExecStoredProc
      Category = 'JuridicalOrderFinance'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsert_byMovBankAccount
      StoredProcList = <
        item
          StoredProc = spInsert_byMovBankAccount
        end>
      Caption = 'actInsert_byMovBankAccount'
    end
    object macInsert_byMovBankAccount: TMultiAction
      Category = 'JuridicalOrderFinance'
      TabSheet = cxTabSheet1
      MoveParams = <>
      Enabled = False
      ActionList = <
        item
          Action = ExecuteDialogPeriod
        end
        item
          Action = actInsert_byMovBankAccount
        end
        item
          Action = actRefreshOFJ
        end>
      QuestionBeforeExecute = 
        #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1074' '#1089#1087#1088'. '#1055#1072#1088#1072#1084'. '#1070#1088'. '#1083#1080#1094#1072', '#1089#1086#1075#1083#1072#1089#1085#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1088'/'#1089 +
        #1095#1077#1090#1072'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1086#1073#1085#1086#1074#1083#1077#1085#1099
      Caption = 
        #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1074' '#1089#1087#1088'. '#1055#1072#1088#1072#1084'. '#1070#1088'. '#1083#1080#1094#1072', '#1089#1086#1075#1083#1072#1089#1085#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1088'/'#1089 +
        #1095#1077#1090#1072
      Hint = 
        #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1074' '#1089#1087#1088'. '#1055#1072#1088#1072#1084'. '#1070#1088'. '#1083#1080#1094#1072', '#1089#1086#1075#1083#1072#1089#1085#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1088'/'#1089 +
        #1095#1077#1090#1072
      ImageIndex = 27
    end
    object actGet_Export_Email_xls: TdsdExecStoredProc
      Category = 'Export_mail_ok'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_Email_xls
      StoredProcList = <
        item
          StoredProc = spGet_Export_Email_xls
        end>
      Caption = 'actGet_Export_Email_xls'
    end
    object actGet_Export_FileNamexls: TdsdExecStoredProc
      Category = 'Export_mail_ok'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetFileName_xls
      StoredProcList = <
        item
          StoredProc = spGetFileName_xls
        end>
      Caption = 'actGet_Export_FileNamexls'
    end
    object actSelect_Export_xls: TdsdExecStoredProc
      Category = 'Export_mail_ok'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelectOrderFinance_XLS
      StoredProcList = <
        item
          StoredProc = spSelectOrderFinance_XLS
        end>
      Caption = 'actSelect_Export_xls'
    end
    object mactExport_xls: TMultiAction
      Category = 'Export_mail_ok'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Export_Email_xls
        end
        item
          Action = actGet_Export_FileNamexls
        end
        item
          Action = actSelect_Export_xls
        end
        item
          Action = actExport_Grid_xls1
        end
        item
          Action = actSMTPFile_xls
        end
        item
          Action = actUpdate_SignWait_1_Yes
        end
        item
          Action = actRefreshGet
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1087#1086#1095#1090#1077'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1091#1089#1087#1077#1096#1085#1086' '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1099' '#1087#1086' '#1087#1086#1095#1090#1077
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1055#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1081' '#1087#1083#1072#1085' '#1087#1086' '#1087#1086#1095#1090#1077
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1055#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1081' '#1087#1083#1072#1085' '#1087#1086' '#1087#1086#1095#1090#1077' (XLS)'
      ImageIndex = 53
    end
    object actSMTPFile_xls: TdsdSMTPFileAction
      Category = 'Export_mail_ok'
      MoveParams = <>
      Host.Value = Null
      Host.Component = ExportEmailCDS
      Host.ComponentItem = 'Host'
      Host.DataType = ftString
      Host.MultiSelectSeparator = ','
      Port.Value = 25
      Port.Component = ExportEmailCDS
      Port.ComponentItem = 'Port'
      Port.DataType = ftString
      Port.MultiSelectSeparator = ','
      UserName.Value = Null
      UserName.Component = ExportEmailCDS
      UserName.ComponentItem = 'UserName'
      UserName.DataType = ftString
      UserName.MultiSelectSeparator = ','
      Password.Value = Null
      Password.Component = ExportEmailCDS
      Password.ComponentItem = 'Password'
      Password.DataType = ftString
      Password.MultiSelectSeparator = ','
      Body.Value = Null
      Body.Component = ExportEmailCDS
      Body.ComponentItem = 'Body'
      Body.DataType = ftString
      Body.MultiSelectSeparator = ','
      Subject.Value = Null
      Subject.Component = ExportEmailCDS
      Subject.ComponentItem = 'Subject'
      Subject.DataType = ftString
      Subject.MultiSelectSeparator = ','
      FromAddress.Value = Null
      FromAddress.Component = ExportEmailCDS
      FromAddress.ComponentItem = 'AddressFrom'
      FromAddress.DataType = ftString
      FromAddress.MultiSelectSeparator = ','
      ToAddress.Value = Null
      ToAddress.Component = ExportEmailCDS
      ToAddress.ComponentItem = 'AddressTo'
      ToAddress.DataType = ftString
      ToAddress.MultiSelectSeparator = ','
    end
    object mactExportMail_xls_1: TMultiAction
      Category = 'Export_mail_ok'
      MoveParams = <>
      Enabled = False
      ActionList = <>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1087#1086#1095#1090#1077'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1091#1089#1087#1077#1096#1085#1086' '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1099' '#1087#1086' '#1087#1086#1095#1090#1077
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1087#1083#1072#1085' 1.'#1087#1085'. '#1087#1086' '#1087#1086#1095#1090#1077
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1087#1083#1072#1085' 1.'#1087#1085'. '#1087#1086' '#1087#1086#1095#1090#1077' (XLS)'
      ImageIndex = 53
    end
    object mactExportMail_xls_2: TMultiAction
      Category = 'Export_mail_ok'
      MoveParams = <>
      Enabled = False
      ActionList = <>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1087#1086#1095#1090#1077'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1091#1089#1087#1077#1096#1085#1086' '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1099' '#1087#1086' '#1087#1086#1095#1090#1077
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1087#1083#1072#1085' 2.'#1074#1090'. '#1087#1086' '#1087#1086#1095#1090#1077
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1087#1083#1072#1085' 2.'#1074#1090'. '#1087#1086' '#1087#1086#1095#1090#1077' (XLS)'
      ImageIndex = 53
    end
    object mactExportMail_xls_3: TMultiAction
      Category = 'Export_mail_ok'
      MoveParams = <>
      Enabled = False
      ActionList = <>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1087#1086#1095#1090#1077'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1091#1089#1087#1077#1096#1085#1086' '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1099' '#1087#1086' '#1087#1086#1095#1090#1077
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1087#1083#1072#1085' 3.'#1089#1088'. '#1087#1086' '#1087#1086#1095#1090#1077
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1087#1083#1072#1085' 3.'#1089#1088'. '#1087#1086' '#1087#1086#1095#1090#1077' (XLS)'
      ImageIndex = 53
    end
    object mactExportMail_xls_4: TMultiAction
      Category = 'Export_mail_ok'
      MoveParams = <>
      Enabled = False
      ActionList = <>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1087#1086#1095#1090#1077'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1091#1089#1087#1077#1096#1085#1086' '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1099' '#1087#1086' '#1087#1086#1095#1090#1077
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1087#1083#1072#1085' 4.'#1095#1090'. '#1087#1086' '#1087#1086#1095#1090#1077
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1087#1083#1072#1085' 4.'#1095#1090'. '#1087#1086' '#1087#1086#1095#1090#1077' (XLS)'
      ImageIndex = 53
    end
    object mactExportMail_xls_5: TMultiAction
      Category = 'Export_mail_ok'
      MoveParams = <>
      Enabled = False
      ActionList = <>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1087#1086#1095#1090#1077'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1091#1089#1087#1077#1096#1085#1086' '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1099' '#1087#1086' '#1087#1086#1095#1090#1077
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1087#1083#1072#1085' 5.'#1087#1090'. '#1087#1086' '#1087#1086#1095#1090#1077
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1087#1083#1072#1085' 5.'#1087#1090'. '#1087#1086' '#1087#1086#1095#1090#1077' (XLS)'
      ImageIndex = 53
    end
    object actChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          ComponentItem = 'Id'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          ComponentItem = 'Code'
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
      DataSource = MasterDS
    end
    object actUpdate_SignWait_1_Yes: TdsdExecStoredProc
      Category = 'Sign_1'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_SignWait_1_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_SignWait_1_Yes
        end
        item
          StoredProc = spGet
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <C'#1090#1072#1088#1090' '#1089#1086#1075#1083#1072#1089#1086#1074#1072#1085#1080#1103'>'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <C'#1090#1072#1088#1090' '#1089#1086#1075#1083#1072#1089#1086#1074#1072#1085#1080#1103'>'
    end
    object actUpdate_SignWait_1_No: TdsdExecStoredProc
      Category = 'Sign_1'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_SignWait_1_No
      StoredProcList = <
        item
          StoredProc = spUpdate_SignWait_1_No
        end
        item
          StoredProc = spGet
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' <'#1057#1090#1072#1088#1090' '#1089#1086#1075#1083#1072#1089#1086#1074#1072#1085#1080#1103'>'
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' <'#1057#1090#1072#1088#1090' '#1089#1086#1075#1083#1072#1089#1086#1074#1072#1085#1080#1103'>'
    end
    object actUpdate_Sign_1_No: TdsdExecStoredProc
      Category = 'Sign_1'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Sign_1_No
      StoredProcList = <
        item
          StoredProc = spUpdate_Sign_1_No
        end
        item
          StoredProc = spGet
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' <'#1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1086'>'
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' <'#1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1086'>'
    end
    object actUpdate_Sign_1_Yes: TdsdExecStoredProc
      Category = 'Sign_1'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Sign_1_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_Sign_1_Yes
        end
        item
          StoredProc = spGet
        end>
      Caption = #1057#1086#1075#1083#1072#1089#1086#1074#1072#1090#1100
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1086'>'
    end
    object actBankChoiceForm_JurMain: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TBankForm'
      FormName = 'TBankForm'
      FormNameParam.Value = 'TBankForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = JuridicalCDS
          ComponentItem = 'BankId_main'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = JuridicalCDS
          ComponentItem = 'BankName_main'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actBankChoiceForm_Jur: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TBankForm'
      FormName = 'TBankForm'
      FormNameParam.Value = 'TBankForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = JuridicalCDS
          ComponentItem = 'BankId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = JuridicalCDS
          ComponentItem = 'BankName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actGet_Export_FileName_gr: TdsdExecStoredProc
      Category = 'Export_mail_group'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetFileName_gr
      StoredProcList = <
        item
          StoredProc = spGetFileName_gr
        end>
      Caption = 'actGet_Export_FileName_xls'
    end
    object actSMTPFile: TdsdSMTPFileAction
      Category = 'Export_Email_fr3'
      MoveParams = <>
      Host.Value = Null
      Host.Component = ExportEmailCDS
      Host.ComponentItem = 'Host'
      Host.DataType = ftString
      Host.MultiSelectSeparator = ','
      Port.Value = 25
      Port.Component = ExportEmailCDS
      Port.ComponentItem = 'Port'
      Port.DataType = ftString
      Port.MultiSelectSeparator = ','
      UserName.Value = Null
      UserName.Component = ExportEmailCDS
      UserName.ComponentItem = 'UserName'
      UserName.DataType = ftString
      UserName.MultiSelectSeparator = ','
      Password.Value = Null
      Password.Component = ExportEmailCDS
      Password.ComponentItem = 'Password'
      Password.DataType = ftString
      Password.MultiSelectSeparator = ','
      Body.Value = Null
      Body.Component = ExportEmailCDS
      Body.ComponentItem = 'Body'
      Body.DataType = ftString
      Body.MultiSelectSeparator = ','
      Subject.Value = Null
      Subject.Component = ExportEmailCDS
      Subject.ComponentItem = 'Subject'
      Subject.DataType = ftString
      Subject.MultiSelectSeparator = ','
      FromAddress.Value = Null
      FromAddress.Component = ExportEmailCDS
      FromAddress.ComponentItem = 'AddressFrom'
      FromAddress.DataType = ftString
      FromAddress.MultiSelectSeparator = ','
      ToAddress.Value = Null
      ToAddress.Component = ExportEmailCDS
      ToAddress.ComponentItem = 'AddressTo'
      ToAddress.DataType = ftString
      ToAddress.MultiSelectSeparator = ','
    end
    object actGet_Export_Email: TdsdExecStoredProc
      Category = 'Export_Email_fr3'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_Email
      StoredProcList = <
        item
          StoredProc = spGet_Export_Email
        end>
      Caption = 'actGet_Export_Email'
    end
    object actExport_Grid: TExportGrid
      Category = 'Export_Email_fr3'
      MoveParams = <>
      Grid = ExportXmlGrid
      Caption = 'actExport_Grid'
      OpenAfterCreate = False
      DefaultFileName = 'Report_'
      DefaultFileExt = 'XML'
    end
    object actGet_Export_FileName_xls: TdsdExecStoredProc
      Category = 'Export_Email_fr3'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_FileName_xls
      StoredProcList = <
        item
          StoredProc = spGet_Export_FileName_xls
        end>
      Caption = 'actGet_Export_FileName_xls'
    end
    object actSPPrintOrderFinanceProcName: TdsdExecStoredProc
      Category = 'Export_Email_fr3'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReportName
      StoredProcList = <
        item
          StoredProc = spGetReportName
        end>
      Caption = 'actSPPrintOrderFinanceProcName'
    end
    object actExport_fr3: TdsdPrintAction
      Category = 'Export_Email_fr3'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = 'actExport_fr3'
      Hint = 'actExport_fr3'
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'NumGroup;NumGroupRes;InfoMoneyName;JuridicalName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'frxXLSExport_find'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'frxXLSExport1_ShowDialog'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'FileNameExport'
          Value = Null
          Component = FormParams
          ComponentItem = 'FileName_xls'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_OrderFinance'
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameOrderFinance'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object mactExport_fr3: TMultiAction
      Category = 'Export_Email_fr3'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Export_Email
        end
        item
          Action = actGet_Export_FileName_xls
        end
        item
          Action = actSPPrintOrderFinanceProcName
        end
        item
          Action = actExport_fr3
        end
        item
          Action = actSMTPFile
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1087#1086#1095#1090#1077'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1091#1089#1087#1077#1096#1085#1086' '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1099' '#1087#1086' '#1087#1086#1095#1090#1077
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1055#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1081' '#1087#1083#1072#1085' '#1087#1086' '#1087#1086#1095#1090#1077
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1055#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1081' '#1087#1083#1072#1085' '#1087#1086' '#1087#1086#1095#1090#1077
      ImageIndex = 53
    end
    object actDoLoad: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = '0'
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
    object mactLoadExcel: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      TabSheet = cxTabSheetMain
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1079#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' Excel?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1079#1072#1075#1088#1091#1078#1077#1085#1099' '#1091#1089#1087#1077#1096#1085#1086
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' Excel'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' Excel'
    end
    object actGet_Export_Email_msg: TdsdExecStoredProc
      Category = 'Export_Email_msg'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_Email_msg
      StoredProcList = <
        item
          StoredProc = spGet_Export_Email_msg
        end>
      Caption = 'actGet_Export_Email_msg'
    end
    object mactExport_msg: TMultiAction
      Category = 'Export_Email_msg'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Export_Email_msg
        end
        item
          Action = actSMTPFile
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' '#1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077' '#1087#1086#1089#1083#1077' '#1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1080#1103'?'
      InfoAfterExecute = #1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077' '#1087#1086#1089#1083#1077' '#1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1080#1103' '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1086
      Caption = #1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077' '#1087#1086#1089#1083#1077' '#1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1080#1103
      Hint = #1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077' '#1087#1086#1089#1083#1077' '#1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1080#1103
      ImageIndex = 53
    end
    object mactSign_1_Yes: TMultiAction
      Category = 'Sign_1'
      MoveParams = <>
      ActionList = <
        item
          Action = mactExport_msg
        end
        item
          Action = actUpdate_Sign_1_Yes
        end>
      Caption = #1057#1086#1075#1083#1072#1089#1086#1074#1072#1090#1100
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1086'>'
    end
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 70
    Top = 311
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 16
    Top = 303
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 344
    Top = 264
    object N1: TMenuItem
      Action = actRefresh
    end
  end
  object spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_OrderFinanceSB'
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
        Name = 'inJuridicalId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContractId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCashId_top'
        Value = Null
        Component = GuidesCash
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCashId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CashId'
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
        Name = 'ioAmount_old'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount_old'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate_Amount_top'
        Value = Null
        Component = edOperDate_Amount
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioOperDate_Amount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDate_Amount'
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioOperDate_Amount_old'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDate_Amount_old'
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmountPlan_1'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlan_1'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmountPlan_2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlan_2'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmountPlan_3'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlan_3'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmountPlan_4'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlan_4'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmountPlan_5'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlan_5'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountPlan_total'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlan_total'
        DataType = ftFloat
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
      end
      item
        Name = 'inGoodsName_child'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsName_child'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber_child'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'InvNumber_child'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber_Invoice_child'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'InvNumber_Invoice_child'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 62
    Top = 359
  end
  object DBViewAddOn: TdsdDBViewAddOn
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
    ColorRuleList = <
      item
        BackGroundValueColumn = ColorFon_record
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 1
      end>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 339
    Top = 361
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 326
    Top = 287
  end
  object spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_OrderFinance'
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
        Name = 'inOrderFinanceId'
        Value = Null
        Component = GuidesOrderFinance
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankAccountId'
        Value = Null
        Component = GuidesBankAccount
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId_1'
        Value = Null
        Component = GuidesMember1
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId_2'
        Value = Null
        Component = GuidesMember2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeekNumber'
        Value = Null
        Component = edWeekNumber
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTotalSumm_1'
        Value = Null
        Component = edTotalSumm_1
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTotalSumm_2'
        Value = Null
        Component = edTotalSumm_2
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTotalSumm_3'
        Value = Null
        Component = edTotalSumm_3
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 258
    Top = 224
  end
  object HeaderSaver: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    StoredProc = spInsertUpdateMovement
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edOperDate
      end
      item
        Control = edOrderFinance
      end
      item
        Control = edWeekNumber
      end
      item
        Control = edTotalSumm_1
      end
      item
        Control = edTotalSumm_2
      end
      item
        Control = edTotalSumm_3
      end
      item
        Control = ceMember_1
      end
      item
        Control = ceMember_2
      end
      item
        Control = ceComment
      end
      item
        Control = edBankAccount
      end>
    GetStoredProc = spGet
    Left = 168
    Top = 313
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_OrderFinance'
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
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
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
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate_Amount'
        Value = Null
        Component = edOperDate_Amount
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OrderFinanceId'
        Value = ''
        Component = GuidesOrderFinance
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'OrderFinanceName'
        Value = ''
        Component = GuidesOrderFinance
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
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
        Name = 'Comment'
        Value = Null
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankAccountId'
        Value = Null
        Component = GuidesBankAccount
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankAccountNameAll'
        Value = Null
        Component = GuidesBankAccount
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateUpdate_report'
        Value = Null
        Component = edUpdatetDate_report
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserUpdate_report'
        Value = Null
        Component = edUserUpdate_report
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'WeekNumber'
        Value = Null
        Component = edWeekNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm_1'
        Value = Null
        Component = edTotalSumm_1
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm_2'
        Value = Null
        Component = edTotalSumm_2
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm_3'
        Value = Null
        Component = edTotalSumm_3
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserMemberId_1'
        Value = Null
        Component = GuidesMember1
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserMember_1'
        Value = Null
        Component = GuidesMember1
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserMemberId_2'
        Value = Null
        Component = GuidesMember2
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserMember_2'
        Value = Null
        Component = GuidesMember2
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertName'
        Value = Null
        Component = GuidesInsert
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateName'
        Value = Null
        Component = GuidesUpdate
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertDate'
        Value = Null
        Component = edInsertDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateDate'
        Value = Null
        Component = edUpdatetDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName_insert'
        Value = Null
        Component = cePosition
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName_insert'
        Value = Null
        Component = ceUnit
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDate_WeekNumber'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate_WeekNumber'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Date_Sign_1'
        Value = Null
        Component = ceDateSign_1
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Date_SignWait_1'
        Value = Null
        Component = ceDateSignWait_1
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSign_1'
        Value = Null
        Component = cbSign_1
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSignWait_1'
        Value = Null
        Component = cbSignWait_1
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalText_1'
        Value = Null
        Component = edTotalText_1
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalText_2'
        Value = Null
        Component = edTotalText_2
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalText_3'
        Value = Null
        Component = edTotalText_3
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSignSB'
        Value = Null
        Component = cbSignSB
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Date_SignSB'
        Value = Null
        Component = ceDate_SignSB
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 216
    Top = 304
  end
  object RefreshAddOn: TRefreshAddOn
    DataSet = 'ClientDataSet'
    KeyField = 'Id'
    RefreshAction = 'actRefresh'
    FormParams = 'FormParams'
    Left = 446
    Top = 354
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    GuidesList = <
      item
        Guides = GuidesOrderFinance
      end>
    ActionItemList = <
      item
        Action = actInsertUpdateMovement
      end>
    Left = 208
    Top = 392
  end
  object spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderFinance_SetErased'
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
    Left = 494
    Top = 232
  end
  object spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderFinance_SetUnErased'
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
    Left = 614
    Top = 264
  end
  object StatusGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceStatus
    FormNameParam.Value = ''
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 39
    Top = 65528
  end
  object spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_OrderFinance'
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
    Left = 188
    Top = 40
  end
  object spGetTotalSumm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_TotalSumm'
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
        Name = 'TotalSumm'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalSumm'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 556
    Top = 60
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 572
    Top = 345
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 548
    Top = 350
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_OrderFinance_Print'
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
    Left = 679
    Top = 96
  end
  object spIDEL: TdsdStoredProc
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = 0
        ParamType = ptInput
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
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmountPartner'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountPacker'
        Value = 0.000000000000000000
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsCalcAmountPartner'
        Value = True
        DataType = ftBoolean
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
        Name = 'ioCountForPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountForPrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountSumm'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLiveWeight'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHeadCount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAssetId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AssetId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 134
    Top = 359
  end
  object GuidesOrderFinance: TdsdGuides
    KeyField = 'Id'
    LookupControl = edOrderFinance
    FormNameParam.Value = 'TOrderFinance_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TOrderFinance_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesOrderFinance
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesOrderFinance
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankAccountId'
        Value = Null
        Component = GuidesBankAccount
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankAccountNameAll'
        Value = Null
        Component = GuidesBankAccount
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberId_1'
        Value = Null
        Component = GuidesMember1
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName_1'
        Value = Null
        Component = GuidesMember1
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberId_2'
        Value = Null
        Component = GuidesMember2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName_2'
        Value = Null
        Component = GuidesMember2
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 512
  end
  object JuridicalCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 704
    Top = 215
  end
  object JuridicalDS: TDataSource
    DataSet = JuridicalCDS
    Left = 886
    Top = 239
  end
  object dsdDBViewAddOnJuridical: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
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
    Left = 875
    Top = 297
  end
  object spSelectJuridicalOrderFinance: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_JuridicalOrderFinance_choice'
    DataSet = JuridicalCDS
    DataSets = <
      item
        DataSet = JuridicalCDS
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
        Name = 'inOrderFinanceId'
        Value = Null
        Component = GuidesOrderFinance
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisShowAll'
        Value = False
        Component = actShowAllJur
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisErased'
        Value = Null
        Component = actShowErasedJur
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 704
    Top = 359
  end
  object spUpdate_Juridical_OrderFinance: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_JuridicalOrderFinance_forMovement'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = JuridicalCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = JuridicalCDS
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId'
        Value = Null
        Component = JuridicalCDS
        ComponentItem = 'InfoMoneyId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankMainId'
        Value = Null
        Component = JuridicalCDS
        ComponentItem = 'BankId_main'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankId'
        Value = Null
        Component = JuridicalCDS
        ComponentItem = 'BankId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankAccountMainId_top'
        Value = Null
        Component = GuidesBankAccount
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankAccountMainName'
        Value = Null
        Component = JuridicalCDS
        ComponentItem = 'BankAccountName_main'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankAccountName'
        Value = Null
        Component = JuridicalCDS
        ComponentItem = 'BankAccountName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummOrderFinance'
        Value = Null
        Component = JuridicalCDS
        ComponentItem = 'SummOrderFinance'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = JuridicalCDS
        ComponentItem = 'Comment_pay'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 806
    Top = 359
  end
  object spInsertUpdateMI_byReport: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_OrderFinance_byReport'
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
    Left = 848
    Top = 80
  end
  object GuidesBankAccount: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBankAccount
    FormNameParam.Value = 'TBankAccount_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankAccount_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBankAccount
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'NameAll'
        Value = ''
        Component = GuidesBankAccount
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 896
    Top = 80
  end
  object spSelect_Export: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_OrderFinance_XML'
    DataSet = ExportCDS
    DataSets = <
      item
        DataSet = ExportCDS
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
    Left = 352
    Top = 440
  end
  object spGet_Export_FileName: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_OrderFinance_FileName'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outFileName'
        Value = Null
        Component = actExport_Grid_file
        ComponentItem = 'DefaultFileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDefaultFileExt'
        Value = Null
        Component = actExport_Grid_file
        ComponentItem = 'DefaultFileExt'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEncodingANSI'
        Value = False
        Component = actExport_Grid_file
        ComponentItem = 'EncodingANSI'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileName'
        Value = Null
        Component = actSMTPFile_file
        ComponentItem = 'FileName'
        DataType = ftString
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
        Name = 'inBankName_Main'
        Value = #1055#1040#1058' "'#1054#1058#1055' '#1041#1040#1053#1050'"'
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 136
    Top = 464
  end
  object ExportDS: TDataSource
    DataSet = ExportCDS
    Left = 88
    Top = 488
  end
  object ExportCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 24
    Top = 488
  end
  object spErasedUnErased_JurOrdFin: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSet = JuridicalCDS
    DataSets = <
      item
        DataSet = JuridicalCDS
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = JuridicalCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 688
    Top = 424
  end
  object spInsert_byMovBankAccount: TdsdStoredProc
    StoredProcName = 'gpInsert_Object_JuridicalOrderFinance_byBankAccount'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inStartDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inStartDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inEndDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankAccountId_main'
        Value = ''
        Component = GuidesBankAccount
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 768
    Top = 144
  end
  object spInsertMaskMIMaster2: TdsdStoredProc
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'id'
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
        Name = 'inJuridicalId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContractId'
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
        Name = 'inAmountPlan_1'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountPlan_2'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountPlan_3'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountPlan_4'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountPlan_5'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAmountPlan_1'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAmountPlan_2'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAmountPlan_3'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAmountPlan_4'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAmountPlan_5'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 102
    Top = 391
  end
  object GuidesInsert: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInsertUser
    DisableGuidesOpen = True
    Key = '0'
    FormNameParam.Value = 'TMemberPosition_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMemberPosition_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesInsert
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInsert
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
    Left = 67
    Top = 51
  end
  object GuidesUpdate: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUpdateUser
    DisableGuidesOpen = True
    Key = '0'
    FormNameParam.Value = 'TMemberPosition_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMemberPosition_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesUpdate
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUpdate
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
    Left = 984
    Top = 48
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    DisableGuidesOpen = True
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 47
  end
  object GuidesPosition: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePosition
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPositionForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPositionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPosition
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPosition
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 319
    Top = 72
  end
  object GuidesMember1: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMember_1
    DisableGuidesOpen = True
    FormNameParam.Value = 'TMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMember1
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMember1
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        ComponentItem = 'Code'
        MultiSelectSeparator = ','
      end>
    Left = 717
    Top = 16
  end
  object GuidesMember2: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMember_2
    DisableGuidesOpen = True
    FormNameParam.Value = 'TMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMember2
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMember2
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        ComponentItem = 'Code'
        MultiSelectSeparator = ','
      end>
    Left = 717
    Top = 56
  end
  object Guides_Update_report: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUserUpdate_report
    DisableGuidesOpen = True
    FormNameParam.Value = 'TMemberForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMemberForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Guides_Update_report
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Guides_Update_report
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        ComponentItem = 'Code'
        MultiSelectSeparator = ','
      end>
    Left = 934
  end
  object spGet_Export_Email_xls: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_OrderFinance_Email_send'
    DataSet = ExportEmailCDS
    DataSets = <
      item
        DataSet = ExportEmailCDS
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
    Left = 312
    Top = 520
  end
  object spSelectOrderFinance_XLS: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_OrderFinance_XLS'
    DataSet = ExportCDS
    DataSets = <
      item
        DataSet = ExportCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = 'False'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 552
    Top = 456
  end
  object ExportEmailCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 456
    Top = 521
  end
  object ExportEmailDS: TDataSource
    DataSet = ExportEmailCDS
    Left = 504
    Top = 522
  end
  object spGetFileName_xls: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_OrderFinance_FileName_xls'
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
        Name = 'outFileName'
        Value = Null
        Component = actExport_Grid_xls1
        ComponentItem = 'DefaultFileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDefaultFileExt'
        Value = Null
        Component = actExport_Grid_xls1
        ComponentItem = 'DefaultFileExt'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEncodingANSI'
        Value = Null
        Component = actExport_Grid_xls1
        ComponentItem = 'EncodingANSI'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileName'
        Value = Null
        Component = actSMTPFile_xls
        ComponentItem = 'FileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 432
    Top = 448
  end
  object PeriodChoice: TPeriodChoice
    Left = 256
    Top = 16
  end
  object FieldFilter: TdsdFieldFilter
    TextEdit = edOKPO_search
    DataSet = MasterCDS
    Column = chOKPO
    ColumnList = <
      item
        Column = chOKPO
        TextEdit = edOKPO_search
      end
      item
        Column = chJuridicalName
        TextEdit = edJuridicalName_search
      end>
    ActionNumber1 = actChoiceGuides
    CheckBoxList = <>
    Left = 448
    Top = 40
  end
  object spUpdate_SignWait_1_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdateMovement_OrderFinance_SignWait_1'
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
        Name = 'inisSignWait_1'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 968
    Top = 264
  end
  object spUpdate_Sign_1_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdateMovement_OrderFinance_Sign_1'
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
        Name = 'isSign_1'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 952
    Top = 392
  end
  object spUpdate_SignWait_1_No: TdsdStoredProc
    StoredProcName = 'gpUpdateMovement_OrderFinance_SignWait_1'
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
        Name = 'inisSignWait_1'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 968
    Top = 336
  end
  object spUpdate_Sign_1_No: TdsdStoredProc
    StoredProcName = 'gpUpdateMovement_OrderFinance_Sign_1'
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
        Name = 'isSign_1'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 952
    Top = 440
  end
  object spGet_Export_Email_gr: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_OrderFinance_Email_sendGroup'
    DataSet = ExportEmailCDS
    DataSets = <
      item
        DataSet = ExportEmailCDS
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
    Left = 712
    Top = 512
  end
  object spGetFileName_gr: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_OrderFinance_FileName_group'
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
        Name = 'outFileName'
        Value = Null
        Component = actExport_Grid_groupCSV
        ComponentItem = 'DefaultFileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDefaultFileExt'
        Value = Null
        Component = actExport_Grid_groupCSV
        ComponentItem = 'DefaultFileExt'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEncodingANSI'
        Value = Null
        Component = actExport_Grid_groupCSV
        ComponentItem = 'EncodingANSI'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileName'
        Value = Null
        Component = actSMTPFile_xls
        ComponentItem = 'FileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 704
    Top = 472
  end
  object dsdDBViewAddOn_Export: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = ExportXmlGridDBTableView
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <
      item
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 259
    Top = 441
  end
  object spGet_Export_Email: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_OrderFinance_Email_send'
    DataSet = ExportEmailCDS
    DataSets = <
      item
        DataSet = ExportEmailCDS
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
    Left = 48
    Top = 552
  end
  object spGet_Export_FileName_xls: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_OrderFinance_FileName_xls'
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
        Name = 'outFileName'
        Value = Null
        Component = FormParams
        ComponentItem = 'FileName_xls'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDefaultFileExt'
        Value = Null
        Component = actExport_Grid
        ComponentItem = 'DefaultFileExt'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEncodingANSI'
        Value = Null
        Component = actExport_Grid
        ComponentItem = 'EncodingANSI'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileName'
        Value = Null
        Component = actSMTPFile
        ComponentItem = 'FileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outExportType'
        Value = Null
        Component = actExport_Grid
        ComponentItem = 'ExportType'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 160
    Top = 506
  end
  object TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Email_FileName'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileName'
        Value = Null
        ComponentItem = 'FileName_xls'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDefaultFileExt'
        Value = Null
        ComponentItem = 'DefaultFileExt'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEncodingANSI'
        Value = Null
        ComponentItem = 'EncodingANSI'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileName'
        Value = Null
        ComponentItem = 'FileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outExportType'
        Value = Null
        ComponentItem = 'ExportType'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 96
    Top = 522
  end
  object spGetReportName: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_OrderFinance_ReportName'
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
        Name = 'gpGet_Movement_OrderFinance_ReportName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportNameOrderFinance'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 216
    Top = 552
  end
  object spGet_Export_EmailGroup: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_OrderFinance_Email_sendGroup'
    DataSet = ExportEmailCDS
    DataSets = <
      item
        DataSet = ExportEmailCDS
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
    Left = 120
    Top = 560
  end
  object spGetImportSetting: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TOrderFinanceJournalForm;zc_Object_ImportSetting_OrderFinance'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 736
    Top = 272
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 934
    Top = 549
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ParentId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 897
    Top = 549
  end
  object ChildViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewChild
    OnDblClickActionList = <
      item
      end
      item
      end>
    ActionItemList = <
      item
        ShortCut = 13
      end
      item
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
    Left = 992
    Top = 544
  end
  object spSelectMIChild: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_OrderFinance_Child'
    DataSet = ChildCDS
    DataSets = <
      item
        DataSet = ChildCDS
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
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 834
    Top = 557
  end
  object spUnErasedMIchild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderFinance_SetUnErased'
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
      end
      item
        Name = 'outSumm_parent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outInvNumber_parent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'InvNumber_Child'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outInvNumber_Invoice_parent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'InvNumber_Invoice_child'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsName_parent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsName_Child'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 574
    Top = 536
  end
  object spErasedMIchild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderFinance_SetErased'
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
        Name = 'outSumm_parent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outInvNumber_parent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'InvNumber_Child'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outInvNumber_Invoice_parent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'InvNumber_Invoice_child'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsName_parent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsName_Child'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 654
    Top = 560
  end
  object spInsertUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_OrderFinance_Child'
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
        Name = 'inParentId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
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
        Name = 'inMovementItemId_Order'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'MovementItemId_OrderIncome'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsName'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'InvNumber'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber_Invoice'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'InvNumber_Invoice'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSumm_parent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outInvNumber_parent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'InvNumber_Child'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outInvNumber_Invoice_parent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'InvNumber_Invoice_Child'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsName_parent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsName_Child'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 800
    Top = 448
  end
  object spUpdate_SignSB_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdateMovement_OrderFinance_SignSB'
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
        Name = 'inisSignSB'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 968
    Top = 136
  end
  object spUpdate_SignSB_No: TdsdStoredProc
    StoredProcName = 'gpUpdateMovement_OrderFinance_SignSB'
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
        Name = 'inisSignSB'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 960
    Top = 184
  end
  object GuidesCash: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceCash
    FormNameParam.Value = 'TCash_BranchForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCash_BranchForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCash
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCash
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 640
    Top = 149
  end
  object spGet_Export_Email_msg: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_OrderFinance_Email_send_msg'
    DataSet = ExportEmailCDS
    DataSets = <
      item
        DataSet = ExportEmailCDS
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
        Name = 'inParam'
        Value = '1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 608
    Top = 407
  end
end
