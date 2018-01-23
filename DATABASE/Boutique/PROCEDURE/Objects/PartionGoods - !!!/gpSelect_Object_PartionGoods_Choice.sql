-- Function: gpSelect_Object_PartionGoods (Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_PartionGoods_Choice (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PartionGoods_Choice(
    IN inUnitId      Integer,       --  
    IN inIsShowAll   Boolean,       --  признак показать удаленные да/нет
    IN inSessiON     TVarChar       --  сессия пользователя
)
RETURNS TABLE (Id                   Integer           
             , MovementItemId       Integer
             , MovementId           Integer
             , InvNumber            TVarChar  
             , InvNumber_Full       TVarChar
             --, SybaseId             Integer  
             , PartnerName          TVarChar  
             , UnitName             TVarChar  
             , OperDate             TDateTime
             , GoodsId              Integer
             , GoodsCode            Integer
             , GoodsName            TVarChar  
             , GroupNameFull        TVarChar  
             , CurrencyName         TVarChar  
             , Amount               TFloat  
             , Remains              TFloat
             , AmountDebt           TFloat
             , RemainsWithDebt      TFloat
             , OperPrice            TFloat
             , PriceSale            TFloat
             , BrandName            TVarChar  
             , PeriodName           TVarChar  
             , PeriodYear           Integer  
             , FabrikaName          TVarChar  
             , GoodsGroupName       TVarChar  
             , MeasureName          TVarChar  
             , CompositionName      TVarChar  
             , GoodsInfoName        TVarChar  
             , LineFabricaName      TVarChar  
             , LabelName            TVarChar  
             , CompositionGroupName TVarChar 
             , GoodsSizeId          Integer   
             , GoodsSizeName        TVarChar  
             , isErased             Boolean  
             , isArc                Boolean  

) 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_PartionGoods());
     vbUserId:= lpGetUserBySessiON (inSession);
     -- определяется - может ли пользовать видеть весь справочник
     -- vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- Результат
     RETURN QUERY 
       WITH 
       tmpDebt AS (SELECT Container.PartionId     AS PartionId
                        , Container.ObjectId      AS GoodsId
                        , SUM (Container.Amount)  AS Amount
                   FROM Container
                        INNER JOIN ContainerLinkObject AS CLO_Client
                                                       ON CLO_Client.ContainerId = Container.Id
                                                      AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                   WHERE Container.DescId = zc_Container_count()
                     AND Container.WhereObjectId = inUnitId
                   GROUP BY Container.PartionId
                          , Container.ObjectId
                   HAVING SUM (Container.Amount) <> 0 
                   )
                        
       SELECT Object_PartionGoods.MovementItemId  AS Id
            , Object_PartionGoods.MovementItemId  AS MovementItemId
            , Movement.Id                         AS MovementId
            , Movement.InvNumber                  AS InvNumber
            , ('№ ' || Movement.InvNumber ||' от '||zfConvert_DateToString(Movement.OperDate) ) :: TVarChar AS InvNumber_full         
            , Object_Partner.ValueData            AS PartnerName
            , Object_Unit.ValueData               AS UnitName
            , Object_PartionGoods.OperDate        AS OperDate
            , Object_PartionGoods.GoodsId         AS GoodsId
            , Object_Goods.ObjectCode             AS GoodsCode
            , Object_Goods.ValueData              AS GoodsName
            , Object_GroupNameFull.ValueData      As GroupNameFull
            , Object_Currency.ValueData           AS CurrencyName
            , Object_PartionGoods.Amount          AS Amount
            , COALESCE (Container.Amount,0) ::TFloat AS Remains
            , COALESCE (tmpDebt.Amount, 0)  ::TFloat AS AmountDebt
            , ( COALESCE (Container.Amount,0) + COALESCE (tmpDebt.Amount, 0))  ::TFloat AS RemainsWithDebt
                    
            , Object_PartionGoods.OperPrice       AS OperPrice
            --, tmpPrice.ValuePrice                 AS PriceSale
            , Object_PartionGoods.PriceSale
            , Object_Brand.ValueData              AS BrandName
            , Object_Period.ValueData             AS PeriodName
            , Object_PartionGoods.PeriodYear      AS PeriodYear
            , Object_Fabrika.ValueData            AS FabrikaName
            , Object_GoodsGroup.ValueData         AS GoodsGroupName
            , Object_Measure.ValueData            AS MeasureName    
            , Object_Composition.ValueData        AS CompositionName
            , Object_GoodsInfo.ValueData          AS GoodsInfoName
            , Object_LineFabrica.ValueData        AS LineFabricaName
            , Object_Label.ValueData              AS LabelName
            , Object_CompositionGroup.ValueData   AS CompositionGroupName
            , Object_GoodsSize.Id                 AS GoodsSizeId           
            , Object_GoodsSize.ValueData          AS GoodsSizeName
            , Object_PartionGoods.isErased        AS isErased
            , Object_PartionGoods.isArc           AS isArc
           
       FROM Container
           LEFT JOIN ContainerLinkObject AS CLO_Client
                                         ON CLO_Client.ContainerId = Container.Id
                                        AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()

           LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = Container.PartionId
                                        AND Object_PartionGoods.isErased       = FALSE
                                        -- !!!обязательно условие, т.к. мог меняться GoodsId и тогда в Container - несколько строк!!!
                                        AND Object_PartionGoods.GoodsId        = Container.ObjectId

           LEFT JOIN  Object AS Object_Partner ON Object_Partner.Id = Object_PartionGoods.PartnerId
           LEFT JOIN  Object AS Object_Unit    ON Object_Unit.Id    = Object_PartionGoods.UnitId
           LEFT JOIN  Object AS Object_Goods   ON Object_Goods.Id   = Object_PartionGoods.GoodsId

           LEFT JOIN  ObjectString AS Object_GroupNameFull
                                   ON Object_GroupNameFull.ObjectId = Object_Goods.Id
                                  AND Object_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()                   

           LEFT JOIN  Object AS Object_Currency         ON Object_Currency.Id         = Object_PartionGoods.CurrencyId
           LEFT JOIN  Object AS Object_Brand            ON Object_Brand.Id            = Object_PartionGoods.BrandId
           LEFT JOIN  Object AS Object_Period           ON Object_Period.Id           = Object_PartionGoods.PeriodId
           LEFT JOIN  Object AS Object_Fabrika          ON Object_Fabrika.Id          = Object_PartionGoods.FabrikaId
           LEFT JOIN  Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = Object_PartionGoods.GoodsGroupId
           LEFT JOIN  Object AS Object_Measure          ON Object_Measure.Id          = Object_PartionGoods.MeasureId
           LEFT JOIN  Object AS Object_CompositiON      ON Object_Composition.Id      = Object_PartionGoods.CompositionId
           LEFT JOIN  Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = Object_PartionGoods.GoodsInfoId
           LEFT JOIN  Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = Object_PartionGoods.LineFabricaId
           LEFT JOIN  Object AS Object_Label            ON Object_Label.Id            = Object_PartionGoods.LabelId
           LEFT JOIN  Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = Object_PartionGoods.CompositionGroupId
           LEFT JOIN  Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = Object_PartionGoods.GoodsSizeId

           LEFT JOIN  Movement ON Movement.Id = Object_PartionGoods.MovementId

           LEFT JOIN tmpDebt ON tmpDebt.PartionId = Object_PartionGoods.MovementItemId
                            AND tmpDebt.GoodsId   = Object_PartionGoods.GoodsId
                            
     WHERE Container.DescId = zc_Container_Count()
       AND Container.WhereObjectId = inUnitId
       AND (COALESCE (Container.Amount,0) <> 0 OR inIsShowAll = TRUE)       
       AND CLO_Client.ContainerId IS NULL -- !!!отбросили Долги Покупателей!!!
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятыкин А.А.
23.01.18          *
29.06.17          *
21.06.17          *
09.05.17          *
25.04.17          * _Choice
15.03.17                                                           *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PartionGoods_Choice (506,TRUE, zfCalc_UserAdmin())