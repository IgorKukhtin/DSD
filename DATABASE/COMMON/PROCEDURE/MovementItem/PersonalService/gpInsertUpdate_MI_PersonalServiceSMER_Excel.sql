-- Function: gpInsertUpdate_MI_PersonalServiceSMER_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalServiceSMER_Excel (Integer, TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PersonalServiceSMER_Excel(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inINN                 TVarChar  , -- ИНН
    IN inFIO                 TVarChar  , -- ФИО
    IN inSummMinusExtRecalc     TFloat    , -- Удержания сторон. юр.л. (ввод)
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService());
     vbUserId := lpGetUserBySession (inSession);

     RAISE EXCEPTION 'Сотрудник <%> не найден с ИНН = <%> и суммой <%> .', inFIO, inINN, inSummMinusExtRecalc;

     -- замена
     inINN:= TRIM (inINN);

     IF COALESCE (inMovementId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Документ не сохранен';
     END IF;

     -- проверка
     IF inINN = '' AND inFIO = '' AND COALESCE (inSummMinusExtRecalc, 0) = 0
     THEN
         RETURN;
     END IF;
     -- проверка
     IF inINN = '-' AND inFIO = '-' AND COALESCE (inSummMinusExtRecalc, 0) = 0
     THEN
         RETURN;
     END IF;

     -- проверка
     IF COALESCE (inINN, '') = ''
     THEN
         RAISE EXCEPTION 'Ошибка.У <%> не заполненное поле <ИНН> в файле Excel для суммы <%> <%>.', inFIO, inSummMinusExtRecalc;
     END IF;


     -- поиск сотрудника
     vbPersonalId:= (WITH tmpPersonal AS (SELECT ObjectLink_Personal_Member.ObjectId AS PersonalId
                                               , ROW_NUMBER() OVER (PARTITION BY ObjectString_INN.ValueData
                                                                    -- сортировкой определяется приоритет для выбора, т.к. выбираем с Ord = 1
                                                                    ORDER BY CASE WHEN COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN 0 ELSE 1 END
                                                                           , CASE WHEN ObjectLink_Personal_PersonalServiceList.ChildObjectId > 0 THEN 0 ELSE 1 END
                                                                           , CASE WHEN ObjectBoolean_Official.ValueData = TRUE THEN 0 ELSE 1 END
                                                                           , CASE WHEN ObjectBoolean_Main.ValueData = TRUE THEN 0 ELSE 1 END
                                                                           , ObjectLink_Personal_Member.ObjectId
                                                                   ) AS Ord
                                          FROM ObjectString AS ObjectString_INN
                                               INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                                     ON ObjectLink_Personal_Member.ChildObjectId = ObjectString_INN.ObjectId
                                                                    AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                                               INNER JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Personal_Member.ObjectId
                                                                                   AND Object_Personal.isErased = FALSE
                                               LEFT JOIN ObjectDate AS ObjectDate_DateOut
                                                                    ON ObjectDate_DateOut.ObjectId = Object_Personal.Id
                                                                   AND ObjectDate_DateOut.DescId   = zc_ObjectDate_Personal_Out()          
                                               LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                                    ON ObjectLink_Personal_PersonalServiceList.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                                   AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
                                               LEFT JOIN ObjectBoolean AS ObjectBoolean_Official
                                                                       ON ObjectBoolean_Official.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                                      AND ObjectBoolean_Official.DescId   = zc_ObjectBoolean_Member_Official()
                                               LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                                                       ON ObjectBoolean_Main.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                                      AND ObjectBoolean_Main.DescId   = zc_ObjectBoolean_Personal_Main()
                                          WHERE TRIM (ObjectString_INN.ValueData) = inINN
                                            AND ObjectString_INN.DescId = zc_ObjectString_Member_INN()
                                         )
                     -- Проверка
                     SELECT tmpPersonal.PersonalId FROM tmpPersonal WHERE tmpPersonal.Ord = 1
                    );

     -- проверка
     IF COALESCE (vbPersonalId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Сотрудник <%> не найден с ИНН = <%> и суммой <%> .', inFIO, inINN, inSummMinusExtRecalc;
     END IF;

     -- сохранили
     PERFORM lpInsertUpdate_MovementItem_PersonalService (ioId                 := gpSelect.Id
                                                        , inMovementId         := inMovementId
                                                        , inPersonalId         := tmpPersonal.PersonalId
                                                        , inIsMain             := COALESCE (gpSelect.IsMain, tmpPersonal.IsMain)
                                                        , inSummService        := COALESCE (gpSelect.SummService, 0)
                                                        , inSummCardRecalc     := COALESCE (gpSelect.SummCardRecalc, 0)
                                                        , inSummCardSecondRecalc:= 0
                                                        , inSummCardSecondCash := 0
                                                        , inSummNalogRecalc    := COALESCE (gpSelect.SummNalogRecalc, 0)
                                                        , inSummNalogRetRecalc := 0
                                                        , inSummMinus          := COALESCE (gpSelect.SummMinus, 0)
                                                        , inSummAdd            := COALESCE (gpSelect.SummAdd, 0)
                                                        , inSummAddOthRecalc   := COALESCE (gpSelect.SummAddOthRecalc, 0)
                                                        , inSummHoliday        := COALESCE (gpSelect.SummHoliday, 0)
                                                        , inSummSocialIn       := COALESCE (gpSelect.SummSocialIn, 0)
                                                        , inSummSocialAdd      := COALESCE (gpSelect.SummSocialAdd, 0)
                                                        , inSummChildRecalc    := COALESCE (gpSelect.SummChildRecalc, 0)
                                                        , inSummMinusExtRecalc := COALESCE (inSummMinusExtRecalc, 0)
                                                        , inSummFine           := COALESCE (gpSelect.SummFine, 0)
                                                        , inSummFineOthRecalc  := COALESCE (gpSelect.SummFineOthRecalc, 0)
                                                        , inSummHosp           := COALESCE (gpSelect.SummHosp, 0)
                                                        , inSummHospOthRecalc  := COALESCE (gpSelect.SummHospOthRecalc, 0)
                                                        , inSummCompensationRecalc := COALESCE (gpSelect.SummCompensationRecalc, 0)
                                                        , inSummAuditAdd       := COALESCE (gpSelect.SummAuditAdd,0)
                                                        , inSummHouseAdd       := COALESCE (gpSelect.SummHouseAdd,0) 
                                                        , inSummAvanceRecalc   := COALESCE (gpSelect.SummAvanceRecalc,0)  ::TFloat
                                                        , inNumber             := COALESCE (gpSelect.Number, '')
                                                        , inComment            := COALESCE (gpSelect.Comment, '')
                                                        , inInfoMoneyId        := COALESCE (gpSelect.InfoMoneyId, zc_Enum_InfoMoney_60101()) -- 60101 Заработная плата + Заработная плата
                                                        , inUnitId             := tmpPersonal.UnitId
                                                        , inPositionId         := tmpPersonal.PositionId
                                                        , inMemberId               := gpSelect.MemberId                                     -- Физ лицо (кому начисляют алименты)
                                                        , inPersonalServiceListId  := ObjectLink_Personal_PersonalServiceList.ChildObjectId -- на которую происходит распределение Карточки БН
                                                        , inFineSubjectId          := COALESCE (gpSelect.FineSubjectId,0)     ::Integer
                                                        , inUnitFineSubjectId      := COALESCE (gpSelect.UnitFineSubjectId,0) ::Integer
                                                        , inUserId             := vbUserId
                                                         )
      FROM (SELECT View_Personal.PersonalId
                 , View_Personal.UnitId
                 , View_Personal.PositionId
                 , View_Personal.IsMain
            FROM Object_Personal_View AS View_Personal
            WHERE View_Personal.PersonalId = vbPersonalId
           ) AS tmpPersonal
           LEFT JOIN gpSelect_MovementItem_PersonalService (inMovementId, FALSE, FALSE, inSession) AS gpSelect ON gpSelect.PersonalId = tmpPersonal.PersonalId
           LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                ON ObjectLink_Personal_PersonalServiceList.ObjectId = tmpPersonal.PersonalId
                               AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
      LIMIT 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.06.22         *
*/

-- тест
--