DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_Site (
  Integer   , -- Ключ объекта <Документ ЧЕК>
  Integer   , -- Ключ объекта <Подразделение>
  TDateTime , --Дата/время документа
  TVarChar  , --Покупатель ВИП 
  TVarChar);
  
CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Check_Site(
 INOUT ioId                Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inUnitId            Integer   , -- Ключ объекта <Подразделение>
    IN inDate              TDateTime , --Дата/время документа
    IN inBayer             TVarChar  , --Покупатель ВИП 
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbInvNumber Integer;
   DECLARE vbCashRegisterId Integer;
   DECLARE vbPaidTypeId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderInternal());
    vbUserId := inSession;

    IF inDate is null
    THEN
        inDate := CURRENT_TIMESTAMP::TDateTime;
    END IF;
    
    IF COALESCE(ioId,0) = 0
    THEN
        SELECT 
            COALESCE(MAX(zfConvert_StringToNumber(InvNumber)), 0) + 1 
        INTO 
            vbInvNumber
        FROM 
            Movement_Check_View 
        WHERE 
            Movement_Check_View.UnitId = inUnitId 
            AND 
            Movement_Check_View.OperDate > CURRENT_DATE;
    ELSE
        SELECT
            InvNumber
        INTO
            vbInvNumber
        FROM 
            Movement_Check_View 
        WHERE 
            Movement_Check_View.Id = ioId;
    END IF;
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Check(), vbInvNumber::TVarChar, inDate, NULL);
    -- сохранили связь с <Подразделением>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
    --прописываем ФИО покупателя
    PERFORM lpInsertUpdate_MovementString(zc_MovementString_Bayer(), ioId, inBayer);
    --Отмечаем документ как отложенный
    PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_Deferred(), ioId, True);      
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Movement_Check_Site (Integer,Integer,TDateTime,TVarChar,TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 17.12.15                                                                       *

*/
--Select * from gpInsertUpdate_Movement_Check_Site(ioId := 0, inUnitId := 183293, inDate := NULL::TDateTime, inBayer := 'Test Bayer'::TVarChar, inSession := '3'::TVarChar);