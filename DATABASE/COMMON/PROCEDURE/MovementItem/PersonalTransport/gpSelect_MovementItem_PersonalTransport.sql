-- Function: gpSelect_MovementItem_PersonalTransport (Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PersonalTransport (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PersonalTransport(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , -- 
    IN inIsErased    Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             , MemberId Integer, MemberName TVarChar
             , Code1C TVarChar, INN TVarChar, Card TVarChar, CardSecond TVarChar
             , CardIBAN TVarChar, CardIBANSecond TVarChar
             , isMain Boolean, isOfficial Boolean, DateOut TDateTime
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , PositionId Integer, PositionName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , Amount TFloat
             , Comment TVarChar
             , isErased Boolean
              )     

AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbPersonalServiceListId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbInfoMoneyId_def Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_PersonalTransport());
     vbUserId:= lpGetUserBySession (inSession);

     --Дата тек.документа
     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

     -- определяется Дефолт
     vbInfoMoneyId_def:= (SELECT Object_InfoMoney_View.InfoMoneyId FROM Object_InfoMoney_View WHERE Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_21421()); --(21421) Общефирменные Услуги полученные проезд


     -- Ведомость из шапки
     vbPersonalServiceListId := (SELECT MovementLinkObject_PersonalServiceList.ObjectId
                                 FROM MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                 WHERE MovementLinkObject_PersonalServiceList.MovementId = inMovementId
                                   AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
                                 );

     RETURN QUERY
       WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE)

          , tmpMI AS (SELECT MovementItem.Id                          AS MovementItemId
                           , MovementItem.Amount                      AS Amount
                           , MovementItem.ObjectId                    AS PersonalId
                           , MovementItem.isErased
                      FROM tmpIsErased
                           INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                  AND MovementItem.DescId = zc_MI_Master()
                                                  AND MovementItem.isErased = tmpIsErased.isErased
                     )

          , tmpPersonal AS (SELECT 0 AS MovementItemId
                                 , 0 AS Amount
                                 , tmpPersonal.PersonalId
                                 , FALSE AS isErased
                            FROM (SELECT ObjectLink_Personal_PersonalServiceList.ObjectId AS PersonalId
                                  FROM ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                  WHERE ObjectLink_Personal_PersonalServiceList.ChildObjectId = vbPersonalServiceListId
                                    AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
                                    AND inShowAll = TRUE
                                 ) AS tmpPersonal

                                 LEFT JOIN tmpMI ON tmpMI.PersonalId = tmpPersonal.PersonalId
                            WHERE tmpMI.PersonalId IS NULL
                           )

          , tmpAll AS (SELECT tmpMI.MovementItemId, tmpMI.Amount, tmpMI.PersonalId, tmpMI.isErased FROM tmpMI
                      UNION ALL
                       SELECT tmpPersonal.MovementItemId, tmpPersonal.Amount, tmpPersonal.PersonalId, tmpPersonal.isErased FROM tmpPersonal
                      )

       -- Результат
       SELECT tmpAll.MovementItemId                         AS Id
            , View_Personal.PersonalId
            , View_Personal.PersonalCode
            , View_Personal.PersonalName
            , COALESCE (Object_Member.Id, 0)                    AS MemberId
            , COALESCE (Object_Member.ValueData, '') ::TVarChar AS MemberName
            , ObjectString_Code1C.ValueData                 AS Code1C
            , ObjectString_Member_INN.ValueData             AS INN
            , ObjectString_Member_Card.ValueData            AS Card
            , ObjectString_Member_CardSecond.ValueData      AS CardSecond
            , ObjectString_Member_CardIBAN.ValueData        AS CardIBAN
            , ObjectString_Member_CardIBANSecond.ValueData  AS CardIBANSecond
            , COALESCE (View_Personal.isMain, FALSE)     :: Boolean AS isMain
            , COALESCE (View_Personal.isOfficial, FALSE) :: Boolean AS isOfficial
            , View_Personal.DateOut_user               :: TDateTime AS DateOut   -- дата увольнения

            , Object_Unit.Id                    AS UnitId
            , Object_Unit.ObjectCode            AS UnitCode
            , Object_Unit.ValueData             AS UnitName
            , Object_Position.Id                AS PositionId
            , Object_Position.ValueData         AS PositionName
            , View_InfoMoney.InfoMoneyId
            , View_InfoMoney.InfoMoneyCode
            , View_InfoMoney.InfoMoneyName
            , View_InfoMoney.InfoMoneyName_all

            , tmpAll.Amount :: TFloat           AS Amount

            , MIString_Comment.ValueData        AS Comment
            , tmpAll.isErased

       FROM tmpAll
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = tmpAll.MovementItemId
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = tmpAll.MovementItemId
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = tmpAll.MovementItemId
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                             ON MILinkObject_Position.MovementItemId = tmpAll.MovementItemId
                                            AND MILinkObject_Position.DescId = zc_MILinkObject_Position()

            LEFT JOIN ObjectString AS ObjectString_Code1C
                                   ON ObjectString_Code1C.ObjectId = tmpAll.PersonalId
                                  AND ObjectString_Code1C.DescId    = zc_ObjectString_Personal_Code1C()

            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = COALESCE (MILinkObject_InfoMoney.ObjectId,vbInfoMoneyId_def)

            LEFT JOIN Object_Personal_View AS View_Personal ON View_Personal.PersonalId = tmpAll.PersonalId

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = COALESCE (MILinkObject_Unit.ObjectId, View_Personal.UnitId)
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = COALESCE (MILinkObject_Position.ObjectId, View_Personal.PositionId)

            LEFT JOIN Object AS Object_Member   ON Object_Member.Id   = View_Personal.MemberId

            LEFT JOIN ObjectString AS ObjectString_Member_INN
                                   ON ObjectString_Member_INN.ObjectId = View_Personal.MemberId
                                  AND ObjectString_Member_INN.DescId = zc_ObjectString_Member_INN()
            LEFT JOIN ObjectString AS ObjectString_Member_Card
                                   ON ObjectString_Member_Card.ObjectId = View_Personal.MemberId
                                  AND ObjectString_Member_Card.DescId = zc_ObjectString_Member_Card()
            LEFT JOIN ObjectString AS ObjectString_Member_CardSecond
                                   ON ObjectString_Member_CardSecond.ObjectId = View_Personal.MemberId
                                  AND ObjectString_Member_CardSecond.DescId = zc_ObjectString_Member_CardSecond()

            LEFT JOIN ObjectString AS ObjectString_Member_CardIBAN
                                   ON ObjectString_Member_CardIBAN.ObjectId = View_Personal.MemberId
                                  AND ObjectString_Member_CardIBAN.DescId = zc_ObjectString_Member_CardIBAN()
            LEFT JOIN ObjectString AS ObjectString_Member_CardIBANSecond
                                   ON ObjectString_Member_CardIBANSecond.ObjectId = View_Personal.MemberId
                                  AND ObjectString_Member_CardIBANSecond.DescId = zc_ObjectString_Member_CardIBANSecond()
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.08.22         *
*/

-- тест
--SELECT * FROM gpSelect_MovementItem_PersonalTransport (inMovementId:= 14521952, inShowAll:= TRUE, inIsErased:= TRUE, inSession:= '2')