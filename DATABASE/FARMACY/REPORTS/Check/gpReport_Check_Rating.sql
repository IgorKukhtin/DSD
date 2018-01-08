-- Function:  gpReport_Movement_Check_Light()

DROP FUNCTION IF EXISTS gpReport_Check_Rating (Integer, Integer, TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Check_Rating(
    IN inRetailId         Integer  ,  -- ссылка на торг.сеть
    IN inGoodsId          Integer  ,  -- ссылка на товар
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inIsFarm           Boolean,    -- для ограничей для фармацевта
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (
  UserCode              Integer,
  UserName              TVarChar,
  JuridicalName         TVarChar,
  UnitName              TVarChar,
  Address               TVarChar,
  GoodsId               Integer, 
  GoodsCode             Integer, 
  GoodsName             TVarChar,
  GoodsGroupName        TVarChar, 
  NDSKindName           TVarChar,
  NDS                   TFloat,
  Amount                TFloat,
  Price                 TFloat,
  PriceSale             TFloat,
  PriceWithVAT          Tfloat,      --Цена поставщика с учетом НДС (без % корр.)
  PriceWithOutVAT       Tfloat, 
  Summa                 TFloat,
  SummaSale             TFloat,
  SummaWithVAT          Tfloat,      --Сумма поставщика с учетом НДС (без % корр.)
  SummaWithOutVAT       Tfloat,
  Ord_Rating            Integer
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDateStartPromo TDateTime;
   DECLARE vbDatEndPromo TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

  
    -- Результат
    RETURN QUERY
    WITH
    tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId     AS UnitId
                FROM ObjectLink AS ObjectLink_Unit_Juridical
                     INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                           ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                          AND (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR inRetailId = 0)
                WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                )
    
  , tmpUser AS (SELECT DISTINCT ObjectLink_User_Member.ObjectId    AS UserId
                     , ObjectLink_Personal_Unit.ChildObjectId      AS UnitId
                FROM ObjectLink AS ObjectLink_Personal_Member
                     LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                          ON ObjectLink_Personal_Unit.ObjectId = ObjectLink_Personal_Member.ObjectId
                                         AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                     INNER JOIN tmpUnit ON tmpUnit.UnitId = ObjectLink_Personal_Unit.ChildObjectId
                     
                     INNER JOIN ObjectLink AS ObjectLink_User_Member
                                           ON ObjectLink_User_Member.ChildObjectId = ObjectLink_Personal_Member.ChildObjectId
                                          AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
    
                WHERE ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
               )         
  , tmpData_Container AS (SELECT COALESCE (MIContainer.AnalyzerId,0)         AS MovementItemId_Income
                               , MIContainer.MovementId                      AS MovementId_Check
                               , MIContainer.ObjectId_analyzer               AS GoodsId
                               , MIContainer.WhereObjectId_analyzer          AS UnitId
                               , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS Amount
                               , SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0)) AS SummaSale
                          FROM MovementItemContainer AS MIContainer
                               INNER JOIN tmpUnit ON tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                          WHERE MIContainer.DescId = zc_MIContainer_Count()
                            AND MIContainer.MovementDescId = zc_Movement_Check()
                            AND MIContainer.OperDate >= inStartDate AND MIContainer.OperDate < inEndDate + INTERVAL '1 DAY'
                            AND MIContainer.ObjectId_analyzer = inGoodsId
                          GROUP BY COALESCE (MIContainer.AnalyzerId,0)
                                 , MIContainer.ObjectId_analyzer 
                                 , MIContainer.MovementId
                                 , MIContainer.WhereObjectId_analyzer
                          HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                          )
                          
  , tmpData_all AS (SELECT tmpData_Container.MovementId_Check 
                         , COALESCE (MI_Income_find.Id,         MI_Income.Id)         :: Integer AS MovementItemId
                         , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) :: Integer AS MovementId
                         , tmpData_Container.GoodsId                                             AS GoodsId
                         , tmpData_Container.UnitId                                              AS UnitId
                         , SUM (COALESCE (tmpData_Container.Amount, 0))                          AS Amount
                         , SUM (COALESCE (tmpData_Container.SummaSale, 0))                       AS SummaSale
                    FROM tmpData_Container

                          -- элемент прихода
                         LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = tmpData_Container.MovementItemId_Income

                         -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                         LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                     ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                    AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                         -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                         LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

                   GROUP BY COALESCE (MI_Income_find.Id,         MI_Income.Id)
                          , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) 
                          , MI_Income.MovementId
                          , MI_Income_find.MovementId  
                          , tmpData_Container.GoodsId
                          , tmpData_Container.MovementId_Check
                          , tmpData_Container.UnitId
                   )

           , tmpData AS (SELECT tmpData_all.MovementId_Check                                               AS MovementId_Check
                              , MovementLinkObject_From_Income.ObjectId                                    AS JuridicalId_Income
                              , tmpData_all.GoodsId                                                        AS GoodsId
                              , tmpData_all.UnitId                                                         AS UnitId
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))  AS Summa
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_PriceWithOutVAT.ValueData, 0)) AS SummaWithOutVAT
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0))    AS SummaWithVAT
                              , SUM (tmpData_all.Amount)                                                   AS Amount
                              , SUM (tmpData_all.SummaSale)                                                AS SummaSale
                         FROM tmpData_all
                              -- цена с учетом НДС, для элемента прихода от поставщика (или NULL)
                              LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                                          ON MIFloat_JuridicalPrice.MovementItemId = tmpData_all.MovementItemId
                                                         AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                              -- цена с учетом НДС, для элемента прихода от поставщика без % корректировки  (или NULL)
                              LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                                          ON MIFloat_PriceWithVAT.MovementItemId = tmpData_all.MovementItemId
                                                         AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
                              -- цена без учета НДС, для элемента прихода от поставщика без % корректировки  (или NULL)
                              LEFT JOIN MovementItemFloat AS MIFloat_PriceWithOutVAT
                                                          ON MIFloat_PriceWithOutVAT.MovementItemId = tmpData_all.MovementItemId
                                                         AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT()
                              -- Поставшик, для элемента прихода от поставщика (или NULL)
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_From_Income
                                                           ON MovementLinkObject_From_Income.MovementId = tmpData_all.MovementId
                                                          AND MovementLinkObject_From_Income.DescId     = zc_MovementLinkObject_From()
                         GROUP BY MovementLinkObject_From_Income.ObjectId
                                , tmpData_all.GoodsId
                                , tmpData_all.MovementId_Check
                                , tmpData_all.UnitId
                        )

   , tmpDataRez_ AS (SELECT MLO_Insert.ObjectId           AS UserId
                          , STRING_AGG (Object_From_Income.ValueData, ', ')  AS JuridicalName
                          , tmpData.GoodsId
                          , tmpData.UnitId
                          , SUM (tmpData.Summa)           AS Summa
                          , SUM (tmpData.SummaWithOutVAT) AS SummaWithOutVAT
                          , SUM (tmpData.SummaWithVAT)    AS SummaWithVAT
                          , SUM (tmpData.Amount)          AS Amount
                          , SUM (tmpData.SummaSale)       AS SummaSale
                     FROM tmpData
                          LEFT JOIN MovementLinkObject AS MLO_Insert
                                                       ON MLO_Insert.MovementId = tmpData.MovementId_Check
                                                      AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
                          LEFT JOIN Object AS Object_From_Income ON Object_From_Income.Id = tmpData.JuridicalId_Income
                     GROUP BY MLO_Insert.ObjectId
                            , tmpData.GoodsId
                            , tmpData.UnitId
                     )
   , tmpDataRez AS (SELECT COALESCE (tmpDataRez_.UserId, tmpUser.UserId)     AS UserId
                         , COALESCE (tmpDataRez_.JuridicalName, '')          AS JuridicalName
                         , COALESCE (tmpDataRez_.GoodsId, inGoodsId)         AS GoodsId
                         , COALESCE (tmpDataRez_.UnitId, tmpUser.UnitId)     AS UnitId
                         , COALESCE (tmpDataRez_.Summa, 0)                   AS Summa
                         , COALESCE (tmpDataRez_.SummaWithOutVAT, 0)         AS SummaWithOutVAT
                         , COALESCE (tmpDataRez_.SummaWithVAT, 0)            AS SummaWithVAT
                         , COALESCE (tmpDataRez_.Amount, 0)                  AS Amount
                         , COALESCE (tmpDataRez_.SummaSale, 0)               AS SummaSale
                   FROM tmpDataRez_
                        FULL JOIN tmpUser ON tmpUser.UserId = tmpDataRez_.UserId
                                         AND tmpUser.UnitId = tmpDataRez_.UnitId)


        -- результат
        SELECT Object_User.ObjectCode                                            AS UserCode
             , Object_User.ValueData                                             AS UserName
             , tmpData.JuridicalName                                 :: TVarchar AS JuridicalName
             , Object_Unit.ValueData                                             AS UnitName
             , ObjectString_Unit_Address.ValueData                   :: TVarchar AS Address
             , Object_Goods.Id                                                   AS GoodsId
             , Object_Goods.ObjectCode                                           AS GoodsCode
             , Object_Goods.ValueData                                            AS GoodsName
             , Object_GoodsGroup.ValueData                                       AS GoodsGroupName
             , Object_NDSKind.ValueData                                          AS NDSKindName
             , ObjectFloat_NDSKind_NDS.ValueData                                 AS NDS
  
             , CASE WHEN inIsFarm = FALSE THEN tmpData.Amount ELSE 0 END                              :: TFloat AS Amount
  
             , CASE WHEN tmpData.Amount <> 0 THEN tmpData.Summa           / tmpData.Amount ELSE 0 END :: TFloat AS Price
             , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaSale       / tmpData.Amount ELSE 0 END :: TFloat AS PriceSale
             , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaWithVAT    / tmpData.Amount ELSE 0 END :: TFloat AS PriceWithVAT
             , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaWithOutVAT / tmpData.Amount ELSE 0 END :: TFloat AS PriceWithOutVAT
  
             , tmpData.Summa           :: TFloat AS Summa
             , tmpData.SummaSale       :: TFloat AS SummaSale
             , tmpData.SummaWithVAT    :: TFloat AS SummaWithVAT
             , tmpData.SummaWithOutVAT :: TFloat AS SummaWithOutVAT
             
             , Row_Number() OVER (ORDER BY tmpData.Amount Desc)  ::integer  AS Ord_Rating

        FROM tmpDataRez AS tmpData
             LEFT JOIN Object AS Object_User  ON Object_User.Id  = tmpData.UserId
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
             LEFT JOIN Object AS Object_Unit  ON Object_Unit.Id  = tmpData.UnitId

             LEFT JOIN ObjectString AS ObjectString_Unit_Address
                                    ON ObjectString_Unit_Address.ObjectId = Object_Unit.Id
                                   AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()
                              
             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                  ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                  ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
             LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId

             LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                   ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId 
                                  AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()  

        ORDER BY Object_GoodsGroup.ValueData
               , Object_Goods.ValueData
;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 07.01.18         *
 08.09.17         *
*/

-- тест
-- select * from gpReport_Check_Rating(inRetailId := 4 , inGoodsId := 42658 , inStartDate := ('01.08.2017')::TDateTime , inEndDate := ('04.08.2017')::TDateTime , inIsFarm := 'FALSE' ,  inSession := '3');