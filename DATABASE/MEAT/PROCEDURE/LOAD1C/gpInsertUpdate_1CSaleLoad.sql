-- Function: gpInsertUpdate_1CSaleLoad()

DROP FUNCTION IF EXISTS gpInsertUpdate_1CSaleLoad(Integer, TVarChar, TVarChar, TDateTime, Integer, 
    TVarChar, Integer, TVarChar, TFloat, TFloat, TFloat, TDateTime, TVarChar, TDateTime, TVarChar,
    TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_1CSaleLoad(Integer, TVarChar, TVarChar, TDateTime, Integer, 
    TVarChar, Integer, TVarChar, TFloat, TFloat, TFloat, TDateTime, TVarChar, TDateTime, TVarChar,
    TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_1CSaleLoad(
    IN inUnitId Integer, 
    IN inVidDoc TVarChar, 
    IN inInvNumber TVarChar,
    IN inOperDate TDateTime, 
    IN inClientCode Integer, 
    IN inClientName TVarChar, 
    IN inGoodsCode Integer, 
    IN inGoodsName TVarChar, 
    IN inOperCount TFloat, 
    IN inOperPrice TFloat,
    IN inTax TFloat, 
    IN inDoc1Date TDateTime, 
    IN inDoc1Number TVarChar, 
    IN inDoc2Date TDateTime, 
    IN inDoc2Number TVarChar,
    IN inSuma TFloat, 
    IN inPDV TFloat, 
    IN inSumaPDV TFloat, 
    IN inClientINN TVarChar, 
    IN inClientOKPO TVarChar,
    IN inInvNalog TVarChar, 
    IN inBillId Integer, 
    IN inEkspCode Integer, 
    IN inExpName TVarChar, 
    IN inBranchId Integer,
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS VOID AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
--     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount());
    
     IF inBranchId <> zfGetBranchFromUnitId(inUnitId) THEN
        RAISE EXCEPTION 'Филиал в файле не соответсвует выбранному филиалу';
     END IF;
    
     IF inVidDoc = '1' or inVidDoc = '4' THEN

        INSERT INTO Sale1C (UnitId, VidDoc, InvNumber, OperDate, ClientCode, ClientName, GoodsCode,   
                            GoodsName, OperCount, OperPrice, Tax, Doc1Date, Doc1Number, Doc2Date, Doc2Number,
                            Suma, PDV, SumaPDV, ClientINN, ClientOKPO, InvNalog, BillId, EkspCode, ExpName)
             VALUES(inUnitId, inVidDoc, inInvNumber, inOperDate, inClientCode, inClientName, inGoodsCode,   
                    inGoodsName, inOperCount, inOperPrice, inTax, inDoc1Date, inDoc1Number, inDoc2Date, inDoc2Number,
                    inSuma, inPDV, inSumaPDV, inClientINN, inClientOKPO, inInvNalog, inBillId, inEkspCode, inExpName);
    END IF;

     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 30.01.14                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_1CSaleLoad (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
