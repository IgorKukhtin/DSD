-- Function: gpGet_Movement_OrderFinance_ReportName()

DROP FUNCTION IF EXISTS gpGet_Movement_OrderFinance_ReportName (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_OrderFinance_ReportName (
    IN inMovementId         Integer  , -- ключ Документа
    IN inSession            TVarChar   -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbPrintFormName TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Sale());

     vbPrintFormName:=
       (SELECT 'PrintMovement_OrderFinance_xls' AS PrintFormName);

     RETURN (vbPrintFormName);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.12.25         *
*/

-- тест
-- SELECT gpGet_Movement_OrderFinance_ReportName FROM gpGet_Movement_OrderFinance_ReportName(inMovementId := 3924205,  inSession := zfCalc_UserAdmin()); -- все