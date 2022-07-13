-- Function: gpSelect_GoodsSearchRemains_1303()

DROP FUNCTION IF EXISTS gpSelect_GoodsSearchRemains_1303 (TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsSearchRemains_1303(
    IN inCodeSearch        TVarChar,    -- поиск товаров по коду
    IN inGoodsSearch       TVarChar,    -- поиск товаров
    IN inPartnerMedicalID  Integer,     -- Медцентр
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id integer, GoodsCode Integer, GoodsName TVarChar
             , NDSkindName TVarChar
             , NDS TFloat
             , GoodsGroupName TVarChar
             , UnitId integer, UnitName TVarChar
             , PartnerMedicalName TVarChar
             , AreaName TVarChar
             , RetailName TVarChar
             , Address_Unit TVarChar
             , Phone_Unit TVarChar
             , ProvinceCityName_Unit TVarChar
             , JuridicalName_Unit TVarChar
             , Phone TVarChar
             , PriceOptSP_1303 TFloat
             , PriceSale_1303 TFloat
             , Amount TFloat
             , AmountIncome TFloat
             , AmountReserve TFloat
             , AmountAll TFloat
             , PriceSale  TFloat
             , SummaSale TFloat
             , DateChange TDateTime
             , PriceSaleIncome  TFloat
             , MinExpirationDate TDateTime
             , DailyCheck TFloat
             , DailySale TFloat
             , DeferredSend TFloat
             , DeferredSendIn TFloat
             , PriceSite TFloat
             , DateChangeSite TDateTime
             , Price_min TFloat
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
        tmpGoods1303 AS (select * from gpSelect_GoodsSPRegistry_1303_All(inSession := inSession))
      , tmpGoods AS (SELECT Goods_Retail.Id
                          , Goods_Main.ObjectCode
                          , Goods_Main.Name
                          , Goods_Main.GoodsGroupId
                          , Goods_Main.NDSKindId
                     FROM Object_Goods_Main AS Goods_Main
                          INNER JOIN Object_Goods_Retail AS Goods_Retail
                                                         ON Goods_Main.Id  = Goods_Retail.GoodsMainId
                                                        AND Goods_Retail.RetailId = vbObjectId 
                          INNER JOIN tmpGoods1303 ON tmpGoods1303.GoodsId = Goods_Retail.Id
                     WHERE (','||inCodeSearch||',' ILIKE '%,'||CAST(Goods_Main.ObjectCode AS TVarChar)||',%' AND inCodeSearch <> '')
                        OR (upper(Goods_Main.Name) ILIKE UPPER('%'||inGoodsSearch||'%')  AND inGoodsSearch <> '' AND inCodeSearch = '')
                     )

      , containerAll AS (SELECT Container.descid
                              , Container.Id                AS ContainerId
                              , Container.ParentId
                              , Container.Amount
                              , Container.ObjectID          AS GoodsId
                              , Container.WhereObjectId     AS UnitId
                         FROM Container
                         WHERE Container.ObjectID in (SELECT tmpGoods.Id FROM tmpGoods)
                           AND Container.descid IN (zc_Container_Count(), zc_Container_CountPartionDate())
                           AND Container.whereobjectid IN (SELECT T1.ID FROM gpSelect_Object_Unit(False, '3') AS T1)
                         )
      , containerPD AS (SELECT Container.ParentId
                             , MIN(COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd()))  AS ExpirationDate
                        FROM containerAll AS Container

                             LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.ContainerId
                                                          AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                             LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                  ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId 
                                                 AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                                 
                        WHERE Container.DescId = zc_Container_CountPartionDate()
                          AND Container.Amount > 0
                        GROUP BY Container.ParentId
                         )
      , containerCount AS (SELECT Container.ContainerId       AS ContainerId
                                , Container.Amount
                                , Container.GoodsId           AS GoodsId
                                , Container.UnitId            AS UnitId
                           FROM containerAll AS Container
                           WHERE Container.descid = zc_container_count()
                           )

      , tmpMIC AS (SELECT MIContainer.ContainerId
                        , MIContainer.Amount
                        , MIContainer.MovementDescId
                   FROM MovementItemContainer AS MIContainer
                   WHERE MIContainer.ContainerId IN (SELECT ContainerCount.ContainerId FROM ContainerCount)
                     AND MIContainer.OperDate >= CURRENT_TIMESTAMP - INTERVAL '1 day'
                     AND MIContainer.MovementDescId in (zc_Movement_Check(), zc_Movement_Sale())
                      )
      , containerCheck AS (SELECT
                                 ContainerCount.GoodsId
                               , ContainerCount.UnitId
                               , COALESCE(SUM(-1.0 * MIContainer.Amount), 0) AS DailyCheck
                          FROM ContainerCount
                              LEFT JOIN tmpMIC AS MIContainer
                                                              ON MIContainer.ContainerId = ContainerCount.ContainerId
                                                             AND MIContainer.MovementDescId = zc_Movement_Check()
                          GROUP BY ContainerCount.GoodsId , ContainerCount.UnitId
                      )
      , containerSale AS (SELECT
                                 ContainerCount.GoodsId
                               , ContainerCount.UnitId
                               , COALESCE(SUM(-1.0 * MIContainer.Amount), 0) AS DailySale
                          FROM ContainerCount
                              LEFT JOIN tmpMIC AS MIContainer
                                                              ON MIContainer.ContainerId = ContainerCount.ContainerId
                                                             AND MIContainer.MovementDescId = zc_Movement_Sale()
                          GROUP BY ContainerCount.GoodsId , ContainerCount.UnitId
                      )
      , tmpCLO AS (SELECT * FROM ContainerlinkObject  AS ContainerLinkObject_MovementItem
                   WHERE ContainerLinkObject_MovementItem.Containerid IN (SELECT containerCount.ContainerId FROM containerCount))

      , tmpData_Inc AS (SELECT containerCount.Amount
                             , containerCount.GoodsId
                             , containerCount.UnitId
                             , COALESCE (MIFloat_MovementItem.ValueData :: Integer,Object_PartionMovementItem.ObjectCode)    AS MI_Income
                             , containerPD.ExpirationDate
                        FROM containerCount

                            -- находим партию для определения срока годности остатка
                            LEFT JOIN tmpCLO AS ContainerLinkObject_MovementItem
                                                          ON ContainerLinkObject_MovementItem.Containerid =  containerCount.ContainerId
                                                         AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                            LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                            -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                            LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                        ON MIFloat_MovementItem.MovementItemId = Object_PartionMovementItem.ObjectCode
                                                       AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                                       
                            LEFT JOIN containerPD ON containerPD.ParentId = containerCount.ContainerId
                        WHERE containerCount.Amount > 0
                        )
      , tmpMID AS (SELECT * FROM MovementItemDate  AS MIDate_ExpirationDate
                   WHERE MIDate_ExpirationDate.MovementItemId IN (SELECT tmpData_Inc.MI_Income FROM tmpData_Inc))

      , tmpData_all AS (SELECT SUM(tmpData_Inc.Amount)    AS Amount
                             , tmpData_Inc.GoodsId
                             , tmpData_Inc.UnitId
                             , min (COALESCE(tmpData_Inc.ExpirationDate, MIDate_ExpirationDate.ValueData, zc_DateEnd()))::TDateTime AS MinExpirationDate -- Срок годности
                        FROM tmpData_Inc

                            LEFT OUTER JOIN tmpMID  AS MIDate_ExpirationDate
                                                              ON MIDate_ExpirationDate.MovementItemId = tmpData_Inc.MI_Income
                                                             AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                        GROUP BY tmpData_Inc.GoodsId, tmpData_Inc.UnitId
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
                                                  AND date_trunc('day', MovementDate_Branch.ValueData) between date_trunc('day', CURRENT_TIMESTAMP)-interval '1 month' AND date_trunc('day', CURRENT_TIMESTAMP)

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

          -- Отложенные перемещения
      , tmpMovementID AS (SELECT
                                 Movement.Id
                               , Movement.DescId
                          FROM Movement
                          WHERE Movement.DescId IN (zc_Movement_Send(), zc_Movement_Check())
                            AND Movement.StatusId = zc_Enum_Status_UnComplete()
                            AND Movement.OperDate > CURRENT_DATE - INTERVAL '100 DAY'
                        )
     , tmpMovementSend AS (SELECT
                                  Movement.Id
                                , MovementLinkObject_To.ObjectId                 AS UnitID
                           FROM tmpMovementID AS Movement

                                INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                           ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                          AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                                          AND MovementBoolean_Deferred.ValueData = TRUE

                                INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                              ON MovementLinkObject_To.MovementId = Movement.Id
                                                             AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                           WHERE Movement.DescId = zc_Movement_Send()
                           )
     , tmpDeferredSend AS (SELECT
                                  Container.WhereObjectId             AS UnitID
                                , Container.ObjectId                  AS GoodsId
                                , SUM(- MovementItemContainer.Amount) AS Amount
                           FROM tmpMovementSend AS Movement

                                INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = Movement.Id
                                                                AND MovementItemContainer.DescId = zc_Container_Count()

                               INNER JOIN Container ON Container.Id = MovementItemContainer.ContainerId

                           GROUP BY Container.WhereObjectId
                                  , Container.ObjectId
                         )
     , tmpDeferredSendIn AS (SELECT
                                  Movement.UnitID                     AS UnitID
                                , Container.ObjectId                  AS GoodsId
                                , SUM(- MovementItemContainer.Amount) AS Amount
                           FROM tmpMovementSend AS Movement

                                INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = Movement.Id
                                                                AND MovementItemContainer.DescId = zc_Container_Count()

                               INNER JOIN Container ON Container.Id = MovementItemContainer.ContainerId

                           GROUP BY Movement.UnitID
                                  , Container.ObjectId
                         )
       -- Отложенные чеки
      , tmpMovReserve AS (SELECT Movement.Id
                               , MovementLinkObject_Unit.ObjectId AS UnitId
                          FROM MovementBoolean AS MovementBoolean_Deferred
                             INNER JOIN tmpMovementID AS Movement 
                                                      ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                                     AND Movement.DescId = zc_Movement_Check()
                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                          WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                            AND MovementBoolean_Deferred.ValueData = TRUE
                         UNION ALL
                          SELECT Movement.Id
                               , MovementLinkObject_Unit.ObjectId AS UnitId
                          FROM MovementString AS MovementString_CommentError
                             INNER JOIN tmpMovementID AS Movement 
                                                      ON Movement.Id     = MovementString_CommentError.MovementId
                                                     AND Movement.DescId = zc_Movement_Check()
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
                          )
      , tmpUnit AS (SELECT Object_Unit.Id                               AS UnitId
                         , Object_Unit.ValueData                        AS UnitName
                         , Object_Area.ValueData                        AS AreaName
                         , Object_Retail.ValueData                      AS RetailName
                         , Object_ProvinceCity.ValueData                AS ProvinceCityName_Unit
                         , Object_Juridical.ValueData                   AS JuridicalName_Unit
                         , ObjectString_Phone.ValueData                 AS Phone
                         , ObjectString_Unit_Address.ValueData          AS Address_Unit
                         , ObjectString_Unit_Phone.ValueData            AS Phone_Unit
                         , Object_PartnerMedical.Id                     AS PartnerMedicalId
                         , Object_PartnerMedical.ValueData              AS PartnerMedicalName
                         , ObjectLink_Unit_Area.ChildObjectId           AS AreaId
                    FROM tmpUnitAll AS Object_Unit
                         INNER JOIN tmpObjectLink AS ObjectLink_Unit_PartnerMedical
                                                  ON ObjectLink_Unit_PartnerMedical.ObjectId = Object_Unit.Id 
                                                 AND ObjectLink_Unit_PartnerMedical.DescId = zc_ObjectLink_Unit_PartnerMedical()
                         LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = ObjectLink_Unit_PartnerMedical.ChildObjectId
                         
                         LEFT JOIN tmpObjectLink AS ObjectLink_Unit_Area
                                                 ON ObjectLink_Unit_Area.ObjectId = Object_Unit.Id
                                                AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
                         LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Unit_Area.ChildObjectId

                         LEFT JOIN tmpObjectLink AS ObjectLink_Unit_Juridical
                                                 ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                         LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

                         LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                         LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

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
                                               
                    WHERE ObjectLink_Unit_PartnerMedical.ChildObjectId = COALESCE(inPartnerMedicalID, 0) OR 
                          COALESCE(inPartnerMedicalID, 0) = 0 AND COALESCE(ObjectLink_Unit_PartnerMedical.ChildObjectId, 0) <> 0
                    )

      , tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                            , ObjectFloat_NDSKind_NDS.ValueData
                      FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                      WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                      )
      , tmpGoodsParams AS (SELECT tmpGoods.Id                                      AS GoodsId
                                , tmpGoods.ObjectCode                              AS GoodsCode
                                , tmpGoods.Name                                    AS GoodsName
                                , Object_GoodsGroup.ValueData                      AS GoodsGroupName
                                , Object_NDSKind.ValueData                         AS NDSKindName
                                , ObjectFloat_NDSKind_NDS.ValueData                AS NDS
                               FROM tmpGoods

                                 LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpGoods.GoodsGroupId

                                 LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = tmpGoods.NDSKindId

                                 LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                                      ON ObjectFloat_NDSKind_NDS.ObjectId = tmpGoods.NDSKindId
                           )

      , tmpPrice AS (SELECT Price_Goods.ObjectId        AS Id
                          , Price_Goods.ChildObjectId   AS GoodsId
                     FROM ObjectLink AS Price_Goods
                     WHERE Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                       AND Price_Goods.ChildObjectId IN (SELECT tmpGoods.Id FROM tmpGoods )
                    )
      , tmpPrice_View AS (SELECT Price_Goods.Id              AS Id
                               , Price_Unit.ChildObjectId    AS UnitId
                               , Price_Goods.GoodsId         AS GoodsId
                               , CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                       AND ObjectFloat_Goods_Price.ValueData > 0
                                      THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                      ELSE ROUND (Price_Value.ValueData, 2)
                                 END :: TFloat                           AS Price
                               , Price_DateChange.ValueData              AS DateChange 
                               , COALESCE (NULLIF (ObjectBoolean_Goods_TOP.ValueData, FALSE), COALESCE (ObjectBoolean_Goods_TOP.ValueData, FALSE))         AS isTop
                               , COALESCE (NULLIF (ObjectFloat_PercentMarkup.ValueData, 0), COALESCE (ObjectFloat_Goods_PercentMarkup.ValueData, 0)) AS PercentMarkup
                          FROM tmpPrice AS Price_Goods
                               LEFT JOIN ObjectLink AS Price_Unit
                                      ON Price_Unit.ObjectId = Price_Goods.Id
                                     AND Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                               LEFT JOIN ObjectFloat AS Price_Value
                                                     ON Price_Value.ObjectId = Price_Unit.ObjectId
                                                    AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                               LEFT JOIN ObjectDate AS Price_DateChange
                                                    ON Price_DateChange.ObjectId = Price_Unit.ObjectId
                                                   AND Price_DateChange.DescId = zc_ObjectDate_Price_DateChange()
                               LEFT JOIN ObjectFloat AS ObjectFloat_PercentMarkup
                                                     ON ObjectFloat_PercentMarkup.ObjectId = Price_Unit.ObjectId
                                                    AND ObjectFloat_PercentMarkup.DescId = zc_ObjectFloat_Price_PercentMarkup()
                                 -- Фикс цена для всей Сети
                               LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                      ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.GoodsId
                                                     AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                               LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                       ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.GoodsId
                                                      AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                               LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PercentMarkup
                                                     ON ObjectFloat_Goods_PercentMarkup.ObjectId = Price_Goods.GoodsId
                                                    AND ObjectFloat_Goods_PercentMarkup.DescId = zc_ObjectFloat_Goods_PercentMarkup()
                          )
      , tmpPrice_Site AS (SELECT Object_PriceSite.Id                        AS Id
                               , ROUND(Price_Value.ValueData,2)::TFloat     AS Price
                               , Price_Goods.ChildObjectId                  AS GoodsId
                               , PriceSite_DateChange.ValueData             AS DateChange 
                          FROM Object AS Object_PriceSite
                               INNER JOIN ObjectLink AS Price_Goods
                                       ON Price_Goods.ObjectId = Object_PriceSite.Id
                                      AND Price_Goods.DescId = zc_ObjectLink_PriceSite_Goods()
                               LEFT JOIN ObjectFloat AS Price_Value
                                      ON Price_Value.ObjectId = Object_PriceSite.Id
                                     AND Price_Value.DescId = zc_ObjectFloat_PriceSite_Value()
                               LEFT JOIN ObjectDate AS PriceSite_DateChange
                                                    ON PriceSite_DateChange.ObjectId = Object_PriceSite.Id
                                                   AND PriceSite_DateChange.DescId = zc_ObjectDate_PriceSite_DateChange()
                          WHERE Object_PriceSite.DescId = zc_Object_PriceSite()
                            AND Price_Goods.ChildObjectId NOT IN (SELECT DISTINCT ObjectLink_BarCode_Goods.ChildObjectId  AS GoodsId
                                                                  FROM Object AS Object_BarCode
                                                                       LEFT JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                                                                            ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                                                                                           AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                                                                       LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                                                                            ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                                                                           AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                                                                       LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId           

                                                                  WHERE Object_BarCode.DescId = zc_Object_BarCode()
                                                                    AND Object_BarCode.isErased = False
                                                                    AND Object_Object.isErased = False)
                         )
      , tmpMinPrice_List AS (SELECT MinPriceList.GoodsId,
                                    MinPriceList.GoodsCode,
                                    MinPriceList.GoodsName,
                                    MinPriceList.PartionGoodsDate,
                                    MinPriceList.Partner_GoodsId,
                                    MinPriceList.Partner_GoodsCode,
                                    MinPriceList.Partner_GoodsName,
                                    MinPriceList.MakerName,
                                    MinPriceList.ContractId,
                                    MinPriceList.AreaId,
                                    MinPriceList.JuridicalId,
                                    MinPriceList.JuridicalName,
                                    MinPriceList.Price,
                                    MinPriceList.SuperFinalPrice,
                                    MinPriceList.isTop,
                                    MinPriceList.isOneJuridical
                                FROM tmpGoods
                                     INNER JOIN MinPrice_ForSite AS MinPriceList
                                                                 ON tmpGoods.Id = MinPriceList.GoodsId
                                WHERE MinPriceList.JuridicalId IN (59610, 59611, 59612))
      , MarginCategory_Unit AS
           (SELECT tmp.UnitId
                 , tmp.MarginCategoryId
            FROM (SELECT tmpList.UnitId
                       , ObjectLink_MarginCategory.ChildObjectId AS MarginCategoryId
                       , ROW_NUMBER() OVER (PARTITION BY tmpList.UnitId ORDER BY tmpList.UnitId, ObjectLink_MarginCategory.ChildObjectId) AS Ord
                  FROM tmpUnit AS tmpList
                       INNER JOIN ObjectLink AS ObjectLink_MarginCategoryLink_Unit
                                             ON ObjectLink_MarginCategoryLink_Unit.ChildObjectId = tmpList.UnitId
                                            AND ObjectLink_MarginCategoryLink_Unit.DescId        = zc_ObjectLink_MarginCategoryLink_Unit()
                       LEFT JOIN ObjectLink AS ObjectLink_MarginCategory
                                            ON ObjectLink_MarginCategory.ObjectId = ObjectLink_MarginCategoryLink_Unit.ObjectId
                                           AND ObjectLink_MarginCategory.DescId   = zc_ObjectLink_MarginCategoryLink_MarginCategory()
                       LEFT JOIN ObjectFloat AS ObjectFloat_Percent
                                             ON ObjectFloat_Percent.ObjectId = ObjectLink_MarginCategory.ChildObjectId
                                            AND ObjectFloat_Percent.DescId   = zc_ObjectFloat_MarginCategory_Percent()
                  WHERE COALESCE (ObjectFloat_Percent.ValueData, 0) = 0 -- !!!вот так криво!!!
                 ) AS tmp
            WHERE tmp.Ord = 1 -- !!!только одна категория!!!
           )
      , MarginCategory_all AS
           (SELECT DISTINCT
                   tmp.UnitId
                 , tmp.MarginCategoryId
                 , ObjectFloat_MarginPercent.ValueData AS MarginPercent
                 , ObjectFloat_MinPrice.ValueData      AS MinPrice
                 , ROW_NUMBER() OVER (PARTITION BY tmp.UnitId, tmp.MarginCategoryId ORDER BY tmp.UnitId, tmp.MarginCategoryId, ObjectFloat_MinPrice.ValueData) AS ORD
            FROM (SELECT MarginCategory_Unit.UnitId, MarginCategory_Unit.MarginCategoryId FROM MarginCategory_Unit) AS tmp
                 -- INNER JOIN Object_MarginCategoryItem_View ON Object_MarginCategoryItem_View.MarginCategoryId = tmp.MarginCategoryId
                 INNER JOIN ObjectLink AS ObjectLink_MarginCategoryItem_MarginCategory
                                       ON ObjectLink_MarginCategoryItem_MarginCategory.ChildObjectId = tmp.MarginCategoryId
                                      AND ObjectLink_MarginCategoryItem_MarginCategory.DescId = zc_ObjectLink_MarginCategoryItem_MarginCategory()
                 INNER JOIN Object ON Object.Id = ObjectLink_MarginCategoryItem_MarginCategory.ObjectId
                                  AND Object.isErased = FALSE
                 LEFT JOIN ObjectFloat AS ObjectFloat_MinPrice
                                       ON ObjectFloat_MinPrice.ObjectId =ObjectLink_MarginCategoryItem_MarginCategory.ObjectId
                                      AND ObjectFloat_MinPrice.DescId = zc_ObjectFloat_MarginCategoryItem_MinPrice()
                 LEFT JOIN ObjectFloat AS ObjectFloat_MarginPercent
                                       ON ObjectFloat_MarginPercent.ObjectId = ObjectLink_MarginCategoryItem_MarginCategory.ObjectId
                                      AND ObjectFloat_MarginPercent.DescId = zc_ObjectFloat_MarginCategoryItem_MarginPercent()

           )
      , MarginCategory AS
           (SELECT DISTINCT
                   MarginCategory_all.UnitId
                 , MarginCategory_all.MarginCategoryId
                 , MarginCategory_all.MarginPercent
                 , MarginCategory_all.MinPrice
                 , COALESCE (MarginCategory_all_next.MinPrice, 1000000) AS MaxPrice
            FROM MarginCategory_all
                 LEFT JOIN MarginCategory_all AS MarginCategory_all_next ON MarginCategory_all_next.UnitId           = MarginCategory_all.UnitId
                                                                        AND MarginCategory_all_next.MarginCategoryId = MarginCategory_all.MarginCategoryId
                                                                        AND MarginCategory_all_next.ORD = MarginCategory_all.ORD + 1
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
             , Object_Unit.PartnerMedicalName
             , Object_Unit.AreaName
             , Object_Unit.RetailName
             , Object_Unit.Address_Unit
             , Object_Unit.Phone_Unit
             , Object_Unit.ProvinceCityName_Unit
             , Object_Unit.JuridicalName_Unit
             , Object_Unit.Phone
             , tmpGoods1303.PriceOptSP
             , tmpGoods1303.PriceSale
             , COALESCE (tmpData.Amount,0)         :: TFloat AS Amount
             , COALESCE (tmpIncome.AmountIncome,0)                                   :: TFloat AS AmountIncome
             , COALESCE (tmpReserve.Amount, 0)                                       :: TFloat AS AmountReserve
             , (COALESCE (tmpData.Amount,0) + COALESCE (tmpIncome.AmountIncome,0) +
               COALESCE (tmpDeferredSendIn.Amount, 0))                               :: TFloat AS AmountAll
             , COALESCE (CASE WHEN COALESCE(tmpData.Amount, 0) <> 0 THEN Object_Price.Price END, 0) :: TFloat AS PriceSale
             , (tmpData.Amount * COALESCE (Object_Price.Price, 0))                   :: TFloat AS SummaSale
             , Object_Price.DateChange                                                         AS DateChange 
             , CASE WHEN COALESCE(tmpIncome.AmountIncome,0) <> 0 THEN COALESCE (tmpIncome.SummSale,0) / COALESCE (tmpIncome.AmountIncome,0) ELSE 0 END  :: TFloat AS PriceSaleIncome
             , tmpData.MinExpirationDate  ::TDateTime
             , containerCheck.DailyCheck:: TFloat
             , containerSale.DailySale:: TFloat
             , tmpDeferredSend.Amount:: TFloat AS DeferredSend
             , tmpDeferredSendIn.Amount:: TFloat AS DeferredSendIn
             , tmpPrice_Site.Price                      AS PriceSite
             , tmpPrice_Site.DateChange                 AS DateChangeSite
             , ROUND (MinPrice_List.Price * (1 + COALESCE (tmpGoodsParams.NDS, 0) / 100) *
                     (1 + CASE WHEN Object_Price.IsTop = TRUE AND COALESCE(Object_Price.PercentMarkup, 0) > 0 THEN Object_Price.PercentMarkup ELSE COALESCE (MarginCategory.MarginPercent, 0) END / 100), 2) :: TFloat  AS Price_min
             , CASE WHEN vbisAdmin AND COALESCE (tmpData.Amount,0) < (COALESCE (containerCheck.DailyCheck,0) + COALESCE (containerSale.DailySale,0)) THEN zc_Color_Red()
                    WHEN vbisAdmin AND COALESCE (tmpData.Amount,0) > (COALESCE (containerCheck.DailyCheck,0) + COALESCE (containerSale.DailySale,0)) * 3 THEN zc_Color_Greenl()
                    ELSE zc_Color_White() END      AS Color_calc

        FROM tmpGoods 
            LEFT JOIN tmpUnit AS Object_Unit ON 1=1
            LEFT JOIN tmpData ON tmpData.GoodsId = tmpGoods.Id
                             AND tmpData.UnitId  = Object_Unit.UnitId
                             
            LEFT JOIN tmpGoods1303 ON tmpGoods1303.GoodsId = tmpGoods.Id

            LEFT JOIN tmpIncome ON tmpIncome.GoodsId = tmpGoods.Id
                               AND tmpIncome.UnitId  = Object_Unit.UnitId

            LEFT JOIN tmpReserve ON tmpReserve.GoodsId = tmpGoods.Id
                                AND tmpReserve.UnitId  = Object_Unit.UnitId

            LEFT JOIN tmpGoodsParams ON tmpGoodsParams.GoodsId = tmpGoods.Id

            LEFT OUTER JOIN tmpPrice_View AS Object_Price
                                          ON Object_Price.GoodsId = tmpGoods.Id
                                         AND Object_Price.UnitId  = Object_Unit.UnitId

            LEFT JOIN containerCheck ON containerCheck.GoodsId = tmpGoods.Id
                                    AND containerCheck.UnitId  = Object_Unit.UnitId

            LEFT JOIN containerSale ON containerSale.GoodsId = tmpGoods.Id
                                    AND containerSale.UnitId  = Object_Unit.UnitId

            LEFT JOIN tmpDeferredSend ON tmpDeferredSend.GoodsId = tmpGoods.Id
                                     AND tmpDeferredSend.UnitId  = Object_Unit.UnitId

            LEFT JOIN tmpDeferredSendIn ON tmpDeferredSendIn.GoodsId = tmpGoods.Id
                                       AND tmpDeferredSendIn.UnitId  = Object_Unit.UnitId

            LEFT JOIN tmpPrice_Site ON tmpPrice_Site.GoodsId = tmpGoods.Id

            LEFT JOIN tmpMinPrice_List AS MinPrice_List ON MinPrice_List.GoodsId = tmpGoods.Id
                                                       AND MinPrice_List.AreaId  = CASE WHEN Object_Unit.AreaId <> 12487449  THEN Object_Unit.AreaId ELSE zc_Area_Basis() END
                                                       
            LEFT JOIN MarginCategory ON MinPrice_List.Price >= MarginCategory.MinPrice AND MinPrice_List.Price < MarginCategory.MaxPrice
                                    AND MarginCategory.UnitId = Object_Unit.UnitId

          ORDER BY Object_Unit.UnitName
                 , tmpGoodsParams.GoodsGroupName
                 , tmpGoodsParams.GoodsName
           ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.07.22                                                       *
*/

-- тест
-- 

select * from gpSelect_GoodsSearchRemains_1303(inCodeSearch := '' , inGoodsSearch := 'пента' , inPartnerMedicalID := 4474307 ,  inSession := '3');