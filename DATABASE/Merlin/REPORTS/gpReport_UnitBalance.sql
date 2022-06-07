-- Function: gpReport_UnitBalance() -- отчет по отделам в разрезе месяц начислений :

DROP FUNCTION IF EXISTS gpReport_UnitBalance (TDateTime, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_UnitBalance (TDateTime, TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_UnitBalance(
    IN inStartDate    TDateTime , --
    IN inEndDate      TDateTime , -- месяц начислений
    IN inServiceDate  TDateTime , -- месяц начислений
    IN inUnitGroupId  Integer,
    IN inInfoMoneyId  Integer,
    IN inIsAll        Boolean,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (ContainerId Integer, ServiceDateId Integer
             , ServiceDate TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , GroupNameFull_Unit TVarChar, NameFull_unit TVarChar
             , ParentName_Unit TVarChar, BuildingName_unit TVarChar, FloorName_unit TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar
             , AccountCode Integer, AccountName TVarChar
             , AmountDebetStart TFloat, AmountKreditStart TFloat
             , AmountDebet TFloat, AmountKredit TFloat
             , AmountDebetEnd TFloat, AmountKreditEnd TFloat
             , OperDate TDateTime--, InvNumber TVarChar
             , InfoMoneyDetailCode Integer, InfoMoneyDetailName TVarChar
             , CommentInfoMoneyCode Integer, CommentInfoMoneyName TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             , AmountRemainsStart_info TFloat
             , AmountRemainsEnd_info TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbServiceDateId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Balance());
     vbUserId:= lpGetUserBySession (inSession);

     inServiceDate := DATE_TRUNC ('MONTH', inServiceDate);
     vbServiceDateId := (SELECT lpInsertFind_Object_ServiceDate (inServiceDate));


     -- Результат
     RETURN QUERY
     WITH
     tmpUnit AS (SELECT lfSelect_Object_Unit_byGroup.UnitId AS UnitId
                      , lfGet_Object_BuildingName (lfSelect_Object_Unit_byGroup.UnitId) ::TVarChar AS BuildingName
                      , lfGet_Object_FloorName (lfSelect_Object_Unit_byGroup.UnitId)    ::TVarChar AS FloorName
                 FROM lfSelect_Object_Unit_byGroup (inUnitGroupId) AS lfSelect_Object_Unit_byGroup
                 WHERE inUnitGroupId <> 0
                UNION
                 SELECT Object.Id AS UnitId
                      , lfGet_Object_BuildingName (Object.Id) ::TVarChar AS BuildingName
                      , lfGet_Object_FloorName (Object.Id)    ::TVarChar AS FloorName
                 FROM Object
                 WHERE Object.DescId = zc_Object_Unit()
                 --AND Object.isErased = FALSE
                   AND inUnitGroupId = 0
                 )
   , tmpInfoMoney AS (SELECT lfSelect_Object_InfoMoney_byGroup.InfoMoneyId AS InfoMoneyId
                      FROM lfSelect_Object_InfoMoney_byGroup (inInfoMoneyId) AS lfSelect_Object_InfoMoney_byGroup
                      WHERE inInfoMoneyId <> 0
                     UNION
                      SELECT Object.Id AS InfoMoneyId
                      FROM Object
                      WHERE Object.DescId = zc_Object_InfoMoney()
                      --AND Object.isErased = FALSE
                        AND inInfoMoneyId = 0
                      )

   , tmpMIContainer_all AS (SELECT Container.Id             AS ContainerId
                                 , Container.ObjectId       AS AccountId
                                 , Container.WhereObjectId  AS UnitId
                                 , Container.Amount         AS Amount
                                 , CLO_ServiceDate.ObjectId AS ServiceDateId
                                 , CLO_InfoMoney.ObjectId   AS InfoMoneyId

                                 , CASE WHEN MIContainer.MovementDescId = zc_Movement_Service() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  1 * MIContainer.Amount ELSE 0 END AS AmountDebet
                                 , CASE WHEN MIContainer.MovementDescId = zc_Movement_Cash()    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN -1 * MIContainer.Amount ELSE 0 END AS AmountKredit
                                 , CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END AS Amount_summ
                                 , MIContainer.MovementItemId
                                 , MIContainer.OperDate
                            FROM Container
                                 LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                               ON CLO_InfoMoney.ContainerId = Container.Id
                                                              AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                 LEFT JOIN ContainerLinkObject AS CLO_ServiceDate
                                                               ON CLO_ServiceDate.ContainerId = Container.Id
                                                              AND CLO_ServiceDate.DescId = zc_ContainerLinkObject_ServiceDate()
                                 LEFT JOIN MovementItemContainer AS MIContainer
                                                                 ON MIContainer.Containerid = Container.Id
                                                                AND MIContainer.OperDate    >= inStartDate

                            WHERE Container.DescId = zc_Container_Summ()
                              AND Container.WhereObjectId IN (SELECT DISTINCT tmpUnit.UnitId           FROM tmpUnit)
                              AND (CLO_InfoMoney.ObjectId IN (SELECT DISTINCT tmpInfoMoney.InfoMoneyId FROM tmpInfoMoney) OR inInfoMoneyId = 0)
                              AND ((CLO_ServiceDate.ObjectId = vbServiceDateId AND inIsAll = FALSE) OR inIsAll = TRUE)
                           )

   , tmpMIContainer_rem AS (SELECT tmpMIContainer_all.ContainerId
                                 , tmpMIContainer_all.AccountId
                                 , tmpMIContainer_all.UnitId
                                 , tmpMIContainer_all.ServiceDateId
                                 , tmpMIContainer_all.InfoMoneyId

                                 , tmpMIContainer_all.Amount - SUM (tmpMIContainer_all.Amount_summ + tmpMIContainer_all.AmountDebet - tmpMIContainer_all.AmountKredit) AS AmountRemainsStart
                                 , tmpMIContainer_all.Amount - SUM (tmpMIContainer_all.Amount_summ) AS AmountRemainsEnd
                            FROM tmpMIContainer_all
                            GROUP BY tmpMIContainer_all.ContainerId
                                   , tmpMIContainer_all.AccountId
                                   , tmpMIContainer_all.UnitId
                                   , tmpMIContainer_all.ServiceDateId
                                   , tmpMIContainer_all.InfoMoneyId
                                   , tmpMIContainer_all.Amount
                            HAVING 0 <> tmpMIContainer_all.Amount - SUM (tmpMIContainer_all.Amount_summ + tmpMIContainer_all.AmountDebet - tmpMIContainer_all.AmountKredit)
                                OR 0 <> tmpMIContainer_all.Amount - SUM (tmpMIContainer_all.Amount_summ)
                           )
   , tmpMIContainer AS (SELECT tmpMIContainer_rem.ContainerId
                             , tmpMIContainer_rem.AccountId
                             , tmpMIContainer_rem.UnitId
                             , tmpMIContainer_rem.ServiceDateId
                             , tmpMIContainer_rem.InfoMoneyId

                             , 0 AS AmountDebet
                             , 0 AS AmountKredit
                             , tmpMIContainer_rem.AmountRemainsStart
                             , tmpMIContainer_rem.AmountRemainsEnd
                             , 0    AS MovementItemId
                             , NULL AS OperDate
                        FROM tmpMIContainer_rem

                       UNION ALL
                        SELECT tmpMIContainer_all.ContainerId
                             , tmpMIContainer_all.AccountId
                             , tmpMIContainer_all.UnitId
                             , tmpMIContainer_all.ServiceDateId
                             , tmpMIContainer_all.InfoMoneyId

                             , SUM (tmpMIContainer_all.AmountDebet)  AS AmountDebet
                             , SUM (tmpMIContainer_all.AmountKredit) AS AmountKredit
                             , 0 AS AmountRemainsStart
                             , 0 AS AmountRemainsEnd
                             , tmpMIContainer_all.MovementItemId
                             , tmpMIContainer_all.OperDate
                        FROM tmpMIContainer_all
                        GROUP BY tmpMIContainer_all.ContainerId
                               , tmpMIContainer_all.AccountId
                               , tmpMIContainer_all.UnitId
                               , tmpMIContainer_all.ServiceDateId
                               , tmpMIContainer_all.InfoMoneyId
                               , tmpMIContainer_all.MovementItemId
                               , tmpMIContainer_all.OperDate
                        HAVING 0 <> SUM (tmpMIContainer_all.AmountDebet)
                            OR 0 <> SUM (tmpMIContainer_all.AmountKredit)
                       )

   , tmpMov_Param AS (SELECT tmp.MovementItemId
                           , Object_InfoMoneyDetail.ObjectCode    AS InfoMoneyDetailCode
                           , Object_InfoMoneyDetail.ValueData     AS InfoMoneyDetailName
                           , Object_CommentInfoMoney.ObjectCode   AS CommentInfoMoneyCode
                           , Object_CommentInfoMoney.ValueData    AS CommentInfoMoneyName
                           , Object_Insert.ValueData              AS InsertName
                           , MovementDate_Insert.ValueData        AS InsertDate
                           , Object_Update.ValueData              AS UpdateName
                           , MovementDate_Update.ValueData        AS UpdateDate
                      FROM (SELECT DISTINCT tmpMIContainer.MovementItemId FROM tmpMIContainer) AS tmp
                            LEFT JOIN MovementItem ON MovementItem.Id = tmp.MovementItemId

                            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoneyDetail
                                                             ON MILinkObject_InfoMoneyDetail.MovementItemId = tmp.MovementItemId
                                                            AND MILinkObject_InfoMoneyDetail.DescId = zc_MILinkObject_InfoMoneyDetail()
                            LEFT JOIN Object AS Object_InfoMoneyDetail ON Object_InfoMoneyDetail.Id = MILinkObject_InfoMoneyDetail.ObjectId

                            LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentInfoMoney
                                                             ON MILinkObject_CommentInfoMoney.MovementItemId = tmp.MovementItemId
                                                            AND MILinkObject_CommentInfoMoney.DescId         = zc_MILinkObject_CommentInfoMoney()
                            LEFT JOIN Object AS Object_CommentInfoMoney ON Object_CommentInfoMoney.Id = MILinkObject_CommentInfoMoney.ObjectId

                            LEFT JOIN MovementDate AS MovementDate_Insert
                                                   ON MovementDate_Insert.MovementId = MovementItem.MovementId
                                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                            LEFT JOIN MovementLinkObject AS MLO_Insert
                                                         ON MLO_Insert.MovementId = MovementItem.MovementId
                                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
                            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

                            LEFT JOIN MovementDate AS MovementDate_Update
                                                   ON MovementDate_Update.MovementId = MovementItem.MovementId
                                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()
                            LEFT JOIN MovementLinkObject AS MLO_Update
                                                         ON MLO_Update.MovementId = MovementItem.MovementId
                                                        AND MLO_Update.DescId = zc_MovementLinkObject_Update()
                            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId

                     )
       -- Результат
       SELECT tmpMIContainer.ContainerId
            , tmpMIContainer.ServiceDateId
            , ((DATE_PART ('YEAR', ObjectDate_ServiceDate_Value.ValueData) :: Integer) :: TVarChar
     || '-' || zfCalc_MonthNumber (ObjectDate_ServiceDate_Value.ValueData)
     || '-' || zfCalc_MonthName (ObjectDate_ServiceDate_Value.ValueData)
              ) ::TVarChar AS ServiceDate
            , Object_Unit.Id         AS UnitId
            , Object_Unit.ObjectCode AS UnitCode
            , Object_Unit.ValueData  AS UnitName
            , ObjectString_Unit_GroupNameFull.ValueData AS GroupNameFull_Unit
            , TRIM (COALESCE (ObjectString_Unit_GroupNameFull.ValueData,'')||' '||Object_Unit.ValueData) ::TVarChar AS NameFull_unit
            , Object_ParentUnit.ValueData               AS ParentName_Unit
            , tmpUnit.BuildingName           ::TVarChar AS BuildingName_unit
            , CASE WHEN tmpUnit.FloorName <> tmpUnit.BuildingName THEN tmpUnit.FloorName ELSE '' END ::TVarChar AS FloorName_unit

            , Object_InfoMoney.ObjectCode AS InfoMoneyCode
            , Object_InfoMoney.ValueData  AS InfoMoneyName
            , Object_Account.ObjectCode   AS AccountCode
            , Object_Account.ValueData    AS AccountName

            , CAST (CASE WHEN tmpMIContainer.AmountRemainsStart > 0 OR  1=1 THEN  1 * tmpMIContainer.AmountRemainsStart ELSE 0 END AS TFloat) AS AmountDebetStart
            , CAST (CASE WHEN tmpMIContainer.AmountRemainsStart < 0 AND 1=0 THEN -1 * tmpMIContainer.AmountRemainsStart ELSE 0 END AS TFloat) AS AmountKreditStart
            , CAST (tmpMIContainer.AmountDebet AS TFloat)  AS AmountDebet
            , CAST (tmpMIContainer.AmountKredit AS TFloat) AS AmountKredit
            , CAST (CASE WHEN tmpMIContainer.AmountRemainsEnd > 0 OR  1=1 THEN  1 * tmpMIContainer.AmountRemainsEnd ELSE 0 END AS TFloat) AS AmountDebetEnd
            , CAST (CASE WHEN tmpMIContainer.AmountRemainsEnd < 0 AND 1=0 THEN -1 * tmpMIContainer.AmountRemainsEnd ELSE 0 END AS TFloat) AS AmountKreditEnd

            , tmpMIContainer.OperDate :: TDateTime AS OperDate
            , tmpMov_Param.InfoMoneyDetailCode
            , tmpMov_Param.InfoMoneyDetailName
            , tmpMov_Param.CommentInfoMoneyCode
            , tmpMov_Param.CommentInfoMoneyName
            , tmpMov_Param.InsertName
            , tmpMov_Param.InsertDate
            , tmpMov_Param.UpdateName
            , tmpMov_Param.UpdateDate

            , tmpMIContainer_rem.AmountRemainsStart :: TFloat AS AmountRemainsStart_info
            , tmpMIContainer_rem.AmountRemainsEnd   :: TFloat AS AmountRemainsEnd_info

       FROM tmpMIContainer
           LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpMIContainer.InfoMoneyId
           LEFT JOIN Object AS Object_Account ON Object_Account.Id = tmpMIContainer.AccountId
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMIContainer.UnitId
           LEFT JOIN Object AS Object_ServiceDate ON Object_ServiceDate.Id = tmpMIContainer.ServiceDateId
           LEFT JOIN ObjectString AS ObjectString_Unit_GroupNameFull
                                  ON ObjectString_Unit_GroupNameFull.ObjectId = Object_Unit.Id
                                 AND ObjectString_Unit_GroupNameFull.DescId = zc_ObjectString_Unit_GroupNameFull()
           LEFT JOIN ObjectDate AS ObjectDate_ServiceDate_Value
                                ON ObjectDate_ServiceDate_Value.ObjectId = Object_ServiceDate.Id
                               AND ObjectDate_ServiceDate_Value.DescId   = zc_ObjectDate_ServiceDate_Value()

           LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
           LEFT JOIN Object AS Object_ParentUnit ON Object_ParentUnit.Id = ObjectLink_Unit_Parent.ChildObjectId

           LEFT JOIN tmpUnit ON tmpUnit.UnitId = tmpMIContainer.UnitId
           LEFT JOIN tmpMov_Param ON tmpMov_Param.MovementItemId = tmpMIContainer.MovementItemId
           LEFT JOIN tmpMIContainer_rem ON tmpMIContainer_rem.ContainerId = tmpMIContainer.ContainerId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.05.22         *
 23.02.22         *
*/

-- тест
-- SELECT * FROM gpReport_UnitBalance (inStartDate := '01.12.2021', inEndDate:= '01.02.2022', inServiceDate:= '01.12.2021', inUnitGroupId:= 0, inInfoMoneyId:= 0, inIsAll:= FALSE , inSession:= zfCalc_UserAdmin())
