-- Function: gpGet_Movement_OrderPartner_FileName()

DROP FUNCTION IF EXISTS gpGet_Movement_OrderPartner_FileName (Integer,  TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_OrderPartner_FileName (
    IN inMovementId         Integer  , -- ключ Документа
    IN inSession            TVarChar   -- сессия пользователя
)
RETURNS TABLE (FileName  TVarChar)
AS
$BODY$
   DECLARE vbFileName  TVarChar;
BEGIN

     -- Результат
     RETURN QUERY
        SELECT ('OrderPartner_'
               ||COALESCE (Movement.InvNumber,'')||'_'
               ||zfConvert_DateShortToString (Movement.OperDate)
                ) ::TVarChar AS FileName                         -- Названия файла - для сохранения PDF 
        FROM Movement
        WHERE Movement.Id = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.01.26         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_OrderPartner_FileName (inMovementId := 1808 , inSession := zfCalc_UserAdmin());
