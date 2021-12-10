-- Function: gpGet_SheetWorkTime_ShowPUSH (TVarChar)

DROP FUNCTION IF EXISTS gpGet_SheetWorkTime_ShowPUSH (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_SheetWorkTime_ShowPUSH(
   OUT outShowMessage Boolean,          -- Показыват сообщение
   OUT outPUSHType    Integer,          -- Тип сообщения
   OUT outText        Text,             -- Текст сообщения
    IN inSession      TVarChar          -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    outShowMessage := FALSE;

    IF vbUserId = 5
    THEN

    -- Проверка - период закрыт
    IF  EXISTS (SELECT 1
                FROM Movement
                     INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                             ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                            AND MovementDate_OperDateEnd.DescId   = zc_MovementDate_OperDateEnd()
                                            AND MovementDate_OperDateEnd.ValueData - INTERVAL '2 DAY' <= CURRENT_DATE
                     LEFT JOIN MovementDate AS MovementDate_TimeClose
                                            ON MovementDate_TimeClose.MovementId = Movement.Id
                                           AND MovementDate_TimeClose.DescId = zc_MovementDate_TimeClose()
                     LEFT JOIN MovementBoolean AS MovementBoolean_ClosedAuto
                                               ON MovementBoolean_ClosedAuto.MovementId = Movement.Id
                                              AND MovementBoolean_ClosedAuto.DescId = zc_MovementBoolean_ClosedAuto()
                WHERE Movement.DescId = zc_Movement_SheetWorkTimeClose()
                  AND Movement.OperDate >= DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 MONTH'
                  AND Movement.StatusId = zc_Enum_Status_Complete()
                  AND MovementBoolean_ClosedAuto.ValueData = TRUE AND MovementDate_TimeClose.ValueData + INTERVAL '3 DAY' >= CURRENT_TIMESTAMP
               )
    THEN
        outText:= 'Внимание!!!!'
       ||CHR(13)||'_______числа текущего месяца'
       ||CHR(13)||'в       _________часов будет осуществлено закрытие табеля.'
       ||CHR(13)||'Редактирование данных в закрытом периоде будет недоступно!!!'
       ||CHR(13)||'Нажмите «ОК», что вы ознакомлены;'
    END IF;

    --
    IF COALESCE (outText, '') <> ''
    THEN
      outShowMessage := True;
      outPUSHType := 3;
     END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.11.21                                        *
*/

-- SELECT * FROM gpGet_SheetWorkTime_ShowPUSH (inSession:= zfCalc_UserAdmin())
