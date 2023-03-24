-- Function: gpSelect_GoodsOnUnitRemains_ForLiki24

DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnitRemains_ForLiki24 (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnitRemains_ForLiki24(
    IN inUnitId  Integer,   -- Подразделение
    IN inSession TVarChar   -- сессия пользователя
)
RETURNS TABLE (PharmacyId          Integer
             , ProductId           Integer
             , ProductName         TVarChar
             , Producer            TVarChar
             , Morion              Integer
             , Barcode             TVarChar
             , RegistrationNumber  TVarChar
             , Optima              TVarChar
             , Badm                TVarChar
             , Quantity            TVarChar
             , Price               TVarChar
             , OfflinePrice        TVarChar
             , PickupPrice         TVarChar
             , "10000001 - insurance company #1 id"   TVarChar
             , "10000002 - insurance company #2 id"   TVarChar
             , Vat                 TVarChar
             , PackSize            Integer
             , PackDivisor         Integer
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate_Begin1 TDateTime;
BEGIN
    -- сразу запомнили время начала выполнения Проц.
    vbOperDate_Begin1:= CLOCK_TIMESTAMP();

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpGetUserBySession (inSession);
    vbUserId:= inSession :: Integer;

    RETURN QUERY
    WITH
       tmpUnit AS
                   (SELECT Object_Unit.Id AS UnitId
                    FROM gpSelect_Object_Unit_ExportPriceForLiki24(inSession) AS Object_Unit
                    WHERE Object_Unit.Id = inUnitId OR inUnitId = 0
                   )
   , tmpContainerPD AS
                   (SELECT Container.WhereObjectId                                           AS UnitId
                         , Container.ObjectId
                         , Container.Id
                         , Container.Amount
                         , ContainerLinkObject.ObjectId                                      AS PartionGoodsId
                    FROM Container
                         LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                      AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
                    WHERE Container.DescId        = zc_Container_CountPartionDate()
                      AND Container.WhereObjectId IN (SELECT tmpUnit.UnitId FROM tmpUnit)
                      AND Container.Amount        > 0
                   )
   , tmpRemainsPD AS
                   (SELECT Container.UnitId
                         , Container.ObjectId
                         , Sum(Container.Amount)                                  AS Amount
                    FROM tmpContainerPD AS Container
                         LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                              ON ObjectDate_ExpirationDate.ObjectId = Container.PartionGoodsId
                                             AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                    WHERE ObjectDate_ExpirationDate.ValueData < CURRENT_DATE
                    GROUP BY Container.UnitId
                           , Container.ObjectId
                   )
   , tmpContainer AS
                   (SELECT Container.WhereObjectId AS UnitId
                         , Container.ObjectId
                         , Container.Id
                         , Container.Amount
                    FROM Container
                    WHERE Container.DescId        = zc_Container_Count()
                      AND Container.Amount        <> 0
                      AND Container.WhereObjectId IN (SELECT tmpUnit.UnitId FROM tmpUnit)
                   )
   , tmpPartionMI AS
                   (SELECT CLO.ContainerId
                         , MILinkObject_Goods.ObjectId AS GoodsId_find
                         , COALESCE (MI_Income_find.Id,MI_Income.Id)                       AS MI_IncomeId
                    FROM ContainerLinkObject AS CLO
                        LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO.ObjectId
                        LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                         ON MILinkObject_Goods.MovementItemId = Object_PartionMovementItem.ObjectCode
                                                        AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                        -- элемент прихода
                        LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                        -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                        LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                    ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                   AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                        -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                        LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                    WHERE CLO.ContainerId IN (SELECT DISTINCT tmpContainer.Id FROM tmpContainer)
                      AND CLO.DescId      = zc_ContainerLinkObject_PartionMovementItem()
                   )
   , Remains AS (SELECT Container.UnitId
                      , Container.ObjectId
                      , SUM (Container.Amount)  AS Amount
                      , MAX(MIString_SertificatNumber.ValueData) AS SertificatNumber
                 FROM tmpContainer AS Container
                     LEFT JOIN tmpPartionMI ON tmpPartionMI.ContainerId = Container.Id
                     LEFT JOIN MovementItemString AS MIString_SertificatNumber
                                                  ON MIString_SertificatNumber.MovementItemId = tmpPartionMI.MI_IncomeId
                                                 AND MIString_SertificatNumber.DescId = zc_MIString_SertificatNumber()
 
                 GROUP BY Container.UnitId
                        , Container.ObjectId
                )

   -- выбираем отложенные Чеки (как в кассе колонка VIP)
   , tmpMovementChek AS (SELECT Movement.Id
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
                        UNION
                         SELECT Movement.Id
                              , MovementLinkObject_Unit.ObjectId
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
       , tmpReserve AS (SELECT tmpMovementChek.UnitId
                             , MovementItem.ObjectId             AS GoodsId
                             , SUM (MovementItem.Amount)::TFloat AS ReserveAmount
                        FROM tmpMovementChek
                             INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovementChek.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                        GROUP BY tmpMovementChek.UnitId,
                                 MovementItem.ObjectId
                        )
      ,  tmpPrice AS (SELECT ObjectLink_Price_Unit.ObjectId          AS Id
                           , ObjectLink_Price_Unit.ChildObjectId     AS UnitId
                           , Price_Goods.ChildObjectId               AS GoodsId
                      FROM ObjectLink AS ObjectLink_Price_Unit
                           INNER JOIN tmpUnit ON tmpUnit.UnitId = ObjectLink_Price_Unit.ChildObjectId
                           INNER JOIN ObjectLink AS Price_Goods
                                                 ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                      WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                           )

      , tmpPrice_View AS (SELECT tmpPrice.UnitId
                               , tmpPrice.GoodsId
                               , ROUND(Price_Value.ValueData,2)::TFloat AS Price
                          FROM tmpPrice
                               LEFT JOIN ObjectFloat AS Price_Value
                                                     ON Price_Value.ObjectId = tmpPrice.Id
                                                    AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                          )
/*      , tmpPrice_Site AS (SELECT ROUND(Price_Value.ValueData,2)::TFloat     AS Price
                               , Price_Goods.ChildObjectId                  AS GoodsId
                          FROM Object AS Object_PriceSite
                               INNER JOIN ObjectLink AS Price_Goods
                                       ON Price_Goods.ObjectId = Object_PriceSite.Id
                                      AND Price_Goods.DescId = zc_ObjectLink_PriceSite_Goods()
                               LEFT JOIN ObjectFloat AS Price_Value
                                      ON Price_Value.ObjectId = Object_PriceSite.Id
                                     AND Price_Value.DescId = zc_ObjectFloat_PriceSite_Value()
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
*/        -- Штрих-коды производителя
      , tmpGoodsBarCode AS (SELECT ObjectLink_Main_BarCode.ChildObjectId AS GoodsMainId
                                 , string_agg(Object_Goods_BarCode.ValueData, ',' ORDER BY Object_Goods_BarCode.ID desc)           AS BarCode
                            FROM ObjectLink AS ObjectLink_Main_BarCode
                                 JOIN ObjectLink AS ObjectLink_Child_BarCode
                                                 ON ObjectLink_Child_BarCode.ObjectId = ObjectLink_Main_BarCode.ObjectId
                                                AND ObjectLink_Child_BarCode.DescId = zc_ObjectLink_LinkGoods_Goods()
                                 JOIN ObjectLink AS ObjectLink_Goods_Object_BarCode
                                                 ON ObjectLink_Goods_Object_BarCode.ObjectId = ObjectLink_Child_BarCode.ChildObjectId
                                                AND ObjectLink_Goods_Object_BarCode.DescId = zc_ObjectLink_Goods_Object()
                                                AND ObjectLink_Goods_Object_BarCode.ChildObjectId = zc_Enum_GlobalConst_BarCode()
                                 LEFT JOIN Object AS Object_Goods_BarCode ON Object_Goods_BarCode.Id = ObjectLink_Goods_Object_BarCode.ObjectId
                            WHERE ObjectLink_Main_BarCode.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                              AND ObjectLink_Main_BarCode.ChildObjectId > 0
                              AND TRIM (Object_Goods_BarCode.ValueData) <> ''
                            GROUP BY ObjectLink_Main_BarCode.ChildObjectId
                           )
      , Goods_Optima AS (SELECT Object_Goods_Retail.Id
                              , Object_Goods_Juridical.Code
                              , Object_Goods_Juridical.MakerName
                              , ROW_NUMBER() OVER (PARTITION BY Object_Goods_Retail.Id ORDER BY Object_Goods_Juridical.Id DESC) AS Ord
                         FROM (SELECT DISTINCT Remains.ObjectId FROM Remains) AS Remains
                              INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = Remains.ObjectId
                                                               AND Object_Goods_Retail.RetailId = 4

                              INNER JOIN Object_Goods_Juridical ON Object_Goods_Juridical.GoodsMainId = Object_Goods_Retail.GoodsMainId
                                                               AND Object_Goods_Juridical.JuridicalId = 59611
                         WHERE Object_Goods_Juridical.Code <> ''
                        )
      , Goods_Badm AS (SELECT Object_Goods_Retail.Id
                            , Object_Goods_Juridical.Code
                            , Object_Goods_Juridical.MakerName
                            , ROW_NUMBER() OVER (PARTITION BY Object_Goods_Retail.Id ORDER BY Object_Goods_Juridical.Id DESC) AS Ord
                       FROM (SELECT DISTINCT Remains.ObjectId FROM Remains) AS Remains
                            INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = Remains.ObjectId
                                                             AND Object_Goods_Retail.RetailId = 4

                            INNER JOIN Object_Goods_Juridical ON Object_Goods_Juridical.GoodsMainId = Object_Goods_Retail.GoodsMainId
                                                             AND Object_Goods_Juridical.JuridicalId = 59610
                       WHERE Object_Goods_Juridical.Code <> ''
                      )
        , tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                              , ObjectFloat_NDSKind_NDS.ValueData
                        FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                        WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                        )
      , tmpGoodsSP AS (SELECT DISTINCT MovementItem.ObjectId         AS GoodsId
                          FROM Movement
                               INNER JOIN MovementDate AS MovementDate_OperDateStart
                                                       ON MovementDate_OperDateStart.MovementId = Movement.Id
                                                      AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                                      AND MovementDate_OperDateStart.ValueData  <= CURRENT_DATE

                               INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                                       ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                                      AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                                      AND MovementDate_OperDateEnd.ValueData  >= CURRENT_DATE
                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = FALSE

                               INNER JOIN MovementItemFloat AS MIFloat_PriceSP
                                                            ON MIFloat_PriceSP.MovementItemId = MovementItem.Id
                                                           AND MIFloat_PriceSP.DescId = zc_MIFloat_PriceSP()
                                                           AND MIFloat_PriceSP.ValueData > 0

                               LEFT JOIN MovementItemLinkObject AS MI_IntenalSP
                                                                ON MI_IntenalSP.MovementItemId = MovementItem.Id
                                                               AND MI_IntenalSP.DescId = zc_MILinkObject_IntenalSP()

                          WHERE Movement.DescId = zc_Movement_GoodsSP()
                            AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                         )
     , tmpGoodsDiscount AS (SELECT Object_Goods_Retail.GoodsMainId                           AS GoodsMainId
                                 , Object_Object.Id                                          AS GoodsDiscountId
                                 , Object_Object.ValueData                                   AS GoodsDiscountName
                                 , COALESCE(ObjectBoolean_GoodsForProject.ValueData, False)  AS isGoodsForProject
                                 , MAX(COALESCE(ObjectFloat_MaxPrice.ValueData, 0))::TFloat  AS MaxPrice 
                              FROM Object AS Object_BarCode
                                  INNER JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                                        ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                                                       AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                                  INNER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = ObjectLink_BarCode_Goods.ChildObjectId

                                  LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                                       ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                                      AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                                  LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId

                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsForProject
                                                          ON ObjectBoolean_GoodsForProject.ObjectId = Object_Object.Id
                                                         AND ObjectBoolean_GoodsForProject.DescId = zc_ObjectBoolean_DiscountExternal_GoodsForProject()

                                  LEFT JOIN ObjectFloat AS ObjectFloat_MaxPrice
                                                        ON ObjectFloat_MaxPrice.ObjectId = Object_BarCode.Id
                                                       AND ObjectFloat_MaxPrice.DescId = zc_ObjectFloat_BarCode_MaxPrice()
                                                                   
                              WHERE Object_BarCode.DescId = zc_Object_BarCode()
                                AND Object_BarCode.isErased = False
                              GROUP BY Object_Goods_Retail.GoodsMainId
                                     , Object_Object.Id
                                     , Object_Object.ValueData
                                     , COALESCE(ObjectBoolean_GoodsForProject.ValueData, False))
       -- Отложенные технические переучеты
       , tmpMovementTP AS (SELECT MovementItemMaster.ObjectId      AS GoodsId
                                , MovementLinkObject_Unit.ObjectId AS UnitId
                                , SUM(-MovementItemMaster.Amount)  AS Amount
                           FROM Movement AS Movement

                                INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                              ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                             AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
                                                               
                                INNER JOIN MovementItem AS MovementItemMaster
                                                        ON MovementItemMaster.MovementId = Movement.Id
                                                       AND MovementItemMaster.DescId     = zc_MI_Master()
                                                       AND MovementItemMaster.isErased   = FALSE
                                                       AND MovementItemMaster.Amount     < 0
                                                         
                                INNER JOIN MovementItemBoolean AS MIBoolean_Deferred
                                                               ON MIBoolean_Deferred.MovementItemId = MovementItemMaster.Id
                                                              AND MIBoolean_Deferred.DescId         = zc_MIBoolean_Deferred()
                                                              AND MIBoolean_Deferred.ValueData      = TRUE
                                                               
                           WHERE Movement.DescId = zc_Movement_TechnicalRediscount()
                             AND Movement.StatusId = zc_Enum_Status_UnComplete()
                           GROUP BY MovementItemMaster.ObjectId
                                  , MovementLinkObject_Unit.ObjectId)

      SELECT Remains.UnitId                 AS PharmacyId
           , Object_Goods_Retail.Id         AS ProductId
           , REPLACE(Object_Goods_Main.Name, ',', ';')::TVarChar                  AS ProductName
           , REPLACE(COALESCE( Object_Goods_Juridical_Badm.MakerName, Object_Goods_Juridical_Optima.MakerName,Object_Goods_Main.MakerName), ',', ';')::TVarChar             AS Producer
           , Object_Goods_Main.MorionCode   AS Morion
           , REPLACE(COALESCE (tmpGoodsBarCode.BarCode, ''), ',', ';')::TVarChar  AS Barcode
           , REPLACE(Remains.SertificatNumber, ',', ';')::TVarChar                AS RegistrationNumber
           , REPLACE(Object_Goods_Juridical_Optima.Code, ',', ';')::TVarChar      AS Optima
           , REPLACE(Object_Goods_Juridical_Badm.Code, ',', ';')::TVarChar        AS Badm
           , to_char(Remains.Amount - coalesce(Reserve_Goods.ReserveAmount, 0) - COALESCE (RemainsPD.Amount, 0) - COALESCE (Reserve_TP.Amount, 0),'FM9999990.0999')::TVarChar  AS Quantity
           , to_char(zfCalc_PriceCash(Object_Price.Price, CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                                          COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)
                                                          ,'FM9999990.00')::TVarChar                   AS Price
           , to_char(zfCalc_PriceCash(Object_Price.Price, CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                                          COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)
                                                          ,'FM9999990.00')::TVarChar                   AS OfflinePrice
--           , to_char(CASE WHEN ObjectLink_Juridical_Retail.ChildObjectId = 4 THEN COALESCE(Price_Site.Price, Object_Price.Price) ELSE Object_Price.Price END,'FM9999990.00')::TVarChar                   AS Price
--           , to_char(CASE WHEN ObjectLink_Juridical_Retail.ChildObjectId = 4 THEN COALESCE(Price_Site.Price, Object_Price.Price) ELSE Object_Price.Price END,'FM9999990.00')::TVarChar                   AS OfflinePrice
           , NULL::TVarChar                   AS PickupPrice
           , NULL::TVarChar                 AS "10000001 - insurance company #1 id"
           , NULL::TVarChar                 AS "10000002 - insurance company #2 id"
           , to_char(ObjectFloat_NDSKind_NDS.ValueData,'FM9999990.0999')::TVarChar  AS Vat
           , NULL::Integer                  AS PackSize
           , NULL::Integer                  AS PackDivisor
      FROM Remains

           INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = Remains.ObjectId
                                         AND Object_Goods_Retail.RetailId = 4
           INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

           LEFT JOIN Goods_Optima AS Object_Goods_Juridical_Optima
                                  ON Object_Goods_Juridical_Optima.Id = Remains.ObjectId
                                 AND Object_Goods_Juridical_Optima.Ord = 1

           LEFT JOIN Goods_Badm AS Object_Goods_Juridical_Badm
                                ON Object_Goods_Juridical_Badm.Id = Remains.ObjectId
                               AND Object_Goods_Juridical_Badm.Ord = 1

           LEFT JOIN  ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = Remains.UnitId
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                 
           LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

           LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods_Main.NDSKindId

           LEFT OUTER JOIN tmpPrice_View AS Object_Price ON Object_Price.GoodsId = Remains.ObjectId
                                                        AND Object_Price.UnitId = Remains.UnitId

--           LEFT OUTER JOIN tmpPrice_Site AS Price_Site ON Price_Site.GoodsId = Remains.ObjectId

           LEFT OUTER JOIN tmpReserve AS Reserve_Goods ON Reserve_Goods.GoodsId = Remains.ObjectId
                                                      AND Reserve_Goods.UnitId = Remains.UnitId

           LEFT OUTER JOIN tmpMovementTP AS Reserve_TP ON Reserve_TP.GoodsId = Remains.ObjectId
                                                      AND Reserve_TP.UnitId = Remains.UnitId
                                                      
           LEFT OUTER JOIN tmpRemainsPD AS RemainsPD ON RemainsPD.ObjectId = Remains.ObjectId
                                                    AND RemainsPD.UnitId = Remains.UnitId

           -- штрих-код производителя
           LEFT JOIN tmpGoodsBarCode ON tmpGoodsBarCode.GoodsMainId = Object_Goods_Main.Id

           LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = Object_Goods_Main.Id
           LEFT JOIN tmpGoodsDiscount ON tmpGoodsDiscount.GoodsMainId = Object_Goods_Main.Id

      WHERE (Remains.Amount - COALESCE (Reserve_Goods.ReserveAmount, 0) - COALESCE (RemainsPD.Amount, 0) - COALESCE (Reserve_TP.Amount, 0)) > 0
        AND Object_Goods_Main.Name NOT ILIKE '%Спеццена%'
        AND Object_Goods_Main.isNotUploadSites = FALSE
        AND COALESCE(Object_Goods_Juridical_Optima.Code, '') <> ''
        AND COALESCE(Object_Goods_Juridical_Badm.Code, '') <> '';

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_GoodsOnUnitRemains_For103UA (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В.
 24.03.20                                                                     *
*/

-- тест
-- 
SELECT * FROM gpSelect_GoodsOnUnitRemains_ForLiki24 (inUnitId := 183292, inSession:= '3')