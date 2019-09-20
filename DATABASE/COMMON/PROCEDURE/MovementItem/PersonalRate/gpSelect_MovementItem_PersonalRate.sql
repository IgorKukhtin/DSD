-- Function: gpSelect_MovementItem_PersonalRate (Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PersonalRate (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PersonalRate(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , -- 
    IN inIsErased    Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             , INN TVarChar, Card TVarChar, CardSecond TVarChar
             , CardIBAN TVarChar, CardIBANSecond TVarChar
             , isMain Boolean, isOfficial Boolean, DateOut TDateTime
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , PositionId Integer, PositionName TVarChar
             , MemberId Integer, MemberName TVarChar
             , Amount TFloat
             , Comment TVarChar
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_PersonalRate());
     vbUserId:= inSession;

     RETURN QUERY
       WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE)

          , tmpMI AS (SELECT MovementItem.Id                          AS MovementItemId
                           , MovementItem.Amount                      AS Amount
                           , MovementItem.ObjectId                    AS PersonalId
                           , ObjectLink_Personal_Member.ChildObjectId AS MemberId_Personal
                           , MILinkObject_Unit.ObjectId               AS UnitId
                           , MILinkObject_Position.ObjectId           AS PositionId
                           , MovementItem.isErased
                      FROM tmpIsErased
                           INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                  AND MovementItem.DescId = zc_MI_Master()
                                                  AND MovementItem.isErased = tmpIsErased.isErased

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

          , tmpUserAll AS (-- Админ видит ВСЕХ
                           SELECT DISTINCT UserId FROM ObjectLink_UserRole_View WHERE RoleId IN (zc_Enum_Role_Admin()/*, 293449*/) AND UserId = vbUserId/* AND UserId <> 9464*/ -- Документы-меню (управленцы) AND <> Рудик Н.В.
                          UNION
                           -- Кисличная Т.А. видит ВСЕХ
                           SELECT vbUserId WHERE vbUserId = 80830
                          )
                          
          , tmpPersonal AS (SELECT 0 AS MovementItemId
                                 , 0 AS Amount
                                 , View_Personal.PersonalId
                                 , View_Personal.UnitId
                                 , View_Personal.PositionId
                                 , View_Personal.MemberId    AS MemberId_Personal
                                 , FALSE AS isErased
                            FROM (SELECT UnitId_PersonalService FROM Object_RoleAccessKeyGuide_View WHERE UnitId_PersonalService <> 0 AND UserId = vbUserId AND inShowAll = TRUE
                                 UNION
                                  -- Админ видит ВСЕХ
                                  SELECT Object.Id AS UnitId_PersonalService FROM Object WHERE Object.DescId = zc_Object_Unit() AND inShowAll = TRUE
                                                                                           AND EXISTS (SELECT 1 FROM tmpUserAll)
                                 ) AS View_RoleAccessKeyGuide
                                 INNER JOIN Object_Personal_View AS View_Personal ON View_Personal.UnitId = View_RoleAccessKeyGuide.UnitId_PersonalService

                                 LEFT JOIN tmpMI ON tmpMI.PersonalId = View_Personal.PersonalId
                                                AND tmpMI.UnitId     = View_Personal.UnitId
                                                AND tmpMI.PositionId = View_Personal.PositionId

                            WHERE tmpMI.PersonalId IS NULL
                           )

          , tmpAll AS (SELECT tmpMI.MovementItemId, tmpMI.Amount, tmpMI.PersonalId, tmpMI.UnitId, tmpMI.PositionId, tmpMI.MemberId_Personal, tmpMI.isErased FROM tmpMI
                      UNION ALL
                       SELECT tmpPersonal.MovementItemId, tmpPersonal.Amount, tmpPersonal.PersonalId, tmpPersonal.UnitId, tmpPersonal.PositionId, tmpPersonal.MemberId_Personal, tmpPersonal.isErased FROM tmpPersonal
                      )
              
              
       -- Результат
       SELECT tmpAll.MovementItemId                         AS Id
            , Object_Personal.Id                            AS PersonalId
            , Object_Personal.ObjectCode                    AS PersonalCode
            , Object_Personal.ValueData                     AS PersonalName
            , ObjectString_Member_INN.ValueData             AS INN
            , ObjectString_Member_Card.ValueData            AS Card
            , ObjectString_Member_CardSecond.ValueData      AS CardSecond
            , ObjectString_Member_CardIBAN.ValueData        AS CardIBAN
            , ObjectString_Member_CardIBANSecond.ValueData  AS CardIBANSecond
            , COALESCE (ObjectBoolean_Personal_Main.ValueData, FALSE)   :: Boolean   AS isMain
            , COALESCE (ObjectBoolean_Member_Official.ValueData, FALSE) :: Boolean AS isOfficial
            , CASE WHEN COALESCE (ObjectDate_Personal_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN NULL ELSE ObjectDate_Personal_DateOut.ValueData END     :: TDateTime AS DateOut   -- дата увольнения

            , Object_Unit.Id                          AS UnitId
            , Object_Unit.ObjectCode                  AS UnitCode
            , Object_Unit.ValueData                   AS UnitName
            , Object_Position.Id                      AS PositionId
            , Object_Position.ValueData               AS PositionName

            , COALESCE (Object_Member.Id, 0)          AS MemberId
            , COALESCE (Object_Member.ValueData, ''::TVarChar) AS MemberName

            , tmpAll.Amount :: TFloat           AS Amount

            , MIString_Comment.ValueData       AS Comment
            , tmpAll.isErased


       FROM tmpAll
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = tmpAll.MovementItemId
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = tmpAll.PersonalId
            LEFT JOIN Object AS Object_Unit     ON Object_Unit.Id     = tmpAll.UnitId
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpAll.PositionId
            LEFT JOIN Object AS Object_Member   ON Object_Member.Id   = tmpAll.MemberId_Personal

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Personal_Main
                                    ON ObjectBoolean_Personal_Main.ObjectId = tmpAll.PersonalId
                                   AND ObjectBoolean_Personal_Main.DescId = zc_ObjectBoolean_Personal_Main()
            LEFT JOIN ObjectDate AS ObjectDate_Personal_DateOut
                                 ON ObjectDate_Personal_DateOut.ObjectId = tmpAll.PersonalId
                                AND ObjectDate_Personal_DateOut.DescId = zc_ObjectDate_Personal_Out()

            LEFT JOIN ObjectString AS ObjectString_Member_INN
                                   ON ObjectString_Member_INN.ObjectId = tmpAll.MemberId_Personal
                                  AND ObjectString_Member_INN.DescId = zc_ObjectString_Member_INN()
            LEFT JOIN ObjectString AS ObjectString_Member_Card
                                   ON ObjectString_Member_Card.ObjectId = tmpAll.MemberId_Personal
                                  AND ObjectString_Member_Card.DescId = zc_ObjectString_Member_Card()
            LEFT JOIN ObjectString AS ObjectString_Member_CardSecond
                                   ON ObjectString_Member_CardSecond.ObjectId = tmpAll.MemberId_Personal
                                  AND ObjectString_Member_CardSecond.DescId = zc_ObjectString_Member_CardSecond()

            LEFT JOIN ObjectString AS ObjectString_Member_CardIBAN
                                   ON ObjectString_Member_CardIBAN.ObjectId = tmpAll.MemberId_Personal
                                  AND ObjectString_Member_CardIBAN.DescId = zc_ObjectString_Member_CardIBAN()
            LEFT JOIN ObjectString AS ObjectString_Member_CardIBANSecond
                                   ON ObjectString_Member_CardIBANSecond.ObjectId = tmpAll.MemberId_Personal
                                  AND ObjectString_Member_CardIBANSecond.DescId = zc_ObjectString_Member_CardIBANSecond()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Member_Official
                                    ON ObjectBoolean_Member_Official.ObjectId = tmpAll.MemberId_Personal
                                   AND ObjectBoolean_Member_Official.DescId = zc_ObjectBoolean_Member_Official()
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.09.19         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_PersonalRate (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItem_PersonalRate (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
