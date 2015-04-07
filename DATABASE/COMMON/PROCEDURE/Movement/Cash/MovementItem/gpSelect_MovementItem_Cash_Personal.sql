-- Function: gpSelect_MovementItem_Cash_Personal()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Cash_Personal (Integer, Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Cash_Personal(
    IN inMovementId     Integer      , -- ключ Документа
    IN inParentId       Integer      , -- ключ Документа
    IN inMovementItemId Integer      , --
    IN inShowAll        Boolean      , --
    IN inIsErased       Boolean      , --
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, PersonalId Integer, PersonalCode Integer, PersonalName TVarChar, INN TVarChar, isMain Boolean, isOfficial Boolean
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , PositionId Integer, PositionName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , Amount TFloat
             , SummService TFloat, SummToPay_cash TFloat, SummToPay TFloat, SummCard TFloat
             , Amount_current TFloat, Amount_avance TFloat, Amount_service TFloat
             , SummRemains TFloat
             , Comment TVarChar
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbServiceDateId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_Cash());
     vbUserId:= lpGetUserBySession (inSession);


     -- определяем <Месяц начислений>
     IF inParentId <> 0
     THEN
         vbServiceDateId:= lpInsertFind_Object_ServiceDate (inOperDate:= (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inParentId AND MovementDate.DescId = zc_MIDate_ServiceDate()));
     END IF;


     -- Результат
     RETURN QUERY
       WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE)
          , tmpMI AS (SELECT MovementItem.Id                          AS MovementItemId
                           , MovementItem.Amount                      AS Amount
                           , MovementItem.ObjectId                    AS PersonalId
                           , MILinkObject_Unit.ObjectId               AS UnitId
                           , MILinkObject_Position.ObjectId           AS PositionId
                           , MILinkObject_InfoMoney.ObjectId          AS InfoMoneyId
                           , MovementItem.isErased
                      FROM tmpIsErased
                           INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                  AND MovementItem.DescId = zc_MI_Child()
                                                  AND MovementItem.isErased = tmpIsErased.isErased
                                                  AND (MovementItem.Id = inMovementItemId OR COALESCE (inMovementItemId, 0) = 0)
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                            ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                            ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                            ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                     )
              , tmpParent AS (SELECT SUM (COALESCE (MIFloat_SummService.ValueData, 0))      AS SummService
                                   , SUM (COALESCE (MIFloat_SummToPay.ValueData, 0) - COALESCE (MIFloat_SummCard.ValueData, 0) - COALESCE (MIFloat_SummChild.ValueData, 0)) AS SummToPay_cash
                                   , SUM (COALESCE (MIFloat_SummToPay.ValueData, 0))        AS SummToPay
                                   , SUM (COALESCE (MIFloat_SummCard.ValueData, 0))         AS SummCard
                                   , MovementItem.ObjectId                                  AS PersonalId
                                   , MILinkObject_Unit.ObjectId                             AS UnitId
                                   , MILinkObject_Position.ObjectId                         AS PositionId
                                   , MILinkObject_InfoMoney.ObjectId                        AS InfoMoneyId
                                   , MLO_PersonalServiceList.ObjectId                       AS PersonalServiceListId
                              FROM Movement
                                   INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                          AND MovementItem.DescId = zc_MI_Master()
                                                          AND MovementItem.isErased = FALSE
                                                          AND MovementItem.Amount <> 0
                                   LEFT JOIN MovementLinkObject AS MLO_PersonalServiceList
                                                                ON MLO_PersonalServiceList.MovementId = Movement.Id
                                                               AND MLO_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                    ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                   ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                                    ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummToPay
                                                               ON MIFloat_SummToPay.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummToPay.DescId = zc_MIFloat_SummToPay()
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummService
                                                               ON MIFloat_SummService.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummService.DescId = zc_MIFloat_SummService()
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummCard
                                                               ON MIFloat_SummCard.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummCard.DescId = zc_MIFloat_SummCard()
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummChild
                                                               ON MIFloat_SummChild.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummChild.DescId = zc_MIFloat_SummChild()
                                   -- ограничение, если нужна только 1 запись
                                   LEFT JOIN (SELECT tmpMI.PersonalId, tmpMI.UnitId, tmpMI.PositionId, tmpMI.InfoMoneyId
                                              FROM tmpMI
                                              LIMIT 1
                                             ) AS tmp ON tmp.PersonalId   = MovementItem.ObjectId
                                                     AND tmp.UnitId       = MILinkObject_Unit.ObjectId
                                                     AND tmp.PositionId   = MILinkObject_Position.ObjectId
                                                     AND tmp.InfoMoneyId  = MILinkObject_InfoMoney.ObjectId
                                                     AND inMovementItemId > 0

                              WHERE Movement.Id = inParentId
                                AND Movement.StatusId = zc_Enum_Status_Complete()
                                AND (tmp.PersonalId IS NOT NULL OR COALESCE (inMovementItemId, 0) = 0) -- ограничение, если нужна только 1 запись

                              GROUP BY MovementItem.ObjectId
                                     , MILinkObject_Unit.ObjectId
                                     , MILinkObject_Position.ObjectId
                                     , MILinkObject_InfoMoney.ObjectId
                                     , MLO_PersonalServiceList.ObjectId
                             )
           , tmpContainer AS (SELECT CLO_ServiceDate.ContainerId
                                   , tmpParent.PersonalId
                                   , tmpParent.UnitId
                                   , tmpParent.PositionId
                                   , tmpParent.InfoMoneyId
                              FROM tmpParent
                                   INNER JOIN ContainerLinkObject AS CLO_ServiceDate
                                                                  ON CLO_ServiceDate.ObjectId = vbServiceDateId
                                                                 AND CLO_ServiceDate.DescId = zc_ContainerLinkObject_ServiceDate()
                                   INNER JOIN ContainerLinkObject AS CLO_Personal
                                                                  ON CLO_Personal.ObjectId = tmpParent.PersonalId
                                                                 AND CLO_Personal.DescId = zc_ContainerLinkObject_Personal()
                                                                 AND CLO_Personal.ContainerId = CLO_ServiceDate.ContainerId
                                   INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                                                                  ON CLO_InfoMoney.ObjectId = tmpParent.InfoMoneyId
                                                                 AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                                 AND CLO_InfoMoney.ContainerId = CLO_ServiceDate.ContainerId
                                   INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                  ON CLO_Unit.ObjectId = tmpParent.UnitId
                                                                 AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                                 AND CLO_Unit.ContainerId = CLO_ServiceDate.ContainerId
                                   INNER JOIN ContainerLinkObject AS CLO_Position
                                                                  ON CLO_Position.ObjectId = tmpParent.PositionId
                                                                 AND CLO_Position.DescId = zc_ContainerLinkObject_Position()
                                                                 AND CLO_Position.ContainerId = CLO_ServiceDate.ContainerId
                                   INNER JOIN ContainerLinkObject AS CLO_PersonalServiceList
                                                                  ON CLO_PersonalServiceList.ObjectId = tmpParent.PersonalServiceListId
                                                                 AND CLO_PersonalServiceList.DescId = zc_ContainerLinkObject_Position()
                                                                 AND CLO_PersonalServiceList.ContainerId = CLO_ServiceDate.ContainerId
                             )
                , tmpCash AS (SELECT SUM (CASE WHEN MIContainer.MovementId =  inMovementId THEN MIContainer.Amount ELSE 0 END) AS Amount_current
                                   , SUM (CASE WHEN MIContainer.MovementId <> inMovementId AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_Cash_PersonalAvance()  THEN MIContainer.Amount ELSE 0 END) AS Amount_avance
                                   , SUM (CASE WHEN MIContainer.MovementId <> inMovementId AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_Cash_PersonalService() THEN MIContainer.Amount ELSE 0 END) AS Amount_service
                                   , tmpContainer.PersonalId
                                   , tmpContainer.UnitId
                                   , tmpContainer.PositionId
                                   , tmpContainer.InfoMoneyId
                              FROM tmpContainer
                                   INNER JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                                   AND MIContainer.DescId = zc_MIContainer_Summ()
                                                                   AND MIContainer.MovementDescId = zc_Movement_Cash()
                              GROUP BY tmpContainer.PersonalId
                                     , tmpContainer.UnitId
                                     , tmpContainer.PositionId
                                     , tmpContainer.InfoMoneyId
                             )
             , tmpService AS (SELECT tmpParent.PersonalId
                                   , tmpParent.UnitId
                                   , tmpParent.PositionId
                                   , tmpParent.InfoMoneyId
                                   , tmpParent.SummService
                                   , tmpParent.SummToPay_cash
                                   , tmpParent.SummToPay
                                   , tmpParent.SummCard
                                   , tmpCash.Amount_current
                                   , tmpCash.Amount_avance
                                   , tmpCash.Amount_service
                              FROM tmpParent
                                   LEFT JOIN tmpCash ON tmpCash.PersonalId  = tmpParent.PersonalId
                                                    AND tmpCash.UnitId      = tmpParent.UnitId
                                                    AND tmpCash.PositionId  = tmpParent.PositionId
                                                    AND tmpCash.InfoMoneyId = tmpParent.InfoMoneyId
                             )
                , tmpData AS (SELECT tmpMI.MovementItemId
                                   , tmpMI.Amount
                                   , tmpService.SummService
                                   , tmpService.SummToPay_cash
                                   , tmpService.SummToPay
                                   , tmpService.SummCard
                                   , tmpService.Amount_current
                                   , tmpService.Amount_avance
                                   , tmpService.Amount_service
                                   , COALESCE (tmpMI.PersonalId, tmpService.PersonalId)   AS PersonalId
                                   , COALESCE (tmpMI.UnitId, tmpService.UnitId)           AS UnitId
                                   , COALESCE (tmpMI.PositionId, tmpService.PositionId)   AS PositionId
                                   , COALESCE (tmpMI.InfoMoneyId, tmpService.InfoMoneyId) AS InfoMoneyId
                                   , COALESCE (tmpMI.isErased, FALSE)                     AS isErased 
                              FROM tmpMI
                                   FULL JOIN tmpService ON tmpService.PersonalId  = tmpMI.PersonalId
                                                       AND tmpService.UnitId      = tmpMI.UnitId
                                                       AND tmpService.PositionId  = tmpMI.PositionId
                                                       AND tmpService.InfoMoneyId = tmpMI.InfoMoneyId
                             )
       -- Результат
       SELECT tmpData.MovementItemId                  AS Id
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
            , View_InfoMoney.InfoMoneyId
            , View_InfoMoney.InfoMoneyCode
            , View_InfoMoney.InfoMoneyName
            , View_InfoMoney.InfoMoneyName_all

            , tmpData.Amount         :: TFloat AS Amount
            , tmpData.SummService    :: TFloat AS SummService
            , tmpData.SummToPay_cash :: TFloat AS SummToPay_cash
            , tmpData.SummToPay      :: TFloat AS SummToPay
            , tmpData.SummCard       :: TFloat AS SummCard
            , tmpData.Amount_current :: TFloat AS Amount_current
            , tmpData.Amount_avance  :: TFloat AS Amount_avance
            , tmpData.Amount_service :: TFloat AS Amount_service
            , (COALESCE (tmpData.SummToPay_cash, 0) - COALESCE (tmpData.Amount, 0) - COALESCE (tmpData.Amount_avance, 0) - COALESCE (tmpData.Amount_service, 0)) :: TFloat AS SummRemains

            , MIString_Comment.ValueData       AS Comment
            , tmpData.isErased
         
       FROM tmpData
            LEFT JOIN MovementItemString AS MIString_Comment 
                                         ON MIString_Comment.MovementItemId = tmpData.MovementItemId
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = tmpData.PersonalId
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpData.PositionId
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpData.InfoMoneyId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Personal_Main
                                    ON ObjectBoolean_Personal_Main.ObjectId = tmpData.PersonalId
                                   AND ObjectBoolean_Personal_Main.DescId = zc_ObjectBoolean_Personal_Main()
            LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                 ON ObjectLink_Personal_Member.ObjectId = tmpData.PersonalId
                                AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
            LEFT JOIN ObjectString AS ObjectString_Member_INN
                                   ON ObjectString_Member_INN.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                  AND ObjectString_Member_INN.DescId = zc_ObjectString_Member_INN()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Member_Official
                                    ON ObjectBoolean_Member_Official.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                   AND ObjectBoolean_Member_Official.DescId = zc_ObjectBoolean_Member_Official()
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 04.04.15                                        * all
 16.09.14         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Cash_Personal (inMovementId:= 25173, inParentId:=0, inMovementItemId:= 0, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
