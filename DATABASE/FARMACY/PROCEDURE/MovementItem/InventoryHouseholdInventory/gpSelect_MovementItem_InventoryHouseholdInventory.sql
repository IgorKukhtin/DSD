-- Function: gpSelect_MovementItem_InventoryHouseholdInventory()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_InventoryHouseholdInventory (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_InventoryHouseholdInventory(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, PartionHouseholdInventoryId Integer
             , HouseholdInventoryId Integer, HouseholdInventoryCode Integer, HouseholdInventoryName TVarChar
             , InvNumber Integer, Remains TFloat, Amount TFloat, CountForPrice TFloat, Summa TFloat
             , Comment TVarChar
             , isErased Boolean)
 AS
$BODY$
    DECLARE vbUserId   Integer;
    DECLARE vbUnitId   Integer;
    DECLARE vbRetailId Integer;

BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_InventoryHouseholdInventory());
    vbUserId:= lpGetUserBySession (inSession);

    vbUnitId := (SELECT MovementLinkObject_Unit.ObjectId
                 FROM MovementLinkObject AS MovementLinkObject_Unit
                 WHERE MovementLinkObject_Unit.MovementId = inMovementId
                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                );


    vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical());

    IF inShowAll = TRUE
    THEN

        -- Результат такой
        -- Результат такой
        RETURN QUERY
               WITH
                   MI_Master AS (SELECT MovementItem.Id                             AS Id
                                      , MovementItem.ObjectId                       AS PartionHouseholdInventoryId
                                      , MovementItem.Amount                         AS Amount
                                      , MIString_Comment.ValueData                  AS Comment
                                      , MovementItem.isErased                       AS isErased
                                      , Container.ObjectId                          AS HouseholdInventoryId
                                 FROM MovementItem

                                      LEFT JOIN MovementItemString AS MIString_Comment
                                                                   ON MIString_Comment.MovementItemId = MovementItem.Id
                                                                  AND MIString_Comment.DescId = zc_MIString_Comment()

                                      LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = MovementItem.ObjectId
                                                                   AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionHouseholdInventory()
                                                                   
                                      LEFT JOIN Container ON ContainerLinkObject.ContainerId = Container.Id

                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId = zc_MI_Master()
                                 ),
                   tmpRemains AS (SELECT Container.ID
                                       , Container.ObjectId                     AS HouseholdInventoryId
                                       , Container.Amount                       AS Amount
                                       , ContainerLinkObject.ObjectId           AS PartionHouseholdInventoryId

                                       , Object_PHI.ObjectCode                  AS InvNumber
                                       , MIFloat_CountForPrice.ValueData        AS CountForPrice
                                  FROM Container
                                
                                       LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                                    AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionHouseholdInventory()
                                                                    
                                       LEFT JOIN Object AS Object_PHI ON Object_PHI.ID = ContainerLinkObject.ObjectId

                                       LEFT JOIN ObjectFloat AS PHI_MovementItemId
                                                             ON PHI_MovementItemId.ObjectId = Object_PHI.Id
                                                            AND PHI_MovementItemId.DescId = zc_ObjectFloat_PartionHouseholdInventory_MovementItemId()

                                       LEFT JOIN MovementItem ON MovementItem.Id = PHI_MovementItemId.ValueData::Integer

                                       LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId

                                       LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                                   ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                                  AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                                  WHERE Container.DescId = zc_Container_CountHouseholdInventory()
                                    AND Container.WhereobjectId = vbUnitId
                                    AND COALESCE (Movement.StatusId, 0) = zc_Enum_Status_Complete()
                                  )

               SELECT MI_Master.Id                                                                AS Id
                    , COALESCE(tmpRemains.PartionHouseholdInventoryId, 
                               MI_Master.PartionHouseholdInventoryId)                             AS PartionHouseholdInventoryId
                    , COALESCE(tmpRemains.HouseholdInventoryId, MI_Master.HouseholdInventoryId)   AS HouseholdInventoryId
                    , Object_HouseholdInventory.ObjectCode                                        AS HouseholdInventoryCode
                    , Object_HouseholdInventory.ValueData                                         AS HouseholdInventoryName
                    , tmpRemains.InvNumber                                                        AS InvNumber
                    , tmpRemains.Amount                                                           AS Remains
                    , MI_Master.Amount                                                            AS Amount
                    , tmpRemains.CountForPrice                                                    AS CountForPrice
                    , Round(MI_Master.Amount * tmpRemains.CountForPrice, 2)::TFloat               AS Summa 
                    , MI_Master.Comment                                                           AS Comment
                    , COALESCE(MI_Master.IsErased, False)                                         AS isErased
               FROM tmpRemains

                    FULL JOIN MI_Master ON MI_Master.PartionHouseholdInventoryId = tmpRemains.PartionHouseholdInventoryId

                    LEFT JOIN Object AS Object_HouseholdInventory ON Object_HouseholdInventory.Id = COALESCE(tmpRemains.HouseholdInventoryId, MI_Master.HouseholdInventoryId)

               ORDER BY MI_Master.HouseholdInventoryId, tmpRemains.InvNumber
               ;

    ELSE

        -- Результат такой
        RETURN QUERY
               WITH
                   MI_Master AS (SELECT MovementItem.Id                             AS Id
                                      , MovementItem.ObjectId                       AS PartionHouseholdInventoryId
                                      , MovementItem.Amount                         AS Amount
                                      , MIString_Comment.ValueData                  AS Comment
                                      , MovementItem.isErased                       AS isErased
                                      , Container.ObjectId                          AS HouseholdInventoryId
                                 FROM MovementItem

                                      LEFT JOIN MovementItemString AS MIString_Comment
                                                                   ON MIString_Comment.MovementItemId = MovementItem.Id
                                                                  AND MIString_Comment.DescId = zc_MIString_Comment()

                                      LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = MovementItem.ObjectId
                                                                   AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionHouseholdInventory()
                                                                   
                                      LEFT JOIN Container ON ContainerLinkObject.ContainerId = Container.Id

                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId = zc_MI_Master()
                                 ),
                   tmpRemains AS (SELECT Container.ID
                                       , Container.ObjectId                     AS HouseholdInventoryId
                                       , Container.Amount                       AS Amount
                                       , ContainerLinkObject.ObjectId           AS PartionHouseholdInventoryId

                                       , Object_PHI.ObjectCode                  AS InvNumber
                                       , MIFloat_CountForPrice.ValueData        AS CountForPrice
                                  FROM Container
                                
                                       LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                                    AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionHouseholdInventory()
                                                                    
                                       LEFT JOIN Object AS Object_PHI ON Object_PHI.ID = ContainerLinkObject.ObjectId

                                       LEFT JOIN ObjectFloat AS PHI_MovementItemId
                                                             ON PHI_MovementItemId.ObjectId = Object_PHI.Id
                                                            AND PHI_MovementItemId.DescId = zc_ObjectFloat_PartionHouseholdInventory_MovementItemId()

                                       LEFT JOIN MovementItem ON MovementItem.Id = PHI_MovementItemId.ValueData::Integer

                                       LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId

                                       LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                                   ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                                  AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                                  WHERE Container.DescId = zc_Container_CountHouseholdInventory()
                                    AND Container.WhereobjectId = vbUnitId
                                    AND COALESCE (Movement.StatusId, 0) = zc_Enum_Status_Complete()
                                  )

               SELECT MI_Master.Id                                      AS Id
                    , MI_Master.PartionHouseholdInventoryId             AS PartionHouseholdInventoryId
                    , MI_Master.HouseholdInventoryId                    AS HouseholdInventoryId
                    , Object_HouseholdInventory.ObjectCode              AS HouseholdInventoryCode
                    , Object_HouseholdInventory.ValueData               AS HouseholdInventoryName
                    , tmpRemains.InvNumber                              AS InvNumber
                    , tmpRemains.Amount                                 AS Remains
                    , MI_Master.Amount                                  AS Amount
                    , tmpRemains.CountForPrice                          AS CountForPrice
                    , Round(MI_Master.Amount * tmpRemains.CountForPrice, 2)::TFloat                AS Summa 
                    , MI_Master.Comment                                 AS Comment
                    , MI_Master.IsErased                                AS isErased
               FROM MI_Master

                   LEFT JOIN Object AS Object_HouseholdInventory ON Object_HouseholdInventory.Id = MI_Master.HouseholdInventoryId

                   LEFT JOIN tmpRemains ON MI_Master.PartionHouseholdInventoryId = tmpRemains.PartionHouseholdInventoryId

               ORDER BY MI_Master.HouseholdInventoryId, tmpRemains.InvNumber

                   ;
    END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 17.07.20                                                      *
*/
-- 
select * from gpSelect_MovementItem_InventoryHouseholdInventory(inMovementId := 19565179 , inShowAll := 'True' , inIsErased := 'False' ,  inSession := '3');
