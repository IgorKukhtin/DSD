-- Function: gpInsertUpdate_MI_PersonalService_Compensation_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Compensation_Load (Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PersonalService_Compensation_Load(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inFIO                 TVarChar  , -- ФИО
    IN inPositionName        TVarChar  , --
    IN inUnitName            TVarChar  , -- Подразделение
    IN inSummCompensation    TFloat    , -- компенсация 
    IN inPriceCompensation   TFloat    , -- Ср. зп для расч. компенс. 
    IN inDayVacation         TFloat    , -- Положено дней отпуска
    IN inDayCompensation     TFloat    , -- Кол-во дн. компенс. отпуска
    IN inDayWork             TFloat    , -- Рабочих дней 
    IN inDayHoliday          TFloat    , -- Исп. дней отпуска
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
   DECLARE vbPositionId Integer;
   DECLARE vbPositionId_2 Integer;
   DECLARE vbUnitId Integer; 
   DECLARE vbCodePersonal Integer;
   DECLARE vbMemberId Integer; 
   DECLARE vbMovementItem Integer;
   --DECLARE vbMemberId_2 Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService());
     vbUserId := lpGetUserBySession (inSession);

     --RAISE EXCEPTION 'Сотрудник <%> не найден с ИНН = <%> и суммой <%> .', inFIO, inINN, inSummMinusExtRecalc;

 --RAISE EXCEPTION 'Ошибка. Документ не сохранен';
 
     IF COALESCE (inMovementId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Документ не сохранен';
     END IF;

     -- проверка
     IF inFIO = '-' AND COALESCE (inSummCompensation, 0) = 0
     THEN
         RETURN;
     END IF;

     IF TRIM(inFIO) = TRIM('ФИО') OR TRIM(inUnitName) = TRIM('Подразделение')
     THEN
         RETURN;
     END IF;
     
     -- проверка
     IF COALESCE (inPositionName, '') = ''
     THEN
         RAISE EXCEPTION 'Ошибка.У <%> <%> не заполненное поле <Должность> в файле Excel для суммы <%>.', inFIO, inUnitName, inSummCompensation;
     END IF;
     IF COALESCE (inUnitName, '') = ''
     THEN
         RAISE EXCEPTION 'Ошибка.У <%> <%> не заполненное поле <Подразделение> в файле Excel для суммы <%>.', inFIO, inPositionName, inSummCompensation;
     END IF;     

     -- поиск должности
     vbPositionId := (SELECT MIN (Object.Id) FROM Object 
                      WHERE Object.DescId = zc_Object_Position() 
                        AND Object.isErased = FALSE
                        AND REPLACE(REPLACE(TRIM (Object.ValueData),'''',''),'`','') LIKE REPLACE(REPLACE(TRIM (inPositionName),'''',''),'`','')
                      );

     -- поиск должности
     vbPositionId_2 := (SELECT MAX (Object.Id) FROM Object 
                        WHERE Object.DescId = zc_Object_Position() 
                          AND Object.isErased = FALSE
                          AND REPLACE(REPLACE(TRIM (Object.ValueData),'''',''),'`','') LIKE REPLACE(REPLACE(TRIM (inPositionName),'''',''),'`','')
                        );


     -- проверка если не нашли должность
     IF COALESCE (vbPositionId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.У <%> не найдена <Должность> = <%> в справочнике.', inFIO, inPositionName;
     END IF;

     -- находим Подразделение
     vbUnitId := (SELECT Object.Id
                  FROM Object 
                  WHERE Object.DescId = zc_Object_Unit() 
                    AND Object.isErased = FALSE
                    AND REPLACE (REPLACE(TRIM (Object.ValueData),'''',''),'`','') ILIKE REPLACE (REPLACE (TRIM (inUnitName),'''',''),'`','')
                  ); 
     IF COALESCE (vbUnitId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.<%> не найдено в справочнике Подразделений.', inUnitName;
     END IF;

  
     --один раз віберем персонал
     CREATE TEMP TABLE _tmpPersonal_View ON COMMIT DROP AS
             (SELECT Object_Personal.Id                                       AS PersonalId 
                   , Object_Personal.ValueData                                AS PersonalName
                   , ObjectLink_Personal_Member.ChildObjectId                 AS MemberId
                   , COALESCE (ObjectLink_Personal_Position.ChildObjectId, 0) AS PositionId
                   , COALESCE (ObjectLink_Personal_Unit.ChildObjectId, 0)     AS UnitId
                   , ObjectDate_DateOut.ValueData                             AS DateOut
                   , COALESCE (ObjectBoolean_Main.ValueData, FALSE)           AS isMain
                   , COALESCE (ObjectBoolean_Official.ValueData, FALSE)       AS isOfficial
                   , Object_Personal.isErased                                 AS isErased
              FROM Object AS Object_Personal
                   LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                        ON ObjectLink_Personal_Member.ObjectId = Object_Personal.Id
                                       AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                   LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                        ON ObjectLink_Personal_Position.ObjectId = Object_Personal.Id
                                       AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                   LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                        ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                                       AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                   LEFT JOIN ObjectDate AS ObjectDate_DateOut
                                        ON ObjectDate_DateOut.ObjectId = Object_Personal.Id
                                       AND ObjectDate_DateOut.DescId = zc_ObjectDate_Personal_Out()
                   LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                           ON ObjectBoolean_Main.ObjectId = Object_Personal.Id
                                          AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Personal_Main()
                   LEFT JOIN ObjectBoolean AS ObjectBoolean_Official
                                           ON ObjectBoolean_Official.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                          AND ObjectBoolean_Official.DescId = zc_ObjectBoolean_Member_Official()
              WHERE Object_Personal.DescId = zc_Object_Personal()
                AND COALESCE (ObjectLink_Personal_Unit.ChildObjectId, 0) = vbUnitId   
             );   
                  
     -- проверка
     IF 1 < (SELECT COUNT(*)
             FROM (SELECT Object_Personal_View.PersonalId
                        , ROW_NUMBER() OVER (PARTITION BY Object_Personal_View.MemberId
                                             -- сортировкой определяется приоритет для выбора, т.к. выбираем с Ord = 1
                                             ORDER BY CASE WHEN COALESCE (Object_Personal_View.DateOut, zc_DateEnd()) = zc_DateEnd() THEN 0 ELSE 1 END
                                                    , CASE WHEN Object_Personal_View.isOfficial = TRUE THEN 0 ELSE 1 END
                                                    , CASE WHEN Object_Personal_View.isMain = TRUE THEN 0 ELSE 1 END
                                                    , Object_Personal_View.MemberId
                                            ) AS Ord
                   FROM _tmpPersonal_View AS Object_Personal_View
                   WHERE Object_Personal_View.PositionId = vbPositionId
                     AND Object_Personal_View.UnitId = vbUnitId
                     AND Object_Personal_View.isErased = FALSE
                     --AND Object_Personal_View.MemberId = vbMemberId
                     AND REPLACE (REPLACE(TRIM (Object_Personal_View.PersonalName),'''',''),'`','') ILIKE REPLACE (REPLACE (TRIM (inFIO),'''',''),'`','')
                  ) AS tmp
             WHERE tmp.Ord = 1
            )
     THEN
         RAISE EXCEPTION 'Ошибка.Найдено больше одного ФИО для <%> <%> <%> (%) (%).', lfGet_Object_ValueData_sh (vbUnitId), inFIO, lfGet_Object_ValueData_sh (vbPositionId), vbUnitId, vbPositionId;
     END IF;

     -- находим
     vbPersonalId := (SELECT tmp.PersonalId
                      FROM (SELECT Object_Personal_View.PersonalId
                                 , ROW_NUMBER() OVER (PARTITION BY Object_Personal_View.MemberId
                                                      -- сортировкой определяется приоритет для выбора, т.к. выбираем с Ord = 1
                                                      ORDER BY CASE WHEN COALESCE (Object_Personal_View.DateOut, zc_DateEnd()) = zc_DateEnd() THEN 0 ELSE 1 END
                                                             , CASE WHEN Object_Personal_View.isOfficial = TRUE THEN 0 ELSE 1 END
                                                             , CASE WHEN Object_Personal_View.isMain = TRUE THEN 0 ELSE 1 END
                                                             , Object_Personal_View.MemberId
                                                     ) AS Ord
                            FROM _tmpPersonal_View AS Object_Personal_View
                            WHERE Object_Personal_View.PositionId = vbPositionId
                              AND Object_Personal_View.UnitId = vbUnitId
                              --AND Object_Personal_View.MemberId = vbMemberId
                              AND Object_Personal_View.isErased = FALSE
                              AND REPLACE (REPLACE(TRIM (Object_Personal_View.PersonalName),'''',''),'`','') ILIKE REPLACE (REPLACE (TRIM (inFIO),'''',''),'`','')
                           ) AS tmp
                      WHERE tmp.Ord = 1
                     );

     -- проверка
     IF COALESCE (vbPersonalId, 0) = 0
     THEN
         --- пробуем найти с должностью 2
         vbPersonalId := (SELECT tmp.PersonalId
                          FROM (SELECT Object_Personal_View.PersonalId
                                     , ROW_NUMBER() OVER (PARTITION BY Object_Personal_View.MemberId
                                                          -- сортировкой определяется приоритет для выбора, т.к. выбираем с Ord = 1
                                                          ORDER BY CASE WHEN COALESCE (Object_Personal_View.DateOut, zc_DateEnd()) = zc_DateEnd() THEN 0 ELSE 1 END
                                                                 , CASE WHEN Object_Personal_View.isOfficial = TRUE THEN 0 ELSE 1 END
                                                                 , CASE WHEN Object_Personal_View.isMain = TRUE THEN 0 ELSE 1 END
                                                                 , Object_Personal_View.MemberId
                                                         ) AS Ord
                                FROM _tmpPersonal_View AS Object_Personal_View
                                WHERE Object_Personal_View.PositionId = vbPositionId_2
                                  AND Object_Personal_View.UnitId = vbUnitId
                                  --AND Object_Personal_View.MemberId = vbMemberId
                                  AND REPLACE (REPLACE(TRIM (Object_Personal_View.PersonalName),'''',''),'`','') ILIKE REPLACE (REPLACE (TRIM (inFIO),'''',''),'`','')
                                ) AS tmp
                          WHERE tmp.Ord = 1
                         );

          -- если нашли по должности 2 переопределяем
          vbPositionId:= vbPositionId_2;
           
          IF COALESCE (vbPersonalId, 0) = 0
          THEN         
              RAISE EXCEPTION 'Ошибка.Сотрудник <%> не найден, должность = <%>, подразделение = <%> и суммой <%> .', inFIO, inPositionName, inUnitName, inSummCompensation;
          END IF;
     END IF;

     --- данные строк для ускорения выбираем напрямую   
   CREATE TEMP TABLE _tmpMI ON COMMIT DROP AS(
   WITH   
       tmpMI AS (SELECT MovementItem.*
                 FROM MovementItem
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.ObjectId = vbPersonalId 
                   AND MovementItem.isErased = False
                   AND MovementItem.DescId = zc_MI_Master()
                 )
     , MIString AS (SELECT *
                    FROM MovementItemString
                    WHERE MovementItemString.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI)
                      AND MovementItemString.DescId IN (zc_MIString_Comment()
                                                      , zc_MIString_Number()
                                                       )
                   )
     , MIFloat AS (SELECT *
                   FROM MovementItemFloat
                   WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI)
                  )  
     , MILO AS (SELECT *
                FROM MovementItemLinkObject
                WHERE MovementItemLinkObject.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI)
                  AND MovementItemLinkObject.DescId IN (zc_MILinkObject_FineSubject()
                                                      , zc_MILinkObject_UnitFineSubject()
                                                      , zc_MILinkObject_InfoMoney()
                                                      , zc_MILinkObject_PersonalServiceList()
                                                      , zc_MILinkObject_Unit()
                                                      , zc_MILinkObject_Position()
                                                      , zc_MILinkObject_Member()
                                                   ) 
                )  
     , MIBoolean AS (SELECT *
                     FROM MovementItemBoolean
                     WHERE MovementItemBoolean.MovementItemId IN  (SELECT tmpMI.Id FROM tmpMI)
                       AND MovementItemBoolean.DescId IN (zc_MIBoolean_Main()
                                                       
                                                        )
                    )
       ---
       SELECT MovementItem.Id                         AS Id
            , MovementItem.ObjectId                   AS PersonalId
            , MIFloat_SummService.ValueData           AS SummService
            , MIFloat_SummCardRecalc.ValueData        AS SummCardRecalc
            , MIFloat_SummCardSecondCash.ValueData    AS SummCardSecondCash 
            , MIFloat_SummNalogRecalc.ValueData       AS SummNalogRecalc
            , MIFloat_SummMinusExtRecalc.ValueData    AS SummMinusExtRecalc
            , MIFloat_SummMinus.ValueData             AS SummMinus 
            , MIFloat_SummAddOthRecalc.ValueData      AS SummAddOthRecalc
            , MIFloat_SummAdd.ValueData               AS SummAdd
            , MIFloat_SummHoliday.ValueData           AS SummHoliday
            , MIFloat_SummSocialIn.ValueData          AS SummSocialIn
            , MIFloat_SummSocialAdd.ValueData         AS SummSocialAdd 
            , MIFloat_SummChildRecalc.ValueData       AS SummChildRecalc
            , MIFloat_SummFine.ValueData              AS SummFine
            , MIFloat_SummFineOthRecalc.ValueData     AS SummFineOthRecalc              
            , MIFloat_SummHosp.ValueData              AS SummHosp
            , MIFloat_SummHospOthRecalc.ValueData     AS SummHospOthRecalc
            , MIFloat_SummCompensationRecalc.ValueData  AS SummCompensationRecalc
            , MIFloat_SummAuditAdd.ValueData          AS SummAuditAdd
            , MIFloat_SummHouseAdd.ValueData          AS SummHouseAdd
            , MIFloat_SummAvance.ValueData            AS SummAvance    
            , MIString_Number.ValueData               AS Number
            , MIString_Comment.ValueData              AS Comment 
            , MILinkObject_InfoMoney.ObjectId         AS InfoMoneyId
            , MILinkObject_PersonalServiceList.ObjectId  AS PersonalServiceListId
            , MILinkObject_FineSubject.ObjectId          AS FineSubjectId
            , MILinkObject_UnitFineSubject.ObjectId      AS UnitFineSubjectId 
            , MILinkObject_Unit.ObjectId                 AS UnitId
            , MILinkObject_Position.ObjectId             AS PositionId
            , MILinkObject_Member.ObjectId               AS MemberId
            , COALESCE (MIBoolean_Main.ValueData, FALSE) AS IsMain
       FROM tmpMI AS MovementItem
             LEFT JOIN MIFloat AS MIFloat_SummService
                                        ON MIFloat_SummService.MovementItemId =  MovementItem.Id
                                       AND MIFloat_SummService.DescId = zc_MIFloat_SummService()
            LEFT JOIN MIFloat AS MIFloat_SummCardRecalc
                                        ON MIFloat_SummCardRecalc.MovementItemId =  MovementItem.Id
                                       AND MIFloat_SummCardRecalc.DescId = zc_MIFloat_SummCardRecalc()                                       
            LEFT JOIN MIFloat AS MIFloat_SummCardSecondCash
                                        ON MIFloat_SummCardSecondCash.MovementItemId =  MovementItem.Id
                                       AND MIFloat_SummCardSecondCash.DescId = zc_MIFloat_SummCardSecondCash()                                             
            LEFT JOIN MIFloat AS MIFloat_SummNalogRecalc
                                        ON MIFloat_SummNalogRecalc.MovementItemId =  MovementItem.Id
                                       AND MIFloat_SummNalogRecalc.DescId = zc_MIFloat_SummNalogRecalc()
            LEFT JOIN MIFloat AS MIFloat_SummMinusExtRecalc
                                        ON MIFloat_SummMinusExtRecalc.MovementItemId =  MovementItem.Id
                                       AND MIFloat_SummMinusExtRecalc.DescId = zc_MIFloat_SummMinusExtRecalc()       
            LEFT JOIN MIFloat AS MIFloat_SummMinus
                                        ON MIFloat_SummMinus.MovementItemId =  MovementItem.Id
                                       AND MIFloat_SummMinus.DescId = zc_MIFloat_SummMinus()
            LEFT JOIN MIFloat AS MIFloat_SummAddOthRecalc
                                        ON MIFloat_SummAddOthRecalc.MovementItemId =  MovementItem.Id
                                       AND MIFloat_SummAddOthRecalc.DescId = zc_MIFloat_SummAddOthRecalc()                                       
            LEFT JOIN MIFloat AS MIFloat_SummAdd
                                        ON MIFloat_SummAdd.MovementItemId =  MovementItem.Id
                                       AND MIFloat_SummAdd.DescId = zc_MIFloat_SummAdd()
            LEFT JOIN MIFloat AS MIFloat_SummHoliday
                                        ON MIFloat_SummHoliday.MovementItemId =  MovementItem.Id
                                       AND MIFloat_SummHoliday.DescId = zc_MIFloat_SummHoliday()                                       
            LEFT JOIN MIFloat AS MIFloat_SummSocialIn
                                        ON MIFloat_SummSocialIn.MovementItemId =  MovementItem.Id
                                       AND MIFloat_SummSocialIn.DescId = zc_MIFloat_SummSocialIn()
            LEFT JOIN MIFloat AS MIFloat_SummSocialAdd
                                        ON MIFloat_SummSocialAdd.MovementItemId =  MovementItem.Id
                                       AND MIFloat_SummSocialAdd.DescId = zc_MIFloat_SummSocialAdd()
            LEFT JOIN MIFloat AS MIFloat_SummChildRecalc
                                        ON MIFloat_SummChildRecalc.MovementItemId =  MovementItem.Id
                                       AND MIFloat_SummChildRecalc.DescId = zc_MIFloat_SummChildRecalc()
            LEFT JOIN MIFloat AS MIFloat_SummFine
                                        ON MIFloat_SummFine.MovementItemId =  MovementItem.Id
                                       AND MIFloat_SummFine.DescId = zc_MIFloat_SummFine()
            LEFT JOIN MIFloat AS MIFloat_SummFineOthRecalc
                                        ON MIFloat_SummFineOthRecalc.MovementItemId =  MovementItem.Id
                                       AND MIFloat_SummFineOthRecalc.DescId = zc_MIFloat_SummFineOthRecalc()                                                                              
            LEFT JOIN MIFloat AS MIFloat_SummHosp
                                        ON MIFloat_SummHosp.MovementItemId =  MovementItem.Id
                                       AND MIFloat_SummHosp.DescId = zc_MIFloat_SummHosp()
            LEFT JOIN MIFloat AS MIFloat_SummHospOthRecalc
                                        ON MIFloat_SummHospOthRecalc.MovementItemId =  MovementItem.Id
                                       AND MIFloat_SummHospOthRecalc.DescId = zc_MIFloat_SummHospOthRecalc()                                       
            LEFT JOIN MIFloat AS MIFloat_SummCompensationRecalc
                                        ON MIFloat_SummCompensationRecalc.MovementItemId =  MovementItem.Id
                                       AND MIFloat_SummCompensationRecalc.DescId = zc_MIFloat_SummCompensationRecalc()                                                                              
            LEFT JOIN MIFloat AS MIFloat_SummAuditAdd
                                        ON MIFloat_SummAuditAdd.MovementItemId =  MovementItem.Id
                                       AND MIFloat_SummAuditAdd.DescId = zc_MIFloat_SummAuditAdd()                                       
            LEFT JOIN MIFloat AS MIFloat_SummHouseAdd
                                        ON MIFloat_SummHouseAdd.MovementItemId =  MovementItem.Id
                                       AND MIFloat_SummHouseAdd.DescId = zc_MIFloat_SummHouseAdd()                                       
            LEFT JOIN MIFloat AS MIFloat_SummAvance
                                        ON MIFloat_SummAvance.MovementItemId =  MovementItem.Id
                                       AND MIFloat_SummAvance.DescId = zc_MIFloat_SummAvance()                                       

            LEFT JOIN MIString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId =  MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
            LEFT JOIN MIString AS MIString_Number
                                         ON MIString_Number.MovementItemId =  MovementItem.Id
                                        AND MIString_Number.DescId = zc_MIString_Number()

            LEFT JOIN MILO AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()                                        
                                        
            LEFT JOIN MILO AS MILinkObject_PersonalServiceList
                                             ON MILinkObject_PersonalServiceList.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PersonalServiceList.DescId = zc_MILinkObject_PersonalServiceList()                                                                               
            LEFT JOIN MILO AS MILinkObject_FineSubject
                           ON MILinkObject_FineSubject.MovementItemId = MovementItem.Id
                          AND MILinkObject_FineSubject.DescId = zc_MILinkObject_FineSubject()
            LEFT JOIN Object AS Object_FineSubject ON Object_FineSubject.Id = MILinkObject_FineSubject.ObjectId
            
            LEFT JOIN MILO AS MILinkObject_UnitFineSubject
                           ON MILinkObject_UnitFineSubject.MovementItemId = MovementItem.Id
                          AND MILinkObject_UnitFineSubject.DescId = zc_MILinkObject_UnitFineSubject()
            LEFT JOIN Object AS Object_UnitFineSubject ON Object_UnitFineSubject.Id = MILinkObject_UnitFineSubject.ObjectId   
            
            LEFT JOIN MILO AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN MILO AS MILinkObject_Position
                                             ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
            LEFT JOIN MILO AS MILinkObject_Member
                                             ON MILinkObject_Member.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Member.DescId = zc_MILinkObject_Member()
            LEFT JOIN MIBoolean AS MIBoolean_Main
                                          ON MIBoolean_Main.MovementItemId = MovementItem.Id
                                         AND MIBoolean_Main.DescId = zc_MIBoolean_Main()
            );


     -- сохранили , в случае если сотрудника не было в ведомости сохраним его
     PERFORM lpInsertUpdate_MovementItem_PersonalService (ioId                 := COALESCE (gpSelect.Id,0)
                                                        , inMovementId         := inMovementId
                                                        , inPersonalId         := tmpPersonal.PersonalId
                                                        , inIsMain             := COALESCE (gpSelect.IsMain, tmpPersonal.IsMain)
                                                        , inSummService        := COALESCE (gpSelect.SummService, 0)
                                                        , inSummCardRecalc     := COALESCE (gpSelect.SummCardRecalc, 0)
                                                        , inSummCardSecondRecalc:= 0
                                                        , inSummCardSecondCash := COALESCE (gpSelect.SummCardSecondCash,0)
                                                        , inSummNalogRecalc    := COALESCE (gpSelect.SummNalogRecalc, 0)
                                                        , inSummNalogRetRecalc := 0
                                                        , inSummMinus          := COALESCE (gpSelect.SummMinus, 0)
                                                        , inSummAdd            := COALESCE (gpSelect.SummAdd, 0)
                                                        , inSummAddOthRecalc   := COALESCE (gpSelect.SummAddOthRecalc, 0)
                                                        , inSummHoliday        := COALESCE (gpSelect.SummHoliday, 0)
                                                        , inSummSocialIn       := COALESCE (gpSelect.SummSocialIn, 0)
                                                        , inSummSocialAdd      := COALESCE (gpSelect.SummSocialAdd, 0)
                                                        , inSummChildRecalc    := COALESCE (gpSelect.SummChildRecalc, 0)
                                                        , inSummMinusExtRecalc := COALESCE (gpSelect.SummMinusExtRecalc, 0)
                                                        , inSummFine           := COALESCE (gpSelect.SummFine, 0)
                                                        , inSummFineOthRecalc  := COALESCE (gpSelect.SummFineOthRecalc, 0)
                                                        , inSummHosp           := COALESCE (gpSelect.SummHosp, 0)
                                                        , inSummHospOthRecalc  := COALESCE (gpSelect.SummHospOthRecalc, 0)
                                                        , inSummCompensationRecalc := COALESCE (gpSelect.SummCompensationRecalc, 0)
                                                        , inSummAuditAdd       := COALESCE (gpSelect.SummAuditAdd,0)
                                                        , inSummHouseAdd       := COALESCE (gpSelect.SummHouseAdd,0)
                                                        , inSummAvanceRecalc   := COALESCE (gpSelect.SummAvance,0)
                                                        , inNumber             := COALESCE (gpSelect.Number, '')
                                                        , inComment            := COALESCE (gpSelect.Comment, '') ::TVarChar
                                                        , inInfoMoneyId        := COALESCE (gpSelect.InfoMoneyId, zc_Enum_InfoMoney_60101()) -- 60101 Заработная плата + Заработная плата
                                                        , inUnitId             := tmpPersonal.UnitId
                                                        , inPositionId         := tmpPersonal.PositionId
                                                        , inMemberId               := gpSelect.MemberId                                     -- Физ лицо (кому начисляют алименты)
                                                        , inPersonalServiceListId  := gpSelect.PersonalServiceListId 
                                                        , inFineSubjectId          := gpSelect.FineSubjectId     ::Integer
                                                        , inUnitFineSubjectId      := gpSelect.UnitFineSubjectId ::Integer
                                                        , inUserId             := vbUserId
                                                         )
      FROM (SELECT View_Personal.PersonalId
                 , View_Personal.UnitId
                 , View_Personal.PositionId
                 , View_Personal.IsMain
            FROM _tmpPersonal_View AS View_Personal
            WHERE View_Personal.PersonalId = vbPersonalId
           ) AS tmpPersonal   
           LEFT JOIN _tmpMI AS gpSelect
                            ON gpSelect.PersonalId = tmpPersonal.PersonalId
                           AND gpSelect.PositionId = vbPositionId
                           AND gpSelect.UnitId = vbUnitId
          /* LEFT JOIN gpSelect_MovementItem_PersonalService (inMovementId, FALSE, FALSE, inSession) AS gpSelect
                                                                                                   ON gpSelect.PersonalId = tmpPersonal.PersonalId
                                                                                                  AND gpSelect.PositionId = vbPositionId
                                                                                                  AND gpSelect.UnitId = vbUnitId*/
      LIMIT 1;

     -- дописываем данные по компенсации отпуска
     PERFORM -- Положено дней отпуска
             lpInsertUpdate_MovementItemFloat (zc_MIFloat_DayVacation(), COALESCE (gpSelect.Id,0), inDayVacation)
             -- использовано дней отпуска
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_DayHoliday(), COALESCE (gpSelect.Id,0), inDayHoliday)
             -- дней компенсации - кол-во дней отпуска за которые компенсация
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_DayCompensation(), COALESCE (gpSelect.Id,0), inDayCompensation)
             -- Рабочих дней
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_DayWork(), COALESCE (gpSelect.Id,0), inDayWork)
             --  средняя зп для расчета суммы компенсации
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceCompensation(), COALESCE (gpSelect.Id,0), inPriceCompensation)
             -- сумма компенсации
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCompensationRecalc(), COALESCE (gpSelect.Id,0), inSummCompensation)
   
     FROM (WITH   
           tmpMI AS (SELECT MovementItem.*
                     FROM MovementItem
                     WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.ObjectId = vbPersonalId 
                       AND MovementItem.isErased = False
                       AND MovementItem.DescId = zc_MI_Master()
                     )
         , MILO AS (SELECT *
                    FROM MovementItemLinkObject
                    WHERE MovementItemLinkObject.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI)
                      AND MovementItemLinkObject.DescId IN (zc_MILinkObject_Unit()
                                                          , zc_MILinkObject_Position()
                                                       )
                    )
          SELECT MovementItem.Id      AS Id
          FROM tmpMI AS MovementItem
               LEFT JOIN MILO AS MILinkObject_Unit
                                                ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                               AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
               LEFT JOIN MILO AS MILinkObject_Position
                                                ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                               AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
          WHERE MILinkObject_Position.ObjectId = vbPositionId
            AND MILinkObject_Unit.ObjectId = vbUnitId
          ) AS gpSelect
         ;
   
   /*  FROM gpSelect_MovementItem_PersonalService (inMovementId, FALSE, FALSE, inSession) AS gpSelect
     WHERE gpSelect.PersonalId = vbPersonalId
       AND gpSelect.PositionId = vbPositionId
       AND gpSelect.UnitId = vbUnitId
     ; */


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  
 06.04.23         *
*/

-- тест
--
