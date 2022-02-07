-- Function: gpRun_MovementItem_WagesSUN1 ()

DROP FUNCTION IF EXISTS gpRun_MovementItem_WagesSUN1 (TVarChar);

CREATE OR REPLACE FUNCTION gpRun_MovementItem_WagesSUN1(
    IN inSession     TVarChar       -- сессия пользователя
 )
RETURNS VOID AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE text_var1   Text;
   DECLARE vbOparDate1  TDateTime;
   DECLARE vbOparDate2  TDateTime;
   DECLARE vbOparDate3  TDateTime;
BEGIN

    vbUserId := inSession;

    vbOparDate1 := CURRENT_DATE - INTERVAL '1 DAY';
    IF date_part('DOW', vbOparDate1)::Integer = 0 THEN vbOparDate1 := vbOparDate1 - INTERVAL '2 DAY'; END IF;

    vbOparDate2 := vbOparDate1 - INTERVAL '1 DAY';
    IF date_part('DOW', vbOparDate2)::Integer = 0 THEN vbOparDate2 := vbOparDate2 - INTERVAL '2 DAY'; END IF;

    vbOparDate3 := vbOparDate2 - INTERVAL '1 DAY';
    IF date_part('DOW', vbOparDate3)::Integer = 0 THEN vbOparDate3 := vbOparDate3 - INTERVAL '2 DAY'; END IF;

--    raise notice 'Прошло. % % %', vbOparDate1, vbOparDate2, vbOparDate3;

     -- Расчет необходимости штрафа
    BEGIN
        PERFORM lpInsertUpdate_MovementItem_WagesSUN1 (inSummaSUN1 := SummaSUN1, inUnitID := T1.UnitID, inInvNumber := InvNumber, inUserId := vbUserId)
        FROM (WITH
                tmpMovement AS (SELECT Movement.Id
                                     , Movement.InvNumber
                                FROM Movement
                                     INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                                ON MovementBoolean_SUN.MovementId = Movement.Id
                                                               AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                                               AND MovementBoolean_SUN.ValueData = TRUE
                                     LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                                               ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                              AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                     LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v2
                                                               ON MovementBoolean_SUN_v2.MovementId = Movement.Id
                                                              AND MovementBoolean_SUN_v2.DescId = zc_MovementBoolean_SUN_v2()
                                     LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v3
                                                               ON MovementBoolean_SUN_v3.MovementId = Movement.Id
                                                              AND MovementBoolean_SUN_v3.DescId = zc_MovementBoolean_SUN_v3()
                                     LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v4
                                                               ON MovementBoolean_SUN_v4.MovementId = Movement.Id
                                                              AND MovementBoolean_SUN_v4.DescId = zc_MovementBoolean_SUN_v4()
                                     LEFT JOIN MovementBoolean AS MovementBoolean_Sent
                                                               ON MovementBoolean_Sent.MovementId = Movement.Id
                                                              AND MovementBoolean_Sent.DescId = zc_MovementBoolean_Sent()
                                     LEFT JOIN MovementBoolean AS MovementBoolean_Received
                                                               ON MovementBoolean_Received.MovementId = Movement.Id
                                                              AND MovementBoolean_Received.DescId = zc_MovementBoolean_Received()
                                     LEFT JOIN MovementBoolean AS MovementBoolean_NotDisplaySUN
                                                               ON MovementBoolean_NotDisplaySUN.MovementId = Movement.Id
                                                              AND MovementBoolean_NotDisplaySUN.DescId = zc_MovementBoolean_NotDisplaySUN()
                                WHERE Movement.DescId = zc_Movement_Send()
                                  AND Movement.StatusId <> zc_Enum_Status_Complete()
                                  AND COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = FALSE
                                  AND COALESCE (MovementBoolean_SUN_v2.ValueData, FALSE) = FALSE
                                  AND COALESCE (MovementBoolean_SUN_v3.ValueData, FALSE) = FALSE
                                  AND COALESCE (MovementBoolean_SUN_v4.ValueData, FALSE) = FALSE
                                  AND COALESCE (MovementBoolean_Sent.ValueData, FALSE) = FALSE
                                  AND COALESCE (MovementBoolean_Received.ValueData, FALSE) = FALSE
                                  AND COALESCE (MovementBoolean_NotDisplaySUN.ValueData, FALSE) = FALSE)


              SELECT MovementLinkObject_From.ObjectId                                           AS UnitID
                   , CASE WHEN date_trunc('day', MovementDate_Insert.ValueData) = vbOparDate1 THEN - 200
                          WHEN date_trunc('day', MovementDate_Insert.ValueData) = vbOparDate2 THEN - 400
                          WHEN date_trunc('day', MovementDate_Insert.ValueData) = vbOparDate3 THEN - 750 END::TFloat AS SummaSUN1
                   , string_agg(Movement.InvNumber, ',')::TVarChar                              AS InvNumber
              FROM tmpMovement AS Movement
                   LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                ON MovementLinkObject_From.MovementId = Movement.Id
                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                   LEFT JOIN MovementDate AS MovementDate_Insert
                                          ON MovementDate_Insert.MovementId = Movement.Id
                                         AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
              WHERE date_trunc('day', MovementDate_Insert.ValueData) in (vbOparDate1, vbOparDate2, vbOparDate3)
              GROUP BY MovementLinkObject_From.ObjectId
                     , date_trunc('day', MovementDate_Insert.ValueData)) AS T1;

        PERFORM lpLog_Run_Schedule_Function('gpRun_MovementItem_WagesSUN1', FALSE, 'Выполнено'::TVarChar, vbUserId);
    EXCEPTION
        WHEN others THEN
          GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
        PERFORM lpLog_Run_Schedule_Function('gpRun_MovementItem_WagesSUN1', True, text_var1::TVarChar, vbUserId);
    END;

     -- Расчет СУН-Экспресс
    BEGIN
        PERFORM gpInsert_Movement_Send_RemainsSun_express (inOperDate:= CURRENT_DATE, inSession:= zfCalc_UserAdmin()); 
    EXCEPTION
        WHEN others THEN
          GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
        PERFORM lpLog_Run_Schedule_Function('gpInsert_Movement_Send_RemainsSun_express', True, text_var1::TVarChar, vbUserId);
    END;

     -- Расчет дополнения СУН1
    BEGIN
        PERFORM gpInsert_Movement_Send_RemainsSun_Supplement (inOperDate:= CURRENT_DATE, inSession:= zfCalc_UserAdmin()); 
    EXCEPTION
        WHEN others THEN
          GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
        PERFORM lpLog_Run_Schedule_Function('gpInsert_Movement_Send_RemainsSun_Supplement', True, text_var1::TVarChar, vbUserId);
    END;

     -- Расчет дополнения СУН2
    BEGIN
        PERFORM gpInsert_Movement_Send_RemainsSun_Supplement_V2 (inOperDate:= CURRENT_DATE, inSession:= zfCalc_UserAdmin()); 
    EXCEPTION
        WHEN others THEN
          GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
        PERFORM lpLog_Run_Schedule_Function('gpInsert_Movement_Send_RemainsSun_Supplement_V2', True, text_var1::TVarChar, vbUserId);
    END;

     -- Расчет UKTZED СУН1
    BEGIN
        PERFORM gpInsert_Movement_Send_RemainsSun_UKTZED (inOperDate:= CURRENT_DATE, inSession:= zfCalc_UserAdmin()); 
    EXCEPTION
        WHEN others THEN
          GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
        PERFORM lpLog_Run_Schedule_Function('gpInsert_Movement_Send_RemainsSun_UKTZED', True, text_var1::TVarChar, vbUserId);
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
-- SELECT * FROM Log_Run_Schedule_Function order by Log_Run_Schedule_Function.DateInsert desc LIMIT 50
-- SELECT * FROM gpRun_MovementItem_WagesSUN1 (inSession := zfCalc_UserAdmin())