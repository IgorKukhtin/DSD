unit CashInterface;

interface
type
   TPaidType = (ptMoney, ptCard, ptCardAdd);

   ICash = interface
     procedure SetAlwaysSold(Value: boolean);
     function GetAlwaysSold: boolean;

     function SoldCode(const GoodsCode: integer; const Amount: double; const Price: double = 0.00): boolean;
     function SoldFromPC(const GoodsCode: integer; const GoodsName, UKTZED: string; const Amount, Price, NDS: double): boolean; //Продажа с компьютера
     function ProgrammingGoods(const GoodsCode: integer; const GoodsName: string; const Price, NDS: double): boolean;
     function ChangePrice(const GoodsCode: integer; const Price: double): boolean;
     function OpenReceipt(const isFiscal: boolean = true; const isPrintSumma: boolean = false; const isReturn: boolean = False): boolean;
     function CloseReceipt: boolean;
     function CloseReceiptEx(out CheckId: String): boolean;
     function GetLastCheckId: Integer;
     function CashInputOutput(const Summa: double): boolean;
     function ClosureFiscal: boolean;
     function XReport: boolean;
     function TotalSumm(Summ, SummAdd: double; PaidType: TPaidType): boolean;
     function DiscountGoods(Summ: double): boolean;
     function DeleteArticules(const GoodsCode: integer): boolean;
     function GetLastErrorCode: integer;
     function GetArticulInfo(const GoodsCode: integer; var ArticulInfo: WideString): boolean;
     function PrintNotFiscalText(const PrintText: WideString): boolean;
     function PrintFiscalText(const PrintText: WideString): boolean;
     function SubTotal(isPrint, isDisplay: WordBool; Percent, Disc: Double): boolean;
     function PrintFiscalMemoryByNum(inStart, inEnd: Integer): boolean;
     function PrintFiscalMemoryByDate(inStart, inEnd: TDateTime): boolean;
     function PrintReportByDate(inStart, inEnd: TDateTime): boolean;
     function PrintReportByNum(inStart, inEnd: Integer): boolean;
     function PrintZeroReceipt: boolean;
     function FiscalNumber:String;
     function SerialNumber:String;
     procedure ClearArticulAttachment;
     procedure SetTime;
     function GetTime : TDateTime;
     procedure Anulirovt;
     function InfoZReport : string;
     function JuridicalName : string;
     function ZReport : Integer;
     function SummaReceipt : Currency;
     function GetTaxRate : string;
     function SensZReportBefore : boolean;
     function SummaCash : Currency;
     function SummaCard : Currency;
     function ReceiptsSales : Integer;
     function ReceiptsReturn : Integer;

     property AlwaysSold: boolean read GetAlwaysSold write SetAlwaysSold;
   end;
implementation

end.
