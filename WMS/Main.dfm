object MainForm: TMainForm
  Left = 0
  Top = 0
  ActiveControl = pgcMain
  Caption = 'MainForm'
  ClientHeight = 642
  ClientWidth = 1384
  Color = clBtnFace
  Constraints.MinHeight = 580
  Constraints.MinWidth = 1000
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pgcMain: TPageControl
    Left = 0
    Top = 0
    Width = 1384
    Height = 642
    ActivePage = tsOraExport
    Align = alClient
    TabOrder = 0
    OnChange = pgcMainChange
    object tsLog: TTabSheet
      Caption = 'Log'
      ImageIndex = 1
      DesignSize = (
        1376
        614)
      object lbFontSize: TLabel
        Left = 723
        Top = 17
        Width = 43
        Height = 13
        Caption = 'Font size'
      end
      object cbRecCount: TCheckBox
        Left = 431
        Top = 16
        Width = 101
        Height = 17
        Caption = 'check RecCount'
        TabOrder = 0
      end
      object EditRecCount: TEdit
        Left = 538
        Top = 14
        Width = 36
        Height = 21
        TabOrder = 1
        Text = '1'
      end
      object cbDebug: TCheckBox
        Left = 616
        Top = 16
        Width = 71
        Height = 17
        Caption = 'Debug'
        TabOrder = 2
      end
      object btnObject_SKU_to_wms: TButton
        Left = 8
        Top = 40
        Width = 200
        Height = 25
        Caption = 'Object_SKU to wms'
        TabOrder = 3
        OnClick = btnObject_SKU_to_wmsClick
      end
      object btnObject_SKU_CODE_to_wms: TButton
        Left = 8
        Top = 69
        Width = 200
        Height = 25
        Caption = 'Object_SKU_CODE to wms'
        TabOrder = 4
        OnClick = btnObject_SKU_CODE_to_wmsClick
      end
      object btnObject_SKU_GROUP_DEPENDS_to_wmsClick: TButton
        Left = 8
        Top = 98
        Width = 200
        Height = 25
        Caption = 'Object_SKU_GROUP+DEPENDS to wms'
        TabOrder = 5
        OnClick = btnObject_SKU_GROUP_DEPENDS_to_wmsClickClick
      end
      object btnObject_CLIENT_to_wms: TButton
        Left = 8
        Top = 127
        Width = 200
        Height = 25
        Caption = 'Object_CLIENT to wms'
        TabOrder = 6
        OnClick = btnObject_CLIENT_to_wmsClick
      end
      object btnObject_PACK_to_wms: TButton
        Left = 8
        Top = 156
        Width = 200
        Height = 25
        Caption = 'Object_PACK to wms'
        TabOrder = 7
        OnClick = btnObject_PACK_to_wmsClick
      end
      object btnObject_USER_to_wms: TButton
        Left = 8
        Top = 185
        Width = 200
        Height = 25
        Caption = 'Object_USER to wms'
        TabOrder = 8
        OnClick = btnObject_USER_to_wmsClick
      end
      object btnMovement_INCOMING_to_wms: TButton
        Left = 8
        Top = 214
        Width = 200
        Height = 25
        Caption = 'Movement_INCOMING to wms'
        TabOrder = 9
        OnClick = btnMovement_INCOMING_to_wmsClick
      end
      object btnMovement_ASN_LOAD_to_wms: TButton
        Left = 8
        Top = 243
        Width = 200
        Height = 25
        Caption = 'Movement_ASN_LOAD to wms'
        TabOrder = 10
        OnClick = btnMovement_ASN_LOAD_to_wmsClick
      end
      object btnMovement_ORDER_to_wms: TButton
        Left = 8
        Top = 272
        Width = 200
        Height = 25
        Caption = 'Movement_ORDER to wms'
        TabOrder = 11
        OnClick = btnMovement_ORDER_to_wmsClick
      end
      object btnStartTimer: TButton
        Left = 8
        Top = 499
        Width = 93
        Height = 25
        Caption = 'Start Timer'
        TabOrder = 12
        OnClick = btnStartTimerClick
      end
      object btnEndTimer: TButton
        Left = 110
        Top = 499
        Width = 98
        Height = 25
        Caption = 'Stop Timer'
        TabOrder = 13
        OnClick = btnEndTimerClick
      end
      object btnFDC_alan: TButton
        Left = 8
        Top = 462
        Width = 93
        Height = 25
        Caption = 'test Open alan'
        TabOrder = 14
        OnClick = btnFDC_alanClick
      end
      object btnFDC_wms: TButton
        Left = 110
        Top = 462
        Width = 98
        Height = 25
        Caption = 'test Open wms'
        TabOrder = 15
        OnClick = btnFDC_wmsClick
      end
      object seFontSize: TSpinEdit
        Left = 770
        Top = 14
        Width = 44
        Height = 22
        MaxValue = 12
        MinValue = 8
        TabOrder = 16
        Value = 10
        OnChange = seFontSizeChange
      end
      object btnImpOrderStatusChanged: TButton
        Left = 8
        Top = 356
        Width = 200
        Height = 42
        Caption = #1079#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1072#1082#1077#1090'    order_status_changed'
        TabOrder = 17
        WordWrap = True
        OnClick = btnImpOrderStatusChangedClick
      end
      object btnImpReceivingResult: TButton
        Left = 8
        Top = 403
        Width = 200
        Height = 42
        Caption = #1079#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1072#1082#1077#1090'  receiving_result'
        TabOrder = 18
        WordWrap = True
        OnClick = btnImpReceivingResultClick
      end
      object chkUseLog: TCheckBox
        Left = 225
        Top = 16
        Width = 140
        Height = 17
        Caption = #1074#1099#1074#1086#1076#1080#1090#1100' '#1083#1086#1075' '#1085#1072' '#1101#1082#1088#1072#1085
        TabOrder = 19
        OnClick = chkUseLogClick
      end
      object pgcLog: TPageControl
        Left = 219
        Top = 38
        Width = 1150
        Height = 569
        ActivePage = tsCheckboxView
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 20
        object tsLogView: TTabSheet
          Caption = 'tsLogView'
          TabVisible = False
          DesignSize = (
            1142
            559)
          object LogMemo: TMemo
            Left = 2
            Top = 4
            Width = 565
            Height = 550
            Anchors = [akLeft, akTop, akBottom]
            Color = clBlack
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clCream
            Font.Height = -11
            Font.Name = 'Courier New'
            Font.Style = []
            Lines.Strings = (
              'Log')
            ParentFont = False
            ReadOnly = True
            ScrollBars = ssVertical
            TabOrder = 0
          end
          object mmoMessage: TMemo
            Left = 572
            Top = 4
            Width = 565
            Height = 550
            Anchors = [akLeft, akTop, akBottom]
            Color = clBlack
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clCream
            Font.Height = -11
            Font.Name = 'Courier New'
            Font.Style = []
            Lines.Strings = (
              'Message')
            ParentFont = False
            ReadOnly = True
            ScrollBars = ssVertical
            TabOrder = 1
          end
        end
        object tsCheckboxView: TTabSheet
          Caption = 'tsCheckboxView'
          ImageIndex = 1
          TabVisible = False
          object grpPackets: TGroupBox
            Left = 33
            Top = 388
            Width = 870
            Height = 108
            Caption = ' '#1055#1088#1086#1094#1077#1089#1089' '#1086#1073#1088#1072#1073#1086#1090#1082#1080' '#1087#1072#1082#1077#1090#1086#1074' '#1080#1084#1087#1086#1088#1090#1072'  '
            TabOrder = 0
            object lbStart_OrderStatusChanged: TLabel
              Left = 188
              Top = 33
              Width = 107
              Height = 13
              Caption = #1085#1072#1095#1072#1083#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103'  '
            end
            object lbEnd_OrderStatusChanged: TLabel
              Left = 459
              Top = 33
              Width = 55
              Height = 13
              Caption = #1079#1072#1074#1077#1088#1096#1077#1085#1086
            end
            object lbStart_ReceivingResult: TLabel
              Left = 188
              Top = 64
              Width = 107
              Height = 13
              Caption = #1085#1072#1095#1072#1083#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103'  '
            end
            object lbEnd_ReceivingResult: TLabel
              Left = 459
              Top = 64
              Width = 55
              Height = 13
              Caption = #1079#1072#1074#1077#1088#1096#1077#1085#1086
            end
            object lbElapsed_OrderStatusChanged: TLabel
              Left = 681
              Top = 33
              Width = 70
              Height = 13
              Caption = #1074#1099#1087#1086#1083#1085#1077#1085#1086' '#1079#1072
            end
            object lbElapsed_ReceivingResult: TLabel
              Left = 681
              Top = 64
              Width = 70
              Height = 13
              Caption = #1074#1099#1087#1086#1083#1085#1077#1085#1086' '#1079#1072
            end
            object chkOrderStatusChanged: TCheckBox
              Left = 24
              Top = 32
              Width = 134
              Height = 17
              Caption = 'order_status_changed'
              TabOrder = 0
            end
            object chkReceivingResult: TCheckBox
              Left = 24
              Top = 63
              Width = 121
              Height = 17
              Caption = 'receiving_result'
              TabOrder = 1
            end
          end
          object grpExpPackets: TGroupBox
            Left = 33
            Top = 11
            Width = 870
            Height = 352
            Caption = ' '#1055#1088#1086#1094#1077#1089#1089' '#1086#1073#1088#1072#1073#1086#1090#1082#1080' '#1087#1072#1082#1077#1090#1086#1074' '#1101#1082#1089#1087#1086#1088#1090#1072'  '
            TabOrder = 1
            object lbStartwms_Object_SKU: TLabel
              Left = 189
              Top = 33
              Width = 107
              Height = 13
              Caption = #1085#1072#1095#1072#1083#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103'  '
            end
            object lbEndwms_Object_SKU: TLabel
              Left = 460
              Top = 33
              Width = 55
              Height = 13
              Caption = #1079#1072#1074#1077#1088#1096#1077#1085#1086
            end
            object lbStartwms_Object_SKU_CODE: TLabel
              Left = 189
              Top = 64
              Width = 107
              Height = 13
              Caption = #1085#1072#1095#1072#1083#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103'  '
            end
            object lbEndwms_Object_SKU_CODE: TLabel
              Left = 460
              Top = 64
              Width = 55
              Height = 13
              Caption = #1079#1072#1074#1077#1088#1096#1077#1085#1086
            end
            object lbElpswms_Object_SKU: TLabel
              Left = 682
              Top = 33
              Width = 70
              Height = 13
              Caption = #1074#1099#1087#1086#1083#1085#1077#1085#1086' '#1079#1072
            end
            object lbElpswms_Object_SKU_CODE: TLabel
              Left = 682
              Top = 64
              Width = 70
              Height = 13
              Caption = #1074#1099#1087#1086#1083#1085#1077#1085#1086' '#1079#1072
            end
            object lbStartwms_Object_SKU_GROUP: TLabel
              Left = 189
              Top = 95
              Width = 107
              Height = 13
              Caption = #1085#1072#1095#1072#1083#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103'  '
            end
            object lbEndwms_Object_SKU_GROUP: TLabel
              Left = 460
              Top = 95
              Width = 55
              Height = 13
              Caption = #1079#1072#1074#1077#1088#1096#1077#1085#1086
            end
            object lbElpswms_Object_SKU_GROUP: TLabel
              Left = 682
              Top = 95
              Width = 70
              Height = 13
              Caption = #1074#1099#1087#1086#1083#1085#1077#1085#1086' '#1079#1072
            end
            object lbStartwms_Object_CLIENT: TLabel
              Left = 189
              Top = 126
              Width = 107
              Height = 13
              Caption = #1085#1072#1095#1072#1083#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103'  '
            end
            object lbEndwms_Object_CLIENT: TLabel
              Left = 460
              Top = 126
              Width = 55
              Height = 13
              Caption = #1079#1072#1074#1077#1088#1096#1077#1085#1086
            end
            object lbElpswms_Object_CLIENT: TLabel
              Left = 682
              Top = 126
              Width = 70
              Height = 13
              Caption = #1074#1099#1087#1086#1083#1085#1077#1085#1086' '#1079#1072
            end
            object lbStartwms_Object_PACK: TLabel
              Left = 188
              Top = 157
              Width = 107
              Height = 13
              Caption = #1085#1072#1095#1072#1083#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103'  '
            end
            object lbEndwms_Object_PACK: TLabel
              Left = 459
              Top = 157
              Width = 55
              Height = 13
              Caption = #1079#1072#1074#1077#1088#1096#1077#1085#1086
            end
            object lbElpswms_Object_PACK: TLabel
              Left = 681
              Top = 157
              Width = 70
              Height = 13
              Caption = #1074#1099#1087#1086#1083#1085#1077#1085#1086' '#1079#1072
            end
            object lbStartwms_Object_USER: TLabel
              Left = 188
              Top = 188
              Width = 107
              Height = 13
              Caption = #1085#1072#1095#1072#1083#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103'  '
            end
            object lbEndwms_Object_USER: TLabel
              Left = 459
              Top = 188
              Width = 55
              Height = 13
              Caption = #1079#1072#1074#1077#1088#1096#1077#1085#1086
            end
            object lbElpswms_Object_USER: TLabel
              Left = 681
              Top = 188
              Width = 70
              Height = 13
              Caption = #1074#1099#1087#1086#1083#1085#1077#1085#1086' '#1079#1072
            end
            object lbStartwms_Movement_INCOMING: TLabel
              Left = 188
              Top = 219
              Width = 107
              Height = 13
              Caption = #1085#1072#1095#1072#1083#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103'  '
            end
            object lbEndwms_Movement_INCOMING: TLabel
              Left = 459
              Top = 219
              Width = 55
              Height = 13
              Caption = #1079#1072#1074#1077#1088#1096#1077#1085#1086
            end
            object lbElpswms_Movement_INCOMING: TLabel
              Left = 681
              Top = 219
              Width = 70
              Height = 13
              Caption = #1074#1099#1087#1086#1083#1085#1077#1085#1086' '#1079#1072
            end
            object lbStartwms_Movement_ASN_LOAD: TLabel
              Left = 188
              Top = 250
              Width = 107
              Height = 13
              Caption = #1085#1072#1095#1072#1083#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103'  '
            end
            object lbEndwms_Movement_ASN_LOAD: TLabel
              Left = 459
              Top = 250
              Width = 55
              Height = 13
              Caption = #1079#1072#1074#1077#1088#1096#1077#1085#1086
            end
            object lbElpswms_Movement_ASN_LOAD: TLabel
              Left = 681
              Top = 250
              Width = 70
              Height = 13
              Caption = #1074#1099#1087#1086#1083#1085#1077#1085#1086' '#1079#1072
            end
            object lbStartwms_Movement_ORDER: TLabel
              Left = 188
              Top = 281
              Width = 107
              Height = 13
              Caption = #1085#1072#1095#1072#1083#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103'  '
            end
            object lbEndwms_Movement_ORDER: TLabel
              Left = 459
              Top = 281
              Width = 55
              Height = 13
              Caption = #1079#1072#1074#1077#1088#1096#1077#1085#1086
            end
            object lbElpswms_Movement_ORDER: TLabel
              Left = 681
              Top = 281
              Width = 70
              Height = 13
              Caption = #1074#1099#1087#1086#1083#1085#1077#1085#1086' '#1079#1072
            end
            object lbStartProcessExpErr: TLabel
              Left = 188
              Top = 310
              Width = 107
              Height = 13
              Caption = #1085#1072#1095#1072#1083#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103'  '
            end
            object lbEndProcessExpErr: TLabel
              Left = 459
              Top = 310
              Width = 55
              Height = 13
              Caption = #1079#1072#1074#1077#1088#1096#1077#1085#1086
            end
            object lbElpsProcessExpErr: TLabel
              Left = 681
              Top = 310
              Width = 70
              Height = 13
              Caption = #1074#1099#1087#1086#1083#1085#1077#1085#1086' '#1079#1072
            end
            object chkwms_Object_SKU: TCheckBox
              Left = 24
              Top = 32
              Width = 134
              Height = 17
              Caption = 'wms_Object_SKU'
              TabOrder = 0
            end
            object chkwms_Object_SKU_CODE: TCheckBox
              Left = 24
              Top = 63
              Width = 160
              Height = 17
              Caption = 'wms_Object_SKU_CODE'
              TabOrder = 1
            end
            object chkwms_Object_SKU_GROUP: TCheckBox
              Left = 24
              Top = 94
              Width = 155
              Height = 17
              Caption = 'wms_Object_SKU_GROUP'
              TabOrder = 2
            end
            object chkwms_Object_CLIENT: TCheckBox
              Left = 24
              Top = 125
              Width = 121
              Height = 17
              Caption = 'wms_Object_CLIENT'
              TabOrder = 3
            end
            object chkwms_Object_PACK: TCheckBox
              Left = 23
              Top = 156
              Width = 134
              Height = 17
              Caption = 'wms_Object_PACK'
              TabOrder = 4
            end
            object chkwms_Object_USER: TCheckBox
              Left = 23
              Top = 187
              Width = 121
              Height = 17
              Caption = 'wms_Object_USER'
              TabOrder = 5
            end
            object chkwms_Movement_INCOMING: TCheckBox
              Left = 23
              Top = 218
              Width = 160
              Height = 17
              Caption = 'wms_Movement_INCOMING'
              TabOrder = 6
            end
            object chkwms_Movement_ASN_LOAD: TCheckBox
              Left = 23
              Top = 249
              Width = 160
              Height = 17
              Caption = 'wms_Movement_ASN_LOAD'
              TabOrder = 7
            end
            object chkwms_Movement_ORDER: TCheckBox
              Left = 23
              Top = 280
              Width = 160
              Height = 17
              Caption = 'wms_Movement_ORDER'
              TabOrder = 8
            end
            object chkProcessExpErr: TCheckBox
              Left = 23
              Top = 306
              Width = 160
              Height = 34
              Caption = ' '#1095#1090#1077#1085#1080#1077' '#1086#1096#1080#1073#1086#1082' '#1086#1073#1088#1072#1073#1086#1090#1082#1080'  '#1076#1072#1085#1085#1099#1093' '#1101#1082#1089#1087#1086#1088#1090#1072
              TabOrder = 9
              WordWrap = True
            end
          end
        end
      end
      object btnDataExportErrors: TButton
        Left = 8
        Top = 302
        Width = 200
        Height = 49
        Caption = ' '#1087#1088#1086#1095#1080#1090#1072#1090#1100' '#1086#1096#1080#1073#1082#1080' '#1086#1073#1088#1072#1073#1086#1090#1082#1080' '#1076#1072#1085#1085#1099#1093' '#1101#1082#1089#1087#1086#1088#1090#1072
        TabOrder = 21
        WordWrap = True
        OnClick = btnDataExportErrorsClick
      end
      object btnStartGateway: TButton
        Left = 8
        Top = 533
        Width = 93
        Height = 25
        Caption = 'Start Gateway'
        TabOrder = 22
        OnClick = btnStartGatewayClick
      end
      object btnStopGateway: TButton
        Left = 110
        Top = 533
        Width = 98
        Height = 25
        Caption = 'Stop Gateway'
        TabOrder = 23
        OnClick = btnStopGatewayClick
      end
    end
    object tsErrors: TTabSheet
      Caption = #1054#1096#1080#1073#1082#1080
      ImageIndex = 2
      object splHorz: TSplitter
        Left = 0
        Top = 262
        Width = 1376
        Height = 5
        Cursor = crVSplit
        Align = alTop
        ExplicitTop = 265
        ExplicitWidth = 1199
      end
      object pnlAlan: TPanel
        Left = 0
        Top = 267
        Width = 1376
        Height = 347
        Align = alClient
        TabOrder = 0
        object pnlAlanTop: TPanel
          Left = 1
          Top = 1
          Width = 1374
          Height = 26
          Align = alTop
          Alignment = taLeftJustify
          BevelOuter = bvLowered
          Caption = '  wms_to_host_error'
          TabOrder = 0
          object lbStartDateAlan: TLabel
            Left = 241
            Top = 7
            Width = 63
            Height = 13
            Caption = 'InsertDate '#1089' '
          end
          object lbEndDateAlan: TLabel
            Left = 508
            Top = 7
            Width = 12
            Height = 13
            Caption = #1087#1086
          end
          object btnUpdateAlan: TButton
            Left = 132
            Top = 3
            Width = 75
            Height = 20
            Caption = #1054#1073#1085#1086#1074#1080#1090#1100
            TabOrder = 0
            TabStop = False
            OnClick = btnUpdateAlanClick
          end
          object dtpStartDateAlan: TDateTimePicker
            Left = 310
            Top = 3
            Width = 186
            Height = 21
            Date = 43997.546522673610000000
            Time = 43997.546522673610000000
            TabOrder = 1
            OnChange = dtpStartDateAlanChange
          end
          object dtpEndDateAlan: TDateTimePicker
            Left = 537
            Top = 3
            Width = 186
            Height = 21
            Date = 43997.546522673610000000
            Time = 43997.546522673610000000
            TabOrder = 2
            OnChange = dtpEndDateAlanChange
          end
        end
        object grdAlan: TDBGrid
          Left = 1
          Top = 27
          Width = 1374
          Height = 319
          Align = alClient
          DataSource = dmData.dsAlan
          ReadOnly = True
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
        end
      end
      object pnlWmsFromHostError: TPanel
        Left = 0
        Top = 0
        Width = 1376
        Height = 262
        Align = alTop
        TabOrder = 1
        object grdWmsFromHostError: TDBGrid
          Left = 1
          Top = 27
          Width = 1374
          Height = 234
          Align = alClient
          DataSource = dmData.dsWmsFromHostError
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
        end
        object pnlpnlWmsFromHostErrorTop: TPanel
          Left = 1
          Top = 1
          Width = 1374
          Height = 26
          Align = alTop
          Alignment = taLeftJustify
          BevelOuter = bvLowered
          Caption = '  wms_from_host_error'
          TabOrder = 1
          object lbStartWmsFromHostError: TLabel
            Left = 241
            Top = 7
            Width = 63
            Height = 13
            Caption = 'InsertDate '#1089' '
          end
          object lbEndWmsFromHostError: TLabel
            Left = 508
            Top = 7
            Width = 12
            Height = 13
            Caption = #1087#1086
          end
          object btnUpdateWmsFromHostError: TButton
            Left = 132
            Top = 3
            Width = 75
            Height = 20
            Caption = #1054#1073#1085#1086#1074#1080#1090#1100
            TabOrder = 0
            TabStop = False
            OnClick = btnUpdateWmsFromHostErrorClick
          end
          object dtpStartWmsFromHostError: TDateTimePicker
            Left = 310
            Top = 3
            Width = 186
            Height = 21
            Date = 43997.546522673610000000
            Time = 43997.546522673610000000
            TabOrder = 1
            OnChange = dtpStartWmsFromHostErrorChange
          end
          object dtpEndWmsFromHostError: TDateTimePicker
            Left = 537
            Top = 3
            Width = 186
            Height = 21
            Date = 43997.546522673610000000
            Time = 43997.546522673610000000
            TabOrder = 2
            OnChange = dtpEndWmsFromHostErrorChange
          end
        end
      end
    end
    object tsWmsToHostMessage: TTabSheet
      Caption = 'wms_to_host_message'
      ImageIndex = 3
      object pnlWmsToHostMessage: TPanel
        Left = 0
        Top = 0
        Width = 1376
        Height = 614
        Align = alClient
        TabOrder = 0
        object pnlWmstMessageTop: TPanel
          Left = 1
          Top = 1
          Width = 1374
          Height = 26
          Align = alTop
          Alignment = taLeftJustify
          BevelOuter = bvLowered
          TabOrder = 0
          object lbWmsMsgStart: TLabel
            Left = 402
            Top = 6
            Width = 63
            Height = 13
            Caption = 'InsertDate '#1089' '
          end
          object lbWmsMsgEnd: TLabel
            Left = 670
            Top = 6
            Width = 12
            Height = 13
            Caption = #1087#1086
          end
          object Label3: TLabel
            Left = 189
            Top = 7
            Width = 61
            Height = 13
            Caption = #1087#1086#1082#1072#1079#1099#1074#1072#1090#1100
          end
          object btnUpdateWmsMessage: TButton
            Left = 90
            Top = 3
            Width = 75
            Height = 20
            Caption = #1054#1073#1085#1086#1074#1080#1090#1100
            TabOrder = 0
            TabStop = False
            OnClick = btnUpdateWmsMessageClick
          end
          object dtpWmsMsgStart: TDateTimePicker
            Left = 472
            Top = 2
            Width = 186
            Height = 21
            Date = 43997.546522673610000000
            Time = 43997.546522673610000000
            TabOrder = 1
            OnChange = dtpWmsMsgStartChange
          end
          object dtpWmsMsgEnd: TDateTimePicker
            Left = 699
            Top = 2
            Width = 186
            Height = 21
            Date = 43997.546522673610000000
            Time = 43997.546522673610000000
            TabOrder = 2
            OnChange = dtpWmsMsgEndChange
          end
          object cbbWmsMessageMode: TComboBox
            Left = 254
            Top = 3
            Width = 107
            Height = 21
            Style = csDropDownList
            ItemIndex = 1
            TabOrder = 3
            Text = #1090#1086#1083#1100#1082#1086' '#1086#1096#1080#1073#1082#1080
            OnChange = cbbWmsMessageModeChange
            Items.Strings = (
              #1074#1089#1105
              #1090#1086#1083#1100#1082#1086' '#1086#1096#1080#1073#1082#1080)
          end
        end
        object grdWmsToHostMessage: TDBGrid
          Left = 1
          Top = 27
          Width = 1374
          Height = 586
          Align = alClient
          DataSource = dmData.dsWmsToHostMessage
          ReadOnly = True
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
        end
      end
    end
    object tsWmsMessage: TTabSheet
      Caption = 'wms_message'
      ImageIndex = 4
      object pnlWmsMessage: TPanel
        Left = 0
        Top = 0
        Width = 1376
        Height = 614
        Align = alClient
        TabOrder = 0
        object pnlWmsMsgTop: TPanel
          Left = 1
          Top = 1
          Width = 1374
          Height = 26
          Align = alTop
          Alignment = taLeftJustify
          BevelOuter = bvLowered
          TabOrder = 0
          object lbMsgStart: TLabel
            Left = 402
            Top = 6
            Width = 63
            Height = 13
            Caption = 'InsertDate '#1089' '
          end
          object lbMsgEnd: TLabel
            Left = 670
            Top = 6
            Width = 12
            Height = 13
            Caption = #1087#1086
          end
          object lbWmsMsgMode: TLabel
            Left = 189
            Top = 7
            Width = 61
            Height = 13
            Caption = #1087#1086#1082#1072#1079#1099#1074#1072#1090#1100
          end
          object btnUpdateWmsMsg: TButton
            Left = 90
            Top = 3
            Width = 75
            Height = 20
            Caption = #1054#1073#1085#1086#1074#1080#1090#1100
            TabOrder = 0
            TabStop = False
            OnClick = btnUpdateWmsMsgClick
          end
          object dtpInsertStart: TDateTimePicker
            Left = 472
            Top = 2
            Width = 186
            Height = 21
            Date = 43997.546522673610000000
            Time = 43997.546522673610000000
            TabOrder = 1
            OnChange = dtpInsertStartChange
          end
          object dtpInsertEnd: TDateTimePicker
            Left = 699
            Top = 2
            Width = 186
            Height = 21
            Date = 43997.546522673610000000
            Time = 43997.546522673610000000
            TabOrder = 2
            OnChange = dtpInsertEndChange
          end
          object cbbWmsMsgMode: TComboBox
            Left = 254
            Top = 3
            Width = 107
            Height = 21
            Style = csDropDownList
            ItemIndex = 1
            TabOrder = 3
            Text = #1090#1086#1083#1100#1082#1086' '#1086#1096#1080#1073#1082#1080
            OnChange = cbbWmsMsgModeChange
            Items.Strings = (
              #1074#1089#1105
              #1090#1086#1083#1100#1082#1086' '#1086#1096#1080#1073#1082#1080)
          end
        end
        object grdWmsMessage: TDBGrid
          Left = 1
          Top = 27
          Width = 1374
          Height = 586
          Align = alClient
          DataSource = dmData.dsWmsMessage
          DefaultDrawing = False
          ReadOnly = True
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnDrawColumnCell = grdWmsMessageDrawColumnCell
        end
      end
    end
    object tsOraExport: TTabSheet
      Caption = #1054#1090#1087#1088#1072#1074#1082#1072' '#1074' Oracle'
      ImageIndex = 5
      object splFromHostHeader: TSplitter
        Left = 0
        Top = 305
        Width = 1376
        Height = 5
        Cursor = crVSplit
        Align = alTop
      end
      object pnlFromHostHeaderMessage: TPanel
        Left = 0
        Top = 0
        Width = 1376
        Height = 305
        Align = alTop
        TabOrder = 0
        object pnlFromHostHeaderMessageTop: TPanel
          Left = 1
          Top = 1
          Width = 1374
          Height = 26
          Align = alTop
          Alignment = taLeftJustify
          BevelOuter = bvLowered
          Caption = '  WMS.from_host_header_message'
          TabOrder = 0
          object lbStartFromHostHeaderMessage: TLabel
            Left = 496
            Top = 6
            Width = 64
            Height = 13
            Caption = 'Start_Date '#1089' '
          end
          object lbEndFromHostHeaderMessage: TLabel
            Left = 764
            Top = 6
            Width = 12
            Height = 13
            Caption = #1087#1086
          end
          object lb3: TLabel
            Left = 283
            Top = 7
            Width = 61
            Height = 13
            Caption = #1087#1086#1082#1072#1079#1099#1074#1072#1090#1100
          end
          object btnUpdateFromHostHeaderMessage: TButton
            Left = 184
            Top = 3
            Width = 75
            Height = 20
            Caption = #1054#1073#1085#1086#1074#1080#1090#1100
            TabOrder = 0
            TabStop = False
            OnClick = btnUpdateFromHostHeaderMessageClick
          end
          object dtpStartFromHostHeaderMessage: TDateTimePicker
            Left = 566
            Top = 2
            Width = 186
            Height = 21
            Date = 43997.546522673610000000
            Time = 43997.546522673610000000
            TabOrder = 1
            OnChange = dtpStartFromHostHeaderMessageChange
          end
          object dtpEndFromHostHeaderMessage: TDateTimePicker
            Left = 793
            Top = 2
            Width = 186
            Height = 21
            Date = 43997.546522673610000000
            Time = 43997.546522673610000000
            TabOrder = 2
            OnChange = dtpEndFromHostHeaderMessageChange
          end
          object cbbFromHostHeaderMessage: TComboBox
            Left = 348
            Top = 3
            Width = 107
            Height = 21
            Style = csDropDownList
            ItemIndex = 1
            TabOrder = 3
            Text = #1090#1086#1083#1100#1082#1086' '#1086#1096#1080#1073#1082#1080
            OnChange = cbbFromHostHeaderMessageChange
            Items.Strings = (
              #1074#1089#1105
              #1090#1086#1083#1100#1082#1086' '#1086#1096#1080#1073#1082#1080)
          end
        end
        object grdFromHostHeaderMessage: TDBGrid
          Left = 1
          Top = 27
          Width = 1374
          Height = 277
          Align = alClient
          DataSource = dmData.dsFromHostMessage
          ReadOnly = True
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
        end
      end
      object pnlFromHostDetailMessage: TPanel
        Left = 0
        Top = 310
        Width = 1376
        Height = 304
        Align = alClient
        TabOrder = 1
        object grdFromHostDetailMessage: TDBGrid
          Left = 1
          Top = 1
          Width = 1374
          Height = 302
          Align = alClient
          DataSource = dmData.dsFromHostDetail
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
        end
      end
    end
    object tsOraImport: TTabSheet
      Caption = #1055#1088#1080#1077#1084' '#1080#1079' Oracle'
      ImageIndex = 6
      object splOraImport: TSplitter
        Left = 0
        Top = 305
        Width = 1376
        Height = 5
        Cursor = crVSplit
        Align = alTop
      end
      object pnlWMS: TPanel
        Left = 0
        Top = 0
        Width = 1376
        Height = 305
        Align = alTop
        TabOrder = 0
        object pnlWmsTop: TPanel
          Left = 1
          Top = 1
          Width = 1374
          Height = 26
          Align = alTop
          Alignment = taLeftJustify
          BevelOuter = bvLowered
          Caption = '  WMS.to_host_header_message'
          TabOrder = 0
          object lbDateStart: TLabel
            Left = 496
            Top = 6
            Width = 64
            Height = 13
            Caption = 'Start_Date '#1089' '
          end
          object lbEndDate: TLabel
            Left = 764
            Top = 6
            Width = 12
            Height = 13
            Caption = #1087#1086
          end
          object lbWMSShowMode: TLabel
            Left = 283
            Top = 7
            Width = 61
            Height = 13
            Caption = #1087#1086#1082#1072#1079#1099#1074#1072#1090#1100
          end
          object btnUpdateWMS: TButton
            Left = 184
            Top = 3
            Width = 75
            Height = 20
            Caption = #1054#1073#1085#1086#1074#1080#1090#1100
            TabOrder = 0
            TabStop = False
            OnClick = btnUpdateWMSClick
          end
          object dtpStartDateWMS: TDateTimePicker
            Left = 566
            Top = 2
            Width = 186
            Height = 21
            Date = 43997.546522673610000000
            Time = 43997.546522673610000000
            TabOrder = 1
            OnChange = dtpStartDateWMSChange
          end
          object dtpEndDateWMS: TDateTimePicker
            Left = 793
            Top = 2
            Width = 186
            Height = 21
            Date = 43997.546522673610000000
            Time = 43997.546522673610000000
            TabOrder = 2
            OnChange = dtpEndDateWMSChange
          end
          object cbbWMSShowMode: TComboBox
            Left = 348
            Top = 3
            Width = 107
            Height = 21
            Style = csDropDownList
            ItemIndex = 1
            TabOrder = 3
            Text = #1090#1086#1083#1100#1082#1086' '#1086#1096#1080#1073#1082#1080
            OnChange = cbbWMSShowModeChange
            Items.Strings = (
              #1074#1089#1105
              #1090#1086#1083#1100#1082#1086' '#1086#1096#1080#1073#1082#1080)
          end
        end
        object grdWMS: TDBGrid
          Left = 1
          Top = 27
          Width = 1374
          Height = 277
          Align = alClient
          DataSource = dmData.dsWMS
          ReadOnly = True
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
        end
      end
      object pnlOraImpDetail: TPanel
        Left = 0
        Top = 310
        Width = 1376
        Height = 304
        Align = alClient
        TabOrder = 1
        object grdWMSDetail: TDBGrid
          Left = 1
          Top = 1
          Width = 1374
          Height = 302
          Align = alClient
          DataSource = dmData.dsWMSDetail
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
        end
      end
    end
    object tsSettings: TTabSheet
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      ImageIndex = 1
      DesignSize = (
        1376
        614)
      object lbWMSDatabase: TLabel
        Left = 37
        Top = 43
        Width = 73
        Height = 13
        Alignment = taRightJustify
        Caption = 'WMS Database'
      end
      object lbAlanServer: TLabel
        Left = 54
        Top = 87
        Width = 56
        Height = 13
        Alignment = taRightJustify
        Caption = 'Alan Server'
      end
      object lbTimerInterval: TLabel
        Left = 45
        Top = 126
        Width = 65
        Height = 13
        Alignment = taRightJustify
        Caption = 'Timer interval'
      end
      object lbIntervalSec: TLabel
        Left = 191
        Top = 123
        Width = 16
        Height = 13
        Caption = 'sec'
      end
      object edtWMSDatabase: TEdit
        Left = 117
        Top = 40
        Width = 1079
        Height = 21
        TabStop = False
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        OnExit = edtWMSDatabaseExit
      end
      object edtAlanServer: TEdit
        Left = 117
        Top = 85
        Width = 1079
        Height = 21
        TabStop = False
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
        OnExit = edtAlanServerExit
      end
      object seTimerInterval: TSpinEdit
        Left = 117
        Top = 123
        Width = 70
        Height = 22
        MaxValue = 10000
        MinValue = 1
        TabOrder = 2
        Value = 1
        OnChange = seTimerIntervalChange
      end
      object btnApplyDefSettings: TButton
        Left = 416
        Top = 192
        Width = 128
        Height = 25
        Caption = 'Apply default settings'
        TabOrder = 3
        TabStop = False
        OnClick = btnApplyDefSettingsClick
      end
      object chkWriteLog: TCheckBox
        Left = 117
        Top = 160
        Width = 156
        Height = 17
        Caption = ' '#1079#1072#1087#1080#1089#1099#1074#1072#1090#1100' '#1083#1086#1075' '#1074' '#1092#1072#1081#1083
        TabOrder = 4
        OnClick = chkWriteLogClick
      end
    end
  end
  object Timer: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = TimerTimer
    Left = 48
    Top = 592
  end
end
