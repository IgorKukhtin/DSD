-- Function: gpSelect_GoodsOnUnitRemains_ForTabletki

DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnitRemains_ForTabletki (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnitRemains_ForTabletki(
    IN inUnitId  Integer = 183292, -- Подразделение
    IN inSession TVarChar = '' -- сессия пользователя
)
RETURNS TABLE (RowData  TBlob)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate_Begin1 TDateTime;
   DECLARE vbRetailId    Integer;
   DECLARE vbAddMarkupTabletki TFloat;
BEGIN
    -- сразу запомнили время начала выполнения Проц.
    vbOperDate_Begin1:= CLOCK_TIMESTAMP();

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpGetUserBySession (inSession);
    vbUserId:= inSession :: Integer;

    SELECT ObjectLink_Juridical_Retail.ChildObjectId
    INTO vbRetailId
    FROM ObjectLink AS ObjectLink_Unit_Juridical
         INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
    WHERE ObjectLink_Unit_Juridical.ObjectId = inUnitId
      AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical();
      
    SELECT COALESCE(ObjectFloat_CashSettings_AddMarkupTabletki.ValueData, 0)
    INTO vbAddMarkupTabletki
    FROM Object AS Object_CashSettings
         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_AddMarkupTabletki
                               ON ObjectFloat_CashSettings_AddMarkupTabletki.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_AddMarkupTabletki.DescId = zc_ObjectFloat_CashSettings_AddMarkupTabletki()
    WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
    LIMIT 1;
            
    CREATE TEMP TABLE tmpContainerAll ON COMMIT DROP AS
                   (SELECT Container.ObjectId
                         , Container.Id
                         , Container.ParentId
                         , Container.Amount
                         , Container.DescId  
                    FROM
                        Container
                    WHERE Container.DescId        IN (zc_Container_Count(), zc_Container_CountPartionDate())
                      AND Container.WhereObjectId = inUnitId
                      AND Container.Amount        <> 0
                   );
                       
    ANALYSE tmpContainerAll;

   -- выбираем отложенные Чеки (как в кассе колонка VIP)
    CREATE TEMP TABLE tmpMovementChek ON COMMIT DROP AS
                        (SELECT Movement.Id
                         FROM MovementBoolean AS MovementBoolean_Deferred
                              INNER JOIN Movement ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                                 AND Movement.DescId = zc_Movement_Check()
                                                 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId = inUnitId
                         WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                           AND MovementBoolean_Deferred.ValueData = TRUE
                        UNION
                         SELECT Movement.Id
                         FROM MovementString AS MovementString_CommentError
                              INNER JOIN Movement ON Movement.Id     = MovementString_CommentError.MovementId
                                                 AND Movement.DescId = zc_Movement_Check()
                                                 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId = inUnitId
                        WHERE MovementString_CommentError.DescId = zc_MovementString_CommentError()
                          AND MovementString_CommentError.ValueData <> ''
                        );
                        
    ANALYSE tmpMovementChek;
    

    RETURN QUERY
    WITH
     tmpContainerPD AS
                   (SELECT Container.ParentId
                         , SUM(Container.Amount) AS Amount
                    FROM
                        tmpContainerAll AS Container

                        INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                      AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                        INNER JOIN ObjectDate AS ObjectDate_ExpirationDate
                                              ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId  
                                             AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                             AND ObjectDate_ExpirationDate.ValueData <= CURRENT_DATE
                                                     
                    WHERE Container.DescId        = zc_Container_CountPartionDate()
                    GROUP BY Container.ParentId
                   )
   , tmpContainer AS
                   (SELECT Container.ObjectId
                         , Container.Id
                         , (Container.Amount - COALESCE (tmpContainerPD.Amount, 0)) AS Amount
                    FROM
                        tmpContainerAll AS Container
                        
                        LEFT JOIN tmpContainerPD ON tmpContainerPD.ParentId = Container.Id
                    WHERE Container.DescId        = zc_Container_Count()
                      AND (Container.Amount - COALESCE (tmpContainerPD.Amount, 0)) > 0
                   )
   , tmpPartionMI AS
                   (SELECT CLO.ContainerId
                         , MILinkObject_Goods.ObjectId AS GoodsId_find
                    FROM ContainerLinkObject AS CLO
                        LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO.ObjectId
                        LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                         ON MILinkObject_Goods.MovementItemId = Object_PartionMovementItem.ObjectCode
                                                        AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                    WHERE CLO.ContainerId IN (SELECT DISTINCT tmpContainer.Id FROM tmpContainer)
                      AND CLO.DescId      = zc_ContainerLinkObject_PartionMovementItem()
                   )
   , tmpRemains AS (SELECT Container.ObjectId
                         , tmpPartionMI.GoodsId_find
                         , SUM (Container.Amount)  AS Amount
                    FROM tmpContainer AS Container
                        LEFT JOIN tmpPartionMI ON tmpPartionMI.ContainerId = Container.Id
                        LEFT JOIN ObjectBoolean AS ObjectBoolean_isNotUploadSites
                                                ON ObjectBoolean_isNotUploadSites.ObjectId = Container.ObjectId
                                               AND ObjectBoolean_isNotUploadSites.DescId   = zc_ObjectBoolean_Goods_isNotUploadSites()

                    WHERE COALESCE (ObjectBoolean_isNotUploadSites.ValueData, FALSE) = FALSE
                    GROUP BY Container.ObjectId
                           , tmpPartionMI.GoodsId_find
                   )
   , tmpGoods AS (SELECT ObjectString.ObjectId AS GoodsId_find, ObjectString.ValueData AS MakerName
                    FROM ObjectString
                    WHERE ObjectString.ObjectId IN (SELECT DISTINCT tmpRemains.GoodsId_find FROM tmpRemains)
                      AND ObjectString.DescId   = zc_ObjectString_Goods_Maker()
                   )
   , Remains AS (SELECT
                         tmpRemains.ObjectId
                       , MAX (tmpGoods.MakerName) AS MakerName
                       , SUM (tmpRemains.Amount) AS Amount
                    FROM
                        tmpRemains
                        LEFT JOIN tmpGoods ON tmpGoods.GoodsId_find = tmpRemains.GoodsId_find
                    GROUP BY tmpRemains.ObjectId
                    HAVING SUM (tmpRemains.Amount) > 0
                   )

       , tmpReserve AS (SELECT MovementItem.ObjectId             AS GoodsId
                         , SUM (MovementItem.Amount)::TFloat AS ReserveAmount
                    FROM tmpMovementChek
                         INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovementChek.Id
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = FALSE
                    GROUP BY MovementItem.ObjectId
                    )
       -- Отложенные технические переучеты
       , tmpMovementTP AS (SELECT MovementItemMaster.ObjectId      AS GoodsId
                                , SUM(-MovementItemMaster.Amount)  AS Amount
                           FROM Movement AS Movement

                                INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                              ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                             AND MovementLinkObject_Unit.ObjectId = inUnitId
                                                               
                                INNER JOIN MovementItem AS MovementItemMaster
                                                        ON MovementItemMaster.MovementId = Movement.Id
                                                       AND MovementItemMaster.DescId     = zc_MI_Master()
                                                       AND MovementItemMaster.isErased   = FALSE
                                                       AND MovementItemMaster.Amount     < 0
                                                         
                                INNER JOIN MovementItemBoolean AS MIBoolean_Deferred
                                                               ON MIBoolean_Deferred.MovementItemId = MovementItemMaster.Id
                                                              AND MIBoolean_Deferred.DescId         = zc_MIBoolean_Deferred()
                                                              AND MIBoolean_Deferred.ValueData      = TRUE
                                                               
                           WHERE Movement.DescId = zc_Movement_TechnicalRediscount()
                             AND Movement.StatusId = zc_Enum_Status_UnComplete()
                           GROUP BY MovementItemMaster.ObjectId)
       , T1 AS (SELECT MIN (Remains.ObjectId) AS ObjectId
                FROM Remains
                     INNER JOIN Object AS Object_Goods ON Object_Goods.Id = Remains.ObjectId
                GROUP BY Object_Goods.ObjectCode
               )
      ,  tmpPrice AS (SELECT ObjectLink_Price_Unit.ObjectId          AS Id
                           , Price_Goods.ChildObjectId               AS GoodsId
                      FROM ObjectLink AS ObjectLink_Price_Unit
                           INNER JOIN ObjectLink AS Price_Goods
                                                 ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                      WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                        AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                           )
      , tmpPrice_View AS (SELECT tmpPrice.GoodsId 
                               , ROUND (CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                              AND ObjectFloat_Goods_Price.ValueData > 0
                                             THEN ObjectFloat_Goods_Price.ValueData
                                             ELSE Price_Value.ValueData
                                        END * CASE WHEN vbAddMarkupTabletki > 0 AND  COALESCE(ObjectFloat_Goods_PercentMarkup.ValueData, 0) > 0 
                                                   THEN 100.0 + vbAddMarkupTabletki ELSE 100.0 END / 100.0, 2) :: TFloat                                                                                  AS Price
                               , COALESCE(ObjectFloat_Goods_PercentMarkup.ValueData, 0)                                         AS PercentMarkup                                      
                          FROM tmpPrice
                               LEFT JOIN ObjectFloat AS Price_Value
                                                     ON Price_Value.ObjectId = tmpPrice.Id
                                                    AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                               -- Фикс цена для всей Сети
                               LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                      ON ObjectFloat_Goods_Price.ObjectId = tmpPrice.GoodsId
                                                     AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                               LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_PercentMarkup
                                                      ON ObjectFloat_Goods_PercentMarkup.ObjectId = tmpPrice.GoodsId
                                                     AND ObjectFloat_Goods_PercentMarkup.DescId   = zc_ObjectFloat_Goods_PercentMarkup()
                               LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                       ON ObjectBoolean_Goods_TOP.ObjectId = tmpPrice.GoodsId
                                                      AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                          )
        -- Штрих-коды производителя
      , tmpGoodsBarCode AS (SELECT ObjectLink_Main_BarCode.ChildObjectId AS GoodsMainId
                                 , string_agg(Object_Goods_BarCode.ValueData, ',' ORDER BY Object_Goods_BarCode.ID desc)           AS BarCode
                            FROM ObjectLink AS ObjectLink_Main_BarCode
                                 JOIN ObjectLink AS ObjectLink_Child_BarCode
                                                 ON ObjectLink_Child_BarCode.ObjectId = ObjectLink_Main_BarCode.ObjectId
                                                AND ObjectLink_Child_BarCode.DescId = zc_ObjectLink_LinkGoods_Goods()
                                 JOIN ObjectLink AS ObjectLink_Goods_Object_BarCode
                                                 ON ObjectLink_Goods_Object_BarCode.ObjectId = ObjectLink_Child_BarCode.ChildObjectId
                                                AND ObjectLink_Goods_Object_BarCode.DescId = zc_ObjectLink_Goods_Object()
                                                AND ObjectLink_Goods_Object_BarCode.ChildObjectId = zc_Enum_GlobalConst_BarCode()
                                 LEFT JOIN Object AS Object_Goods_BarCode ON Object_Goods_BarCode.Id = ObjectLink_Goods_Object_BarCode.ObjectId
                            WHERE ObjectLink_Main_BarCode.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                              AND ObjectLink_Main_BarCode.ChildObjectId > 0
                              AND TRIM (Object_Goods_BarCode.ValueData) <> ''
                            GROUP BY ObjectLink_Main_BarCode.ChildObjectId
                           )
      , tmpGoodsSP AS (SELECT DISTINCT MovementItem.ObjectId         AS GoodsId
                          FROM Movement
                               INNER JOIN MovementDate AS MovementDate_OperDateStart
                                                       ON MovementDate_OperDateStart.MovementId = Movement.Id
                                                      AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                                      AND MovementDate_OperDateStart.ValueData  <= CURRENT_DATE

                               INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                                       ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                                      AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                                      AND MovementDate_OperDateEnd.ValueData  >= CURRENT_DATE
                               LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE

                               LEFT JOIN MovementItemLinkObject AS MI_IntenalSP
                                                                ON MI_IntenalSP.MovementItemId = MovementItem.Id
                                                               AND MI_IntenalSP.DescId = zc_MILinkObject_IntenalSP()

                          WHERE Movement.DescId = zc_Movement_GoodsSP()
                            AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                         )
          -- Товары дисконтной программы
          , tmpUnitDiscount AS (SELECT ObjectLink_DiscountExternal.ChildObjectId     AS DiscountExternalId
                                     , ObjectLink_Unit.ChildObjectId                  AS UnitId
                                FROM Object AS Object_DiscountExternalTools
                                      LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                                           ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountExternalTools.Id
                                                          AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalTools_DiscountExternal()
                                      LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                           ON ObjectLink_Unit.ObjectId = Object_DiscountExternalTools.Id
                                                          AND ObjectLink_Unit.DescId = zc_ObjectLink_DiscountExternalTools_Unit()
                                 WHERE Object_DiscountExternalTools.DescId = zc_Object_DiscountExternalTools()
                                   AND Object_DiscountExternalTools.isErased = False
                                   AND ObjectLink_Unit.ChildObjectId  = inUnitId
                                 )
          -- Товары дисконтной программы
          , tmpGoodsDiscount AS (SELECT Object_Goods_Retail.GoodsMainId                        AS GoodsMainId
                                      , Object_Goods_Retail.Id                                 AS GoodsId
                                      , tmpUnitDiscount.DiscountExternalId                     AS DiscountExternalId
                                      , COALESCE (ObjectBoolean_DiscountSite.ValueData, False) AS isDiscountSite
                                                   
                                      , MAX(ObjectFloat_MaxPrice.ValueData)                    AS MaxPrice 
                                      , MAX(ObjectFloat_DiscountProcent.ValueData)             AS DiscountProcent 
                                                                               
                                  FROM Object AS Object_BarCode

                                       LEFT JOIN ObjectBoolean AS ObjectBoolean_DiscountSite
                                                                ON ObjectBoolean_DiscountSite.ObjectId = Object_BarCode.Id
                                                               AND ObjectBoolean_DiscountSite.DescId = zc_ObjectBoolean_BarCode_DiscountSite()
                                                               AND ObjectBoolean_DiscountSite.ValueData = True

                                       LEFT JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                                            ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                                                           AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                                       LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = ObjectLink_BarCode_Goods.ChildObjectId
                                           
                                       LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                                            ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                                           AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                                       LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId           

                                       LEFT JOIN tmpUnitDiscount ON tmpUnitDiscount.DiscountExternalId = ObjectLink_BarCode_Object.ChildObjectId 

                                       LEFT JOIN ObjectFloat AS ObjectFloat_MaxPrice
                                                             ON ObjectFloat_MaxPrice.ObjectId = Object_BarCode.Id
                                                            AND ObjectFloat_MaxPrice.DescId = zc_ObjectFloat_BarCode_MaxPrice()
                                       LEFT JOIN ObjectFloat AS ObjectFloat_DiscountProcent
                                                             ON ObjectFloat_DiscountProcent.ObjectId = Object_BarCode.Id
                                                            AND ObjectFloat_DiscountProcent.DescId = zc_ObjectFloat_BarCode_DiscountProcent()

                                 WHERE Object_BarCode.DescId = zc_Object_BarCode()
                                   AND Object_BarCode.isErased = False
                                   AND Object_Object.isErased = False
                                   AND COALESCE (tmpUnitDiscount.DiscountExternalId, 0) <> 0
                                 GROUP BY Object_Goods_Retail.GoodsMainId 
                                        , Object_Goods_Retail.Id
                                        , tmpUnitDiscount.DiscountExternalId
                                        , ObjectBoolean_DiscountSite.ValueData
                          )
       , tmpRemainsDiscount AS (SELECT Container.ObjectId         AS GoodsId
                                     , SUM(CASE WHEN COALESCE (ContainerPD.Id, 0) = 0 AND COALESCE (DiscountExternalSupplier.DiscountExternalId, 0) <> 0 
                                                     AND Container.Amount >= 1 THEN FLOOR(Container.Amount) ELSE 0 END) AS AmountDiscount
                                     , SUM(Container.Amount)      AS Amount
                                FROM (SELECT DISTINCT tmpGoodsDiscount.GoodsId, tmpGoodsDiscount.DiscountExternalId FROM tmpGoodsDiscount) AS GoodsDiscount
                                
                                     JOIN Container ON Container.ObjectId = GoodsDiscount.GoodsId
                                                   AND Container.DescId = zc_Container_Count() 
                                                   AND Container.Amount > 0
                                                   AND Container.WhereObjectId = inUnitId
   
                                     JOIN containerlinkobject AS CLI_MI
                                                          ON CLI_MI.containerid = Container.Id
                                                         AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                                     LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                     -- элемент прихода
                                     LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                     -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                     LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                 ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                                AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                     -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                     LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                                                          -- AND 1=0
                                     LEFT OUTER JOIN MovementItemDate AS MIDate_ExpirationDate
                                                                      ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                                     AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                                     LEFT OUTER JOIN Movement AS Movement_Income
                                                              ON Movement_Income.Id = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)  --Object_PartionMovementItem.ObjectCode

                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                  ON MovementLinkObject_From.MovementId = COALESCE (MI_Income_find.MovementId ,MI_Income.MovementId)
                                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                        
                                     LEFT JOIN Container AS ContainerPD
                                                         ON ContainerPD.ParentId = Container.Id
                                                        AND ContainerPD.Amount > 0
                                                        AND ContainerPD.DescId = zc_Container_CountPartionDate()
                                                        
                                     LEFT JOIN gpSelect_Object_DiscountExternalSupplier(inSession := inSession) AS DiscountExternalSupplier
                                                                                                                ON DiscountExternalSupplier.isErased = False
                                                                                                               AND DiscountExternalSupplier.DiscountExternalId =  GoodsDiscount.DiscountExternalId
                                                                                                               AND DiscountExternalSupplier.JuridicalId = MovementLinkObject_From.ObjectId
                                                        
                               GROUP BY Container.ObjectId
                               )
                -- Цена со скидкой
          , tmpPriceChange AS (SELECT DISTINCT ObjectLink_PriceChange_Goods.ChildObjectId                                                    AS GoodsId
                                    , COALESCE (PriceChange_Value_Unit.ValueData, PriceChange_Value_Retail.ValueData)                        AS PriceChange
                                    , COALESCE (PriceChange_FixPercent_Unit.ValueData, PriceChange_FixPercent_Retail.ValueData)::TFloat      AS FixPercent
                                    , COALESCE (PriceChange_FixDiscount_Unit.ValueData, PriceChange_FixDiscount_Retail.ValueData)::TFloat    AS FixDiscount
                                    , COALESCE (PriceChange_Multiplicity_Unit.ValueData, PriceChange_Multiplicity_Retail.ValueData) ::TFloat AS Multiplicity
                               FROM Object AS Object_PriceChange
                                    -- скидка по подразд
                                    LEFT JOIN ObjectLink AS ObjectLink_PriceChange_Unit
                                                         ON ObjectLink_PriceChange_Unit.ObjectId = Object_PriceChange.Id
                                                        AND ObjectLink_PriceChange_Unit.DescId = zc_ObjectLink_PriceChange_Unit()
                                                        AND ObjectLink_PriceChange_Unit.ChildObjectId = inUnitId
                                    -- цена со скидкой по подразд.
                                    LEFT JOIN ObjectFloat AS PriceChange_Value_Unit
                                                          ON PriceChange_Value_Unit.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                         AND PriceChange_Value_Unit.DescId = zc_ObjectFloat_PriceChange_Value()
                                                         AND COALESCE (PriceChange_Value_Unit.ValueData, 0) <> 0
                                    -- процент скидки по подразд.
                                    LEFT JOIN ObjectFloat AS PriceChange_FixPercent_Unit
                                                          ON PriceChange_FixPercent_Unit.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                         AND PriceChange_FixPercent_Unit.DescId = zc_ObjectFloat_PriceChange_FixPercent()
                                                         AND COALESCE (PriceChange_FixPercent_Unit.ValueData, 0) <> 0
                                    -- сумма скидки по подразд.
                                    LEFT JOIN ObjectFloat AS PriceChange_FixDiscount_Unit
                                                          ON PriceChange_FixDiscount_Unit.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                         AND PriceChange_FixDiscount_Unit.DescId = zc_ObjectFloat_PriceChange_FixDiscount()
                                                         AND COALESCE (PriceChange_FixDiscount_Unit.ValueData, 0) <> 0
                                    -- Кратность отпуска
                                    LEFT JOIN ObjectFloat AS PriceChange_Multiplicity_Unit
                                                          ON PriceChange_Multiplicity_Unit.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                         AND PriceChange_Multiplicity_Unit.DescId = zc_ObjectFloat_PriceChange_Multiplicity()
                                                         AND COALESCE (PriceChange_Multiplicity_Unit.ValueData, 0) <> 0
                                    -- Дата окончания действия скидки
                                    LEFT JOIN ObjectDate AS PriceChange_FixEndDate_Unit
                                                         ON PriceChange_FixEndDate_Unit.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                        AND PriceChange_FixEndDate_Unit.DescId = zc_ObjectDate_PriceChange_FixEndDate()
                                                            
                                    LEFT JOIN ObjectLink AS ObjectLink_PriceChange_PartionDateKind_Unit
                                                          ON ObjectLink_PriceChange_PartionDateKind_Unit.ObjectId  = ObjectLink_PriceChange_Unit.ObjectId
                                                         AND ObjectLink_PriceChange_PartionDateKind_Unit.DescId    = zc_ObjectLink_PriceChange_PartionDateKind()
                                                            

                                    -- скидка по сети
                                    LEFT JOIN ObjectLink AS ObjectLink_PriceChange_Retail
                                                         ON ObjectLink_PriceChange_Retail.ObjectId = Object_PriceChange.Id
                                                        AND ObjectLink_PriceChange_Retail.DescId = zc_ObjectLink_PriceChange_Retail()
                                                        AND ObjectLink_PriceChange_Retail.ChildObjectId = vbRetailId
                                    -- цена со скидкой по сети
                                    LEFT JOIN ObjectFloat AS PriceChange_Value_Retail
                                                          ON PriceChange_Value_Retail.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                                         AND PriceChange_Value_Retail.DescId = zc_ObjectFloat_PriceChange_Value()
                                                         AND COALESCE (PriceChange_Value_Retail.ValueData, 0) <> 0
                                    -- процент скидки по сети.
                                    LEFT JOIN ObjectFloat AS PriceChange_FixPercent_Retail
                                                          ON PriceChange_FixPercent_Retail.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                                         AND PriceChange_FixPercent_Retail.DescId = zc_ObjectFloat_PriceChange_FixPercent()
                                                         AND COALESCE (PriceChange_FixPercent_Retail.ValueData, 0) <> 0
                                    -- сумма скидки по сети.
                                    LEFT JOIN ObjectFloat AS PriceChange_FixDiscount_Retail
                                                          ON PriceChange_FixDiscount_Retail.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                                         AND PriceChange_FixDiscount_Retail.DescId = zc_ObjectFloat_PriceChange_FixDiscount()
                                                         AND COALESCE (PriceChange_FixDiscount_Retail.ValueData, 0) <> 0
                                    -- Кратность отпуска по сети.
                                    LEFT JOIN ObjectFloat AS PriceChange_Multiplicity_Retail
                                                          ON PriceChange_Multiplicity_Retail.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                                         AND PriceChange_Multiplicity_Retail.DescId = zc_ObjectFloat_PriceChange_Multiplicity()
                                                         AND COALESCE (PriceChange_Multiplicity_Retail.ValueData, 0) <> 0
                                    -- Дата окончания действия скидки по сети.
                                    LEFT JOIN ObjectDate AS PriceChange_FixEndDate_Retail
                                                         ON PriceChange_FixEndDate_Retail.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                                        AND PriceChange_FixEndDate_Retail.DescId = zc_ObjectDate_PriceChange_FixEndDate()

                                    LEFT JOIN ObjectLink AS ObjectLink_PriceChange_PartionDateKind_Retail
                                                          ON ObjectLink_PriceChange_PartionDateKind_Retail.ObjectId  = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                                         AND ObjectLink_PriceChange_PartionDateKind_Retail.DescId    = zc_ObjectLink_PriceChange_PartionDateKind()

                                    LEFT JOIN ObjectLink AS ObjectLink_PriceChange_Goods
                                                         ON ObjectLink_PriceChange_Goods.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                                        AND ObjectLink_PriceChange_Goods.DescId = zc_ObjectLink_PriceChange_Goods()

                               WHERE Object_PriceChange.DescId = zc_Object_PriceChange()
                                 AND Object_PriceChange.isErased = FALSE
                                 AND (COALESCE (PriceChange_Value_Retail.ValueData, 0) <> 0 OR COALESCE (PriceChange_Value_Unit.ValueData, 0) <> 0 OR
                                     COALESCE (PriceChange_FixPercent_Unit.ValueData, PriceChange_FixPercent_Retail.ValueData, 0) <> 0 OR
                                     COALESCE (PriceChange_FixDiscount_Unit.ValueData, PriceChange_FixDiscount_Retail.ValueData, 0) <> 0) -- выбираем только цены <> 0
                                 AND COALESCE (PriceChange_Multiplicity_Unit.ValueData, PriceChange_Multiplicity_Retail.ValueData, 0) IN (0, 1)
                                 AND COALESCE (PriceChange_FixEndDate_Unit.ValueData, PriceChange_FixEndDate_Retail.ValueData, CURRENT_DATE) >= CURRENT_DATE   
                                 AND COALESCE (ObjectLink_PriceChange_PartionDateKind_Unit.ChildObjectId, ObjectLink_PriceChange_PartionDateKind_Retail.ChildObjectId, 0) = 0 
                              )
                          
       , tmpResult AS (
                      --Шапка
                      SELECT '<?xml version="1.0" encoding="utf-8"?>'::TVarChar AS RowData
                      UNION ALL
                      SELECT '<Offers>'::TVarChar
                      UNION ALL
                      --Тело
                        SELECT
                            '<Offer Code="'||CAST(Object_Goods_Main.ObjectCode AS TVarChar)
                               ||'" Name="'||replace(replace(replace(Object_Goods_Main.Name, '"', ''),'&','&amp;'),'''','')
                               ||'" Producer="'||replace(replace(replace(COALESCE(Remains.MakerName,''),'"',''),'&','&amp;'),'''','')
                               ||'" Price="'||to_char(CASE WHEN COALESCE(Object_Price.Price, 0) > 0 AND COALESCE (GoodsDiscount.DiscountProcent, 0) > 0 AND GoodsDiscount.isDiscountSite = TRUE
                                                           THEN ROUND(CASE WHEN COALESCE(GoodsDiscount.MaxPrice, 0) = 0 OR Object_Price.Price < GoodsDiscount.MaxPrice
                                                                           THEN Object_Price.Price ELSE GoodsDiscount.MaxPrice END * (100 - GoodsDiscount.DiscountProcent) / 100, 1)
                                                           ELSE zfCalc_PriceCash(CASE WHEN COALESCE (PriceChange.PriceChange, 0) > 0 
                                                                                      THEN PriceChange.PriceChange
                                                                                      WHEN COALESCE (PriceChange.FixPercent, 0) > 0 
                                                                                      THEN Object_Price.Price * (100.0 - PriceChange.FixPercent) / 100.0
                                                                                      WHEN COALESCE (PriceChange.FixDiscount, 0) > 0 AND Object_Price.Price > PriceChange.FixDiscount
                                                                                      THEN Object_Price.Price - PriceChange.FixDiscount
                                                                                      ELSE Object_Price.Price END, CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                                                                                                        COALESCE(GoodsDiscount.GoodsMainId, 0) <> 0) END
                                                                                           ,'FM9999990.00')
                               ||'" Quantity="'||CAST((CASE WHEN COALESCE (GoodsDiscount.DiscountProcent, 0) > 0 THEN RemainsDiscount.AmountDiscount ELSE Remains.Amount END - 
                                                       coalesce(Reserve_Goods.ReserveAmount, 0) - COALESCE (Reserve_TP.Amount, 0)) AS TVarChar)
                               ||'" PriceReserve="'||to_char(CASE WHEN COALESCE(Object_Price.Price, 0) > 0 AND COALESCE (GoodsDiscount.DiscountProcent, 0) > 0 AND GoodsDiscount.isDiscountSite = TRUE
                                                           THEN ROUND(CASE WHEN COALESCE(GoodsDiscount.MaxPrice, 0) = 0 OR Object_Price.Price < GoodsDiscount.MaxPrice
                                                                           THEN Object_Price.Price ELSE GoodsDiscount.MaxPrice END * (100 - GoodsDiscount.DiscountProcent) / 100, 1)
                                                           ELSE zfCalc_PriceCash(CASE WHEN COALESCE (PriceChange.PriceChange, 0) > 0 
                                                                                      THEN PriceChange.PriceChange
                                                                                      WHEN COALESCE (PriceChange.FixPercent, 0) > 0 
                                                                                      THEN Object_Price.Price * (100.0 - PriceChange.FixPercent) / 100.0
                                                                                      WHEN COALESCE (PriceChange.FixDiscount, 0) > 0 AND Object_Price.Price > PriceChange.FixDiscount
                                                                                      THEN Object_Price.Price - PriceChange.FixDiscount
                                                                                      ELSE Object_Price.Price END, CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                                                                                                        COALESCE(GoodsDiscount.GoodsMainId, 0) <> 0) END
                                                                                           ,'FM9999990.00')
                               ||'" Barcode="'||COALESCE (tmpGoodsBarCode.BarCode, '')
                               ||'" />'

                        FROM Remains
                             INNER JOIN T1 ON T1.ObjectId = Remains.ObjectId

                             INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = Remains.ObjectId
                             INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

                             LEFT JOIN tmpPrice_View AS Object_Price ON Object_Price.GoodsId = Remains.ObjectId
                             
                             LEFT JOIN tmpPriceChange AS PriceChange ON PriceChange.GoodsId = Remains.ObjectId
                             
                             LEFT JOIN tmpReserve AS Reserve_Goods ON Reserve_Goods.GoodsId = Remains.ObjectId
                             
                             LEFT JOIN tmpMovementTP AS Reserve_TP ON Reserve_TP.GoodsId = Remains.ObjectId

                             LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = Object_Goods_Main.Id
                             LEFT JOIN tmpGoodsDiscount AS GoodsDiscount ON GoodsDiscount.GoodsMainId = Object_Goods_Main.Id
                             LEFT JOIN tmpRemainsDiscount AS RemainsDiscount ON RemainsDiscount.GoodsId = Object_Goods_Retail.Id

                             -- штрих-код производителя
                             LEFT JOIN tmpGoodsBarCode ON tmpGoodsBarCode.GoodsMainId = Object_Goods_Main.Id
                        WHERE (CASE WHEN COALESCE (GoodsDiscount.DiscountProcent, 0) > 0 THEN RemainsDiscount.AmountDiscount ELSE Remains.Amount END - 
                                         COALESCE (Reserve_Goods.ReserveAmount, 0) - COALESCE (Reserve_TP.Amount, 0)) > 0
                          AND Object_Goods_Main.Name NOT ILIKE '%Спеццена%'
                          AND Object_Goods_Main.ObjectCode NOT IN (3274, 17789)                          
                      UNION ALL
                      -- подва
                      SELECT '</Offers>')
                      
       SELECT tmpResult.RowData::TBlob FROM tmpResult;


/*
     -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
     INSERT INTO ResourseProtocol (UserId
                                 , OperDate
                                 , Value1
                                 , Value2
                                 , Value3
                                 , Value4
                                 , Value5
                                 , Time1
                                 , Time2
                                 , Time3
                                 , Time4
                                 , Time5
                                 , ProcName
                                 , ProtocolData
                                  )
        WITH tmp_pg AS (SELECT * FROM pg_stat_activity WHERE state = 'active')
        SELECT vbUserId
               -- во сколько началась
             , CURRENT_TIMESTAMP
             , (SELECT COUNT (*) FROM tmp_pg)                                   AS Value1
             , (SELECT COUNT (*) FROM tmp_pg WHERE client_addr =  '172.17.2.4') AS Value2
             , (SELECT COUNT (*) FROM tmp_pg WHERE client_addr <> '172.17.2.4') AS Value3
             , 0 AS Value4
             , (SELECT COUNT (*) FROM _Result) AS Value5
               -- сколько всего выполнялась проц
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin1) :: INTERVAL AS Time1
               -- сколько всего выполнялась проц
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin1) :: INTERVAL AS Time2
               -- сколько всего выполнялась проц
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin1) :: INTERVAL AS Time3
               -- сколько всего выполнялась проц
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin1) :: INTERVAL AS Time4
               -- во сколько закончилась
             , CLOCK_TIMESTAMP() AS Time5
               -- ProcName
             , 'gpSelect_GoodsOnUnitRemains_ForTabletki'
               -- ProtocolData
             , inUnitId :: TVarChar
        WHERE vbUserId > 0
       ;*/
       
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_GoodsOnUnitRemains_ForTabletki (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В.
 14.04.20                                                                                      *
 18.02.19                                                                                      *
 29.01.19                                                                                      *
 23.07.18                                                                                      *
 24.05.18                                                                                      *
 29.03.18                                                                                      *
 15.01.16                                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_GoodsOnUnitRemains_ForTabletki (inUnitId := 183292, inSession:= '-3')

--Select * from gpSelect_GoodsOnUnitRemains_ForTabletki(10128935 ,'3');
--Select * from gpSelect_GoodsOnUnitRemains_ForTabletki(8156016  ,'3');
Select * from gpSelect_GoodsOnUnitRemains_ForTabletki(16001195   ,'3') --  where RowData ILIKE '%Гептрал%';