-- Function: gpSelect_MovementItem_PersonalService()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PersonalService (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PersonalService(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, PersonalId Integer, PersonalCode Integer, PersonalName TVarChar, INN TVarChar, isMain Boolean, isOfficial Boolean
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , PositionId Integer, PositionName TVarChar
             , InfoMoneyId Integer, InfoMoneyName  TVarChar
             , Amount TFloat, AmountCash TFloat, SummService TFloat, SummCard TFloat, SummMinus TFloat, SummAdd TFloat
             , Comment TVarChar
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbInfoMoneyId_def Integer;
   DECLARE vbInfoMoneyName TVarChar;
   DECLARE vbInfoMoneyName_all TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_MI_PersonalService());
     vbUserId:= lpGetUserBySession (inSession);


     -- определяется Дефолт
     vbInfoMoneyId_def:= (SELECT Object_InfoMoney_View.InfoMoneyId FROM Object_InfoMoney_View WHERE Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_60101()); -- 60101 Заработная плата + Заработная плата

     -- Результат
     RETURN QUERY
       WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE)
          , tmpMI AS (SELECT MovementItem.Id                          AS MovementItemId
                           , MovementItem.Amount
                           , MovementItem.ObjectId                    AS PersonalId
                           , MILinkObject_Unit.ObjectId               AS UnitId
                           , MILinkObject_Position.ObjectId           AS PositionId
                           , MILinkObject_InfoMoney.ObjectId          AS InfoMoneyId
                           , ObjectLink_Personal_Member.ChildObjectId AS MemberId
                           , MovementItem.isErased
                      FROM tmpIsErased
                           INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                  AND MovementItem.DescId = zc_MI_Master()
                                                  AND MovementItem.isErased = tmpIsErased.isErased
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                            ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                           ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                            ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                           LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                ON ObjectLink_Personal_Member.ObjectId = MovementItem.ObjectId
                                               AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                     )
          , tmpUserAll AS (SELECT DISTINCT UserId FROM ObjectLink_UserRole_View WHERE RoleId IN (zc_Enum_Role_Admin()/*, 293449*/) AND UserId = vbUserId/* AND UserId <> 9464*/) -- Документы-меню (управленцы) AND <> Рудик Н.В.
          , tmpPersonal AS (SELECT 0 AS MovementItemId
                                 , 0 AS Amount
                                 , View_Personal.PersonalId
                                 , View_Personal.UnitId
                                 , View_Personal.PositionId
                                 , vbInfoMoneyId_def AS InfoMoneyId
                                 , View_Personal.MemberId
                                 , FALSE AS isErased
                            FROM (SELECT UnitId_PersonalService FROM Object_RoleAccessKeyGuide_View WHERE UnitId_PersonalService <> 0 AND UserId = vbUserId AND inShowAll = TRUE
                                 UNION
                                  -- Админ видит ВСЕХ
                                  SELECT Object.Id AS UnitId_PersonalService FROM tmpUserAll INNER JOIN Object ON Object.DescId = zc_Object_Unit() AND inShowAll = TRUE
                                 ) AS View_RoleAccessKeyGuide
                                 INNER JOIN Object_Personal_View AS View_Personal ON View_Personal.UnitId = View_RoleAccessKeyGuide.UnitId_PersonalService
                                                                                 AND View_Personal.isErased = FALSE
                                 LEFT JOIN tmpMI ON tmpMI.PersonalId = View_Personal.PersonalId
                                                AND tmpMI.UnitId     = View_Personal.UnitId
                                                AND tmpMI.PositionId = View_Personal.PositionId
                            WHERE tmpMI.PersonalId IS NULL
                           )
          , tmpAll AS (SELECT tmpMI.MovementItemId, tmpMI.Amount, tmpMI.PersonalId, tmpMI.UnitId, tmpMI.PositionId, tmpMI.InfoMoneyId, tmpMI.MemberId, tmpMI.isErased FROM tmpMI
                      UNION ALL
                       SELECT tmpPersonal.MovementItemId, tmpPersonal.Amount, tmpPersonal.PersonalId, tmpPersonal.UnitId, tmpPersonal.PositionId, tmpPersonal.InfoMoneyId, tmpPersonal.MemberId, tmpPersonal.isErased FROM tmpPersonal
                      )
       SELECT tmpAll.MovementItemId                   AS Id
            , Object_Personal.Id                      AS PersonalId
            , Object_Personal.ObjectCode              AS PersonalCode
            , Object_Personal.ValueData               AS PersonalName
            , ObjectString_Member_INN.ValueData       AS INN
            , COALESCE (ObjectBoolean_Personal_Main.ValueData, FALSE) :: Boolean   AS isMain
            , COALESCE (ObjectBoolean_Member_Official.ValueData, FALSE) :: Boolean AS isOfficial

            , Object_Unit.Id                          AS UnitId
            , Object_Unit.ObjectCode                  AS UnitCode
            , Object_Unit.ValueData                   AS UnitName
            , Object_Position.Id                      AS PositionId
            , Object_Position.ValueData               AS PositionName
            , View_InfoMoney.InfoMoneyId              AS InfoMoneyId
            , View_InfoMoney.InfoMoneyName_all        AS InfoMoneyName

            , tmpAll.Amount :: TFloat         AS Amount
            , (COALESCE (tmpAll.Amount, 0) - COALESCE (MIFloat_SummCard.ValueData)) :: TFloat AS AmountCash
            , MIFloat_SummService.ValueData   AS SummService
            , MIFloat_SummCard.ValueData      AS SummCard
            , MIFloat_SummMinus.ValueData     AS SummMinus
            , MIFloat_SummAdd.ValueData       AS SummAdd

            , MIString_Comment.ValueData      AS Comment
            , tmpAll.isErased
         
       FROM tmpAll 
            LEFT JOIN MovementItemString AS MIString_Comment 
                                         ON MIString_Comment.MovementItemId = tmpAll.MovementItemId
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
                                        
            LEFT JOIN MovementItemFloat AS MIFloat_SummService 
                                        ON MIFloat_SummService.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummService.DescId = zc_MIFloat_SummService()
            LEFT JOIN MovementItemFloat AS MIFloat_SummCard
                                        ON MIFloat_SummCard.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummCard.DescId = zc_MIFloat_SummCard()
            LEFT JOIN MovementItemFloat AS MIFloat_SummMinus
                                        ON MIFloat_SummMinus.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummMinus.DescId = zc_MIFloat_SummMinus()
            LEFT JOIN MovementItemFloat AS MIFloat_SummAdd
                                        ON MIFloat_SummAdd.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummAdd.DescId = zc_MIFloat_SummAdd()

            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = tmpAll.PersonalId
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpAll.UnitId
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpAll.PositionId
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpAll.InfoMoneyId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Personal_Main
                                    ON ObjectBoolean_Personal_Main.ObjectId = tmpAll.PersonalId
                                   AND ObjectBoolean_Personal_Main.DescId = zc_ObjectBoolean_Personal_Main()
            LEFT JOIN ObjectString AS ObjectString_Member_INN
                                   ON ObjectString_Member_INN.ObjectId = tmpAll.MemberId
                                  AND ObjectString_Member_INN.DescId = zc_ObjectString_Member_INN()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Member_Official
                                    ON ObjectBoolean_Member_Official.ObjectId = tmpAll.MemberId
                                   AND ObjectBoolean_Member_Official.DescId = zc_ObjectBoolean_Member_Official()
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_PersonalService (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 14.09.14                                        * ALL
 11.09.14         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_PersonalService (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_PersonalService (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
