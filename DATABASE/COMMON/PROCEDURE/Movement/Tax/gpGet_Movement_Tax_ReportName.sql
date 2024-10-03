-- Function: gpGet_Movement_Tax_ReportName()

DROP FUNCTION IF EXISTS gpGet_Movement_Tax_ReportName (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_Tax_ReportName (
    IN inMovementId         Integer  , -- ключ Документа
    IN inSession            TVarChar   -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbPrintFormName TVarChar;
   DECLARE vbUserId Integer;
BEGIN
       -- проверка прав пользователя на вызов процедуры
       -- PERFORM lpCheckRight (inSession, zc_Enum_Process_...());
       vbUserId:= lpGetUserBySession (inSession);


       -- поиск формы
       SELECT COALESCE (PrintForms_View.PrintFormName, 'PrintMovement_Tax')
              INTO vbPrintFormName
       FROM (-- поиск даты
             SELECT MAX (CASE /*WHEN (CURRENT_DATE >= '01.03.2021'  OR vbUserId = 5) AND COALESCE (MovementString_InvNumberRegistered.ValueData, '') = ''
                                   THEN '01.03.2021'
                               */
                              WHEN Movement.OperDate < '01.03.2017' AND MovementDate_DateRegistered.ValueData >= '01.03.2017'
                                   THEN Movement.OperDate
                              WHEN COALESCE (MovementString_InvNumberRegistered.ValueData, '') = ''
                                   THEN '01.10.2024'
                              WHEN Movement.OperDate > COALESCE (MovementDate_DateRegistered.ValueData, Movement.OperDate)
                                   THEN Movement.OperDate
                              ELSE COALESCE (MovementDate_DateRegistered.ValueData, Movement.OperDate)
                         END) AS OperDate
             FROM Movement
                  LEFT JOIN MovementDate AS MovementDate_DateRegistered
                                         ON MovementDate_DateRegistered.MovementId = Movement.Id
                                        AND MovementDate_DateRegistered.DescId     = zc_MovementDate_DateRegistered()
                  LEFT JOIN MovementString AS MovementString_InvNumberRegistered
                                           ON MovementString_InvNumberRegistered.MovementId = Movement.Id
                                          AND MovementString_InvNumberRegistered.DescId     = zc_MovementString_InvNumberRegistered()
             WHERE Movement.Id =  inMovementId
               AND Movement.DescId = zc_Movement_Tax()
            ) AS Movement
            LEFT JOIN PrintForms_View
                   ON Movement.OperDate BETWEEN PrintForms_View.StartDate AND PrintForms_View.EndDate
                  AND PrintForms_View.ReportType = 'Tax'
       ;

       -- Результат
       RETURN (vbPrintFormName);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Tax_ReportName (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 28.03.16                                        *
 27.02.14                                                        *
 05.02.14                                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Tax_ReportName (inMovementId:= 3414237 , inSession:= '5'); -- все
