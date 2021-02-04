 -- Function: gpReport_SalesOfTermDrugsUnit()

DROP FUNCTION IF EXISTS gpReport_SalesOfTermDrugsUnit (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SalesOfTermDrugsUnit(
    IN inStartDate        TDateTime,
    IN inEndDate          TDateTime,
    IN inDaysBeforeDelay  Integer  ,  -- Количество дней до окончания срока годности
    IN inUnitId           Integer  ,  -- Подразделение
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (UserId Integer, UserName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar

             , Amount TFloat, Price TFloat, Summa TFloat
             , OperDate TDateTime, ExpirationDate TDateTime, DaysBeforeDelay Integer
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    -- Результат
    RETURN QUERY
    WITH tmpMIContainer AS (SELECT MovementItemContainer.ContainerId
                                , MovementItemContainer.MovementId
                                , MovementItemContainer.OperDate
                                , MovementItemContainer.Price
                                , MovementItemContainer.ObjectId_Analyzer       AS GoodsId
                                , MovementItemContainer.WhereObjectId_Analyzer  AS UnitId
                                , -1.0 * MovementItemContainer.Amount           AS Amount
                           FROM MovementItemContainer
                           WHERE MovementItemContainer.DescId = zc_MIContainer_CountPartionDate()
                             AND MovementItemContainer.MovementDescId = zc_Movement_Check()
                             AND MovementItemContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                             AND MovementItemContainer.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                             AND MovementItemContainer.WhereObjectId_Analyzer = inUnitId),
         tmpExpirationDate AS (SELECT tmpMIContainer.*
                                    , COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd())                      AS ExpirationDate
                                    , extract('DAY' from COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd()) - 
                                                         tmpMIContainer.OperDate)::Integer                              AS DaysBeforeDelay
                               FROM tmpMIContainer                            

                                    LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = tmpMIContainer.ContainerId
                                                                 AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
                                                                 
                                    LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                         ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                                        AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                              )
                             
                             
  SELECT Object_User.Id                                    AS UserId
       , Object_User.ValueData                             AS UserName
       , Object_Goods.Id                                   AS GoodsId
       , Object_Goods.ObjectCode                           AS GoodsCode
       , Object_Goods.ValueData                            AS GoodsName
       , tmpExpirationDate.Amount::TFloat                  AS Amount
       , tmpExpirationDate.Price::TFloat                   AS Summs
       , Round(tmpExpirationDate.Amount * tmpExpirationDate.Price, 2)::TFloat  AS Summs
       , tmpExpirationDate.OperDate
       , tmpExpirationDate.ExpirationDate
       , tmpExpirationDate.DaysBeforeDelay
  FROM tmpExpirationDate  
  
       INNER JOIN Object AS Object_Goods ON Object_Goods.ID = tmpExpirationDate.GoodsId

       LEFT JOIN MovementLinkObject AS MLO_Insert
                                    ON MLO_Insert.MovementId = tmpExpirationDate.MovementId
                                   AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
                                   
       LEFT JOIN MovementLinkObject AS MovementLinkObject_UserConfirmedKind
                                    ON MovementLinkObject_UserConfirmedKind.MovementId = tmpExpirationDate.MovementId
                                   AND MovementLinkObject_UserConfirmedKind.DescId = zc_MovementLinkObject_UserConfirmedKind()
       
       LEFT JOIN Object AS Object_User ON Object_User.Id = COALESCE(MLO_Insert.ObjectId, MovementLinkObject_UserConfirmedKind.ObjectId)
       
  WHERE tmpExpirationDate.DaysBeforeDelay <= inDaysBeforeDelay
  ORDER BY Object_User.ValueData, Object_Goods.ValueData;
END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 03.02.21                                                                     *
*/

-- тест
--
-- 
select * from gpReport_SalesOfTermDrugsUnit(inStartDate := ('01.01.2021')::TDateTime, inEndDate := ('31.01.2021')::TDateTime, inDaysBeforeDelay := 90, inUnitId := 183292 , inSession := '3');         