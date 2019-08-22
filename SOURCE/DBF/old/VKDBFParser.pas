{Copyright:      Vlad Karpov
 		 mailto:KarpovVV@protek.ru
		 http:\\vlad-karpov.narod.ru
     ICQ#136489711
 Author:         Vlad Karpov
 Remarks:        Freeware with pay for support, see license.txt
}
unit VKDBFParser;

{$I VKDBF.DEF}
{$WARNINGS OFF}

interface

uses  dbcommon, Windows, classes, db,
      {$IFDEF DELPHI6} Variants, {$ENDIF}
      VKDBFUtil;

type

  PDBFExprNode = ^TDBFExprNode;
  TDBFExprNode = record
    FNext: PDBFExprNode;
    FKind: TExprNodeKind;
    FPartial: Boolean;
    FOperator: TCANOperator;
    FData: Variant;
    FLeft: PDBFExprNode;
    FRight: PDBFExprNode;
    FDataType: TFieldType;
    FDataSize: Integer;
    FDataLen: Integer;
    FDataPrec: Integer;
    FArgs: TList;
    FScopeKind: TExprScopeKind;
    FField: TField;
  end;

  {TVKDBFFilterExpr}
  TVKDBFFilterExpr = class
  private
    FDataSet: TDataSet;
    FFieldMap: TFieldMap;
    FOptions: TFilterOptions;
    FParserOptions: TParserOptions;
    FNodes: PDBFExprNode;
    FFieldName: AnsiString;
    FDependentFields: TBits;
    function GetFieldByName(Name: AnsiString) : TField;
  public
    constructor Create(DataSet: TDataSet; Options: TFilterOptions;
      ParseOptions: TParserOptions; const FieldName: AnsiString; DepFields: TBits;
      FieldMap: TFieldMap);
    destructor Destroy; override;
    function NewCompareNode(Field: TField; Operator: TCANOperator;
      const Value: Variant): PDBFExprNode;
    function NewNode(Kind: TExprNodeKind; Operator: TCANOperator;
      const Data: Variant; Left, Right: PDBFExprNode): PDBFExprNode;
    property DataSet: TDataSet write FDataSet;
  end;

  {TVKDBFExprParser}
  TVKDBFExprParser = class(TVKDBFFilterExpr)
    FFilter: TVKDBFFilterExpr;
    FFieldMap: TFieldMap;
    FText: AnsiString;
    FSourcePtr: PAnsiChar;
    FTokenPtr: PAnsiChar;
    FTokenString: AnsiString;
    FStrTrue: AnsiString;
    FStrFalse: AnsiString;
    FToken: TExprToken;
    FPrevToken: TExprToken;
    FNumericLit: Boolean;
    FParserOptions: TParserOptions;
    FFieldName: AnsiString;
    FDataSet: TDataSet;
    FDependentFields: TBits;
    FIndexKeyValue: boolean;
    FPartualKeyValue: boolean;
    FFields: TList;
    FKeyValues: Variant;
    FKeyFromValues: boolean;
    FFC: AnsiChar;
    procedure NextToken;
    function NextTokenIsLParen : Boolean;
    function ParseExpr: PDBFExprNode;
    function ParseExpr2: PDBFExprNode;
    function ParseExpr3: PDBFExprNode;
    function ParseExpr4: PDBFExprNode;
    function ParseExpr5: PDBFExprNode;
    function ParseExpr6: PDBFExprNode;
    function ParseExpr7: PDBFExprNode;
    function TokenName: AnsiString;
    function TokenSymbolIs(const S: AnsiString): Boolean;
    function TokenSymbolIsFunc(const S: AnsiString) : Boolean;
    procedure GetFuncResultInfo(Node: PDBFExprNode);
    procedure TypeCheckArithOp(Node: PDBFExprNode);
    procedure GetScopeKind(Root, Left, Right : PDBFExprNode);
    function Execute(Root: PDBFExprNode): Variant; overload;
  private
    FLastRoot: PDBFExprNode;
    FValue: Variant;
    FValueType: Integer;
    FKey: AnsiString;
    FHash: DWord;
    function GetDataLen: Integer;
    function GetDataPrec: Integer;
  public
    constructor Create(DataSet: TDataSet; const Text: AnsiString;
      Options: TFilterOptions; ParserOptions: TParserOptions;
      const FieldName: AnsiString; DepFields: TBits; FieldMap: TFieldMap);
    destructor Destroy; override;
    procedure SetExprParams(const Text: AnsiString; Options: TFilterOptions;
      ParserOptions: TParserOptions; const FieldName: AnsiString);
    procedure SetExprParams1(const Text: AnsiString; Options: TFilterOptions;
      ParserOptions: TParserOptions; const FieldName: AnsiString);
    function Execute: Variant; overload;
    function EvaluteKey: AnsiString; overload;
    function EvaluteKey(const KeyFields: AnsiString; const KeyValues: Variant; const CF: AnsiChar = #$20): AnsiString; overload;
    function ForPadFunctions(V: PDBFExprNode; Vr: Variant): AnsiString;
    function SuiteFieldList(fl: AnsiString; out m: Integer): Integer;
    function GetFieldList: AnsiString;
    property IndexKeyValue: boolean read FIndexKeyValue write FIndexKeyValue;
    property PartualKeyValue: boolean read FPartualKeyValue write FPartualKeyValue;
    property LastRoot: PDBFExprNode read FLastRoot;
    property Value: Variant read FValue;
    property ValueType: Integer read FValueType;
    property Key: AnsiString read FKey;
    property Len: Integer read GetDataLen; //FLastRoot.FDataLen;
    property Prec: Integer read GetDataPrec; //FLastRoot.FDataPrec;
    property Hash: DWord read FHash;
  end;

  function LikeOperator(const Var1, Var2: Variant; const CaseInsensitive: Boolean; const ManyChars, OneChar: AnsiChar): boolean;

implementation

uses SysUtils, DBConsts, VKDBFDataSet, ActiveX;

const

  varDecimal = $000E;
  StringFieldTypes = [ftString, ftFixedChar, ftWideString, ftGuid];
  DTFieldTypes = [ftDate, ftTime, ftDateTime];
  IntFieldTypes = [ftSmallint, ftInteger, ftWord, ftAutoInc, ftLargeint];
  FloatFieldTypes = [ftFloat, ftCurrency, ftBCD];
  NumberFieldTypes = IntFieldTypes + FloatFieldTypes;
  BlobFieldTypes = [ftBlob, ftMemo, ftGraphic, ftFmtMemo, ftParadoxOle, ftDBaseOle,
    ftTypedBinary, ftOraBlob, ftOraClob];

function IsNumeric(DataType: TFieldType): Boolean;
begin
  Result := DataType in [ftSmallint, ftInteger, ftWord, ftFloat, ftCurrency,
    ftBCD, ftAutoInc, ftLargeint];
end;

function IsTemporal(DataType: TFieldType): Boolean;
begin
  Result := DataType in [ftDate, ftTime, ftDateTime];
end;

function LikeOperator(const Var1, Var2: Variant; const CaseInsensitive: Boolean; const ManyChars, OneChar: AnsiChar): boolean;
var
  sStr, sPatt: AnsiString;
begin
  if VarIsNull(Var1) or VarIsNull(Var2) then
    Result := False
  else begin
    sStr := Var1;
    sPatt := Var2;
    if CaseInsensitive then
    begin
      sStr := AnsiUpperCase(sStr);
      sPatt := AnsiUpperCase(sPatt);
    end;
    Result := wildc(pAnsiChar(sPatt), pAnsiChar(sStr), Length(sStr), ManyChars, OneChar);
  end;
end;

{TVKDBFFilterExpr}
constructor TVKDBFFilterExpr.Create(DataSet: TDataSet; Options: TFilterOptions;
  ParseOptions: TParserOptions; const FieldName: AnsiString; DepFields: TBits;
  FieldMap: TFieldMap);
begin
  FFieldMap := FieldMap;
  FDataSet := DataSet;
  FOptions := Options;
  FFieldName := FieldName;
  FParserOptions := ParseOptions;
  FDependentFields := DepFields;
end;

destructor TVKDBFFilterExpr.Destroy;
var
  Node: PDBFExprNode;
begin
  while FNodes <> nil do
  begin
    Node := FNodes;
    FNodes := Node^.FNext;
    if (Node^.FKind = enFunc) and (Node^.FArgs <> nil) then
      Node^.FArgs.Free;
    Dispose(Node);
  end;
end;

function TVKDBFFilterExpr.NewCompareNode(Field: TField; Operator: TCANOperator;
  const Value: Variant): PDBFExprNode;
var
  ConstExpr: PDBFExprNode;
begin
  ConstExpr := NewNode(enConst, coNOTDEFINED, Value, nil, nil);
  ConstExpr^.FDataType := Field.DataType;
  ConstExpr^.FDataSize := Field.Size;
  Result := NewNode(enOperator, Operator, Unassigned,
    NewNode(enField, coNOTDEFINED, Field.FieldName, nil, nil), ConstExpr);
end;

function TVKDBFFilterExpr.NewNode(Kind: TExprNodeKind; Operator: TCANOperator;
  const Data: Variant; Left, Right: PDBFExprNode): PDBFExprNode;
var
  Field : TField;
begin
  New(Result);
  with Result^ do
  begin
    FNext := FNodes;
    FKind := Kind;
    FPartial := False;
    FOperator := Operator;
    FData := Data;
    FLeft := Left;
    FRight := Right;
    FDataLen := 0;
    FDataPrec := 0;
    FDataType := ftUnknown;
    FArgs := nil;
  end;
  FNodes := Result;
  if Kind = enField then
  begin
    Field := GetFieldByName(Data);
    if Field = nil then
      DatabaseErrorFmt(SFieldNotFound, [Data]);
    Result^.FDataType := Field.DataType;
    Result^.FDataSize := Field.Size;
    Result^.FField := Field;
  end;
end;

function TVKDBFFilterExpr.GetFieldByName(Name: AnsiString) : TField;
//var
//  I: Integer;
//  F: TField;
//  FieldInfo: TFieldInfo;
begin
//  Result := nil;
//  if poFieldNameGiven in FParserOptions then
//    Result := FDataSet.FieldByName(UpperCase(FFieldName))
//  else if poUseOrigNames in FParserOptions then begin
//    for I := 0 to FDataset.FieldCount - 1 do
//    begin
//      F := FDataSet.Fields[I];
//      if GetFieldInfo(F.Origin, FieldInfo) and
//         (AnsiCompareStr(Name, FieldInfo.OriginalFieldName) = 0) then
//      begin
//        Result := F;
//        Exit;
//      end;
//    end;
//  end;
//  if Result = nil then
    Result := FDataSet.FieldByName(UpperCase(Name));
//  if (Result <> nil) and (Result.FieldKind = fkCalculated) and (poAggregate in FParserOptions) then
//    DatabaseErrorFmt(SExprNoAggOnCalcs, [Result.FieldName]);
//  if (poFieldDepend in FParserOptions) and (Result <> nil) and
//     (FDependentFields <> nil) then
//    FDependentFields[Result.FieldNo-1] := True;
end;

{TVKDBFExprParser}
constructor TVKDBFExprParser.Create(DataSet: TDataSet; const Text: AnsiString;
  Options: TFilterOptions; ParserOptions: TParserOptions; const FieldName: AnsiString;
  DepFields: TBits; FieldMap: TFieldMap);
begin
  FFieldMap := FieldMap;
  FStrTrue := STextTrue;
  FStrFalse := STextFalse;
  FDataSet := DataSet;
  FDependentFields := DepFields;
  FIndexKeyValue := False;
  FPartualKeyValue := False;
  FFilter := TVKDBFFilterExpr.Create(DataSet, Options, ParserOptions, FieldName,
    DepFields, FieldMap);
  if Text <> '' then
    SetExprParams(Text, Options, ParserOptions, FieldName);
  FFields := nil;
  FKeyFromValues := false;
  FFC := #$20; //' '
  FValueType := varEmpty;
end;

destructor TVKDBFExprParser.Destroy;
begin
  FFilter.Free;
end;

procedure  TVKDBFExprParser.SetExprParams(const Text: AnsiString; Options: TFilterOptions;
  ParserOptions: TParserOptions; const FieldName: AnsiString);
var
  Root, DefField: PDBFExprNode;
begin
  FParserOptions := ParserOptions;
  if FFilter <> nil then
    FFilter.Free;
  FFilter := TVKDBFFilterExpr.Create(FDataSet, Options, ParserOptions, FieldName,
    FDependentFields, FFieldMap);
  FText := Text;
  FSourcePtr := PAnsiChar(Text);
  FFieldName := FieldName;
  NextToken;
  Root := nil;
  if FToken <> etEnd then Root := ParseExpr;
  FValue := NULL;
  if Root <> nil then begin
    if FToken <> etEnd then DatabaseError(SExprTermination);

    if (poAggregate in FParserOptions) and (Root^.FScopeKind <> skAgg) then
       DatabaseError(SExprNotAgg);
    if (not (poAggregate in FParserOptions)) and (Root^.FScopeKind = skAgg) then
       DatabaseError(SExprNoAggFilter);
    if poDefaultExpr in ParserOptions then
    begin
      DefField := FFilter.NewNode(enField, coNOTDEFINED, FFieldName, nil, nil);
      if (IsTemporal(DefField^.FDataType) and (Root^.FDataType in StringFieldTypes)) or
         ((DefField^.FDataType = ftBoolean ) and (Root^.FDataType in StringFieldTypes)) then
        Root^.FDataType := DefField^.FDataType;

      if not ((IsTemporal(DefField^.FDataType) and IsTemporal(Root^.FDataType))
         or (IsNumeric(DefField^.FDataType) and IsNumeric(Root^.FDataType))
         or ((DefField^.FDataType in StringFieldTypes) and (Root^.FDataType in StringFieldTypes))
         or ((DefField^.FDataType = ftBoolean) and (Root^.FDataType = ftBoolean))) then
        DatabaseError(SExprTypeMis);
      Root := FFilter.NewNode(enOperator, coASSIGN, Unassigned, Root, DefField);
    end;

    if not (poAggregate in FParserOptions) and not(poDefaultExpr in ParserOptions)
       and (Root^.FDataType <> ftBoolean ) then
       DatabaseError(SExprIncorrect);


    FValue := Execute(Root);

  end;

  FLastRoot := Root;

end;

procedure TVKDBFExprParser.SetExprParams1(const Text: AnsiString;
  Options: TFilterOptions; ParserOptions: TParserOptions;
  const FieldName: AnsiString);
var
  Root: PDBFExprNode;
begin
  FParserOptions := ParserOptions;
  if FFilter <> nil then
    FFilter.Free;
  FFilter := TVKDBFFilterExpr.Create(FDataSet, Options, ParserOptions, FieldName,
    FDependentFields, FFieldMap);
  FText := Text;
  FSourcePtr := PAnsiChar(Text);
  FFieldName := FieldName;
  NextToken;
  Root := nil;
  if FToken <> etEnd then Root := ParseExpr;
  if Root <> nil then
    if FToken <> etEnd then DatabaseError(SExprTermination);

  FLastRoot := Root;

end;

function TVKDBFExprParser.NextTokenIsLParen : Boolean;
var
  P : PAnsiChar;
begin
  P := FSourcePtr;
  while (P^ <> #0) and (P^ <= ' ') do Inc(P);
  Result := P^ = '(';
end;

procedure TVKDBFExprParser.NextToken;
type
  ASet = Set of AnsiChar;
var
  P, TokenStart: PAnsiChar;
  L: Integer;
  StrBuf: array[0..255] of AnsiChar;

  function IsKatakana(const Chr: Byte): Boolean;
  begin
    Result := (SysLocale.PriLangID = LANG_JAPANESE) and (Chr in [$A1..$DF]);
  end;

  procedure Skip(TheSet: ASet);
  begin
    while TRUE do
    begin
      if P^ in LeadBytes then
        Inc(P, 2)
      else if (P^ in TheSet) or IsKatakana(Byte(P^)) then
        Inc(P)
      else
        Exit;
    end;
  end;

  procedure Litr(ltr: AnsiChar);
  begin
    Inc(P);
    L := 0;
    while True do
    begin
      if P^ = #0 then DatabaseError(SExprStringError);
      if P^ = ltr then
      begin
        Inc(P);
        if P^ <> ltr then Break;
      end;
      if L < SizeOf(StrBuf) then
      begin
        StrBuf[L] := P^;
        Inc(L);
      end;
      Inc(P);
    end;
    SetString(FTokenString, StrBuf, L);
    FToken := etLiteral;
    FNumericLit := False;
  end;

begin
  FPrevToken := FToken;
  FTokenString := '';
  P := FSourcePtr;
  while (P^ <> #0) and (P^ <= ' ') do Inc(P);
  if (P^ <> #0) and (P^ = '/') and (P[1] <> #0) and (P[1] = '*')then
  begin
    P := P + 2;
    while (P^ <> #0) and (P^ <> '*') do Inc(P);
    if (P^ = '*') and (P[1] <> #0) and (P[1] =  '/')  then
      P := P + 2
    else
      DatabaseErrorFmt(SExprInvalidChar, [P^]);
  end;
  while (P^ <> #0) and (P^ <= ' ') do Inc(P);
  FTokenPtr := P;
  case P^ of
    'A'..'Z', 'a'..'z', '_', #$81..#$fe:
      begin
        TokenStart := P;
        if not SysLocale.FarEast then
        begin
          Inc(P);
          while P^ in ['A'..'Z', 'a'..'z', '0'..'9', '_', '.', '[', ']'] do Inc(P);
        end
        else
          Skip(['A'..'Z', 'a'..'z', '0'..'9', '_', '.', '[', ']']);
        SetString(FTokenString, TokenStart, P - TokenStart);
        FToken := etSymbol;
        if CompareText(FTokenString, 'LIKE') = 0 then   { do not localize }
          FToken := etLIKE
        else if CompareText(FTokenString, 'IN') = 0 then   { do not localize }
          FToken := etIN
        else if CompareText(FTokenString, 'IS') = 0 then    { do not localize }
        begin
          while (P^ <> #0) and (P^ <= ' ') do Inc(P);
          TokenStart := P;
          Skip(['A'..'Z', 'a'..'z']);
          SetString(FTokenString, TokenStart, P - TokenStart);
          if CompareText(FTokenString, 'NOT')= 0 then  { do not localize }
          begin
            while (P^ <> #0) and (P^ <= ' ') do Inc(P);
            TokenStart := P;
            Skip(['A'..'Z', 'a'..'z']);
            SetString(FTokenString, TokenStart, P - TokenStart);
            if CompareText(FTokenString, 'NULL') = 0 then
              FToken := etISNOTNULL
            else
              DatabaseError(SInvalidKeywordUse);
          end
          else if CompareText (FTokenString, 'NULL') = 0  then  { do not localize }
          begin
            FToken := etISNULL;
          end
          else
            DatabaseError(SInvalidKeywordUse);
        end;
      end;
    '[':
      begin
        Inc(P);
        TokenStart := P;
        P := AnsiStrScan(P, ']');
        if P = nil then DatabaseError(SExprNameError);
        SetString(FTokenString, TokenStart, P - TokenStart);
        FToken := etName;
        Inc(P);
      end;
    '''': Litr('''');
    '"': Litr('"');
    '-', '0'..'9':
      begin
        if (FPrevToken <> etLiteral) and (FPrevToken <> etName) and
           (FPrevToken <> etSymbol)and (FPrevToken <> etRParen) then
          begin
            TokenStart := P;
            Inc(P);
            while (P^ in ['0'..'9', '.', 'e', 'E', '+', '-']) do
              Inc(P);
            //if ((P-1)^ = ',') and (DecimalSeparator = ',') and (P^ = ' ') then
            //  Dec(P);
            SetString(FTokenString, TokenStart, P - TokenStart);
            FToken := etLiteral;
            FNumericLit := True;
          end
        else
         begin
           FToken := etSUB;
           Inc(P);
         end;
      end;
    '(':
      begin
        Inc(P);
        FToken := etLParen;
      end;
    ')':
      begin
        Inc(P);
        FToken := etRParen;
      end;
    '<':
      begin
        Inc(P);
        case P^ of
          '=':
            begin
              Inc(P);
              FToken := etLE;
            end;
          '>':
            begin
              Inc(P);
              FToken := etNE;
            end;
        else
          FToken := etLT;
        end;
      end;
    '=':
      begin
        Inc(P);
        FToken := etEQ;
      end;
    '>':
      begin
        Inc(P);
        if P^ = '=' then
        begin
          Inc(P);
          FToken := etGE;
        end else
          FToken := etGT;
      end;
    '+':
      begin
        Inc(P);
        FToken := etADD;
      end;
    '*':
      begin
        Inc(P);
        FToken := etMUL;
      end;
    '/':
      begin
        Inc(P);
        FToken := etDIV;
      end;
    ',':
      begin
        Inc(P);
        FToken := etComma;
      end;
    #0:
      FToken := etEnd;
    '.':
      begin
        TokenStart := P;
        Skip(['A'..'Z', 'a'..'z', '0'..'9', '_', '.', '[', ']']);
        SetString(FTokenString, TokenStart, P - TokenStart);
        if CompareText(FTokenString, '.T.') = 0 then FTokenString := 'TRUE';
        if CompareText(FTokenString, '.F.') = 0 then FTokenString := 'FALSE';
        if CompareText(FTokenString, '.AND.') = 0 then FTokenString := 'AND';
        if CompareText(FTokenString, '.OR.') = 0 then FTokenString := 'OR';
        if CompareText(FTokenString, '.XOR.') = 0 then FTokenString := 'XOR';
        if CompareText(FTokenString, '.NOT.') = 0 then FTokenString := 'NOT';
        FToken := etSymbol;
      end;
    '!':
      begin
        Inc(P);
        FTokenString := 'NOT';
        FToken := etSymbol;
      end;
  else
    DatabaseErrorFmt(SExprInvalidChar, [P^]);
  end;
  FSourcePtr := P;
end;

function TVKDBFExprParser.ParseExpr: PDBFExprNode;
begin
  Result := ParseExpr2;
  while TokenSymbolIs('OR') do
  begin
    NextToken;
    Result := FFilter.NewNode(enOperator, coOR, Unassigned,
      Result, ParseExpr2);
    GetScopeKind(Result, Result^.FLeft, Result^.FRight);
    Result^.FDataType := ftBoolean;
  end;
end;

function TVKDBFExprParser.ParseExpr2: PDBFExprNode;
begin
  Result := ParseExpr3;
  while TokenSymbolIs('AND') do
  begin
    NextToken;
    Result := FFilter.NewNode(enOperator, coAND, Unassigned,
      Result, ParseExpr3);
    GetScopeKind(Result, Result^.FLeft, Result^.FRight);
    Result^.FDataType := ftBoolean;
  end;
end;

function TVKDBFExprParser.ParseExpr3: PDBFExprNode;
begin
  if TokenSymbolIs('NOT') then
  begin
    NextToken;
    Result := FFilter.NewNode(enOperator, coNOT, Unassigned,
      ParseExpr4, nil);
    Result^.FDataType := ftBoolean;
  end else
    Result := ParseExpr4;
  GetScopeKind(Result, Result^.FLeft, Result^.FRight);
end;


function TVKDBFExprParser.ParseExpr4: PDBFExprNode;
const
  Operators: array[etEQ..etLT] of TCANOperator = (
    coEQ, coNE, coGE, coLE, coGT, coLT);
var
  Operator: TCANOperator;
  Left, Right: PDBFExprNode;
begin
  Result := ParseExpr5;
  if (FToken in [etEQ..etLT]) or (FToken = etLIKE)
     or (FToken = etISNULL) or (FToken = etISNOTNULL)
     or (FToken = etIN) then
  begin
    case FToken of
      etEQ..etLT:
        Operator := Operators[FToken];
      etLIKE:
        Operator := coLIKE;
      etISNULL:
        Operator := coISBLANK;
      etISNOTNULL:
        Operator := coNOTBLANK;
      etIN:
        Operator := coIN;
      else
        Operator := coNOTDEFINED;
    end;
    NextToken;
    Left := Result;
    if Operator = coIN then
    begin
      if FToken <> etLParen then
        DatabaseErrorFmt(SExprNoLParen, [TokenName]);
      NextToken;
      Result := FFilter.NewNode(enOperator, coIN, Unassigned,
                 Left, nil);
      Result.FDataType := ftBoolean;
      if FToken <> etRParen then
      begin
        Result.FArgs := TList.Create;
        repeat
          Right := ParseExpr;
          if IsTemporal(Left.FDataType) then
            Right.FDataType := Left.FDataType;
          Result.FArgs.Add(Right);
          if (FToken <> etComma) and (FToken <> etRParen) then
            DatabaseErrorFmt(SExprNoRParenOrComma, [TokenName]);
          if FToken = etComma then NextToken;
        until (FToken = etRParen) or (FToken = etEnd);
        if FToken <> etRParen then
          DatabaseErrorFmt(SExprNoRParen, [TokenName]);
        NextToken;
      end else
        DatabaseError(SExprEmptyInList);
    end else
    begin
      if (Operator <> coISBLANK) and (Operator <> coNOTBLANK) then
        Right := ParseExpr5
      else
        Right := nil;
      Result := FFilter.NewNode(enOperator, Operator, Unassigned,
        Left, Right);
      if Right <> nil then
      begin
        if (Left^.FKind = enField) and (Right^.FKind = enConst) then
          begin
            Right^.FDataType := Left^.FDataType;
            Right^.FDataSize := Left^.FDataSize;
          end
        else if (Right^.FKind = enField) and (Left^.FKind = enConst) then
          begin
            Left^.FDataType := Right^.FDataType;
            Left^.FDataSize := Right^.FDataSize;
          end;
      end;
      if (Left^.FDataType in BlobFieldTypes) and (Operator = coLIKE) then
      begin
        if Right^.FKind = enConst then Right^.FDataType := ftString;
      end
      else if (Operator <> coISBLANK) and (Operator <> coNOTBLANK)
         and ((Left^.FDataType in (BlobFieldTypes + [ftBytes])) or
         ((Right <> nil) and (Right^.FDataType in (BlobFieldTypes + [ftBytes])))) then
        DatabaseError(SExprTypeMis);
      Result.FDataType := ftBoolean;
      if Right <> nil then
      begin
        if IsTemporal(Left.FDataType) and (Right.FDataType in StringFieldTypes) then
          Right.FDataType := Left.FDataType
        else if IsTemporal(Right.FDataType) and (Left.FDataType in StringFieldTypes) then
          Left.FDataType := Right.FDataType;
      end;
      GetScopeKind(Result, Left, Right);
    end;
  end;
end;

function TVKDBFExprParser.ParseExpr5: PDBFExprNode;
const
  Operators: array[etADD..etDIV] of TCANOperator = (
    coADD, coSUB, coMUL, coDIV);
var
  Operator: TCANOperator;
  Left, Right: PDBFExprNode;
begin
  Result := ParseExpr6;
  while FToken in [etADD, etSUB] do
  begin
    if not (poExtSyntax in FParserOptions) then
      DatabaseError(SExprNoArith);
    Operator := Operators[FToken];
    Left := Result;
    NextToken;
    Right := ParseExpr6;
    Result := FFilter.NewNode(enOperator, Operator, Unassigned, Left, Right);
    TypeCheckArithOp(Result);
    GetScopeKind(Result, Left, Right);
  end;
end;

function TVKDBFExprParser.ParseExpr6: PDBFExprNode;
const
  Operators: array[etADD..etDIV] of TCANOperator = (
    coADD, coSUB, coMUL, coDIV);
var
  Operator: TCANOperator;
  Left, Right: PDBFExprNode;
begin
  Result := ParseExpr7;
  while FToken in [etMUL, etDIV] do
  begin
    if not (poExtSyntax in FParserOptions) then
      DatabaseError(SExprNoArith);
    Operator := Operators[FToken];
    Left := Result;
    NextToken;
    Right := ParseExpr7;
    Result := FFilter.NewNode(enOperator, Operator, Unassigned, Left, Right);
    TypeCheckArithOp(Result);
    GetScopeKind(Result, Left, Right);
  end;
end;


function TVKDBFExprParser.ParseExpr7: PDBFExprNode;
var
  FuncName: AnsiString;
begin
  case FToken of
    etSymbol:
      if (poExtSyntax in FParserOptions)
         and  NextTokenIsLParen and TokenSymbolIsFunc(FTokenString) then
        begin
          Funcname := FTokenString;
          NextToken;
          if FToken <> etLParen then
            DatabaseErrorFmt(SExprNoLParen, [TokenName]);
          NextToken;
          if (CompareText(FuncName,'count') = 0) and (FToken = etMUL) then
          begin
            FuncName := 'COUNT(*)';
            NextToken;
          end;
          Result := FFilter.NewNode(enFunc, coNOTDEFINED, FuncName,
                    nil, nil);
          if FToken <> etRParen then
          begin
            Result.FArgs := TList.Create;
            repeat
              Result.FArgs.Add(ParseExpr);
              if (FToken <> etComma) and (FToken <> etRParen) then
                DatabaseErrorFmt(SExprNoRParenOrComma, [TokenName]);
              if FToken = etComma then NextToken;
            until (FToken = etRParen) or (FToken = etEnd);
          end else
            Result.FArgs := nil;

          GetFuncResultInfo(Result);
        end
      else if TokenSymbolIs('NULL') then
        begin
          Result := FFilter.NewNode(enConst, coNOTDEFINED, Null, nil, nil);
          Result.FScopeKind := skConst;
        end
      else if TokenSymbolIs(FStrTrue) then
        begin
          Result := FFilter.NewNode(enConst, coNOTDEFINED, True, nil, nil);
          Result.FScopeKind := skConst;
        end
      else if TokenSymbolIs(FStrFalse) then
        begin
          Result := FFilter.NewNode(enConst, coNOTDEFINED, False, nil, nil);
          Result.FScopeKind := skConst;
        end
      else
        begin
          Result := FFilter.NewNode(enField, coNOTDEFINED, FTokenString, nil, nil);
          Result.FScopeKind := skField;
        end;
    etName:
      begin
        Result := FFilter.NewNode(enField, coNOTDEFINED, FTokenString, nil, nil);
        Result.FScopeKind := skField;
      end;
    etLiteral:
      begin
        if FNumericLit then begin
          if FormatSettings.DecimalSeparator <> '.' then
            FTokenString := StringReplace(FTokenString, '.', FormatSettings.DecimalSeparator, []);
          Result := FFilter.NewNode(enConst, coNOTDEFINED, FTokenString, nil, nil);
          Result^.FDataType := ftFloat;
        end else begin
          Result := FFilter.NewNode(enConst, coNOTDEFINED, FTokenString, nil, nil);
          Result^.FDataType := ftString;
        end;
        Result.FScopeKind := skConst;
      end;
    etLParen:
      begin
        NextToken;
        Result := ParseExpr;
        if FToken <> etRParen then DatabaseErrorFmt(SExprNoRParen, [TokenName]);
      end;
  else
    DatabaseErrorFmt(SExprExpected, [TokenName]);
    Result := nil;
  end;
  NextToken;
end;

procedure  TVKDBFExprParser.GetScopeKind(Root, Left, Right : PDBFExprNode);
begin
  if (Left = nil) and (Right = nil) then Exit;
  if Right = nil then
  begin
    Root.FScopeKind := Left.FScopeKind;
    Exit;
  end;
  if ((Left^.FScopeKind = skField) and (Right^.FScopeKind = skAgg))
     or ((Left^.FScopeKind = skAgg) and (Right^.FScopeKind = skField)) then
    DatabaseError(SExprBadScope);
  if (Left^.FScopeKind = skConst) and (Right^.FScopeKind = skConst) then
    Root^.FScopeKind := skConst
  else if (Left^.FScopeKind = skAgg) or (Right^.FScopeKind = skAgg) then
    Root^.FScopeKind := skAgg
  else if (Left^.FScopeKind = skField) or (Right^.FScopeKind = skField) then
    Root^.FScopeKind := skField;
end;

procedure TVKDBFExprParser.GetFuncResultInfo(Node : PDBFExprNode);
begin
  Node^.FDataType := ftString;
  if (CompareText(Node^.FData, 'COUNT(*)') <> 0 )
     and (CompareText(Node^.FData,'GETDATE') <> 0 )
     and ( (Node^.FArgs = nil ) or ( Node^.FArgs.Count = 0) ) then
      DatabaseError(SExprTypeMis);

  if (Node^.FArgs <> nil) and (Node^.FArgs.Count > 0) then
     Node^.FScopeKind := PDBFExprNode(Node^.FArgs.Items[0])^.FScopeKind;
  if (CompareText(Node^.FData , 'SUM') = 0) or
     (CompareText(Node^.FData , 'AVG') = 0) then
  begin
    Node^.FDataType := ftFloat;
    Node^.FScopeKind := skAgg;
  end
  else if (CompareText(Node^.FData , 'MIN') = 0) or
          (CompareText(Node^.FData , 'MAX') = 0) then
  begin
    Node^.FDataType := PDBFExprNode(Node^.FArgs.Items[0])^.FDataType;
    Node^.FScopeKind := skAgg;
  end
  else if  (CompareText(Node^.FData , 'COUNT') = 0) or
           (CompareText(Node^.FData , 'COUNT(*)') = 0) then
  begin
    Node^.FDataType := ftInteger;
    Node^.FScopeKind := skAgg;
  end
  else if (CompareText(Node^.FData , 'YEAR') = 0) or
          (CompareText(Node^.FData , 'MONTH') = 0) or
          (CompareText(Node^.FData , 'DAY') = 0) or
          (CompareText(Node^.FData , 'HOUR') = 0) or
          (CompareText(Node^.FData , 'MINUTE') = 0) or
          (CompareText(Node^.FData , 'SECOND') = 0 ) then
  begin
    Node^.FDataType := ftInteger;
    Node^.FScopeKind := PDBFExprNode(Node^.FArgs.Items[0])^.FScopeKind;
  end
  else if CompareText(Node^.FData , 'GETDATE') = 0  then
  begin
    Node^.FDataType := ftDateTime;
    Node^.FScopeKind := skConst;
  end
  else if CompareText(Node^.FData , 'DATE') = 0  then
  begin
    Node^.FDataType := ftDate;
    Node^.FScopeKind := PDBFExprNode(Node^.FArgs.Items[0])^.FScopeKind;
  end
  else if CompareText(Node^.FData , 'TIME') = 0  then
  begin
    Node^.FDataType := ftTime;
    Node^.FScopeKind := PDBFExprNode(Node^.FArgs.Items[0])^.FScopeKind;
  end;
end;

function TVKDBFExprParser.TokenName: AnsiString;
begin
  if FSourcePtr = FTokenPtr then Result := SExprNothing else
  begin
    SetString(Result, FTokenPtr, FSourcePtr - FTokenPtr);
    Result := '''' + Result + '''';
  end;
end;

function TVKDBFExprParser.TokenSymbolIs(const S: AnsiString): Boolean;
begin
  Result := (FToken = etSymbol) and (CompareText(FTokenString, S) = 0);
end;


function TVKDBFExprParser.TokenSymbolIsFunc(const S: AnsiString) : Boolean;
begin
  Result := (CompareText(S, 'UPPER') = 0) or
            (CompareText(S, 'LOWER') = 0) or
            (CompareText(S, 'ANSIUPPER') = 0) or
            (CompareText(S, 'ANSILOWER') = 0) or
            (CompareText(S, 'SUBSTRING') = 0) or
            (CompareText(S, 'SUBSTR') = 0) or
            (CompareText(S, 'STUFF') = 0) or
            (CompareText(S, 'STRTRAN') = 0) or
            (CompareText(S, 'ALLTRIM') = 0) or
            (CompareText(S, 'TRIM') = 0) or
            (CompareText(S, 'TRIMLEFT') = 0) or
            (CompareText(S, 'LTRIM') = 0) or
            (CompareText(S, 'TRIMRIGHT') = 0) or
            (CompareText(S, 'RTRIM') = 0) or
            (CompareText(S, 'PADR') = 0) or
            (CompareText(S, 'PADL') = 0) or
            (CompareText(S, 'PADC') = 0) or
            (CompareText(S, 'DTOS') = 0) or
            (CompareText(S, 'DTTOS') = 0) or
            (CompareText(S, 'STR') = 0) or
            (CompareText(S, 'VAL') = 0) or
            (CompareText(S, 'YEAR') = 0) or
            (CompareText(S, 'MONTH') = 0) or
            (CompareText(S, 'DAY') = 0) or
            (CompareText(S, 'HOUR') = 0) or
            (CompareText(S, 'MINUTE') = 0) or
            (CompareText(S, 'SECOND') = 0) or
            (CompareText(S, 'GETDATE') = 0) or
            (CompareText(S, 'DATE') = 0) or
            (CompareText(S, 'TIME') = 0) or
            (CompareText(S, 'IF') = 0) or
            (CompareText(S, 'IIF') = 0) or
            (CompareText(S, 'LEFT') = 0) or
            (CompareText(S, 'RIGHT') = 0) or
            (CompareText(S, 'SPACE') = 0) or
            (CompareText(S, 'STRZERO') = 0) or
            (CompareText(S, 'DESCEND') = 0) or
            (CompareText(S, 'SUM') = 0) or
            (CompareText(S, 'MIN') = 0) or
            (CompareText(S, 'MAX') = 0) or
            (CompareText(S, 'AVG') = 0) or
            (CompareText(S, 'COUNT') = 0);

end;

procedure TVKDBFExprParser.TypeCheckArithOp(Node: PDBFExprNode);
begin
  with Node^ do
  begin
    if IsNumeric(FLeft.FDataType) and IsNumeric(FRight.FDataType)  then
      FDataType := ftFloat
    else if (FLeft.FDataType in StringFieldTypes) and
       (FRight.FDataType in StringFieldTypes) and (FOperator = coADD) then
      FDataType := ftString
    else if IsTemporal(FLeft.FDataType) and IsNumeric(FRight.FDataType) and
       (FOperator = coADD) then
      FDataType := ftDateTime
    else if IsTemporal(FLeft.FDataType) and IsNumeric(FRight.FDataType) and
       (FOperator = coSUB) then
      FDataType := FLeft.FDataType
    else if IsTemporal(FLeft.FDataType) and IsTemporal(FRight.FDataType) and
       (FOperator = coSUB) then
      FDataType := ftFloat
    else if (FLeft.FDataType in StringFieldTypes) and IsTemporal(FRight.FDataType) and
       (FOperator = coSUB) then
    begin
      FLeft.FDataType := FRight.FDataType;
      FDataType := ftFloat;
    end
    else if ( FLeft.FDataType in StringFieldTypes) and  IsNumeric(FRight.FDataType )and
         (FLeft.FKind = enConst)  then
      FLeft.FDataType := ftDateTime
    else
      DatabaseError(SExprTypeMis);
  end;
end;

function TVKDBFExprParser.Execute(Root: PDBFExprNode): Variant;

    {$WARNINGS OFF}
    function EvaluteNodeValueComplex(ANode: PDBFExprNode): Variant;
    var
      VrLeft, VrRight: Variant;
      V: PDBFExprNode;
      l, r, Vr: Variant;
      i, j, k: Integer;
      S, S1, S2, S3: AnsiString;
      specStr: string;
      Year, Month, Day: Word;
      Hour, Min, Sec, MSec: Word;
      dt: TDateTime;
      ff: boolean;
      Code: Integer;
      kk: Int64;
      OldTrimCType: Boolean;
      b: byte;
      Cr: AnsiChar;
      //vType: Integer;
      //i64: Int64;


      function VarIsString(const V: Variant): Boolean;
      var
          tp: Integer;
      begin
          tp := VarType(l);
          Result := (tp = varString) or (tp = varOleStr);
      end;

      procedure UpperCaseLR;
      begin
          if VarIsString(l) then
              l := AnsiUpperCase(l);
          if VarIsString(r) then
              r := AnsiUpperCase(r);
      end;

      function PartialEQ(AForce: Boolean): Boolean;
      var
          sL, sR: AnsiString;
          ln, lnL, lnR: Integer;
          partial: Boolean;
      begin
          if VarIsString(l) and VarIsString(r) then begin
              sL := l;
              sR := r;
              lnL := Length(sL);
              lnR := Length(sR);
              if l <> '' then begin
                  partial := False;
                  if sL[lnL] = '*' then begin
                      partial := True;
                      Dec(lnL);
                  end;
                  if r <> '' then begin
                      if sR[lnR] = '*' then begin
                          partial := True;
                          Dec(lnR);
                      end;
                      if partial or AForce then begin
                          ln := lnR;
                          if ln > lnL then
                              ln := lnL;
                          if (foCaseInsensitive in FOptions) then
                              Result := AnsiStrLIComp(PAnsiChar(sL), PAnsiChar(sR), ln) = 0
                          else
                              Result := AnsiStrLComp(PAnsiChar(sL), PAnsiChar(sR), ln) = 0;
                          Exit;
                      end;
                  end;
              end;
              if (foCaseInsensitive in FOptions) then
                  Result := AnsiCompareText(sL, sR) = 0
              else
                  Result := sL = Sr;
          end
          else begin
              UpperCaseLR;
              Result := l = r;
          end;
      end;

      procedure PadPrepare;
      begin
        V := PDBFExprNode(ANode^.FArgs.Items[0]);
        Vr := EvaluteNodeValueComplex(V);
        S1 := ForPadFunctions(V, Vr);
        V := PDBFExprNode(ANode^.FArgs.Items[1]);
        j := Integer(EvaluteNodeValueComplex(V));
        if ANode^.FArgs.Count > 2 then
          Cr := AnsiChar(VarToStr(EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[2])))[1])
        else
          Cr := ' ';
        k := length(S1);
      end;

    begin
      Result := Unassigned;
      case ANode^.FKind of
      enField:
        begin
          if not FKeyFromValues then begin
            if FIndexKeyValue then begin
              OldTrimCType := TVKSmartDBF(FDataSet).TrimCType;
              TVKSmartDBF(FDataSet).TrimCType := False;
              try
                Result := (ANode^.FField).Value;
              finally
                TVKSmartDBF(FDataSet).TrimCType := OldTrimCType;
              end;
            end else
              Result := (ANode^.FField).Value;
          end else begin
            ff := false;
            for i:=0 to FFields.Count - 1 do
              if TField(FFields[i]).FieldName = (ANode^.FField).FieldName then begin
                if VarIsArray(FKeyValues) then begin
                  if (VarArrayLowBound(FKeyValues, 1) <= i) and (i <= VarArrayHighBound(FKeyValues, 1)) then
                    Result := FKeyValues[i]
                  else
                    Result := Null;
                end else
                  Result := FKeyValues;
                if (not VarIsNull(Result)) then
                  case TField(FFields[i]).DataType of
                    ftString, ftFixedChar               : Result := VarAsType(Result, varString);
                    ftWideString                        : Result := VarAsType(Result, varOleStr);
                    ftSmallint                          : Result := VarAsType(Result, varSmallint);
                    ftInteger, ftWord, ftAutoInc        : Result := VarAsType(Result, varInteger);
                    ftLargeint                          :
                      begin
                        Val(Result, kk, code);
                        if code <> 0 then
                          Result := Null
                        else begin
													{$IFDEF VER130}
                          TVarData(Vr).VType := VT_DECIMAL;
                          Decimal(Vr).lo64 := kk;
													{$ENDIF}
													{$IFDEF VER140}
													Vr := kk;
													{$ENDIF}
													{$IFDEF VER150}
													Vr := kk;
													{$ENDIF}
                          Result := Vr;
                        end;
                      end;
                    ftBoolean                           : Result := VarAsType(Result, varBoolean);
                    ftFloat                             : Result := VarAsType(Result, varDouble);
                    ftCurrency, ftBCD                   : Result := VarAsType(Result, varCurrency);
                    ftDate, ftTime, ftDateTime          : Result := VarAsType(Result, varDate);
                  end;
                ff := true;
                break;
              end;
            if not ff then Result := Null;
          end;
          if FIndexKeyValue then begin
            if ANode^.FDataType in [ftFloat, ftCurrency] then begin
              ANode^.FDataLen := TVKSmartDBF((ANode^.FField).DataSet).GetLen(ANode^.FField);
              ANode^.FDataPrec := TVKSmartDBF((ANode^.FField).DataSet).GetPrec(ANode^.FField);
            end else begin
              ANode^.FDataLen := TVKSmartDBF((ANode^.FField).DataSet).GetLen(ANode^.FField);
              ANode^.FDataPrec := 0;
            end;
            ANode^.FDataSize := TVKSmartDBF((ANode^.FField).DataSet).GetDataSize(ANode^.FField);
            if VarIsNull(Result) then begin
              if not FPartualKeyValue then
                case ANode^.FDataType of
                  ftString, ftFixedChar, ftWideString: Result := StringOfChar(FFC, ANode^.FDataSize);
                  ftFloat, ftLargeint, ftInteger, ftWord, ftCurrency, ftBCD, ftSmallint: Result := 0;
                  ftBoolean: Result := false;
                end
              else
                case ANode^.FDataType of
                  ftString, ftFixedChar, ftWideString: Result := '';
                end;
            end else
              if ANode^.FDataType in [ftString, ftFixedChar, ftWideString] then
                if Length(Result) < ANode^.FDataSize then
                  if not FPartualKeyValue then
                    Result := Result + StringOfChar(FFC, ANode^.FDataSize - Length(Result));
          end;
        end;
      enConst:
        Result := ANode^.FData;
      enOperator:
        case ANode^.FOperator of
        coNOTDEFINED:;
        coASSIGN:
          begin
            (ANode^.FRight^.FField).Value :=
                EvaluteNodeValueComplex(ANode^.FLeft);
            Result := (ANode^.FRight^.FField).Value;
          end;
        coOR:
            Result := Boolean(EvaluteNodeValueComplex(ANode^.FLeft)) or
                      Boolean(EvaluteNodeValueComplex(ANode^.FRight));
        coAND:
            Result := Boolean(EvaluteNodeValueComplex(ANode^.FLeft)) and
                      Boolean(EvaluteNodeValueComplex(ANode^.FRight));
        coNOT:
            Result := not Boolean(EvaluteNodeValueComplex(ANode^.FLeft));
        coEQ, coNE, coGE, coLE, coGT, coLT:
          begin
            l := EvaluteNodeValueComplex(ANode^.FLeft);
            r := EvaluteNodeValueComplex(ANode^.FRight);
            if (foCaseInsensitive in FOptions) and
               not (foNoPartialCompare in FOptions) then
                UpperCaseLR;
            case ANode^.FOperator of
                coEQ:
                  if foNoPartialCompare in FOptions then
                    Result := l = r
                  else
                    Result := PartialEQ(ANode^.FPartial);
                coNE: Result := l <> r;
                coGE: Result := l >= r;
                coLE: Result := l <= r;
                coGT: Result := l > r;
                coLT: Result := l < r;
            end;
          end;
        coLIKE:
            begin
                Result := LikeOperator( EvaluteNodeValueComplex(ANode^.FLeft), EvaluteNodeValueComplex(ANode^.FRight),
                                        foCaseInsensitive in FOptions, '%', '_');
            end;
        coISBLANK, coNOTBLANK:
            begin
                if ANode^.FLeft^.FKind = enField then
                    Result := ANode^.FLeft^.FField.IsNull
                else
                    Result := VarIsNull(EvaluteNodeValueComplex(ANode^.FLeft));
                if ANode^.FOperator = coNOTBLANK then
                    Result := not Result;
            end;
        coIN:
            begin
                Result := False;
                l := EvaluteNodeValueComplex(ANode^.FLeft);
                for i := 0 to ANode^.FArgs.Count - 1 do
                begin
                  r := EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[i]));
                  if foNoPartialCompare in FOptions then
                    Result := l = r
                  else
                    Result := PartialEQ(ANode^.FPartial);
                  if Result then Break;
                end;
            end;
        coADD:
          begin
            VrLeft := EvaluteNodeValueComplex(ANode^.FLeft);
            VrRight := EvaluteNodeValueComplex(ANode^.FRight);
            if not FIndexKeyValue then
              Result := VrLeft + VrRight
            else begin
              if VarIsNull(VrLeft) and ( VarType(VrRight) = varString ) then begin
                if FPartualKeyValue then
                  VrLeft := ''
                else
                  VrLeft := StringOfChar(FFC, ANode^.FLeft.FDataSize);
              end;
              if VarIsNull(VrRight) and ( VarType(VrLeft) = varString ) then begin
                if FPartualKeyValue then
                  VrRight := ''
                else
                  VrRight := StringOfChar(FFC, ANode^.FRight.FDataSize);
              end;
              Result := VrLeft + VrRight;
              if VarType(Result) = varString then begin
                ANode^.FDataSize := ANode^.FLeft.FDataSize + ANode^.FRight.FDataSize;
              end else begin
                if ANode^.FLeft.FDataLen > ANode^.FRight.FDataLen then
                  ANode^.FDataLen := ANode^.FLeft.FDataLen + 1
                else
                  ANode^.FDataLen := ANode^.FRight.FDataLen + 1;
                if ANode^.FLeft.FDataPrec > ANode^.FRight.FDataPrec then
                  ANode^.FDataPrec := ANode^.FLeft.FDataPrec
                else
                  ANode^.FDataPrec := ANode^.FRight.FDataPrec;
                ANode^.FDataSize := ANode^.FDataLen;
                //if ANode^.FDataLen > 14 then ANode^.FDataLen := 14;
                //if ANode^.FDataPrec + 1 > ANode^.FDataLen then ANode^.FDataPrec := ANode^.FDataLen - 3;
              end;
            end;
          end;
        coSUB:
          begin
            Result := EvaluteNodeValueComplex(ANode^.FLeft) - EvaluteNodeValueComplex(ANode^.FRight);
            if FIndexKeyValue then begin
              if ANode^.FLeft.FDataLen > ANode^.FRight.FDataLen then
                ANode^.FDataLen := ANode^.FLeft.FDataLen
              else
                ANode^.FDataLen := ANode^.FRight.FDataLen;
              if ANode^.FLeft.FDataPrec > ANode^.FRight.FDataPrec then
                ANode^.FDataPrec := ANode^.FLeft.FDataPrec
              else
                ANode^.FDataPrec := ANode^.FRight.FDataPrec;
              if ANode^.FDataLen > 14 then ANode^.FDataLen := 14;
              if ANode^.FDataPrec + 1 > ANode^.FDataLen then ANode^.FDataPrec := ANode^.FDataLen - 3;
            end;
          end;
        coMUL:
          begin
            Result := EvaluteNodeValueComplex(ANode^.FLeft) * EvaluteNodeValueComplex(ANode^.FRight);
            if FIndexKeyValue then begin
              ANode^.FDataLen := ANode^.FLeft.FDataLen + ANode^.FRight.FDataLen;
              ANode^.FDataPrec := ANode^.FLeft.FDataPrec + ANode^.FRight.FDataPrec;
              if ANode^.FDataLen > 14 then ANode^.FDataLen := 14;
              if ANode^.FDataPrec + 1 > ANode^.FDataLen then ANode^.FDataPrec := ANode^.FDataLen - 3;
            end;
          end;
        coDIV:
          begin
            Result := EvaluteNodeValueComplex(ANode^.FLeft) / EvaluteNodeValueComplex(ANode^.FRight);
            if FIndexKeyValue then begin
              if ANode^.FLeft.FDataLen > ANode^.FRight.FDataLen then
                ANode^.FDataLen := ANode^.FLeft.FDataLen
              else
                ANode^.FDataLen := ANode^.FRight.FDataLen;
              if ANode^.FLeft.FDataPrec > ANode^.FRight.FDataPrec then
                ANode^.FDataPrec := ANode^.FLeft.FDataPrec
              else
                ANode^.FDataPrec := ANode^.FRight.FDataPrec;
              if ANode^.FDataLen > 14 then ANode^.FDataLen := 14;
              if ANode^.FDataPrec + 1 > ANode^.FDataLen then ANode^.FDataPrec := ANode^.FDataLen - 3;
            end;
          end;
        end;
      enFunc:
        begin
          S := AnsiUpperCase(ANode^.FData);
          if (CompareText(S, 'UPPER') = 0) then begin
            V := PDBFExprNode(ANode^.FArgs.Items[0]);
            Vr := EvaluteNodeValueComplex(V);
            if not VarIsNull(Vr) then
              Result := UpperCase(VarToStr(Vr))
            else
              Result := StringOfChar(FFC, V.FDataSize);
            ANode^.FDataSize := V.FDataSize;
            ANode^.FDataLen := V.FDataLen;
            ANode^.FDataPrec := 0;
          end else if (CompareText(S, 'LOWER') = 0) then begin
            V := PDBFExprNode(ANode^.FArgs.Items[0]);
            Vr := EvaluteNodeValueComplex(V);
            if not VarIsNull(Vr) then
              Result := LowerCase(VarToStr(Vr))
            else
              Result := StringOfChar(FFC, V.FDataSize);
            ANode^.FDataSize := V.FDataSize;
            ANode^.FDataLen := V.FDataLen;
            ANode^.FDataPrec := 0;
          end else if (CompareText(S, 'ANSIUPPER') = 0) then begin
            V := PDBFExprNode(ANode^.FArgs.Items[0]);
            Vr := EvaluteNodeValueComplex(V);
            if not VarIsNull(Vr) then
              Result := AnsiUpperCase(VarToStr(Vr))
            else
              Result := StringOfChar(FFC, V.FDataSize);
            ANode^.FDataSize := V.FDataSize;
            ANode^.FDataLen := V.FDataLen;
            ANode^.FDataPrec := 0;
          end else if (CompareText(S, 'ANSILOWER') = 0) then begin
            V := PDBFExprNode(ANode^.FArgs.Items[0]);
            Vr := EvaluteNodeValueComplex(V);
            if not VarIsNull(Vr) then
              Result := AnsiLowerCase(VarToStr(Vr))
            else
              Result := StringOfChar(FFC, V.FDataSize);
            ANode^.FDataSize := V.FDataSize;
            ANode^.FDataLen := V.FDataLen;
            ANode^.FDataPrec := 0;
          end else if (CompareText(S, 'DTOS') = 0) then begin
            V := PDBFExprNode(ANode^.FArgs.Items[0]);
            Vr := EvaluteNodeValueComplex(V);
            if VarType(Vr) = varDate then begin
              if not VarIsNull(Vr) then
                Result := DtoS(VarToDateTime(Vr))
              else
                Result := StringOfChar(FFC, 8);
            end else
              Result := StringOfChar(FFC, 8);
            ANode^.FDataSize := 8;
            ANode^.FDataLen := 8;
            ANode^.FDataPrec := 0;
          end else if (CompareText(S, 'DTTOS') = 0) then begin
            V := PDBFExprNode(ANode^.FArgs.Items[0]);
            Vr := EvaluteNodeValueComplex(V);
            if VarType(Vr) = varDate then begin
              if not VarIsNull(Vr) then
                Result := DTtoS(VarToDateTime(Vr))
              else
                Result := StringOfChar(FFC, 14);
            end else
              Result := StringOfChar(FFC, 14);
            ANode^.FDataSize := 14;
            ANode^.FDataLen := 14;
            ANode^.FDataPrec := 0;
          end else if (CompareText(S, 'STR') = 0) then begin
            V := PDBFExprNode(ANode^.FArgs.Items[0]);
            Vr := EvaluteNodeValueComplex(V);
            if not VarIsNull(Vr) then begin
              S1 := '';
              case ANode^.FArgs.Count of
                1:
                  begin
                    Str(Vr:V.FDataLen:V.FDataPrec, S1);
                    ANode^.FDataSize := V.FDataLen;
                    ANode^.FDataLen := V.FDataLen;
                  end;
                2:
                  begin
                    j := EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[1]));
                    Str(Vr:j:V.FDataPrec, S1);
                    ANode^.FDataSize := j;
                    ANode^.FDataLen := j;
                  end;
                3:
                  begin
                    j := EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[1]));
                    k := EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[2]));
                    Str(Vr:j:k, S1);
                    ANode^.FDataSize := j;
                    ANode^.FDataLen := j;
                  end;
              end;
            end else begin
              if not FPartualKeyValue then
                S1 := StringOfChar(FFC, V.FDataLen)
              else
                S1 := '';
              ANode^.FDataSize := V.FDataLen;
              ANode^.FDataLen := V.FDataLen;
            end;
            ANode^.FDataPrec := 0;
            Result := S1;
          end else if (CompareText(S, 'VAL') = 0) then begin
            V := PDBFExprNode(ANode^.FArgs.Items[0]);
            Vr := EvaluteNodeValueComplex(V);
            if V.FDataLen >= 10 then
              ANode^.FDataLen := 10
            else
              ANode^.FDataLen := V.FDataLen;
            ANode^.FDataPrec := 0;
            ANode^.FDataSize := V.FDataLen;
            Result := VKDBFUtil.ClipperVal(Vr);
          end else if (CompareText(S, 'STRZERO') = 0) then begin
            j := Integer(Trunc(EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[0]))));
            S1 := '';
            case ANode^.FArgs.Count of
              1:
                begin
                  FmtStr(specStr, '%d', [j]);
                  S1 := AnsiString(specStr);
                  Result := StringOfChar('0', 10 - Length(S1)) + S1;
                  ANode^.FDataLen := 10;
                end;
              2:
                begin
                  k := Integer(Trunc(EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[1]))));
                  FmtStr(specStr, '%d', [j]);
                  S1 := AnsiString(specStr);
                  Result := StringOfChar('0', k - Length(S1)) + S1;
                  ANode^.FDataLen := k;
                end;
            end;
            ANode^.FDataSize := ANode^.FDataLen;
            ANode^.FDataPrec := 0;
          end else if (CompareText(S, 'SPACE') = 0) then begin
            V := PDBFExprNode(ANode^.FArgs.Items[0]);
            Vr := EvaluteNodeValueComplex(V);
            Result := StringOfChar(FFC, Integer(Vr));
            ANode^.FDataLen := Integer(Vr);
            ANode^.FDataSize := ANode^.FDataLen;
            ANode^.FDataPrec := 0;
          end else if (CompareText(S, 'RIGHT') = 0) then begin
            V := PDBFExprNode(ANode^.FArgs.Items[0]);
            Vr := EvaluteNodeValueComplex(V);
            S1 := VarToStr(Vr);
            j := Integer(EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[1])));
            k := Length(S1) - j + 1;
            if k <= 0 then k := 1;
            Result := Copy(S1, k, j);
            ANode^.FDataLen := j;
            ANode^.FDataSize := j;
            ANode^.FDataPrec := 0;
          end else if (CompareText(S, 'LEFT') = 0) then begin
            S1 := VarToStr(EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[0])));
            j := Integer(EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[1])));
            Result := Copy(S1, 1, j);
            ANode^.FDataLen := j;
            ANode^.FDataSize := j;
            ANode^.FDataPrec := 0;
          end else if ((CompareText(S, 'IF') = 0) or (CompareText(S, 'IIF') = 0)) then
          begin
            if EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[0])) then begin
              V := PDBFExprNode(ANode^.FArgs.Items[1]);
              Result := EvaluteNodeValueComplex(V);
              ANode^.FDataLen := V.FDataLen;
              ANode^.FDataPrec := V.FDataPrec;
            end else begin
              V := PDBFExprNode(ANode^.FArgs.Items[2]);
              Result := EvaluteNodeValueComplex(V);
              ANode^.FDataLen := V.FDataLen;
              ANode^.FDataPrec := V.FDataPrec;
            end;
          end else if CompareText(S, 'DESCEND') = 0 then begin
            V := PDBFExprNode(ANode^.FArgs.Items[0]);
            Vr := EvaluteNodeValueComplex(V);
            ANode^.FDataSize := V.FDataSize;
            ANode^.FDataLen := V.FDataLen;
            ANode^.FDataPrec := V.FDataPrec;
            if not VarIsNull(Vr) then begin
              if VarType(Vr) = varDate then begin
                //2816789 - значение функции при дате = 12/30/1899
                Result := 2816789 - Integer(trunc(VarToDateTime(Vr)));
                ANode^.FDataLen := 10;
                ANode^.FDataPrec := 0;
              end else if ((VarType(Vr) = varOleStr) or (VarType(Vr) = varString)) then begin
                Result := '';
                S1 := VarToStr(Vr);
                for k := 1 to Length(S1) do begin
                  b := ord(S1[k]);
                  if b = 0 then
                    Result := Result + chr(0)
                  else
                    Result := Result + chr(256 - b);
                end;
              {$IFDEF DELPHI6}
              end else if VarType(Vr) in [varSmallint, varInteger, varSingle,
                        varShortInt, varByte, varWord, varLongWord, varDouble,
                        varCurrency] then begin
                Result := -Vr;
                ANode^.FDataLen := 13;
                ANode^.FDataPrec := 2;
              {$ELSE}
              end else if VarType(Vr) = varDecimal then begin
                TVarData(Result).VType := VT_DECIMAL;
                Decimal(Result).lo64 := - Decimal(Vr).lo64;
                ANode^.FDataLen := 13;
                ANode^.FDataPrec := 2;
              end else if VarType(Vr) in [varSmallint, varInteger, varSingle,
                                          varDouble, varCurrency] then begin
                Result := -Vr;
                ANode^.FDataLen := 13;
                ANode^.FDataPrec := 2;
              {$ENDIF}
              end else if VarType(Vr) = varBoolean then begin
                Result := not Vr;
              end else
                raise Exception.Create('Non supported argument type in DESCEND() function!');
            end else begin
              if V.FDataType in DTFieldTypes then begin
                Result := 0005231808;
                ANode^.FDataLen := 10;
                ANode^.FDataPrec := 0;
              end else if V.FDataType in StringFieldTypes then begin
                Result := StringOfChar(FFC, V.FDataLen);
              end else if V.FDataType in NumberFieldTypes then begin
                Result := 0;
                ANode^.FDataLen := 13;
                ANode^.FDataPrec := 2;
              end else if V.FDataType = ftBoolean then begin
                Result := False;
              end else
                raise Exception.Create('Field type for DESCEND() not avaliable!');
            end;
          end else if ((CompareText(S, 'SUBSTRING') = 0) or (CompareText(S, 'SUBSTR') = 0)) then begin
            if not ( ANode^.FArgs.Count in [2, 3] ) then raise Exception.Create('TVKDBFExprParser.Execute: Incorrect number of arguments in SUBSTR call.');
            S1 := VarToStr(EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[0])));
            j := Integer(EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[1])));
            if ANode^.FArgs.Count = 3 then
              k := Integer(EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[2])))
            else
              k := 0;
            Result := VKDBFUtil.SubStr(S1, j, k);
            ANode^.FDataLen := k;
            ANode^.FDataPrec := 0;
          end else if (CompareText(S, 'STUFF') = 0) then begin
            if not ( ANode^.FArgs.Count in [3, 4] ) then raise Exception.Create('TVKDBFExprParser.Execute: Incorrect number of arguments in STUFF call.');
            S1 := VarToStr(EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[0])));
            j := Integer(EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[1])));
            k := Integer(EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[2])));
            if ANode^.FArgs.Count = 4 then
              S2 := VarToStr(EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[3])))
            else
              S2 := '';
            Result := VKDBFUtil.Stuff(S1, j, k, S2);
            ANode^.FDataLen := Length(Result);
            ANode^.FDataPrec := 0;
          end else if (CompareText(S, 'STRTRAN') = 0) then begin
            if not ( ANode^.FArgs.Count in [2, 3, 4, 5] ) then raise Exception.Create('TVKDBFExprParser.Execute: Incorrect number of arguments in STRTRAN call.');
            S1 := VarToStr(EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[0])));
            S2 := VarToStr(EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[1])));
            if ANode^.FArgs.Count > 2 then begin
              S3 := VarToStr(EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[2])));
              if ANode^.FArgs.Count > 3 then begin
                j := Integer(EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[3])));
                if ANode^.FArgs.Count > 4 then begin
                  j := Integer(EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[4])));
                end else begin
                  k := 0;
                end;
              end else begin
                j := 1;
                k := 0;
              end;
            end else begin
              S3 := '';
              j := 1;
              k := 0;
            end;
            Result := VKDBFUtil.StrTran(S1, S2, S3, j, k);
            ANode^.FDataLen := Length(Result);
            ANode^.FDataPrec := 0;
          end else if ( CompareText(S, 'PADR') = 0 ) then begin
            PadPrepare;
            if k < j then begin
              Result := S1 + StringOfChar(Cr, j - k);
            end else begin
              Result := Copy(S1, 1, j);
            end;
          end else if ( CompareText(S, 'PADL') = 0 ) then begin
            PadPrepare;
            if k < j then begin
              Result := StringOfChar(Cr, j - k) + S1;
            end else begin
              Result := Copy(S1, 1, j);
            end;
          end else if ( CompareText(S, 'PADC') = 0 ) then begin
            PadPrepare;
            if k < j then begin
              Result := StringOfChar(Cr, ((j - k) shr 1)) +
                S1 + StringOfChar(Cr, ((j - k) - ((j - k) shr 1)));
            end else begin
              Result := Copy(S1, 1, j);
            end;
          end else if ( CompareText(S, 'ALLTRIM') = 0 ) then begin
            V := PDBFExprNode(ANode^.FArgs.Items[0]);
            Vr := EvaluteNodeValueComplex(V);
            Result := Trim(VarToStr(Vr));
            ANode^.FDataLen := Length(Result);
            ANode^.FDataPrec := 0;
          end else if ((CompareText(S, 'TRIMLEFT') = 0) or (CompareText(S, 'LTRIM') = 0)) then begin
            V := PDBFExprNode(ANode^.FArgs.Items[0]);
            Vr := EvaluteNodeValueComplex(V);
            Result := TrimLeft(VarToStr(Vr));
            ANode^.FDataLen := Length(Result);
            ANode^.FDataPrec := 0;
          end else if ((CompareText(S, 'TRIMRIGHT') = 0) or (CompareText(S, 'RTRIM') = 0) or (CompareText(S, 'TRIM') = 0)) then begin
            V := PDBFExprNode(ANode^.FArgs.Items[0]);
            Vr := EvaluteNodeValueComplex(V);
            Result := TrimRight(VarToStr(Vr));
            ANode^.FDataLen := Length(Result);
            ANode^.FDataPrec := 0;
          end else if (CompareText(S, 'YEAR') = 0) then begin
            DecodeDate(VarToDateTime(EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[0]))), Year, Month, Day);
            Result := Year;
            ANode^.FDataLen := 4;
            ANode^.FDataPrec := 0;
          end else if (CompareText(S, 'MONTH') = 0) then begin
            DecodeDate(VarToDateTime(EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[0]))), Year, Month, Day);
            Result := Month;
            ANode^.FDataLen := 2;
            ANode^.FDataPrec := 0;
          end else if (CompareText(S, 'DAY') = 0) then begin
            DecodeDate(VarToDateTime(EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[0]))), Year, Month, Day);
            Result := Day;
            ANode^.FDataLen := 2;
            ANode^.FDataPrec := 0;
          end else if (CompareText(S, 'HOUR') = 0) then begin
            DecodeTime(VarToDateTime(EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[0]))), Hour, Min, Sec, MSec);
            Result := Hour;
            ANode^.FDataLen := 2;
            ANode^.FDataPrec := 0;
          end else if (CompareText(S, 'MINUTE') = 0) then begin
            DecodeTime(VarToDateTime(EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[0]))), Hour, Min, Sec, MSec);
            Result := Min;
            ANode^.FDataLen := 2;
            ANode^.FDataPrec := 0;
          end else if (CompareText(S, 'SECOND') = 0) then begin
            DecodeTime(VarToDateTime(EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[0]))), Hour, Min, Sec, MSec);
            Result := Sec;
            ANode^.FDataLen := 2;
            ANode^.FDataPrec := 0;
          end else if (CompareText(S, 'GETDATE') = 0) then begin
            Result := StrToDate(VarToStr(EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[0]))))
          end else if (CompareText(S, 'DATE') = 0) then begin
            Result := Integer(Trunc(VarToDateTime(EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[0])))))
          end else if (CompareText(S, 'TIME') = 0) then begin
            dt := VarToDateTime(EvaluteNodeValueComplex(PDBFExprNode(ANode^.FArgs.Items[0])));
            Result := dt - Trunc(dt);
          end;
          {(CompareText(S, 'SUM') = 0)
          (CompareText(S, 'MIN') = 0)
          (CompareText(S, 'MAX') = 0)
          (CompareText(S, 'AVG') = 0)
          (CompareText(S, 'COUNT') = 0)}
        end;
      else
        Result := Null;
      end;
    end;
    {$WARNINGS ON}
begin
    Result := EvaluteNodeValueComplex(Root);
end;

function TVKDBFExprParser.Execute: Variant;
begin
  FValue := Null;
  if FLastRoot <> nil then
    FValue := Execute(FLastRoot);
  Result := FValue;
end;

function TVKDBFExprParser.EvaluteKey: AnsiString;
var
  sign: boolean;
  vType: Integer;
  i64: Int64;
  q: DWord;
  HashCode: DWord;
  HashCodeArr: array[0..3] of AnsiChar absolute HashCode;
  KeyValue: pAnsiChar;
  specStr: string;

  procedure HashFromInt64(j64: Int64);
  var
    j64Rec: Int64Rec absolute j64;
  begin
    if j64 < 0 then begin
      j64 := - j64;
      if j64Rec.Hi <> 0 then begin
        j64Rec.Hi := 0;
        j64Rec.Lo := $80000000;
      end else begin
        j64 := - j64;
      end;
    end else begin
      if j64Rec.Hi <> 0 then begin
        j64Rec.Hi := 0;
        j64Rec.Lo := $7FFFFFFF;
      end;
    end;
    FHash := j64Rec.Lo;
  end;

begin
  FValue := Null;
  if FLastRoot <> nil then
    FValue := Execute(FLastRoot);
  vType := VarType(FValue);
  if not ((vType = varEmpty) or (vType = varNull)) then FValueType := vType;
  {$IFDEF DELPHI6}
  if (vType = varInt64) then begin
    i64 := FValue;
  {$ELSE}
  if (vType = varDecimal) then begin
    i64 := Decimal(FValue).lo64;
  {$ENDIF}
    HashFromInt64(i64);
    if i64 >= 0 then
      sign := false
    else begin
      sign := true;
      i64 := -i64;
    end;
    FmtStr(specStr, '%d', [i64]);
    Result := AnsiString(specStr);
    if Length(Result) <= FLastRoot.FDataLen then begin
      Result := StringOfChar('0', FLastRoot.FDataLen - Length(Result)) + Result;
      if sign then
        ReplSign(Result);
    end else begin
      Result := StringOfChar('0', FLastRoot.FDataLen);
    end;
  end else if (vType in [ varDouble,
                          {$IFDEF DELPHI6}
                          varShortInt,
                          varByte,
                          varWord,
                          varLongWord,
                          {$ENDIF}
                          varInteger,
                          varSmallint,
                          varSingle,
                          varCurrency] ) then begin
    i64 := Trunc(FValue);
    HashFromInt64(i64);
    if FValue >= 0 then
      sign := false
    else begin
      sign := true;
      FValue := -FValue;
    end;
    // use $U- for escape GPF
    Str(FValue:FLastRoot.FDataLen:FLastRoot.FDataPrec, Result);
    //
    if Length(Result) <= FLastRoot.FDataLen then begin
      ReplBlanks(Result);
      if sign then
        ReplSign(Result);
    end else begin
      Result := StringOfChar('0', FLastRoot.FDataLen);
      if FLastRoot.FDataPrec <> 0 then Result[FLastRoot.FDataLen - FLastRoot.FDataPrec] := '.';
    end;
  end else if (vType = varBoolean) then begin
    if FValue then begin
      Result := 'T';
      FHash := $FFFFFFFF;
    end else begin
      Result := 'F';
      FHash := 0;
    end;
  end else if (vType = varDate) then begin
    i64 := Trunc(FValue);
    HashFromInt64(i64);
    case FLastRoot.FDataType of
      ftDate: Result := DtoS(VarToDateTime(FValue));
      ftTime: Result := TtoS(VarToDateTime(FValue));
      ftDateTime: Result := DTtoS(VarToDateTime(FValue));
    else
      Result := DtoS(VarToDateTime(FValue))
    end;
  end else if ((vType = varEmpty) or (vType = varNull)) then begin
    FHash := 0;
    Result := StringOfChar(FFC, FLastRoot.FDataSize);
  end else begin
    Result := VarToStr(FValue);
    KeyValue := pAnsiChar(Result);

    //Calculate hash
    q := Pred(FLastRoot.FDataSize);
    if q > 3 then q := 3;

    //FHash := ( Byte((KeyValue + (( q     ) and 3))^) shl 24 ) or
    //         ( Byte((KeyValue + (( q + 1 ) and 3))^) shl 16 ) or
    //         ( Byte((KeyValue + (( q + 2 ) and 3))^) shl 8  ) or
    //         ( Byte((KeyValue + (( q + 3 ) and 3))^)        );

    HashCodeArr[0] := (KeyValue + (q and 3))^;
    Dec(q);
    HashCodeArr[1] := (KeyValue + (q and 3))^;
    Dec(q);
    HashCodeArr[2] := (KeyValue + (q and 3))^;
    Dec(q);
    HashCodeArr[3] := (KeyValue + (q and 3))^;
    FHash := HashCode;
    //

  end;
  //if Result = '' then raise Exception.Create('TVKDBFExprParser.EvaluteKey: Key mast not be empty!');
  FKey := Result;
end;

function TVKDBFExprParser.ForPadFunctions(V: PDBFExprNode; Vr: Variant): AnsiString;
var
  vType: Integer;
  i64: Int64;
  specStr: string;
begin
  vType := VarType(Vr);
  {$IFDEF DELPHI6}
  if (vType = varInt64) then begin
    i64 := Vr;
  {$ELSE}
  if (vType = varDecimal) then begin
    i64 := Decimal(Vr).lo64;
  {$ENDIF}
    FmtStr(specStr, '%d', [i64]);
    Result := AnsiString(specStr);
  end else if (vType in [ varDouble,
                          {$IFDEF DELPHI6}
                          varShortInt,
                          varByte,
                          varWord,
                          varLongWord,
                          {$ENDIF}
                          varInteger,
                          varSmallint,
                          varSingle,
                          varCurrency] ) then begin
    // use $U- for escape GPF
    Str(Vr:V.FDataLen:V.FDataPrec, Result);
    Result := trim(Result);
    //
  end else if (vType = varDate) then begin
    //Use ShortDateFormat and LongTimeFormat global varaible
    //to rich needed date format
    Result := DateTimeToStr(VarToDateTime(Vr));
  end else if ((vType = varEmpty) or (vType = varNull)) then begin
    Result := StringOfChar(' ', V.FDataSize);
  end else begin
    Result := VarToStr(Vr);
  end;
end;


function TVKDBFExprParser.SuiteFieldList(fl: AnsiString; out m: Integer): Integer;
var
  fs, fn: AnsiString;
  fc: Integer;
  q: boolean;

  procedure SuiteFieldListInternal(ANode: PDBFExprNode);
  var
    i: Integer;
  begin
    case ANode^.FKind of
    enField:
      begin
        Inc(m);
        if not q then begin
          fn := UpperCase((ANode^.FField).FieldName);
          if    ( Pos(fn + ';', fs) <> 0 )
             or ( Pos(';' + fn, fs) <> 0 )
             or ( fn = fs ) then
            Inc(fc)
          else
            q := true;
        end;
      end;
    enOperator, enFunc:
      begin
        if ANode^.FLeft <> nil then
          SuiteFieldListInternal(ANode^.FLeft);
        if ANode^.FRight <> nil then
          SuiteFieldListInternal(ANode^.FRight);
        if ANode^.FArgs <> nil then
          for i := 0 to ANode^.FArgs.Count - 1 do
            if ANode^.FArgs.Items[i] <> nil then
              SuiteFieldListInternal(PDBFExprNode(ANode^.FArgs.Items[i]));
      end;
    end;
  end;

begin
  fs := UpperCase(fl);
  fc := 0;
  m := 0;
  q := false;
  if FLastRoot <> nil then SuiteFieldListInternal(FLastRoot);
  Result := fc;
end;

function TVKDBFExprParser.EvaluteKey(const KeyFields: AnsiString;
  const KeyValues: Variant; const CF: AnsiChar = #$20): AnsiString;
begin
  if CF <> #$20 then FFC := CF;
  FFields := TList.Create;
  FKeyValues := KeyValues;
  FKeyFromValues := true;
  try
    FDataSet.GetFieldList(FFields, KeyFields);
    Result := EvaluteKey;
  finally
    FKeyFromValues := false;
    FFC := #$20;
    FFields.Free;
    FFields := nil;
  end;
end;

function TVKDBFExprParser.GetDataLen: Integer;
begin
  Result := FLastRoot.FDataLen;
end;

function TVKDBFExprParser.GetDataPrec: Integer;
begin
  Result := FLastRoot.FDataPrec;
end;

function TVKDBFExprParser.GetFieldList: AnsiString;
var
  lResult: AnsiString;

  procedure GetFieldListInternal(ANode: PDBFExprNode);
  var
    i: Integer;
  begin
    case ANode^.FKind of
    enField: lResult := lResult + UpperCase((ANode^.FField).FieldName) + ';';
    enOperator, enFunc:
      begin
        if ANode^.FLeft <> nil then
          GetFieldListInternal(ANode^.FLeft);
        if ANode^.FRight <> nil then
          GetFieldListInternal(ANode^.FRight);
        if ANode^.FArgs <> nil then
          for i := 0 to ANode^.FArgs.Count - 1 do
            if ANode^.FArgs.Items[i] <> nil then
              GetFieldListInternal(PDBFExprNode(ANode^.FArgs.Items[i]));
      end;
    end;
  end;

begin
  lResult := '';
  if FLastRoot <> nil then GetFieldListInternal(FLastRoot);
  Result := lResult;
end;

end.
