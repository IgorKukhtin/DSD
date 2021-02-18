-- Function: gpInsertUpdate_Movement_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Income(Integer, TVarChar, TDateTime, Boolean, Integer, Integer, Integer, Integer, TDateTime, TVarChar, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Income(Integer, TVarChar, TDateTime, Boolean, Boolean, Integer, Integer, Integer, Integer, TDateTime, TVarChar, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Income(Integer, TVarChar, TDateTime, Boolean, Boolean, Integer, Integer, Integer, Integer, TDateTime, TVarChar, TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Income(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inisDifferent         Boolean   , -- точка др. юр. лица
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому
    IN inNDSKindId           Integer   , -- Типы НДС
    IN inContractId          Integer   , -- Договор
   -- IN inOrderId             Integer   , -- Сcылка на заявку поставщику 
    IN inPaymentDate         TDateTime , -- Дата платежа
    IN inInvNumberBranch     TVarChar  , -- Номер документа
    IN inOperDateBranch      TDateTime , -- Дата документа
 INOUT ioJuridicalId         Integer   , -- Юрлицо покупатель
   OUT outJuridicalName      TVarChar  , -- Юрлицо покупатель
    IN inComment             TVarChar  , -- Примечание
    IN inisUseNDSKind        Boolean   , -- Использовать ставку НДС по приходу
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOldContractId Integer;
   DECLARE vbDeferment Integer;
   DECLARE vbInvNumber TVarChar;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Income());
    vbUserId := inSession;
    -- Получаем старый договор. Если он отличается от текущего, то берем новую дату платежа

    -- определяем <Номер документа>
    SELECT InvNumber INTO vbInvNumber FROM Movement WHERE Id = ioId;

    IF COALESCE (vbInvNumber, '') <> '' AND COALESCE (vbInvNumber, '') <> COALESCE (inInvNumber, '')
    THEN
        RAISE EXCEPTION 'Ошибка. Для изменения номера документа используйте кнопку <Установить № и дату документа> или <Установить № документа и дату оплаты>.';
    END IF;

    SELECT ContractId INTO vbOldContractId FROM Movement_Income_View WHERE Movement_Income_View.Id = ioId;

    IF COALESCE(vbOldContractId, 0) <> inContractId THEN 
       SELECT Deferment INTO vbDeferment 
         FROM Object_Contract_View WHERE Object_Contract_View.Id = inContractId;
       inPaymentDate := inOperDate + vbDeferment * interval '1 day';  
    END IF;

    --определить юрлицо
    IF COALESCE(ioJuridicalId,0) = 0
    THEN
        SELECT
            Object.Id,
            Object.ValueData
        INTO
            ioJuridicalId,
            outJuridicalName
        FROM
            ObjectLink
            Inner Join object ON ObjectLink.ChildObjectId = Object.Id
        WHERE
            ObjectLink.ObjectId = inToId
            AND
            ObjectLink.DescId = zc_ObjectLink_Unit_Juridical();
    ELSE
        outJuridicalName = (Select ValueData from Object Where Id = ioJuridicalId);
    END IF;
    
    ioId := lpInsertUpdate_Movement_Income(ioId, inInvNumber, inOperDate, inPriceWithVAT
                                         , inFromId, inToId, inNDSKindId, inContractId--, inOrderId
                                         , inPaymentDate, ioJuridicalId, inisDifferent, inComment
                                         , inisUseNDSKind, vbUserId);

    PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberBranch(), ioId, inInvNumberBranch);

    --дата аптеки сохранять только после нажатия кнопки рассчитать расходную цену , поэтому здесь не сохраняем
    /*IF COALESCE (inInvNumberBranch,'') <> ''
    THEN
        -- 
        PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Branch(), ioId, inOperDateBranch);
    END IF;
    */

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В.
 14.04.20                                                                                    * UseNDSKind
 06.05.16         * del inOrderId
 22.04.16         *
 21.12.15                                                                       *
 07.12.15                                                                       *
 20.05.15                         *
 24.12.14                         *
 02.12.14                                                        *
 10.07.14                                                        *


*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Income (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')