-- Function: gpInsertUpdate_MI_PersonalService_byMemberMinus()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_byMemberMinus (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PersonalService_byMemberMinus(
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PersonalService());

     

     -- Выбираем данные из справочника MemberMinus
     CREATE TEMP TABLE tmpMemberMinus ON COMMIT DROP AS 
            (WITH
                 tmpPersonal AS (SELECT lfSelect.MemberId
                                      , lfSelect.PersonalId
                                      , lfSelect.PositionId
                                      , lfSelect.isMain
                                      , lfSelect.UnitId
                                 FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                                 WHERE lfSelect.Ord = 1
                                )

             SELECT ObjectLink_MemberMinus_From.ChildObjectId AS MemberId
                  , tmpPersonal.PersonalId
                  , tmpPersonal.PositionId
                  , tmpPersonal.isMain
                  , tmpPersonal.UnitId
                  , ObjectLink_Personal_PersonalServiceList.ChildObjectId AS PersonalServiceListId
                  , SUM (CASE WHEN COALESCE (ObjectBoolean_Child.ValueData, FALSE) = FALSE THEN COALESCE (ObjectFloat_Summ.ValueData, 0) ELSE 0 END) :: TFloat AS SummMinusExtRecalc
                  , SUM (CASE WHEN COALESCE (ObjectBoolean_Child.ValueData, FALSE) = TRUE  THEN COALESCE (ObjectFloat_Summ.ValueData, 0) ELSE 0 END) :: TFloat AS SummChildRecalc

                  --, SUM (CASE WHEN Object_To.DescId = zc_Object_Juridical() THEN COALESCE (ObjectFloat_Summ.ValueData, 0) ELSE 0 END) :: TFloat AS SummMinusExtRecalc
                  --, SUM (CASE WHEN Object_To.DescId = zc_Object_Juridical() THEN 0 ELSE COALESCE (ObjectFloat_Summ.ValueData, 0) END) :: TFloat AS SummChildRecalc
             FROM Object AS Object_MemberMinus
                   LEFT JOIN ObjectLink AS ObjectLink_MemberMinus_From
                                        ON ObjectLink_MemberMinus_From.ObjectId = Object_MemberMinus.Id
                                       AND ObjectLink_MemberMinus_From.DescId = zc_ObjectLink_MemberMinus_From()
         
                   LEFT JOIN ObjectLink AS ObjectLink_MemberMinus_To
                                        ON ObjectLink_MemberMinus_To.ObjectId = Object_MemberMinus.Id
                                       AND ObjectLink_MemberMinus_To.DescId = zc_ObjectLink_MemberMinus_To()
                   --LEFT JOIN Object AS Object_To ON Object_To.Id = ObjectLink_MemberMinus_To.ChildObjectId
                   
                   LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_MemberMinus_From.ChildObjectId

                   LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                        ON ObjectLink_Personal_PersonalServiceList.ObjectId = tmpPersonal.PersonalId
                                       AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()

                   LEFT JOIN ObjectFloat AS ObjectFloat_Summ
                                         ON ObjectFloat_Summ.ObjectId = Object_MemberMinus.Id
                                        AND ObjectFloat_Summ.DescId = zc_ObjectFloat_MemberMinus_Summ()

                   LEFT JOIN ObjectBoolean AS ObjectBoolean_Child
                                           ON ObjectBoolean_Child.ObjectId = Object_MemberMinus.Id
                                          AND ObjectBoolean_Child.DescId = zc_ObjectBoolean_MemberMinus_Child()

             WHERE Object_MemberMinus.DescId = zc_Object_MemberMinus()
               AND Object_MemberMinus.isErased = FALSE
             GROUP BY ObjectLink_MemberMinus_From.ChildObjectId
                    --, ObjectLink_MemberMinus_To.ChildObjectId
                    , tmpPersonal.PersonalId
                    , tmpPersonal.PositionId
                    , tmpPersonal.isMain
                    , tmpPersonal.UnitId
                    , ObjectLink_Personal_PersonalServiceList.ChildObjectId
              );
     -- Выбираем сохраненные данные из документа
     CREATE TEMP TABLE tmpMI ON COMMIT DROP AS
            (SELECT tmp.*
             FROM gpSelect_MovementItem_PersonalService(inMovementId, FALSE, FALSE, inSession) AS tmp
            );
     
     -- добавиляем новые строки и обновляем существующие
     PERFORM lpInsertUpdate_MovementItem_PersonalService (ioId                    := COALESCE (tmpMI.Id,0)                                  ::Integer
                                                        , inMovementId            := inMovementId                                           ::Integer
                                                        , inPersonalId            := tmpMemberMinus.PersonalId                              ::Integer
                                                        , inIsMain                := COALESCE (tmpMemberMinus.IsMain, tmpMI.isMain)         ::Boolean
                                                        , inSummService           := 0                                                      ::TFloat
                                                        , inSummCardRecalc        := COALESCE (tmpMI.SummCardRecalc,0)                      ::TFloat
                                                        , inSummCardSecondRecalc  := COALESCE (tmpMI.SummCardSecondRecalc,0)                ::TFloat
                                                        , inSummCardSecondCash    := COALESCE (tmpMI.SummCardSecondCash,0)                  ::TFloat
                                                        , inSummNalogRecalc       := COALESCE (tmpMI.SummNalogRecalc,0)                     ::TFloat
                                                        , inSummNalogRetRecalc    := 0                                                      ::TFloat
                                                        , inSummMinus             := COALESCE (tmpMI.SummMinus,0)                           ::TFloat
                                                        , inSummAdd               := COALESCE (tmpMI.SummAdd,0)                             ::TFloat
                                                        , inSummAddOthRecalc      := COALESCE (tmpMI.SummAddOthRecalc,0)                    ::TFloat
                                                        , inSummHoliday           := COALESCE (tmpMI.SummHoliday,0)                         ::TFloat
                                                        , inSummSocialIn          := COALESCE (tmpMI.SummSocialIn,0)                        ::TFloat
                                                        , inSummSocialAdd         := COALESCE (tmpMI.SummSocialAdd,0)                       ::TFloat
                                                        , inSummChildRecalc       := COALESCE (tmpMemberMinus.SummChildRecalc,0)            ::TFloat
                                                        , inSummMinusExtRecalc    := COALESCE (tmpMemberMinus.SummMinusExtRecalc,0)         ::TFloat
                                                        , inSummFine              := COALESCE (tmpMI.SummFine,0)                            ::TFloat
                                                        , inSummFineOthRecalc     := COALESCE (tmpMI.SummFineOthRecalc,0)                   ::TFloat
                                                        , inSummHosp              := COALESCE (tmpMI.SummHosp,0)                            ::TFloat
                                                        , inSummHospOthRecalc     := COALESCE (tmpMI.SummHospOthRecalc,0)                   ::TFloat
                                                        , inSummCompensationRecalc:= COALESCE (tmpMI.SummCompensationRecalc,0)              ::TFloat
                                                        , inSummAuditAdd          := COALESCE (tmpMI.SummAuditAdd,0)                        ::TFloat
                                                        , inComment               := COALESCE (tmpMI.Comment, '')                           ::TVarChar
                                                        , inInfoMoneyId           := zc_Enum_InfoMoney_60101()                              ::Integer
                                                        , inUnitId                := COALESCE (tmpMemberMinus.UnitId, tmpMI.UnitId)         ::Integer
                                                        , inPositionId            := COALESCE (tmpMemberMinus.PositionId, tmpMI.PositionId) ::Integer
                                                        , inMemberId              := 0                                                      ::Integer    --COALESCE (tmpMemberMinus.MemberId, tmpMI.MemberId) 
                                                        , inPersonalServiceListId := COALESCE (tmpMemberMinus.PersonalServiceListId, tmpMI.PersonalServiceListId) :: Integer
                                                        , inFineSubjectId         := COALESCE (tmpMI.FineSubjectId,0)                       ::Integer
                                                        , inUnitFineSubjectId     := COALESCE (tmpMI.UnitFineSubjectId,0)                   ::Integer
                                                        , inUserId                := vbUserId
                                                      ) 
     FROM tmpMemberMinus
          LEFT JOIN tmpMI ON tmpMI.PersonalId = tmpMemberMinus.PersonalId
                         AND tmpMI.MemberId = tmpMemberMinus.MemberId;
     
     -- если в спр.Удержаний нет сотрудника а в док. есть - удаляем его из документа
     PERFORM lpSetErased_MovementItem (inMovementItemId:= tmpMI.Id, inUserId:= vbUserId)
     FROM tmpMI
          LEFT JOIN tmpMemberMinus ON tmpMemberMinus.PersonalId = tmpMI.PersonalId
                                  AND tmpMemberMinus.MemberId = tmpMI.MemberId
     WHERE tmpMemberMinus.MemberId IS NULL;

     

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.11.20         *
*/

-- тест
-- select * from gpInsertUpdate_MI_PersonalService_byMemberMinus(inMovementId := 18002434 ,  inSession := '5');