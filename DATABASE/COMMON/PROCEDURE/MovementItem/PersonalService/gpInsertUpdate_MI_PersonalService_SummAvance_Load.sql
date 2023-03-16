-- Function: gpInsertUpdate_MI_PersonalService_SummAvance_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_SummAvance_Load (Integer, TVarChar, TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PersonalService_SummAvance_Load(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inFIO                 TVarChar  , -- ФИО
    IN inPositionName        TVarChar  , --
    IN inUnitName            TVarChar  , -- Подразделение
    IN inSummAvance          TFloat    , -- Начисления
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
   --DECLARE vbMemberId_2 Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService());
     vbUserId := lpGetUserBySession (inSession);

     --RAISE EXCEPTION 'Сотрудник <%> не найден с ИНН = <%> и суммой <%> .', inFIO, inINN, inSummMinusExtRecalc;

     IF COALESCE (inMovementId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Документ не сохранен';
     END IF;

     -- проверка
     IF inFIO = '-' AND COALESCE (inSummAvance, 0) = 0
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
         RAISE EXCEPTION 'Ошибка.У <%> <%> не заполненное поле <Должность> в файле Excel для суммы <%>.', inFIO, inUnitName, inSummAvance;
     END IF;
     IF COALESCE (inUnitName, '') = ''
     THEN
         RAISE EXCEPTION 'Ошибка.У <%> <%> не заполненное поле <Подразделение> в файле Excel для суммы <%>.', inFIO, inPositionName, inSummAvance;
     END IF;     

     -- проверка должности
    /* IF 1 < (SELECT COUNT(*)
             FROM Object
             WHERE Object.DescId = zc_Object_Position() AND TRIM (Object.ValueData) LIKE TRIM (inPositionName) AND Object.isErased = FALSE
            )
            AND 1=1
     THEN
         RAISE EXCEPTION 'Ошибка.Должность <%> не уникальна в справочнике должностей.', inPositionName;
     END IF;
     */
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


  /*   IF 1 < (SELECT COUNT(*)
             FROM Object
             WHERE Object.DescId = zc_Object_Member() 
               AND REPLACE (REPLACE(TRIM (Object.ValueData),'''',''),'`','') ILIKE REPLACE (REPLACE (TRIM (inFIO),'''',''),'`','')
               AND Object.isErased = FALSE
            )
            AND 1=1
     THEN
         RAISE EXCEPTION 'Ошибка.Физ.лицо <%> не уникально в справочнике физ.лиц.', inFIO;
     END IF;

     -- находим физ лицо
     vbMemberId := (SELECT Object.Id
                    FROM Object 
                    WHERE Object.DescId = zc_Object_Member() 
                      AND Object.isErased = FALSE
                      AND REPLACE (REPLACE(TRIM (Object.ValueData),'''',''),'`','') ILIKE REPLACE (REPLACE (TRIM (inFIO),'''',''),'`','') 
                    LIMIT 1
                    ); 
     IF COALESCE (vbMemberId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.<%> не найден в справочнике Физ лиц.', inFIO;
     END IF;
*/ 
      -- находим ПОдразделение
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

     /*
     --  по физ лицу должности и подр - находим сотрудника
     IF 1 < (SELECT COUNT(*)
             FROM Object_Personal_View
             WHERE Object_Personal_View.PositionId = vbPositionId
               AND Object_Personal_View.UnitId = vbUnitId
               AND Object_Personal_View.MemberId = vbMemberId
            )
     THEN
         RAISE EXCEPTION 'Ошибка.Сотрудник <%> <%> <%> не уникален в справочнике Сотрудников.', inFIO, inPositionName, inUnitName;
     END IF;
     */
            
     vbPersonalId := (SELECT tmp.PersonalId
                      FROM (SELECT Object_Personal_View.PersonalId
                                 , ROW_NUMBER() OVER (PARTITION BY Object_Personal_View.MemberId
                                                      -- сортировкой определяется приоритет для выбора, т.к. выбираем с Ord = 1
                                                      ORDER BY CASE WHEN COALESCE (Object_Personal_View.DateOut, zc_DateEnd()) = zc_DateEnd() THEN 0 ELSE 1 END
                                                             , CASE WHEN Object_Personal_View.isOfficial = TRUE THEN 0 ELSE 1 END
                                                             , CASE WHEN Object_Personal_View.isMain = TRUE THEN 0 ELSE 1 END
                                                             , Object_Personal_View.MemberId
                                                     ) AS Ord
                            FROM Object_Personal_View
                            WHERE Object_Personal_View.PositionId = vbPositionId
                              AND Object_Personal_View.UnitId = vbUnitId
                              --AND Object_Personal_View.MemberId = vbMemberId
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
                                FROM Object_Personal_View
                                WHERE Object_Personal_View.PositionId = vbPositionId_2
                                  AND Object_Personal_View.UnitId = vbUnitId
                                  --AND Object_Personal_View.MemberId = vbMemberId
                                  AND REPLACE (REPLACE(TRIM (Object_Personal_View.PersonalName),'''',''),'`','') ILIKE REPLACE (REPLACE (TRIM (inFIO),'''',''),'`','')
                                ) AS tmp
                          WHERE tmp.Ord = 1
                          );
          vbPositionId:= vbPositionId_2; --если нашли по должности 2 переопределяем
           
          IF COALESCE (vbPersonalId, 0) = 0
          THEN         
              RAISE EXCEPTION 'Ошибка.Сотрудник <%> не найден, должность = <%>, подразделение = <%> и суммой <%> .', inFIO, inPositionName, inUnitName, inSummAvance;
          END IF;
     END IF;


     -- сохранили
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
                                                        , inSummAvanceRecalc   := inSummAvance
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
            FROM Object_Personal_View AS View_Personal
            WHERE View_Personal.PersonalId = vbPersonalId
           ) AS tmpPersonal
           LEFT JOIN gpSelect_MovementItem_PersonalService (inMovementId, FALSE, FALSE, inSession) AS gpSelect
                                                                                                   ON gpSelect.PersonalId = tmpPersonal.PersonalId
                                                                                                  AND gpSelect.PositionId = vbPositionId
                                                                                                  AND gpSelect.UnitId = vbUnitId
      LIMIT 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  
 17.01.23         *
*/

-- тест
--
