-- Function: gpSelect_Cash_Overdue()

DROP FUNCTION IF EXISTS gpSelect_Cash_Overdue (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Cash_Overdue (
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (ORD Integer, id Integer,
               GoodsID Integer, GoodsCode Integer, GoodsName TVarChar,
               Amount TFloat, PriceWithVAT TFloat, ValueMin TFloat,
               ExpirationDate TDateTime,
               BranchDate TDateTime, Invnumber TVarChar, FromName TVarChar, ContractName TVarChar,
               PartionGoodsId Integer,
               ExpirationDateDialog TDateTime, AmountDialog TFloat,
               Cat_5 boolean,  DatePartionGoodsCat5 TDateTime,
               Price TFloat
              ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbLanguage TVarChar;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);
   vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
   IF vbUnitKey = '' THEN
      vbUnitKey := '0';
   END IF;
   vbUnitId := vbUnitKey::Integer;

   SELECT COALESCE (ObjectString_Language.ValueData, 'RU')::TVarChar                AS Language
   INTO vbLanguage
   FROM Object AS Object_User
                 
        LEFT JOIN ObjectString AS ObjectString_Language
               ON ObjectString_Language.ObjectId = Object_User.Id
              AND ObjectString_Language.DescId = zc_ObjectString_User_Language()
              
   WHERE Object_User.Id = vbUserId;    

  RETURN QUERY
  WITH
    tmpObject_Price AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                     AND ObjectFloat_Goods_Price.ValueData > 0
                                    THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                    ELSE ROUND (Price_Value.ValueData, 2)
                               END :: TFloat                           AS Price
                             , MCS_Value.ValueData                     AS MCSValue
                             , Price_Goods.ChildObjectId               AS GoodsId
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
                           -- Фикс цена для всей Сети
                           LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                  ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                 AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                   ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                  AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                        WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                          AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                        )
                        
  SELECT ROW_NUMBER()OVER(ORDER BY CASE WHEN vbLanguage = 'UA' AND COALESCE(Object_Goods.NameUkr, '') <> ''
                                        THEN Object_Goods.NameUkr
                                        ELSE Object_Goods.Name END)::Integer  AS ORD
       , Container.ID
       , Object_Goods.ID                                    AS GoodsID
       , Object_Goods.ObjectCode                            AS GoodsCode
       , CASE WHEN vbLanguage = 'UA' AND COALESCE(Object_Goods.NameUkr, '') <> ''
              THEN Object_Goods.NameUkr
              ELSE Object_Goods.Name END                    AS GoodsName
       , Container.Amount                                   AS Amount
       , ObjectFloat_PartionGoods_PriceWithVAT.ValueData    AS PriceWithVAT
       , ObjectFloat_PartionGoods_ValueMin.ValueData        AS ValueMin
       , ObjectDate_PartionGoods_ExpirationDate.ValueData   AS ExpirationDate
       , MovementDate_Branch.ValueData                      AS BranchDate
       , Movement_Income.Invnumber                          AS Invnumber
       , Object_From.ValueData                              AS FromName
       , Object_Contract.ValueData                          AS ContractName
       , ContainerLinkObject.ObjectId                       AS PartionGoodsId 

       , ObjectDate_PartionGoods_ExpirationDate.ValueData             AS ExpirationDateDialog
       , Container.Amount                                             AS AmountDialog
       , COALESCE(ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE)  AS Cat_5
       , ObjectDate_PartionGoods_Cat_5.ValueData                      AS DatePartionGoodsCat5
       , COALESCE(tmpObject_Price.Price,0)::TFloat                    AS Price
  FROM Container

       LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = Container.ObjectId
       LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId

       LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                    AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
       LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.ID = ContainerLinkObject.ObjectId

       LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_ValueMin
                             ON ObjectFloat_PartionGoods_ValueMin.ObjectId =  ContainerLinkObject.ObjectId
                            AND ObjectFloat_PartionGoods_ValueMin.DescId = zc_ObjectFloat_PartionGoods_ValueMin()

       LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_PriceWithVAT
                             ON ObjectFloat_PartionGoods_PriceWithVAT.ObjectId =  ContainerLinkObject.ObjectId
                            AND ObjectFloat_PartionGoods_PriceWithVAT.DescId = zc_ObjectFloat_PartionGoods_PriceWithVAT()

       LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_ExpirationDate
                            ON ObjectDate_PartionGoods_ExpirationDate.ObjectId =  ContainerLinkObject.ObjectId
                           AND ObjectDate_PartionGoods_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

       LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                               ON ObjectBoolean_PartionGoods_Cat_5.ObjectId =  ContainerLinkObject.ObjectId
                              AND ObjectBoolean_PartionGoods_Cat_5.DescId = zc_ObjectBoolean_PartionGoods_Cat_5()

       LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Cat_5
                            ON ObjectDate_PartionGoods_Cat_5.ObjectId =  ContainerLinkObject.ObjectId
                           AND ObjectDate_PartionGoods_Cat_5.DescId = zc_ObjectDate_PartionGoods_Cat_5()

       LEFT JOIN Movement AS Movement_Income ON Movement_Income.ID = Object_PartionGoods.ObjectCode

       LEFT JOIN MovementDate AS MovementDate_Branch
                              ON MovementDate_Branch.MovementId = Object_PartionGoods.ObjectCode
                             AND MovementDate_Branch.DescId = zc_MovementDate_Branch()

       LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                    ON MovementLinkObject_From.MovementId = Object_PartionGoods.ObjectCode
                                   AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
       LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

       LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                    ON MovementLinkObject_Contract.MovementId = Object_PartionGoods.ObjectCode
                                   AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
       LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

       LEFT OUTER JOIN tmpObject_Price ON tmpObject_Price.GoodsId = Object_Goods.ID 
       
  WHERE Container.DescId    = zc_Container_CountPartionDate()
    AND Container.WhereObjectId = vbUnitId
    AND ObjectDate_PartionGoods_ExpirationDate.ValueData <= CURRENT_DATE
    AND Container.Amount > 0
 -- !!!
 -- AND 1=0
  ORDER BY 5;

END;
$BODY$


LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.07.19                                                       *
 17.07.19                                                       *
 28.06.19                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Cash_Overdue('3')