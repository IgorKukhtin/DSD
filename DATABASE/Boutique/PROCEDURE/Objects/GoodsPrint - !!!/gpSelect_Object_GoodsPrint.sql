-- Function: gpSelect_Object_GoodsPrint (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsPrint (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsPrint(
    IN inUnitId      Integer,       --  подразделение 
    IN inUserId      Integer,       --  пользовать 
    IN inSession     TVarChar       --  сессия пользователя
)
RETURNS TABLE  (Num                  Integer
             , UnitId               Integer
             , UnitName             TVarChar
             , UserId               Integer
             , UserName             TVarChar
             , Amount               TFloat
             , InsertDate           TDateTime

             , InvNumber_Partion    TVarChar  
             , OperDate_Partion     TDateTime
             , GoodsName            TVarChar  
             , GroupNameFull        TVarChar  
             , BrandName            TVarChar  
             , PeriodName           TVarChar  
             , PeriodYear           Integer  
             , GoodsGroupName       TVarChar  
             , MeasureName          TVarChar  
             , CompositionName      TVarChar  
             , GoodsInfoName        TVarChar  
             , LineFabricaName      TVarChar  
             , LabelName            TVarChar  
             , GoodsSizeName        TVarChar
 ) 
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsPrint());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY
     WITH 
     tmpOrd AS (SELECT Object_GoodsPrint.UserId
                     , Object_GoodsPrint.InsertDate
                     , ROW_NUMBER() OVER( PARTITION BY Object_GoodsPrint.UserId ORDER BY Object_GoodsPrint.InsertDate)  AS ord  
                FROM Object_GoodsPrint
                GROUP BY Object_GoodsPrint.UserId
                       , Object_GoodsPrint.InsertDate
                ) 

       SELECT  
             tmpOrd.Ord               :: integer AS Id
           , Object_Unit.Id                      AS UnitId
           , Object_Unit.ValueData               AS UnitName
           , Object_User.Id                      AS UserId
           , Object_User.ValueData               AS UserName 
           , Object_GoodsPrint.Amount            AS Amount       
           , Object_GoodsPrint.InsertDate        AS InsertDate
           
           , Movement.InvNumber                  AS InvNumber_Partion
           , Movement.OperDate                   AS OperDate_Partion
           , Object_Goods.ValueData              AS GoodsName
           , Object_GroupNameFull.ValueData      As GroupNameFull
           , Object_Brand.ValueData              AS BrandName
           , Object_Period.ValueData             AS PeriodName
           , Object_PartionGoods.PeriodYear      AS PeriodYear
           , Object_GoodsGroup.ValueData         AS GoodsGroupName
           , Object_Measure.ValueData            AS MeasureName    
           , Object_Composition.ValueData        AS CompositionName
           , Object_GoodsInfo.ValueData          AS GoodsInfoName
           , Object_LineFabrica.ValueData        AS LineFabricaName
           , Object_Label.ValueData              AS LabelName
           , Object_GoodsSize.ValueData          AS GoodsSizeName
                               
       FROM Object_GoodsPrint 
            LEFT JOIN Object AS Object_Unit  ON Object_Unit.Id         = Object_GoodsPrint.UnitId 
            LEFT JOIN Object AS Object_User  ON Object_User.Id         = Object_GoodsPrint.UserId 
            
            LEFT JOIN Object_PartionGoods    ON Object_PartionGoods.MovementItemId = Object_GoodsPrint.PartionId 
            LEFT JOIN Movement               ON Movement.Id            = Object_PartionGoods.MovementId
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id        = Object_PartionGoods.GoodsId 
            
            LEFT JOIN  ObjectString AS Object_GroupNameFull
                                    ON Object_GroupNameFull.ObjectId = Object_Goods.Id
                                   AND Object_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()                   
            LEFT JOIN  Object AS Object_Brand            ON Object_Brand.Id            = Object_PartionGoods.BrandId
            LEFT JOIN  Object AS Object_Period           ON Object_Period.Id           = Object_PartionGoods.PeriodId
            LEFT JOIN  Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = Object_PartionGoods.GoodsGroupId
            LEFT JOIN  Object AS Object_Measure          ON Object_Measure.Id          = Object_PartionGoods.MeasureId
            LEFT JOIN  Object AS Object_Composition      ON Object_Composition.Id      = Object_PartionGoods.CompositionId
            LEFT JOIN  Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = Object_PartionGoods.GoodsInfoId
            LEFT JOIN  Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = Object_PartionGoods.LineFabricaId
            LEFT JOIN  Object AS Object_Label            ON Object_Label.Id            = Object_PartionGoods.LabelId
            LEFT JOIN  Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = Object_PartionGoods.GoodsSizeId
 
            LEFT JOIN  tmpOrd ON tmpOrd.UserId     = Object_GoodsPrint.UserId 
                             AND tmpOrd.InsertDate = Object_GoodsPrint.InsertDate
            
     WHERE (Object_GoodsPrint.UserId = inUserId OR inUserId = 0)
       AND (Object_GoodsPrint.UnitId = inUnitId OR inUnitId = 0)

        
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятыкин А.А.
17.08.17          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsPrint (inUnitId:=0, inUserId:= 0, inSession:=zfCalc_UserAdmin())
