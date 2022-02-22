-- Function: gpInsert_Translation_5_Category()

DROP FUNCTION IF EXISTS gpInsert_Translation_5_Category (TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Translation_5_Category(
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbDate180  TDateTime;
   DECLARE vbDate90   TDateTime;
   DECLARE vbDate30   TDateTime;
   DECLARE vbDate0    TDateTime;
   DECLARE vbOperDate TDateTime;

   DECLARE vbId_err            Integer;
   DECLARE vbAmount_master_err TFloat;
   DECLARE vbAmount_child_err  TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SendPartionDate());
    vbUserId := inSession;

    CREATE TEMP TABLE tmpTranslation ON COMMIT DROP AS  
     (WITH tmpContainer AS (SELECT Container.ParentId                   AS ContainerId,
                                   Container.Id                         AS ContainerPDId,
                                   Container.WhereObjectId              AS UnitId,
                                   Container.ObjectId                   AS GoodsId,
                                   Container.Amount                     AS Amount,
                                   ObjectDate_ExpirationDate.ValueData  AS ExpirationDate,
                                   COALESCE(ObjectFloat_PartionGoods_Value.ValueData, 0) AS ChangePercentPD,
                                   COALESCE(ObjectFloat_PartionGoods_ValueLess.ValueData, 0) AS ChangePercentLessPD,
                                   COALESCE(ObjectFloat_PartionGoods_ValueMin.ValueData, 0) AS ChangePercentMinPD
                            FROM Container
                                 INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                               AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
                                                        
                                 INNER JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                       ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId    
                                                      AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                 INNER JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                          ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = ContainerLinkObject.ObjectId    
                                                         AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()
                                                         AND ObjectBoolean_PartionGoods_Cat_5.ValueData = True
                                 LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_MovementId 
                                                       ON ObjectFloat_PartionGoods_MovementId.ObjectId = ContainerLinkObject.ObjectId   
                                                      AND ObjectFloat_PartionGoods_MovementId.DescId = zc_ObjectFloat_PartionGoods_MovementId() 
                                 LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_ValueMin
                                                       ON ObjectFloat_PartionGoods_ValueMin.ObjectId =  ContainerLinkObject.ObjectId
                                                      AND ObjectFloat_PartionGoods_ValueMin.DescId = zc_ObjectFloat_PartionGoods_ValueMin()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_Value
                                                       ON ObjectFloat_PartionGoods_Value.ObjectId =  ContainerLinkObject.ObjectId
                                                      AND ObjectFloat_PartionGoods_Value.DescId = zc_ObjectFloat_PartionGoods_Value()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_ValueLess
                                                       ON ObjectFloat_PartionGoods_ValueLess.ObjectId =  ContainerLinkObject.ObjectId
                                                      AND ObjectFloat_PartionGoods_ValueLess.DescId = zc_ObjectFloat_PartionGoods_ValueLess()
                                 LEFT JOIN Movement ON Movement.ID = ObjectFloat_PartionGoods_MovementId.ValueData
                            WHERE Container.DescId = zc_Container_CountPartionDate()
                              AND Container.Amount > 0
                              AND Movement.OperDate < CURRENT_DATE - INTERVAL '30 DAY'
                              )
         , tmpMovementPrew AS (SELECT MovementLinkObject_Unit.ObjectId AS UnitID
                                    , MAX(Movement.ID)                 AS MovementId
                               FROM Movement

                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                  ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                 AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                                    LEFT JOIN MovementBoolean AS MovementBoolean_Transfer
                                                              ON MovementBoolean_Transfer.MovementId = Movement.Id
                                                             AND MovementBoolean_Transfer.DescId = zc_MovementBoolean_Transfer()
 
                               WHERE Movement.DescId = zc_Movement_SendPartionDate()
                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                                 AND MovementLinkObject_Unit.ObjectId IN (SELECT DISTINCT tmpContainer.UnitId FROM tmpContainer)
                                 AND COALESCE(MovementBoolean_Transfer.ValueData, False) = False
                               GROUP BY MovementLinkObject_Unit.ObjectId)
         , tmpMovementData AS (SELECT Movement.MovementId                           AS MovementId
                                    , Movement.UnitID                               AS UnitID
                                    , MovementFloat_ChangePercent.ValueData         AS ChangePercent
                                    , MovementFloat_ChangePercentLess.ValueData     AS ChangePercentLess
                                    , MovementFloat_ChangePercentMin.ValueData      AS ChangePercentMin
                               FROM tmpMovementPrew AS Movement

                                    LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                                            ON MovementFloat_ChangePercent.MovementId =  Movement.MovementId
                                                           AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

                                    LEFT JOIN MovementFloat AS MovementFloat_ChangePercentLess
                                                            ON MovementFloat_ChangePercentLess.MovementId =  Movement.MovementId
                                                           AND MovementFloat_ChangePercentLess.DescId = zc_MovementFloat_ChangePercentLess()

                                    LEFT JOIN MovementFloat AS MovementFloat_ChangePercentMin
                                                            ON MovementFloat_ChangePercentMin.MovementId =  Movement.MovementId
                                                           AND MovementFloat_ChangePercentMin.DescId = zc_MovementFloat_ChangePercentMin()

                               )
                              
     SELECT MovementData.UnitID
          , MovementData.ChangePercent
          , MovementData.ChangePercentLess
          , MovementData.ChangePercentMin
          , Container.ContainerId
          , Container.ContainerPDId
          , Container.GoodsId
          , Container.Amount 
          , Container.ExpirationDate
          , Container.ChangePercentPD
          , Container.ChangePercentLessPD
          , Container.ChangePercentMinPD
          , 0::Integer                           AS MovementId
          , 0::Integer                           AS MovementItemId
     FROM tmpContainer AS Container
     
          INNER JOIN tmpMovementData AS MovementData
                                     ON MovementData.UnitID = Container.UnitID                                      
     );
                             
    UPDATE tmpTranslation SET MovementId = T1.MovementId
    FROM (SELECT tmpTranslation.UnitID
               , lpInsertUpdate_Movement_SendPartionDate(ioId                := 0,
                                                         inInvNumber         := CAST (NEXTVAL ('Movement_SendPartionDate_seq') AS TVarChar),
                                                         inOperDate          := CURRENT_DATE,
                                                         inUnitId            := tmpTranslation.UnitID,
                                                         inChangePercent     := tmpTranslation.ChangePercent,
                                                         inChangePercentLess := tmpTranslation.ChangePercentLess,
                                                         inChangePercentMin  := tmpTranslation.ChangePercentMin,
                                                         inComment           := 'Отмена 5 категории',
                                                         inParentId          := Null,
                                                         inUserId            := vbUserId
                                                         ) AS MovementId
          FROM tmpTranslation
          GROUP BY tmpTranslation.UnitID
                 , tmpTranslation.ChangePercent
                 , tmpTranslation.ChangePercentLess
                 , tmpTranslation.ChangePercentMin) AS T1
    WHERE tmpTranslation.UnitID = T1.UnitID;
    
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Transfer(), tmpTranslation.MovementId, True)
    FROM tmpTranslation
    WHERE tmpTranslation.MovementId <> 0
    GROUP BY tmpTranslation.MovementId;
 
    UPDATE tmpTranslation SET MovementItemId = gpInsertUpdate_MI_SendPartionDate_Master(ioId               := 0
                                                                                  , inMovementId           := tmpTranslation.MovementId
                                                                                  , inGoodsId              := tmpTranslation.GoodsId
                                                                                  , inAmount               := tmpTranslation.Amount
                                                                                  , inAmountRemains        := tmpTranslation.Amount   
                                                                                  , inChangePercent        := tmpTranslation.ChangePercentPD
                                                                                  , inChangePercentLess    := tmpTranslation.ChangePercentLessPD
                                                                                  , inChangePercentMin     := tmpTranslation.ChangePercentMinPD
                                                                                  , inContainerId          := tmpTranslation.ContainerPDId
                                                                                  , inExpirationDate       := Nill::TDateTime
                                                                                  , inSession              := inSession
                                                                                    )
    WHERE tmpTranslation.MovementId <> 0;
    
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ExpirationDate(), MI_Child.Id, tmpTranslation.ExpirationDate)
    FROM tmpTranslation
         INNER JOIN MovementItem AS MI_Child
                                 ON MI_Child.ParentId = tmpTranslation.MovementItemId
                                AND MI_Child.MovementId = tmpTranslation.MovementID
                                AND MI_Child.DescId = zc_MI_Child()   
    WHERE tmpTranslation.MovementItemId <> 0;
    
    -- Проводим документ сроков
    PERFORM gpUpdate_Status_SendPartionDate(inMovementId := tmpTranslation.MovementId  
                                          , inStatusCode   := zc_Enum_StatusCode_Complete()
                                          , inSession      := inSession)
    FROM tmpTranslation
    WHERE tmpTranslation.MovementId <> 0
    GROUP BY tmpTranslation.MovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 27.03.21                                                      *
*/

--  select * from gpInsert_Translation_5_Category(inSession := '3');
                             