-- Function: gpSelect_Cash_OverdueChange()

DROP FUNCTION IF EXISTS gpSelect_Cash_OverdueChange (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Cash_OverdueChange (
    IN inUnitId         Integer,       -- Подразделение
    IN inGoodsId        Integer,       -- Товар
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (ContainerID Integer,
               GoodsID Integer, GoodsCode Integer, GoodsName TVarChar,
               Amount TFloat, ExpirationDate TDateTime,
               ContainerPGID Integer, AmountPG TFloat, ExpirationDatePG TDateTime,
               BranchDate TDateTime, Invnumber TVarChar, FromName TVarChar, ContractName TVarChar,
               ExpirationDateDialog TDateTime, AmountDialog TFloat,
               Cat_5 boolean, DatePartionGoodsCat5 TDateTime,
               ContainerChangeID Integer
              ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGuudsId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);

  IF COALESCE (inUnitId, 0) = 0
  THEN
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    inUnitId := vbUnitKey::Integer;
  END IF;

  RETURN QUERY
  WITH   tmpContainer AS (SELECT Container.Id, Container.ObjectId, Container.Amount
                          FROM Container
                          WHERE Container.DescId = zc_Container_Count()
                            AND Container.WhereObjectId = inUnitId
                            AND Container.ObjectId      = inGoodsId
                            AND Container.Amount <> 0
                         )
       , tmpExpirationDate AS (SELECT tmp.Id       AS ContainerId
                                    , MIDate_ExpirationDate.ValueData
                                    , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) AS MovementId
                               FROM tmpContainer AS tmp
                                  LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                ON ContainerLinkObject_MovementItem.Containerid = tmp.Id
                                                               AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                  LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                  -- элемент прихода
                                  LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                  -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                  LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                              ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                             AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                  -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                  LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                                                       -- AND 1=0
                                   LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                                    ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                                   AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                               )

  SELECT Container.ID                                                      AS ContainerID
       , Object_Goods.ID                                                   AS GoodsID
       , Object_Goods.ObjectCode                                           AS GoodsCode
       , Object_Goods.ValueData                                            AS GoodsName
       , Container.Amount                                                  AS Amount
       , COALESCE (tmpExpirationDate.ValueData, zc_DateEnd()) :: TDateTime AS ExpirationDate

       , Container_PD.Id                                                   AS ContainerPGID
       , COALESCE (Container_PD.Amount, Container.Amount)                  AS AmountPG
       , ObjectFloat_PartionGoods_ExpirationDate.ValueData                 AS ExpirationDatePG

       , MovementDate_Branch.ValueData                                     AS BranchDate
       , Movement_Income.Invnumber                                         AS Invnumber
       , Object_From.ValueData                                             AS FromName
       , Object_Contract.ValueData                                         AS ContractName

       , COALESCE (ObjectFloat_PartionGoods_ExpirationDate.ValueData,
                   tmpExpirationDate.ValueData, zc_DateEnd())              AS ExpirationDateDialog
       , COALESCE (Container_PD.Amount, Container.Amount)                  AS AmountDialog

       , COALESCE(ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE)       AS Cat_5
       , ObjectDate_PartionGoods_Cat_5.ValueData                           AS DatePartionGoodsCat5

       , COALESCE (Container_PD.Id, Container.ID)                          AS ContainerChangeID
  FROM tmpContainer AS Container

       LEFT JOIN tmpExpirationDate ON tmpExpirationDate.ContainerId = Container.Id

       LEFT JOIN Container AS Container_PD
                           ON Container_PD.ParentId = Container.Id
                          AND Container_PD.DescId = zc_Container_CountPartionDate()
                          AND Container_PD.Amount <> 0

       LEFT JOIN Object AS Object_Goods ON Object_Goods.ID = Container.ObjectId


       LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container_PD.Id
                                    AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
       LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.ID = ContainerLinkObject.ObjectId

       LEFT JOIN ObjectDate AS ObjectFloat_PartionGoods_ExpirationDate
                            ON ObjectFloat_PartionGoods_ExpirationDate.ObjectId =  ContainerLinkObject.ObjectId
                           AND ObjectFloat_PartionGoods_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

       LEFT JOIN Movement AS Movement_Income ON Movement_Income.ID = tmpExpirationDate.MovementID

       LEFT JOIN MovementDate AS MovementDate_Branch
                              ON MovementDate_Branch.MovementId = Movement_Income.ID
                             AND MovementDate_Branch.DescId = zc_MovementDate_Branch()

       LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                    ON MovementLinkObject_From.MovementId = Movement_Income.ID
                                   AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
       LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

       LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                    ON MovementLinkObject_Contract.MovementId = Movement_Income.ID
                                   AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
       LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

       LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                               ON ObjectBoolean_PartionGoods_Cat_5.ObjectId =  ContainerLinkObject.ObjectId
                              AND ObjectBoolean_PartionGoods_Cat_5.DescId = zc_ObjectBoolean_PartionGoods_Cat_5()

       LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Cat_5
                            ON ObjectDate_PartionGoods_Cat_5.ObjectId =  ContainerLinkObject.ObjectId
                           AND ObjectDate_PartionGoods_Cat_5.DescId = zc_ObjectDate_PartionGoods_Cat_5()
  ORDER BY 5;

END;
$BODY$


LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.07.20                                                       *
 07.07.19                                                       *
*/

-- тест select * from gpSelect_Cash_OverdueChange(inUnitId := 0 , inGoodsId := 634 ,  inSession := '3');