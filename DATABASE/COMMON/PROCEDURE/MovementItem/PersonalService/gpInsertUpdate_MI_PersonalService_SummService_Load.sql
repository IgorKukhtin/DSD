-- Function: gpInsertUpdate_MI_PersonalService_SummService_Load()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_SummService_Load (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_SummService_Load (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PersonalService_SummService_Load(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inPersonalCode        Integer   , --Integer
    IN inFIO                 TVarChar  , -- ФИО
    IN inPositionName        TVarChar  , --
    IN inFineSubjectName     TVarChar  , -- Вид нарушений
    IN inUnitFineSubjectName TVarChar  , -- Кем налагается взыскание
    IN inComment             TVarChar  , -- примечание
    IN inSummService         TFloat    , -- Начисления
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
   DECLARE vbPositionId Integer;
   DECLARE vbFineSubjectId Integer;
   DECLARE vbUnitFineSubjectId Integer;
   DECLARE vbCodePersonal Integer;
   DECLARE vbMemberId Integer;
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
     IF COALESCE (inPersonalCode, 0) = 0 AND inFIO = '' AND COALESCE (inSummService, 0) = 0
     THEN
         RETURN;
     END IF;
     -- проверка
     IF COALESCE (inPersonalCode, 0) = 0 AND inFIO = '-' AND COALESCE (inSummService, 0) = 0
     THEN
         RETURN;
     END IF;

     -- проверка
     IF COALESCE (inPersonalCode, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.У <%> не заполненное поле <Код> в файле Excel для суммы <%> <%>.', inFIO, inSummService, inFineSubjectName;
     END IF;

     -- проверка
     IF COALESCE (inPositionName, '') = ''
     THEN
         RAISE EXCEPTION 'Ошибка.У <%> не заполненное поле <Должность> в файле Excel для суммы <%> <%>.', inFIO, inSummService, inFineSubjectName;
     END IF;


     -- если можно сразу
     IF EXISTS (SELECT 1
                FROM Object
                     INNER JOIN ObjectLink AS ObjectLink_Personal_Position
                                           ON ObjectLink_Personal_Position.ObjectId = Object.Id
                                          AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                     INNER JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Personal_Position.ChildObjectId
                                                         AND TRIM (Object_Position.ValueData) ILIKE TRIM (inPositionName)
                WHERE Object.DescId     = zc_Object_Personal()
                  AND Object.ObjectCode = inPersonalCode
                  AND Object.isErased   = FALSE
               )
     THEN
         -- поиск сотрудника по коду и должности
         vbPersonalId := (SELECT MAX (Object.Id)
                          FROM Object
                               INNER JOIN ObjectLink AS ObjectLink_Personal_Position
                                                     ON ObjectLink_Personal_Position.ObjectId = Object.Id
                                                    AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                               INNER JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Personal_Position.ChildObjectId
                                                                   AND TRIM (Object_Position.ValueData) ILIKE TRIM (inPositionName)
                          WHERE Object.DescId     = zc_Object_Personal()
                            AND Object.ObjectCode = inPersonalCode
                            AND Object.isErased   = FALSE
                         );
     ELSE
         -- проверка должности
         IF 1 < (SELECT COUNT(*)
                 FROM Object
                 WHERE Object.DescId = zc_Object_Position() AND TRIM (Object.ValueData) LIKE TRIM (inPositionName) AND Object.isErased = FALSE
                )
                AND 1=1
         THEN
             RAISE EXCEPTION 'Ошибка.У <%> должность <%> не уникальна в справочнике должностей.', inFIO, inPositionName;
         END IF;

         -- поиск должности
         vbPositionId := (SELECT MAX (Object.Id) FROM Object
                          WHERE Object.DescId = zc_Object_Position()
                            AND Object.isErased = FALSE
                            AND REPLACE(REPLACE(TRIM (Object.ValueData),'''',''),'`','') LIKE REPLACE(REPLACE(TRIM (inPositionName),'''',''),'`',''));

         -- проверка если не нашли должность
         IF COALESCE (vbPositionId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.У <%> не найдена <Должность> = <%> в справочнике.', inFIO, inPositionName;
         END IF;


         -- проверка сотрудника
         IF 1 < (SELECT COUNT(*)
                 FROM Object
                      INNER JOIN ObjectLink AS ObjectLink_Personal_Position
                                            ON ObjectLink_Personal_Position.ObjectId      = Object.Id
                                           AND ObjectLink_Personal_Position.DescId        = zc_ObjectLink_Personal_Position()
                                           AND ObjectLink_Personal_Position.ChildObjectId = vbPositionId
                 WHERE Object.DescId = zc_Object_Personal() AND Object.ObjectCode = inPersonalCode AND Object.isErased = FALSE
                )
                AND 1=0
         THEN
             RAISE EXCEPTION 'Ошибка.Код сотрудника <%> и должность <%> не уникальны в справочнике сотрудников.', inPersonalCode, lfGet_Object_ValueData_sh (vbPositionId);
         END IF;

         -- поиск сотрудника по коду и должности
         vbPersonalId := (SELECT MAX (Object.Id)
                          FROM Object
                               INNER JOIN ObjectLink AS ObjectLink_Personal_Position
                                                     ON ObjectLink_Personal_Position.ObjectId = Object.Id
                                                    AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                                    AND ObjectLink_Personal_Position.ChildObjectId = vbPositionId
                          WHERE Object.DescId     = zc_Object_Personal()
                            AND Object.ObjectCode = inPersonalCode
                            AND Object.isErased   = FALSE
                         );
         -- если не нашли по должности и коду, найти физ лицо, а по нему сотрудника с основным местом работы
         IF COALESCE (vbPersonalId,0) = 0
         THEN
             vbMemberId := (SELECT Object.Id
                            FROM Object
                            WHERE Object.DescId = zc_Object_Member()
                              AND Object.isErased = FALSE
                              AND REPLACE(TRIM (Object.ValueData),'''','') ILIKE REPLACE (TRIM (inFIO),'''','')
                            );
             --
             vbPersonalId := (SELECT lfSelect.PersonalId
                              FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                              WHERE lfSelect.Ord = 1
                                AND lfSelect.MemberId = vbMemberId
                              );
         END IF;

     END IF;


     -- проверка
     IF COALESCE (vbPersonalId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Сотрудник <%> не найден с кодом = <%> и должность = <%>(%) и суммой <%> .', inFIO, inPersonalCode, inPositionName, vbPositionId, inSummService;
     END IF;

     --находим Вид начисления
     vbFineSubjectId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_FineSubject() AND TRIM (Object.ValueData) ILIKE TRIM (inFineSubjectName));
     IF COALESCE (vbFineSubjectId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Вид нарушений <%> не найден для Сотрудника <%> с кодом <%> и суммой <%> .', inFineSubjectName, inFIO, inPersonalCode, inSummService;
     END IF;

     --находим
     vbUnitFineSubjectId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Unit() AND TRIM (Object.ValueData) ILIKE TRIM (inUnitFineSubjectName));
     IF COALESCE (vbUnitFineSubjectId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Подразделение- Кем налагается взыскание <%> не найдено для Сотрудника <%> с кодом <%> и суммой <%> .', inUnitFineSubjectName, inFIO, inPersonalCode, inSummService;
     END IF;


     -- сохранили
     PERFORM lpInsertUpdate_MovementItem_PersonalService (ioId                 := COALESCE (gpSelect.Id,0)
                                                        , inMovementId         := inMovementId
                                                        , inPersonalId         := tmpPersonal.PersonalId
                                                        , inIsMain             := COALESCE (gpSelect.IsMain, tmpPersonal.IsMain)
                                                        , inSummService        := inSummService
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
                                                        , inSummAvanceRecalc   := COALESCE (gpSelect.SummAvanceRecalc,0)::TFloat
                                                        , inNumber             := COALESCE (gpSelect.Number, '')
                                                        , inComment            := inComment ::TVarChar
                                                        , inInfoMoneyId        := COALESCE (gpSelect.InfoMoneyId, zc_Enum_InfoMoney_60101()) -- 60101 Заработная плата + Заработная плата
                                                        , inUnitId             := tmpPersonal.UnitId
                                                        , inPositionId         := tmpPersonal.PositionId
                                                        , inMemberId               := gpSelect.MemberId                                     -- Физ лицо (кому начисляют алименты)
                                                        , inPersonalServiceListId  := gpSelect.PersonalServiceListId
                                                        , inFineSubjectId          := vbFineSubjectId     ::Integer
                                                        , inUnitFineSubjectId      := vbUnitFineSubjectId ::Integer
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
                                                                                                  AND gpSelect.FineSubjectId = vbFineSubjectId
                                                                                                  AND gpSelect.UnitFineSubjectId = vbUnitFineSubjectId
                                                                                                  AND COALESCE (gpSelect.Comment, '') = COALESCE (inComment, '')
      LIMIT 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.01.23         *
 30.12.22         *
*/

-- тест
--