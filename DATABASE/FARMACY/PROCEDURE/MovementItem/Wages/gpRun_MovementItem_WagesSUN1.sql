-- Function: lpInsertUpdate_MovementItem_WagesSUN1 ()

DROP FUNCTION IF EXISTS gpRun_MovementItem_WagesSUN1 (TVarChar);

CREATE OR REPLACE FUNCTION gpRun_MovementItem_WagesSUN1(
    IN inSession     TVarChar       -- сессия пользователя
 )
RETURNS VOID AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE text_var1   Text;
   DECLARE vbOparDate  TDateTime;
BEGIN

    vbUserId := inSession;

    IF CURRENT_DATE < '20.02.2020'
    THEN
      PERFORM lpLog_Run_Schedule_Function('gpRun_MovementItem_WagesSUN1', False, 'Пропущено по дата ранее старта'::TVarChar, vbUserId);
      RETURN;
    END IF;

    IF date_part('DOW', CURRENT_DATE)::Integer = 4
    THEN
      vbOparDate := CURRENT_DATE - INTERVAL '2 day';
    ELSEIF  date_part('DOW', CURRENT_DATE)::Integer = 5
    THEN
      vbOparDate := CURRENT_DATE - INTERVAL '3 day';
    ELSEIF  date_part('DOW', CURRENT_DATE)::Integer = 1
    THEN
      vbOparDate := CURRENT_DATE - INTERVAL '6 day';
    ELSE
      PERFORM lpLog_Run_Schedule_Function('gpRun_MovementItem_WagesSUN1', False, 'Пропущено по дню недели'::TVarChar, vbUserId);
      RETURN;
    END IF;

     -- Расчет необходимости штрафа
    BEGIN
        PERFORM lpInsertUpdate_MovementItem_WagesSUN1 (inOparDate := CURRENT_DATE, inUnitID := T1.UnitID, inUserId := vbUserId)
        FROM (SELECT MovementLinkObject_From.ObjectId AS UnitID
              FROM Movement
                   INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                              ON MovementBoolean_SUN.MovementId = Movement.Id
                                             AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                             AND MovementBoolean_SUN.ValueData = TRUE
                   LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                             ON MovementBoolean_Deferred.MovementId = Movement.Id
                                            AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                   LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                ON MovementLinkObject_From.MovementId = Movement.Id
                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
              WHERE Movement.OperDate >= '11.02.2020'
                AND Movement.DescId = zc_Movement_Send()
                AND Movement.StatusId <> zc_Enum_Status_Complete()
                AND COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = FALSE
              GROUP BY MovementLinkObject_From.ObjectId) AS T1;

        PERFORM lpLog_Run_Schedule_Function('gpRun_MovementItem_WagesSUN1', False, 'Выполнено'::TVarChar, vbUserId);
    EXCEPTION
        WHEN others THEN
          GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
        PERFORM lpLog_Run_Schedule_Function('gpRun_MovementItem_WagesSUN1', True, text_var1::TVarChar, vbUserId);
    END;

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.02.20                                                        *
*/

-- тест
-- SELECT * FROM Log_Run_Schedule_Function
-- SELECT * FROM gpRun_MovementItem_WagesSUN1 (inSession := zfCalc_UserAdmin())