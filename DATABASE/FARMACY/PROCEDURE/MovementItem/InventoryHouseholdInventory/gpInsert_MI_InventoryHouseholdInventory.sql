-- Function: gpInsert_MI_InventoryHouseholdInventory()

DROP FUNCTION IF EXISTS gpInsert_MI_InventoryHouseholdInventory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_InventoryHouseholdInventory(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS VOID
 AS
$BODY$
    DECLARE vbUserId   Integer;
    DECLARE vbUnitId   Integer;
    DECLARE vbRetailId Integer;

BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_InventoryHouseholdInventory());
    vbUserId:= lpGetUserBySession (inSession);

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_InventoryHouseholdInventory());

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

     PERFORM gpInsertUpdate_MI_InventoryHouseholdInventory (ioId                           := 0,
                                                            inMovementId                   := inMovementId,
                                                            inPartionHouseholdInventoryId  := tmpRemains.PartionHouseholdInventoryId,
                                                            inAmount                       := 0,
                                                            inComment                      := '',
                                                            inSession                      := inSession) 
     FROM (WITH
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
                                    AND Container.Amount > 0)

             SELECT tmpRemains.PartionHouseholdInventoryId AS PartionHouseholdInventoryId
             FROM tmpRemains

                  LEFT JOIN MI_Master ON MI_Master.PartionHouseholdInventoryId = tmpRemains.PartionHouseholdInventoryId

             WHERE COALESCE(MI_Master.Id, 0) = 0) AS tmpRemains
             ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 17.07.20                                                      *
*/
-- select * from gpInsert_MI_InventoryHouseholdInventory(inMovementId := 19480115,  inSession := '3');
