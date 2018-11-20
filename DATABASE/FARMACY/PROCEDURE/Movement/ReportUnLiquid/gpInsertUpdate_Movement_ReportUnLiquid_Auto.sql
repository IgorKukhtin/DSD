-- Function: gpInsertUpdate_Movement_ReportUnLiquid()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReportUnLiquid_Auto (Integer, TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ReportUnLiquid_Auto (
 INOUT ioId                  Integer   ,
    IN inStartSale           TDateTime , -- Дата начала отчета
    IN inEndSale             TDateTime , -- Дата окончания отчета
    IN inUnitId              Integer   , -- Юридические лица
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReportUnLiquid());
     vbUserId := inSession;

     -- 
     ioId := lpInsertUpdate_Movement_ReportUnLiquid (ioId         := COALESCE (ioId, 0) :: Integer
                                                   , inInvNumber  := CAST (NEXTVAL ('movement_ReportUnLiquid_seq') AS TVarChar)
                                                   , inOperDate   := CURRENT_DATE       :: TDateTime
                                                   , inStartSale  := inStartSale
                                                   , inEndSale    := inEndSale
                                                   , inUnitId     := inUnitId
                                                   , inComment    := ''                 ::TVarChar
                                                   , inUserId     := vbUserId
                                                     );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.11.18         *
*/

-- тест
--