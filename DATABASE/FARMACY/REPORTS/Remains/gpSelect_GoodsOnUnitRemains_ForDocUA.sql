-- Function: gpSelect_GoodsOnUnitRemains_ForDocUA

DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnitRemains_ForDocUA (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnitRemains_ForDocUA(
    IN inUnitId  Integer,   -- Подразделение
    IN inSession TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id                  Integer
             , Name_ru             TVarChar
             , Name_ua             TVarChar
             , Marion_Code         Integer
             , Badm_Code           TVarChar
             , Description         TVarChar
             , Price               TFloat
             , Quantity            TFloat
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
     tmpContainerPD AS
                   (SELECT Container.ObjectId
                         , Container.Id
                         , Container.Amount
                         , ContainerLinkObject.ObjectId                                      AS PartionGoodsId
                    FROM Container
                         LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                      AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
                    WHERE Container.DescId        = zc_Container_CountPartionDate()
                      AND Container.Amount        > 0
                      AND Container.WhereObjectId = inUnitId
                   )
   , tmpRemainsPD AS
                   (SELECT Container.ObjectId
                         , Sum(Container.Amount)                                  AS Amount
                    FROM tmpContainerPD AS Container
                         LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                              ON ObjectDate_ExpirationDate.ObjectId = Container.PartionGoodsId
                                             AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                    WHERE ObjectDate_ExpirationDate.ValueData < CURRENT_DATE
                    GROUP BY Container.ObjectId
                   )
   , tmpContainer AS
                   (SELECT Container.ObjectId
                         , Container.Id
                         , Container.Amount
                    FROM Container
                    WHERE Container.DescId        = zc_Container_Count()
                      AND Container.Amount        <> 0
                      AND Container.WhereObjectId = inUnitId
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
   , tmpRemains AS (SELECT Container.ObjectId
                         , tmpPartionMI.GoodsId_find
                         , SUM (Container.Amount)  AS Amount
                         , MAX(MIString_SertificatNumber.ValueData) AS SertificatNumber
                    FROM tmpContainer AS Container
                        LEFT JOIN tmpPartionMI ON tmpPartionMI.ContainerId = Container.Id
                        LEFT JOIN ObjectBoolean AS ObjectBoolean_isNotUploadSites
                                                ON ObjectBoolean_isNotUploadSites.ObjectId = Container.ObjectId
                                               AND ObjectBoolean_isNotUploadSites.DescId   = zc_ObjectBoolean_Goods_isNotUploadSites()
                        LEFT JOIN MovementItemString AS MIString_SertificatNumber
                                                     ON MIString_SertificatNumber.MovementItemId = tmpPartionMI.MI_IncomeId
                                                    AND MIString_SertificatNumber.DescId = zc_MIString_SertificatNumber()

                    WHERE COALESCE (ObjectBoolean_isNotUploadSites.ValueData, FALSE) = FALSE
                    GROUP BY Container.ObjectId
                           , tmpPartionMI.GoodsId_find
                   )
   , tmpGoods AS (SELECT ObjectString.ObjectId AS GoodsId_find, ObjectString.ValueData AS MakerName
                    FROM ObjectString
                    WHERE ObjectString.ObjectId IN (SELECT DISTINCT tmpRemains.GoodsId_find FROM tmpRemains)
                      AND ObjectString.DescId   = zc_ObjectString_Goods_Maker()
                   )
   , Remains AS (SELECT tmpRemains.ObjectId
                      , MAX (tmpGoods.MakerName)         AS MakerName
                      , SUM (tmpRemains.Amount)          AS Amount
                      , MAX(tmpRemains.SertificatNumber) AS SertificatNumber
                   FROM
                       tmpRemains
                       LEFT JOIN tmpGoods ON tmpGoods.GoodsId_find = tmpRemains.GoodsId_find
                   GROUP BY tmpRemains.ObjectId
                   HAVING SUM (tmpRemains.Amount) > 0
                 )

   -- выбираем отложенные Чеки (как в кассе колонка VIP)
   , tmpMovementChek AS (SELECT Movement.Id
                         FROM MovementBoolean AS MovementBoolean_Deferred
                              INNER JOIN Movement ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                                 AND Movement.DescId = zc_Movement_Check()
                                                 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                         WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                           AND MovementBoolean_Deferred.ValueData = TRUE
                           AND MovementLinkObject_Unit.ObjectId = inUnitId
                        UNION
                         SELECT Movement.Id
                         FROM MovementString AS MovementString_CommentError
                              INNER JOIN Movement ON Movement.Id     = MovementString_CommentError.MovementId
                                                 AND Movement.DescId = zc_Movement_Check()
                                                 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                        WHERE MovementString_CommentError.DescId = zc_MovementString_CommentError()
                          AND MovementString_CommentError.ValueData <> ''
                          AND MovementLinkObject_Unit.ObjectId = inUnitId
                        )
       , tmpReserve AS (SELECT MovementItem.ObjectId             AS GoodsId
                             , SUM (MovementItem.Amount)::TFloat AS ReserveAmount
                        FROM tmpMovementChek
                             INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovementChek.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                        GROUP BY MovementItem.ObjectId
                        )
      , tmpPrice_View AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                       AND ObjectFloat_Goods_Price.ValueData > 0
                                      THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                      ELSE ROUND (Price_Value.ValueData, 2)
                                 END :: TFloat                           AS Price
                               , Price_Goods.ChildObjectId               AS GoodsId
                          FROM ObjectLink AS ObjectLink_Price_Unit
                             LEFT JOIN ObjectLink AS Price_Goods
                                                  ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                 AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                             LEFT JOIN ObjectFloat AS Price_Value
                                                   ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                  AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                             -- Фикс цена для всей Сети
                             LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                    ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                   AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                             LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                     ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                    AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                          WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                            AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                            )
      , Goods_Badm AS (SELECT Object_Goods_Retail.Id
                            , Object_Goods_Juridical.Code
                            , ROW_NUMBER() OVER (PARTITION BY Object_Goods_Retail.Id ORDER BY Object_Goods_Juridical.Id DESC) AS Ord
                       FROM (SELECT DISTINCT Remains.ObjectId FROM Remains) AS Remains
                            INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = Remains.ObjectId
                                                             AND Object_Goods_Retail.RetailId = 4

                            INNER JOIN Object_Goods_Juridical ON Object_Goods_Juridical.GoodsMainId = Object_Goods_Retail.GoodsMainId
                                                             AND Object_Goods_Juridical.JuridicalId = 59610
                      )
        , tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                              , ObjectFloat_NDSKind_NDS.ValueData
                        FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                        WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                        )
       -- Отложенные технические переучеты
       , tmpMovementTP AS (SELECT MovementItemMaster.ObjectId      AS GoodsId
                                , SUM(-MovementItemMaster.Amount)  AS Amount
                           FROM Movement AS Movement

                                INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                              ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                             AND MovementLinkObject_Unit.ObjectId = inUnitId
                                                               
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
                           GROUP BY MovementItemMaster.ObjectId)

      SELECT Object_Goods_Retail.Id                                               AS Id
           , Object_Goods_Main.Name                                               AS name_ru
           , Object_Goods_Main.Name                                               AS name_ua
           , Object_Goods_Main.MorionCode                                         AS marion_code
           , Object_Goods_Juridical_Badm.Code                                     AS badm_code
           , ''::TVarChar                                                         AS description
           , Object_Price.Price                                                   AS Price
           , (Remains.Amount - coalesce(Reserve_Goods.ReserveAmount, 0) - COALESCE (RemainsPD.Amount, 0) - COALESCE (Reserve_TP.Amount, 0))::TFloat  AS Quantity
      FROM Remains

           INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = Remains.ObjectId
                                         AND Object_Goods_Retail.RetailId = 4
           INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

           INNER JOIN Goods_Badm AS Object_Goods_Juridical_Badm
                                 ON Object_Goods_Juridical_Badm.Id = Remains.ObjectId
                                AND Object_Goods_Juridical_Badm.Ord = 1

           LEFT OUTER JOIN tmpPrice_View AS Object_Price ON Object_Price.GoodsId = Remains.ObjectId

           LEFT OUTER JOIN tmpReserve AS Reserve_Goods ON Reserve_Goods.GoodsId = Remains.ObjectId

           LEFT OUTER JOIN tmpMovementTP AS Reserve_TP ON Reserve_TP.GoodsId = Remains.ObjectId

           LEFT OUTER JOIN tmpRemainsPD AS RemainsPD ON RemainsPD.ObjectId = Remains.ObjectId

      WHERE (Remains.Amount - COALESCE (Reserve_Goods.ReserveAmount, 0) - COALESCE (RemainsPD.Amount, 0) - COALESCE (Reserve_TP.Amount, 0)) > 0;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_GoodsOnUnitRemains_ForDocUA (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В.
 24.03.20                                                                     *
*/

-- тест
-- SELECT * FROM gpSelect_GoodsOnUnitRemains_ForDocUA (inUnitId := 377606, inSession:= '3')