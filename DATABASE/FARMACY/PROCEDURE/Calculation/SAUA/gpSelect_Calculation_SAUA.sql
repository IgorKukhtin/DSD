-- Function: gpSelect_Calculation_SAUA()

--DROP FUNCTION IF EXISTS gpSelect_Calculation_SAUA (TDateTime, TDateTime, Text, Text, TFloat, Integer, Integer, TFloat, boolean, boolean, boolean, boolean, boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Calculation_SAUA (TDateTime, TDateTime, Text, Text, TFloat, Integer, Integer, boolean, boolean, boolean, boolean, TFloat, TFloat, boolean, TFloat, TFloat, boolean, boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Calculation_SAUA(
    IN inDateStart           TDateTime , -- Начало периода
    IN inDateEnd             TDateTime , -- Окончание периода
    IN inRecipientList       Text      , -- Аптеки получатели
    IN inAssortmentList      Text      , -- Аптеки ассортимента
    IN inThreshold           TFloat    , -- Порог минимальных продаж
    IN inDaysStock           Integer   , -- Дней запаса у получателя
    IN inCountPharmacies     Integer   , -- Мин. кол-во аптек ассортимента
--    IN inResolutionParameter TFloat    , -- Гранич. параметр разрешения
    IN inisGoodsClose        boolean   , -- Не показывать Закрыт код
    IN inisMCSIsClose        boolean   , -- Не показывать Убит код 
    IN inisNotCheckNoMCS     boolean   , -- Не показывать Продажи не для НТЗ

    IN inisMCSValue          boolean   , -- Учитывать товар с НТЗ
    IN inThresholdMCS        TFloat    , -- Порог минимального НТЗ
    IN inThresholdMCSLarge   TFloat    , -- Порог минимального НТЗ верхний

    IN inisRemains             boolean   , -- Остаток получателя
    IN inThresholdRemains      TFloat    , -- Порог остатка
    IN inThresholdRemainsLarge TFloat    , -- Порог остатка верхний

    IN inisAssortmentRound     boolean   , -- Ассортимент округлять по мат принципу
    IN inisNeedRound           boolean   , -- Потребность округлять по мат принципу
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, UnitCode Integer, UnitName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Remains TFloat
             , Assortment TFloat
             , Need TFloat
             , AmountCheck TFloat
             , CountUnit Integer)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);

    -- Аптеки получатели
    CREATE TEMP TABLE _tmpUnitRecipient ON COMMIT DROP AS
       (SELECT Object_Unit.Id          AS Id
             , Object_Unit.ObjectCode  AS Code
             , Object_Unit.ValueData   AS Name
        FROM Object AS Object_Unit

             LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                  ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                 AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

             LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                  ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                 AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

        WHERE Object_Unit.DescId = zc_Object_Unit()
          AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId, 0) = 4
          AND ','||inRecipientList||',' LIKE '%,'||Object_Unit.Id::TEXT||',%'
        ORDER BY Object_Unit.Id);

    -- Аптеки ассортимента
    CREATE TEMP TABLE _tmpUnitAssortment ON COMMIT DROP AS
       (SELECT Object_Unit.Id          AS Id
             , Object_Unit.ObjectCode  AS Code
             , Object_Unit.ValueData   AS Name
        FROM Object AS Object_Unit

             LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                  ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                 AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

             LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                  ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                 AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

        WHERE Object_Unit.DescId = zc_Object_Unit()
          AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId, 0) = 4
          AND ','||inAssortmentList||',' LIKE '%,'||Object_Unit.Id::TEXT||',%'
        ORDER BY Object_Unit.Id);

     -- Получили все продажи по аптекам ассортимента
    CREATE TEMP TABLE _tmpSale_Assortment ON COMMIT DROP AS
       (SELECT AnalysisContainerItem.GoodsId                          AS GoodsId
             , SUM(AnalysisContainerItem.AmountCheck)::TFloat         AS AmountCheck
             , COUNT(DISTINCT AnalysisContainerItem.UnitID)::Integer  AS CountUnit
             , CASE WHEN COALESCE (inisAssortmentRound, False) = True
                    THEN ROUND(SUM(AnalysisContainerItem.AmountCheck) / COUNT(DISTINCT AnalysisContainerItem.UnitID) / (inDateEnd::Date -  inDateStart::Date + 1) * inDaysStock)
                    ELSE CEIL(SUM(AnalysisContainerItem.AmountCheck) / COUNT(DISTINCT AnalysisContainerItem.UnitID) / (inDateEnd::Date -  inDateStart::Date + 1) * inDaysStock) END::TFloat         AS Assortment
        FROM AnalysisContainerItem AS AnalysisContainerItem
        WHERE AnalysisContainerItem.Operdate >= inDateStart
          AND AnalysisContainerItem.Operdate < inDateEnd + INTERVAL '1 DAY'
          AND AnalysisContainerItem.AmountCheck > 0
          AND AnalysisContainerItem.UnitID IN (SELECT DISTINCT _tmpUnitAssortment.Id FROM _tmpUnitAssortment)
        GROUP BY AnalysisContainerItem.GoodsId
        HAVING SUM(AnalysisContainerItem.AmountCheck) / COUNT(DISTINCT AnalysisContainerItem.UnitID) >= inThreshold
           AND COUNT(DISTINCT AnalysisContainerItem.UnitID) >= inCountPharmacies);

     -- Вычитаем все продажи не для НТЗ
    IF inisNotCheckNoMCS = TRUE
    THEN

      raise notice 'Value 01: %', timeofday();
      CREATE TEMP TABLE _tmpSale_CheckNoMCS ON COMMIT DROP AS
           (WITH  tmpMovement AS (
                       SELECT *
                       FROM MovementBoolean AS MovementBoolean_NotMCS

                            INNER JOIN Movement ON Movement.ID = MovementBoolean_NotMCS.MovementId
                                               AND Movement.OperDate >= inDateStart
                                               AND Movement.OperDate < inDateEnd + INTERVAL '1 DAY'
                                               AND Movement.StatusId = zc_Enum_Status_Complete()

                       WHERE MovementBoolean_NotMCS.DescId = zc_MovementBoolean_NotMCS()
                         AND MovementBoolean_NotMCS.ValueData = TRUE),
                  tmpMovementUnit AS (
                       SELECT Movement.Id
                       FROM tmpMovement AS Movement

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                       WHERE MovementLinkObject_Unit.ObjectId IN (SELECT DISTINCT _tmpUnitAssortment.Id FROM _tmpUnitAssortment)

                       )

                      SELECT MovementItem.ObjectId      AS GoodsID
               , SUM(MovementItem.Amount)   AS Amount
          FROM MovementItem
          WHERE MovementItem.MovementID IN (SELECT Movement.ID FROM tmpMovementUnit AS Movement)
            AND MovementItem.isErased = False
            AND MovementItem.Amount > 0

          GROUP BY MovementItem.ObjectId );

      raise notice 'Value 02: %', timeofday();

      UPDATE _tmpSale_Assortment SET AmountCheck = _tmpSale_Assortment.AmountCheck - T1.Amount
                                   , Assortment = CASE WHEN COALESCE (inisAssortmentRound, False) = True
                                                       THEN ROUND((_tmpSale_Assortment.AmountCheck - T1.Amount) / _tmpSale_Assortment.CountUnit / (inDateEnd::Date -  inDateStart::Date + 1) * inDaysStock)
                                                       ELSE CEIL((_tmpSale_Assortment.AmountCheck - T1.Amount) / _tmpSale_Assortment.CountUnit / (inDateEnd::Date -  inDateStart::Date + 1) * inDaysStock) END::TFloat
      FROM (SELECT * FROM _tmpSale_CheckNoMCS) AS T1
      WHERE _tmpSale_Assortment.GoodsId = T1.GoodsId;

    END IF;

     -- Получили все остатки по аптекам
    CREATE TEMP TABLE _tmpRemains_All ON COMMIT DROP AS
       (SELECT Container.WhereObjectId          AS UnitId
             , Container.ObjectId               AS GoodsId
             , SUM(Container.Amount)::TFloat    AS Amount
        FROM Container
        WHERE Container.DescId = zc_Container_Count()
          AND Container.Amount <> 0
          AND Container.WhereObjectId in (SELECT DISTINCT _tmpUnitAssortment.Id FROM _tmpUnitAssortment
                                          UNION ALL
                                          SELECT DISTINCT _tmpUnitRecipient.Id FROM _tmpUnitRecipient)
        GROUP BY Container.WhereObjectId, Container.ObjectId
        HAVING SUM(Container.Amount) > 0);

    RETURN QUERY
    WITH tmpObject_Price AS (
                        SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                     AND ObjectFloat_Goods_Price.ValueData > 0
                                    THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                    ELSE ROUND (Price_Value.ValueData, 2)
                               END :: TFloat                           AS Price
                             , MCS_Value.ValueData                     AS MCSValue
                             , COALESCE (ObjectBoolean_Price_MCSIsClose.ValueData, False) AS MCSIsClose
                             , Price_Goods.ChildObjectId               AS GoodsId
                             , ObjectLink_Price_Unit.ChildObjectId     AS UnitId
                        FROM ObjectLink AS ObjectLink_Price_Unit
                           LEFT JOIN ObjectLink AS Price_Goods
                                                ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                           LEFT JOIN ObjectFloat AS Price_Value
                                                 ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                           LEFT JOIN ObjectFloat AS MCS_Value
                                                 ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Price_MCSIsClose
                                                   ON ObjectBoolean_Price_MCSIsClose.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                  AND ObjectBoolean_Price_MCSIsClose.DescId   = zc_ObjectBoolean_Price_MCSIsClose()
                           -- Фикс цена для всей Сети
                           LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                  ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                 AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                   ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                  AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                        WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                          AND ObjectLink_Price_Unit.ChildObjectId IN (SELECT _tmpUnitRecipient.Id FROM _tmpUnitRecipient)
                        )



    SELECT _tmpUnitRecipient.*
         , Object_Goods_Retail.Id
         , Object_Goods_Main.ObjectCode
         , Object_Goods_Main.Name
         , _tmpRemains_All.Amount
         , _tmpSale_Assortment.Assortment
         , CASE WHEN COALESCE (inisNeedRound, False) = True
                THEN ROUND(_tmpSale_Assortment.Assortment - COALESCE(_tmpRemains_All.Amount, 0))
                ELSE CEIL(_tmpSale_Assortment.Assortment - COALESCE(_tmpRemains_All.Amount, 0)) END::TFloat
         , _tmpSale_Assortment.AmountCheck
         , _tmpSale_Assortment.CountUnit
    FROM _tmpUnitRecipient

         LEFT JOIN _tmpSale_Assortment ON _tmpSale_Assortment.Assortment > 0

         LEFT JOIN _tmpRemains_All ON _tmpRemains_All.UnitId = _tmpUnitRecipient.Id
                                  AND _tmpRemains_All.GoodsId = _tmpSale_Assortment.GoodsId

         LEFT JOIN tmpObject_Price ON tmpObject_Price.UnitId = _tmpUnitRecipient.Id
                                  AND tmpObject_Price.GoodsId = _tmpSale_Assortment.GoodsId

         LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = _tmpSale_Assortment.GoodsId
         LEFT JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId

    WHERE CASE WHEN COALESCE (inisNeedRound, False) = True
               THEN ROUND(_tmpSale_Assortment.Assortment - COALESCE(_tmpRemains_All.Amount, 0))
               ELSE CEIL(_tmpSale_Assortment.Assortment - COALESCE(_tmpRemains_All.Amount, 0)) END > 0
     -- AND (COALESCE(_tmpRemains_All.Amount, 0) < inResolutionParameter OR inResolutionParameter = 0)
      AND (Object_Goods_Main.isClose = False OR inisGoodsClose = False)
      AND (tmpObject_Price.MCSIsClose = False OR inisMCSIsClose = False)
      AND (inisMCSValue = False AND COALESCE (tmpObject_Price.MCSValue , 0) = 0 
        OR inisMCSValue = TRUE AND COALESCE (tmpObject_Price.MCSValue , 0) >= COALESCE (inThresholdMCS, 0) AND COALESCE (tmpObject_Price.MCSValue , 0) <= COALESCE (inThresholdMCSLarge, 0))
      AND (inisRemains = False AND COALESCE (_tmpRemains_All.Amount, 0) = 0 
        OR inisRemains = TRUE AND COALESCE (_tmpRemains_All.Amount, 0) >= COALESCE (inThresholdRemains, 0) AND COALESCE (_tmpRemains_All.Amount, 0) <= COALESCE (inThresholdRemainsLarge, 0))

    ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.11.20                                                       *
*/

-- select * from gpSelect_Calculation_SAUA(inDateStart := ('01.10.2020')::TDateTime , inDateEnd := ('31.10.2020')::TDateTime , inRecipientList := '183292' , inAssortmentList := '472116,1781716,6309262' , inThreshold := 1 , inDaysStock := 10, inPercentPharmacies := 75,  inSession := '3');

--select * from gpSelect_Calculation_SAUA(inDateStart := ('01.01.2021')::TDateTime , inDateEnd := ('09.04.2021')::TDateTime , inRecipientList := '377594' , inAssortmentList := '1781716,6309262' , inThreshold := 1 , inDaysStock := 7 , inCountPharmacies := 1 , inResolutionParameter := 1 , inisGoodsClose := 'True' , inisMCSIsClose := 'True' , inisNotCheckNoMCS := 'True' ,  inSession := '3');