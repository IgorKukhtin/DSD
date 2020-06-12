object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 590
  ClientWidth = 1207
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
    Width = 1207
    Height = 590
    ActivePage = tsErrors
    Align = alClient
    TabOrder = 0
    OnChange = pgcMainChange
    object tsLog: TTabSheet
      Caption = 'Log'
      ImageIndex = 1
      DesignSize = (
        1199
        562)
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
        Left = 218
        Top = 40
        Width = 491
        Height = 513
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
      object btnAll_from_wms: TButton
        Left = 8
        Top = 301
        Width = 200
        Height = 25
        Caption = 'from wms Header +Detail toHost '
        TabOrder = 13
        OnClick = btnAll_from_wmsClick
      end
      object btnStartTimer: TButton
        Left = 8
        Top = 373
        Width = 93
        Height = 25
        Caption = 'Start Timer'
        TabOrder = 14
        OnClick = btnStartTimerClick
      end
      object btnEndTimer: TButton
        Left = 110
        Top = 373
        Width = 98
        Height = 25
        Caption = 'Stop Timer'
        TabOrder = 15
        OnClick = btnEndTimerClick
      end
      object btnFDC_alan: TButton
        Left = 8
        Top = 336
        Width = 93
        Height = 25
        Caption = 'test Open alan'
        TabOrder = 16
        OnClick = btnFDC_alanClick
      end
      object btnFDC_wms: TButton
        Left = 110
        Top = 336
        Width = 98
        Height = 25
        Caption = 'test Open wms'
        TabOrder = 17
        OnClick = btnFDC_wmsClick
      end
      object mmoMessage: TMemo
        Left = 720
        Top = 40
        Width = 473
        Height = 513
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
        TabOrder = 18
      end
      object seFontSize: TSpinEdit
        Left = 589
        Top = 14
        Width = 44
        Height = 22
        MaxValue = 12
        MinValue = 8
        TabOrder = 19
        Value = 10
        OnChange = seFontSizeChange
      end
    end
    object tsErrors: TTabSheet
      Caption = 'Errors'
      ImageIndex = 2
      object splHorz: TSplitter
        Left = 0
        Top = 265
        Width = 1199
        Height = 5
        Cursor = crVSplit
        Align = alTop
      end
      object pnlWMS: TPanel
        Left = 0
        Top = 0
        Width = 1199
        Height = 265
        Align = alTop
        TabOrder = 0
        object pnlWmsTop: TPanel
          Left = 1
          Top = 1
          Width = 1197
          Height = 24
          Align = alTop
          BevelOuter = bvLowered
          Caption = #1054#1096#1080#1073#1082#1080' WMS'
          TabOrder = 0
          ExplicitTop = -5
          DesignSize = (
            1197
            24)
          object btnUpdateWMS: TButton
            Left = 1056
            Top = 2
            Width = 75
            Height = 20
            Anchors = [akTop, akRight]
            Caption = #1054#1073#1085#1086#1074#1080#1090#1100
            TabOrder = 0
            TabStop = False
            OnClick = btnUpdateWMSClick
          end
        end
        object grdWMS: TDBGrid
          Left = 1
          Top = 25
          Width = 1197
          Height = 239
          Align = alClient
          DataSource = dmData.dsWMS
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
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
        Width = 1199
        Height = 292
        Align = alClient
        TabOrder = 1
        ExplicitLeft = 152
        ExplicitTop = 344
        ExplicitWidth = 185
        ExplicitHeight = 41
        object pnlAlanTop: TPanel
          Left = 1
          Top = 1
          Width = 1197
          Height = 24
          Align = alTop
          BevelOuter = bvLowered
          Caption = #1054#1096#1080#1073#1082#1080' Alan'
          TabOrder = 0
          ExplicitLeft = 2
          ExplicitTop = 9
          DesignSize = (
            1197
            24)
          object btnUpdateAlan: TButton
            Left = 1055
            Top = 2
            Width = 75
            Height = 20
            Anchors = [akTop, akRight]
            Caption = #1054#1073#1085#1086#1074#1080#1090#1100
            TabOrder = 0
            TabStop = False
            OnClick = btnUpdateAlanClick
          end
        end
        object grdAlan: TDBGrid
          Left = 1
          Top = 25
          Width = 1197
          Height = 266
          Align = alClient
          DataSource = dmData.dsAlan
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
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
        1199
        562)
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
        Width = 902
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        OnExit = edtWMSDatabaseExit
      end
      object edtAlanServer: TEdit
        Left = 117
        Top = 85
        Width = 902
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
        OnExit = edtAlanServerExit
      end
      object seTimerInterval: TSpinEdit
        Left = 117
        Top = 120
        Width = 70
        Height = 22
        MaxValue = 100
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
