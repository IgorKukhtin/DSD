-- Function: gpGet_Movement_CashCloseReturn()

DROP FUNCTION IF EXISTS gpGet_Movement_CashCloseReturn (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_CashCloseReturn(
    IN inMovementId        Integer  , -- ключ Документа
   OUT outSummaTotal       TFloat   ,
   OUT outPaidType         Integer  ,
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbStatusId Integer;
BEGIN

      vbUserId:= lpGetUserBySession (inSession);

       -- пересчитали Итоговые суммы
      PERFORM lpInsertUpdate_MovementFloat_TotalSummReturnIn (inMovementId);

      PERFORM lpCheckComplete_Movement_ReturnIn (inMovementId, vbUserId);

      SELECT Movement_ReturnIn.StatusId
           , MovementFloat_TotalSumm.ValueData          AS TotalSumm
           , COALESCE(Object_PaidTypeCheck.ObjectCode, 0)  AS PaidTypeCheck
      INTO vbStatusId
         , outSummaTotal
         , outPaidType
      FROM Movement AS Movement_ReturnIn

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement_ReturnIn.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementFloat AS MovementFloat_MovementId
                                    ON MovementFloat_MovementId.MovementId = Movement_ReturnIn.Id
                                   AND MovementFloat_MovementId.DescId = zc_MovementFloat_MovementId()
            LEFT JOIN Movement AS MovementCheck ON MovementCheck.ID = MovementFloat_MovementId.ValueData::Integer

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidTypeCheck
                                         ON MovementLinkObject_PaidTypeCheck.MovementId = MovementCheck.Id
                                        AND MovementLinkObject_PaidTypeCheck.DescId = zc_MovementLinkObject_PaidType()
            LEFT JOIN Object AS Object_PaidTypeCheck ON Object_PaidTypeCheck.Id = MovementLinkObject_PaidTypeCheck.ObjectId
      WHERE Movement_ReturnIn.Id = inMovementId
        AND Movement_ReturnIn.DescId = zc_Movement_ReturnIn()
      ;

      IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_UnComplete()
      THEN
        RAISE EXCEPTION 'Ошибка. Пробитие чека по документу в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
      END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
10.08.20                                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_CashCloseReturn (inMovementId:= 19806544 , inSession:= '3')