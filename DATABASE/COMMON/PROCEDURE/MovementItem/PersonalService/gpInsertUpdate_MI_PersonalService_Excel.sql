-- Function: gpInsertUpdate_MI_PersonalService_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Excel (Integer, TVarChar, TVarChar, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PersonalService_Excel(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inINN                 TVarChar  , -- ИНН
    IN inFIO                 TVarChar  , -- ФИО
    IN inSummNalogRecalc     TFloat    , -- Сумма Налоги - удержания с ЗП для распределения
    IN inSummCardRecalc1     TFloat    , -- Сумма1 на карточку (БН) для распределения
    IN inSummCardRecalc2     TFloat    , -- Сумма2 на карточку (БН) для распределения
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

     -- замена
     inINN:= TRIM (inINN);

     IF COALESCE (inMovementId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Документ не сохранен';
     END IF;

     -- проверка
     IF inINN = '' AND inFIO = '' AND COALESCE (inSummNalogRecalc, 0) = 0 AND COALESCE (inSummCardRecalc1, 0) = 0 AND COALESCE (inSummCardRecalc2, 0) = 0
     THEN
         RETURN;
     END IF;
     -- проверка
     IF inINN = '-' AND inFIO = '-' AND COALESCE (inSummNalogRecalc, 0) = 0 AND COALESCE (inSummCardRecalc1, 0) = 0 AND COALESCE (inSummCardRecalc2, 0) = 0
     THEN
         RETURN;
     END IF;

     -- проверка
     IF COALESCE (inINN, '') = ''
     THEN
         RAISE EXCEPTION 'Ошибка.У <%> не заполненное поле <ИНН> в файле Excel для сумм <%> <%> <%>.', inFIO, inSummCardRecalc1, inSummCardRecalc2, inSummNalogRecalc;
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
         RAISE EXCEPTION 'Ошибка.Сотрудник <%> не найден с ИНН = <%> и суммы <%> <%> <%>.', inFIO, inINN, inSummCardRecalc1, inSummCardRecalc2, inSummNalogRecalc;
     END IF;

     -- сохранили
     PERFORM lpInsertUpdate_MovementItem_PersonalService (ioId                 := gpSelect.Id
                                                        , inMovementId         := inMovementId
                                                        , inPersonalId         := gpSelect.PersonalId
                                                        , inIsMain             := gpSelect.IsMain
                                                        , inSummService        := COALESCE (gpSelect.SummService, 0)
                                                        , inSummCardRecalc     := COALESCE (inSummCardRecalc1, 0) + COALESCE (inSummCardRecalc2, 0)
                                                        , inSummCardSecondRecalc:= 0
                                                        , inSummCardSecondCash := 0
                                                        , inSummNalogRecalc    := COALESCE (inSummNalogRecalc, 0)
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
                                                        , inSummAvanceRecalc   := COALESCE (gpSelect.SummAvanceRecalc,0) ::TFloat
                                                        , inNumber             := COALESCE (gpSelect.Number, '')
                                                        , inComment            := COALESCE (gpSelect.Comment, '')
                                                        , inInfoMoneyId        := gpSelect.InfoMoneyId -- 60101 Заработная плата + Заработная плата
                                                        , inUnitId             := gpSelect.UnitId
                                                        , inPositionId         := gpSelect.PositionId
                                                        , inMemberId               := gpSelect.MemberId                                     -- Физ лицо (кому начисляют алименты)
                                                        , inPersonalServiceListId  := gpSelect.PersonalServiceListId -- на которую происходит распределение Карточки БН
                                                        , inFineSubjectId          := COALESCE (gpSelect.FineSubjectId,0)     ::Integer
                                                        , inUnitFineSubjectId      := COALESCE (gpSelect.UnitFineSubjectId,0) ::Integer
                                                        , inUserId             := vbUserId
                                                         ) 

       FROM (WITH
             tmpMI AS (SELECT MovementItem.*
                       FROM MovementItem
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId     = zc_MI_Master()
                         AND MovementItem.isErased   = FALSE
                         AND MovementItem.ObjectId   = bPersonalId
                       LIMIT 1)
                       
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
      
           , MIBoolean AS (SELECT *
                           FROM MovementItemBoolean
                           WHERE MovementItemBoolean.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI)
                             AND MovementItemBoolean.DescId IN (zc_MIBoolean_Main()
                                                              ) 
                          )
           , MILO AS (SELECT *
                      FROM MovementItemLinkObject
                      WHERE MovementItemLinkObject.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI)
                        AND MovementItemLinkObject.DescId IN (zc_MILinkObject_InfoMoney() 
                                                            , zc_MILinkObject_FineSubject()
                                                            , zc_MILinkObject_UnitFineSubject()
                                                            ) 
                     )
           , tmpPersonal AS (SELECT View_Personal.PersonalId
                                  , View_Personal.MemberId
                                  , View_Personal.UnitId
                                  , View_Personal.PositionId
                                  , View_Personal.IsMain
                             FROM Object_Personal_View AS View_Personal
                             WHERE View_Personal.PersonalId = vbPersonalId
                            )

          SELECT tmpMI.Id
               , tmpPersonal.PersonalId
               , COALESCE (MIBoolean_Main.ValueData, tmpPersonal.IsMain) ::Boolean AS IsMain
               , COALESCE (MIFloat_SummService.ValueData, 0)             ::TFloat  AS SummService
               , COALESCE (MIFloat_SummMinus.ValueData, 0)               ::TFloat  AS SummMinus
               , COALESCE (MIFloat_SummAdd.ValueData, 0)                 ::TFloat  AS SummAdd           
               , COALESCE (MIFloat_SummAddOthRecalc.ValueData, 0)        ::TFloat  AS SummAddOthRecalc
               , COALESCE (MIFloat_SummHoliday.ValueData, 0)             ::TFloat  AS SummHoliday
               , COALESCE (MIFloat_SummSocialIn.ValueData, 0)            ::TFloat  AS SummSocialIn
               , COALESCE (MIFloat_SummSocialAdd.ValueData, 0)           ::TFloat  AS SummSocialAdd            
               , COALESCE (MIFloat_SummChildRecalc.ValueData, 0)         ::TFloat  AS SummChildRecalc
               , COALESCE (MIFloat_SummMinusExtRecalc.ValueData, 0)      ::TFloat  AS SummMinusExtRecalc
               , COALESCE (MIFloat_SummFine.ValueData, 0)                ::TFloat  AS SummFine
               , COALESCE (MIFloat_SummFineOthRecalc.ValueData, 0)       ::TFloat  AS SummFineOthRecalc
               , COALESCE (MIFloat_SummHosp.ValueData, 0)                ::TFloat  AS SummHosp
               , COALESCE (MIFloat_SummHospOthRecalc.ValueData, 0)       ::TFloat  AS SummHospOthRecalc
               , COALESCE (MIFloat_SummCompensationRecalc.ValueData, 0)  ::TFloat  AS SummCompensationRecalc
               , COALESCE (MIFloat_SummAuditAdd.ValueData, 0)            ::TFloat  AS SummAuditAdd
               , COALESCE (MIFloat_SummHouseAdd.ValueData, 0)            ::TFloat  AS SummHouseAdd 
               , COALESCE (MIFloat_SummAvanceRecalc.ValueData, 0)        ::TFloat  AS SummAvanceRecalc 
            
               , COALESCE (MIString_Number.ValueData, '')               ::TVarChar AS Number
               , COALESCE (MIString_Comment.ValueData, '')              ::TVarChar AS Comment
               , COALESCE (MILinkObject_InfoMoney.ObjectId, zc_Enum_InfoMoney_60101()) AS InfoMoneyId

               , tmpPersonal.UnitId
               , tmpPersonal.PositionId
               , tmpPersonal.MemberId
               , ObjectLink_Personal_PersonalServiceList.ChildObjectId             AS PersonalServiceListId
               , COALESCE (MILinkObject_FineSubject.ObjectId,0)         ::Integer  AS FineSubjectId
               , COALESCE (MILinkObject_UnitFineSubject.ObjectId,0)     ::Integer  AS UnitFineSubjectId
          FROM tmpPersonal 
               LEFT JOIN tmpMI ON tmpMI.ObjectId = tmpPersonal.PersonalId

               LEFT JOIN MILO AS MILinkObject_FineSubject
                              ON MILinkObject_FineSubject.MovementItemId = tmpMI.Id
                             AND MILinkObject_FineSubject.DescId = zc_MILinkObject_FineSubject()

               LEFT JOIN MILO AS MILinkObject_UnitFineSubject
                              ON MILinkObject_UnitFineSubject.MovementItemId = tmpMI.Id
                             AND MILinkObject_UnitFineSubject.DescId = zc_MILinkObject_UnitFineSubject()

               LEFT JOIN MILO AS MILinkObject_InfoMoney
                              ON MILinkObject_InfoMoney.MovementItemId = tmpMI.Id
                             AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()

               LEFT JOIN MIBoolean AS MIBoolean_Main
                                   ON MIBoolean_Main.MovementItemId = tmpMI.Id
                                  AND MIBoolean_Main.DescId = zc_MIBoolean_Main()

               LEFT JOIN MIString AS MIString_Comment
                                  ON MIString_Comment.MovementItemId = tmpMI.Id
                                 AND MIString_Comment.DescId = zc_MIString_Comment()

               LEFT JOIN MIString AS MIString_Number
                                  ON MIString_Number.MovementItemId = tmpMI.Id
                                 AND MIString_Number.DescId = zc_MIString_Number()

               LEFT JOIN MIFloat AS MIFloat_SummAvanceRecalc
                                 ON MIFloat_SummAvanceRecalc.MovementItemId = tmpMI.Id
                                AND MIFloat_SummAvanceRecalc.DescId = zc_MIFloat_SummAvanceRecalc()
               LEFT JOIN MIFloat AS MIFloat_SummService
                                 ON MIFloat_SummService.MovementItemId = tmpMI.Id
                                AND MIFloat_SummService.DescId = zc_MIFloat_SummService()                             
               LEFT JOIN MIFloat AS MIFloat_SummMinus
                                 ON MIFloat_SummMinus.MovementItemId = tmpMI.Id
                                AND MIFloat_SummMinus.DescId = zc_MIFloat_SummMinus()
               LEFT JOIN MIFloat AS MIFloat_SummFine
                                 ON MIFloat_SummFine.MovementItemId = tmpMI.Id
                                AND MIFloat_SummFine.DescId = zc_MIFloat_SummFine()
               LEFT JOIN MIFloat AS MIFloat_SummFineOthRecalc
                                 ON MIFloat_SummFineOthRecalc.MovementItemId = tmpMI.Id
                                AND MIFloat_SummFineOthRecalc.DescId = zc_MIFloat_SummFineOthRecalc()
               LEFT JOIN MIFloat AS MIFloat_SummAdd
                                 ON MIFloat_SummAdd.MovementItemId = tmpMI.Id
                                AND MIFloat_SummAdd.DescId = zc_MIFloat_SummAdd()
               LEFT JOIN MIFloat AS MIFloat_SummAuditAdd
                                 ON MIFloat_SummAuditAdd.MovementItemId = tmpMI.Id
                                AND MIFloat_SummAuditAdd.DescId = zc_MIFloat_SummAuditAdd()
               LEFT JOIN MIFloat AS MIFloat_SummHoliday
                                 ON MIFloat_SummHoliday.MovementItemId = tmpMI.Id
                                AND MIFloat_SummHoliday.DescId = zc_MIFloat_SummHoliday()
               LEFT JOIN MIFloat AS MIFloat_SummHosp
                                 ON MIFloat_SummHosp.MovementItemId = tmpMI.Id
                                AND MIFloat_SummHosp.DescId = zc_MIFloat_SummHosp()
               LEFT JOIN MIFloat AS MIFloat_SummHospOthRecalc
                                 ON MIFloat_SummHospOthRecalc.MovementItemId = tmpMI.Id
                                AND MIFloat_SummHospOthRecalc.DescId = zc_MIFloat_SummHospOthRecalc()
               LEFT JOIN MIFloat AS MIFloat_SummSocialIn
                                 ON MIFloat_SummSocialIn.MovementItemId = tmpMI.Id
                                AND MIFloat_SummSocialIn.DescId = zc_MIFloat_SummSocialIn()
               LEFT JOIN MIFloat AS MIFloat_SummSocialAdd
                                 ON MIFloat_SummSocialAdd.MovementItemId = tmpMI.Id
                                AND MIFloat_SummSocialAdd.DescId = zc_MIFloat_SummSocialAdd()
               LEFT JOIN MIFloat AS MIFloat_SummChildRecalc
                                 ON MIFloat_SummChildRecalc.MovementItemId = tmpMI.Id
                                AND MIFloat_SummChildRecalc.DescId = zc_MIFloat_SummChildRecalc()
               LEFT JOIN MIFloat AS MIFloat_SummMinusExtRecalc
                                 ON MIFloat_SummMinusExtRecalc.MovementItemId = tmpMI.Id
                                AND MIFloat_SummMinusExtRecalc.DescId = zc_MIFloat_SummMinusExtRecalc()
               LEFT JOIN MIFloat AS MIFloat_SummAddOthRecalc
                                 ON MIFloat_SummAddOthRecalc.MovementItemId = tmpMI.Id
                                AND MIFloat_SummAddOthRecalc.DescId = zc_MIFloat_SummAddOthRecalc()
               LEFT JOIN MIFloat AS MIFloat_SummHouseAdd
                                 ON MIFloat_SummHouseAdd.MovementItemId = tmpMI.Id
                                AND MIFloat_SummHouseAdd.DescId = zc_MIFloat_SummHouseAdd()
               LEFT JOIN MIFloat AS MIFloat_SummCompensationRecalc
                                 ON MIFloat_SummCompensationRecalc.MovementItemId = tmpMI.Id
                                AND MIFloat_SummCompensationRecalc.DescId = zc_MIFloat_SummCompensationRecalc()
   
               LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                    ON ObjectLink_Personal_PersonalServiceList.ObjectId = tmpPersonal.PersonalId
                                   AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
            ) AS gpSelect;

     IF vbUserId = 9457
     THEN
          RAISE EXCEPTION 'Test. Ок';
     END IF; 
 
 /*     FROM (SELECT View_Personal.PersonalId
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
    */
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.06.25         * оптимизация
 29.07.19         *
 05.01.18         *
 20.06.17         * add inSummCardSecondCash 
 28.01.17                                        *
 18.01.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_PersonalService_Excel(inMovementId :=31408142 , inINN := '2784316034', inSum1 := 15 ::TFloat, inSum2 := 45 ::TFloat , inSession :='3':: TVarChar)
-- SELECT * FROM gpInsertUpdate_MI_PersonalService_Excel(inMovementId := 31430850, inINN := '2784316034', inFIO:= '', inSummNalogRecalc := 15 ::TFloat, inSummCardRecalc1 := 45 ::TFloat, inSummCardRecalc2 := 45 ::TFloat, inSession :='9457':: TVarChar)

