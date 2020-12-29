-- Function: gpGet_PUSH_Farmacy(TVarChar)

--DROP FUNCTION IF EXISTS gpGet_PUSH_Farmacy(TVarChar);
DROP FUNCTION IF EXISTS gpGet_PUSH_Farmacy(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_PUSH_Farmacy(
    IN inNumberPUSH  Integer,       -- ���������� ����� ������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Text TBlob,
               FormName TVarChar, Button TVarChar, Params TVarChar, TypeParams TVarChar, ValueParams TVarChar)
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

    -- �������� ���� ������������ �� ����� ���������
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

   -- ��������� ����
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_User_PUSH(), vbUserId, CURRENT_TIMESTAMP);

   -- ����������� �� ��� �������� "������ ����������� ���"
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
          SELECT 6, '�������, ������� ���� ������������ ����������� �� ��� �� ���, ������������ � �������� � "������������"!'||
                    CASE WHEN date_part('DOW',     CURRENT_DATE)::Integer <= 5
                          AND date_part('HOUR',    CURRENT_TIME)::Integer < 12
                         THEN Chr(13)||Chr(13)||'������� ������� ����� ������� �� 12:00!' ELSE '' END,
                    'TSendForm', '����������� ���', 'Id,inOperDate', 'ftInteger,ftDateTime',
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
        VALUES (6, '�������, ������� ���� ������������ ����������� �� ��� �� ���, ������������ � �������� � "������������"!'||
                    CASE WHEN date_part('DOW',     CURRENT_DATE)::Integer <= 5
                          AND date_part('HOUR',    CURRENT_TIME)::Integer < 12
                         THEN Chr(13)||Chr(13)||'������� ������� ����� ������� �� 12:00!' ELSE '' END,
                   'TSendCashJournalSunForm', '������ ����������� ���', 'isSUNAll', 'ftBoolean', 'False');
      END IF;
   END IF;

     -- �������, ��������, �� ��� ������� ����������� �� ���!. ����� ����������
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
     INSERT INTO _PUSH (Id, Text) VALUES (7, '�������, ��������, �� ��� ������� ����������� �� ���!');
   END IF;

     -- �������, ��������, �� ��� ������� ����������� �� ���!. � 16:00
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
        INSERT INTO _PUSH (Id, Text) VALUES (8, '�������, ��������, �� ��� ������� ����������� �� ���!');
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
         INSERT INTO _PUSH (Id, Text) VALUES (9, '���������� �� ������� �� ����� ����� ����� 20:'||CHR(13)||CHR(13)||vbText);
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
         INSERT INTO _PUSH (Id, Text) VALUES (10, '���������� �� ��� ��������� �������� ����:'||CHR(13)||CHR(13)||vbText);
       END IF;

   END IF;


   SELECT string_agg(Movement.InvNumber||' �� '||TO_CHAR(Movement.OperDate, 'DD.MM.YYYY'), CHR(13))
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
     INSERT INTO _PUSH (Id, Text) VALUES (11, '����������� VIP �� ������� ���������� ������� �����������:'||CHR(13)||CHR(13)||vbText);
   END IF;

   SELECT string_agg(Movement.InvNumber||' �� '||TO_CHAR(Movement.OperDate, 'DD.MM.YYYY'), CHR(13))
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
     INSERT INTO _PUSH (Id, Text) VALUES (12, '����������� VIP �� ������� ���������� ������� �� �����������:'||CHR(13)||CHR(13)||vbText);
   END IF;

   IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_PartialSale(), zc_Enum_Role_PharmacyManager()))
      AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_SendVIP()))
      AND date_part('DOW', CURRENT_DATE)::Integer in (1, 4) AND (inNumberPUSH = 1 OR
      (DATE_PART('HOUR', CURRENT_TIME)::Integer IN (12, 16) AND DATE_PART('MINUTE',  CURRENT_TIME)::Integer >= 00 AND DATE_PART('MINUTE',  CURRENT_TIME)::Integer <= 20))
   THEN

     SELECT string_agg('��. ����: '||T1.JuridicalName||CHR(13)||'���������: '||T1.FromName||CHR(13)||'�����: '||zfConvert_FloatToString(T1.Summa), CHR(13)||CHR(13))
     INTO vbText
     FROM gpSelect_Calculation_PartialSale (CURRENT_DATE, inSession) AS T1;

     IF COALESCE (vbText, '') <> ''
     THEN
       INSERT INTO _PUSH (Id, Text, FormName, Button, Params, TypeParams, ValueParams)
       VALUES (13, '�� ��������� �� '||zfConvert_DateToString (CURRENT_DATE)||' �������� ������ �������:'||CHR(13)||CHR(13)||vbText,
                   'TCalculationPartialSaleForm', '������������ ������� �����', 'OperDate', 'ftDateTime',
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
       VALUES (14, '��������!!!  �� ����� ������, ���� ������� � ������ ����������, ������� ����� ��������� ��� ��� ����.'||CHR(13)||CHR(13)||
                   '����� ��������� �� ����: ��������� => �������� ��� ����� ���������������',
                   'TReport_PriceCheckForm', '�������� ��� ����� ���������������', 'Percent,UserId,UserName', 'ftFloat,ftInteger,ftString',
                   '20,'||inSession::TVarChar||','||(SELECT Object.ValueData FROM Object WHERE Object.Id = vbUserId));
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
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.12.19                                                       *

*/

-- ����
-- SELECT * FROM gpGet_PUSH_Farmacy('12198759')
--
SELECT * FROM gpGet_PUSH_Farmacy(1, '948223')