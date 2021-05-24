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
             , Date_Last TDateTime
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbPersonalServiceListId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_PersonalRate());
     vbUserId:= lpGetUserBySession (inSession);

     --Дата тек.документа
     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

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

          --нужно добавить в грид еще дату до которой действует ставка - найти следующий (по дате) документ по этому физ лицу где была введена новая ставка
          -- находим следующие документы для МИ
          , tmpMovementLast AS (SELECT MIN (Movement.OperDate) AS OperDate
                                     , MovementItem.ObjectId   AS PersonalId
                                FROM Movement
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                                                   ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                                                  AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
                                                                  AND MovementLinkObject_PersonalServiceList.ObjectId = vbPersonalServiceListId
                                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                           AND MovementItem.DescId = zc_MI_Master()
                                                           AND MovementItem.isErased = FALSE
                                     INNER JOIN tmpMI ON tmpMI.PersonalId = MovementItem.ObjectId
                                WHERE Movement.DescId   = zc_Movement_PersonalRate()
                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                                  --AND Movement.StatusId <> zc_Enum_Status_Erased()
                                  AND Movement.OperDate >= vbOperDate
                                  AND Movement.Id <> inMovementId
                                GROUP BY MovementItem.ObjectId
                               )
              
       -- Результат
       SELECT tmpAll.MovementItemId                         AS Id
            , View_Personal.PersonalId
            , View_Personal.PersonalCode
            , View_Personal.PersonalName
            , ObjectString_Member_INN.ValueData             AS INN
            , ObjectString_Member_Card.ValueData            AS Card
            , ObjectString_Member_CardSecond.ValueData      AS CardSecond
            , ObjectString_Member_CardIBAN.ValueData        AS CardIBAN
            , ObjectString_Member_CardIBANSecond.ValueData  AS CardIBANSecond
            , COALESCE (View_Personal.isMain, FALSE)   :: Boolean   AS isMain
            , COALESCE (View_Personal.isOfficial, FALSE) :: Boolean AS isOfficial
            , View_Personal.DateOut_user       :: TDateTime AS DateOut   -- дата увольнения

            , View_Personal.UnitId
            , View_Personal.UnitCode
            , View_Personal.UnitName
            , View_Personal.PositionId
            , View_Personal.PositionName

            , COALESCE (Object_Member.Id, 0)          AS MemberId
            , COALESCE (Object_Member.ValueData, ''::TVarChar) AS MemberName

            , tmpAll.Amount :: TFloat           AS Amount

            , MIString_Comment.ValueData       AS Comment
            , COALESCE (tmpMovementLast.OperDate, NULL) ::TDateTime AS Date_Last -- до какой даты действует ставка  -- zc_DateEnd()
            , tmpAll.isErased

       FROM tmpAll
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = tmpAll.MovementItemId
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN Object_Personal_View AS View_Personal ON View_Personal.PersonalId = tmpAll.PersonalId

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

            LEFT JOIN tmpMovementLast ON tmpMovementLast.PersonalId = tmpAll.PersonalId
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
--SELECT * FROM gpSelect_MovementItem_PersonalRate (inMovementId:= 14521952, inShowAll:= TRUE, inIsErased:= TRUE, inSession:= '2')
--SELECT * FROM gpSelect_MovementItem_PersonalRate (inMovementId:= 14521952, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
