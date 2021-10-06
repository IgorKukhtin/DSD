-- Function: gpGet_Movement_TransportGoods_ReportName()

DROP FUNCTION IF EXISTS gpGet_Movement_TransportGoods_ReportName (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_TransportGoods_ReportName (
    IN inMovementId         Integer  , -- ключ Документа
    IN inSession            TVarChar   -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbPrintFormName TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_TransportGoods());

       SELECT COALESCE (PrintForms_View.PrintFormName, 'PrintMovement_TTN')
              INTO vbPrintFormName
       FROM Movement
            LEFT JOIN PrintForms_View
                   ON Movement.OperDate BETWEEN PrintForms_View.StartDate AND PrintForms_View.EndDate
                  AND PrintForms_View.JuridicalId = 0
                  AND PrintForms_View.ReportType = 'TransportGoods'
                  AND PrintForms_View.DescId = zc_Movement_TransportGoods()
       WHERE Movement.Id = inMovementId
       ;

     RETURN (vbPrintFormName);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.10.21         *
*/

-- тест
--SELECT gpGet_Movement_TransportGoods_ReportName FROM gpGet_Movement_TransportGoods_ReportName(inMovementId := 21045471,  inSession := '5'); -- все
