-- Function: gpSelect_Calculation_SAUA()

DROP FUNCTION IF EXISTS gpSelect_Calculation_SAUA (TDateTime, TDateTime, Text, Text, TFloat, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Calculation_SAUA(
    IN inDateStart         TDateTime , -- Начало периода
    IN inDateEnd           TDateTime , -- Окончание периода
    IN inRecipientList     Text      , -- Аптеки получатели
    IN inAssortmentList    Text      , -- Аптеки ассортимента
    IN inThreshold         TFloat    , -- Порог минимальных продаж
    IN inDaysStock         Integer   , -- Дней запаса у получателя
    IN inPercentPharmacies TFloat    , -- Процент аптек ассортимента с продажами
    IN inSession           TVarChar    -- сессия пользователя
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
    DECLARE vbCountAssortment Integer;
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

    vbCountAssortment := Round((SELECT COUNT(*) FROM _tmpUnitAssortment) * inPercentPharmacies / 100, 0);

     -- Получили все продажи по аптекам ассортимента
    CREATE TEMP TABLE _tmpSale_Assortment ON COMMIT DROP AS
       (SELECT AnalysisContainerItem.GoodsId                          AS GoodsId
             , SUM(AnalysisContainerItem.AmountCheck)::TFloat         AS AmountCheck
             , COUNT(DISTINCT AnalysisContainerItem.UnitID)::Integer  AS CountUnit
             , CEIL(SUM(AnalysisContainerItem.AmountCheck) / COUNT(DISTINCT AnalysisContainerItem.UnitID) / (inDateEnd::Date -  inDateStart::Date + 1) * inDaysStock)::TFloat         AS Assortment
        FROM AnalysisContainerItem AS AnalysisContainerItem
        WHERE AnalysisContainerItem.Operdate >= inDateStart
          AND AnalysisContainerItem.Operdate < inDateEnd + INTERVAL '1 DAY'
          AND AnalysisContainerItem.AmountCheck > 0
          AND AnalysisContainerItem.UnitID IN (SELECT DISTINCT _tmpUnitAssortment.Id FROM _tmpUnitAssortment)
        GROUP BY AnalysisContainerItem.GoodsId
        HAVING SUM(AnalysisContainerItem.AmountCheck) / COUNT(DISTINCT AnalysisContainerItem.UnitID) >= inThreshold
           AND COUNT(DISTINCT AnalysisContainerItem.UnitID) >= vbCountAssortment);


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
    SELECT _tmpUnitRecipient.*
         , Object_Goods_Retail.Id
         , Object_Goods_Main.ObjectCode
         , Object_Goods_Main.Name
         , _tmpRemains_All.Amount
         , _tmpSale_Assortment.Assortment
         , CEIL( _tmpSale_Assortment.Assortment - COALESCE(_tmpRemains_All.Amount, 0))::TFloat
         , _tmpSale_Assortment.AmountCheck
         , _tmpSale_Assortment.CountUnit
    FROM _tmpUnitRecipient

         LEFT JOIN _tmpSale_Assortment ON _tmpSale_Assortment.Assortment > 0

         LEFT JOIN _tmpRemains_All ON _tmpRemains_All.UnitId = _tmpUnitRecipient.Id
                                  AND _tmpRemains_All.GoodsId = _tmpSale_Assortment.GoodsId

         LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = _tmpSale_Assortment.GoodsId
         LEFT JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId

    WHERE CEIL( _tmpSale_Assortment.Assortment - COALESCE(_tmpRemains_All.Amount, 0)) > 0
    ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.11.20                                                       *
*/

select * from gpSelect_Calculation_SAUA(inDateStart := ('01.10.2020')::TDateTime , inDateEnd := ('31.10.2020')::TDateTime , inRecipientList := '183292' , inAssortmentList := '472116,1781716,6309262' , inThreshold := 1 , inDaysStock := 10, inPercentPharmacies := 75,  inSession := '3');