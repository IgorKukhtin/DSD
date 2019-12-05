-- Function: gpGet_PUSH_Farmacy(TVarChar)

DROP FUNCTION IF EXISTS gpGet_PUSH_Farmacy(TVarChar);

CREATE OR REPLACE FUNCTION gpGet_PUSH_Farmacy(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Text TBlob,
               FormName TVarChar, Button TVarChar, Params TVarChar, TypeParams TVarChar, ValueParams TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbRetailId Integer;
   DECLARE vbMovementID Integer;
   DECLARE vbEmployeeShow Boolean;
   DECLARE vbPositionID Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical());

    CREATE TEMP TABLE _PUSH (Id  Integer
                           , Text TBlob
                           , FormName TVarChar
                           , Button TVarChar
                           , Params TVarChar
                           , TypeParams TVarChar
                           , ValueParams TVarChar) ON COMMIT DROP;

    SELECT ObjectLink_Member_Position.ObjectId
    INTO vbPositionID
    FROM ObjectLink AS ObjectLink_User_Member

                  LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                                       ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                                      AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()

    WHERE ObjectLink_User_Member.ObjectId = vbUserId
      AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member();


   -- Перемещения по СУН открытие "Реестр перемещений СУН"
   IF COALESCE(vbPositionID, 0) = 1690028 AND
      EXISTS(SELECT 1
             FROM  Movement
                   INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                              ON MovementBoolean_SUN.MovementId = Movement.Id
                                             AND MovementBoolean_SUN.DescId     = zc_MovementBoolean_SUN()
                                             AND MovementBoolean_SUN.ValueData  = TRUE
                   LEFT JOIN MovementBoolean AS MovementBoolean_NotDisplaySUN
                                             ON MovementBoolean_NotDisplaySUN.MovementId = Movement.Id
                                            AND MovementBoolean_NotDisplaySUN.DescId = zc_MovementBoolean_NotDisplaySUN()
                   INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                ON MovementLinkObject_From.MovementId = Movement.Id
                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                               AND MovementLinkObject_From.ObjectId = vbUnitId
             WHERE Movement.DescId   = zc_Movement_Send()
               AND Movement.OperDate = CURRENT_DATE
               AND Movement.StatusId = zc_Enum_Status_Erased()
               AND COALESCE (MovementBoolean_NotDisplaySUN.ValueData, FALSE) = FALSE
            )
      AND (DATE_PART('HOUR',    CURRENT_TIME)::Integer <= 12
        OR (DATE_PART('HOUR',    CURRENT_TIME)::Integer > 12
        AND DATE_PART('MINUTE',  CURRENT_TIME)::Integer >= 00
        AND DATE_PART('MINUTE',  CURRENT_TIME)::Integer <= 16
           ))
      AND vbUnitId NOT IN (SELECT OB.ObjectId FROM ObjectBoolean AS OB WHERE OB.ValueData = TRUE AND OB.DescId = zc_ObjectBoolean_Unit_SUN_v2())
   THEN
      IF (SELECT COUNT(*)
          FROM  Movement
                INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                           ON MovementBoolean_SUN.MovementId = Movement.Id
                                          AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                          AND MovementBoolean_SUN.ValueData = True
                LEFT JOIN MovementBoolean AS MovementBoolean_NotDisplaySUN
                                          ON MovementBoolean_NotDisplaySUN.MovementId = Movement.Id
                                         AND MovementBoolean_NotDisplaySUN.DescId = zc_MovementBoolean_NotDisplaySUN()
                INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                            AND MovementLinkObject_From.ObjectId = vbUnitId
          WHERE Movement.DescId = zc_Movement_Send()
            AND Movement.OperDate = CURRENT_DATE
            AND Movement.StatusId = zc_Enum_Status_Erased()
            AND COALESCE (MovementBoolean_NotDisplaySUN.ValueData, FALSE) = FALSE) = 1
      THEN
        INSERT INTO _PUSH (Id, Text, FormName, Button, Params, TypeParams, ValueParams)
          SELECT 6, 'Коллеги, сегодня было сформировано перемещение от вас по СУН, ознакомьтесь с деталями в "Перемещениях"!'||
                    CASE WHEN date_part('DOW',     CURRENT_DATE)::Integer <= 5
                          AND date_part('HOUR',    CURRENT_TIME)::Integer < 12
                         THEN Chr(13)||Chr(13)||'Просьба собрать товар сегодня до 12:00!' ELSE '' END,
                    'TSendForm', 'Перемещение СУН', 'Id,inOperDate', 'ftInteger,ftDateTime',
                    Movement.ID::TVarChar||','||CURRENT_DATE::TVarChar
          FROM  Movement
                INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                           ON MovementBoolean_SUN.MovementId = Movement.Id
                                          AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                          AND MovementBoolean_SUN.ValueData = True
                LEFT JOIN MovementBoolean AS MovementBoolean_NotDisplaySUN
                                          ON MovementBoolean_NotDisplaySUN.MovementId = Movement.Id
                                         AND MovementBoolean_NotDisplaySUN.DescId = zc_MovementBoolean_NotDisplaySUN()
                INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                            AND MovementLinkObject_From.ObjectId = vbUnitId
          WHERE Movement.DescId = zc_Movement_Send()
            AND Movement.OperDate = CURRENT_DATE
            AND Movement.StatusId = zc_Enum_Status_Erased()
            AND COALESCE (MovementBoolean_NotDisplaySUN.ValueData, FALSE) = FALSE
          LIMIT 1;
      ELSE
        INSERT INTO _PUSH (Id, Text, FormName, Button, Params, TypeParams, ValueParams)
        VALUES (6, 'Коллеги, сегодня было сформировано перемещение от вас по СУН, ознакомьтесь с деталями в "Перемещениях"!'||
                    CASE WHEN date_part('DOW',     CURRENT_DATE)::Integer <= 5
                          AND date_part('HOUR',    CURRENT_TIME)::Integer < 12
                         THEN Chr(13)||Chr(13)||'Просьба собрать товар сегодня до 12:00!' ELSE '' END,
                   'TSendCashJournalSunForm', 'Реестр перемещений СУН', 'isSUNAll', 'ftBoolean', 'False');
      END IF;
   END IF;

     -- Коллеги, ожидайте, на вас следует перемещение по СУН!. после отправлено
   IF EXISTS(SELECT 1
             FROM  Movement
                   INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                              ON MovementBoolean_SUN.MovementId = Movement.Id
                                             AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                             AND MovementBoolean_SUN.ValueData = True
                   INNER JOIN MovementBoolean AS MovementBoolean_Sent
                                              ON MovementBoolean_Sent.MovementId = Movement.Id
                                             AND MovementBoolean_Sent.DescId = zc_MovementBoolean_Sent()
                                             AND MovementBoolean_Sent.ValueData = True
                   LEFT JOIN MovementBoolean AS MovementBoolean_Received
                                              ON MovementBoolean_Received.MovementId = Movement.Id
                                             AND MovementBoolean_Received.DescId = zc_MovementBoolean_Received()
                   INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                 ON MovementLinkObject_To.MovementId = Movement.Id
                                                AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                AND MovementLinkObject_To.ObjectId = vbUnitId
                   INNER JOIN MovementDate AS MovementDate_Sent
                                           ON MovementDate_Sent.MovementId = Movement.Id
                                          AND MovementDate_Sent.DescId = zc_MovementDate_Sent()
                                          AND MovementDate_Sent.ValueData >= CURRENT_TIMESTAMP - INTERVAL '20 MIN'
             WHERE Movement.DescId = zc_Movement_Send()
               AND Movement.StatusId = zc_Enum_Status_UnComplete()
               AND COALESCE (MovementBoolean_Received.ValueData, False) = False)
   THEN
     INSERT INTO _PUSH (Id, Text) VALUES (7, 'Коллеги, ожидайте, на вас следует перемещение по СУН!');
   END IF;

     -- Коллеги, ожидайте, на вас следует перемещение по СУН!. в 16:00
   IF date_part('HOUR',    CURRENT_TIME)::Integer = 16
     AND date_part('MINUTE',  CURRENT_TIME)::Integer >= 00
     AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 20
   THEN
      IF EXISTS(SELECT 1
                FROM  Movement
                      INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                 ON MovementBoolean_SUN.MovementId = Movement.Id
                                                AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                                AND MovementBoolean_SUN.ValueData = True
                      INNER JOIN MovementBoolean AS MovementBoolean_Sent
                                                 ON MovementBoolean_Sent.MovementId = Movement.Id
                                                AND MovementBoolean_Sent.DescId = zc_MovementBoolean_Sent()
                                                AND MovementBoolean_Sent.ValueData = True
                      LEFT JOIN MovementBoolean AS MovementBoolean_Received
                                                ON MovementBoolean_Received.MovementId = Movement.Id
                                               AND MovementBoolean_Received.DescId = zc_MovementBoolean_Received()
                                               AND MovementBoolean_Received.ValueData = False
                      INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                    ON MovementLinkObject_To.MovementId = Movement.Id
                                                   AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                   AND MovementLinkObject_To.ObjectId = vbUnitId
                WHERE Movement.DescId = zc_Movement_Send()
                  AND Movement.StatusId = zc_Enum_Status_UnComplete()
                  AND COALESCE (MovementBoolean_Received.ValueData, False) = False)
      THEN
        INSERT INTO _PUSH (Id, Text) VALUES (8, 'Коллеги, ожидайте, на вас следует перемещение по СУН!');
      END IF;
   END IF;

   RETURN QUERY
     SELECT _PUSH.Id                     AS Id
          , _PUSH.Text                   AS Text
          , _PUSH.FormName               AS FormName
          , _PUSH.Button                 AS Button
          , _PUSH.Params                 AS Params
          , _PUSH.TypeParams             AS TypeParams
          , _PUSH.ValueParams            AS ValueParams
     FROM _PUSH;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.12.19                                                       *

*/

-- тест
-- SELECT * FROM gpGet_PUSH_Farmacy('4127945')
-- SELECT * FROM gpGet_PUSH_Farmacy('3')