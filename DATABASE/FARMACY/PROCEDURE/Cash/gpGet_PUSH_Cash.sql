-- Function: gpGet_PUSH_Cash(TVarChar)

--DROP FUNCTION IF EXISTS gpGet_PUSH_Cash(TVarChar);
DROP FUNCTION IF EXISTS gpGet_PUSH_Cash(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_PUSH_Cash(
    IN inisStart     Boolean  ,     -- Первый запуск после входа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Text TBlob, isPoll boolean,
               FormName TVarChar, Button TVarChar, Params TVarChar, TypeParams TVarChar, ValueParams TVarChar,
               isFormOpen boolean, isFormLoad boolean, isExecStoredProc boolean, 
               isSpecialLighting Boolean, TextColor Integer, Color Integer, isBold Boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbRetailId Integer;
   DECLARE vbMovementID Integer;
   DECLARE vbEmployeeShow Boolean;
   DECLARE vbPositionCode Integer;
   DECLARE vbText TBlob;   
   DECLARE vbUnitName TVarChar;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;
    
    vbUnitName := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbUnitId);

    vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical());

    vbPositionCode := (SELECT Object_Position.ObjectCode
                       FROM ObjectLink AS ObjectLink_User_Member
                            LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                                                 ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                                                AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
                            LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId
                       WHERE ObjectLink_User_Member.ObjectId = vbUserId
                         AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member());

    CREATE TEMP TABLE _PUSH (Id  Integer
                           , Text TBlob
                           , isPoll boolean
                           , FormName TVarChar
                           , Button TVarChar
                           , Params TVarChar
                           , TypeParams TVarChar
                           , ValueParams TVarChar
                           , isFormOpen boolean Not Null Default False
                           , isFormLoad boolean Not Null Default True
                           , isExecStoredProc boolean Not Null Default False
                           , isSpecialLighting Boolean Not Null Default False
                           , TextColor Integer
                           , Color Integer
                           , isBold Boolean Not Null Default False) ON COMMIT DROP;

     -- Отметка посещаемости
    IF vbRetailId = 4 AND
       EXISTS(SELECT COALESCE (ObjectBoolean_NotSchedule.ValueData, False)
              FROM Object AS Object_User
                   LEFT JOIN ObjectLink AS ObjectLink_User_Member
                          ON ObjectLink_User_Member.ObjectId = Object_User.Id
                         AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                   LEFT JOIN ObjectBoolean AS ObjectBoolean_NotSchedule
                                           ON ObjectBoolean_NotSchedule.ObjectId = ObjectLink_User_Member.ChildObjectId
                                          AND ObjectBoolean_NotSchedule.DescId = zc_ObjectBoolean_Member_NotSchedule()
              WHERE Object_User.Id = vbUserId
                AND COALESCE (ObjectBoolean_NotSchedule.ValueData, False) = False)
    THEN
      vbEmployeeShow := True;
      IF EXISTS(SELECT 1 FROM Movement
                WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE)
                AND Movement.DescId = zc_Movement_EmployeeSchedule())
      THEN

        SELECT Movement.ID
        INTO vbMovementID
        FROM Movement
        WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE)
          AND Movement.DescId = zc_Movement_EmployeeSchedule();

        IF EXISTS(SELECT 1 FROM MovementItem AS MIMaster
                         INNER JOIN MovementItem AS MIChild
                                                 ON MIChild.MovementId = vbMovementID
                                                AND MIChild.DescId = zc_MI_Child()
                                                AND MIChild.ParentId = MIMaster.ID
                                                AND MIChild.Amount = date_part('DAY',  CURRENT_DATE)::Integer
                         LEFT JOIN MovementItemDate AS MIDate_Start
                                                     ON MIDate_Start.MovementItemId = MIChild.Id
                                                    AND MIDate_Start.DescId = zc_MIDate_Start()

                         LEFT JOIN MovementItemDate AS MIDate_End
                                                    ON MIDate_End.MovementItemId = MIChild.Id
                                                   AND MIDate_End.DescId = zc_MIDate_End()

                         LEFT JOIN MovementItemBoolean AS MIBoolean_ServiceExit
                                                       ON MIBoolean_ServiceExit.MovementItemId = MIChild.Id
                                                      AND MIBoolean_ServiceExit.DescId = zc_MIBoolean_ServiceExit()
                  WHERE MIMaster.MovementId = vbMovementID
                    AND MIMaster.DescId = zc_MI_Master()
                    AND MIMaster.ObjectId = vbUserId
                    AND (COALESCE(MIBoolean_ServiceExit.ValueData, FALSE) = TRUE
                     OR MIBoolean_ServiceExit.ValueData IS NOT NULL AND MIDate_End.ValueData IS NOT NULL))
           OR
           EXISTS(SELECT 1
                  FROM MovementItem AS MIMaster
                       INNER JOIN MovementItem AS MIChild
                                               ON MIChild.MovementId = MIMaster.MovementId
                                              AND MIChild.DescId = zc_MI_Child()
                                              AND MIChild.ParentId = MIMaster.ID
                                              AND MIChild.Amount = date_part('DAY',  CURRENT_DATE)::Integer - 1

                       INNER JOIN MovementItemDate AS MIDate_End
                                                   ON MIDate_End.MovementItemId = MIChild.Id
                                                  AND MIDate_End.DescId = zc_MIDate_End()
                                                  AND MIDate_End.ValueData > date_trunc('day', CURRENT_DATE)


                  WHERE MIMaster.MovementId = (SELECT Movement.ID
                                               FROM Movement
                                               WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE - interval '1 day')
                                                 AND Movement.DescId = zc_Movement_EmployeeSchedule() )
                    AND MIMaster.DescId = zc_MI_Master()
                    AND MIMaster.ObjectId = vbUserId)
        THEN
          vbEmployeeShow := False;
        END IF;
      END IF;

     IF vbEmployeeShow = True AND vbRetailId = 4
     THEN
        INSERT INTO _PUSH (Id, Text) VALUES (1, 'Уважаемые коллеги, не забудьте сегодня поставить отметки времени прихода и ухода в график (Ctrl+T), исходя из персонального графика работы (время вводится с шагом 30 мин)');
     END IF;
   END IF;

   -- Уведомление по рецептам Хелси и Фармасикеш
   IF vbUnitId in (9951517, 375627, 183289)
     AND date_part('HOUR',  CURRENT_TIME)::Integer = 17
     AND date_part('MINUTE',  CURRENT_TIME)::Integer >= 30
     AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 50
   THEN
      INSERT INTO _PUSH (Id, Text) VALUES (2, 'В конце рабочего дня проверить соотвествие рецептов, прошедших по Хелси и Фармасикеш! За качество сверки  фармацевт несет полную отвественность!"');
   END IF;

   -- Уведомление по перемещениям на склад просрочки
   IF EXISTS(SELECT 1 FROM Object AS Object_Unit

               INNER JOIN ObjectBoolean AS ObjectBoolean_DividePartionDate
                                        ON ObjectBoolean_DividePartionDate.ObjectId = Object_Unit.Id
                                       AND ObjectBoolean_DividePartionDate.DescId = zc_ObjectBoolean_Unit_DividePartionDate()
                                      AND ObjectBoolean_DividePartionDate.ValueData = True

               INNER JOIN ObjectLink AS ObjectLink_Unit_UnitOverdue
                                     ON ObjectLink_Unit_UnitOverdue.ObjectId = Object_Unit.Id
                                    AND ObjectLink_Unit_UnitOverdue.DescId = zc_ObjectLink_Unit_UnitOverdue()
                                    AND COALESCE (ObjectLink_Unit_UnitOverdue.ChildObjectId, 0) <> 0

            WHERE Object_Unit.ID = vbUnitId)
   THEN
     -- Уведомление по перемещениям на склад просрочки в пятницу
     IF date_part('DOW',     CURRENT_DATE)::Integer = 5
       AND date_part('HOUR',    CURRENT_TIME)::Integer = 16
       AND date_part('MINUTE',  CURRENT_TIME)::Integer >= 00
       AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 20
     THEN
       INSERT INTO _PUSH (Id, Text) VALUES (3, 'Коллеги, информируем вас, что во вторник на товар по вашей 4 категории (просрочка) будет создано перемещение на виртуальный склад "Сроки", если есть необходимость, проработайте данный товар!');
     END IF;

     -- Уведомление по перемещениям на склад просрочки по понедельникам
     IF date_part('DOW',     CURRENT_DATE)::Integer = 1
       AND date_part('HOUR',    CURRENT_TIME)::Integer = 16
       AND date_part('MINUTE',  CURRENT_TIME)::Integer >= 00
       AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 20
     THEN
        IF EXISTS(SELECT 1
                  FROM Movement

                       INNER JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                                     ON MovementLinkObject_PartionDateKind.MovementId =  Movement.Id
                                                    AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
                                                    AND MovementLinkObject_PartionDateKind.ObjectId = zc_Enum_PartionDateKind_0()

                       INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                     ON MovementLinkObject_From.MovementId = Movement.Id
                                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                    AND MovementLinkObject_From.ObjectId = vbUnitId
                       INNER JOIN MovementItemContainer AS MIC
                                                        ON MIC.Movementid = Movement.id
                  WHERE Movement.DescId = zc_Movement_Send()
                    AND Movement.StatusId = zc_Enum_Status_UnComplete()) OR
           EXISTS(SELECT 1
                  FROM Container

                       LEFT JOIN Object AS Object_Goods ON Object_Goods.ID = Container.ObjectId

                       LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                    AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                       LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                            ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                           AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

                       LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                               ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = ContainerLinkObject.ObjectId
                                              AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()

                  WHERE Container.DescId = zc_Container_CountPartionDate()
                    AND Container.WhereObjectId = vbUnitId
                    AND Container.Amount > 0
                    AND ObjectDate_ExpirationDate.ValueData <= CURRENT_DATE + interval '1 day'
                    AND  COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = FALSE)
        THEN
          INSERT INTO _PUSH (Id, Text) VALUES (4, 'Коллеги, информируем вас, что завтра на товар по вашей 4 категории (просрочка) будет создано перемещение на виртуальный склад "Сроки"!!!');
        END IF;
     END IF;

     -- Уведомление по перемещениям на склад просрочки по вторникам
     IF date_part('DOW',     CURRENT_DATE)::Integer = 2
       AND date_part('HOUR',    CURRENT_TIME)::Integer = 11
       AND date_part('MINUTE',  CURRENT_TIME)::Integer >= 00
       AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 20
     THEN
        IF EXISTS(SELECT 1
                  FROM Movement

                       INNER JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                                     ON MovementLinkObject_PartionDateKind.MovementId =  Movement.Id
                                                    AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
                                                    AND MovementLinkObject_PartionDateKind.ObjectId = zc_Enum_PartionDateKind_0()

                       INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                     ON MovementLinkObject_From.MovementId = Movement.Id
                                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                    AND MovementLinkObject_From.ObjectId = vbUnitId
                       INNER JOIN MovementItemContainer AS MIC
                                                        ON MIC.Movementid = Movement.id
                  WHERE Movement.DescId = zc_Movement_Send()
                    AND Movement.StatusId = zc_Enum_Status_UnComplete()) OR
           EXISTS(SELECT 1
                  FROM Container

                       LEFT JOIN Object AS Object_Goods ON Object_Goods.ID = Container.ObjectId

                       LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                    AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                       LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                            ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                           AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

                       LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                               ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = ContainerLinkObject.ObjectId
                                              AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()

                  WHERE Container.DescId = zc_Container_CountPartionDate()
                    AND Container.WhereObjectId = vbUnitId
                    AND Container.Amount > 0
                    AND ObjectDate_ExpirationDate.ValueData <= CURRENT_DATE
                    AND  COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = FALSE)
        THEN
          INSERT INTO _PUSH (Id, Text) VALUES (4, 'Коллеги, сегодня будет сформировано перемещение на виртуальный склад "Сроки", на коробке подпишите "Сегодняшнюю дату "Сроки" Аптека отправитель - Новокрымскую,4"');
        END IF;
     END IF;
   END IF;

   -- Перемещения по СУН открытие "Реестр перемещений СУН"
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
        AND DATE_PART('MINUTE',  CURRENT_TIME)::Integer <= 20)
        OR (DATE_PART('HOUR',    CURRENT_TIME)::Integer > 12
        AND DATE_PART('MINUTE',  CURRENT_TIME)::Integer >= 30
        AND DATE_PART('MINUTE',  CURRENT_TIME)::Integer <= 50
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
                                         AND MovementBoolean_SUN_v3.DescId     = zc_MovementBoolean_SUN_v3()
                                         AND MovementBoolean_SUN_v3.ValueData  = TRUE
                LEFT JOIN MovementBoolean AS MovementBoolean_NotDisplaySUN
                                          ON MovementBoolean_NotDisplaySUN.MovementId = Movement.Id
                                         AND MovementBoolean_NotDisplaySUN.DescId     = zc_MovementBoolean_NotDisplaySUN()
                                         AND MovementBoolean_NotDisplaySUN.ValueData  = TRUE
                INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                            AND MovementLinkObject_From.ObjectId    = vbUnitId
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
                         THEN Chr(13)||Chr(13)||'Просьба собрать товар сегодня до 18:00!'||Chr(13)||
                             'Напоминаем, что товар который перемещается со сроком от 90 дней до окончания срока годности, '||
                             'поэтому просим перед отправкой проверять его как на товаре по факту, так и в самом перемещении программы!' ELSE '' END,
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
                                            AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                            AND MovementLinkObject_From.ObjectId   = vbUnitId
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
                         THEN Chr(13)||Chr(13)||'Просьба собрать товар сегодня до 18:00!'||Chr(13)||
                             'Напоминаем, что товар который перемещается со сроком от 90 дней до окончания срока годности, '||
                             'поэтому просим перед отправкой проверять его как на товаре по факту, так и в самом перемещении программы!' ELSE '' END,
                   'TSendCashJournalSunForm', 'Реестр перемещений СУН', 'isSUNAll', 'ftBoolean', 'False');
      END IF;
   END IF;

     -- Коллеги, ожидайте, на вас следует перемещение по СУН!. после отправлено
/*   IF vbPositionCode = 2 AND 
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
                                                AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                AND MovementLinkObject_To.ObjectId = vbUnitId
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
   END IF;*/

     -- Коллеги, ожидайте, на вас следует перемещение по СУН!. в 16:00
/*   IF date_part('HOUR',    CURRENT_TIME)::Integer = 16
     AND date_part('MINUTE',  CURRENT_TIME)::Integer >= 00
     AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 20
     AND vbPositionCode = 2
   THEN
      IF EXISTS(SELECT 1
                FROM  Movement
                      INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                 ON MovementBoolean_SUN.MovementId = Movement.Id
                                                AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                                AND MovementBoolean_SUN.ValueData = TRUE
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
                WHERE Movement.DescId = zc_Movement_Send()
                  AND Movement.StatusId = zc_Enum_Status_UnComplete()
                  AND MovementBoolean_Received.ValueData IS NULL
                  AND MovementBoolean_SUN_v2.MovementId IS NULL
                  AND MovementBoolean_SUN_v3.MovementId IS NULL
               )
      THEN
        INSERT INTO _PUSH (Id, Text) VALUES (8, 'Коллеги, ожидайте, на вас следует перемещение по СУН!');
      END IF;
   END IF;*/
   
   -- Удалить отмененные чеки
    WITH 
         tmpMovement AS (SELECT Movement.Id
                              , Movement.OperDate
                              , Movement.InvNumber
                         FROM Movement
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId = vbUnitId
                         WHERE Movement.DescId = zc_Movement_Check()
                           AND Movement.StatusId = zc_Enum_Status_UnComplete()
                           AND Movement.OperDate >= CURRENT_DATE - INTERVAL '5 DAY')
       , tmpMovementProtocol AS (SELECT MovementProtocol.MovementId
                                      , MovementProtocol.OperDate
                                      , MovementProtocol.UserId
                                      , CASE WHEN SUBSTRING(MovementProtocol.ProtocolData, POSITION('Статус' IN MovementProtocol.ProtocolData) + 22, 1) = 'П'
                                             THEN TRUE ELSE FALSE END AS Status
                                 FROM tmpMovement AS Movement

                                      INNER JOIN MovementProtocol ON MovementProtocol.MovementId = Movement.ID
                                                                 AND COALESCE(MovementProtocol.UserId, 0) <> 0)
       , tmpMovementComplete AS (SELECT DISTINCT MovementProtocol.MovementId
                                 FROM tmpMovementProtocol AS MovementProtocol
                                 WHERE MovementProtocol.Status = TRUE)
                  
                  
    SELECT string_agg(Movement.InvNumber||' от '||zfConvert_DateShortToString (Movement.OperDate), Chr(13))
    INTO vbText
    FROM tmpMovement AS Movement
         INNER JOIN tmpMovementComplete ON tmpMovementComplete.MovementId = Movement.Id

         LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                      ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                     AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
                                     
         LEFT JOIN MovementLinkObject AS MovementLinkObject_JackdawsChecks
                                      ON MovementLinkObject_JackdawsChecks.MovementId =  Movement.Id
                                     AND MovementLinkObject_JackdawsChecks.DescId = zc_MovementLinkObject_JackdawsChecks()
                                     
         LEFT JOIN MovementString AS MovementString_FiscalCheckNumber
                                  ON MovementString_FiscalCheckNumber.MovementId = Movement.Id
                                 AND MovementString_FiscalCheckNumber.DescId = zc_MovementString_FiscalCheckNumber()
    WHERE COALESCE(MovementLinkObject_CashRegister.ObjectId, 0) = 0
       OR COALESCE(MovementLinkObject_JackdawsChecks.ObjectId, 0) <> 0
       OR COALESCE(MovementString_FiscalCheckNumber.ValueData, '') = '-5';
    
   IF COALESCE (vbText, '') <> ''
   THEN
     INSERT INTO _PUSH (Id, Text) VALUES (9, 'Коллеги, удалите распроведенные чеки:'||Chr(13)||Chr(13)||vbText);    
   END IF;
      
     -- ВНИМАНИЕ!!! ЖУРНАЛ ПОКАЗАНИЙ СЧЁТЧИКА ВОДЫ!!! СЕГОДНЯ снять и внести показания в журнал!!!
   IF date_part('DAY',    CURRENT_DATE)::Integer in (1, 15)
     AND date_part('HOUR',  CURRENT_TIME)::Integer % 2 = 00
     AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 20
     AND vbUnitName NOT ILIKE 'Апт. пункт %'
   THEN
     INSERT INTO _PUSH (Id, Text) VALUES (10, 'ВНИМАНИЕ!!!'||Chr(13)||'ЖУРНАЛ ПОКАЗАНИЙ СЧЁТЧИКА ВОДЫ!!!'||Chr(13)||Chr(13)||'СЕГОДНЯ снять и внести показания в журнал!!!');
   END IF;
  
   -- Заполнили, но не провели СУН 
   IF date_part('MINUTE',  CURRENT_TIME)::Integer <= 10 OR
      date_part('MINUTE',  CURRENT_TIME)::Integer >= 30 AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 50
   THEN
     WITH tmpMovement AS (SELECT *
                          FROM  Movement
                                INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                           ON MovementBoolean_SUN.MovementId = Movement.Id
                                                          AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                                          AND MovementBoolean_SUN.ValueData = TRUE
                                INNER JOIN MovementBoolean AS MovementBoolean_Sent
                                                           ON MovementBoolean_Sent.MovementId = Movement.Id
                                                          AND MovementBoolean_Sent.DescId     = zc_MovementBoolean_Sent()
                                                          AND MovementBoolean_Sent.ValueData  = TRUE
                                LEFT JOIN MovementBoolean AS MovementBoolean_Received
                                                          ON MovementBoolean_Received.MovementId = Movement.Id
                                                         AND MovementBoolean_Received.DescId     = zc_MovementBoolean_Received()
                                INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                              ON MovementLinkObject_To.MovementId = Movement.Id
                                                             AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                             AND MovementLinkObject_To.ObjectId   = vbUnitId
                          WHERE Movement.DescId = zc_Movement_Send()
                            AND Movement.StatusId = zc_Enum_Status_UnComplete()  
                            AND Movement.OperDate >= CURRENT_DATE - INTERVAL '7 DAY'                    
                   ),
          tmpMI AS (SELECT DISTINCT Movement.Id
                    FROM tmpMovement AS Movement
                                     
                         INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                AND MovementItem.DescId = zc_MI_Master()
                                                AND MovementItem.isErased = FALSE
                                          
                         LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                                     ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                                    AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
                         LEFT JOIN MovementItemFloat AS MIFloat_AmountStorage
                                                     ON MIFloat_AmountStorage.MovementItemId = MovementItem.Id
                                                    AND MIFloat_AmountStorage.DescId = zc_MIFloat_AmountStorage()
                    WHERE COALESCE(MIFloat_AmountManual.ValueData,0) <> COALESCE(MIFloat_AmountStorage.ValueData,0)
                    ),
          tmpMovementUnComplete AS (SELECT Movement.*
                                    FROM tmpMovement AS Movement
                                                   
                                         LEFT JOIN tmpMI ON tmpMI.Id = Movement.Id
      
                                    WHERE COALESCE(tmpMI.Id, 0) = 0
                                    ),
          tmpMovementProtocol AS (SELECT MovementProtocol.MovementId
                                       , MAX(MovementProtocol.OperDate) AS OperDate
                                  FROM tmpMovement AS Movement

                                       INNER JOIN MovementProtocol ON MovementProtocol.MovementId = Movement.ID
                                                                  AND COALESCE(MovementProtocol.UserId, 0) <> 0
                                  GROUP BY MovementProtocol.MovementId)
                   
     SELECT string_agg(Movement.InvNumber||' от '||zfConvert_DateShortToString (Movement.OperDate), Chr(13))
     INTO vbText
     FROM tmpMovementUnComplete AS  Movement
        
          INNER JOIN tmpMovementProtocol ON tmpMovementProtocol.MovementId = Movement.ID
             
     WHERE tmpMovementProtocol.OperDate > CURRENT_TIMESTAMP - INTERVAL '2 HOUR' - INTERVAL '30 minute'
       AND tmpMovementProtocol.OperDate < CURRENT_TIMESTAMP - INTERVAL '1 HOUR';    

     IF COALESCE (vbText, '') <> ''
     THEN
       INSERT INTO _PUSH (Id, Text) VALUES (11, 'Заполнили, но не провели СУН:'||Chr(13)||Chr(13)||vbText);    
     END IF;
   END IF;
      
     -- Подтверждено по телефонному звонку
   INSERT INTO _PUSH (Id, Text, FormName, Button, Params, TypeParams, ValueParams, isFormOpen, isFormLoad) 
   SELECT 12
        , '' AS Text  
        , 'TCheck_ConfirmedByPhoneCallForm'
        , ''
        , 'MovementId'
        , 'ftInteger'
        , Movement.ID::TVarChar
        , True
        , True
   FROM gpSelect_Movement_Check_ConfirmByPhone (inUnitId:= vbUnitId, inSession:= inSession) AS Movement;

     -- Обработка просрочки
   INSERT INTO _PUSH (Id, Text, FormName, Button, Params, TypeParams, ValueParams, isFormOpen, isFormLoad) 
   SELECT 13
        , '' AS Text  
        , 'TCheck_RefusalConfirmedForm'
        , ''
        , 'MovementId'
        , 'ftInteger'
        , Movement.ID::TVarChar
        , True
        , True
   FROM gpSelect_Movement_Check_RefusalConfirmed (inUnitId:= vbUnitId, inSession:= inSession) AS Movement;

   -- PUSH уведомления
   WITH tmpMovementItemUnit AS (SELECT DISTINCT Movement.Id AS MovementId
                                FROM Movement

                                    INNER JOIN MovementItem
                                           ON MovementItem.MovementId = Movement.Id
                                          AND MovementItem.DescId = zc_MI_Child()
                                          AND MovementItem.IsErased = False

                                    LEFT JOIN MovementDate AS MovementDate_DateEndPUSH
                                                           ON MovementDate_DateEndPUSH.MovementId = Movement.Id
                                                          AND MovementDate_DateEndPUSH.DescId = zc_MovementDate_DateEndPUSH()

                                WHERE Movement.OperDate <= CURRENT_TIMESTAMP
                                  AND CURRENT_TIMESTAMP < COALESCE(MovementDate_DateEndPUSH.ValueData, date_trunc('day', Movement.OperDate + INTERVAL '1 DAY'))
                                  AND Movement.DescId = zc_Movement_PUSH()
                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                                )

      , tmpMovementPUSH AS (SELECT Movement.Id                                                     AS ID
                                 , PUSH_Message.Message                                            AS Message
                                 , COALESCE(MovementBoolean_Poll.ValueData, False)                 AS isPoll
                                 , PUSH_Message.FormName                                           AS FormName
                                 , PUSH_Message.Button                                             AS Button
                                 , PUSH_Message.Params                                             AS Params
                                 , PUSH_Message.TypeParams                                         AS TypeParams
                                 , PUSH_Message.ValueParams                                        AS ValueParams
                                 , PUSH_Message.isFormOpen                                         AS isFormOpen
                                 , PUSH_Message.isFormLoad                                         AS isFormLoad
                            FROM Movement

                                 LEFT JOIN MovementDate AS MovementDate_DateEndPUSH
                                                        ON MovementDate_DateEndPUSH.MovementId = Movement.Id
                                                       AND MovementDate_DateEndPUSH.DescId = zc_MovementDate_DateEndPUSH()

                                 LEFT JOIN MovementFloat AS MovementFloat_Replays
                                                         ON MovementFloat_Replays.MovementId = Movement.Id
                                                        AND MovementFloat_Replays.DescId = zc_MovementFloat_Replays()

                                 LEFT JOIN MovementBlob AS MovementBlob_Message
                                                        ON MovementBlob_Message.MovementId = Movement.Id
                                                       AND MovementBlob_Message.DescId = zc_MovementBlob_Message()

                                 LEFT JOIN MovementBoolean AS MovementBoolean_Daily
                                                           ON MovementBoolean_Daily.MovementId = Movement.Id
                                                          AND MovementBoolean_Daily.DescId = zc_MovementBoolean_PUSHDaily()

                                 LEFT JOIN MovementBoolean AS MovementBoolean_Poll
                                                           ON MovementBoolean_Poll.MovementId = Movement.Id
                                                          AND MovementBoolean_Poll.DescId = zc_MovementBoolean_Poll()

                                 LEFT JOIN MovementBoolean AS MovementBoolean_Pharmacist
                                                           ON MovementBoolean_Pharmacist.MovementId = Movement.Id
                                                          AND MovementBoolean_Pharmacist.DescId = zc_MovementBoolean_Pharmacist()

                                 LEFT JOIN MovementLinkObject AS MLO_Retail
                                                              ON MLO_Retail.MovementId = Movement.Id
                                                             AND MLO_Retail.DescId = zc_MovementLinkObject_Retail()
                                 LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = MLO_Retail.ObjectId

                                 LEFT JOIN MovementString AS MovementString_Function
                                                          ON MovementString_Function.MovementId = Movement.Id
                                                         AND MovementString_Function.DescId = zc_MovementString_Function()

                                 LEFT JOIN MovementString AS MovementString_Form
                                                          ON MovementString_Form.MovementId = Movement.Id
                                                         AND MovementString_Form.DescId = zc_MovementString_Form()

                                 LEFT JOIN MovementItem AS MovementItem_Child
                                                        ON MovementItem_Child.MovementId = Movement.Id
                                                       AND MovementItem_Child.DescId = zc_MI_Child()
                                                       AND MovementItem_Child.ObjectId = vbUnitId
                                                       AND MovementItem_Child.isErased = False

                                 LEFT JOIN tmpMovementItemUnit AS MovementItemUnit
                                                               ON MovementItemUnit.MovementId = Movement.Id

                                 LEFT JOIN gpGet_Movement_PUSH_Message(MovementBlob_Message.ValueData,
                                                                       MovementString_Function.ValueData,
                                                                       MovementString_Form.ValueData,
                                                                       Movement.ID,
                                                                       vbUnitId,
                                                                       vbUserId) AS PUSH_Message ON 1 = 1

                            WHERE Movement.OperDate <= CURRENT_TIMESTAMP
                              AND make_time(date_part('hour', Movement.OperDate)::integer, date_part('minute', Movement.OperDate)::integer, date_part('second', Movement.OperDate)::integer) <= CURRENT_TIME
                              AND CURRENT_TIMESTAMP < COALESCE(MovementDate_DateEndPUSH.ValueData, date_trunc('day', Movement.OperDate + INTERVAL '1 DAY'))
                              AND Movement.DescId = zc_Movement_PUSH()
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                              AND (COALESCE(MovementBoolean_Pharmacist.ValueData, False) = FALSE OR vbPositionCode = 1)
                              AND (COALESCE (MLO_Retail.ObjectId, 0) = 0 OR MLO_Retail.ObjectId = vbRetailId)
                              AND (COALESCE(MovementItemUnit.MovementId, 0) = 0 OR COALESCE(MovementItem_Child.ObjectId, 0) = vbUnitId)
                              AND (COALESCE (inisStart, False) = TRUE
                                   OR
                                   COALESCE (MovementBoolean_Daily.ValueData, FALSE) = FALSE
                                   AND COALESCE(MovementFloat_Replays.ValueData, 1) >
                                       COALESCE ((SELECT MovementItem.Amount
                                                  FROM MovementItem
                                                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                                        ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                                       AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                                  WHERE MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId = zc_MI_Master()
                                                    AND MovementItem.ObjectId = vbUserId
                                                    AND COALESCE(MILinkObject_Unit.ObjectId, 0) = vbUnitId), 0)
                                   OR
                                   COALESCE (MovementBoolean_Daily.ValueData, FALSE) = TRUE
                                   AND COALESCE(MovementFloat_Replays.ValueData, 1) >
                                       COALESCE ((SELECT COALESCE(CASE WHEN date_trunc('day',MovementItemDate_Viewed.ValueData) = CURRENT_DATE 
                                                                      THEN COALESCE(MIFloat_AmountSecond.ValueData, 1) ELSE 0 END, 0)::Integer
                                                  FROM MovementItem

                                                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                                        ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                                       AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

                                                       LEFT JOIN MovementItemDate AS MovementItemDate_Viewed
                                                                                  ON MovementItemDate_Viewed.MovementItemId = MovementItem.Id
                                                                                 AND MovementItemDate_Viewed.DescId = zc_MIDate_Viewed()

                                                       LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                                                   ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                                                  AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                                                                                  
                                                  WHERE MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId = zc_MI_Master()
                                                    AND MovementItem.ObjectId = vbUserId
                                                    AND COALESCE(MILinkObject_Unit.ObjectId, 0) = vbUnitId), 0))
                            )


   INSERT INTO _PUSH (Id, Text, isPoll, FormName, Button, Params, TypeParams, ValueParams, isFormOpen, isFormLoad)
   SELECT
          tmpMovementPUSH.Id
        , tmpMovementPUSH.Message                                            AS Message
        , tmpMovementPUSH.isPoll                                             AS isPoll
        , tmpMovementPUSH.FormName                                           AS FormName
        , tmpMovementPUSH.Button                                             AS Button
        , tmpMovementPUSH.Params                                             AS Params
        , tmpMovementPUSH.TypeParams                                         AS TypeParams
        , tmpMovementPUSH.ValueParams                                        AS ValueParams
        , tmpMovementPUSH.isFormOpen                                         AS isFormOpen
        , tmpMovementPUSH.isFormLoad                                         AS isFormLoad
   FROM tmpMovementPUSH
   WHERE tmpMovementPUSH.Message <> '' OR COALESCE(tmpMovementPUSH.FormName, '') <> '' AND tmpMovementPUSH.isFormOpen = True;
   
 /*  IF vbUserId = 3
   THEN
     INSERT INTO _PUSH (Id, Text, isPoll, FormName, Button, Params, TypeParams, ValueParams, isFormOpen, isFormLoad)
     SELECT
          1111111                          AS Id
        , ''                               AS Message
        , False                            AS isPoll
        , 'TCheckHelsiSignPUSHForm'        AS FormName
        , ''                               AS Button
        , ''                               AS Params
        , ''                               AS TypeParams
        , ''                               AS ValueParams
        , True                             AS isFormOpen
        , False                            AS isFormLoad;
   END IF;*/
   
   RETURN QUERY
     SELECT _PUSH.Id                                  AS Id
          , _PUSH.Text                                AS Text
          , COALESCE(_PUSH.isPoll, False)             AS isPoll
          , _PUSH.FormName                            AS FormName
          , _PUSH.Button                              AS Button
          , _PUSH.Params                              AS Params
          , _PUSH.TypeParams                          AS TypeParams
          , _PUSH.ValueParams                         AS ValueParams
          , COALESCE(_PUSH.isFormOpen, False)         AS isFormOpen
          , COALESCE(_PUSH.isFormLoad, False)         AS isFormLoad
          , COALESCE(_PUSH.isExecStoredProc, False)   AS isExecStoredProc
          , COALESCE(_PUSH.isSpecialLighting, False)  AS isSpecialLighting
          , _PUSH.TextColor                           AS TextColor
          , _PUSH.Color                               AS Color
          , COALESCE(_PUSH.isBold, False)             AS isBold
     FROM _PUSH;
     
     
  -- raise notice 'Value: % %', vbUnitName, vbUnitName NOT ILIKE 'Апт. пункт %';

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.05.20                                                       *
 05.03.20                                                       *
 19.02.20                                                       *
 23.09.19                                                       *
 05.08.19                                                       *
 25.07.19                                                       *
 11.05.19                                                       *
 13.03.18                                                       *
 04.03.18                                                       *

*/

-- тест
-- 
SELECT * FROM gpGet_PUSH_Cash(True, '3')