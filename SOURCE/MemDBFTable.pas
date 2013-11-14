{ *************************************************************************** }
{                                                                             }
{                                                                             }
{                                                                             }
{ Модуль MemDBFTable - модуль, обеспечивающий работу с DBF-файлами.           }
{ Является исправленной и улучшенной версией модуля MDBFTable                 }
{ В связи с огромным числом исправлений модуль был переименован в MemDBFTable }
{ Может работать в автономном режиме без обращения к DBF-файлу                }
{ Проверен в Delphi 7, 2007, 2010                                             }
{ (c) 2009-2010 Логинов Дмитрий Сергеевич                                     }
{ Последнее обновление: 09.12.2010                                            }
{ Адрес сайта: http://matrix.kladovka.net.ru/                                 }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{ *************************************************************************** }

{
  Возможности модуля:
  - Поддержка стандартных компонентов VCL для работы с наборами данных. По способу
    работы похож на стандартный компонент TTable.
  - Поддержка большинства возможностей TTable. Компонент
    - доступ к данным через FieldByName / Fields[] и т.п.
    - добавление, удаление, редактирование записей
    - открытие, закрытие набора данных через Open и Close
    - фильтрация (реализован простейший фильтр типа: ИмяПоле Операция Значение
    - поддержка поиска с помощью Locate()
    - добавление полей через FieldDefs (только для пустой таблицы)
  - Поддержка кодировок OEM / ANSI. Для указания кодировки следует правильно
    выставить св-во OEM до открытия набора данных. По умолчанию OEM=True
  - Кодировку данных можно в любой момент изменить с OEM на ANSI (или наоборот)
   с помощью метода TMemDBFTable.ChangeCharsCode().
  - Вся работа с компонентом может выполняться в оперативной памяти без
    обращений к DBF-файлу. Для этого сперва следует создать описание полей
    FieldDefs, а затем вызвать метод TMemDBFTable.CreateTable() без параметров,
    а после этого открыть набор данных.
  - Данные можно в любой момент сохранить в произвольный файл с помощью метода MemDBFTable.Save.
  - При удалении записей они лишь помечаются как удаленные. При этом можно не
    сохранять их в DBF-файл, если установить TMemDBFTable.PackOnSave=True
  - Данные можно отсортировать по одному или нескольким полям по возрастанию или убыванию.  

}

{
  Примеры работы с компонентом TMemDBFTable.

  ** Пример №1: Открытие существующего DBF файла:
  procedure TForm1.FormCreate(Sender: TObject);
  begin
    DBF := TMemDBFTable.Create(Self);
    DataSource1.DataSet := DBF;
    DBF.FileName := 'C:\Delphi\MemDBFTable\TEST1.DBF';
    DBF.Open;
  end;
  Подразумевается, что на Form1 лежит DataSource1 и DBGrid

  ** Пример №2: Работа с данными в оперативной памяти
  procedure TForm1.FormCreate(Sender: TObject);
  begin
    DBF := TMemDBFTable.Create(Self);
    DataSource1.DataSet := DBF;

    // Добавление описания полей
    DBF.FieldDefs.Add('DATA', ftDate);
    DBF.FieldDefs.Add('NAME', ftString, 20);

    DBF.CreateTable();
    DBF.Open;

    // Добавление записи
    DBF.Append;
    DBF.FieldByName('DATA').AsDateTime := Date;
    DBF.FieldByName('NAME').AsString := 'Наименование';
    DBF.Post;
  end;
  Пользователь может сохранить информацию в DBF файл например так:
  DBF.Save('C:\Delphi\MemDBFTable\TEST2.DBF');

  ** Пример №3: Перенос данных из произвольного TDataSet в DBF
  procedure LoadFromParadix(ATable: TDataSet; AFileName: string);
  var
    I: Integer;
    DBF: TMemDBFTable;
  begin
    DBF := TMemDBFTable.Create(nil);
    try
      // Копируем описание полей.
      // Внимание! TMemDBFTable поддерживает не все типы полей!
      DBF.FieldDefs.Assign(ATable.FieldDefs);

      DBF.CreateTable();
      DBF.Open;

      // Копируем данные в DBF
      ATable.First;
      while not ATable.Eof do
      begin
        DBF.Append;
        for I := 0 to ATable.Fields.Count - 1 do
          if not ATable.Fields[i].IsNull then
            DBF.Fields[i].Assign(ATable.Fields[i]); 
        DBF.Post;
        ATable.Next;
      end;

      // Сохраняем в указанный DBF-файл
      DBF.Save(AFileName);
    finally
      DBF.Free;
    end;
  end;
  // Следует иметь ввиду, что имена полей в DBF ограничены 10 символов

}

{
  Перечень исправлений и доработок:
    - отсутствовал деструктор класса TMDBFTable. Из-за этого были утечки памяти.
    - убран пустой параметр "bdase3: Boolean" из процедуры CreateTable
    - убран буффер записи в функции ReadDBFData. Из-за него была утечка памяти
    - деструктор TDBFAccess.Destroy удалял список Fields, но не освобождал помять
      под его элементы. То же самое в методе LoadFromFile
    - Добавлен метод ClearFieldsDefs
    - метод GetData изменяет (на время) ShortDateFormat. Опасно в многопоточном приожении
    - код прогнал через DelForExp
    - исправлено множество потенциально опасных участков кода, которые могли
      привести к утечкам памяти
    - тестирование с FastMM4 показало отсутствие утечек памяти
    - в метод ReadDBFData добавлен код, заменяющий все символы #0 на пробелы
    - метод ReadDBFData для некоторых DBF заглатывал последнюю запись (если в конце
      файла отсутствовал байт 1A)
    - не записывался в DBF-файл тип поля для вещественных значений (N)
    - исправлена функция SetFieldData: добавлена конвертация AnsiToOemBuff
    - исправлена функция GetData. Раньше была очень долгая обработка строк из-за
      кода в цикле: s := s + c. Теперь заранее вызывается SetLength. Открытие и
      прокрутка набора данных теперь работают ощутимо быстрее. Также блоки try..except
      заменены на TryStrToFloat и TryStrToInt. Должно работать чуть-чуть быстрее.
    - в методе GetData для строк функция Trim заменена на TrimRight. Левые пробелы
      не должны обрезаться. Кстати, при открытии в MS Excel начальные пробелы
      обрезаются, а OpenOffice Calc их оставляет.
    - полностью переписана фильтрация. Раньше она практически не работали и жутко тормозила.
      Теперь она достаночно неплохо оптимизирована. Учитывает OEM.
    - доработана функция CreateTable(). Теперь можно заранее создать поля через
      FieldDefs (или через FieldDefs.Assign), а затем вызвать CreateTable() с одним
      параметром - именем файла. Попутно добавлена поддержка дополнительных типов данных.
    - после использования FieldDefs.Assign нужно иметь ввиду, что для вещественных
      полей (ftFloat и т.п.) число знаков после запятой еще не определено. По умолчанию
      компонент устанавливает 4 знака после запятой, но этого может оказаться мало,
      поэтому можно вручную указать требуемое число знаков,
      например: Table.FieldDefs.Items[0].Precision := 7;
    - функция SetFieldData оказалась очень опасной. В нее VCL передавала адрес
      переменной (разного типа данных), затем это значение преобразовывалось в
      текстовый вид, а затем текст копировался в область памяти переданной
      переменной. AV происходило редко, но, к счастью (для отладки) оно произошло.
    - исправлена функция GetData. Она не возвращала текст, если набор данных пуст
      и изменяется первая (пустая) строка.
    - чтение из DBF файла и запись в DBF файл переделаны с TFileStream на TMemoryStream.
      Чтение при этом (на проведенном тесте) практически в 2 раза быстрее.
      Скорость записи практически та же, что и для TFileStream.
    - теперь, благодаря переводу на TMemoryStream, компонент может работать в
      режиме TMemoryDataSet, т.е. DBF файл вообще не требуется. Для этого нужно
      создать описание полей в FieldDefs и вызвать CreateTable() без параметров.
    - Для TStringList, в который сохраняются считанные строки, заранее устанавливается Capacity.
    - Исправлен метод Locate. Ранее он мог найти только строку. При этом опция
      loCaseInsensitive не обеспечивала правильный поиск для WIN1251.
    - На всякий случай закомментировал код в методе InternalHandleException.
      Нужно еще разобраться, как он поведет себя в дополнительном потоке.
      Это сделано по примеру. В IBX тело этого метода также пустое!
    - Добавлен метод TMemDBFTable.ChangeCharsCode для перекодировки данных между OEM/ANSI
    - При сохранении данных в созданный DBF-файл в качестве значения байта $1D
      пишется значение $65 (DOS, 866) либо $03 (WIN1251). Число кодировок
      таким образом сильно ограничено (в принципе автору этого достаточно).
    - Исправлено свойство TMemDBFTable.Modified. Оно должно выставляться в True,
      только при установке значения поля.
    - Исправлена функция GetData(). Не учитывалось, что вызовы могут быть с
      параметром Value=nil. Это бывает при проверке поля: TField.IsNull
    - Обнаружен глюк: не работает вставка записи с помощью InsertRecord(). Вместо
      этого следует использовать AppendRecord().
    - 11/07/09: Оптимизирована функция SetFieldData(). Теперь она работает
      (в среднем) в 1.5 раза быстрее, чем раньше.
    - 12/07/09: Исправленная серьезная ошибка. Неправильно выполнялась работа с
      полями Boolean. Вместо этого следует использовать тип WordBool. Ошибка выявилась
      случайно. Во всех проектах использование Boolean всегда прокатывало, а в
      одном из проектов все записи имели значение True у логических полей, хотя
      этот проект в части работы с DBF был идентичен всем предыдущим проектам.
    - 12/07/09: Добавлена возможность сортировки по одному или нескольким полям.
      См. описание метода TMemDBFTable.Sort().
    - 12/07/09: Добавлена поддержка фильтра по частичному совпадению.

    - 07/01/10: Модуль адаптирован для работы в D2010. Нового ничего не добавлено!
      В DBF-файлах по прежнему строки хранятся в формате ASCII (никакого юникода!),
      правильность работы с кодовыми страницами контроллируется пользователем.
      Работоспособность модуля проверена в D7, D2007, D2010.

    - 09/12/2010: теперь проверка входимости символа в множество осуществляется с
      помощью CharInSet

}

unit MemDBFTable;

{ Директива D2009PLUS определяет, что текущая версия Delphi: 2009 или выше}
{$IF RTLVersion >= 20.00}
   {$DEFINE D2009PLUS}
{$IFEND}

interface

uses
  Variants, Windows, Messages, SysUtils, Classes, Controls, Db, Math;

const
  dBase_MaxRecCount = 1000000000;
  dBase_MaxRecSize = 4000;
  dBase_MaxFieldCount = 128;
  dBase_MaxFieldWidth = 255;
  dBase_MaxNumPrec = 16;
  dBase_MaxMemoBytes = 16384;
  dBase_MaxMemoRec = 512;

  flgDeleted = #$2A;
  flgUndeleted = #$20;
  flgEOF = #$1A;
  flgBOF = #$0D;

  err_ErrorCode = 'Error code: ';
  err_Warning = 'Warning';
  err_Stop = 'Error';
  err_BookMark = 'Cannot find bookmark';
  err_NoRecords = 'No records';
  err_InValidValue = 'Invalid value';
  err_ChangeFileName = 'Cannot change Filename if table is active';
  err_IncorrectDBF = 'Incorrect DBF file';
  err_AccessOutRange = 'Access out of range';
  err_WrongFieldDef = 'Wrong field definition';
  err_FileNotOpen = 'File not open';

  dBaseIIIPlus = $03;
  dBaseIIIPlusMemo = $83;

type    

  TDBFError = procedure(Sender: TObject; ErrorMsg: string) of object;

  TFieldName = string[10]; // Имя поля в DBF ограничено 10 символами!

  // Описание одной записи
  TDBFBuffer = array[1..dBase_MaxRecSize] of Byte;

  // Заголовок файла dBaseIII
  TdBaseIIIPlus_Header = record
    Version, //$03 without memo, $83 with memo
      Year,
      Month,
      Day: Byte;
    Recordcount: Longint;
    HeaderSize,
      RecordSize: Word;
    Reserved1: array[1..3] of Byte;
    LANRsvd: array[1..13] of Byte;
    Reserved2: array[1..4] of Byte;
  end;

  // Заголовок файла dBaseIV
  TdBaseIVPlus_Header = record
    Version, { 01234567
                vvvmsssa
                |  ||  |
                |  ||  - presence of any memo file
                |  |- presence of an SQL table
                |  - presence of a dBASE IV memo
                - indicate version number}
    Year,
      Month,
      Day: Byte;
    Recordcount: Longint;
    HeaderSize,
      RecordSize: Word;
    Reserved1: array[1..2] of Byte; //filled with 0
    IncompleteTranstactionFlag, //$01 transaction protected
      EncryptionFlag: byte; //$01 encrypted
    MultiuserRsvd: array[1..12] of Byte;
    MDXFlag, //$01 presence
      LangDrvID: byte;
    { 001 - cp 437
      002 - cp 850
      100 - cp 852
      102 - cp 865
      101 - cp 866
      104 - cp 895
      200 - cp 1250
      201 - cp 1251
      003 - cp 1252                      }
  end;

  // Физическое описание одного поля в таблице dBaseIII
  TdBaseIIIPlus_Field = record
    Name: array[1..10] of AnsiChar;
    ClosingZero: byte;
    FieldType: AnsiChar;
    MemAddress: array[1..4] of Byte;
    Width,
      Decimals: Byte;
    LAN1: array[1..2] of Byte;
    WorkAreaID: byte;
    LAN2: array[1..2] of Byte;
    SetFields: byte;
    Rsvd: byte;
  end;

  // Описание поля dBaseIV
  TdBaseIVPlus_Field = record
    Name: array[1..10] of AnsiChar;
    ClosingZero: byte;
    FieldType: AnsiChar;
    Rsvd1: array[1..4] of Byte;
    Width,
      Decimals: Byte;
    Rsvd2: array[1..2] of Byte;
    WorkAreaID: byte;
    Rsvd3: array[1..10] of Byte;
    Indexed: byte;
  end;

  TDBTHeader = record
    NextBlock: DWORD;
    BlockSize: DWORD;
    Reserved: array[1..504] of AnsiChar;
  end;

  PDBFField = ^TDBFField;
  TDBFField = record
    FieldName: TFieldname;
    FieldType: TFieldType;
    Size: word;
    Decimals: Byte;
    Offset: Word;
    Indexed: Boolean;
  end;

  TDBFStructure = record
    FileName: string;
    Year, Month, Day: Byte;
    Version: byte;
    RecordCount, DeletedCount: LongInt;
    HeaderSize: Word;
    RecordSize: Word;
    MDXPresent: Boolean;
    Encrypted,
      TransProt,
      Memo, AnyMemo: Boolean;
    CodePage: word;
    FieldCount: Word;
    Data: TStringList;
    Fields: TList;
  end;

  PRecInfo = ^TRecInfo;
  TRecInfo = packed record
    BookMark: Integer;
    UpdateStatus: TUpdateStatus;
    BookmarkFlag: TBookmarkFlag;
  end;

  TDBFAccess = class(TPersistent)
  private
    Fdb3Header: TdBaseIIIPlus_Header;
    Fdb4Header: TdBaseIVPlus_Header;
    Fdb3Field: TdBaseIIIPlus_Field;
    Fdb4Field: TdBaseIVPlus_Field;
    FDBF: TDBFStructure;
    FResult: Integer;
    FOnDBFError: TDBFError;
    FPackOnSave: Boolean;
    FDB3: Boolean;
    procedure CheckRange(FileSize: Longint);
    procedure CheckField(Field: TDBFField);
    procedure ReadDBFHeader(AStream: TStream);
    procedure ReadDBFFieldDefs(AStream: TStream);
    procedure ReadDBFData(AStream: TStream);
    procedure WriteDB3Header(HB: TdBaseIIIPlus_Header; AStream: TStream);
    procedure WriteDB4Header(HB: TdBaseIVPlus_Header; AStream: TStream);
    procedure WriteDBFFieldDefs(AFields: TList; AStream: TStream);
    procedure WriteDBFData(AFields: TList; AData: TStringList; AStream: TStream);
    procedure ClearFieldsDefs;
  protected
    procedure RaiseDBFError;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromStream(AStream: TStream);
    procedure SaveToFile(const Filename: string; OEM: Boolean);
    property Structure: TDBFStructure read FDBF write FDBF;
    property LastError: Integer read FResult write FResult;
    property OnDBFError: TDBFError read FOnDBFError write FOnDBFError;
    property PackOnSave: Boolean read FPackOnSave write FPackOnSave;
    property Dbase3: Boolean read FDB3 write FDB3;
  end;

  //PdBaseMemoRecord = ^TdBaseMemoRecord;
  //TdBaseMemoRecord = array [0..dBase_MaxMemoBytes] of byte;

  TMemDBFTable = class(TDataset)
  private
    FAccess: TDBFAccess;
    FStructure: TDBFStructure;
    FData: tstringlist; // Ссылка на список из FAccess
    FRecSize: Integer; // Кол-во байтов в одной записи
    FRecBufSize: Integer;
    FRecInfoOfs: Integer;
    FCurRec: Integer;
    FAbout, FFileName: string;
    FLastBookmark: Integer;
    FLastUpdate: string;
    FOnDBFError: TDBFError;
    FMakeBackup: Boolean;
    FShowDeleted: Boolean;
    FModified: Boolean;
    FVersion: string;
    FActiveFilter: Boolean;
    FMemoFile: TFileStream;
    DBTHeader: TDBTHeader;
    FMemoFilename: string;
    FOEM: Boolean;

    // Хранит заголовочную часть таблицы после CreateTable
    // Автоматически уничтожается после Open
    MemDataHeader: TMemoryStream;

    function GetField(Index: Integer): TDBFField;
    procedure DBFError(Sender: TObject; ErrorMsg: string);
    function GetDeleted: Boolean;
    procedure SetShowDeleted(const Value: Boolean);
    procedure SetFilterActive(const Value: Boolean);
    function GetFilterActive: Boolean;
    function GetCodePage: word;
    function GetDeletedCount: Integer;
    function GetEncrypted: Boolean;
    function GetPackOnSave: Boolean;
    function GetTransactionProtected: Boolean;
    function GetWithMemo: Boolean;
    procedure SetPackOnSave(const Value: Boolean);
  protected
    procedure SetAbout(value: string);
    procedure SetFilename(value: string);

    function AllocRecordBuffer: {$IFDEF D2009PLUS}TRecordBuffer{$ELSE}PChar{$ENDIF}; override;

    procedure FreeRecordBuffer(var Buffer: {$IFDEF D2009PLUS}TRecordBuffer{$ELSE}PChar{$ENDIF}); override;

    procedure GetBookmarkData(Buffer: {$IFDEF D2009PLUS}TRecordBuffer{$ELSE}PChar{$ENDIF}; Data: Pointer); override;

    function GetBookmarkFlag(Buffer: {$IFDEF D2009PLUS}TRecordBuffer{$ELSE}PChar{$ENDIF}): TBookmarkFlag; override;

    function GetRecord(Buffer: {$IFDEF D2009PLUS}TRecordBuffer{$ELSE}PChar{$ENDIF}; GetMode: TGetMode; DoCheck: Boolean): TGetResult; override;
    function GetRecordSize: Word; override;
    //function GetFieldPointer(Buffer: PChar; Fields: TField): PChar;
    function GetActiveRecordBuffer: PAnsiChar;
    procedure InternalAddRecord(Buffer: Pointer; Append: Boolean); override;
//    procedure InternalRefresh; override;
    procedure InternalClose; override;
    procedure InternalDelete; override;
    procedure InternalFirst; override;
    procedure InternalGotoBookmark(Bookmark: Pointer); override;
    procedure InternalHandleException; override;
    procedure InternalInitFieldDefs; override;
    procedure InternalInitRecord(Buffer: {$IFDEF D2009PLUS}TRecordBuffer{$ELSE}PChar{$ENDIF}); override;
    procedure InternalLast; override;
    procedure InternalOpen; override;
    procedure InternalPost; override;
    procedure InternalInsert; override;
    procedure InternalCancel; override;
    procedure InternalSetToRecord(Buffer: {$IFDEF D2009PLUS}TRecordBuffer{$ELSE}PChar{$ENDIF}); override;
    function IsCursorOpen: Boolean; override;
    procedure SetBookmarkFlag(Buffer: {$IFDEF D2009PLUS}TRecordBuffer{$ELSE}PChar{$ENDIF}; Value: TBookmarkFlag); override;
    procedure SetBookmarkData(Buffer: {$IFDEF D2009PLUS}TRecordBuffer{$ELSE}PChar{$ENDIF}; Data: Pointer); override;
    procedure SetFieldData(Field: TField; Buffer: Pointer); override;
    function GetRecordCount: Integer; override;
    function GetRecNo: Integer; override;
    procedure SetRecNo(Value: Integer); override;
    function GetData(Field: TField; var Value: PAnsiChar; Buffer: PAnsiChar): Boolean;
    function FindRecord(Restart, GoForward: Boolean): Boolean; override;
    procedure Zap;
    function HasMemo: Boolean;
    function ProcessFilter(Buffer: PAnsiChar): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    {Создает DBF файл с именем FileName, либо инициализирует набор данных в
     оперативной памяти для дальнейшей работы с ним. Если указать FileName='',
     то компонент вообще не будет обращаться к диску, т.е. становится TMemoryDataSet.
     Fields - список указателей на описатели полей TDBFField. Если Fields=nil,
     то берется стандартный список FieldDefs (его нужно заполнить заранее до открытия
     набора данных. Внимание! После переоткрытия набора данных он очищается!) }
    procedure CreateTable(const FileName: string = ''; Fields: TList = nil);

    {Сохраняет набор данных в указанный файл. Если файл не указан, то будет
     использоваться исходный DBF файл, из которого загружены данные}
    procedure Save(const AFileName: string = '');

    { Выполняет сортировку таблицы в соответствии с указанными в Fields
      полями. Можно указать одно поле или несколько. Несколько полей
      должны отделяться друг от друга символом ";". Если Asc=True, то сортировка
      выполняется по возрастанию, иначе - по убыванию. Asc действует сразу на все
      поля. Индивидуальная сортировка для каждого поля не поддерживается. Если в
      качестве Fields указать пустую строку, или несуществующие столбцы, то
      сортировка отменяется, т.е. она осуществляется в том же порядке, к котором
      записи были добавлены в таблицу. При этом учитывается флаг Asc.}
    procedure Sort(Fields: string; Asc: Boolean = True);

    function FindKey(const KeyValues: array of const): Boolean;
    procedure GetFields(var Fields: TList);
    function Locate(const KeyFields: string; const KeyValues: Variant; Options: TLocateOptions): Boolean; override;
    function GetMemoData(Field: TField): string;
    procedure SetMemoData(Field: TField; Text: string);
    function GetFieldData(Field: TField; Buffer: Pointer): Boolean; override;
    {function GetBLOBData(Field :TField): TMemoryStream;
    procedure SetBLOBData(Field :TField; BLOB :TMemoryStream);}
    procedure Undelete;

    {Изменяет кодировку текстовых данных с OEM в ANSI либо наоборот, при этом
     меняется флаг OEM. Может использоваться, например, если есть DBF файл в
     кодировке WIN1251. Требуется его перекодировать в ОЕМ для того, чтобы
     открыть в MS Excel}
    procedure ChangeCharsCode;
    property OriginalFields[Index: Integer]: TDBFField read GetField;
    property LastUpdate: string read FLastUpdate;
    property Deleted: Boolean read GetDeleted;
    property WithMemo: Boolean read GetWithMemo;
    property DeletedCount: Integer read GetDeletedCount;
    property Modified: Boolean read FModified write FModified;
    property Version: string read FVersion;
    property CodePage: word read GetCodePage;
    property TransactionProtected: Boolean read GetTransactionProtected;
    property Encrypted: Boolean read GetEncrypted;
  published
    property About: string read fabout write SetAbout;
    property FileName: string read FFileName write SetFileName;
    property MakeBackup: Boolean read FMakeBackup write FMakeBackup;
    property ShowDeleted: Boolean read FShowDeleted write SetShowDeleted;
    property PackOnSave: Boolean read GetPackOnSave write SetPackOnSave;
    property Filter;
    property Filtered: Boolean read GetFilterActive write SetFilterActive;

    // Определяет, в какой кодировке хранятся строки в DBF-файле. Если OEM = True,
    // то будут дополнительно использоваться функции CharToOem и OemToChar
    property OEM: Boolean read FOEM write FOEM default True;
    
    property Active;
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    property OnDBFError: TDBFError read FOnDBFError write FOnDBFError;
    property OnDeleteError;
    property OnEditError;
    property OnNewRecord;
    property OnPostError;
    property OnCalcFields;
  end;

const
  //AboutInfo = 'MiTeC DBF Table 1.5 - © 1997,2002, MichaL MutL';
  AboutInfo = 'Memory DBF Table - © 2009-2010, LDS';

  DBFOK = 0;
  DBFIncorectFile = -1;
  DBFOutOfRange = -2;
  DBFWrongFieldDef = -3;
  DBFInvalidValue = -4;
  DBFNotOpened = -5;

  DBFErrorMessages: array[0..5] of string = ('OK', Err_IncorrectDBF,
    Err_AccessOutRange,
    Err_WrongFieldDef,
    Err_InValidValue,
    Err_FileNotOpen);


procedure Register;

implementation

{$IFNDEF D2009PLUS}
function CharInSet(C: Char; const CharSet: TSysCharSet): Boolean;
begin
  Result := C in CharSet;
end;
{$ENDIF}

procedure Register;
begin
  RegisterComponents('Data Access', [TMemDBFTable]);
end;

function AnsiTrimRight(const S: AnsiString): AnsiString;
var
  I: Integer;
begin
  I := Length(S);
  while (I > 0) and (S[I] <= ' ') do Dec(I);
  Result := Copy(S, 1, I);
end;

function AnsiCharPos(AChar: AnsiChar; const str: AnsiString): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Length(str) do
    if str[I] = AChar then
    begin
      Result := I;
      Exit;
    end;
end;

{TDBFAccess}

constructor TDBFAccess.Create;
begin
  inherited Create;

  FDB3 := True;
  with FDBF do
  begin
    Data := TStringList.Create;
    Fields := TList.Create;
    FileName := '';
  end;
end;

destructor TDBFAccess.Destroy;
begin
  with FDBF do
  begin
    Data.Free;
    
    ClearFieldsDefs;
    Fields.Free;
  end;
  inherited Destroy;
end;

procedure TDBFAccess.CheckRange;
begin
  if FileSize < (FDBF.RecordCount * FDBF.RecordSize + FDBF.HeaderSize) then
    raise Exception.Create(err_IncorrectDBF);

  if (FDBF.recordcount > dBase_MaxReccount) or
     (FDBF.RecordSize > dBase_MaxRecSize) or
     (FDBF.FieldCount > dBase_MaxFieldCount) then
     raise Exception.Create(err_AccessOutRange);  
end;

procedure TDBFAccess.CheckField;
  procedure RaiseAccessOutRange;
  begin
    raise Exception.Create(err_AccessOutRange);
  end;
begin
  with field do
  begin
    if Size > dBase_MaxFieldWidth then
      RaiseAccessOutRange
    else
      case fieldType of
        ftstring:
          if Decimals <> 0 then
            RaiseAccessOutRange;
        ftinteger:
          if (Size > 10) or (Decimals <> 0) then
            RaiseAccessOutRange;
        ftLargeint:
          if (Size > 30) or (Decimals <> 0) then
            RaiseAccessOutRange;
        ftfloat:
          if (Size > 30) or (Decimals > size - 2) then
            RaiseAccessOutRange
          else
            if Size + 2 < Decimals then
              RaiseAccessOutRange;
        ftdate:
          if (Size <> 8) or (Decimals <> 0) then
            RaiseAccessOutRange;
        ftboolean:
          if (Size <> 1) or (Decimals <> 0) then
            RaiseAccessOutRange;
        ftmemo:
          if (Size <> 10) or (Decimals <> 0) then
            RaiseAccessOutRange;
        ftblob:
          if (Size <> 10) or (Decimals <> 0) then
            RaiseAccessOutRange;
        ftdbaseole:
          if (Size <> 10) or (Decimals <> 0) then
            RaiseAccessOutRange;
      else
        raise Exception.Create(err_WrongFieldDef + ' - ' + string(Field.FieldName) + ': ' + IntToStr(Integer(fieldType)));
      end;
  end;
end;

procedure TDBFAccess.ReadDBFHeader(AStream: TStream);
var
  Buffer: Byte;
begin
  AStream.Seek(0, soFromBeginning);
  AStream.Read(Buffer, 1);
  AStream.Seek(0, soFromBeginning);

  if not (Buffer in [$03..$F5]) then
    raise Exception.Create(err_IncorrectDBF);

  if Buffer in [dBaseIIIPlus, dBaseIIIPlusMemo] then
  begin
    FDB3 := True;
    AStream.Read(Fdb3Header, 32); // Чтение заголовка DBF файла

    // Запоминаем структуру DBF файла
    with FDBF do
    begin
      Year := Fdb3Header.Year;
      Month := Fdb3Header.Month;
      Day := Fdb3Header.Day;
      Version := 3;
      Recordcount := Fdb3Header.Recordcount;
      HeaderSize := Fdb3Header.HeaderSize; // Область описания полей
      RecordSize := Fdb3Header.RecordSize;
      FieldCount := Pred(Pred(HeaderSize) div 32); // Определение кол-ва полей
      MDXPresent := False;
      Memo := Fdb3Header.Version = dBaseIIIPlusMemo;
      AnyMemo := Memo;
      CodePage := 0; // Кодовая страница не задана!
      Encrypted := False;
      TransProt := False;
      CheckRange(AStream.Size);
    end;
  end else
  begin
    AStream.Read(Fdb4Header, 32); // Чтение заголовка DBF файла
    FDB3 := False;
    with FDBF do
    begin
      Year := Fdb4Header.Year;
      Month := Fdb4Header.Month;
      Day := Fdb4Header.Day;
      case Fdb4Header.Version and 7 of
        3: version := 4;
      else version := 5;
      end;
      Recordcount := Fdb4Header.Recordcount;
      HeaderSize := Fdb4Header.HeaderSize;
      RecordSize := Fdb4Header.RecordSize;
      FieldCount := Pred(Pred(HeaderSize) div 32);
      mdxpresent := Fdb4Header.MDXFlag = $01;
      memo := (Fdb4Header.Version and 128) = 128;
      anymemo := (Fdb4Header.Version and 8) = 8;
      transprot := Fdb4Header.IncompleteTranstactionFlag = $01;
      encrypted := Fdb4Header.EncryptionFlag = $01;
      case Fdb4Header.LangDrvID of
        001: codepage := 437;
        002: codepage := 850;
        100: codepage := 852;
        102: codepage := 865;
        101: codepage := 866; // Русская кодовая страница ASCII в Dos
        104: codepage := 895;
        200: codepage := 1250;
        201: codepage := 1251; // Русская кодовая страница ASCII в Windows
        003: codepage := 1252;
      else
        codepage := 0;
      end;
      CheckRange(AStream.Size);
    end;
  end;
end;

procedure TDBFAccess.ReadDBFFieldDefs(AStream: TStream);
var
  i, o: word;
  b: byte;
  Field: PDBFField;
begin
  o := 1;

  AStream.Seek(32, soFromBeginning); // Пропускаем область заголовка

  if FDB3 then
  begin
    for i := 1 to FDBF.FieldCount do
    begin
      with FDBF do
      begin
        New(Field);

        try
          AStream.Read(Fdb3Field, 32); // Читаем описание очередного поля в буфер

          // Извлекаем имя поля
          b := 1;
          while (b <= 10) and (Fdb3Field.Name[b] <> #0) do
            Inc(b);

          system.Move(Fdb3Field.Name[1], Field^.FieldName[1], Pred(b));
          Field^.FieldName[0] := AnsiChar(Chr(Pred(b)));

          case Fdb3Field.FieldType of
            'C': Field^.FieldType := ftString;
            'N': if Fdb3Field.Decimals > 0 then
                Field^.FieldType := ftFloat
              else
                if Fdb3Field.Width > 10 then
                   Field^.FieldType := ftLargeint
                else
                   Field^.FieldType := ftInteger;
            'F': Field^.FieldType := ftFloat;
            'D': Field^.FieldType := ftDate;
            'L': Field^.FieldType := ftBoolean;
            'M': Field^.FieldType := ftMemo;
            'B': Field^.FieldType := ftBlob;
            'O': Field^.FieldType := ftDBaseOle;
          end;
          Field^.Size := Fdb3Field.Width;
          Field^.Decimals := Fdb3Field.Decimals;
          Field^.Offset := o;
          Field^.Indexed := Fdb3Field.SetFields = 1;
          Inc(o, Fdb3Field.Width);
          CheckField(Field^);
          Fields.Add(Field);
        except
          Dispose(Field);
          raise;
        end;
      end; // with
    end; // for i
  end else
  begin
    for i := 1 to fdbf.FieldCount do
    begin
      with fdbf do
      begin
        New(Field);
        try
          AStream.Read(Fdb4Field, 32);
          b := 1;
          while (b <= 10) and (Fdb4Field.Name[b] <> #0) do
            Inc(b);
          system.Move(Fdb4Field.Name[1], Field^.fieldName[1], Pred(b));
          Field^.fieldName[0] := AnsiChar(Chr(Pred(b)));

          case Fdb4Field.fieldType of
            'C': Field^.FieldType := ftstring;
            'N': if Fdb3Field.Decimals > 0 then
                Field^.FieldType := ftFloat
              else
                if Fdb3Field.Width > 10 then
                   Field^.FieldType := ftLargeint
                else
                   Field^.FieldType := ftInteger;
            'F': Field^.FieldType := ftfloat;
            'D': Field^.FieldType := ftdate;
            'L': Field^.FieldType := ftboolean;
            'M': Field^.FieldType := ftmemo;
            'B': Field^.FieldType := ftblob;
            'O': Field^.FieldType := ftdbaseole;
          end;
          Field^.Size := Fdb4Field.Width;
          Field^.Decimals := Fdb4Field.Decimals;
          Field^.Offset := o;
          Field^.indexed := Fdb4Field.Indexed = 1;
          Inc(o, Fdb4Field.Width);
          CheckField(Field^);
          Fields.Add(Field);
        except
          Dispose(Field);
          raise;
        end;
      end; // with
    end;
  end;
end;

procedure TDBFAccess.ReadDBFData(AStream: TStream);
var
  r, I: Integer;
  S: AnsiString;
  StrCount: Integer;
begin
  AStream.Seek(fDBF.HeaderSize, soFromBeginning);

  if FDBF.RecordSize = 0 then
    raise Exception.Create('Wrong record size');

  SetLength(S, FDBF.RecordSize);

  // Расчитываем примерное число строк
  StrCount := Round((AStream.Size - fDBF.HeaderSize) / FDBF.RecordSize) + 100;
  StrCount := Max(StrCount, 100);
  FDBF.Data.Capacity := StrCount;

  while (AStream.position + fDBF.RecordSize <= AStream.Size) do
  begin
    r := AStream.Read(S[1], fDBF.RecordSize);
    if r = FDBF.RecordSize then
    begin
      // Заменяем все символы #0 на пробелы
      for I := 1 to Length(S) do
        if S[I] = #0 then
          S[I] := ' ';
      FDBF.Data.Add(string(S));
    end;
  end;
end;

procedure TDBFAccess.WriteDB3Header;
var
  y, m, d: word;
begin
  decodedate(date, y, m, d);
  if y > 2000 then
    y := y - 2000
  else
    y := y - 1900;
  hb.Year := Y;
  hb.Month := M;
  hb.Day := D;

  AStream.Seek(0, sofrombeginning);
  AStream.Write(hb, 32);
end;

procedure TDBFAccess.WriteDB4Header;
var
  y, m, d: word;
begin
  decodedate(date, y, m, d);
  if y > 2000 then
    y := y - 2000
  else
    y := y - 1900;
  hb.Year := Y;
  hb.Month := M;
  hb.Day := D;

  AStream.Seek(0, sofrombeginning);
  AStream.Write(hb, 32);
end;

procedure TDBFAccess.WriteDBFFieldDefs;
var
  i: word;
begin
  if fdb3 then
    for i := 0 to aFields.Count - 1 do
    begin
      FillChar(Fdb3Field, SizeOf(Fdb3Field), 0);
      Move(PDBFField(aFields.items[i]).fieldName[1], Fdb3Field.Name,
        Length(PDBFField(aFields.items[i]).fieldName));
      case PDBFField(aFields.items[i]).FieldType of
        ftstring, ftDateTime: Fdb3Field.FieldType := 'C';
        ftinteger, ftFloat, ftSmallint, ftCurrency, ftBCD, ftFMTBcd: Fdb3Field.FieldType := 'N';
        ftdate: Fdb3Field.FieldType := 'D';
        ftboolean: Fdb3Field.FieldType := 'L';
        ftmemo: Fdb3Field.FieldType := 'M';
      end;
      Fdb3Field.Width := PDBFField(aFields.items[i]).size;
      Fdb3Field.Decimals := PDBFField(aFields.items[i]).Decimals;
      Fdb3Field.SetFields := byte(PDBFField(aFields.items[i]).indexed);
      AStream.Write(Fdb3Field, 32);
    end // for i
  else
    for i := 0 to aFields.Count - 1 do
    begin
      FillChar(Fdb4Field, SizeOf(Fdb4Field), 0);
      Move(PDBFField(aFields.items[i]).fieldName[1], Fdb4Field.Name,
        Length(PDBFField(aFields.items[i]).fieldName));
      case tdbffield(aFields.items[i]^).FieldType of
        ftstring, ftTimeStamp: Fdb4Field.FieldType := 'C';
        ftinteger, ftSmallint: Fdb4Field.FieldType := 'N';
        ftfloat, ftCurrency, ftBCD, ftFMTBcd: Fdb4Field.FieldType := 'F';
        ftdate: Fdb4Field.FieldType := 'D';
        ftboolean: Fdb4Field.FieldType := 'L';
        ftmemo: Fdb4Field.FieldType := 'M';
        ftblob: Fdb4Field.FieldType := 'B';
        ftdbaseole: Fdb4Field.FieldType := 'O';
      end;
      Fdb4Field.Width := PDBFField(aFields.items[i]).size;
      Fdb4Field.Decimals := PDBFField(aFields.items[i]).Decimals;
      Fdb4Field.Indexed := byte(PDBFField(aFields.items[i]).indexed);
      AStream.Write(Fdb4Field, 32);
    end // for i

end;


procedure TDBFAccess.WriteDBFData;
var
  recsize, i: Integer;
  S: char;
  CurRec: AnsiString;
  MemSize: Integer;
begin 
  recsize := 1;
  for i := 0 to afields.count - 1 do
    recsize := recsize + PDBFField(afields.items[i]).Size;

  S := flgBOF; // Разделитель между описанием полей и данными
  AStream.write(S, 1);
  if assigned(adata) then
  begin
    MemSize := AStream.Position + (AData.Count * recsize) + recsize; // Устанавливаем размер побольше
    AStream.Size := MemSize; // Сразу резервирует требуемый объем памяти
    for i := 0 to AData.Count - 1 do
    begin
      CurRec := AnsiString(AData[i]);
      if (not packonsave) or (packonsave and (CurRec[1] <> flgDeleted)) then
      begin
        AStream.write(CurRec[1], recsize);
      end;
    end;
    // Обрезаем размер стрима с учетом байта flgEOF
    AStream.Size := AStream.Position + 1;
  end;
  S := flgEOF;
  AStream.write(S, 1);
end;

procedure TDBFAccess.RaiseDBFError;
var
  s: string;
begin
  if (fresult < 0) then
    s := DBFErrorMessages[abs(fresult)]
  else
    s := Err_ErrorCode + inttostr(fresult);
  if Assigned(FOnDBFError) then
    FOnDBFError(Self, s);
  Abort;
end;

procedure TDBFAccess.LoadFromStream;
begin
  ClearFieldsDefs;
  FDBF.Data.Clear;

  ReadDBFHeader(AStream);
  ReadDBFFieldDefs(AStream);
  ReadDBFData(AStream);
end;

procedure TDBFAccess.SaveToFile;
var
  MS: TMemoryStream;
  bytear: PByteArray;
begin
  MS := TMemoryStream.Create;
  try
    if fdbf.version = 3 then
    begin
      {if fdbf.Memo then
        Fdb3Header.Version:=dbaseiiiplusmemo
      else
        Fdb3Header.Version:=dbaseiiiplus;}
      if PackOnSave then
        Fdb3Header.Recordcount := fDBF.data.Count - FDBF.DeletedCount
      else
        Fdb3Header.Recordcount := fDBF.data.count;
      Fdb3Header.HeaderSize := fDBF.HeaderSize;
      Fdb3Header.RecordSize := fDBF.RecordSize;

      bytear := @Fdb3Header;
      // Если байт кодировки еще не выставлен, то устанавливаем его
      if bytear[$1D] = 0 then
      begin
        if OEM then
          bytear[$1D] := $65  // 866
        else
          bytear[$1D] := $03; // 1251
      end;

      writedb3header(Fdb3Header, MS);
    end else
    begin
      {Fdb4Header.Version:=0;
      Fdb4Header.Version:=Fdb4Header.Version or 3;
      if fdbf.AnyMemo then
        Fdb4Header.Version:=Fdb4Header.Version or 128;
      if fdbf.Memo then
        Fdb4Header.Version:=Fdb4Header.Version or 8;
      Fdb4Header.MDXFlag:=byte(fdbf.MDXPresent);
      Fdb4Header.EncryptionFlag:=byte(fdbf.Encrypted);
      Fdb4Header.IncompleteTranstactionFlag:=byte(fdbf.TransProt);}
      if PackOnSave then
        Fdb4Header.Recordcount := fDBF.data.Count - FDBF.DeletedCount
      else
        Fdb4Header.Recordcount := fDBF.data.Count;
      Fdb4Header.HeaderSize := fDBF.HeaderSize;
      Fdb4Header.RecordSize := fDBF.RecordSize;
      writedb4header(Fdb4Header, MS);
    end;

    WriteDBFFieldDefs(fdbf.fields, MS);
    WriteDBFData(fdbf.fields, fdbf.data, MS);

    MS.SaveToFile(Filename);
  finally
    MS.Free;
  end;
end;

procedure TDBFAccess.ClearFieldsDefs;
var
  I: Integer;
begin
  for I := 0 to FDBF.Fields.Count - 1 do
    Dispose(PDBFField(FDBF.Fields[I]));
  FDBF.Fields.Clear;
end;

{TMDBFTable}

constructor TMemDBFTable.Create;
begin
  inherited create(aowner);
  FAccess := TDBFAccess.Create;
  FAccess.OnDbfError := DBFError;
  FAbout := AboutInfo;
  FVersion := 'Unknown';
  FOEM := True;
end;

function TMemDBFTable.GetField(Index: Integer): TDBFField;
begin
  result := PDBFField(FStructure.fields[index])^;
end;

procedure TMemDBFTable.DBFError(Sender: TObject; ErrorMsg: string);
begin
  if Assigned(FOnDBFError) then
    FOnDBFError(Self, ErrorMsg) else
    MessageBox(0, PChar(ErrorMsg), Err_Stop, mb_Ok or mb_IconStop or
      mb_DefButton1);
end;

procedure TMemDBFTable.SetFilename;
begin
  if ffilename <> value then
  begin
    if active then
      raise Exception.Create(err_ChangeFileName)
    else
      ffilename := value;
  end;
end;

procedure TMemDBFTable.SetAbout;
begin
  // none
end;

procedure TMemDBFTable.InternalOpen;
var
  I: Integer;
  y: word;
  MS: TMemoryStream;
begin
  FieldDefs.Clear;
  if Assigned(MemDataHeader) then
    MS := MemDataHeader
  else
    MS := TMemoryStream.Create;
  try
    if MemDataHeader = nil then
      MS.LoadFromFile(FFileName);
    MS.Position := 0;
    FAccess.LoadFromStream(MS);

  finally
    MS.Free;
    MemDataHeader := nil;
  end;

  //FAccess.LoadFromFile(FFileName);
  FStructure := FAccess.Structure;
  FData := FStructure.Data;
  FStructure.DeletedCount := 0;

  for I := 1 to FData.Count do
  begin
    FData.Objects[I - 1] := Pointer(I);
    if PChar(FData[i - 1])[0] = flgDeleted then
      Inc(FStructure.Deletedcount);
  end;

  if WithMemo then
  begin
    FMemoFilename := ChangeFileExt(FFileName, '.dbt');
    FMemoFile := TFileStream.Create(FMemoFilename, fmOpenReadWrite);
    FMemoFile.Seek(0, soFromBeginning);
    FMemoFile.ReadBuffer(DBTHeader, Sizeof(DBTHeader));
  end;

  fversion := 'dBase ?';
  case FStructure.version of
    3: fversion := 'dBase III+';
    4: fversion := 'dBase IV';
    5: fversion := 'dBase/Win';
  end;

  if FStructure.Year > 50 then
    y := FStructure.Year + 1900
  else
    y := FStructure.Year + 2000;

  FLastUpdate := datetostr(encodedate(y, FStructure.month, FStructure.day));
  FLastBookmark := FData.Count;
  FCurRec := -1;
  frecsize := 1;
  for i := 0 to FStructure.fields.count - 1 do
    frecsize := frecsize + PDBFField(FStructure.fields[i]).size;
  FRecInfoOfs := frecsize;
  FRecBufSize := FRecInfoOfs + SizeOf(TRecInfo);
  BookmarkSize := SizeOf(Integer);
  InternalInitFieldDefs;
  if DefaultFields then
    CreateFields;
  BindFields(True);
end;


procedure TMemDBFTable.InternalCancel;
begin
  FModified := False;
end;

procedure TMemDBFTable.InternalClose;
begin
  FreeAndNil(FMemoFile);

  if DefaultFields then
    DestroyFields;
    
  FLastBookmark := 0;
  FCurRec := -1;
end;

function TMemDBFTable.IsCursorOpen: Boolean;
begin
  result := Assigned(FData);
end;

procedure TMemDBFTable.InternalInitFieldDefs;
var
  i, s: Integer;
begin
  FieldDefs.Clear;
  with FStructure.fields do
    for i := 0 to FStructure.fieldcount - 1 do
    begin
      if PDBFField(items[i]).fieldtype in [ftstring, ftmemo] then
        s := PDBFField(items[i]).size
      else
        s := 0;
      TFieldDef.Create(FieldDefs, string(PDBFField(items[i]).FieldName),
        PDBFField(items[i]).FieldType, s, False, i + 1)
    end;
end;

procedure TMemDBFTable.InternalHandleException;
begin
//  Application.HandleException(Self);
end;

procedure TMemDBFTable.InternalGotoBookmark(Bookmark: Pointer);
var
  Index: Integer;
begin
  Index := FData.IndexOfObject(TObject(PInteger(Bookmark)^));
  if Index <> -1 then
    FCurRec := Index
  else
    DatabaseError(Err_BookMark);
end;

procedure TMemDBFTable.InternalSetToRecord(Buffer: {$IFDEF D2009PLUS}TRecordBuffer{$ELSE}PChar{$ENDIF});
begin
  InternalGotoBookmark(@PRecInfo(Buffer + FRecInfoOfs).Bookmark);
end;

function TMemDBFTable.GetBookmarkFlag(Buffer: {$IFDEF D2009PLUS}TRecordBuffer{$ELSE}PChar{$ENDIF}): TBookmarkFlag;
begin
  Result := PRecInfo(Buffer + FRecInfoOfs).BookmarkFlag;
end;

procedure TMemDBFTable.SetBookmarkFlag(Buffer: {$IFDEF D2009PLUS}TRecordBuffer{$ELSE}PChar{$ENDIF}; Value: TBookmarkFlag);
begin
  PRecInfo(Buffer + FRecInfoOfs).BookmarkFlag := Value;
end;

procedure TMemDBFTable.GetBookmarkData(Buffer: {$IFDEF D2009PLUS}TRecordBuffer{$ELSE}PChar{$ENDIF}; Data: Pointer);
begin
  PInteger(Data)^ := PRecInfo(Buffer + FRecInfoOfs).Bookmark;
end;

procedure TMemDBFTable.SetBookmarkData(Buffer: {$IFDEF D2009PLUS}TRecordBuffer{$ELSE}PChar{$ENDIF}; Data: Pointer);
begin
  PRecInfo(Buffer + FRecInfoOfs).Bookmark := PInteger(Data)^;
end;

function TMemDBFTable.GetRecordSize: Word;
begin
  Result := FRecSize;
end;

function TMemDBFTable.AllocRecordBuffer: {$IFDEF D2009PLUS}TRecordBuffer{$ELSE}PChar{$ENDIF};
begin
  GetMem(Result, FRecBufSize);
end;

procedure TMemDBFTable.FreeRecordBuffer(var Buffer: {$IFDEF D2009PLUS}TRecordBuffer{$ELSE}PChar{$ENDIF});
begin
  FreeMem(Buffer);
end;

function TMemDBFTable.GetRecord(Buffer: {$IFDEF D2009PLUS}TRecordBuffer{$ELSE}PChar{$ENDIF}; GetMode: TGetMode; DoCheck: Boolean): TGetResult;
var
  accept: Boolean;
  sCopy: AnsiString;
begin
  Result := grOk;

  if FData.Count < 1 then
    Result := grEOF
  else
  begin
    repeat
      case GetMode of
        gmNext:
          if FCurRec >= RecordCount - 1 then
            result := grEOF
          else
            Inc(FCurRec);
        gmPrior:
          if FCurRec <= 0 then
            result := grBOF
          else
            Dec(FCurRec);
        gmCurrent:
          if (FCurRec < 0) or (FCurRec >= RecordCount) then
            result := grError;
      end; // case

      if result = grOK then
      begin
        sCopy := AnsiString(FData[FCurRec]);
        StrLCopy(PAnsiChar(Buffer), PAnsiChar(sCopy), frecsize);
        ClearCalcFields(Buffer);
        GetCalcFields(Buffer);
        with PRecInfo(Buffer + FRecInfoOfs)^ do
        begin
          BookmarkFlag := bfCurrent;
          Bookmark := Integer(FData.Objects[FCurRec]);
        end;
      end else
        if (result = grError) and DoCheck then
          DatabaseError(Err_NoRecords);

      accept := (fshowdeleted or (not fshowdeleted and (AnsiChar(Buffer[0]) <> flgDeleted)));

      if Filtered or FActiveFilter then
        accept := accept and ProcessFilter(PAnsiChar(Buffer));

      if (GetMode = gmCurrent) and not Accept then
        Result := grError;

    until (Result <> grOK) or Accept;
  end;

  if ((Result = grEOF) or (Result = grBOF)) and
     (Filtered or FActiveFilter) and not (ProcessFilter(PAnsiChar(Buffer))) then
    Result := grError;
end;

procedure TMemDBFTable.InternalInitRecord(Buffer: {$IFDEF D2009PLUS}TRecordBuffer{$ELSE}PChar{$ENDIF});
begin
  FillChar(Buffer^, RecordSize, 0);
end;

function TMemDBFTable.GetFieldData(Field: TField; Buffer: Pointer): Boolean;
begin
  if (FData.count = 0) and (fcurrec = -1) and (State = dsBrowse) then
    FillChar(ActiveBuffer^, RecordSize, 0);

  if not (Field.DataType in [ftMemo, ftGraphic, ftBlob, ftDBaseOle]) then
    Result := GetData(Field, PAnsiChar(Buffer), PAnsiChar(ActiveBuffer))
  else
    Result := True;
end;

procedure TMemDBFTable.SetFieldData(Field: TField; Buffer: Pointer);
var
  Offs, fs: Integer;
  i, j, p: Integer;
  dt: TDateTime;     
  BufStr, S: AnsiString;
begin
  if (Field.FieldNo >= 0) then
  begin
    // Если буффер под активную запись еще ни разу не использовался, то
    // забиваем его пробелами
    if AnsiChar(ActiveBuffer[0]) = #0 then
      FillChar(activeBuffer^, RecordSize, 32);

    offs := PDBFField(FStructure.fields.Items[Field.fieldno - 1]).Offset;
    fs := PDBFField(FStructure.fields.Items[Field.fieldno - 1]).Size;

    // Если выходной буфер задан, то копируем из него данные
    if Assigned(Buffer) then
    begin
      case Field.DataType of
        ftString:
          begin
            BufStr := AnsiString(PAnsiChar(Buffer));
            j := Length(BufStr); // Кол-во символов в строке. Обычно символов меньше, чем max
            SetLength(BufStr, fs); // Устанавливаем длину строки max
            if j < fs then
            begin
              for I := j + 1 to fs do // Забиваем недостающие символы пробелами
                BufStr[I] := ' ';
            end;                 

            if OEM then
              AnsiToOemBuff(PAnsiChar(BufStr), PAnsiChar(BufStr), fs);
          end;

        ftFloat:
          begin
            Str(pdouble(Buffer)^: fs:
              PDBFField(FStructure.fields.Items[Field.fieldno - 1]).Decimals, S);

            j := Length(S);
            if j >= fs then
            begin
              SetLength(S, fs); // Если длина строки слишком большая
              BufStr := S;
            end else
            begin
              SetLength(BufStr, fs);
              for I := 1 to fs do
                if I <= fs - j then
                  BufStr[I] := ' '
                else
                  BufStr[I] := S[I - (fs - j)];
            end;

            p := AnsiCharPos(AnsiChar(DecimalSeparator), BufStr);

            if (p > 0) then
              BufStr[p] := '.'; // Разделитель должен быть точкой!
          end;

        ftInteger, ftMemo:
          begin
            S := AnsiString(IntToStr(pinteger(Buffer)^));
            j := Length(S);
            
            if j >= fs then
            begin
              SetLength(S, fs); // Если длина строки слишком большая
              BufStr := S;
            end else
            begin
              SetLength(BufStr, fs);
              for I := 1 to fs do
                if I <= fs - j then
                  BufStr[I] := ' '
                else
                  BufStr[I] := S[I - (fs - j)];
            end;
          end;
          
        ftDate:
          begin
            if fs <> 8 then
              raise Exception.Create('Buffer must be 8 chars for date');

            //BufStr := FormatDateTime('yyyymmdd', PDateTime(Buffer)^); - не работает!!!

            j := pinteger(Buffer)^ - 693594;
            PDouble(@dt)^ := j;
            BufStr := AnsiString(FormatDateTime('yyyymmdd', dt));
          end;
        ftBoolean:
          begin
            if fs <> 1 then
              raise Exception.Create('Buffer must be 1 char for boolean');

             if PWordBool(Buffer)^ then
                BufStr := 'T'
              else
                BufStr := 'F';
          end;

        ftgraphic, ftblob: ;
      else
        raise Exception.Create('Unexpected field type.');
      end; // case
    end else // Запрос на очистку данных. Всю строку забиваем пробелами
    begin
      SetLength(BufStr, fs);
      for i := 1 to fs do
        BufStr[i] := ' ';
    end;

    Move(BufStr[1], activebuffer[offs], fs);
    FModified := True;

    DataEvent(deFieldChange, Longint(Field));
  end;
end;

procedure TMemDBFTable.InternalFirst;
begin
  FCurRec := -1;
end;

procedure TMemDBFTable.InternalLast;
begin
  FCurRec := FData.Count;
end;

procedure TMemDBFTable.InternalPost;
begin
  if (State = dsEdit) then
  begin
    FData[FCurRec] := string(PAnsiChar(ActiveBuffer));
  end else
  begin
    Inc(FLastBookmark);
    if (State = dsInsert) and (FCurRec < 0) then
      FCurRec := 0;
    FData.InsertObject(FCurRec, string(PAnsiChar(ActiveBuffer)), Pointer(FLastBookmark));
  end;
  FModified := False;
end;

procedure TMemDBFTable.InternalAddRecord(Buffer: Pointer; Append: Boolean);
begin
  FModified := True;
  Inc(FLastBookmark);
  if Append then
    InternalLast;
  FData.InsertObject(FCurRec, string(PAnsiChar(Buffer)), Pointer(FLastBookmark));
end;

procedure TMemDBFTable.InternalDelete;
begin
{  FData.Delete(FCurRec);
  if FCurRec >= FData.Count then
    Dec(FCurRec);
  if fcurrec=-1 then
    FillChar(activeBuffer^,RecordSize,0);}
  PChar(FData[FCurRec])[0] := flgDeleted;
  PAnsiChar(ActiveBuffer)[0] := flgDeleted;
  Inc(FStructure.DeletedCount);
  FModified := True;
  //refresh;
end;

function TMemDBFTable.GetRecordCount: Longint;
begin
  if IsCursorOpen then
    result := FData.Count
  else
    Result := 0;
end;

function TMemDBFTable.GetRecNo: Longint;
begin
  UpdateCursorPos;
  if (FCurRec = -1) and (RecordCount > 0) then
    result := 1 else
    result := FCurRec + 1;
end;

procedure TMemDBFTable.SetRecNo(Value: Integer);
begin
  if (Value >= 0) and (Value < FData.Count) then
  begin
    FCurRec := Value - 1;
    Resync([]);
  end;
end;

procedure TMemDBFTable.CreateTable;
var
  hb: TdBaseIIIPlus_Header;
  i: Integer;
  AFields: TList;
  pField: PDBFField;
  Offset: Integer;
  MS: TMemoryStream;
begin
  if Fields = nil then // Если поля не заданы, то используем FieldDefs
    AFields := TList.Create
  else
    AFields := Fields; // В функцию передано описание требуемых полей

  try
    with FAccess do
    begin
      if (AFields.Count = 0) and (FieldDefs.Count > 0) then
      begin
        // Заполняем список полей
        Offset := 1;
        for I := 0 to FieldDefs.Count - 1 do
        begin
          New(pField);
          AFields.Add(pField);
          pField.FieldName := AnsiString(Copy(AnsiUpperCase(FieldDefs[I].Name), 1, 10));
          pField.FieldType := FieldDefs[I].DataType;
          pField.Decimals := 0; 
          case FieldDefs[I].DataType of
            ftString: pField.Size := FieldDefs[I].Size;
            ftFloat, ftCurrency:
              begin
                pField.Size := FieldDefs[I].Size;
                if pField.Size = 0 then
                  pField.Size := 20;

                pField.Decimals := FieldDefs[I].Precision;
                if pField.Decimals = 0 then // Для вещественных типов нужно задать
                  pField.Decimals := 4;     // несколько знаков после запятой
              end;

            ftBCD, ftFMTBcd:
              begin
                pField.Size := 20;
                pField.Decimals := 4;
              end; 

            ftDate: pField.Size := 8;
            ftDateTime: pField.Size := 30; // Дата и время в стандартном формате
            ftInteger, ftSmallint, ftLargeInt:
              begin
                pField.FieldType := ftInteger;
                pField.Size := 11;
              end;
            ftBoolean: pField.Size := 1;
          else
            raise Exception.Create('CreateTable -> Invalid field type: ' + IntToStr(Integer(FieldDefs[I].DataType)));
          end;

          if pField.Decimals = 0 then
            pField.Decimals := FieldDefs[I].Precision;  
          
          pField.Offset := Offset;
          pField.Indexed := False; // ???
          Inc(Offset, pField.Size);
        end;
      end;


      MS := TMemoryStream.Create;
      try
        HB.Recordcount := 0;
        HB.HeaderSize := Succ(Succ(AFields.Count) * 32);
        hb.RecordSize := 1;
        hb.Version := $03;
        FillChar(hb.Reserved1, 3, 0);
        FillChar(hb.LANRsvd, 13, 0);
        FillChar(hb.Reserved2, 4, 0);

        for i := 0 to AFields.count - 1 do
          hb.recordsize := hb.recordsize + PDBFField(AFields.items[i]).size;

        writedb3header(hb, MS);
        writedbffielddefs(AFields, MS);
        writedbFData(AFields, nil, MS); // Данных нет!

        if FileName <> '' then
        begin
          MS.SaveToFile(FileName);
          SetFilename(FileName);
        end;

      finally
        if FileName = '' then
          MemDataHeader := MS
        else
          MS.Free;
      end;
    end;
  finally
    // Уничтожаем временный список описаний полей
    if Fields = nil then
    begin
      for I := 0 to AFields.Count - 1 do
        Dispose(PDBFField(AFields[i]));
      AFields.Free;
    end;
  end;
end;

function TMemDBFTable.FindKey(const KeyValues: array of const): Boolean;
var
  i: Integer;
begin
  result := false;
  for i := 0 to FData.Count - 1 do
    if pos(string(KeyValues[0].VPChar), FData[i]) > 0 then
    begin
      result := true;
      FCurRec := i;
      resync([]);
      break;
    end;
end;

procedure TMemDBFTable.Save;
var
  bakfile: string;
  AFile: string;
begin
  AFile := AFileName;
  if AFile = '' then
    AFile := FFileName;
  if AFile = '' then
    raise Exception.Create('Can not save to file. File name requested');

  if fmakebackup then
  begin
    bakfile := changefileext(AFile, '.~' + Copy(extractfileext(AFile), 2, 255));
    if fileexists(bakfile) then
      deletefile(bakfile);
    renamefile(AFile, bakfile);
  end;
  with FAccess do
  begin
    Structure := FStructure;
    PackOnSave := FPackOnSave;

    SaveToFile(AFile, OEM);
  end;
end;

procedure TMemDBFTable.Zap;
var
  i: Integer;
begin
  FModified := True;
  for i := 0 to FData.count - 1 do
    delete;
  FillChar(activeBuffer^, RecordSize, 0);
end;

procedure TMemDBFTable.GetFields;
begin
  fields := FStructure.fields;
end;

function TMemDBFTable.Locate(const KeyFields: string;
  const KeyValues: Variant; Options: TLocateOptions): Boolean;
var
  i, j, a, n: Integer;
  fn, s, k, v: string;
  kv: variant;
  p: PAnsiChar;
  found: Boolean;
begin
  kv := keyvalues;
  if not varisarray(kv) then
    kv := vararrayof([keyvalues]);
  n := vararrayhighbound(kv, 1) + 1;
  if length(trim(keyfields)) > 0 then
  begin
    result := false;
    {$IFDEF D2009PLUS}
    p := AnsiStrAlloc(dBase_MaxFieldWidth);
    {$ELSE}
    p := StrAlloc(dBase_MaxFieldWidth); // Буффер под значение для поиска
    {$ENDIF}
    try
      for a := 0 to FData.count - 1 do
      begin
        j := 1;
        for i := 0 to n - 1 do
        begin
          fn := ExtractFieldName(keyfields, j);
          GetData(FieldByName(fn), p, PAnsiChar(AnsiString(FData[a])));

          case fieldbyname(fn).datatype of
            ftstring:
              begin
                v := string(p);
                if loCaseInsensitive in Options then
                begin
                  s := AnsiUpperCase(v);
                  k := AnsiUpperCase(kv[i]);
                end else
                begin
                  s := v;
                  k := kv[i];
                end;

                if loPartialKey in Options then
                  found := (pos(k, s) = 1)
                else
                  found := (k = s);
              end;
            ftInteger:
              begin
                found := PInteger(p)^ = kv[i];
              end;
            ftFloat:
              begin
                found := SameValue(PDouble(p)^, kv[i]);
              end;
            ftBoolean:
              begin
                found := PWordBool(p)^ = kv[i];
              end;   
          else
            found := False; // Нельзя проверить по неизвестному типу данных
            //found := (v = kv[i]);
          end;
            
          result := found;
          if not found then
            break;
        end;
        if result then
        begin
          fcurrec := a;
          resync([]);
          break;
        end;
      end;
    finally
      strdispose(p);
    end;      
  end else
    result := false;
end;

function TMemDBFTable.GetData(Field: TField; var Value: PAnsiChar; Buffer: PAnsiChar):
  Boolean;
var
  Offs: Integer;
  s: string;
  Buf: PAnsiChar;
  sAnsi: AnsiString;
  i, j, p: Integer;
  d: Double;
  dt: TDateTime;
  pFielf: PDBFField;
  i64: int64;
begin
  Result := false;

  if RecordCount > 0 then
    Buf := Buffer
  else
    Buf := PAnsiChar(ActiveBuffer);

  if (not IsEmpty) and (Field.FieldNo > 0) and
    (Assigned(Buffer)) and (Assigned(Buf)) then
  begin
    pFielf := PDBFField(FStructure.fields.Items[Field.fieldno - 1]);
    offs := pFielf.Offset;

    if Value = nil then
    begin
      SetString(s, PAnsiChar(@Buf[offs]), pFielf.Size);
      s := Trim(s);
      Result := s <> '';
      Exit;
    end;

    case Field.DataType of
      ftString: // value: AnsiString
        begin
          SetString(sAnsi, PAnsiChar(@Buf[offs]), pFielf.Size);
          sAnsi := AnsiTrimRight(sAnsi);

          if sAnsi <> '' then
          begin
            if OEM then
              OemToCharBuffA(PAnsiChar(sAnsi), PAnsiChar(value), Length(sAnsi) + 1) // "+ 1" - нужно, чтобы копировался терминальный 0
            else
              Move(sAnsi[1], value^, Length(sAnsi) + 1);
          end else
            value[0] := #0;    

          Result := True;
        end;
      ftFloat, ftInteger, ftLargeInt:
        begin
          SetString(s, PAnsiChar(@Buf[offs]), pFielf.Size);

          s := Trim(s);
          if s = '' then
            Result := false
          else
          begin
            if Field.DataType = ftfloat then
            begin
              p := pos('.', s);
              if (p > 0) then
                s[p] := DecimalSeparator;

              if TryStrToFloat(S, d) then
                result := true
              else
              begin
                d := 0;
                result := false;
              end;

              PDouble(value)^ := d;
            end;
            if Field.DataType = ftInteger then
            begin
              if TryStrToInt(s, i) then
                 result := true
              else
              begin
                i := 0;
                result := false;
              end;
              Pinteger(value)^ := i;
            end;
            if Field.DataType = ftLargeInt then
            begin
              if TryStrToInt64(s, i64) then
                 result := true
              else
              begin
                i64 := 0;
                result := false;
              end;
              Pint64(value)^ := i64;
            end;
          end;
        end;
      ftDate:
        begin
          SetString(s, PAnsiChar(@Buf[offs]), pFielf.Size);
          if (trim(s) = '') or (s = '00000000') then
            result := false
          else
          begin
            if TryEncodeDate(StrToInt(Copy(s, 1, 4)), StrToInt(Copy(s, 5, 2)), StrToInt(Copy(s, 7, 2)), dt) then
            begin
              j := Trunc(PDouble(@dt)^) + 693594;
              pinteger(value)^ := j;
              result := true;
            end else
              result := false;      
          end;
        end;
      ftBoolean:
        begin
          result := true;
          if Buf[offs] in ['S', 'T', 'Y'] then
            PWordBool(value)^ := True
          else
            if Buf[Offs] in ['N', 'F'] then
              PWordBool(value)^ := false
            else
              result := false;
        end;
      ftMemo, ftgraphic, ftblob, ftdbaseole:
        begin
          SetString(s, PAnsiChar(@Buf[offs]), pFielf.Size);
          s := TrimRight(s);

          if s = '' then
            Result := false
          else
          begin
            Result := True;
            try
              i := StrToint(s);
            except
              i := 0;
              result := false;
            end;
            Pinteger(value)^ := i;
          end;
        end;
    else
      raise Exception.Create('Unexpected field type.');
    end; // case
  end;
end;

procedure TMemDBFTable.UnDelete;
begin
  PAnsiChar(activebuffer)[0] := flgUndeleted;
  PChar(FData[FCurRec])[0] := flgUndeleted;
  Dec(FStructure.DeletedCount);
  FModified := True;
  //refresh;
end;

function TMemDBFTable.GetDeleted: Boolean;
begin
  Result := PAnsiChar(activebuffer)[0] = flgDeleted;
end;

procedure TMemDBFTable.SetShowDeleted(const Value: Boolean);
begin
  if FShowDeleted <> Value then
  begin
    FShowDeleted := Value;
    if Active then
      refresh;
  end;
end;

{function TMemDBFTable.GetFieldPointer(Buffer: PChar; Fields: TField): PChar;
begin
  Result := Buffer;
  if Buffer = nil then
    exit;
  inc(Result, PDBFField(FStructure.fields.items[fields.fieldno - 1]).offset);
end;}

function TMemDBFTable.GetActiveRecordBuffer: PAnsiChar;
begin
  if State = dsBrowse then
  begin
    if IsEmpty then
      Result := nil
    else
      Result := PAnsiChar(ActiveBuffer);
  end else
    Result := PAnsiChar(ActiveBuffer);
end;

function TMemDBFTable.HasMemo: Boolean;
var
  i: Integer;
begin
  result := false;
  for i := 0 to fieldcount - 1 do
    if originalfields[i].FieldType = ftmemo then
    begin
      result := true;
      break;
    end;
end;

type
  TCompareType = (ctEqual, ctLess, ctMore, ctNotEqual, ctLessOrEqual, ctMoreOrEqual);

function TMemDBFTable.ProcessFilter(Buffer: PAnsiChar): Boolean;
var
  FilterExpresion: string;
  PosComp, i: Integer;
  FName: string;
  FieldPos, fs: Integer;
  FieldOffset: Integer;
  FieldText: string;
  sTemp: AnsiString;
  CType: TCompareType;
  AField: PDBFField;
  FilterText: string;
  Float1, Float2: Double;
  Bool1, Bool2: Boolean;
  Date1, Date2: TDateTime;
begin
  FilterExpresion := Filter;

  Result := True;

  PosComp := Pos('>=', FilterExpresion);
  if PosComp > 0 then
  begin
    CType := ctMoreOrEqual;
  end else
  begin
    PosComp := Pos('<=', FilterExpresion);
    if PosComp > 0 then
    begin
      CType := ctLessOrEqual
    end else
    begin
      PosComp := Pos('<>', FilterExpresion);
      if PosComp > 0 then
      begin
        CType := ctNotEqual
      end else
      begin
        PosComp := Pos('>', FilterExpresion);
        if PosComp > 0 then
        begin
          CType := ctMore
        end else
        begin
          PosComp := Pos('<', FilterExpresion);
          if PosComp > 0 then
          begin
            CType := ctLess
          end else
          begin
            PosComp := Pos('=', FilterExpresion);
            if PosComp > 0 then
            begin
              CType := ctEqual
            end else
            begin
              Exit;
            end;
          end;
        end;
      end;
    end;
  end;

  // Определяем имя поля, используемого в фильре
  FName := Trim(Copy(FilterExpresion, 1, PosComp - 1));

  // Если поле не существует, то выходим
  FieldPos := FieldDefs.IndexOf(FName);
  if FieldPos < 0 then Exit;

  AField := PDBFField(FStructure.fields.Items[fieldpos]);

  // Начало данных для этого поля
  FieldOffset := AField.offset;
  fs := AField.Size;

  // Извлекаем содержимое поля в FieldText
  SetString(FieldText, PAnsiChar(@Buffer[FieldOffset]), fs);

  // Переконвертируем при необходимости
  if (AField.FieldType = ftString) and (OEM) then
  begin
    sTemp := AnsiString(FieldText);
    OemToAnsiBuff(PAnsiChar(sTemp), PAnsiChar(sTemp), fs);
    FieldText := string(sTemp);
  end;

  FieldText := Trim(FieldText);

  // Определяем текст фильтра
  if CType in [ctEqual, ctLess, ctMore] then
    FilterText := Copy(FilterExpresion, PosComp + 1, MAXSHORT)
  else
    FilterText := Copy(FilterExpresion, PosComp + 2, MAXSHORT);

  FilterText := Trim(FilterText);

  case AField.FieldType of
    ftString:
    begin
      if (foCaseInsensitive in FilterOptions) then
      begin
        FilterText := AnsiUpperCase(FilterText);
        FieldText := AnsiUpperCase(FieldText);
      end;

      case CType of
        ctEqual:
          begin
            if (foNoPartialCompare in FilterOptions) then
              Result := FieldText = FilterText
            else
              Result := Pos(FilterText, FieldText) > 0;
          end;
        
        ctMore: Result := FieldText > FilterText;
        ctLess: Result := FieldText < FilterText;
        ctNotEqual: Result := FieldText <> FilterText;
        ctLessOrEqual: Result := FieldText <= FilterText;
        ctMoreOrEqual: Result := FieldText >= FilterText;
      end;
    end;

    ftFloat, ftInteger:
    begin
      // Заменяем разделитель "." или "," на DecimalSeparator
      i := LastDelimiter(FieldText, '.,');
      if i > 0 then
        FieldText[i] := DecimalSeparator;

      i := LastDelimiter(FilterText, '.,');
      if i > 0 then
        FilterText[i] := DecimalSeparator;

      if TryStrToFloat(FieldText, Float1) and TryStrToFloat(FilterText, Float2) then
      begin
      case CType of
        ctEqual: Result := Float1 = Float2;
        ctMore: Result := Float1 > Float2;
        ctLess: Result := Float1 < Float2;
        ctNotEqual: Result := Float1 <> Float2;
        ctLessOrEqual: Result := Float1 <= Float2;
        ctMoreOrEqual: Result := Float1 >= Float2;
      end;
      end else
        Result := False;
    end;

    ftBoolean:
    begin
      Bool1 := (Length(FieldText) > 0) and CharInSet(FieldText[1], ['T', 't', 'Y', 'y', '1']);
      Bool2 := (Length(FilterText) > 0) and CharInSet(FilterText[1], ['T', 't', 'Y', 'y', '1']);
      case CType of
        ctEqual: Result := Bool1 = Bool2;
        ctMore: Result := Bool1 > Bool2;
        ctLess: Result := Bool1 < Bool2;
        ctNotEqual: Result := Bool1 <> Bool2;
        ctLessOrEqual: Result := Bool1 <= Bool2;
        ctMoreOrEqual: Result := Bool1 >= Bool2;
      end;
    end;

    ftDate:
    begin
      Result := False;
      if Length(FieldText) = 8 then
      begin
        if TryEncodeDate(
          StrToIntDef(Copy(FieldText, 1, 4), -1),
          StrToIntDef(Copy(FieldText, 5, 2), -1),
          StrToIntDef(Copy(FieldText, 7, 2), -1), Date1) then
        begin
          if TryStrToDate(FilterText, Date2) then
          begin
            case CType of
              ctEqual: Result := Date1 = Date2;
              ctMore: Result := Date1 > Date2;
              ctLess: Result := Date1 < Date2;
              ctNotEqual: Result := Date1 <> Date2;
              ctLessOrEqual: Result := Date1 <= Date2;
              ctMoreOrEqual: Result := Date1 >= Date2;
            end;
          end;
        end;
      end;
    end;
  else
    Result := False; // Неучтенный тип поля
  end; // CASE FieldType
end;

function TMemDBFTable.FindRecord(Restart, GoForward: Boolean): Boolean;
var
  Status: Boolean;
begin
  CheckBrowseMode;
  DoBeforeScroll;
  UpdateCursorPos;
  CursorPosChanged;
  try
    if GoForward then
    begin
      if Restart then
        First;
      if Filtered then
        fActiveFilter := True;
      Status := GetNextRecord;
    end else
    begin
      if Restart then
        Last;
      if Filtered then
        fActiveFilter := True;
      Status := GetPriorRecord;
    end;
  finally
    if Filtered then
      fActiveFilter := False;
  end;
  Result := Status;
  if Result then
    DoAfterScroll;
end;

procedure TMemDBFTable.SetFilterActive(const Value: Boolean);
begin
  SetFiltered(Value);
  if Active then
    refresh;
end;

function TMemDBFTable.GetFilterActive: Boolean;
begin
  Result := inherited Filtered;
end;

function TMemDBFTable.GetMemoData(Field: TField): string;
var
  TmpS: string;
  Buff: array[1..512] of Char;
  Flag: Boolean;
  Block: pinteger;
begin
  Result := '';
  if assigned(FMemofile) then
  try
    TmpS := '';
    Flag := false;
    new(Block);
    try
      getdata(Field, PAnsiChar(block), PAnsiChar(activebuffer));
      FMemoFile.Seek(Block^ * 512, soFromBeginning);
      while (not Flag) do
      begin
        if FMemoFile.Read(Buff, 512) < 512 then
          Flag := True;
        if Pos(#$1A#$1A, Buff) > 0 then
        begin
          TmpS := TmpS + Copy(Buff, 1, Pos(#$1A#$1A, Buff) - 1);
          Flag := True;
        end else
          TmpS := TmpS + Copy(Buff, 1, Pos(#$1A, Buff) - 1);
      end;
      while Pos(#$8D, TmpS) > 0 do
        TmpS[Pos(#$8D, TmpS)] := #$D;
      Result := TmpS;
    finally
      dispose(block);
    end;
  except
    on E: Exception do
      raise Exception.Create('Error occured while reading memo data. ' + E.Message);
  end;
end;

procedure TMemDBFTable.SetMemoData(Field: TField; Text: string);
var
  TmpL: Longint;
  Block: pinteger;
  s: string;
begin
  if assigned(FMemofile) then
  begin

    new(Block);
    try
      Block^ := DBTHeader.NextBlock;
      SetFieldData(Field, PChar(Block));
      FMemoFile.Seek(-1, soFromEnd);
      s := #$1A#$1A;
      for TmpL := 1 to Length(s) do
        FMemoFile.write(s[TmpL], 1);
      FMemoFile.Seek(DBTHeader.NextBlock * 512, soFromBeginning);
      Text := Text + #$1A#$1A;
      for TmpL := 1 to Length(Text) do
        FMemoFile.Write(Text[TmpL], 1);
      inc(DBTHeader.NextBlock);
    finally
      dispose(block);
    end;
    
    FModified := True;
  end;
end;

{function TMDBFTable.GetBLOBData(Field: TField): TMemoryStream;
var
  p :pchar;
  Buff :PChar;
  Flag :Boolean;
  Block :pinteger;
begin
  if assigned(FMemofile) then
  try
    result:=tmemorystream.create;
    buff:=stralloc(512);
    Flag:=false;
    new(Block);
    getdata(Field,PChar(block),activebuffer);
    FMemoFile.Seek(Block^*512,soFromBeginning);
    while (not Flag) do begin
      if FMemoFile.Read(Buff,512)<512 then
        Flag:=True;
      p:=StrPos(Buff,#$1A#$1A);
      if assigned(p) then begin
        strlcopy(buff,buff,strlen(buff)-strlen(p)-1);
        Flag:=True;
      end else begin
        p:=strPos(#$1A,Buff);
        strlcopy(buff,buff,strlen(buff)-strlen(p)-1);
      end;
    end;
    result.setsize(strlen(buff));
    result.write(buff,strlen(buff));
    dispose(block);
    strdispose(buff);
  except
    raise Exception.Create('Error occured while reading BLOB data.');
  end;
end;

procedure TMDBFTable.SetBLOBData(Field: TField; BLOB: TMemoryStream);
begin

end;}

procedure TMemDBFTable.InternalInsert;
begin
  FModified := True;
end;

function TMemDBFTable.GetCodePage: word;
begin
  Result := FStructure.CodePage;
end;

function TMemDBFTable.GetDeletedCount: Integer;
begin
  Result := FStructure.DeletedCount;
end;

function TMemDBFTable.GetEncrypted: Boolean;
begin
  Result := FStructure.Encrypted;
end;

function TMemDBFTable.GetPackOnSave: Boolean;
begin
  Result := FAccess.PackOnSave;
end;

function TMemDBFTable.GetTransactionProtected: Boolean;
begin
  Result := FStructure.TransProt;
end;

function TMemDBFTable.GetWithMemo: Boolean;
begin
  Result := FStructure.Memo;
end;

procedure TMemDBFTable.SetPackOnSave(const Value: Boolean);
begin
  FAccess.PackOnSave := Value;
end;

destructor TMemDBFTable.Destroy;
begin
  FAccess.Free;
  FData := nil;
  FreeAndNil(MemDataHeader);
  inherited;
end;

procedure TMemDBFTable.ChangeCharsCode;
var
  I: Integer;
  sTemp: AnsiString;
begin
  if Assigned(FData) then
  begin
    for I := 0 to FData.Count - 1 do
    begin
      sTemp := AnsiString(FData[I]);

      if OEM then
        OemToAnsi(PAnsiChar(sTemp), PAnsiChar(sTemp))
      else
        AnsiToOem(PAnsiChar(sTemp), PAnsiChar(sTemp));

      FData[I] := string(sTemp);
    end;

    Resync([]); // Инициируем перерисовку записей, которые видны на экране
  end;
  OEM := not OEM;
end;

threadvar
  vSortFields: TList;
  vSortASC: Boolean;
  vSortOEM: Boolean;

function SortTable(List: TStringList; Index1, Index2: Integer): Integer;
var
  I: Integer;
  f: PDBFField;
  s1, s2: string;
  sTemp: AnsiString;
  i1, i2: Integer;
  f1, f2: Double;
  d1, d2: TDateTime;
begin
  Result := 0;

  if Assigned(vSortFields) then
  begin
    for I := 0 to vSortFields.Count - 1 do
    begin
      f := PDBFField(vSortFields[I]);
      s1 := Copy(List[Index1], f.Offset + 1, f.Size);
      s2 := Copy(List[Index2], f.Offset + 1, f.Size);
      case f.FieldType of
        ftString:
          begin
            if s1 = s2 then
              Result := 0
            else
            begin
              if vSortOEM then
              begin
                sTemp := AnsiString(s1);
                OemToCharBuffA(PAnsiChar(sTemp), PAnsiChar(sTemp), f.Size);
                s1 := string(sTemp);

                sTemp := AnsiString(s2);
                OemToCharBuffA(PAnsiChar(sTemp), PAnsiChar(sTemp), f.Size);
                s2 := string(sTemp);
              end;

              Result := AnsiCompareText(s1, s2);
              if not vSortASC then
                Result := Result * -1;
            end;

            // Если строки разные, то выходим. Сортировка по другим полям не нужна!
            if Result <> 0 then Exit;
          end;
        ftBoolean:
          begin
            if CharInSet(s1[1], ['T', 't', 'Y', 'y']) then
              i1 := 1
            else if CharInSet(s1[1], ['F', 'f', 'N', 'n']) then
              i1 := -1
            else
              i1 := 0;

            if CharInSet(s2[1], ['T', 't', 'Y', 'y']) then
              i2 := 1
            else if CharInSet(s2[1], ['F', 'f', 'N', 'n']) then
              i2 := -1
            else
              i2 := 0;

            Result := CompareValue(i1, i2);
            if not vSortASC then
              Result := Result * -1;
            if Result <> 0 then Exit;
          end;

        ftInteger, ftFloat, ftSmallint, ftCurrency, ftBCD, ftFMTBcd:
          begin
            s1 := Trim(s1);
            s2 := Trim(s2);

            i1 := Pos('.', s1);
            if i1 > 0 then
              s1[i1] := DecimalSeparator;

            i2 := Pos('.', s2);
            if i2 > 0 then
              s2[i2] := DecimalSeparator;

            f1 := StrToFloatDef(s1, 0);
            f2 := StrToFloatDef(s2, 0);

            Result := CompareValue(f1, f2);
            if not vSortASC then
              Result := Result * -1;
            if Result <> 0 then Exit;
          end;

        ftDate:
          begin
            if TryEncodeDate(StrToInt(Copy(s1, 1, 4)), StrToInt(Copy(s1, 5, 2)), StrToInt(Copy(s1, 7, 2)), d1) and
               TryEncodeDate(StrToInt(Copy(s2, 1, 4)), StrToInt(Copy(s2, 5, 2)), StrToInt(Copy(s2, 7, 2)), d2) then
            begin
              Result := CompareValue(d1, d2);
              if not vSortASC then
                Result := Result * -1;
              if Result <> 0 then Exit;
            end;
          end;
      end;
    end;
  end else
  begin // Отменяем сортировку
    Result := CompareValue(Integer(List.Objects[Index1]), Integer(List.Objects[Index2]));
    if not vSortASC then
      Result := Result * -1;
  end;

end;

procedure TMemDBFTable.Sort(Fields: string; Asc: Boolean = True);
var
  fDefs: TList;
  fNames: TStringList;
  I, J: Integer;
  s: string;
  f: PDBFField;
begin
  fNames := nil;
  fDefs := TList.Create;
  try
    fNames := TStringList.Create;

    fNames.Text := StringReplace(Fields, ';', #13#10, [rfReplaceAll]);
    for I := 0 to fNames.Count - 1 do
    begin
      s := Trim(fNames[I]);
      if (s <> '') then
      begin
        for J := 0 to FAccess.FDBF.Fields.Count - 1 do
        begin
          f := PDBFField(FAccess.FDBF.Fields[J]);
          if SameText(s, string(f.FieldName)) then
            fDefs.Add(f);
        end;
      end;  
    end;

    if fDefs.Count > 0 then
    begin // Сортируем по полям
      vSortFields := fDefs;          
      vSortOEM := OEM;
    end else
    begin // Отменяем сортировку
      vSortFields := nil;
    end;

    vSortASC := Asc;
    FAccess.FDBF.Data.CustomSort(@SortTable);
    Resync([]);
  finally
    fDefs.Free;
    fNames.Free;
  end;         
end;

end.

