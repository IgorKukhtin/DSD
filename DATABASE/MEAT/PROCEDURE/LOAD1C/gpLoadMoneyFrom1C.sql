-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpLoadMoneyFrom1C (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpLoadMoneyFrom1C(
    IN inId                  Integer    , 
    IN inBranchId            Integer    , -- Филиал
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbOperDate TDateTime;  
   DECLARE vbMovementId Integer;
   DECLARE vbPartnerId Integer;
   DECLARE vbPartnerCode Integer;
   DECLARE vbContractId Integer;
   DECLARE vbSummaIn TFloat;
   DECLARE vbSummaOut TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_LoadMoneyFrom1C());
     vbUserId := lpGetUserBySession (inSession);

     -- Создание Документов                                   

     -- Вытащили данные из строки
     SELECT 
         Money1C.InvNumber
       , Money1C.OperDate
       , Money1C.ClientCode
       , Money1C.SummaIn 
       , Money1C.SummaOut INTO vbInvNumber, vbOperDate, vbPartnerCode, vbSummaIn, vbSummaOut
    FROM Money1C WHERE Id = inId;
     -- Нашли Кассу и Точку доставки
     

     /*OPEN curMovement FOR 
          SELECT DISTINCT Money1C.InvNumber
                        , Money1C.OperDate
                        , zfGetUnitFromUnitId (Money1C.UnitId) AS UnitId
                        , Money1C.UnitId AS UnitId_1C
                        , ObjectLink_Partner1CLink_Partner.ChildObjectId AS PartnerId
                        , tmpPartner1CLink.ContractId
                        , Money.Id AS MovementId
                        , zfGetPaidKindFrom1CType(Money1C.VidDoc) AS PaidKindId
                        , round(Money1C.Tax)
          FROM Money1C
               JOIN (SELECT Object_Partner1CLink.Id AS ObjectId
                          , Object_Partner1CLink.ObjectCode
                          , ObjectLink_Partner1CLink_Branch.ChildObjectId  AS BranchId
                          , ObjectLink_Partner1CLink_Contract.ChildObjectId AS ContractId
                     FROM Object AS Object_Partner1CLink
                           JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
                                           ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_Partner1CLink.Id
                                          AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
                           JOIN ObjectLink AS ObjectLink_Partner1CLink_Contract
                                           ON ObjectLink_Partner1CLink_Contract.ObjectId = Object_Partner1CLink.Id
                                          AND ObjectLink_Partner1CLink_Contract.DescId = zc_ObjectLink_Partner1CLink_Contract()                                 
                     WHERE Object_Partner1CLink.DescId =  zc_Object_Partner1CLink()
                    ) AS tmpPartner1CLink ON tmpPartner1CLink.ObjectCode = Money1C.ClientCode
                                         AND tmpPartner1CLink.BranchId = zfGetBranchLinkFromBranchPaidKind(zfGetBranchFromUnitId (Money1C.UnitId), zfGetPaidKindFrom1CType(Money1C.VidDoc))
               LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
                                    ON ObjectLink_Partner1CLink_Partner.ObjectId = tmpPartner1CLink.ObjectId
                                   AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()
               LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                    ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner1CLink_Partner.ChildObjectId
                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
               LEFT JOIN  (SELECT Movement.Id, Movement.InvNumber, Movement.OperDate, MLO_To.ObjectId AS PartnerId FROM Movement  
          JOIN MovementLinkObject AS MLO_From
                                  ON MLO_From.MovementId = Movement.Id
                                 AND MLO_From.DescId = zc_MovementLinkObject_From() 
          JOIN MovementLinkObject AS MLO_To
                                  ON MLO_To.MovementId = Movement.Id
                                 AND MLO_To.DescId = zc_MovementLinkObject_To() 
          JOIN ObjectLink AS ObjectLink_Unit_Branch 
                          ON ObjectLink_Unit_Branch.ObjectId = MLO_From.ObjectId 
                         AND ObjectLink_Unit_Branch.ChildObjectId = inBranchId
                         AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
          JOIN MovementBoolean AS MovementBoolean_isLoad 
                               ON MovementBoolean_isLoad.MovementId = Movement.Id
                              AND MovementBoolean_isLoad.DescId = zc_MovementBoolean_isLoad()
                              AND MovementBoolean_isLoad.ValueData = TRUE
     WHERE Movement.DescId = zc_Movement_Money()
       AND Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.StatusId <> zc_Enum_Status_Erased()) AS Money
                          ON Money.InvNumber = Money1C.InvNumber AND Money.OperDate = Money1C.OperDate
                         AND ObjectLink_Partner1CLink_Partner.ChildObjectId = Money.PartnerId
            
          WHERE Money1C.InvNumber = inInvNumber AND Money1C.OperDate = inOperDate AND Money1C.ClientCode = inClientCode
            AND ((Money1C.VIDDOC = '1') OR (Money1C.VIDDOC = '2')) AND inBranchId = zfGetBranchFromUnitId (Money1C.UnitId);

          -- сохранили Документ
          SELECT tmp.ioId INTO vbMovementId
          FROM lpInsertUpdate_Movement_Money (ioId := vbMovementId, inInvNumber := vbInvNumber, inInvNumberPartner := vbInvNumber, inInvNumberOrder := ''
                                           , inOperDate := vbOperDate, inOperDatePartner := vbOperDate, inChecked := FALSE, inPriceWithVAT := FALSE, inVATPercent := 20
                                           , inChangePercent := - vbDiscount, inFromId := vbUnitId, inToId := vbPartnerId, inPaidKindId:= vbPaidKindId
                                           , inContractId:= vbContractId, ioPriceListId:= 0, inRouteSortingId:= 0
                                           , inCurrencyDocumentId:= 14461 -- грн
                                           , inCurrencyPartnerId:= NULL
                                           , inUserId := vbUserId
                                            ) AS tmp;
          -- сохранили свойство <Загружен из 1С>
          PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isLoad(), vbMovementId, TRUE);
          -- пометим записи на удаление ПОКА
          PERFORM gpSetErased_MovementItem(MovementItem.Id, inSession) FROM MovementItem WHERE MovementItem.MovementId = vbMovementId;
    */     
         
    
     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 02.09.14                         * 
*/

-- тест
-- SELECT * FROM gpLoadMoneyFrom1C('01-01-2013'::TDateTime, '01-01-2014'::TDateTime, '')
