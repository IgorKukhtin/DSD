-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpSelect_GoodsSearchRemains (TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_GoodsSearchRemains (TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsSearchRemains(
    IN inCodeSearch     TVarChar,    -- поиск товаров по коду
    IN inGoodsSearch    TVarChar,    -- поиск товаров
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id integer, GoodsCode Integer, GoodsName TVarChar
             , NDSkindName TVarChar
             , NDS TFloat
             , GoodsGroupName TVarChar
             , UnitId integer, UnitName TVarChar
             , AreaName TVarChar
             , Address_Unit TVarChar
             , Phone_Unit TVarChar
             , ProvinceCityName_Unit TVarChar
             , JuridicalName_Unit TVarChar
             , Phone TVarChar
             , Amount TFloat
             , AmountIncome TFloat
             , AmountReserve TFloat
             , AmountAll TFloat
             , PriceSale  TFloat
             , SummaSale TFloat
             , PriceSaleIncome  TFloat
             , MinExpirationDate TDateTime
             , DailyCheck TFloat
             , DailySale TFloat
             , Color_calc Integer
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbRemainsDate TDateTime;
   DECLARE vbisAdmin Boolean;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    vbRemainsDate = CURRENT_TIMESTAMP;
    vbisAdmin := EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin()) 
                 AND vbUserId NOT IN (183242);

    -- Результат
    RETURN QUERY
        WITH
        tmpGoods AS (SELECT  Goods_Retail.Id
                     FROM Object_Goods_Main AS Goods_Main
                          INNER JOIN Object_Goods_Retail AS Goods_Retail
                                                         ON Goods_Main.Id  = Goods_Retail.GoodsMainId
                     WHERE (position(','||CAST(Goods_Main.ObjectCode AS TVarChar)||',' IN ','||inCodeSearch||',') > 0 AND inCodeSearch <> '')
                        OR (upper(Goods_Main.Name) ILIKE UPPER('%'||inGoodsSearch||'%')  AND inGoodsSearch <> '' AND inCodeSearch = '')
                     )

      , containerCount AS (SELECT Container.Id                AS ContainerId
                                , Container.Amount
                                , Container.ObjectID          AS GoodsId
                                , Container.WhereObjectId     AS UnitId
                           FROM Container 
                           WHERE Container.ObjectID in (SELECT tmpGoods.Id FROM tmpGoods)
                             AND Container.descid = zc_container_count()
                             AND Container.whereobjectid IN (SELECT T1.ID FROM gpSelect_Object_Unit(False, '3') AS T1)
                           )

      , tmpcontainerCount AS (SELECT ContainerCount.Amount - COALESCE(SUM(MIContainer.Amount), 0) AS Amount
                                   , ContainerCount.GoodsId
                                   , ContainerCount.UnitId
                                   , ContainerCount.ContainerId
                              FROM ContainerCount
                                  LEFT JOIN MovementItemContainer AS MIContainer
                                                                  ON MIContainer.ContainerId = ContainerCount.ContainerId
                                                                 AND MIContainer.OperDate >= vbRemainsDate
                              GROUP BY ContainerCount.ContainerId, ContainerCount.Amount, ContainerCount.GoodsId , ContainerCount.UnitId
                              HAVING (ContainerCount.Amount - COALESCE(SUM(MIContainer.Amount), 0)) <> 0
                             )

      , containerCheck AS (SELECT
                                 ContainerCount.GoodsId
                               , ContainerCount.UnitId
                               , COALESCE(SUM(-1.0 * MIContainer.Amount), 0) AS DailyCheck
                          FROM ContainerCount
                              LEFT JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.ContainerId = ContainerCount.ContainerId
                                                             AND MIContainer.OperDate >= CURRENT_TIMESTAMP - INTERVAL '1 day'
                                                             AND MIContainer.OperDate < CURRENT_TIMESTAMP
                                                             AND MIContainer.MovementDescId in (zc_Movement_Check())
                          GROUP BY ContainerCount.GoodsId , ContainerCount.UnitId
                      )
      , containerSale AS (SELECT
                                 ContainerCount.GoodsId
                               , ContainerCount.UnitId
                               , COALESCE(SUM(-1.0 * MIContainer.Amount), 0) AS DailySale
                          FROM ContainerCount
                              LEFT JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.ContainerId = ContainerCount.ContainerId
                                                             AND MIContainer.OperDate >= CURRENT_TIMESTAMP - INTERVAL '1 day'
                                                             AND MIContainer.OperDate < CURRENT_TIMESTAMP
                                                             AND MIContainer.MovementDescId in (zc_Movement_Sale())
                          GROUP BY ContainerCount.GoodsId , ContainerCount.UnitId
                      )

      , tmpData_all AS (SELECT SUM(tmpcontainerCount.Amount)    AS Amount
                             , tmpcontainerCount.GoodsId
                             , tmpcontainerCount.UnitId
                             , min (COALESCE(MIDate_ExpirationDate.ValueData,zc_DateEnd()))::TDateTime AS MinExpirationDate -- Срок годности
                        FROM tmpcontainerCount

                            -- находим партию для определения срока годности остатка
                            LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                          ON ContainerLinkObject_MovementItem.Containerid =  tmpcontainerCount.ContainerId
                                                         AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                            LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                            -- элемент прихода
                            LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                            -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                            LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                        ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                       AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                            -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                            LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

                            LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                              ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                             AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                        GROUP BY tmpcontainerCount.GoodsId, tmpcontainerCount.UnitId
                        )

      , tmpData AS (SELECT tmpData_all.UnitId
                         , tmpData_all.GoodsId
                         , SUM (tmpData_all.Amount)   AS Amount
                         , min (tmpData_all.MinExpirationDate) AS MinExpirationDate
                    FROM  tmpData_all
                    GROUP BY tmpData_all.GoodsId
                           , tmpData_all.UnitId
                    HAVING (SUM (tmpData_all.Amount) <> 0)
                    )

      , tmpIncome AS (SELECT MovementLinkObject_To.ObjectId          AS UnitId
                           , MI_Income.ObjectId                      AS GoodsId
                           , SUM(COALESCE (MI_Income.Amount, 0))     AS AmountIncome
                           , SUM(COALESCE (MI_Income.Amount, 0) * COALESCE(MIFloat_PriceSale.ValueData,0))  AS SummSale
                      FROM Movement AS Movement_Income
                           INNER JOIN MovementDate AS MovementDate_Branch
                                                   ON MovementDate_Branch.MovementId = Movement_Income.Id
                                                  AND MovementDate_Branch.DescId = zc_MovementDate_Branch()
                                                  AND date_trunc('day', MovementDate_Branch.ValueData) between date_trunc('day', CURRENT_TIMESTAMP)-interval '1 day' AND date_trunc('day', CURRENT_TIMESTAMP)

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                         ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                           LEFT JOIN MovementItem AS MI_Income
                                                  ON MI_Income.MovementId = Movement_Income.Id
                                                 AND MI_Income.isErased   = False

                           LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                       ON MIFloat_PriceSale.MovementItemId = MI_Income.Id
                                                      AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

                           -- left join  Object ON Object.id = MI_Income.ObjectId
                           -- left join  Object AS Object1 ON Object1.id = MovementLinkObject_To.ObjectId
                       WHERE Movement_Income.DescId = zc_Movement_Income()
                         AND Movement_Income.StatusId = zc_Enum_Status_UnComplete()
                       GROUP BY MI_Income.ObjectId
                              , MovementLinkObject_To.ObjectId
                    )

       -- Отложенные чеки
      , tmpMovReserve AS (SELECT Movement.Id
                               , MovementLinkObject_Unit.ObjectId AS UnitId
                          FROM MovementBoolean AS MovementBoolean_Deferred
                             INNER JOIN Movement ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                                AND Movement.DescId = zc_Movement_Check()
                                                AND Movement.StatusId = zc_Enum_Status_UnComplete()
                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                          WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                            AND MovementBoolean_Deferred.ValueData = TRUE
                         UNION ALL
                          SELECT Movement.Id
                               , MovementLinkObject_Unit.ObjectId AS UnitId
                          FROM MovementString AS MovementString_CommentError
                             INNER JOIN Movement ON Movement.Id     = MovementString_CommentError.MovementId
                                                AND Movement.DescId = zc_Movement_Check()
                                                AND Movement.StatusId = zc_Enum_Status_UnComplete()
                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                         WHERE MovementString_CommentError.DescId = zc_MovementString_CommentError()
                           AND MovementString_CommentError.ValueData <> ''
                         )
      , tmpReserve AS (SELECT tmpMovReserve.UnitId             AS UnitId
                            , MovementItem.ObjectId            AS GoodsId
                            , Sum(MovementItem.Amount)::TFloat AS Amount
                       FROM tmpMovReserve
                            INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovReserve.Id
                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                   AND MovementItem.isErased   = FALSE
                       GROUP BY MovementItem.ObjectId, tmpMovReserve.UnitId
                       )
      , tmpUnitAll AS (SELECT *
                       FROM Object AS Object_Unit
                       WHERE Object_Unit.DescId = zc_Object_Unit()
                       )
      , tmpObjectLink AS (SELECT *
                          FROM ObjectLink
                          WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpUnitAll.Id FROM tmpUnitAll)
                            AND ObjectLink.DescId IN (zc_ObjectLink_Unit_Area()
                                                    , zc_ObjectLink_Unit_Juridical()
                                                    , zc_ObjectLink_Unit_ProvinceCity())
                          )
      , tmpUnit AS (SELECT Object_Unit.Id                               AS UnitId
                         , Object_Unit.ValueData                        AS UnitName
                         , Object_Area.ValueData                        AS AreaName
                         , Object_ProvinceCity.ValueData                AS ProvinceCityName_Unit
                         , Object_Juridical.ValueData                   AS JuridicalName_Unit
                         , ObjectString_Phone.ValueData                 AS Phone
                         , ObjectString_Unit_Address.ValueData          AS Address_Unit
                         , ObjectString_Unit_Phone.ValueData            AS Phone_Unit
                    FROM tmpUnitAll AS Object_Unit
                         LEFT JOIN tmpObjectLink AS ObjectLink_Unit_Area
                                                 ON ObjectLink_Unit_Area.ObjectId = Object_Unit.Id
                                                AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
                         LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Unit_Area.ChildObjectId

                         LEFT JOIN tmpObjectLink AS ObjectLink_Unit_Juridical
                                                 ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                         LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

                         LEFT JOIN tmpObjectLink AS ObjectLink_Unit_ProvinceCity
                                                 ON ObjectLink_Unit_ProvinceCity.ObjectId = Object_Unit.Id
                                                AND ObjectLink_Unit_ProvinceCity.DescId = zc_ObjectLink_Unit_ProvinceCity()
                         LEFT JOIN Object AS Object_ProvinceCity ON Object_ProvinceCity.Id = ObjectLink_Unit_ProvinceCity.ChildObjectId

                         LEFT JOIN ObjectString AS ObjectString_Unit_Address
                                                ON ObjectString_Unit_Address.ObjectId = Object_Unit.Id
                                               AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()
                         LEFT JOIN ObjectString AS ObjectString_Unit_Phone
                                                ON ObjectString_Unit_Phone.ObjectId = Object_Unit.Id
                                               AND ObjectString_Unit_Phone.DescId = zc_ObjectString_Unit_Phone()

                         LEFT JOIN ObjectLink AS ContactPerson_ContactPerson_Object
                                              ON ContactPerson_ContactPerson_Object.ChildObjectId = Object_Unit.Id
                                             AND ContactPerson_ContactPerson_Object.DescId = zc_ObjectLink_ContactPerson_Object()

                         LEFT JOIN ObjectString AS ObjectString_Phone
                                                ON ObjectString_Phone.ObjectId = ContactPerson_ContactPerson_Object.ObjectId
                                               AND ObjectString_Phone.DescId = zc_ObjectString_ContactPerson_Phone()
                    )

      , tmpGoodsParams AS (SELECT Object_Goods.Id                AS GoodsId
                                , Object_Goods.ObjectCode                          AS GoodsCode
                                , Object_Goods.ValueData                           AS GoodsName
                                , Object_GoodsGroup.ValueData                      AS GoodsGroupName
                                , Object_NDSKind.ValueData                         AS NDSKindName
                                , ObjectFloat_NDSKind_NDS.ValueData                AS NDS
                               FROM tmpGoods
                                 LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoods.Id

                                 LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                      ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpGoods.Id
                                                     AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()

                                 LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                                 LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                                      ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                                                     AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
                                 LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId

                                 LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                       ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId
                                                      AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                           )

      , tmpPrice_View AS (SELECT Price_Goods.ObjectId        AS Id
                               , Price_Unit.ChildObjectId    AS UnitId
                               , Price_Goods.ChildObjectId   AS GoodsId
                          FROM ObjectLink AS Price_Goods
                               LEFT JOIN ObjectLink AS Price_Unit
                                      ON Price_Unit.ObjectId = Price_Goods.ObjectId
                                     AND Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                          WHERE Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                            AND Price_Goods.ChildObjectId IN (SELECT tmpGoods.Id FROM tmpGoods )
                          )

      , tmpObjectHistory_Price AS (SELECT *
                                   FROM ObjectHistory AS ObjectHistory_Price
                                   WHERE ObjectHistory_Price.ObjectId IN (SELECT DISTINCT tmpPrice_View.Id FROM tmpPrice_View)
                                     AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                     AND CURRENT_TIMESTAMP >= ObjectHistory_Price.StartDate AND CURRENT_TIMESTAMP < ObjectHistory_Price.EndDate
                                  )

      , tmpObjectHistoryFloat_Price AS (SELECT *
                                        FROM ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                        WHERE ObjectHistoryFloat_Price.ObjectHistoryId IN (SELECT DISTINCT tmpObjectHistory_Price.Id FROM tmpObjectHistory_Price)
                                          AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
                                       )

        --РЕЗУЛЬТАТ
        SELECT tmpGoodsParams.GoodsId
             , tmpGoodsParams.GoodsCode
             , tmpGoodsParams.GoodsName
             , tmpGoodsParams.NDSkindName
             , tmpGoodsParams.NDS
             , tmpGoodsParams.GoodsGroupName
             , Object_Unit.UnitId
             , Object_Unit.UnitName
             , Object_Unit.AreaName
             , Object_Unit.Address_Unit
             , Object_Unit.Phone_Unit
             , Object_Unit.ProvinceCityName_Unit
             , Object_Unit.JuridicalName_Unit
             , Object_Unit.Phone
             , COALESCE (tmpData.Amount,0)         :: TFloat AS Amount
             , COALESCE (tmpIncome.AmountIncome,0)                                   :: TFloat AS AmountIncome
             , COALESCE (tmpReserve.Amount, 0)                                       :: TFloat AS AmountReserve
             , (COALESCE (tmpData.Amount,0) + COALESCE (tmpIncome.AmountIncome,0))   :: TFloat AS AmountAll
             , COALESCE (ObjectHistoryFloat_Price.ValueData, 0)                      :: TFloat AS PriceSale
             , (tmpData.Amount * COALESCE (ObjectHistoryFloat_Price.ValueData, 0))   :: TFloat AS SummaSale
             , CASE WHEN COALESCE(tmpIncome.AmountIncome,0) <> 0 THEN COALESCE (tmpIncome.SummSale,0) / COALESCE (tmpIncome.AmountIncome,0) ELSE 0 END  :: TFloat AS PriceSaleIncome
             , tmpData.MinExpirationDate  ::TDateTime
             , containerCheck.DailyCheck:: TFloat
             , containerSale.DailySale:: TFloat
             , CASE WHEN vbisAdmin AND COALESCE (tmpData.Amount,0) < (COALESCE (containerCheck.DailyCheck,0) + COALESCE (containerSale.DailySale,0)) THEN zc_Color_Red()
                    WHEN vbisAdmin AND COALESCE (tmpData.Amount,0) > (COALESCE (containerCheck.DailyCheck,0) + COALESCE (containerSale.DailySale,0)) * 3 THEN zc_Color_Greenl()
                    ELSE zc_Color_White() END      AS Color_calc

        FROM tmpGoods
            LEFT JOIN tmpUnit AS Object_Unit ON 1=1
            LEFT JOIN tmpData ON tmpData.GoodsId = tmpGoods.Id
                             AND tmpData.UnitId  = Object_Unit.UnitId

            LEFT JOIN tmpIncome ON tmpIncome.GoodsId = tmpGoods.Id
                               AND tmpIncome.UnitId  = Object_Unit.UnitId

            LEFT JOIN tmpReserve ON tmpReserve.GoodsId = tmpGoods.Id
                                AND tmpReserve.UnitId  = Object_Unit.UnitId

            LEFT JOIN tmpGoodsParams ON tmpGoodsParams.GoodsId = tmpGoods.Id

            LEFT OUTER JOIN tmpPrice_View AS Object_Price
                                          ON Object_Price.GoodsId = tmpGoods.Id
                                         AND Object_Price.UnitId  = Object_Unit.UnitId

            -- получаем значения цены и НТЗ из истории значений на дату на начало
            LEFT JOIN tmpObjectHistory_Price AS ObjectHistory_Price
                                             ON ObjectHistory_Price.ObjectId = Object_Price.Id

            LEFT JOIN tmpObjectHistoryFloat_Price AS ObjectHistoryFloat_Price
                                                  ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id

            LEFT JOIN containerCheck ON containerCheck.GoodsId = tmpGoods.Id
                                    AND containerCheck.UnitId  = Object_Unit.UnitId

            LEFT JOIN containerSale ON containerSale.GoodsId = tmpGoods.Id
                                    AND containerSale.UnitId  = Object_Unit.UnitId

          WHERE COALESCE(tmpData.Amount,0)<>0 OR COALESCE(tmpIncome.AmountIncome,0)<>0
          ORDER BY Object_Unit.UnitName
                 , tmpGoodsParams.GoodsGroupName
                 , tmpGoodsParams.GoodsName
           ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.09.19         *
 11.12.18         * AmountReserve
 28.08.18         *
 05.01.18         *
 08.07.16         *
 11.05.16         *
 18.04.16         *
*/

-- тест
-- SELECT * FROM gpSelect_GoodsSearchRemains ('4282', 'глюкоз', inSession := '3')
-- select * from gpSelect_GoodsSearchRemains(inCodeSearch := '' , inGoodsSearch := 'маска защит' ,  inSession := '3');

