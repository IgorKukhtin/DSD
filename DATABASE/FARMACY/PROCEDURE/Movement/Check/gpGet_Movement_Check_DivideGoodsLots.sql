-- Function: gpGet_Movement_Check_DivideGoodsLots()


DROP FUNCTION IF EXISTS gpGet_Movement_Check_DivideGoodsLots (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Check_DivideGoodsLots(
    IN inMovementId          Integer   , -- Документ
   OUT outMessageText        Text      , -- вернули, если есть ошибка
   OUT outisReload           Boolean      , -- вернули, если есть ошибка
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbUnitId  Integer;
   DECLARE vbIndex   Integer;
   DECLARE vbRecord  Record;
   DECLARE vbRRecord  Record;
   DECLARE vbRemains TFloat;
   DECLARE vbAmount TFloat;

   DECLARE vbDate_6 TDateTime;
   DECLARE vbDate_3 TDateTime;
   DECLARE vbDate_1 TDateTime;
   DECLARE vbDate_0 TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);
    
    outMessageText := '';
    outisReload := False;

    -- определяется подразделение
     SELECT MovementLinkObject_Unit.ObjectId
     INTO vbUnitId
     FROM MovementLinkObject AS MovementLinkObject_Unit
     WHERE MovementLinkObject_Unit.MovementId = inMovementId
       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit();    

    -- значения для разделения по срокам
    SELECT Date_6, Date_3, Date_1, Date_0
    INTO vbDate_6, vbDate_3, vbDate_1, vbDate_0
    FROM lpSelect_PartionDateKind_SetDate ();
    

    -- Содержимое документа
    CREATE TEMP TABLE _tmpMI ON COMMIT DROP AS
       SELECT
             MovementItem.Id                     AS Id
           , MovementItem.ObjectId               AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.Name                   AS GoodsName
           , MovementItem.Amount                 AS Amount
           , MIFloat_AmountOrder.ValueData       AS AmountOrder
           , MIFloat_Price.ValueData             AS Price
           , MIFloat_PriceSale.ValueData         AS PriceSale
           , MIFloat_PriceLoad.ValueData         AS PriceLoad

           , COALESCE (MILinkObject_NDSKind.ObjectId, Object_Goods.NDSKindId)::Integer     AS NDSKindId
           , MILinkObject_PartionDateKind.ObjectId  AS PartionDateKindId
           , MILinkObject_DivisionParties.ObjectId  AS DivisionPartiesId 
           , MILinkObject_Juridical.ObjectId        AS JuridicalId 

           , MovementItem.isErased               AS isErased


       FROM MovementItem
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                        ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
            LEFT JOIN MovementItemFloat AS MIFloat_PriceLoad
                                        ON MIFloat_PriceLoad.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceLoad.DescId = zc_MIFloat_PriceLoad()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountOrder
                                        ON MIFloat_AmountOrder.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_NDSKind
                                             ON MILinkObject_NDSKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_NDSKind.DescId         = zc_MILinkObject_NDSKind()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionDateKind
                                             ON MILinkObject_PartionDateKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionDateKind.DescId         = zc_MILinkObject_PartionDateKind()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_DivisionParties
                                             ON MILinkObject_DivisionParties.MovementItemId = MovementItem.Id
                                            AND MILinkObject_DivisionParties.DescId         = zc_MILinkObject_DivisionParties()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Juridical
                                             ON MILinkObject_Juridical.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Juridical.DescId         = zc_MILinkObject_Juridical()
            LEFT JOIN MovementItemBoolean AS MIBoolean_Present
                                          ON MIBoolean_Present.MovementItemId = MovementItem.Id
                                         AND MIBoolean_Present.DescId         = zc_MIBoolean_Present()
            LEFT JOIN MovementItemBoolean AS MIBoolean_GoodsPresent
                                          ON MIBoolean_GoodsPresent.MovementItemId = MovementItem.Id
                                         AND MIBoolean_GoodsPresent.DescId         = zc_MIBoolean_GoodsPresent()

            LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem.ObjectId
            LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId

   WHERE MovementItem.DescId     = zc_MI_Master()
     AND MovementItem.MovementId = inMovementId
     AND MovementItem.isErased   = False
     AND COALESCE (MIBoolean_Present.ValueData, False) = False
     AND COALESCE (MIBoolean_GoodsPresent.ValueData, False) = False;
    
   ANALYSE _tmpMI;
    

    -- таблица
    CREATE TEMP TABLE _tmpGoods ON COMMIT DROP AS 
    SELECT _tmpMI.GoodsId
         , SUM(_tmpMI.Amount)::TFloat  AS Amount
         , _tmpMI.PartionDateKindId
         , _tmpMI.NDSKindId
         , _tmpMI.DivisionPartiesId
    FROM _tmpMI
    GROUP BY _tmpMI.GoodsId
           , _tmpMI.PartionDateKindId
           , _tmpMI.NDSKindId
           , _tmpMI.DivisionPartiesId;
    
    ANALYSE _tmpGoods;
    
    -- Контейнера остатков
    CREATE TEMP TABLE _tmpContainerAll ON COMMIT DROP AS 
       SELECT tmpGoods.GoodsId, 
              Container.Id, 
              Container.Amount,
              COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)                      AS M_Income,
              COALESCE (MI_Income_find.Id,MI_Income.Id)                                      AS MI_Income
        FROM (SELECT DISTINCT _tmpGoods.GoodsId FROM _tmpGoods) AS tmpGoods

             INNER JOIN Container ON Container.DescId = zc_Container_Count()
                                 AND Container.WhereObjectId = vbUnitId
                                 AND Container.ObjectId = tmpGoods.GoodsId
                                 AND Container.Amount > 0

             LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                           ON ContainerLinkObject_MovementItem.Containerid = Container.Id
                                          AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
             LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
             -- элемент прихода
             LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
             -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
             LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                         ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                        AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
             -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
             LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer);
                                   
    ANALYSE _tmpContainerAll;
                              

    -- Собираем оcтатки
    CREATE TEMP TABLE tmpRemains ON COMMIT DROP AS     
    WITH tmpContainer AS (SELECT Container.GoodsId, 
                                 Container.Id, 
                                 Container.Amount,
                                 CASE WHEN COALESCE (MovementBoolean_UseNDSKind.ValueData, FALSE) = FALSE
                                        OR COALESCE(MovementLinkObject_NDSKind.ObjectId, 0) = 0
                                      THEN Object_Goods.NDSKindId ELSE MovementLinkObject_NDSKind.ObjectId END  AS NDSKindId,
                                 ContainerLinkObject_DivisionParties.ObjectId                                   AS DivisionPartiesId,
                                 MovementLinkObject_From.ObjectId                                               AS JuridicalId,
                                 MIFloat_Price.ValueData                                                        AS Price
                           FROM _tmpContainerAll AS Container
                                                           
                                LEFT OUTER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = Container.GoodsId
                                LEFT OUTER JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId

                                LEFT OUTER JOIN MovementBoolean AS MovementBoolean_UseNDSKind
                                                                ON MovementBoolean_UseNDSKind.MovementId = Container.M_Income
                                                               AND MovementBoolean_UseNDSKind.DescId = zc_MovementBoolean_UseNDSKind()
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                             ON MovementLinkObject_NDSKind.MovementId = Container.M_Income
                                                            AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                                                                                             
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                             ON MovementLinkObject_From.MovementId = Container.M_Income
                                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                                LEFT JOIN ContainerlinkObject AS ContainerLinkObject_DivisionParties
                                                              ON ContainerLinkObject_DivisionParties.Containerid = Container.Id
                                                             AND ContainerLinkObject_DivisionParties.DescId = zc_ContainerLinkObject_DivisionParties()
                                                                
                                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                            ON MIFloat_Price.MovementItemId =  Container.MI_Income
                                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                                                           
                              )
       , tmpContainerPDAll AS  (SELECT Container.ParentId
                                     , Container.Amount
                                     , CASE WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0 AND
                                                 COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE
                                                                                                  THEN zc_Enum_PartionDateKind_Cat_5()  -- 5 кат (просрочка без наценки)
                                            WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0  THEN zc_Enum_PartionDateKind_0()      -- просрочено
                                            WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_1  THEN zc_Enum_PartionDateKind_1()      -- Меньше 1 месяца
                                            WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_3  THEN zc_Enum_PartionDateKind_3()      -- Меньше 3 месяца
                                            WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_6  THEN zc_Enum_PartionDateKind_6()      -- Меньше 6 месяца
                                            ELSE  zc_Enum_PartionDateKind_Good() END  AS PartionDateKindId                              -- Востановлен с просрочки
                                     , COALESCE(ObjectDate_ExpirationDate.ValueData, zc_DateEnd())    AS ExpirationDate
                                FROM tmpContainer

                                     INNER JOIN Container ON Container.ParentId = tmpContainer.Id
                                                         AND Container.DescId  = zc_Container_CountPartionDate()
                                                         AND Container.Amount > 0

                                     LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                                  AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                                     LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                          ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                                         AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                     LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                             ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = ContainerLinkObject.ObjectId
                                                            AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()
                                 )

       , tmpContainerPD AS (SELECT Container.ParentId
                                 , Container.PartionDateKindId
                                 , Sum(Container.Amount)                    AS Amount
                                 , MIN(Container.ExpirationDate)::TDateTime AS ExpirationDate
                            FROM tmpContainerPDAll AS Container
                            GROUP BY Container.ParentId
                                   , Container.PartionDateKindId
                             )
                      
      SELECT tmpGoods.GoodsId
           , Container.NDSKindId
           , tmpContainerPD.PartionDateKindId
           , Container.DivisionPartiesId
           , SUM (COALESCE (tmpContainerPD.Amount, Container.Amount))::TFloat AS Remains
           , MIN(COALESCE(tmpContainerPD.ExpirationDate, zc_DateEnd()))::TDateTime AS ExpirationDate
      FROM (SELECT DISTINCT _tmpGoods.GoodsId FROM _tmpGoods) AS tmpGoods

           INNER JOIN tmpContainer AS Container
                                   ON Container.GoodsId                        = tmpGoods.GoodsId


           LEFT OUTER JOIN tmpContainerPD ON tmpContainerPD.ParentId = Container.ID
           
      WHERE COALESCE(tmpContainerPD.ExpirationDate, zc_DateEnd()) >= CURRENT_DATE

      GROUP BY tmpGoods.GoodsId
             , Container.NDSKindId
             , tmpContainerPD.PartionDateKindId
             , Container.DivisionPartiesId;
                               
    ANALYSE tmpRemains;

        
    IF EXISTS(SELECT * FROM _tmpMI WHERE COALESCE (_tmpMI.JuridicalId , 0) <> 0)
    THEN
      outMessageText := 'Ошибка. Для заказов с товарами прикрепленніми к поставщику не работает.';
      RETURN;

      /*-- Собираем оcтатки по поставщикам
      CREATE TEMP TABLE _tmpRemainsJuridical ON COMMIT DROP AS 
      
      WITH tmpFromJuridical AS (SELECT tmpGoods.GoodsId
                                     , tmpGoods.NDSKindId
                                     , tmpGoods.PartionDateKindId
                                     , tmpGoods.DivisionPartiesId
                                     , tmpGoods.JuridicalId
                                     , SUM (_tmpGoods.Amount) AS Amount 
                                FROM _tmpMI AS tmpGoods
                                WHERE COALESCE(tmpGoods.JuridicalId, 0) <> 0
                                GROUP BY tmpGoods.GoodsId
                                       , tmpGoods.NDSKindId
                                       , tmpGoods.PartionDateKindId
                                       , tmpGoods.DivisionPartiesId
                                       , tmpGoods.JuridicalId)
         , tmpContainer AS (SELECT Container.GoodsId, 
                                   Container.Id, 
                                   Container.Amount,
                                   CASE WHEN COALESCE (MovementBoolean_UseNDSKind.ValueData, FALSE) = FALSE
                                          OR COALESCE(MovementLinkObject_NDSKind.ObjectId, 0) = 0
                                        THEN Object_Goods.NDSKindId ELSE MovementLinkObject_NDSKind.ObjectId END  AS NDSKindId,
                                   ContainerLinkObject_DivisionParties.ObjectId                                   AS DivisionPartiesId,
                                   MovementLinkObject_From.ObjectId                                               AS JuridicalId,
                                   MIFloat_Price.ValueData                                                        AS Price
                             FROM _tmpContainerAll AS Container
                                                             
                                  LEFT OUTER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = Container.GoodsId
                                  LEFT OUTER JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId

                                  LEFT OUTER JOIN MovementBoolean AS MovementBoolean_UseNDSKind
                                                                  ON MovementBoolean_UseNDSKind.MovementId = Container.M_Income
                                                                 AND MovementBoolean_UseNDSKind.DescId = zc_MovementBoolean_UseNDSKind()
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                               ON MovementLinkObject_NDSKind.MovementId = Container.M_Income
                                                              AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                                                                                               
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = Container.M_Income
                                                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                                  LEFT JOIN ContainerlinkObject AS ContainerLinkObject_DivisionParties
                                                                ON ContainerLinkObject_DivisionParties.Containerid = Container.Id
                                                               AND ContainerLinkObject_DivisionParties.DescId = zc_ContainerLinkObject_DivisionParties()
                                                                  
                                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                              ON MIFloat_Price.MovementItemId =  Container.MI_Income
                                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                                                             
                                )
         , tmpContainerPDAll AS  (SELECT Container.ParentId
                                       , Container.Amount
                                       , CASE WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0 AND
                                                   COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE
                                                                                                    THEN zc_Enum_PartionDateKind_Cat_5()  -- 5 кат (просрочка без наценки)
                                              WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0  THEN zc_Enum_PartionDateKind_0()      -- просрочено
                                              WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_1  THEN zc_Enum_PartionDateKind_1()      -- Меньше 1 месяца
                                              WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_3  THEN zc_Enum_PartionDateKind_3()      -- Меньше 3 месяца
                                              WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_6  THEN zc_Enum_PartionDateKind_6()      -- Меньше 6 месяца
                                              ELSE  zc_Enum_PartionDateKind_Good() END  AS PartionDateKindId                              -- Востановлен с просрочки
                                  FROM tmpContainer

                                       INNER JOIN Container ON Container.ParentId = tmpContainer.Id
                                                           AND Container.DescId  = zc_Container_CountPartionDate()
                                                           AND Container.Amount > 0

                                       LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                                    AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                                       LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                            ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                                           AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                       LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                               ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = ContainerLinkObject.ObjectId
                                                              AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()
                                   )

         , tmpContainerPD AS (SELECT Container.ParentId
                                   , Container.PartionDateKindId
                                   , Sum(Container.Amount)          AS Amount
                              FROM tmpContainerPDAll AS Container
                              GROUP BY Container.ParentId
                                     , Container.PartionDateKindId
                               )

         SELECT tmpFrom.GoodsId
              , tmpFrom.NDSKindId
              , tmpFrom.PartionDateKindId
              , tmpFrom.DivisionPartiesId
              , tmpFrom.JuridicalId
              , SUM (COALESCE (tmpContainerPD.Amount, Container.Amount))::TFloat AS Remains
         FROM tmpFromJuridical AS tmpFrom

              INNER JOIN tmpContainer AS Container
                                      ON Container.NDSKindId                      = tmpFrom.NDSKindId
                                     AND Container.GoodsId                        = tmpFrom.GoodsId
                                     AND COALESCE(Container.DivisionPartiesId, 0) = COALESCE(tmpFrom.DivisionPartiesId, 0)
                                     AND COALESCE(Container.JuridicalId, 0)       = COALESCE(tmpFrom.JuridicalId, 0)

              LEFT OUTER JOIN tmpContainerPD ON tmpContainerPD.ParentId = Container.ID

         WHERE COALESCE(tmpContainerPD.PartionDateKindId, 0) = COALESCE (tmpFrom.PartionDateKindId, 0)
         GROUP BY tmpFrom.GoodsId
                , tmpFrom.NDSKindId
                , tmpFrom.PartionDateKindId
                , tmpFrom.DivisionPartiesId
                , tmpFrom.JuridicalId;
                                      
      ANALYSE _tmpRemainsJuridical;*/

    END IF;

    -- Сравним с очтатком    
    FOR vbRecord IN
        SELECT _tmpMI.*  
        FROM _tmpMI
        ORDER BY _tmpMI.ID
    LOOP

      IF EXISTS (SELECT 1
                 FROM tmpRemains 
                 WHERE tmpRemains.GoodsId = vbRecord.GoodsId
                   AND tmpRemains.NDSKindId = vbRecord.NDSKindId
                   AND COALESCE(tmpRemains.PartionDateKindId, 0) = COALESCE(vbRecord.PartionDateKindId, 0)
                   AND COALESCE(tmpRemains.DivisionPartiesId, 0) = COALESCE(vbRecord.DivisionPartiesId, 0))
      THEN
      
        SELECT tmpRemains.Remains
        INTO vbRemains
        FROM tmpRemains 
        WHERE tmpRemains.GoodsId = vbRecord.GoodsId
          AND tmpRemains.NDSKindId = vbRecord.NDSKindId
          AND COALESCE(tmpRemains.PartionDateKindId, 0) = COALESCE(vbRecord.PartionDateKindId, 0)
          AND COALESCE(tmpRemains.DivisionPartiesId, 0) = COALESCE(vbRecord.DivisionPartiesId, 0);
      
        IF vbRemains = vbRecord.Amount
        THEN
          DELETE FROM tmpRemains 
          WHERE  tmpRemains.GoodsId = vbRecord.GoodsId
            AND tmpRemains.NDSKindId = vbRecord.NDSKindId
            AND COALESCE(tmpRemains.PartionDateKindId, 0) = COALESCE(vbRecord.PartionDateKindId, 0)
            AND COALESCE(tmpRemains.DivisionPartiesId, 0) = COALESCE(vbRecord.DivisionPartiesId, 0);
          DELETE FROM _tmpMI WHERE _tmpMI.ID = vbRecord.Id;          
        ELSEIF vbRemains < vbRecord.Amount
        THEN
          DELETE FROM tmpRemains 
          WHERE  tmpRemains.GoodsId = vbRecord.GoodsId
            AND tmpRemains.NDSKindId = vbRecord.NDSKindId
            AND COALESCE(tmpRemains.PartionDateKindId, 0) = COALESCE(vbRecord.PartionDateKindId, 0)
            AND COALESCE(tmpRemains.DivisionPartiesId, 0) = COALESCE(vbRecord.DivisionPartiesId, 0);
          UPDATE _tmpMI SET Amount = _tmpMI.Amount - vbRemains WHERE _tmpMI.ID = vbRecord.Id;                 
        ELSE
          UPDATE tmpRemains SET Remains = tmpRemains.Remains - vbRecord.Amount
          WHERE  tmpRemains.GoodsId = vbRecord.GoodsId
            AND tmpRemains.NDSKindId = vbRecord.NDSKindId
            AND COALESCE(tmpRemains.PartionDateKindId, 0) = COALESCE(vbRecord.PartionDateKindId, 0)
            AND COALESCE(tmpRemains.DivisionPartiesId, 0) = COALESCE(vbRecord.DivisionPartiesId, 0);
          DELETE FROM _tmpMI WHERE _tmpMI.ID = vbRecord.Id;                 
        END IF;      
      END IF;                                                        
    END LOOP;  
    
    
                  
    IF EXISTS (SELECT 1 FROM _tmpMI)
    THEN
      IF NOT EXISTS (SELECT 1
                     FROM (SELECT tmpMI.GoodsId
                                , SUM(tmpMI.Amount)::TFloat  AS Amount 
                           FROM _tmpMI AS tmpMI 
                           GROUP BY tmpMI.GoodsId) AS tmpGoods 
                          LEFT JOIN (SELECT tmpRemains.GoodsId
                                          , SUM(tmpRemains.Remains)::TFloat AS Remains 
                                     FROM tmpRemains AS tmpRemains 
                                     GROUP BY tmpRemains.GoodsId) AS tmpRemains ON tmpRemains.GoodsId = tmpGoods.GoodsId
                                                                                
                     WHERE tmpGoods.Amount > COALESCE(tmpRemains.Remains, 0))
      THEN

        -- Создание технических переучетов
        BEGIN

          -- Распределяем
          FOR vbRecord IN
              SELECT _tmpMI.*  
              FROM _tmpMI
              ORDER BY _tmpMI.ID
          LOOP
            
            vbAmount := vbRecord.Amount;
          
            FOR vbRRecord IN
                SELECT tmpRemains.*  
                FROM tmpRemains
                WHERE tmpRemains.GoodsId = vbRecord.GoodsId
                ORDER BY tmpRemains.ExpirationDate
            LOOP
            
              IF vbAmount > 0 AND vbAmount = vbRRecord.Remains
              THEN
                PERFORM gpInsertUpdate_MovementItem_Check_DivideGoodsLots (ioId                 := 0
                                                                         , inMovementId         := inMovementId
                                                                         , inGoodsId            := vbRecord.GoodsId
                                                                         , inAmount             := vbAmount
                                                                         , inPrice              := vbRecord.Price
                                                                         , inPriceSale          := vbRecord.PriceSale
                                                                         , inNDSKindId          := vbRRecord.NDSKindId
                                                                         , inPartionDateKindId  := vbRRecord.PartionDateKindId
                                                                         , inDivisionPartiesId  := vbRRecord.DivisionPartiesId
                                                                         , inSession := inSession);
                PERFORM gpInsertUpdate_MovementItem_Check_DivideGoodsLots (ioId                 := MovementItem.Id
                                                                         , inMovementId         := inMovementId
                                                                         , inGoodsId            := vbRecord.GoodsId
                                                                         , inAmount             := MovementItem.Amount - vbAmount
                                                                         , inPrice              := vbRecord.Price
                                                                         , inPriceSale          := vbRecord.PriceSale
                                                                         , inNDSKindId          := vbRecord.NDSKindId
                                                                         , inPartionDateKindId  := vbRecord.PartionDateKindId
                                                                         , inDivisionPartiesId  := vbRecord.DivisionPartiesId
                                                                         , inSession := inSession)
                FROM MovementItem
                WHERE MovementItem.Id = vbRecord.Id;

                DELETE FROM _tmpMI WHERE _tmpMI.ID = vbRecord.Id;          
                DELETE FROM tmpRemains 
                WHERE  tmpRemains.GoodsId = vbRRecord.GoodsId
                  AND tmpRemains.NDSKindId = vbRRecord.NDSKindId
                  AND COALESCE(tmpRemains.PartionDateKindId, 0) = COALESCE(vbRRecord.PartionDateKindId, 0)
                  AND COALESCE(tmpRemains.DivisionPartiesId, 0) = COALESCE(vbRRecord.DivisionPartiesId, 0);                            
              ELSEIF vbAmount > 0 AND vbAmount < vbRRecord.Remains
              THEN

                PERFORM gpInsertUpdate_MovementItem_Check_DivideGoodsLots (ioId                 := 0
                                                                         , inMovementId         := inMovementId
                                                                         , inGoodsId            := vbRecord.GoodsId
                                                                         , inAmount             := vbAmount
                                                                         , inPrice              := vbRecord.Price
                                                                         , inPriceSale          := vbRecord.PriceSale
                                                                         , inNDSKindId          := vbRRecord.NDSKindId
                                                                         , inPartionDateKindId  := vbRRecord.PartionDateKindId
                                                                         , inDivisionPartiesId  := vbRRecord.DivisionPartiesId
                                                                         , inSession := inSession);
                PERFORM gpInsertUpdate_MovementItem_Check_DivideGoodsLots (ioId                 := MovementItem.Id
                                                                         , inMovementId         := inMovementId
                                                                         , inGoodsId            := vbRecord.GoodsId
                                                                         , inAmount             := MovementItem.Amount - vbAmount
                                                                         , inPrice              := vbRecord.Price
                                                                         , inPriceSale          := vbRecord.PriceSale
                                                                         , inNDSKindId          := vbRecord.NDSKindId
                                                                         , inPartionDateKindId  := vbRecord.PartionDateKindId
                                                                         , inDivisionPartiesId  := vbRecord.DivisionPartiesId
                                                                         , inSession := inSession)
                FROM MovementItem
                WHERE MovementItem.Id = vbRecord.Id;
                
                DELETE FROM _tmpMI WHERE _tmpMI.ID = vbRecord.Id;          
                UPDATE tmpRemains SET Remains = tmpRemains.Remains - vbRecord.Amount
                WHERE  tmpRemains.GoodsId = vbRRecord.GoodsId
                  AND tmpRemains.NDSKindId = vbRRecord.NDSKindId
                  AND COALESCE(tmpRemains.PartionDateKindId, 0) = COALESCE(vbRRecord.PartionDateKindId, 0)
                  AND COALESCE(tmpRemains.DivisionPartiesId, 0) = COALESCE(vbRRecord.DivisionPartiesId, 0);
              ELSEIF vbAmount > 0 AND vbAmount > vbRRecord.Remains
              THEN

                PERFORM gpInsertUpdate_MovementItem_Check_DivideGoodsLots (ioId                 := 0
                                                                         , inMovementId         := inMovementId
                                                                         , inGoodsId            := vbRecord.GoodsId
                                                                         , inAmount             := vbRRecord.Remains
                                                                         , inPrice              := vbRecord.Price
                                                                         , inPriceSale          := vbRecord.PriceSale
                                                                         , inNDSKindId          := vbRRecord.NDSKindId
                                                                         , inPartionDateKindId  := vbRRecord.PartionDateKindId
                                                                         , inDivisionPartiesId  := vbRRecord.DivisionPartiesId
                                                                         , inSession := inSession);
                PERFORM gpInsertUpdate_MovementItem_Check_DivideGoodsLots (ioId                 := MovementItem.Id
                                                                         , inMovementId         := inMovementId
                                                                         , inGoodsId            := vbRecord.GoodsId
                                                                         , inAmount             := MovementItem.Amount - vbRRecord.Remains
                                                                         , inPrice              := vbRecord.Price
                                                                         , inPriceSale          := vbRecord.PriceSale
                                                                         , inNDSKindId          := vbRecord.NDSKindId
                                                                         , inPartionDateKindId  := vbRecord.PartionDateKindId
                                                                         , inDivisionPartiesId  := vbRecord.DivisionPartiesId
                                                                         , inSession := inSession)
                FROM MovementItem
                WHERE MovementItem.Id = vbRecord.Id;

                UPDATE _tmpMI SET Amount = _tmpMI.Amount - vbRRecord.Remains WHERE _tmpMI.ID = vbRecord.Id;                 
                DELETE FROM tmpRemains 
                WHERE  tmpRemains.GoodsId = vbRRecord.GoodsId
                  AND tmpRemains.NDSKindId = vbRRecord.NDSKindId
                  AND COALESCE(tmpRemains.PartionDateKindId, 0) = COALESCE(vbRRecord.PartionDateKindId, 0)
                  AND COALESCE(tmpRemains.DivisionPartiesId, 0) = COALESCE(vbRRecord.DivisionPartiesId, 0);              
              END IF;
               
              vbAmount := vbAmount - vbRRecord.Remains;
            
            END LOOP; 
          END LOOP; 
    
          IF EXISTS (SELECT 1 FROM _tmpMI)
          THEN
            RAISE EXCEPTION 'Ошибка. Не удалось перерасределить товар.';
          END IF;
        EXCEPTION
           WHEN others THEN
             GET STACKED DIAGNOSTICS outMessageText = MESSAGE_TEXT;
        END;

        IF NOT EXISTS (SELECT 1 FROM _tmpMI) OR outMessageText = ''
        THEN
          outMessageText := 'Рапределил.';
          outisReload := True;
        END IF;
        
      ELSE
        outMessageText := 'Ошибка. Недостаточно остатка для перерапределения. ';     
      END IF;
    END IF;
    

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 08.06.23                                                       *
*/

-- тест


-- select * from gpGet_Movement_Check_DivideGoodsLots(inMovementId := 32324440 ,  inSession := '3');