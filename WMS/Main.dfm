object MainForm: TMainForm
  Left = 0
  Top = 0
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
    ActivePage = tsErrors
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
        Left = 542
        Top = 17
        Width = 43
        Height = 13
        Caption = 'Font size'
      end
      object cbRecCount: TCheckBox
        Left = 218
        Top = 16
        Width = 84
        Height = 17
        Caption = 'cbRecCount'
        TabOrder = 0
      end
      object EditRecCount: TEdit
        Left = 303
        Top = 14
        Width = 36
        Height = 21
        TabOrder = 1
        Text = '1'
      end
      object cbDebug: TCheckBox
        Left = 345
        Top = 16
        Width = 97
        Height = 17
        Caption = 'cbDebug'
        TabOrder = 2
      end
      object LogMemo: TMemo
        Left = 217
        Top = 40
        Width = 596
        Height = 565
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
        TabOrder = 3
      end
      object btnObject_SKU_to_wms: TButton
        Left = 8
        Top = 40
        Width = 200
        Height = 25
        Caption = 'Object_SKU to wms'
        TabOrder = 4
        OnClick = btnObject_SKU_to_wmsClick
      end
      object btnObject_SKU_CODE_to_wms: TButton
        Left = 8
        Top = 69
        Width = 200
        Height = 25
        Caption = 'Object_SKU_CODE to wms'
        TabOrder = 5
        OnClick = btnObject_SKU_CODE_to_wmsClick
      end
      object btnObject_SKU_GROUP_DEPENDS_to_wmsClick: TButton
        Left = 8
        Top = 98
        Width = 200
        Height = 25
        Caption = 'Object_SKU_GROUP+DEPENDS to wms'
        TabOrder = 6
        OnClick = btnObject_SKU_GROUP_DEPENDS_to_wmsClickClick
      end
      object btnObject_CLIENT_to_wms: TButton
        Left = 8
        Top = 127
        Width = 200
        Height = 25
        Caption = 'Object_CLIENT to wms'
        TabOrder = 7
        OnClick = btnObject_CLIENT_to_wmsClick
      end
      object btnObject_PACK_to_wms: TButton
        Left = 8
        Top = 156
        Width = 200
        Height = 25
        Caption = 'Object_PACK to wms'
        TabOrder = 8
        OnClick = btnObject_PACK_to_wmsClick
      end
      object btnObject_USER_to_wms: TButton
        Left = 8
        Top = 185
        Width = 200
        Height = 25
        Caption = 'Object_USER to wms'
        TabOrder = 9
        OnClick = btnObject_USER_to_wmsClick
      end
      object btnMovement_INCOMING_to_wms: TButton
        Left = 8
        Top = 214
        Width = 200
        Height = 25
        Caption = 'Movement_INCOMING to wms'
        TabOrder = 10
        OnClick = btnMovement_INCOMING_to_wmsClick
      end
      object btnMovement_ASN_LOAD_to_wms: TButton
        Left = 8
        Top = 243
        Width = 200
        Height = 25
        Caption = 'Movement_ASN_LOAD to wms'
        TabOrder = 11
        OnClick = btnMovement_ASN_LOAD_to_wmsClick
      end
      object btnMovement_ORDER_to_wms: TButton
        Left = 8
        Top = 272
        Width = 200
        Height = 25
        Caption = 'Movement_ORDER to wms'
        TabOrder = 12
        OnClick = btnMovement_ORDER_to_wmsClick
      end
      object btnStartTimer: TButton
        Left = 8
        Top = 444
        Width = 93
        Height = 25
        Caption = 'Start Timer'
        TabOrder = 13
        OnClick = btnStartTimerClick
      end
      object btnEndTimer: TButton
        Left = 110
        Top = 444
        Width = 98
        Height = 25
        Caption = 'Stop Timer'
        TabOrder = 14
        OnClick = btnEndTimerClick
      end
      object btnFDC_alan: TButton
        Left = 8
        Top = 407
        Width = 93
        Height = 25
        Caption = 'test Open alan'
        TabOrder = 15
        OnClick = btnFDC_alanClick
      end
      object btnFDC_wms: TButton
        Left = 110
        Top = 407
        Width = 98
        Height = 25
        Caption = 'test Open wms'
        TabOrder = 16
        OnClick = btnFDC_wmsClick
      end
      object mmoMessage: TMemo
        Left = 822
        Top = 40
        Width = 545
        Height = 565
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
        TabOrder = 17
      end
      object seFontSize: TSpinEdit
        Left = 589
        Top = 14
        Width = 44
        Height = 22
        MaxValue = 12
        MinValue = 8
        TabOrder = 18
        Value = 10
        OnChange = seFontSizeChange
      end
      object btnImpOrderStatusChanged: TButton
        Left = 8
        Top = 301
        Width = 200
        Height = 42
        Caption = #1079#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1072#1082#1077#1090'    order_status_changed'
        TabOrder = 19
        WordWrap = True
        OnClick = btnImpOrderStatusChangedClick
      end
      object btnImpReceivingResult: TButton
        Left = 8
        Top = 347
        Width = 200
        Height = 42
        Caption = #1079#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1072#1082#1077#1090'  receiving_result'
        TabOrder = 20
        WordWrap = True
        OnClick = btnImpReceivingResultClick
      end
    end
    object tsErrors: TTabSheet
      Caption = 'Errors'
      ImageIndex = 2
      object splHorz: TSplitter
        Left = 0
        Top = 265
        Width = 1376
        Height = 5
        Cursor = crVSplit
        Align = alTop
        ExplicitWidth = 1199
      end
      object pnlWMS: TPanel
        Left = 0
        Top = 0
        Width = 1376
        Height = 265
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
          Caption = '  '#1054#1096#1080#1073#1082#1080' WMS'
          TabOrder = 0
          object lbDateStart: TLabel
            Left = 402
            Top = 6
            Width = 64
            Height = 13
            Caption = 'Start_Date '#1089' '
          end
          object lbEndDate: TLabel
            Left = 670
            Top = 6
            Width = 12
            Height = 13
            Caption = #1087#1086
          end
          object lbWMSShowMode: TLabel
            Left = 189
            Top = 7
            Width = 61
            Height = 13
            Caption = #1087#1086#1082#1072#1079#1099#1074#1072#1090#1100
          end
          object btnUpdateWMS: TButton
            Left = 90
            Top = 3
            Width = 75
            Height = 20
            Caption = #1054#1073#1085#1086#1074#1080#1090#1100
            TabOrder = 0
            TabStop = False
            OnClick = btnUpdateWMSClick
          end
          object dtpStartDateWMS: TDateTimePicker
            Left = 472
            Top = 2
            Width = 186
            Height = 21
            Date = 43997.546522673610000000
            Time = 43997.546522673610000000
            TabOrder = 1
            OnChange = dtpStartDateWMSChange
          end
          object dtpEndDateWMS: TDateTimePicker
            Left = 699
            Top = 2
            Width = 186
            Height = 21
            Date = 43997.546522673610000000
            Time = 43997.546522673610000000
            TabOrder = 2
            OnChange = dtpEndDateWMSChange
          end
          object cbbWMSShowMode: TComboBox
            Left = 254
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
          Height = 237
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
      object pnlAlan: TPanel
        Left = 0
        Top = 270
        Width = 1376
        Height = 344
        Align = alClient
        TabOrder = 1
        object pnlAlanTop: TPanel
          Left = 1
          Top = 1
          Width = 1374
          Height = 26
          Align = alTop
          Alignment = taLeftJustify
          BevelOuter = bvLowered
          Caption = '  '#1054#1096#1080#1073#1082#1080' Alan'
          TabOrder = 0
          object lbStartDateAlan: TLabel
            Left = 403
            Top = 7
            Width = 63
            Height = 13
            Caption = 'InsertDate '#1089' '
          end
          object lbEndDateAlan: TLabel
            Left = 670
            Top = 7
            Width = 12
            Height = 13
            Caption = #1087#1086
          end
          object btnUpdateAlan: TButton
            Left = 90
            Top = 3
            Width = 75
            Height = 20
            Caption = #1054#1073#1085#1086#1074#1080#1090#1100
            TabOrder = 0
            TabStop = False
            OnClick = btnUpdateAlanClick
          end
          object dtpStartDateAlan: TDateTimePicker
            Left = 472
            Top = 3
            Width = 186
            Height = 21
            Date = 43997.546522673610000000
            Time = 43997.546522673610000000
            TabOrder = 1
            OnChange = dtpStartDateAlanChange
          end
          object dtpEndDateAlan: TDateTimePicker
            Left = 699
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
          Height = 316
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
    end
    object tsWmsMessage: TTabSheet
      Caption = 'wms_to_host_message'
      ImageIndex = 3
      object pnlWmsMessage: TPanel
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
        object grdWmsMessage: TDBGrid
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
    object tsSettings: TTabSheet
      Caption = 'Settings'
      ImageIndex = 1
      DesignSize = (
        1376
        614)
      object lbWMSDatabase: TLabel
        Left = 40
        Top = 43
        Width = 73
        Height = 13
        Caption = 'WMS Database'
      end
      object lbAlanServer: TLabel
        Left = 40
        Top = 87
        Width = 56
        Height = 13
        Caption = 'Alan Server'
      end
      object lbTimerInterval: TLabel
        Left = 40
        Top = 123
        Width = 65
        Height = 13
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
        Top = 120
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
    end
  end
  object Timer: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = TimerTimer
    Left = 336
    Top = 456
  end
end
