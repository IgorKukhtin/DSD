object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 294
  ClientWidth = 531
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 16
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 531
    Height = 294
    Align = alClient
    Caption = 'pnlTop'
    ShowCaption = False
    TabOrder = 0
    object lblObject: TLabel
      Left = 196
      Top = 193
      Width = 175
      Height = 16
      Caption = 'Generate mapping for objects:'
    end
    object lblDelayTime: TLabel
      Left = 286
      Top = 121
      Width = 21
      Height = 16
      Caption = 'ms.'
      Enabled = False
    end
    object lblTimerTime: TLabel
      Left = 286
      Top = 171
      Width = 21
      Height = 16
      Caption = 'ms.'
      Enabled = False
    end
    object btnExecuteScripts: TButton
      Left = 20
      Top = 16
      Width = 153
      Height = 29
      Caption = 'Execute Scripts ...'
      ImageIndex = 7
      ImageMargins.Left = 5
      Images = ScriptsForm.ImageList
      TabOrder = 0
      OnClick = btnExecuteScriptsClick
    end
    object btnCreateReplicaStruct: TButton
      Left = 20
      Top = 51
      Width = 153
      Height = 26
      Caption = 'Show dump form'
      TabOrder = 1
      OnClick = btnCreateReplicaStructClick
    end
    object chbAutoAlter: TCheckBox
      Left = 196
      Top = 16
      Width = 249
      Height = 17
      Caption = 'Auto create primary key if not exist'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object chbReadOnly: TCheckBox
      Left = 196
      Top = 64
      Width = 237
      Height = 17
      Caption = 'Slave used in read only mode'
      Checked = True
      Enabled = False
      State = cbChecked
      TabOrder = 3
    end
    object chbDelay: TCheckBox
      Left = 196
      Top = 90
      Width = 185
      Height = 17
      Caption = 'Delayed request time'
      Enabled = False
      TabOrder = 4
    end
    object chbTimer: TCheckBox
      Left = 196
      Top = 140
      Width = 233
      Height = 17
      Caption = 'Request chhanged data by timer'
      Enabled = False
      TabOrder = 5
    end
    object btnGenerateExecute: TButton
      Left = 20
      Top = 117
      Width = 153
      Height = 25
      Caption = 'Generate AND Execute'
      TabOrder = 6
      OnClick = btnGenerateExecuteClick
    end
    object edDelay: TEdit
      Left = 210
      Top = 113
      Width = 70
      Height = 24
      Alignment = taRightJustify
      Enabled = False
      TabOrder = 7
      Text = '0'
    end
    object edTimer: TEdit
      Left = 210
      Top = 163
      Width = 70
      Height = 24
      Alignment = taRightJustify
      Enabled = False
      TabOrder = 8
      Text = '0'
    end
    object chbIncludeTable: TCheckBox
      Left = 210
      Top = 218
      Width = 97
      Height = 17
      Caption = 'Table'
      Checked = True
      Enabled = False
      State = cbChecked
      TabOrder = 9
    end
    object chbIncludeView: TCheckBox
      Left = 210
      Top = 246
      Width = 97
      Height = 17
      Caption = 'View'
      TabOrder = 10
    end
    object btnWizard: TButton
      Left = 20
      Top = 148
      Width = 153
      Height = 25
      Caption = 'Wizard'
      TabOrder = 11
      OnClick = btnWizardClick
    end
    object btnGenerate: TButton
      Left = 20
      Top = 83
      Width = 153
      Height = 25
      Caption = 'Generate only'
      TabOrder = 12
      OnClick = btnGenerateClick
    end
    object chbCheckSchema: TCheckBox
      Left = 196
      Top = 40
      Width = 285
      Height = 17
      Caption = 'Do not generate schema "_replica" if exists'
      Checked = True
      State = cbChecked
      TabOrder = 13
    end
  end
  object ActionList: TActionList
    Left = 928
    Top = 20
    object actAlter: TAction
      Caption = 'actAlter'
    end
    object actAlterPK: TAction
      AutoCheck = True
      Caption = 'Add PK'
      Checked = True
      GroupIndex = 1
      OnExecute = actAlterPKExecute
    end
    object actAlterIndex: TAction
      AutoCheck = True
      Caption = 'Add UK'
      GroupIndex = 1
      OnExecute = actAlterIndexExecute
    end
  end
end
