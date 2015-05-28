-- Function: lpInsertUpdate_Movement_Medoc()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Medoc 
   (Integer, Integer, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TDateTime, TVarChar, TVarChar, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Medoc(
 INOUT ioId                  Integer    , 
    IN inMedocCode           Integer    ,
    IN inInvNumberPartner    TVarChar   , -- Номер
    IN inOperDate            TDateTime  , -- Дата
    IN inFromINN             TVarChar   , -- ИНН от кого
    IN inToINN               TVarChar   , -- ИНН кому
    IN inInvNumberBranch     TVarChar   , -- Филиал
    IN inInvNumberRegistered TVarChar   , -- Номер
    IN inDateRegistered      TDateTime  , -- Дата
    IN inDocKind             TVarChar   , -- Тип документа
    IN inContract            TVarChar   , -- Договор
    IN inTotalSumm           TFloat     , -- Сумма документа
    IN inUserId              Integer      -- пользователь
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbisIncome Boolean;
BEGIN

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     SELECT ObjectBoolean_isCorporate.ValueData INTO vbisIncome FROM ObjectHistory_JuridicalDetails_View AS Juridical
                 JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                    ON ObjectBoolean_isCorporate.ObjectId = Juridical.JuridicalId 
                                   AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
         WHERE Juridical.INN = inToINN;


     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Medoc(), inMedocCode::TVarChar, inOperDate, NULL);

     -- сохранили свойство <Номер налогового документа>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);

     -- сохранили свойство <ИНН от кого>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_FromINN(), ioId, inFromINN);

     -- сохранили свойство <ИНН кому>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_ToINN(), ioId, inToINN);

     -- сохранили свойство <Филиал>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberBranch(), ioId, inInvNumberBranch);
     
     -- сохранили свойство <Номер регистрации>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberRegistered(), ioId, inInvNumberRegistered);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Desc(), ioId, inDocKind);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Contract(), ioId, inContract);

     PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_DateRegistered(), ioId, inDateRegistered);

     -- Приход
     PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_isIncome(), ioId, vbisIncome);

     -- Сохранили свойство <Итого  Сумма (затраты) >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), ioId, inTotalSumm);

     -- сохранили протокол
--     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.05.15                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_Loss (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
