-- Function: gpSelect_Movement_PriceList()

DROP FUNCTION IF EXISTS gpReport_MovementIncome_byPromo (Integer, Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MovementIncome_byPromo(
    IN inMovementId    Integer,     -- Ид документа маркетинга
    IN inRetailId      Integer,     -- Торговая сеть
    IN inStartDate     TDateTime, 
    IN inEndDate       TDateTime,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE ( GoodsCode   Integer      --Код товара
              , GoodsName   TVarChar     --Наименование товара
              , MakerName   TVarChar     --Производитель
              , NDSKindName TVarChar     --вид ндс
              , NDS         TFloat       -- % ндс
              , Price1      TFloat
              , Price2      TFloat
              , Price3      TFloat
              , Price4      TFloat
              , Price5      TFloat
              , Price6      TFloat
              , Price7      TFloat
              , Price8      TFloat
              , Price9      TFloat
              , Price10     TFloat
              , Price11     TFloat
              , Price12     TFloat
              , Price13     TFloat
              , Price14     TFloat
              , Price15     TFloat
              , Price16     TFloat
              , Price17     TFloat
              , Price18     TFloat
              , Price19     TFloat
              , Price20     TFloat
              , Price21     TFloat
              , Price22     TFloat
              , Price23     TFloat
              , Price24     TFloat
              , Price25     TFloat
              , Price26     TFloat
              , Price27     TFloat
              , Price28     TFloat
              , Price29     TFloat
              , Price30     TFloat
              , Price31     TFloat
              , Persent     TFloat
              
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpGetUserBySession (inSession);

    IF DATE_TRUNC('Month', inStartDate) <> DATE_TRUNC('Month', inEndDate) 
    THEN
         RAISE EXCEPTION 'Ошибка. Даты периода должны быть в пределе одного месяца.';
    END IF;

    inEndDate := inEndDate+interval '1 day';
    
     --если заполнены поставщики в документе, то отчет строим по ним
     CREATE TEMP TABLE tmpJuridical (JuridicalId Integer) ON COMMIT DROP; 
     INSERT INTO tmpJuridical (JuridicalId)
            SELECT MovementLinkObject_Juridical.ObjectId    AS JuridicalId
            FROM Movement 
                 JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                         ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
            WHERE Movement.ParentId = inMovementId
              AND Movement.DescId = zc_Movement_PromoPartner()
              AND Movement.StatusId <> zc_Enum_Status_Erased();
              
     -- если поставщики не выбраны, заполняем таблицу всеми поставщиками
     IF NOT EXISTS (SELECT JuridicalId FROM tmpJuridical) 
     THEN 
         INSERT INTO tmpJuridical (JuridicalId)
            SELECT Object.Id AS JuridicalId
            FROM Object
            WHERE Object.DescId = zc_Object_Juridical();
     END IF;

    RETURN QUERY
    WITH 
      -- cписок подразделений все или выбранной торг.сети
      tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                  FROM ObjectLink AS ObjectLink_Unit_Juridical
                     INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                           ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                          AND (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR inRetailId = 0)
                  WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                  )
                  
      -- товары тек.документа маркетинга
    , tmpGoodsPromo AS (SELECT DISTINCT MI_Goods.ObjectId AS GoodsId
                          FROM MovementItem AS MI_Goods
                          WHERE MI_Goods.MovementId = inMovementId
                            AND MI_Goods.DescId = zc_MI_Master()
                            AND MI_Goods.isErased = FALSE
                           )

      -- выбираем приходы с маркет. товарами
    , tmpMovMI AS (SELECT Movement.Id                       AS MovementId
                        , MovementDate_Branch.ValueData     AS BranchDate
                        , MI_Master.ObjectId                AS GoodsId
                        , MIFloat_Price.ValueData ::TFloat  AS Price  
                        
                   FROM Movement 
                        INNER JOIN MovementDate AS MovementDate_Branch
                                                ON MovementDate_Branch.MovementId = Movement.Id
                                               AND MovementDate_Branch.DescId = zc_MovementDate_Branch()
                                               AND MovementDate_Branch.ValueData >= inStartDate AND MovementDate_Branch.ValueData < inEndDate 

                        LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                     ON MovementLinkObject_To.MovementId = Movement.Id
                                                    AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                        INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_To.ObjectId
                        
                        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                     ON MovementLinkObject_From.MovementId = Movement.Id
                                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                        INNER JOIN tmpJuridical ON tmpJuridical.JuridicalId = MovementLinkObject_From.ObjectId
                                                
                        INNER JOIN MovementItem AS MI_Master 
                                                ON MI_Master.MovementId = Movement.Id
                                               AND MI_Master.DescId = zc_MI_Master()
                                               AND MI_Master.IsErased = FALSE
  
                        INNER JOIN tmpGoodsPromo ON tmpGoodsPromo.GoodsId = MI_Master.ObjectId
                        
                        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                    ON MIFloat_Price.MovementItemId = MI_Master.Id
                                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()

                   WHERE Movement.DescId = zc_Movement_Income()
                     AND Movement.StatusId = zc_Enum_Status_Complete()
                   )
 
    -- получаем свойства Документов прихода для расчета цены с НДС
    , tmpMov AS (SELECT  tmpMovMI.MovementId           
                       , COALESCE(MovementBoolean_PriceWithVAT.ValueData,False)  AS PriceWithVAT
                       , ObjectFloat_NDSKind_NDS.ValueData AS NDS
                 FROM (SELECT DISTINCT tmpMovMI.MovementId
                       FROM tmpMovMI
                       ) AS tmpMovMI 
                         LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                ON MovementBoolean_PriceWithVAT.MovementId = tmpMovMI.MovementId
                               AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
 
                         LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                ON MovementLinkObject_NDSKind.MovementId = tmpMovMI.MovementId
                               AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                         LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                               AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 
                  )
                  
    , tmpData AS (SELECT DISTINCT
                         tmpMovMI.GoodsId
                       , EXTRACT(DAY FROM tmpMovMI.BranchDate)  AS NumDay
                       , tmpMov.NDS
                       , CASE WHEN COALESCE(tmpMov.PriceWithVAT,False) = TRUE THEN tmpMovMI.Price
                              ELSE (tmpMovMI.Price * (1 + tmpMov.NDS /100)) ::TFloat
                         END    AS PriceWithVAT
                  FROM tmpMovMI 
                       LEFT JOIN tmpMov ON tmpMov.MovementId = tmpMovMI.MovementId
                 )
    , tmpDataCase AS (SELECT tmpData.GoodsId
                           , SUM (tmpData.Price1)  AS Price1
                           , SUM (tmpData.Price2)  AS Price2
                           , SUM (tmpData.Price3)  AS Price3
                           , SUM (tmpData.Price4)  AS Price4
                           , SUM (tmpData.Price5)  AS Price5
                           , SUM (tmpData.Price6)  AS Price6
                           , SUM (tmpData.Price7)  AS Price7
                           , SUM (tmpData.Price8)  AS Price8
                           , SUM (tmpData.Price9)  AS Price9
                           , SUM (tmpData.Price10) AS Price10
                           , SUM (tmpData.Price11) AS Price11
                           , SUM (tmpData.Price12) AS Price12
                           , SUM (tmpData.Price13) AS Price13
                           , SUM (tmpData.Price14) AS Price14
                           , SUM (tmpData.Price15) AS Price15
                           , SUM (tmpData.Price16) AS Price16
                           , SUM (tmpData.Price17) AS Price17
                           , SUM (tmpData.Price18) AS Price18
                           , SUM (tmpData.Price19) AS Price19
                           , SUM (tmpData.Price20) AS Price20
                           , SUM (tmpData.Price21) AS Price21
                           , SUM (tmpData.Price22) AS Price22
                           , SUM (tmpData.Price23) AS Price23
                           , SUM (tmpData.Price24) AS Price24
                           , SUM (tmpData.Price25) AS Price25
                           , SUM (tmpData.Price26) AS Price26
                           , SUM (tmpData.Price27) AS Price27
                           , SUM (tmpData.Price28) AS Price28
                           , SUM (tmpData.Price29) AS Price29
                           , SUM (tmpData.Price30) AS Price30
                           , SUM (tmpData.Price31) AS Price31
                           
                      FROM (SELECT tmpData.GoodsId
                                 , CASE WHEN tmpData.NumDay  = 1  THEN tmpData.PriceWithVAT ELSE 0 END AS Price1
                                 , CASE WHEN tmpData.NumDay = 2  THEN tmpData.PriceWithVAT ELSE 0 END AS Price2
                                 , CASE WHEN tmpData.NumDay = 3  THEN tmpData.PriceWithVAT ELSE 0 END AS Price3
                                 , CASE WHEN tmpData.NumDay = 4  THEN tmpData.PriceWithVAT ELSE 0 END AS Price4
                                 , CASE WHEN tmpData.NumDay = 5  THEN tmpData.PriceWithVAT ELSE 0 END AS Price5
                                 , CASE WHEN tmpData.NumDay = 6  THEN tmpData.PriceWithVAT ELSE 0 END AS Price6
                                 , CASE WHEN tmpData.NumDay = 7  THEN tmpData.PriceWithVAT ELSE 0 END AS Price7
                                 , CASE WHEN tmpData.NumDay = 8  THEN tmpData.PriceWithVAT ELSE 0 END AS Price8
                                 , CASE WHEN tmpData.NumDay = 9  THEN tmpData.PriceWithVAT ELSE 0 END AS Price9
                                 , CASE WHEN tmpData.NumDay = 10 THEN tmpData.PriceWithVAT ELSE 0 END AS Price10
                                 , CASE WHEN tmpData.NumDay = 11 THEN tmpData.PriceWithVAT ELSE 0 END AS Price11
                                 , CASE WHEN tmpData.NumDay = 12 THEN tmpData.PriceWithVAT ELSE 0 END AS Price12
                                 , CASE WHEN tmpData.NumDay = 13 THEN tmpData.PriceWithVAT ELSE 0 END AS Price13
                                 , CASE WHEN tmpData.NumDay = 14 THEN tmpData.PriceWithVAT ELSE 0 END AS Price14
                                 , CASE WHEN tmpData.NumDay = 15 THEN tmpData.PriceWithVAT ELSE 0 END AS Price15
                                 , CASE WHEN tmpData.NumDay = 16 THEN tmpData.PriceWithVAT ELSE 0 END AS Price16
                                 , CASE WHEN tmpData.NumDay = 17 THEN tmpData.PriceWithVAT ELSE 0 END AS Price17
                                 , CASE WHEN tmpData.NumDay = 18 THEN tmpData.PriceWithVAT ELSE 0 END AS Price18
                                 , CASE WHEN tmpData.NumDay = 19 THEN tmpData.PriceWithVAT ELSE 0 END AS Price19
                                 , CASE WHEN tmpData.NumDay = 20 THEN tmpData.PriceWithVAT ELSE 0 END AS Price20
                                 , CASE WHEN tmpData.NumDay = 21 THEN tmpData.PriceWithVAT ELSE 0 END AS Price21
                                 , CASE WHEN tmpData.NumDay = 22 THEN tmpData.PriceWithVAT ELSE 0 END AS Price22
                                 , CASE WHEN tmpData.NumDay = 23 THEN tmpData.PriceWithVAT ELSE 0 END AS Price23
                                 , CASE WHEN tmpData.NumDay = 24 THEN tmpData.PriceWithVAT ELSE 0 END AS Price24
                                 , CASE WHEN tmpData.NumDay = 25 THEN tmpData.PriceWithVAT ELSE 0 END AS Price25
                                 , CASE WHEN tmpData.NumDay = 26 THEN tmpData.PriceWithVAT ELSE 0 END AS Price26
                                 , CASE WHEN tmpData.NumDay = 27 THEN tmpData.PriceWithVAT ELSE 0 END AS Price27
                                 , CASE WHEN tmpData.NumDay = 28 THEN tmpData.PriceWithVAT ELSE 0 END AS Price28
                                 , CASE WHEN tmpData.NumDay = 29 THEN tmpData.PriceWithVAT ELSE 0 END AS Price29
                                 , CASE WHEN tmpData.NumDay = 30 THEN tmpData.PriceWithVAT ELSE 0 END AS Price30
                                 , CASE WHEN tmpData.NumDay = 31 THEN tmpData.PriceWithVAT ELSE 0 END AS Price31
                                 
                            FROM (SELECT tmpData.NumDay, tmpData.GoodsId, MIN(tmpData.PriceWithVAT) AS PriceWithVAT
                                  FROM tmpData 
                                  GROUP BY tmpData.NumDay, tmpData.GoodsId
                                  ) AS tmpData
                            ) AS tmpData
                      GROUP BY tmpData.GoodsId
                     )
                     
      -- результат
      SELECT  Object_Goods.ObjectCode                  AS GoodsCode
            , Object_Goods.ValueData                   AS GoodsName
            , ObjectString_Goods_Maker.ValueData       AS MakerName
            , Object_NDSKind.ValueData                 AS NDSKindName
            , ObjectFloat_NDSKind_NDS.ValueData        AS NDS
            
            , tmpData.Price1                ::TFloat
            , tmpData.Price2                ::TFloat
            , tmpData.Price3                ::TFloat
            , tmpData.Price4                ::TFloat
            , tmpData.Price5                ::TFloat
            , tmpData.Price6                ::TFloat
            , tmpData.Price7                ::TFloat
            , tmpData.Price8                ::TFloat
            , tmpData.Price9                ::TFloat
            , tmpData.Price10               ::TFloat
            , tmpData.Price11               ::TFloat
            , tmpData.Price12               ::TFloat
            , tmpData.Price13               ::TFloat
            , tmpData.Price14               ::TFloat
            , tmpData.Price15               ::TFloat
            , tmpData.Price16               ::TFloat
            , tmpData.Price17               ::TFloat
            , tmpData.Price18               ::TFloat
            , tmpData.Price19               ::TFloat
            , tmpData.Price20               ::TFloat
            , tmpData.Price21               ::TFloat
            , tmpData.Price22               ::TFloat
            , tmpData.Price23               ::TFloat
            , tmpData.Price24               ::TFloat
            , tmpData.Price25               ::TFloat
            , tmpData.Price26               ::TFloat
            , tmpData.Price27               ::TFloat
            , tmpData.Price28               ::TFloat
            , tmpData.Price29               ::TFloat
            , tmpData.Price30               ::TFloat
            , tmpData.Price31               ::TFloat
            , 0                             ::TFloat AS Persent

      FROM tmpDataCase AS tmpData
      
        LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                               ON ObjectString_Goods_Maker.ObjectId = tmpData.GoodsId
                              AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker() 

        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId

        LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                             ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
        LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId

        LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                              ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId 
                             AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
      ORDER BY 2                                   
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 12.10.16         *
*/

-- тест
-- select * from gpReport_MovementIncome_byPromo(inMovementId := 3712500  , inRetailId := 4 , inStartDate := ('01.09.2016')::TDateTime , inEndDate := ('01.11.2016')::TDateTime ,  inSession := '3');