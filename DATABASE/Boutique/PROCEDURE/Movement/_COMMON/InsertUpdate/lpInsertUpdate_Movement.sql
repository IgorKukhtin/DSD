-- Function: lpInsertUpdate_Movement (Integer, Integer, TVarChar, TDateTime, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement (Integer, Integer, TVarChar, TDateTime, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement (Integer, Integer, TVarChar, TDateTime, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement (Integer, Integer, TVarChar, TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement (
 INOUT ioId        Integer   , --
    IN inDescId    Integer   , --
    IN inInvNumber TVarChar  , --
    IN inOperDate  TDateTime , --
    IN inParentId  Integer   , --
    IN inUserId    Integer     -- 
  )
RETURNS Integer
AS
$BODY$
  DECLARE vbStatusId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     IF inOperDate <> DATE_TRUNC('DAY', inOperDate) THEN
        RAISE EXCEPTION 'Ошибка.inOperDate = <%>', inOperDate;
     END IF;

     -- меняем параметр
     IF inParentId = 0
     THEN
         inParentId := NULL;
     END IF;


     IF COALESCE (ioId, 0) = 0 THEN
        INSERT INTO Movement (DescId, InvNumber, OperDate, StatusId, ParentId)
                      VALUES (inDescId, inInvNumber, inOperDate, zc_Enum_Status_UnComplete(), inParentId)
                      RETURNING Id INTO ioId;
     ELSE
        --
        UPDATE Movement SET DescId    = inDescId
                          , InvNumber = inInvNumber
                          , OperDate  = inOperDate
                          , ParentId  = inParentId
        WHERE Id = ioId
        RETURNING StatusId INTO vbStatusId;

        --
        IF vbStatusId <> zc_Enum_Status_UnComplete() THEN
           RAISE EXCEPTION 'Ошибка.Изменение документа № <%> в статусе <%> не возможно.', inInvNumber, lfGet_Object_ValueData (vbStatusId);
        END IF;
        --
        IF vbStatusId = zc_Enum_Status_Complete() THEN
           RAISE EXCEPTION 'Ошибка.Изменение документа № <%> в статусе <%> не возможно.', inInvNumber, lfGet_Object_ValueData (vbStatusId);
        END IF;

        --
        IF NOT FOUND
        THEN
            INSERT INTO Movement (Id, DescId, InvNumber, OperDate, StatusId, ParentId)
                          VALUES (ioId, inDescId, inInvNumber, inOperDate, zc_Enum_Status_UnComplete(), inParentId)
                          RETURNING Id INTO ioId;
        END IF;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
 09.06.17                                                       *  add inUserId
 05.06.17                                        * all
*/

-- тест
--
