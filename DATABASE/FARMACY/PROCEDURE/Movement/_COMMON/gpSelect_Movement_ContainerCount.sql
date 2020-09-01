-- Function: gpSelect_Movement_ContainerCount()

DROP FUNCTION IF EXISTS gpSelect_Movement_ContainerCount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ContainerCount(
    IN inMovementId    Integer , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (ContainerID Integer, ContainerPDID Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , ExpirationDate      TDateTime
             , OperDate_Income     TDateTime
             , Invnumber_Income    TVarChar
             , FromName_Income     TVarChar
             , ContractName_Income TVarChar
             , PartionDateKindName TVarChar
              )

AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbDate_6 TDateTime;
  DECLARE vbDate_3 TDateTime;
  DECLARE vbDate_1 TDateTime;
  DECLARE vbDate_0 TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Loss());
     vbUserId:= lpGetUserBySession (inSession);

     -- значения для разделения по срокам
     SELECT Date_6, Date_3, Date_1, Date_0
     INTO vbDate_6, vbDate_3, vbDate_1, vbDate_0
     FROM lpSelect_PartionDateKind_SetDate ();

     RETURN QUERY
     WITH
         tmpMIContainer AS (SELECT MovementItemContainer.MovementItemID      AS Id
                                 , MovementItemContainer.ContainerID         AS ContainerID
                                 , Container.ObjectId                        AS ObjectId
                                 , MovementItemContainer.Amount              AS Amount
                                 , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId) AS MovementId_Income
                                 , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd())  AS ExpirationDate
                            FROM  MovementItemContainer

                                  INNER JOIN Container ON Container.ID = MovementItemContainer.ContainerID

                                  LEFT JOIN ContainerlinkObject AS CLO_MovementItem
                                                                ON CLO_MovementItem.Containerid = MovementItemContainer.ContainerID
                                                               AND CLO_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                  LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO_MovementItem.ObjectId
                                  -- элемент прихода
                                  LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                  -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                  LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                              ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                             AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                  -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                  LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

                                  LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                                    ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                                   AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                            WHERE MovementItemContainer.MovementId = inMovementId
                              AND MovementItemContainer.DescId = zc_Container_Count()
                            )
       , tmpMIContainerPD AS (SELECT MovementItemContainer.MovementItemID     AS Id
                                   , MovementItemContainer.ContainerID        AS ContainerID
                                   , Container.ParentId                       AS ParentId
                                   , MovementItemContainer.Amount             AS Amount
                                   , COALESCE (ObjectDate_Value.ValueData, zc_DateEnd())  AS ExpirationDate
                                   , CASE WHEN ObjectDate_Value.ValueData <= vbDate_0 AND
                                               COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE
                                                                                                THEN zc_Enum_PartionDateKind_Cat_5()  -- 5 кат (просрочка без наценки)
                                          WHEN ObjectDate_Value.ValueData <= vbDate_0  THEN zc_Enum_PartionDateKind_0()      -- просрочено
                                          WHEN ObjectDate_Value.ValueData <= vbDate_1  THEN zc_Enum_PartionDateKind_1()      -- Меньше 1 месяца
                                          WHEN ObjectDate_Value.ValueData <= vbDate_3  THEN zc_Enum_PartionDateKind_3()      -- Меньше 3 месяца
                                          WHEN ObjectDate_Value.ValueData <= vbDate_6  THEN zc_Enum_PartionDateKind_6()      -- Меньше 6 месяца
                                          WHEN ObjectDate_Value.ValueData > vbDate_6   THEN zc_Enum_PartionDateKind_Good()  END  AS PartionDateKindId                              -- Востановлен с просрочки
                               FROM  MovementItemContainer

                                     INNER JOIN Container ON Container.ID = MovementItemContainer.ContainerID

                                     LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                   ON CLO_PartionGoods.ContainerId = MovementItemContainer.ContainerID
                                                                  AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                     LEFT OUTER JOIN ObjectDate AS ObjectDate_Value
                                                                ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                               AND ObjectDate_Value.DescId   =  zc_ObjectDate_PartionGoods_Value()
                                     LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                             ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = CLO_PartionGoods.ObjectId
                                                            AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()

                               WHERE MovementItemContainer.MovementId = inMovementId
                                 AND MovementItemContainer.DescId = zc_Container_CountPartionDate()
                               )
       SELECT
             Container.ContainerID                                          AS ContainerId
           , tmpMIContainerPD.ContainerID                                   AS ContainerPDID
           , Container.ObjectId                                             AS GoodsId
           , Object_Goods.ObjectCode                                        AS GoodsCode
           , Object_Goods.ValueData                                         AS GoodsName
           , COALESCE(tmpMIContainerPD.Amount, Container.Amount)::TFloat    AS Amount

           , COALESCE (tmpMIContainerPD.ExpirationDate, Container.ExpirationDate):: TDateTime AS ExpirationDate
           , MovementDate_Branch.ValueData     AS OperDate_Income
           , Movement.Invnumber                AS Invnumber_Income
           , Object_From.ValueData             AS FromName_Income
           , Object_Contract.ValueData         AS ContractName_Income

           , Object_PartionDateKind.ValueData  AS PartionDateKindName
       FROM tmpMIContainer AS Container

            LEFT JOIN tmpMIContainerPD ON tmpMIContainerPD.ParentId = Container.ContainerId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = Container.ObjectId

            LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = tmpMIContainerPD.PartionDateKindId

            LEFT JOIN Movement ON Movement.ID = Container.MovementId_Income

            LEFT JOIN MovementDate AS MovementDate_Branch
                                   ON MovementDate_Branch.MovementId = Movement.Id
                                  AND MovementDate_Branch.DescId = zc_MovementDate_Branch()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_ContainerCount (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.09.20                                                       *
*/

-- тест
--
SELECT * FROM gpSelect_Movement_ContainerCount (inMovementId:= 20086833 , inSession:= '3')
