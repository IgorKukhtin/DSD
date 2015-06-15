-- Function: gpUpdate_MI_PersonalService_isMask()

DROP FUNCTION IF EXISTS gpUpdate_MI_PersonalService_isMask (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_MI_PersonalService_isMask(
    IN inMovementId      Integer      , -- ключ Документа
    IN inMovementMaskId  Integer      , -- ключ Документа маски
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_MI_PersonalService());
     vbUserId:= lpGetUserBySession (inSession);


      -- Проверка - что б не копировали два раза
      IF EXISTS (SELECT Id FROM MovementItem WHERE isErased = FALSE AND DescId = zc_MI_Master() AND MovementId = inMovementId AND Amount <> 0)
         THEN RAISE EXCEPTION 'Ошибка.В документе уже есть данные по начислениям.'; 
      END IF;


      -- Результат
       CREATE TEMP TABLE tmpMI (MovementItemId Integer, PersonalId Integer, isMain Boolean
             , UnitId Integer, PositionId Integer, InfoMoneyId Integer, MemberId Integer, PersonalServiceListId Integer
             , Amount TFloat, SummService TFloat, SummCard TFloat, SummCardRecalc TFloat, SummMinus TFloat, SummAdd TFloat
             , SummSocialIn TFloat, SummSocialAdd TFloat, SummChild TFloat) ON COMMIT DROP;
       
       WITH tmpMI AS (SELECT MAX (MovementItem.Id)                     AS MovementItemId
                           , MovementItem.ObjectId                     AS PersonalId
                           , MILinkObject_Unit.ObjectId                AS UnitId
                           , MILinkObject_Position.ObjectId            AS PositionId
                           , MILinkObject_InfoMoney.ObjectId           AS InfoMoneyId
                      FROM MovementItem 
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                            ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                            ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                            ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                      WHERE MovementItem.isErased = FALSE
                        AND MovementItem.DescId = zc_MI_Master()
                        AND MovementItem.MovementId =  inMovementId
                      GROUP BY MovementItem.ObjectId
                             , MILinkObject_Unit.ObjectId
                             , MILinkObject_Position.ObjectId
                             , MILinkObject_InfoMoney.ObjectId
                     )
         INSERT INTO tmpMI  (MovementItemId, PersonalId, isMain, UnitId, PositionId, InfoMoneyId, MemberId, PersonalServiceListId
                           , Amount, SummService, SummCard, SummCardRecalc, SummMinus, SummAdd 
                           , SummSocialIn, SummSocialAdd, SummChild)
            SELECT COALESCE (tmpMI.MovementItemId, 0)        AS MovementItemId
                 , MovementItem.ObjectId                     AS PersonalId
                 , COALESCE (MIBoolean_Main.ValueData, FALSE) :: Boolean   AS isMain
                 , MILinkObject_Unit.ObjectId                AS UnitId
                 , MILinkObject_Position.ObjectId            AS PositionId
                 , MILinkObject_InfoMoney.ObjectId           AS InfoMoneyId
                 , MILinkObject_Member.ObjectId              AS MemberId
                 , MILinkObject_PersonalServiceList.ObjectId AS PersonalServiceListId
                 , COALESCE (MovementItem.Amount, 0):: TFloat 
                 , COALESCE (MIFloat_SummService.ValueData, 0):: TFloat     AS SummService
                 , COALESCE (MIFloat_SummCard.ValueData, 0):: TFloat        AS SummCard
                 , COALESCE (MIFloat_SummCardRecalc.ValueData, 0):: TFloat  AS SummCardRecalc        
                 , COALESCE (MIFloat_SummMinus.ValueData, 0):: TFloat       AS SummMinus
                 , COALESCE (MIFloat_SummAdd.ValueData, 0):: TFloat         AS SummAdd
                 , COALESCE (MIFloat_SummSocialIn.ValueData, 0):: TFloat    AS SummSocialIn
                 , COALESCE (MIFloat_SummSocialAdd.ValueData, 0):: TFloat   AS SummSocialAdd
                 , COALESCE (MIFloat_SummChild.ValueData, 0):: TFloat       AS SummChild
            FROM MovementItem 
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                  ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                  ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Member
                                                  ON MILinkObject_Member.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_Member.DescId = zc_MILinkObject_Member()                                                           
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalServiceList
                                                  ON MILinkObject_PersonalServiceList.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_PersonalServiceList.DescId = zc_MILinkObject_PersonalServiceList() 

                 LEFT JOIN MovementItemFloat AS MIFloat_SummToPay
                                             ON MIFloat_SummToPay.MovementItemId = MovementItem.Id
                                            AND MIFloat_SummToPay.DescId = zc_MIFloat_SummToPay()
                 LEFT JOIN MovementItemFloat AS MIFloat_SummService 
                                             ON MIFloat_SummService.MovementItemId = MovementItem.Id
                                            AND MIFloat_SummService.DescId = zc_MIFloat_SummService()
                 LEFT JOIN MovementItemFloat AS MIFloat_SummCard
                                             ON MIFloat_SummCard.MovementItemId = MovementItem.Id
                                            AND MIFloat_SummCard.DescId = zc_MIFloat_SummCard()

                 LEFT JOIN MovementItemFloat AS MIFloat_SummCardRecalc
                                             ON MIFloat_SummCardRecalc.MovementItemId = MovementItem.Id
                                            AND MIFloat_SummCardRecalc.DescId = zc_MIFloat_SummCardRecalc()
                                                                              
                 LEFT JOIN MovementItemFloat AS MIFloat_SummMinus
                                             ON MIFloat_SummMinus.MovementItemId = MovementItem.Id
                                            AND MIFloat_SummMinus.DescId = zc_MIFloat_SummMinus()
                 LEFT JOIN MovementItemFloat AS MIFloat_SummAdd
                                             ON MIFloat_SummAdd.MovementItemId = MovementItem.Id
                                            AND MIFloat_SummAdd.DescId = zc_MIFloat_SummAdd()

                 LEFT JOIN MovementItemFloat AS MIFloat_SummSocialIn
                                             ON MIFloat_SummSocialIn.MovementItemId = MovementItem.Id
                                            AND MIFloat_SummSocialIn.DescId = zc_MIFloat_SummSocialIn()
                 LEFT JOIN MovementItemFloat AS MIFloat_SummSocialAdd
                                             ON MIFloat_SummSocialAdd.MovementItemId = MovementItem.Id
                                            AND MIFloat_SummSocialAdd.DescId = zc_MIFloat_SummSocialAdd()                                     
                 LEFT JOIN MovementItemFloat AS MIFloat_SummChild
                                             ON MIFloat_SummChild.MovementItemId = MovementItem.Id
                                            AND MIFloat_SummChild.DescId = zc_MIFloat_SummChild()
                 LEFT JOIN MovementItemBoolean AS MIBoolean_Main
                                               ON MIBoolean_Main.MovementItemId = MovementItem.Id
                                              AND MIBoolean_Main.DescId = zc_MIBoolean_Main()
                 LEFT JOIN tmpMI ON tmpMI.PersonalId  = MovementItem.ObjectId
                                AND tmpMI.UnitId      = MILinkObject_Unit.ObjectId
                                AND tmpMI.PositionId  = MILinkObject_Position.ObjectId
                                AND tmpMI.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
       WHERE MovementItem.isErased = FALSE
         AND MovementItem.DescId = zc_MI_Master()
         AND MovementItem.MovementId =  inMovementMaskId ;
        

     PERFORM lpInsertUpdate_MovementItem_PersonalService (ioId                 := MovementItemId
                                                        , inMovementId         := inMovementId
                                                        , inPersonalId         := PersonalId
                                                        , inisMain             := isMain
                                                        , inSummService        := SummService
                                                        , inSummCardRecalc     := SummCardRecalc
                                                        , inSummMinus          := SummMinus
                                                        , inSummAdd            := SummAdd
                                                        , inSummSocialIn       := SummSocialIn
                                                        , inSummSocialAdd      := SummSocialAdd
                                                        , inSummChild          := SummChild
                                                        , inComment            := 'копирование из другой ведомости'
                                                        , inInfoMoneyId        := InfoMoneyId
                                                        , inUnitId             := UnitId
                                                        , inPositionId         := PositionId
                                                        , inMemberId           := MemberId
                                                        , inPersonalServiceListId:= PersonalServiceListId
                                                        , inUserId             := vbUserId             
                                                         )
                                                   
     FROM tmpMI
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 23.05.15                                        *
 24.10.14         * 
*/

-- тест
--select * from gpUpdate_MI_PersonalService_isMask (inMovementId:= 393522 , inMovementMaskId :=393501 ,  inSession := '5');
