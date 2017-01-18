-- Function: gpInsertUpdate_MI_PersonalService_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_From_Excel (Integer,  TVarChar, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PersonalService_From_Excel(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inINN                 TVarChar  , -- 
    IN inSum1                TFloat    , -- Сумма1
    IN inSum2                TFloat    , -- Сумма2
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService());
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE(inMovementId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Документ не записан';
     END IF;

     IF COALESCE(inINN, '') = '' THEN
        RETURN;
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.01.17         *
*/

-- тест
--select * from gpInsertUpdate_MI_PersonalService_From_Excel(inMovementId :=0 , inINN := '2565555555', inSum1 := 15 ::TFloat, inSum2 := 45 ::TFloat , inSession :='3':: TVarChar)