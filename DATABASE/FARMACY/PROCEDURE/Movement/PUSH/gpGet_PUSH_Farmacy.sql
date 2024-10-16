-- Function: gpGet_PUSH_Farmacy(TVarChar)

--DROP FUNCTION IF EXISTS gpGet_PUSH_Farmacy(TVarChar);
DROP FUNCTION IF EXISTS gpGet_PUSH_Farmacy(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_PUSH_Farmacy(
    IN inNumberPUSH  Integer,       -- ���������� ����� ������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Text TBlob,
               FormName TVarChar, Button TVarChar, Params TVarChar, TypeParams TVarChar, ValueParams TVarChar, Beep Integer,
               SpecialLighting Boolean, TextColor Integer, Color Integer, Bold Boolean, GridData TBlob)
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
   -- ��� ��� �� ��������� ������� 
   DECLARE vbDataUpdate TDateTime;
   DECLARE vbDateDone TDateTime;
   DECLARE vbisMCRequesInfo Boolean;
   DECLARE vbisMCRequesShow Boolean; 
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
                           , ValueParams TVarChar
                           , Beep Integer Not Null Default 0
                           , SpecialLighting Boolean Not Null Default False
                           , TextColor Integer
                           , Color Integer
                           , Bold Boolean Not Null Default False
                           , GridData TBlob) ON COMMIT DROP;

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

   -- ���������� ���� �� ������� �� ��������� �������
   vbisMCRequesInfo := False;
   vbisMCRequesShow := False;    
   IF EXISTS (SELECT 1
              FROM Object AS Object_MCReques

                   LEFT JOIN ObjectDate AS ObjectDate_DateUpdate
                                        ON ObjectDate_DateUpdate.ObjectId = Object_MCReques.Id
                                       AND ObjectDate_DateUpdate.DescId = zc_ObjectDate_MCRequest_DateUpdate()
                   LEFT JOIN ObjectDate AS ObjectDate_DateDone
                                        ON ObjectDate_DateDone.ObjectId = Object_MCReques.Id
                                       AND ObjectDate_DateDone.DescId = zc_ObjectDate_MCRequest_DateDone()

              WHERE Object_MCReques.DescId = zc_Object_MCRequest()
                AND Object_MCReques.ObjectCode = 1
                AND (ObjectDate_DateDone.ValueData IS NULL OR ObjectDate_DateDone.ValueData > vbDatePUSH AND ObjectDate_DateDone.ValueData > '23.05.2022'))
   THEN   
      SELECT ObjectDate_DateUpdate.ValueData          AS DataUpdate
           , ObjectDate_DateDone.ValueData            AS DateDone
      INTO vbDataUpdate, vbDateDone
      FROM Object AS Object_MCReques

           LEFT JOIN ObjectDate AS ObjectDate_DateUpdate
                                ON ObjectDate_DateUpdate.ObjectId = Object_MCReques.Id
                               AND ObjectDate_DateUpdate.DescId = zc_ObjectDate_MCRequest_DateUpdate()
           LEFT JOIN ObjectDate AS ObjectDate_DateDone
                                ON ObjectDate_DateDone.ObjectId = Object_MCReques.Id
                               AND ObjectDate_DateDone.DescId = zc_ObjectDate_MCRequest_DateDone()

      WHERE Object_MCReques.DescId = zc_Object_MCRequest()
        AND Object_MCReques.ObjectCode = 1;
        
      IF vbDateDone is NULL 
      THEN
        IF lpUpdate_Object_MCReques_DateDone(vbUserId) 
        THEN
          vbisMCRequesInfo := True;        
        ELSE
          vbisMCRequesShow := True;                
        END IF;
      ELSE
        vbisMCRequesInfo := True;
      END IF;   
   END IF;
   
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

     CREATE TEMP TABLE tmpCheckAll ON COMMIT DROP AS
             (SELECT Movement.ID                                                             AS ID
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
                AND Movement.StatusId = zc_Enum_Status_Complete());
                   
     ANALYSE tmpCheckAll;
   
      WITH tmpCheckUser AS (
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

/*   IF (EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_PartialSale(), zc_Enum_Role_PharmacyManager()))
      AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_SendVIP(), 12084491)) OR vbUserId = 183242)
      AND date_part('DOW', CURRENT_DATE)::Integer in (1, 4) AND (--inNumberPUSH = 1 OR
      (DATE_PART('HOUR', CURRENT_TIME)::Integer IN (10, 16) AND DATE_PART('MINUTE',  CURRENT_TIME)::Integer >= 00 AND DATE_PART('MINUTE',  CURRENT_TIME)::Integer <= 20))
   THEN

     SELECT string_agg(T1.JuridicalName||CHR(13)||T1.FromName||CHR(13)||T1.Summa::Text, CHR(13))
     INTO vbText
     FROM gpSelect_Calculation_PartialSale (CURRENT_DATE, inSession) AS T1;

     IF COALESCE (vbText, '') <> ''
     THEN
       INSERT INTO _PUSH (Id, Text, FormName, Button, Params, TypeParams, ValueParams, GridData)
       VALUES (13, '�� ��������� �� '||zfConvert_DateToString (CURRENT_DATE)||' �������� ������ �������:',
                   'TCalculationPartialSaleForm', '������������ ������� �����', 'OperDate', 'ftDateTime',
                   CURRENT_DATE::TVarChar, 'ftString,ftString,ftFloat'||CHR(13)||
                   '��. ����'||CHR(13)||'���������'||CHR(13)||'�����'||
                   CHR(13)||vbText);
     END IF;
   END IF;*/

   IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), zc_Enum_Role_PharmacyManager()))
      AND DATE_PART('DOW', CURRENT_DATE)::Integer in (2, 5)
      AND (DATE_PART('HOUR', CURRENT_TIME)::Integer IN (14) AND DATE_PART('MINUTE',  CURRENT_TIME)::Integer >= 0 AND DATE_PART('MINUTE',  CURRENT_TIME)::Integer <= 20)
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
                                               AND Object_CancelReason.ObjectCode IN (2, 3)
                                                                
                              LEFT JOIN MovementBoolean AS MovementBoolean_MobileApplication
                                                        ON MovementBoolean_MobileApplication.MovementId = Movement.Id
                                                       AND MovementBoolean_MobileApplication.DescId = zc_MovementBoolean_MobileApplication()

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
                                 AND COALESCE (MovementBoolean_MobileApplication.ValueData, False) = False
                           )
         , tmpMovementProtocol AS (SELECT MovementProtocol.MovementId
                                        , MovementProtocol.OperDate 
                                        , MovementProtocol.UserId
                                        , CASE WHEN SUBSTRING(MovementProtocol.ProtocolData, POSITION('������' IN MovementProtocol.ProtocolData) + 22, 1) = '�'
                                               THEN TRUE ELSE FALSE END AS Status
                                        , ROW_NUMBER() OVER (Partition BY MovementProtocol.MovementId ORDER BY MovementProtocol.OperDate DESC) AS ord
                                   FROM (SELECT DISTINCT tmpMovement.Id AS ID FROM tmpMovement) Movement

                                        INNER JOIN MovementProtocol ON MovementProtocol.MovementId = Movement.ID
                                   WHERE CASE WHEN SUBSTRING(MovementProtocol.ProtocolData, POSITION('������' IN MovementProtocol.ProtocolData) + 22, 1) = '�'
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
                                                  
     SELECT STRING_AGG('  � '||Movement.InvNumber||
                       ', ������ '||TO_CHAR(tmpMovementProtocol.OperDate, 'DD.MM.YYYY HH24:MI:SS')||
                       ', ������� '||COALESCE(Movement.CancelReason, '')||
                       ', ����� '||zfConvert_FloatToString(Movement.TotalSumm)||
                       ', ���������� '||COALESCE(Movement.Bayer, '')||
                       ', ����� �������� '||COALESCE(Movement.BayerPhone, '')||
                       ', ����� ������ '||COALESCE(Movement.InvNumberOrder, ''), Chr(13))
           
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
       VALUES (15, '��� ������ ��� ����:'||Chr(13)||vbText, '', '', '', '', '');
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

                                                                
                              LEFT JOIN MovementBoolean AS MovementBoolean_MobileApplication
                                                        ON MovementBoolean_MobileApplication.MovementId = Movement.Id
                                                       AND MovementBoolean_MobileApplication.DescId = zc_MovementBoolean_MobileApplication()

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_BuyerForSite
                                                           ON MovementLinkObject_BuyerForSite.MovementId = Movement.Id
                                                          AND MovementLinkObject_BuyerForSite.DescId = zc_MovementLinkObject_BuyerForSite()
                              LEFT JOIN Object AS Object_BuyerForSite ON Object_BuyerForSite.Id = MovementLinkObject_BuyerForSite.ObjectId
                              LEFT JOIN ObjectString AS ObjectString_BuyerForSite_Phone
                                                     ON ObjectString_BuyerForSite_Phone.ObjectId = Object_BuyerForSite.Id 
                                                    AND ObjectString_BuyerForSite_Phone.DescId = zc_ObjectString_BuyerForSite_Phone()                                                       
                                                      
                         WHERE Movement.DescId = zc_Movement_Check()
                           AND Movement.OperDate >= CURRENT_DATE - INTERVAL '20 DAY'
                           AND COALESCE (Object_CancelReason.ObjectCode, 0) <> 2
                           AND COALESCE (MovementBoolean_MobileApplication.ValueData, False) = False
                           )
         , tmpMIAll AS (SELECT tmpMovement.*
                          , MovementItem.Id                 AS MovementItemId 
                          , MovementItem.ObjectId           AS GoodsId
                          , MovementItem.Amount
                     FROM tmpMovement
                     
                          INNER JOIN MovementItem ON MovementItem.MovementId =  tmpMovement.Id
                                                 AND MovementItem.DescId = zc_MI_Master()
                                                 
                    )
         , tmpMIFloat AS (SELECT MovementItemFloat.*
                          FROM MovementItemFloat 
                          WHERE MovementItemFloat.MovementItemId in (SELECT tmpMIAll.MovementItemId FROM tmpMIAll)
                         )
         , tmpMI AS (SELECT tmpMovement.*
                          , MIFloat_AmountOrder.ValueData   AS AmountOrder
                     FROM tmpMIAll AS tmpMovement
                     
                          LEFT JOIN tmpMIFloat AS MIFloat_AmountOrder
                                               ON MIFloat_AmountOrder.MovementItemId = tmpMovement.MovementItemId
                                              AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()
                                              
                     WHERE tmpMovement.Amount < MIFloat_AmountOrder.ValueData
                    )
         , tmpMovementProtocol AS (SELECT MovementProtocol.MovementId
                                        , MovementProtocol.OperDate 
                                        , MovementProtocol.UserId
                                        , ROW_NUMBER() OVER (Partition BY MovementProtocol.MovementId ORDER BY MovementProtocol.Id) AS ord
                                   FROM MovementProtocol 
                                   WHERE MovementProtocol.MovementId in (SELECT DISTINCT tmpMI.Id AS ID FROM tmpMI)
                                     AND MovementProtocol.ProtocolData ILIKE '%"������ ������ (��������� VIP-����)" FieldValue = "�����������"%')
         , tmpMIProtocolAll AS (SELECT MovementItemProtocol.*
                                FROM MovementItemProtocol 
                                WHERE MovementItemProtocol.MovementItemId in (SELECT tmpMI.MovementItemId FROM tmpMI) 
                                 )
         , tmpMIProtocol AS (SELECT MovementItemProtocol.MovementItemId
                                  , MovementItemProtocol.OperDate
                                  , ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.Id) AS Ord
                             FROM tmpMI
                             
                                  INNER JOIN tmpMIProtocolAll AS MovementItemProtocol 
                                                              ON  MovementItemProtocol.MovementItemId = tmpMI.MovementItemId
                                                             AND MovementItemProtocol.ProtocolData NOT ILIKE '%"��������" FieldValue = "' ||tmpMI.AmountOrder || '"%' 
                              )

     SELECT STRING_AGG('  � '||Movement.InvNumber||
                       ', ���������� '||COALESCE(Movement.Bayer, '')||
                       ', ����� �������� '||COALESCE(Movement.BayerPhone, '')||
                       ', ����� ������ '||COALESCE(Movement.InvNumberOrder, '')||
                       ', �������� '||TO_CHAR(tmpMIProtocol.OperDate, 'DD.MM.YYYY HH24:MI:SS')||
                       ', ����� '||Object_Goods.ValueData||
                       ', �������� '||zfConvert_FloatToString(Movement.AmountOrder)||
                       ', � ���� '||zfConvert_FloatToString(Movement.Amount)
                       , Chr(13))
           
     INTO vbText
     FROM tmpMI AS Movement
          INNER JOIN tmpMIProtocol ON tmpMIProtocol.MovementItemId = Movement.MovementItemId
                                  AND tmpMIProtocol.ord = 1
          
          LEFT JOIN tmpMovementProtocol ON tmpMovementProtocol.MovementId = Movement.Id
                                       AND tmpMovementProtocol.ord = 1 
 
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = Movement.GoodsId
                              
     WHERE (tmpMIProtocol.OperDate < tmpMovementProtocol.OperDate OR tmpMovementProtocol.OperDate IS NULL)
       AND tmpMIProtocol.OperDate >= vbDatePUSH
     ;  

     IF COALESCE (vbText, '') <> ''
     THEN
       INSERT INTO _PUSH (Id, Text, FormName, Button, Params, TypeParams, ValueParams, Beep)
       VALUES (16, '���� ���������� ������ � ��� �����:'||Chr(13)||vbText, '', '', '', '', '', 1);
     END IF;
     
     
      -- ��� �� �������
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
         VALUES (17, '���������� ����� ������', 'TEmployeeScheduleUserVIPForm', '���� ������� ������� � �����', ' ', ' ', ' ');
       END IF;
     END IF;
     
     -- T���� �� ������, ���� �� ������ �����
     vbText := '';
            WITH tmpMovement AS (SELECT Movement.*
                                , MovementString_InvNumberOrder.ValueData  AS InvNumberOrder
                                , MovementFloat_TotalSumm.ValueData        AS TotalSumm
                                , COALESCE(Object_BuyerForSite.ValueData,
                                           MovementString_Bayer.ValueData, '')           AS Bayer
                                , COALESCE (ObjectString_BuyerForSite_Phone.ValueData, 
                                            MovementString_BayerPhone.ValueData, '')     AS BayerPhone
                                , MovementLinkObject_Unit.ObjectId                       AS UnitId
                                , MovementDate_Coming.ValueData                          AS DateComing 
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
                                
                              INNER JOIN MovementDate AS MovementDate_Coming
                                                      ON MovementDate_Coming.MovementId = Movement.Id
                                                     AND MovementDate_Coming.DescId = zc_MovementDate_Coming()                                

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                                           ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                                          AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()

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
                                 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                 AND Movement.OperDate >= CURRENT_DATE - INTERVAL '20 DAY'
                                 AND MovementDate_Coming.ValueData < CURRENT_DATE - INTERVAL '1 DAY'
                                 AND MovementDate_Coming.ValueData > vbDatePUSH
                                 AND COALESCE (MovementLinkObject_ConfirmedKind.ObjectId, zc_Enum_ConfirmedKind_UnComplete()) = zc_Enum_ConfirmedKind_UnComplete()
                           )
                                                  
     SELECT STRING_AGG('  � '||Movement.InvNumber||
                       ', ���� ������� �� ������ '||TO_CHAR(Movement.DateComing, 'DD.MM.YYYY')||
                       ', ����� '||zfConvert_FloatToString(Movement.TotalSumm)||
                       ', ���������� '||COALESCE(Movement.Bayer, '')||
                       ', ����� �������� '||COALESCE(Movement.BayerPhone, '')||
                       ', ����� ������ '||COALESCE(Movement.InvNumberOrder, ''), Chr(13))
           
     INTO vbText
     FROM tmpMovement AS Movement;       

     IF COALESCE (vbText, '') <> ''
     THEN
       INSERT INTO _PUSH (Id, Text, FormName, Button, Params, TypeParams, ValueParams, Beep)
       VALUES (18, 'T���� �� ������ �� ������:'||Chr(13)||vbText, '', '', '', '', '', 1);
     END IF;
     
   END IF;

   IF date_part('DOW', CURRENT_DATE)::Integer in (1, 4)  
      AND DATE_PART('HOUR', CURRENT_TIME)::Integer >= 9
      AND vbDatePUSH < CURRENT_DATE + INTERVAL '9 HOUR'
   THEN
     IF inSession::Integer IN (4183126, 269777) -- AND inNumberPUSH IN (1, 8, 16, 24, 32)
     THEN
       vbText := '';

       SELECT string_agg(PartialSale.JuridicalName||'; '||PartialSale.FromName||': '||zfConvert_FloatToString(PartialSale.Summa), Chr(13) ORDER BY PartialSale.JuridicalName, PartialSale.FromName) 
       INTO vbText
       FROM gpSelect_Calculation_PartialSale(inOperDate := CURRENT_DATE,  inSession := inSession) AS PartialSale
       WHERE PartialSale.JuridicalId in (393052,723462,1311462,3457711,13310756)
         AND PartialSale.JuridicalId in (9526799) AND vbUserId = 4183126          -- ����
          
          OR PartialSale.JuridicalId in (472115, 393054) AND vbUserId = 374171    -- �������� �����    
           
          OR PartialSale.JuridicalId in (393038, 6608394) AND vbUserId = 3004360  -- �������� �������

          OR PartialSale.JuridicalId in (2886776) AND vbUserId = 10885233         -- ��������� �������

          OR PartialSale.JuridicalId in (10106457) AND vbUserId = 10885303        -- ��������� �������

          OR PartialSale.JuridicalId in (13310756) AND vbUserId = 269777          -- ������� �����
         ;
         
       IF COALESCE (vbText, '') <> ''
       THEN
         INSERT INTO _PUSH (Id, Text, FormName, Button, Params, TypeParams, ValueParams)
         VALUES (19, '�������� ������ �������:'||Chr(13)||vbText, '', '', '', '', '');
       END IF;
     END IF;
   END IF;
   
   
   -- �������� ����� �����
   IF vbUserId IN (3, 9383066)
   THEN

      WITH tmpMovement AS (SELECT Movement.*
                                , Object_Unit.ValueData  AS UnitName
                           FROM Movement

                                INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                             ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                            AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                INNER JOIN Object AS Object_Unit ON Object_Unit.ID = MovementLinkObject_Unit.ObjectId

                                LEFT JOIN MovementLinkObject AS MovementLinkObject_JackdawsChecks
                                                             ON MovementLinkObject_JackdawsChecks.MovementId =  Movement.Id
                                                            AND MovementLinkObject_JackdawsChecks.DescId = zc_MovementLinkObject_JackdawsChecks()
                                LEFT JOIN Object AS Object_JackdawsChecks ON Object_JackdawsChecks.Id = MovementLinkObject_JackdawsChecks.ObjectId
 
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                                             ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                                            AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
                                                                       
                           WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '3 DAY'
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                             AND Movement.DescId = zc_Movement_Check()
                             AND COALESCE(Object_JackdawsChecks.ObjectCode, 0) <> 10413041
                             AND (COALESCE(Object_JackdawsChecks.ObjectCode, 0) <> 0
                              OR COALESCE(MovementLinkObject_CashRegister.ObjectId, 0) = 0))                
         , tmpMovementProtocol AS (SELECT MovementProtocol.MovementId
                                        , MovementProtocol.OperDate
                                   FROM MovementProtocol 
                                   WHERE MovementProtocol.MovementId IN (SELECT Movement.ID FROM tmpMovement AS Movement)
                                     AND COALESCE(MovementProtocol.UserId, 0) <> 0)
         , tmpProtocol AS (SELECT MovementProtocol.MovementId
                                , MAX(MovementProtocol.OperDate) AS OperDate 
                           FROM tmpMovementProtocol AS MovementProtocol
                           GROUP BY  MovementProtocol.MovementId)
                                                                              
     SELECT string_agg(Movement.InvNumber||' �� '||TO_CHAR(Movement.OperDate, 'DD.MM.YYYY')||' ������ '||Movement.UnitName, CHR(13))
     INTO vbText
     FROM tmpProtocol    
          INNER JOIN tmpMovement AS Movement ON Movement.ID = tmpProtocol.MovementId
     WHERE tmpProtocol.OperDate >= vbDatePUSH;
               
               
     IF COALESCE (vbText, '') <> ''
     THEN         
       INSERT INTO _PUSH (Id, Text, FormName, Button, Params, TypeParams, ValueParams)
       VALUES (20, '��������� ����� �����-���:'||CHR(13)||CHR(13)||vbText, 
                   'TReport_Check_JackdawsSumForm', '����� ���� �� ������', 
                   'StartDate,EndDate,UnitId,UnitName', 
                   'ftDateTime,ftDateTime,ftInteger,ftString', TO_CHAR(CURRENT_DATE - INTERVAL '3 DAY', 'YYYY-MM-DD')||','||TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD')||',0,');
     END IF;
   END IF;
   
   -- ��� ���� "������ ������"
   IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
            WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = zc_Enum_Role_CashierPharmacy())
   THEN

     vbText := gpGet_Movement_ReturnOut_PUSH_NewDoc (inStartDate := vbDatePUSH, inSession:= inSession);
        
     IF COALESCE (vbText, '') <> ''
     THEN         
       INSERT INTO _PUSH (Id, Text, FormName, Button, Params, TypeParams, ValueParams, SpecialLighting, TextColor, Color, Bold)
       VALUES (21, '��������!!!'||CHR(13)|| 
                   '�� ����� ������ ������ ����� �������:'||CHR(13)||vbText||CHR(13)||CHR(13)||
                   '������������ ���������.'||CHR(13)||
                   '����������� ����� � ���������.'||CHR(13)||
                   '��������� ������� "�������" � ���������� ���������.', 
                   'TReturnOutPharmacyJournalForm', '������� ����������', 
                   '', '', '', TRUE, zc_Color_Red(), zc_Color_White(), TRUE);
     END IF;

     IF vbDatePUSH::Time < '10:00:00'::Time AND CURRENT_TIMESTAMP::Time >= '10:00:00'::Time
     THEN
       vbText := gpGet_Movement_ReturnOut_PUSH_NotGiven (inSession:= inSession);
        
       IF COALESCE (vbText, '') <> ''
       THEN         
         INSERT INTO _PUSH (Id, Text, FormName, Button, Params, TypeParams, ValueParams, SpecialLighting, TextColor, Color, Bold)
         VALUES (21, '��������!!!'||CHR(13)|| 
                     '� ��� ���� �������� ���������� , ������� ��� �� ������:'||CHR(13)||vbText||CHR(13)||CHR(13)||
                     '��������� �� ������� � ������ !!!'||CHR(13)||CHR(13)||
                     '���� ����� ����� ���������� - ��������� ������� "���� �������� ������" �   ������� "������� ����������"', 
                     'TReturnOutPharmacyJournalForm', '������� ����������', 
                     '', '', '', TRUE, zc_Color_Red(), zc_Color_White(), TRUE);
       END IF;

       vbText := gpGet_Movement_Pretension_PUSH_Actual (inSession:= inSession);
        
       IF COALESCE (vbText, '') <> ''
       THEN         
         INSERT INTO _PUSH (Id, Text, FormName, Button, Params, TypeParams, ValueParams)
         VALUES (22, '�� ����� ������ ���� ��������� � ������� ��������� !!!'||CHR(13)|| 
                     '��������� � ������ ��������� �� ������ ����:'||CHR(13)||CHR(13)|| 
                     '1. ������� ������ ��������� ��� ����������� (����� �������������� � ��������� ��� �� ������ ����������) - �������� ������ � ��������������� ������.'||CHR(13)||CHR(13)|| 
                     '2. ��������� ������ ��������� (��������� ���� ����� ��� ������ �������, �������, ������������� ������ ������� ��� ����� ������� ����� ������ ��������� ����������) - ��������� ���� ������� ���������.', 
                     'TPretensionJournalForm', '��������� ����������', 
                     '', '', '');
       END IF;
     END IF;

   END IF;
   
   IF inNumberPUSH in (1, 10) AND vbUserId IN (3, 4183126) AND date_part('isodow', CURRENT_DATE)::Integer in (1)
   THEN
      SELECT string_agg(T1.Code||' - '||T1.Name, CHR(13)) FROM gpSelect_Object_HelsiUser (True, '3') AS T1
      INTO vbText
      WHERE T1.KeyExpireDate >= date_trunc('month', CURRENT_DATE)
        AND T1.KeyExpireDate <= date_trunc('month', CURRENT_DATE) + INTERVAL '1 MONTH'
        AND T1.isErased = FALSE
        AND T1.UnitId in (SELECT T2.ID FROM gpSelect_Object_Unit_Active (inNotUnitId := 0, inSession := inSession) AS T2);   

       IF COALESCE (vbText, '') <> ''
       THEN         
         INSERT INTO _PUSH (Id, Text)
         VALUES (23, '� ����������� �������� � ����� ���� �������� �����:'||CHR(13)||CHR(13)||vbText);
       END IF;
   END IF;

   IF vbisMCRequesShow AND (inNumberPUSH = 1 OR vbDataUpdate > vbDatePUSH OR inNumberPUSH % 8 = 0) AND vbUserId IN (3, 4183126, 183242)
   THEN
       INSERT INTO _PUSH (Id, Text, FormName)
       VALUES (24, '', 'TMCRequestShowPUSHForm');
   END IF;

   IF vbisMCRequesInfo AND (vbUserId IN (3, 4183126 ) OR
      EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (12084491, 393039, zc_Enum_Role_PharmacyManager())))
   THEN
       INSERT INTO _PUSH (Id, Text, FormName)
       VALUES (25, '', 'TMCRequestInfoPUSHForm');
   END IF;
   
   IF inNumberPUSH = 1 AND COALESCE (vbPositionID, 0) = 1690028 AND COALESCE (vbUnitId, 0) <> 0 or vbUserId IN (3)
   THEN
       SELECT string_agg(T1.InvNumber, CHR(13))
       INTO vbText
       FROM (SELECT string_agg(T1.InvNumber, ' - ') AS InvNumber
             FROM gpReport_IncomeDubly (CURRENT_DATE - INTERVAL '4 DAY', CURRENT_DATE, vbUnitId, FALSE, '3') AS T1
             GROUP BY T1.Ord) AS T1;   

       IF COALESCE (vbText, '') <> ''
       THEN         
         INSERT INTO _PUSH (Id, Text)
         VALUES (26, '�� ��� ���������� ������� ��������� ��������� ���������:'||CHR(13)||CHR(13)||vbText||CHR(13)||CHR(13)||         
                     '������� ��������� ������� ������ �� ���, � ������ �������� - ���������� � ������ ���������!');
       END IF;   
   END IF;
    
   IF inNumberPUSH = 1 AND vbUserId IN (3, 375661, 11263040)
   THEN
       SELECT string_agg(T1.GoodsCode::TEXT||' - '||T1.GoodsName, CHR(13)) AS InvNumber
       INTO vbText
       FROM gpReport_Inventory_ProficitReturnOut (CURRENT_DATE - INTERVAL '4 DAY', CURRENT_DATE, inSession) AS T1
       WHERE T1.OperDateStatus = CURRENT_DATE - INTERVAL '1 DAY';   

       IF COALESCE (vbText, '') <> ''
       THEN         
         INSERT INTO _PUSH (Id, Text)
         VALUES (26, '������ �� ������ �������������� �������������� � ��������� ����������:'||CHR(13)||CHR(13)||vbText);
       END IF;   
   END IF;

   IF vbUserId IN (3, 8037524)
   THEN
       SELECT COALESCE(Object_Member.ValueData, Object_User.ValueData)
       INTO vbText
       FROM Object AS Object_User
       
            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_InternshipCompleted
                                    ON ObjectBoolean_InternshipCompleted.ObjectId = Object_User.Id
                                   AND ObjectBoolean_InternshipCompleted.DescId = zc_ObjectBoolean_User_InternshipCompleted()
            LEFT JOIN ObjectFloat AS ObjectFloat_InternshipConfirmation
                                  ON ObjectFloat_InternshipConfirmation.ObjectId = Object_User.Id
                                 AND ObjectFloat_InternshipConfirmation.DescId = zc_ObjectFloat_User_InternshipConfirmation()
            LEFT JOIN ObjectDate AS ObjectDate_User_InternshipConfirmation
                                 ON ObjectDate_User_InternshipConfirmation.ObjectId = Object_User.Id
                                AND ObjectDate_User_InternshipConfirmation.DescId = zc_ObjectDate_User_InternshipConfirmation()
       
       WHERE COALESCE (ObjectBoolean_InternshipCompleted.ValueData, FALSE) = TRUE
         AND COALESCE (ObjectFloat_InternshipConfirmation.ValueData, 0) = 1
         AND ObjectDate_User_InternshipConfirmation.ValueData >= vbDatePUSH;   

       IF COALESCE (vbText, '') <> ''
       THEN         
         INSERT INTO _PUSH (Id, Text)
         VALUES (76, '���������� �� ������'||CHR(13)||CHR(13)||vbText||CHR(13)||CHR(13)||'��������� ����!');
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
          , _PUSH.SpecialLighting        AS SpecialLighting
          , _PUSH.TextColor              AS Color
          , _PUSH.Color                  AS Color
          , _PUSH.Bold                   AS Bold
          , _PUSH.GridData               AS GridData
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

SELECT * FROM gpGet_PUSH_Farmacy(1,'3')