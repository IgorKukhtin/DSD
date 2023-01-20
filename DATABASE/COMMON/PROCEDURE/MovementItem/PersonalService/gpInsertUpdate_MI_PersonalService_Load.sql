-- Function: gpInsertUpdate_MI_PersonalService_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Load (Integer, TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PersonalService_Load(
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inINN_from               TVarChar  , --ИНН получателя
    IN inNumber                 TVarChar  , --
    IN inAmount                 TFloat    , 
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
     --получаем из MemberMinus нужного сотрудника
     SELECT DISTINCT
            ObjectLink_MemberMinus_From.ChildObjectId AS MemberId
          , tmpPersonal.PersonalId
          , tmpPersonal.PositionId
          , tmpPersonal.isMain
          , tmpPersonal.UnitId
          , ObjectLink_Personal_PersonalServiceList.ChildObjectId AS PersonalServiceListId
          , (CASE WHEN COALESCE (ObjectBoolean_Child.ValueData, FALSE) = FALSE THEN inAmount ELSE 0 END) :: TFloat AS SummMinusExtRecalc
          , (CASE WHEN COALESCE (ObjectBoolean_Child.ValueData, FALSE) = TRUE  THEN inAmount ELSE 0 END) :: TFloat AS SummChildRecalc
     FROM ObjectString AS ObjectString_INN_from

          LEFT JOIN ObjectLink AS ObjectLink_MemberMinus_From
                               ON ObjectLink_MemberMinus_From.ChildObjectId= ObjectString_INN_from.ObjectId
                              AND ObjectLink_MemberMinus_From.DescId = zc_ObjectLink_MemberMinus_From()

          INNER JOIN ObjectString AS ObjectString_Number
                                  ON ObjectString_Number.ObjectId = ObjectLink_MemberMinus_From.ObjectId
                                 AND ObjectString_Number.DescId = zc_ObjectString_MemberMinus_Number()
                                 AND ObjectString_Number.ValueData = TRIM (inNumber)

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Child
                                  ON ObjectBoolean_Child.ObjectId = ObjectLink_MemberMinus_From.ObjectId
                                 AND ObjectBoolean_Child.DescId = zc_ObjectBoolean_MemberMinus_Child()

          LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_MemberMinus_From.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                               ON ObjectLink_Personal_PersonalServiceList.ObjectId = tmpPersonal.PersonalId
                              AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()

     WHERE  ObjectString_INN_from.DescId IN (zc_ObjectString_MemberExternal_INN(), zc_ObjectString_Member_INN())
           AND ObjectString_INN_from.ValueData = TRIM(inINN_from)
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
                                                        , inSummHouseAdd          := COALESCE (tmpMI.SummHouseAdd,0)                        ::TFloat 
                                                        , inSummAvanceRecalc      := COALESCE (tmpMI.SummAvanceRecalc,0)                    ::TFloat
                                                        , inNumber                := TRIM(inNumber)                                         ::TVarChar
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
                         AND tmpMI.MemberId = tmpMemberMinus.MemberId
                         AND tmpMI.Number = inNumber
     ;
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.12.21         *
*/

-- тест
-- select * from gpInsertUpdate_MI_PersonalService_byMemberMinus(inMovementId := 18002434 ,  inSession := '5');