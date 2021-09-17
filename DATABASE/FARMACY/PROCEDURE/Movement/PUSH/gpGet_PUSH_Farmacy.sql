-- Function: gpGet_PUSH_Farmacy(TVarChar)

--DROP FUNCTION IF EXISTS gpGet_PUSH_Farmacy(TVarChar);
DROP FUNCTION IF EXISTS gpGet_PUSH_Farmacy(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_PUSH_Farmacy(
    IN inNumberPUSH  Integer,       -- Порядковый номер вызова
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Text TBlob,
               FormName TVarChar, Button TVarChar, Params TVarChar, TypeParams TVarChar, ValueParams TVarChar, Beep Integer)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbRetailId Integer;
   DECLARE vbPositionID Integer;
   DECLARE vbText Text;
   DECLARE vbCount Integer;
   DECLARE vbDatePUSH TDateTime;
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
                           , ValueParams TVarChar
                           , Beep Integer) ON COMMIT DROP;

    SELECT ObjectLink_Member_Position.ChildObjectId
    INTO vbPositionID
    FROM ObjectLink AS ObjectLink_User_Member

                  LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                                       ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                                      AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()

    WHERE ObjectLink_User_Member.ObjectId = vbUserId
      AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member();

   vbDatePUSH := (SELECT ObjectDate.ValueData FROM ObjectDate
                  WHERE ObjectDate.ObjectId = vbUserId
                    AND ObjectDate.DescId = zc_ObjectDate_User_PUSH());

   -- сохранили дату
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_User_PUSH(), vbUserId, CURRENT_TIMESTAMP);

   -- Перемещения по СУН открытие "Реестр перемещений СУН"
   IF COALESCE(vbPositionID, 0) = 1690028 AND
      EXISTS(SELECT 1
             FROM  Movement
                   INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                              ON MovementBoolean_SUN.MovementId = Movement.Id
                                             AND MovementBoolean_SUN.DescId     = zc_MovementBoolean_SUN()
                                             AND MovementBoolean_SUN.ValueData  = TRUE
                   LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v2
                                             ON MovementBoolean_SUN_v2.MovementId = Movement.Id
                                            AND MovementBoolean_SUN_v2.DescId     = zc_MovementBoolean_SUN_v2()
                                            AND MovementBoolean_SUN_v2.ValueData  = TRUE
                   LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v3
                                             ON MovementBoolean_SUN_v3.MovementId = Movement.Id
                                            AND MovementBoolean_SUN_v3.DescId     = zc_MovementBoolean_SUN_v3()
                                            AND MovementBoolean_SUN_v3.ValueData  = TRUE
                   LEFT JOIN MovementBoolean AS MovementBoolean_NotDisplaySUN
                                             ON MovementBoolean_NotDisplaySUN.MovementId = Movement.Id
                                            AND MovementBoolean_NotDisplaySUN.DescId     = zc_MovementBoolean_NotDisplaySUN()
                                            AND MovementBoolean_NotDisplaySUN.ValueData  = TRUE
                   INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                 ON MovementLinkObject_From.MovementId = Movement.Id
                                                AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                                AND MovementLinkObject_From.ObjectId   = vbUnitId
             WHERE Movement.DescId   = zc_Movement_Send()
               AND Movement.OperDate = CURRENT_DATE
               AND Movement.StatusId = zc_Enum_Status_Erased()
               AND MovementBoolean_NotDisplaySUN.ValueData IS NULL
               AND MovementBoolean_SUN_v2.MovementId IS NULL
               AND MovementBoolean_SUN_v3.MovementId IS NULL
            )
      AND (DATE_PART('HOUR',    CURRENT_TIME)::Integer <= 12
        OR (DATE_PART('HOUR',    CURRENT_TIME)::Integer > 12
        AND DATE_PART('MINUTE',  CURRENT_TIME)::Integer >= 00
        AND DATE_PART('MINUTE',  CURRENT_TIME)::Integer <= 16
           ))
   THEN
      IF (SELECT COUNT(*)
          FROM  Movement
                INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                           ON MovementBoolean_SUN.MovementId = Movement.Id
                                          AND MovementBoolean_SUN.DescId     = zc_MovementBoolean_SUN()
                                          AND MovementBoolean_SUN.ValueData  = TRUE
                LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v2
                                          ON MovementBoolean_SUN_v2.MovementId = Movement.Id
                                         AND MovementBoolean_SUN_v2.DescId     = zc_MovementBoolean_SUN_v2()
                                         AND MovementBoolean_SUN_v2.ValueData  = TRUE
                LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v3
                                          ON MovementBoolean_SUN_v3.MovementId = Movement.Id
                                         AND MovementBoolean_SUN_v3.DescId     = zc_MovementBoolean_SUN_v2()
                                         AND MovementBoolean_SUN_v3.ValueData  = TRUE
                LEFT JOIN MovementBoolean AS MovementBoolean_NotDisplaySUN
                                          ON MovementBoolean_NotDisplaySUN.MovementId = Movement.Id
                                         AND MovementBoolean_NotDisplaySUN.DescId     = zc_MovementBoolean_NotDisplaySUN()
                                         AND MovementBoolean_NotDisplaySUN.ValueData  = TRUE
                INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                              ON MovementLinkObject_From.MovementId = Movement.Id
                                             AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                             AND MovementLinkObject_From.ObjectId   = vbUnitId
          WHERE Movement.DescId = zc_Movement_Send()
            AND Movement.OperDate = CURRENT_DATE
            AND Movement.StatusId = zc_Enum_Status_Erased()
            AND MovementBoolean_NotDisplaySUN.ValueData IS NULL
            AND MovementBoolean_SUN_v2.MovementId IS NULL
            AND MovementBoolean_SUN_v3.MovementId IS NULL
         ) >= 1
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
                                          AND MovementBoolean_SUN.DescId     = zc_MovementBoolean_SUN()
                                          AND MovementBoolean_SUN.ValueData  = TRUE
                LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v2
                                          ON MovementBoolean_SUN_v2.MovementId = Movement.Id
                                         AND MovementBoolean_SUN_v2.DescId     = zc_MovementBoolean_SUN_v2()
                                         AND MovementBoolean_SUN_v2.ValueData  = TRUE
                LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v3
                                          ON MovementBoolean_SUN_v3.MovementId = Movement.Id
                                         AND MovementBoolean_SUN_v3.DescId     = zc_MovementBoolean_SUN_v3()
                                         AND MovementBoolean_SUN_v3.ValueData  = TRUE
                LEFT JOIN MovementBoolean AS MovementBoolean_NotDisplaySUN
                                          ON MovementBoolean_NotDisplaySUN.MovementId = Movement.Id
                                         AND MovementBoolean_NotDisplaySUN.DescId     = zc_MovementBoolean_NotDisplaySUN()
                                         AND MovementBoolean_NotDisplaySUN.ValueData  = TRUE
                INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                            AND MovementLinkObject_From.ObjectId = vbUnitId
          WHERE Movement.DescId = zc_Movement_Send()
            AND Movement.OperDate = CURRENT_DATE
            AND Movement.StatusId = zc_Enum_Status_Erased()
            AND MovementBoolean_NotDisplaySUN.ValueData IS NULL
            AND MovementBoolean_SUN_v2.MovementId IS NULL
            AND MovementBoolean_SUN_v3.MovementId IS NULL
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
   IF COALESCE(vbPositionID, 0) = 1690028 AND
      EXISTS(SELECT 1
             FROM  Movement
                   INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                              ON MovementBoolean_SUN.MovementId = Movement.Id
                                             AND MovementBoolean_SUN.DescId     = zc_MovementBoolean_SUN()
                                             AND MovementBoolean_SUN.ValueData  = TRUE
                   LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v2
                                             ON MovementBoolean_SUN_v2.MovementId = Movement.Id
                                            AND MovementBoolean_SUN_v2.DescId     = zc_MovementBoolean_SUN_v2()
                                            AND MovementBoolean_SUN_v2.ValueData  = TRUE
                   LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v3
                                             ON MovementBoolean_SUN_v3.MovementId = Movement.Id
                                            AND MovementBoolean_SUN_v3.DescId     = zc_MovementBoolean_SUN_v3()
                                            AND MovementBoolean_SUN_v3.ValueData  = TRUE
                   INNER JOIN MovementBoolean AS MovementBoolean_Sent
                                              ON MovementBoolean_Sent.MovementId = Movement.Id
                                             AND MovementBoolean_Sent.DescId     = zc_MovementBoolean_Sent()
                                             AND MovementBoolean_Sent.ValueData  = TRUE
                   LEFT JOIN MovementBoolean AS MovementBoolean_Received
                                             ON MovementBoolean_Received.MovementId = Movement.Id
                                            AND MovementBoolean_Received.DescId     = zc_MovementBoolean_Received()
                                            AND MovementBoolean_Received.ValueData  = TRUE
                   INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                 ON MovementLinkObject_To.MovementId = Movement.Id
                                                AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                AND MovementLinkObject_To.ObjectId   = vbUnitId
                   INNER JOIN MovementDate AS MovementDate_Sent
                                           ON MovementDate_Sent.MovementId = Movement.Id
                                          AND MovementDate_Sent.DescId = zc_MovementDate_Sent()
                                          AND MovementDate_Sent.ValueData >= CURRENT_TIMESTAMP - INTERVAL '20 MIN'
             WHERE Movement.DescId = zc_Movement_Send()
               AND Movement.StatusId = zc_Enum_Status_UnComplete()
               AND MovementBoolean_Received.ValueData IS NULL
               AND MovementBoolean_SUN_v2.MovementId IS NULL
               AND MovementBoolean_SUN_v3.MovementId IS NULL
            )
   THEN
     INSERT INTO _PUSH (Id, Text) VALUES (7, 'Коллеги, ожидайте, на вас следует перемещение по СУН!');
   END IF;

     -- Коллеги, ожидайте, на вас следует перемещение по СУН!. в 16:00
   IF COALESCE(vbPositionID, 0) = 1690028 AND
      date_part('HOUR',    CURRENT_TIME)::Integer = 16
     AND date_part('MINUTE',  CURRENT_TIME)::Integer >= 00
     AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 20
   THEN
      IF EXISTS(SELECT 1
                FROM  Movement
                      INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                 ON MovementBoolean_SUN.MovementId = Movement.Id
                                                AND MovementBoolean_SUN.DescId     = zc_MovementBoolean_SUN()
                                                AND MovementBoolean_SUN.ValueData  = TRUE
                      LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v2
                                                ON MovementBoolean_SUN_v2.MovementId = Movement.Id
                                               AND MovementBoolean_SUN_v2.DescId     = zc_MovementBoolean_SUN_v2()
                                               AND MovementBoolean_SUN_v2.ValueData  = TRUE
                      LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v3
                                                ON MovementBoolean_SUN_v3.MovementId = Movement.Id
                                               AND MovementBoolean_SUN_v3.DescId     = zc_MovementBoolean_SUN_v2()
                                               AND MovementBoolean_SUN_v3.ValueData  = TRUE
                      INNER JOIN MovementBoolean AS MovementBoolean_Sent
                                                 ON MovementBoolean_Sent.MovementId = Movement.Id
                                                AND MovementBoolean_Sent.DescId     = zc_MovementBoolean_Sent()
                                                AND MovementBoolean_Sent.ValueData  = TRUE
                      LEFT JOIN MovementBoolean AS MovementBoolean_Received
                                                ON MovementBoolean_Received.MovementId = Movement.Id
                                               AND MovementBoolean_Received.DescId     = zc_MovementBoolean_Received()
                                               AND MovementBoolean_Received.ValueData  = TRUE
                      INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                    ON MovementLinkObject_To.MovementId = Movement.Id
                                                   AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                   AND MovementLinkObject_To.ObjectId   = vbUnitId
                WHERE Movement.DescId = zc_Movement_Send()
                  AND Movement.StatusId = zc_Enum_Status_UnComplete()
                  AND MovementBoolean_Received.ValueData IS NULL
                  AND MovementBoolean_SUN_v2.MovementId IS NULL
                  AND MovementBoolean_SUN_v3.MovementId IS NULL
               )
      THEN
        INSERT INTO _PUSH (Id, Text) VALUES (8, 'Коллеги, ожидайте, на вас следует перемещение по СУН!');
      END IF;
   END IF;

   IF inNumberPUSH = 1 AND vbUserId IN (3, 758920)
   THEN
      WITH tmpCheckAll AS (
              SELECT Movement.ID                                                             AS ID
                   , Movement.OperDate                                                       AS OperDate
                   , MovementLinkObject_Unit.ObjectId                                        AS UnitId
                   , MLO_Insert.ObjectId                                                     AS UserID
              FROM Movement

                   INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                   LEFT JOIN MovementLinkObject AS MLO_Insert
                                                ON MLO_Insert.MovementId = Movement.Id
                                               AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()

                   LEFT JOIN MovementDate AS MovementDate_Insert
                                          ON MovementDate_Insert.MovementId = Movement.Id
                                         AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

              WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '1 day'
                AND Movement.OperDate < CURRENT_DATE
                AND DATE_TRUNC ('DAY', MovementDate_Insert.ValueData) = CURRENT_DATE - INTERVAL '1 day'
                AND Movement.DescId = zc_Movement_Check()
                AND Movement.StatusId = zc_Enum_Status_Complete()),
           tmpCheckUser AS (
              SELECT Movement.UserID                            AS UserID
                   , count(*)                                   AS CountCheck
              FROM tmpCheckAll AS Movement
                   INNER JOIN ObjectLink AS ObjectLink_User_Member
                                         ON ObjectLink_User_Member.ObjectId = Movement.UserID
                                        AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                   INNER JOIN ObjectLink AS ObjectLink_Member_Position
                                         ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                                        AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
                                        AND ObjectLink_Member_Position.ChildObjectId = 1672498
              GROUP BY Movement.UserID
              HAVING count(*) < 20)


       SELECT string_agg(Object_User.ValueData, CHR(13))
       INTO vbText
       FROM tmpCheckUser
            LEFT JOIN Object AS Object_User ON Object_User.ID = tmpCheckUser.UserID;

       IF COALESCE (vbText, '') <> ''
       THEN
         INSERT INTO _PUSH (Id, Text) VALUES (9, 'Сотрудники по которым за вчера чеков менее 20:'||CHR(13)||CHR(13)||vbText);
       END IF;

       WITH tmpCashSettings AS (SELECT ObjectFloat_CashSettings_AttemptsSub.ValueData::Integer AS AttemptsSub
                               FROM Object AS Object_CashSettings
                                    LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_AttemptsSub
                                                          ON ObjectFloat_CashSettings_AttemptsSub.ObjectId = Object_CashSettings.Id
                                                         AND ObjectFloat_CashSettings_AttemptsSub.DescId = zc_ObjectFloat_CashSettings_AttemptsSub()
                               WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
                               LIMIT 1),
           tmpMovement AS (SELECT Movement.OperDate
                                 , Movement.Id
                            FROM Movement
                            WHERE Movement.DescId = zc_Movement_TestingUser()
                              AND Movement.OperDate = date_trunc('month', CURRENT_DATE)),
           tmpMI AS (SELECT        Movement.OperDate
                                 , MovementItem.ObjectId                                          AS UserID
                                 , MovementItem.Id
                            FROM tmpMovement AS Movement

                                 LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId = zc_MI_Master()),
           tmpMIF AS (SELECT * FROM MovementItemFloat
                      WHERE MovementItemFloat.MovementItemId in (SELECT tmpMI.Id FROM tmpMI)
                        AND MovementItemFloat.DescId = zc_MIFloat_TestingUser_Attempts()
                        AND MovementItemFloat.ValueData >= (SELECT tmpCashSettings.AttemptsSub FROM tmpCashSettings)),
           tmpSubstitution AS (SELECT MIMaster.ObjectId            AS UserID
                                    , COUNT(*)                     AS CountSubstitution
                              FROM Movement

                                   INNER JOIN MovementItem AS MIMaster
                                                           ON MIMaster.MovementId = Movement.id
                                                          AND MIMaster.DescId = zc_MI_Master()

                                   LEFT JOIN MovementItem AS MIChild
                                                          ON MIChild.MovementId = Movement.id
                                                         AND MIChild.ParentId = MIMaster.ID
                                                         AND MIChild.DescId = zc_MI_Child()

                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_PayrollType
                                                                    ON MILinkObject_PayrollType.MovementItemId = MIChild.Id
                                                                   AND MILinkObject_PayrollType.DescId = zc_MILinkObject_PayrollType()

                              WHERE Movement.ID = (SELECT Max(Movement.ID) FROM Movement
                                                   WHERE Movement.DescId = zc_Movement_EmployeeSchedule()
                                                     AND Movement.OperDate = date_trunc('month', CURRENT_DATE))
                                AND MILinkObject_PayrollType.ObjectId IN (zc_Enum_PayrollType_WorkSCS(), zc_Enum_PayrollType_WorkSAS())
                                GROUP BY MIMaster.ObjectId)


        SELECT string_agg(Object_User.ValueData||' - '||(tmpMIF.ValueData - COALESCE (tmpSubstitution.CountSubstitution * 5, 0))::Integer::TVarchar, Chr(13))
        INTO vbText
        FROM tmpMI AS MovementItem

             INNER JOIN tmpMIF ON tmpMIF.MovementItemId = MovementItem.Id
                              AND tmpMIF.DescId = zc_MIFloat_TestingUser_Attempts()

             LEFT JOIN tmpSubstitution ON tmpSubstitution.UserID = MovementItem.UserID

             INNER JOIN Object AS Object_User ON Object_User.ID = MovementItem.UserID
        WHERE (tmpMIF.ValueData - COALESCE (tmpSubstitution.CountSubstitution * 5, 0)) >=
              ((SELECT tmpCashSettings.AttemptsSub FROM tmpCashSettings) + 5);

       IF COALESCE (vbText, '') <> ''
       THEN
         INSERT INTO _PUSH (Id, Text) VALUES (10, 'Сотрудники по кот назначены штрафные балы:'||CHR(13)||CHR(13)||vbText);
       END IF;

   END IF;


   SELECT string_agg(Movement.InvNumber||' от '||TO_CHAR(Movement.OperDate, 'DD.MM.YYYY'), CHR(13))
   INTO vbText
   FROM Movement
        INNER JOIN MovementBoolean AS MovementBoolean_VIP
                                   ON MovementBoolean_VIP.MovementId = Movement.Id
                                  AND MovementBoolean_VIP.DescId = zc_MovementBoolean_VIP()

        INNER JOIN MovementBoolean AS MovementBoolean_Confirmed
                                   ON MovementBoolean_Confirmed.MovementId = Movement.Id
                                  AND MovementBoolean_Confirmed.DescId = zc_MovementBoolean_Confirmed()

        INNER JOIN MovementDate  AS MovementDate_UserConfirmedKind
                                 ON MovementDate_UserConfirmedKind.MovementId = Movement.Id
                                AND MovementDate_UserConfirmedKind.DescId = zc_MovementDate_UserConfirmedKind()

        INNER JOIN MovementLinkObject AS MovementLinkObject_Insert
                                      ON MovementLinkObject_Insert.MovementId = Movement.Id
                                     AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()

   WHERE Movement.DescId = zc_Movement_Send()
     AND Movement.StatusId = zc_Enum_Status_UnComplete()
     AND (MovementDate_UserConfirmedKind.ValueData >= vbDatePUSH OR vbDatePUSH IS NULL)
     AND COALESCE (MovementBoolean_VIP.ValueData, FALSE) = TRUE
     AND COALESCE (MovementBoolean_Confirmed.ValueData, FALSE) = TRUE
     AND MovementLinkObject_Insert.ObjectId = vbUserId;

   IF COALESCE (vbText, '') <> ''
   THEN
     INSERT INTO _PUSH (Id, Text) VALUES (11, 'Перемещения VIP по которым установлен признак подтвержден:'||CHR(13)||CHR(13)||vbText);
   END IF;

   SELECT string_agg(Movement.InvNumber||' от '||TO_CHAR(Movement.OperDate, 'DD.MM.YYYY'), CHR(13))
   INTO vbText
   FROM Movement
        INNER JOIN MovementBoolean AS MovementBoolean_VIP
                                   ON MovementBoolean_VIP.MovementId = Movement.Id
                                  AND MovementBoolean_VIP.DescId = zc_MovementBoolean_VIP()

        INNER JOIN MovementBoolean AS MovementBoolean_Confirmed
                                   ON MovementBoolean_Confirmed.MovementId = Movement.Id
                                  AND MovementBoolean_Confirmed.DescId = zc_MovementBoolean_Confirmed()

        INNER JOIN MovementDate  AS MovementDate_UserConfirmedKind
                                 ON MovementDate_UserConfirmedKind.MovementId = Movement.Id
                                AND MovementDate_UserConfirmedKind.DescId = zc_MovementDate_UserConfirmedKind()

        INNER JOIN MovementLinkObject AS MovementLinkObject_Insert
                                      ON MovementLinkObject_Insert.MovementId = Movement.Id
                                     AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()

   WHERE Movement.DescId = zc_Movement_Send()
     AND Movement.StatusId = zc_Enum_Status_UnComplete()
     AND (MovementDate_UserConfirmedKind.ValueData >= vbDatePUSH OR vbDatePUSH IS NULL)
     AND COALESCE (MovementBoolean_VIP.ValueData, FALSE) = TRUE
     AND COALESCE (MovementBoolean_Confirmed.ValueData, FALSE) = FALSE
     AND MovementLinkObject_Insert.ObjectId = vbUserId;

   IF COALESCE (vbText, '') <> ''
   THEN
     INSERT INTO _PUSH (Id, Text) VALUES (12, 'Перемещения VIP по которым установлен признак не подтвержден:'||CHR(13)||CHR(13)||vbText);
   END IF;

   IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_PartialSale(), zc_Enum_Role_PharmacyManager()))
      AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_SendVIP(), 12084491))
      AND date_part('DOW', CURRENT_DATE)::Integer in (1, 4) AND (inNumberPUSH = 1 OR
      (DATE_PART('HOUR', CURRENT_TIME)::Integer IN (12, 16) AND DATE_PART('MINUTE',  CURRENT_TIME)::Integer >= 00 AND DATE_PART('MINUTE',  CURRENT_TIME)::Integer <= 20))
   THEN

     SELECT string_agg('Юр. лицо: '||T1.JuridicalName||CHR(13)||'Поставщик: '||T1.FromName||CHR(13)||'Сумма: '||zfConvert_FloatToString(T1.Summa), CHR(13)||CHR(13))
     INTO vbText
     FROM gpSelect_Calculation_PartialSale (CURRENT_DATE, inSession) AS T1;

     IF COALESCE (vbText, '') <> ''
     THEN
       INSERT INTO _PUSH (Id, Text, FormName, Button, Params, TypeParams, ValueParams)
       VALUES (13, 'По состоянию на '||zfConvert_DateToString (CURRENT_DATE)||' возможна оплата частями:'||CHR(13)||CHR(13)||vbText,
                   'TCalculationPartialSaleForm', 'Формирование измения долга', 'OperDate', 'ftDateTime',
                   CURRENT_DATE::TVarChar);
     END IF;
   END IF;

   IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), zc_Enum_Role_PharmacyManager()))
      AND (DATE_PART('HOUR', CURRENT_TIME)::Integer IN (17) AND DATE_PART('MINUTE',  CURRENT_TIME)::Integer >= 0 AND DATE_PART('MINUTE',  CURRENT_TIME)::Integer <= 20)
   THEN

     vbCount := gpSelect_PriceCheck_PUSH (inPercent := 20, inSession := inSession);

     IF COALESCE (vbCount, 0) > 0
     THEN
       INSERT INTO _PUSH (Id, Text, FormName, Button, Params, TypeParams, ValueParams)
       VALUES (14, 'ВНИМАНИЕ!!!  По Вашим точкам, есть позиции с ценами реализации, которые нужно выровнять под всю сеть.'||CHR(13)||CHR(13)||
                   'Отчет находится по пути: Служебные => Проверка цен между подразделениями',
                   'TReport_PriceCheckForm', 'Проверка цен между подразделениями', 'Percent,UserId,UserName', 'ftFloat,ftInteger,ftString',
                   '20,'||inSession::TVarChar||','||(SELECT Object.ValueData FROM Object WHERE Object.Id = vbUserId));
     END IF;
   END IF;

   IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_VIPManager())
   THEN
     vbText := '';
     
            WITH tmpMovement AS (SELECT Movement.*
                                , MovementString_InvNumberOrder.ValueData  AS InvNumberOrder
                                , CASE WHEN Movement.StatusId = zc_Enum_Status_Erased()
                                       THEN COALESCE(Object_CancelReason.ValueData, '') END::TVarChar  AS CancelReason
                                , MovementFloat_TotalSumm.ValueData        AS TotalSumm
                                , COALESCE(Object_BuyerForSite.ValueData,
                                           MovementString_Bayer.ValueData, '')           AS Bayer
                                , COALESCE (ObjectString_BuyerForSite_Phone.ValueData, 
                                            MovementString_BayerPhone.ValueData, '')     AS BayerPhone
                                , MovementLinkObject_Unit.ObjectId                       AS UnitId
                         FROM Movement
                                
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                           
                              INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                         ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                        AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                                        AND MovementBoolean_Deferred.ValueData = TRUE
                                                          
                              INNER JOIN MovementString AS MovementString_InvNumberOrder
                                                        ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                                       AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

                              INNER JOIN MovementLinkObject AS MovementLinkObject_CancelReason
                                                           ON MovementLinkObject_CancelReason.MovementId = Movement.Id
                                                          AND MovementLinkObject_CancelReason.DescId = zc_MovementLinkObject_CancelReason()
                              INNER JOIN Object AS Object_CancelReason 
                                                ON Object_CancelReason.Id = MovementLinkObject_CancelReason.ObjectId
                                               AND Object_CancelReason.ObjectCode = 2
                                
                                
                              LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                      ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                     AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                                       
                              LEFT JOIN MovementString AS MovementString_Bayer
                                                       ON MovementString_Bayer.MovementId = Movement.Id
                                                      AND MovementString_Bayer.DescId = zc_MovementString_Bayer()
                              LEFT JOIN MovementString AS MovementString_BayerPhone
                                                       ON MovementString_BayerPhone.MovementId = Movement.Id
                                                      AND MovementString_BayerPhone.DescId = zc_MovementString_BayerPhone()

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_BuyerForSite
                                                           ON MovementLinkObject_BuyerForSite.MovementId = Movement.Id
                                                          AND MovementLinkObject_BuyerForSite.DescId = zc_MovementLinkObject_BuyerForSite()
                              LEFT JOIN Object AS Object_BuyerForSite ON Object_BuyerForSite.Id = MovementLinkObject_BuyerForSite.ObjectId
                              LEFT JOIN ObjectString AS ObjectString_BuyerForSite_Phone
                                                     ON ObjectString_BuyerForSite_Phone.ObjectId = Object_BuyerForSite.Id 
                                                    AND ObjectString_BuyerForSite_Phone.DescId = zc_ObjectString_BuyerForSite_Phone()                                                       
                                                      
                               WHERE Movement.DescId = zc_Movement_Check()
                                 AND Movement.StatusId = zc_Enum_Status_Erased()
                                 AND Movement.OperDate >= CURRENT_DATE - INTERVAL '1 MONTH'
                                 AND Movement.OperDate >= '20.04.2021'
                           )
         , tmpMovementProtocol AS (SELECT MovementProtocol.MovementId
                                        , MovementProtocol.OperDate 
                                        , MovementProtocol.UserId
                                        , CASE WHEN SUBSTRING(MovementProtocol.ProtocolData, POSITION('Статус' IN MovementProtocol.ProtocolData) + 22, 1) = 'У'
                                               THEN TRUE ELSE FALSE END AS Status
                                        , ROW_NUMBER() OVER (Partition BY MovementProtocol.MovementId ORDER BY MovementProtocol.OperDate DESC) AS ord
                                   FROM (SELECT DISTINCT tmpMovement.Id AS ID FROM tmpMovement) Movement

                                        INNER JOIN MovementProtocol ON MovementProtocol.MovementId = Movement.ID
                                   WHERE CASE WHEN SUBSTRING(MovementProtocol.ProtocolData, POSITION('Статус' IN MovementProtocol.ProtocolData) + 22, 1) = 'У'
                                              THEN TRUE ELSE FALSE END = TRUE)
         , tmpMI_all AS (SELECT tmpMov.Id AS MovementId, tmpMov.UnitId, MovementItem.ObjectId AS GoodsId, SUM (MovementItem.Amount) AS Amount
                         FROM tmpMovement AS tmpMov
                              INNER JOIN MovementItem
                                      ON MovementItem.MovementId = tmpMov.Id
                                     AND MovementItem.DescId     = zc_MI_Master()
                                     AND MovementItem.isErased   = FALSE
                         GROUP BY tmpMov.Id, tmpMov.UnitId, MovementItem.ObjectId
                         )
         , tmpMI AS (SELECT tmpMI_all.UnitId, tmpMI_all.GoodsId, SUM (tmpMI_all.Amount) AS Amount
                     FROM tmpMI_all
                     GROUP BY tmpMI_all.UnitId, tmpMI_all.GoodsId
                    )
         , tmpRemains AS (SELECT tmpMI.GoodsId
                               , tmpMI.UnitId
                               , tmpMI.Amount           AS Amount_mi
                               , COALESCE (SUM (Container.Amount), 0) AS Amount_remains
                          FROM tmpMI
                               LEFT JOIN Container ON Container.DescId = zc_Container_Count()
                                                  AND Container.ObjectId = tmpMI.GoodsId
                                                  AND Container.WhereObjectId = tmpMI.UnitId
                                                  AND Container.Amount <> 0
                          GROUP BY tmpMI.GoodsId
                                 , tmpMI.UnitId
                                 , tmpMI.Amount
                          HAVING COALESCE (SUM (Container.Amount), 0) < tmpMI.Amount
                          )
         , tmpErr AS (SELECT DISTINCT tmpMov.Id AS MovementId
                      FROM tmpMovement AS tmpMov
                           INNER JOIN tmpMI_all ON tmpMI_all.MovementId = tmpMov.Id
                           INNER JOIN tmpRemains ON tmpRemains.GoodsId = tmpMI_all.GoodsId
                                                AND tmpRemains.UnitId  = tmpMI_all.UnitId
                     )
                                                  
     SELECT STRING_AGG('  № '||Movement.InvNumber||
                       ', удален '||TO_CHAR(tmpMovementProtocol.OperDate, 'DD.MM.YYYY HH24:MI:SS')||
                       ', причина '||COALESCE(Movement.CancelReason, '')||
                       ', сумма '||zfConvert_FloatToString(Movement.TotalSumm)||
                       ', покупатель '||COALESCE(Movement.Bayer, '')||
                       ', номер телефона '||COALESCE(Movement.BayerPhone, '')||
                       ', номер заказа '||COALESCE(Movement.InvNumberOrder, ''), Chr(13))
           
     INTO vbText
     FROM tmpMovement AS Movement
          INNER JOIN tmpMovementProtocol ON tmpMovementProtocol.MovementId = Movement.Id
                                       AND tmpMovementProtocol.ord = 1
          LEFT JOIN tmpErr ON tmpErr.MovementId = Movement.Id
     WHERE tmpMovementProtocol.OperDate >= vbDatePUSH
       AND COALESCE(tmpErr.MovementId, 0) = 0;  

     IF COALESCE (vbText, '') <> ''
     THEN
       INSERT INTO _PUSH (Id, Text, FormName, Button, Params, TypeParams, ValueParams)
       VALUES (15, 'Был удален ВИП чеки:'||Chr(13)||vbText, '', '', '', '', '');
     END IF;

     vbText := '';

            WITH tmpMovement AS (SELECT Movement.*
                                , MovementString_InvNumberOrder.ValueData  AS InvNumberOrder
                                , CASE WHEN Movement.StatusId = zc_Enum_Status_Erased()
                                       THEN COALESCE(Object_CancelReason.ValueData, '') END::TVarChar  AS CancelReason
                                , MovementFloat_TotalSumm.ValueData        AS TotalSumm
                                , COALESCE(Object_BuyerForSite.ValueData,
                                           MovementString_Bayer.ValueData, '')           AS Bayer
                                , COALESCE (ObjectString_BuyerForSite_Phone.ValueData, 
                                            MovementString_BayerPhone.ValueData, '')     AS BayerPhone
                                , MovementLinkObject_Unit.ObjectId                       AS UnitId
                         FROM Movement
                                
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                           
                              INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                         ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                        AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                                        AND MovementBoolean_Deferred.ValueData = TRUE
                                                          
                              INNER JOIN MovementString AS MovementString_InvNumberOrder
                                                        ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                                       AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                                           ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                                          AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_CancelReason
                                                           ON MovementLinkObject_CancelReason.MovementId = Movement.Id
                                                          AND MovementLinkObject_CancelReason.DescId = zc_MovementLinkObject_CancelReason()
                              LEFT JOIN Object AS Object_CancelReason 
                                               ON Object_CancelReason.Id = MovementLinkObject_CancelReason.ObjectId
                                
                              LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                      ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                     AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                                       
                              LEFT JOIN MovementString AS MovementString_Bayer
                                                       ON MovementString_Bayer.MovementId = Movement.Id
                                                      AND MovementString_Bayer.DescId = zc_MovementString_Bayer()
                              LEFT JOIN MovementString AS MovementString_BayerPhone
                                                       ON MovementString_BayerPhone.MovementId = Movement.Id
                                                      AND MovementString_BayerPhone.DescId = zc_MovementString_BayerPhone()

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_BuyerForSite
                                                           ON MovementLinkObject_BuyerForSite.MovementId = Movement.Id
                                                          AND MovementLinkObject_BuyerForSite.DescId = zc_MovementLinkObject_BuyerForSite()
                              LEFT JOIN Object AS Object_BuyerForSite ON Object_BuyerForSite.Id = MovementLinkObject_BuyerForSite.ObjectId
                              LEFT JOIN ObjectString AS ObjectString_BuyerForSite_Phone
                                                     ON ObjectString_BuyerForSite_Phone.ObjectId = Object_BuyerForSite.Id 
                                                    AND ObjectString_BuyerForSite_Phone.DescId = zc_ObjectString_BuyerForSite_Phone()                                                       
                                                      
                         WHERE Movement.DescId = zc_Movement_Check()
                           AND Movement.OperDate >= CURRENT_DATE - INTERVAL '1 MONTH'
                           AND Movement.OperDate >= '20.04.2021'
                           AND COALESCE (Object_CancelReason.ObjectCode, 0) <> 2
                           )
         , tmpMI AS (SELECT tmpMovement.*
                          , MovementItem.Id                 AS MovementItemId 
                          , MovementItem.ObjectId           AS GoodsId
                     FROM tmpMovement
                     
                          INNER JOIN MovementItem ON MovementItem.MovementId =  tmpMovement.Id
                                                 AND MovementItem.DescId = zc_MI_Master()
                                                 AND MovementItem.Amount = 0
                                                 
                    )
         , tmpMovementProtocol AS (SELECT MovementProtocol.MovementId
                                        , MovementProtocol.OperDate 
                                        , MovementProtocol.UserId
                                        , ROW_NUMBER() OVER (Partition BY MovementProtocol.MovementId ORDER BY MovementProtocol.Id) AS ord
                                   FROM MovementProtocol 
                                   WHERE MovementProtocol.MovementId in (SELECT DISTINCT tmpMI.Id AS ID FROM tmpMI)
                                     AND MovementProtocol.ProtocolData ILIKE '%"Статус заказа (Состояние VIP-чека)" FieldValue = "Подтвержден"%')
         , tmpMIProtocol AS (SELECT MovementItemProtocol.MovementItemId
                                  , MovementItemProtocol.OperDate
                                  , ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.Id) AS Ord
                             FROM MovementItemProtocol 
                             WHERE MovementItemProtocol.MovementItemId in (SELECT tmpMI.MovementItemId FROM tmpMI)
                                                               AND MovementItemProtocol.ProtocolData ILIKE '%"Значение" FieldValue = "0.0000"%'
                            )
         , tmpMIFloat AS (SELECT MovementItemFloat.*
                          FROM MovementItemFloat 
                          WHERE MovementItemFloat.MovementItemId in (SELECT tmpMI.MovementItemId FROM tmpMI)
                         )

     SELECT STRING_AGG('  № '||Movement.InvNumber||
                       ', покупатель '||COALESCE(Movement.Bayer, '')||
                       ', номер телефона '||COALESCE(Movement.BayerPhone, '')||
                       ', номер заказа '||COALESCE(Movement.InvNumberOrder, '')||
                       ', обнулено '||TO_CHAR(tmpMIProtocol.OperDate, 'DD.MM.YYYY HH24:MI:SS')||
                       ', товар '||Object_Goods.ValueData||
                       ', заказано '||zfConvert_FloatToString(MIFloat_AmountOrder.ValueData)
                       , Chr(13))
           
     INTO vbText
     FROM tmpMI AS Movement
          INNER JOIN tmpMIProtocol ON tmpMIProtocol.MovementItemId = Movement.MovementItemId
                                  AND tmpMIProtocol.ord = 1
          
          LEFT JOIN tmpMovementProtocol ON tmpMovementProtocol.MovementId = Movement.Id
                                       AND tmpMovementProtocol.ord = 1 
 
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = Movement.GoodsId

          LEFT JOIN tmpMIFloat AS MIFloat_AmountOrder
                               ON MIFloat_AmountOrder.MovementItemId = Movement.MovementItemId
                              AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()
                              
     WHERE (tmpMIProtocol.OperDate < tmpMovementProtocol.OperDate OR tmpMovementProtocol.OperDate IS NULL)
       AND tmpMIProtocol.OperDate >= vbDatePUSH
     ;  

     IF COALESCE (vbText, '') <> ''
     THEN
       INSERT INTO _PUSH (Id, Text, FormName, Button, Params, TypeParams, ValueParams, Beep)
       VALUES (16, 'Было обнулено в ВИП чеках:'||Chr(13)||vbText, '', '', '', '', '', 1);
     END IF;
     
     
      -- ПУШ по отметке
     IF EXISTS(SELECT Movement.Id FROM Movement
               WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE)
                 AND Movement.DescId = zc_Movement_EmployeeScheduleVIP())
     THEN
         
       IF NOT EXISTS(SELECT 1 FROM MovementItem
                        INNER JOIN MovementItem AS MIChild
                                                ON MIChild.MovementId = MovementItem.MovementID
                                               AND MIChild.DescId = zc_MI_Child()
                                               AND MIChild.ParentId = MovementItem.ID
                                               AND MIChild.Amount = date_part('DAY',  CURRENT_DATE)::Integer                     
                     WHERE MovementItem.MovementId = (SELECT Movement.Id FROM Movement
                                                      WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE)
                                                        AND Movement.DescId = zc_Movement_EmployeeScheduleVIP()
                                                      LIMIT 1)
                       AND MovementItem.DescId = zc_MI_Master()
                       AND MovementItem.ObjectId = vbUserId)
       THEN
         INSERT INTO _PUSH (Id, Text, FormName, Button, Params, TypeParams, ValueParams)
         VALUES (17, 'Установите время работы', 'TEmployeeScheduleUserVIPForm', 'Ввод времени прихода и ухода', ' ', ' ', ' ');
       END IF;
     END IF;
   END IF;

   IF date_part('DOW', CURRENT_DATE)::Integer in (1, 4)
   THEN
     IF inSession::Integer IN (3, 4183126, 374171, 3004360, 10885303, 10885233) AND inNumberPUSH IN (1, 8, 16, 24, 32)
     THEN
       vbText := '';

       SELECT string_agg(PartialSale.JuridicalName||'; '||PartialSale.FromName||': '||zfConvert_FloatToString(PartialSale.Summa), Chr(13) ORDER BY PartialSale.JuridicalName, PartialSale.FromName) 
       INTO vbText
       FROM gpSelect_Calculation_PartialSale(inOperDate := CURRENT_DATE,  inSession := inSession) AS PartialSale
       WHERE PartialSale.JuridicalId in (393052,723462,1311462,3457711,13310756)
         AND PartialSale.JuridicalId in (9526799) AND vbUserId = 4183126          -- Олег
          
          OR PartialSale.JuridicalId in (472115, 393054) AND vbUserId = 374171    -- Елисеева Лидия    
           
          OR PartialSale.JuridicalId in (393038, 6608394) AND vbUserId = 3004360  -- Ашихмина Татьяна

          OR PartialSale.JuridicalId in (2886776) AND vbUserId = 10885233         -- Василенко Валерия

          OR PartialSale.JuridicalId in (10106457) AND vbUserId = 10885303        -- Грабченко Татьяна

          OR PartialSale.JuridicalId in (13310756) 
         AND PartialSale.JuridicalId NOT IN (9526799) AND vbUserId = 10885303     -- Грабченко Татьяна
         ;
         
       IF COALESCE (vbText, '') <> ''
       THEN
         INSERT INTO _PUSH (Id, Text, FormName, Button, Params, TypeParams, ValueParams)
         VALUES (18, 'Возможна оплата частями:'||Chr(13)||vbText, '', '', '', '', '');
       END IF;
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
          , _PUSH.Beep                   AS Beep
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
-- SELECT * FROM gpGet_PUSH_Farmacy('12198759')
-- 
SELECT * FROM gpGet_PUSH_Farmacy(1, '390046')