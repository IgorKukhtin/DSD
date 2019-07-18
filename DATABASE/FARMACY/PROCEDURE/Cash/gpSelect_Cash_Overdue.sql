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
               Cat_5 boolean
              ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);
   vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
   IF vbUnitKey = '' THEN
      vbUnitKey := '0';
   END IF;
   vbUnitId := vbUnitKey::Integer;


  RETURN QUERY
  SELECT ROW_NUMBER()OVER(ORDER BY Object_Goods.ValueData)::Integer  AS ORD
       , Container.ID
       , Object_Goods.ID                                    AS GoodsID
       , Object_Goods.ObjectCode                            AS GoodsCode
       , Object_Goods.ValueData                             AS GoodsName
       , Container.Amount                                   AS Amount
       , ObjectFloat_PartionGoods_PriceWithVAT.ValueData    AS PriceWithVAT
       , ObjectFloat_PartionGoods_ValueMin.ValueData        AS ValueMin
       , ObjectFloat_PartionGoods_ExpirationDate.ValueData  AS ExpirationDate
       , MovementDate_Branch.ValueData                      AS BranchDate
       , Movement_Income.Invnumber                          AS Invnumber
       , Object_From.ValueData                              AS FromName
       , Object_Contract.ValueData                          AS ContractName
       , ContainerLinkObject.ObjectId                       AS PartionGoodsId 

       , ObjectFloat_PartionGoods_ExpirationDate.ValueData            AS ExpirationDateDialog
       , Container.Amount                                             AS AmountDialog
       , COALESCE(ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE)  AS Cat_5
  FROM Container

       LEFT JOIN Object AS Object_Goods ON Object_Goods.ID = Container.ObjectId

       LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                    AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
       LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.ID = ContainerLinkObject.ObjectId

       LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_ValueMin
                             ON ObjectFloat_PartionGoods_ValueMin.ObjectId =  ContainerLinkObject.ObjectId
                            AND ObjectFloat_PartionGoods_ValueMin.DescId = zc_ObjectFloat_PartionGoods_ValueMin()

       LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_PriceWithVAT
                             ON ObjectFloat_PartionGoods_PriceWithVAT.ObjectId =  ContainerLinkObject.ObjectId
                            AND ObjectFloat_PartionGoods_PriceWithVAT.DescId = zc_ObjectFloat_PartionGoods_PriceWithVAT()

       LEFT JOIN ObjectDate AS ObjectFloat_PartionGoods_ExpirationDate
                            ON ObjectFloat_PartionGoods_ExpirationDate.ObjectId =  ContainerLinkObject.ObjectId
                           AND ObjectFloat_PartionGoods_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

       LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                               ON ObjectBoolean_PartionGoods_Cat_5.ObjectId =  ContainerLinkObject.ObjectId
                              AND ObjectBoolean_PartionGoods_Cat_5.DescId = zc_ObjectBoolean_PartionGoods_Cat_5()

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

  WHERE Container.DescId    = zc_Container_CountPartionDate()
    AND Container.WhereObjectId = vbUnitId
    AND ObjectFloat_PartionGoods_ExpirationDate.ValueData <= CURRENT_DATE
    AND Container.Amount > 0
  ORDER BY Object_Goods.ValueData;

END;
$BODY$


LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.07.19                                                       *
 28.06.19                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Cash_Overdue('3')