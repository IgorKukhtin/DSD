-- Function: gpSelect_GoodsPartionDate_ForSiteMobile()

DROP FUNCTION IF EXISTS gpSelect_GoodsPartionDate_ForSiteMobile (Text, Text, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsPartionDate_ForSiteMobile(
    IN inGoodsId          Integer  ,  -- Id товара
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id                   Integer

             , Name                 TVarChar   -- Название русское
             , NameUkr              TVarChar   -- Название украинское если (есть)

             , deleted              Integer

             , Remains              TFloat    -- Остаток (с учетом резерва)

             , Price_unit_Min       TFloat -- цена аптеки
             , Price_unit_Max       TFloat -- цена аптеки

             , PartionDateKindId_1  Integer -- Id Срока
             , Remains_1            TFloat  -- Остаток (с учетом резерва) 
             , Price_unit_Min_1     TFloat  -- цена аптеки 
             , Price_unit_Max_1     TFloat  -- цена аптеки 
             
             , PartionDateKindId_3  Integer -- Id Срока
             , Remains_3            TFloat  -- Остаток (с учетом резерва) 
             , Price_unit_Min_3     TFloat  -- цена аптеки 
             , Price_unit_Max_3     TFloat  -- цена аптеки 

             , PartionDateKindId_6  Integer -- Id Срока
             , Remains_6            TFloat  -- Остаток (с учетом резерва) 
             , Price_unit_Min_6     TFloat  -- цена аптеки 
             , Price_unit_Max_6     TFloat  -- цена аптеки 
             
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;

   -- DECLARE inUnitId Integer;

   DECLARE vbIndex Integer;

   DECLARE vbQueryText Text;

   DECLARE vbDate_6 TDateTime;
   DECLARE vbDate_3 TDateTime;
   DECLARE vbDate_1 TDateTime;
   DECLARE vbDate_0 TDateTime;
   
   DECLARE vbPriceSamples TFloat;
   DECLARE vbSamples21 TFloat;
   DECLARE vbSamples22 TFloat;
   DECLARE vbSamples3 TFloat;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    -- vbUserId:= lpGetUserBySession (inSession);
    vbUserId:= inSession :: Integer;

    -- Результат
    RETURN QUERY
    SELECT p.Id
         , p.Name
         , p.NameUkr
         , p.deleted 

         , SUM(p.Remains)::TFloat

         , MIN(p.Price_unit_sale)::TFloat
         , MAX(p.Price_unit_sale)::TFloat

         , MAX(p.PartionDateKindId_1)::Integer
         , SUM(p.Remains_1)::TFloat
         , MIN(p.Price_unit_sale_1)::TFloat
         , MAX(p.Price_unit_sale_1)::TFloat
             
         , MAX(p.PartionDateKindId_3)::Integer
         , SUM(p.Remains_3)::TFloat
         , MIN(p.Price_unit_sale_3)::TFloat
         , MAX(p.Price_unit_sale_3)::TFloat

         , MAX(p.PartionDateKindId_6)::Integer
         , SUM(p.Remains_6)::TFloat
         , MIN(p.Price_unit_sale_6)::TFloat
         , MAX(p.Price_unit_sale_6)::TFloat

    FROM gpSelect_GoodsOnUnit_ForSiteMobile ('', inGoodsId::Text, inSession) AS p
    GROUP BY p.Id, p.Name, p.NameUkr, p.deleted;
       
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 08.06.22                                                                    *
*/

-- тест


SELECT p.* FROM gpSelect_GoodsPartionDate_ForSiteMobile (12520, zfCalc_UserSite()) AS p