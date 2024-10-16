-- Function: gpInsertUpdate_MovementItem_OrderInternalMCSLayout()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderInternalMCSLayout(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderInternalMCSLayout(
    IN inUnitId              Integer   , -- �������������
    IN inNeedCreate          Boolean   , -- ����� �� ���������
   OUT outOrderExists        Boolean   , -- ������ ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbOperDate TDateTime;

   DECLARE vbDate180 TDateTime;
   DECLARE vbDate9 TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_OrderInternal());
    
    vbDate180 := CURRENT_DATE + zc_Interval_ExpirationDate()+ zc_Interval_ExpirationDate();   -- ����� 1 ��� (������� =6 ���.)
    vbDate9 := CURRENT_DATE + INTERVAL '9 MONTH';

    -- raise notice 'Value 0: %', CLOCK_TIMESTAMP();

    IF inNeedCreate = True  --���� � ���������� ��������� ����� �� �������������
    THEN -- �� ������������ ������ �� ������� ����� �������� � ���
        vbUserId := inSession;
        vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
        vbOperDate := CURRENT_DATE;
        --���� ������ �� �������, ����������, �������� ���������
        SELECT Movement.Id INTO vbMovementId
        FROM Movement
            JOIN MovementLinkObject AS MovementLinkObject_Unit
                                    ON MovementLinkObject_Unit.MovementId = Movement.Id
                                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
        WHERE
            Movement.StatusId = zc_Enum_Status_UnComplete()
            AND
            Movement.DescId = zc_Movement_OrderInternal()
            AND
            Movement.OperDate = vbOperDate
            AND
            MovementLinkObject_Unit.ObjectId = inUnitId
        ORDER BY
            Movement.Id
        LIMIT 1;

        IF COALESCE(vbMovementId, 0) = 0 THEN --���� ����� ��� - �������
            vbMovementId := gpInsertUpdate_Movement_OrderInternal(0, '', vbOperDate, inUnitId, 0, inSession);
        END IF;
        --������� ���������� ������
        DELETE FROM MovementItemFloat
        WHERE
            MovementItemId in (
                                SELECT MovementItem.Id
                                FROM MovementItem
                                    INNER JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                                 ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                                AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                                WHERE
                                    MovementItem.MovementId = vbMovementId
                              )
            AND
            DescId = zc_MIFloat_AmountManual();


        DELETE FROM MovementItemFloat
        WHERE
            MovementItemId in (
                                SELECT Id from MovementItem
                                Where MovementItem.MovementId = vbMovementId
                              )
            AND
            DescId = zc_MIFloat_AmountSecond();

    -- raise notice 'Value 1: % %', CLOCK_TIMESTAMP(), vbMovementId;

       CREATE TEMP TABLE _tmpMovement  ON COMMIT DROP AS
	                              (SELECT Movement.*
                                   FROM Movement 
                                   WHERE Movement.DescId in (zc_Movement_Income(), zc_Movement_Send(), zc_Movement_Check())
                                     AND Movement.StatusId = zc_Enum_Status_UnComplete());
	   
	   ANALYSE _tmpMovement;

    -- raise notice 'Value 2: %', CLOCK_TIMESTAMP();


       CREATE TEMP TABLE tmpLayoutAll  ON COMMIT DROP AS
       WITH    
              -- ��������       
              tmpLayoutMovement AS (SELECT Movement.Id                                             AS Id
                                          , COALESCE(MovementBoolean_PharmacyItem.ValueData, FALSE) AS isPharmacyItem
                                     FROM Movement
                                          LEFT JOIN MovementBoolean AS MovementBoolean_PharmacyItem
                                                                    ON MovementBoolean_PharmacyItem.MovementId = Movement.Id
                                                                   AND MovementBoolean_PharmacyItem.DescId = zc_MovementBoolean_PharmacyItem()
                                     WHERE Movement.DescId = zc_Movement_Layout()
                                       AND Movement.StatusId = zc_Enum_Status_Complete()
                                    )
            , tmpLayout AS (SELECT Movement.ID                        AS Id
                                  , MovementItem.ObjectId              AS GoodsId
                                  , MovementItem.Amount                AS Amount
                                  , Movement.isPharmacyItem            AS isPharmacyItem
                             FROM tmpLayoutMovement AS Movement
                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                         AND MovementItem.DescId = zc_MI_Master()
                                                         AND MovementItem.isErased = FALSE
                                                         AND MovementItem.Amount > 0
                            )
            , tmpLayoutUnit AS (SELECT Movement.ID                        AS Id
                                     , MovementItem.ObjectId              AS UnitId
                                FROM tmpLayoutMovement AS Movement
                                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                            AND MovementItem.DescId = zc_MI_Child()
                                                            AND MovementItem.isErased = FALSE
                                                            AND MovementItem.Amount > 0
                               )
                                     
            , tmpLayoutUnitCount AS (SELECT tmpLayoutUnit.ID                  AS Id
                                          , count(*)                          AS CountUnit
                                     FROM tmpLayoutUnit
                                     GROUP BY tmpLayoutUnit.ID
                                     )
            SELECT tmpLayout.GoodsId                  AS GoodsId
                                    , MAX(tmpLayout.Amount)::TFloat      AS Amount
                               FROM tmpLayout
                                 
                                    LEFT JOIN Object AS Object_Unit
                                                     ON Object_Unit.Id        = inUnitId
                                                    AND Object_Unit.DescId    = zc_Object_Unit()

                                    LEFT JOIN tmpLayoutUnit ON tmpLayoutUnit.Id     = tmpLayout.Id
                                                           AND tmpLayoutUnit.UnitId = inUnitId

                                    LEFT JOIN tmpLayoutUnitCount ON tmpLayoutUnitCount.Id     = tmpLayout.Id
                                       
                               WHERE (tmpLayoutUnit.UnitId = inUnitId OR COALESCE (tmpLayoutUnitCount.CountUnit, 0) = 0)
                                 AND (Object_Unit.ValueData NOT ILIKE '���. ����� %' OR tmpLayout.isPharmacyItem = True)
                               GROUP BY tmpLayout.GoodsId;
                               
       ANALYSE tmpLayoutAll;
                               
    -- raise notice 'Value 21: %', CLOCK_TIMESTAMP();


       CREATE TEMP TABLE tmpPrice ON COMMIT DROP AS
       WITH    
              
            -- ���
              tmpPriceAll AS (SELECT ObjectLink_Price_Unit.ChildObjectId     AS UnitId
                                         , Price_Goods.ChildObjectId               AS GoodsId
                                         , ROUND(Price_Value.ValueData,2)::TFloat  AS Price
                                           -- 03.03.2022 ������� �� ������� �������� ��� ��� ��������
                                         , CASE WHEN COALESCE(tmpLayoutAll.Amount, 0) > COALESCE(MCS_Value.ValueData, 0) 
                                                THEN COALESCE(tmpLayoutAll.Amount, 0)
                                                ELSE COALESCE(MCS_Value.ValueData, 0) END ::TFloat      AS MCSValue
--                                         , (COALESCE(tmpLayoutAll.Amount, 0) + COALESCE(MCS_Value.ValueData, 0))::TFloat      AS MCSValue
                                         , CASE WHEN Price_MCSValueMin.ValueData is not null
                                                THEN CASE WHEN COALESCE (Price_MCSValueMin.ValueData, 0) < 
                                                               CASE WHEN COALESCE(tmpLayoutAll.Amount, 0) > COALESCE(MCS_Value.ValueData, 0) 
                                                                    THEN COALESCE(tmpLayoutAll.Amount, 0)
                                                                    ELSE COALESCE(MCS_Value.ValueData, 0) END 
--                                                               COALESCE (COALESCE(tmpLayoutAll.Amount, 0) + COALESCE(MCS_Value.ValueData, 0), 0) 
                                                          THEN COALESCE(Price_MCSValueMin.ValueData,0) 
                                                          ELSE CASE WHEN COALESCE(tmpLayoutAll.Amount, 0) > COALESCE(MCS_Value.ValueData, 0) 
                                                                    THEN COALESCE(tmpLayoutAll.Amount, 0)
                                                                    ELSE COALESCE(MCS_Value.ValueData, 0) END  END
--                                                          ELSE COALESCE(tmpLayoutAll.Amount, 0) + COALESCE(MCS_Value.ValueData, 0) END
                                                ELSE 0
                                           END ::TFloat AS MCSValue_min
                                         , COALESCE(tmpLayoutAll.Amount, 0) AS Layout
                                         , ObjectLink_Price_Unit.ObjectId
                                    FROM ObjectLink AS ObjectLink_Price_Unit
                                         LEFT JOIN ObjectBoolean AS MCS_isClose
                                                                 ON MCS_isClose.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                                AND MCS_isClose.DescId = zc_ObjectBoolean_Price_MCSIsClose()
                                         LEFT JOIN ObjectLink AS Price_Goods
                                                              ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                             AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                         INNER JOIN Object AS Object_Goods
                                                           ON Object_Goods.Id = Price_Goods.ChildObjectId
                                                          AND Object_Goods.isErased = False
                                         LEFT JOIN ObjectFloat AS Price_Value
                                                               ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                              AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                                         LEFT JOIN ObjectFloat AS MCS_Value
                                                               ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                              AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                                         LEFT JOIN ObjectFloat AS Price_MCSValueMin
                                                               ON Price_MCSValueMin.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                              AND Price_MCSValueMin.DescId = zc_ObjectFloat_Price_MCSValueMin()
                                         LEFT JOIN tmpLayoutAll ON tmpLayoutAll.GoodsId = Price_Goods.ChildObjectId
                                    WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                      AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                                      AND (COALESCE(MCS_isClose.ValueData,False) = False OR COALESCE(tmpLayoutAll.Amount,0) > 0) 
                                   )
             , tmpLeftTheMarket AS (SELECT Object_Goods_Retail.Id                                       AS GoodsId
                                         , tmpPriceAll.UnitId                                           AS UnitId      
                                         , COALESCE (ObjectHistoryFloat_MCSValue.ValueData, 0):: TFloat AS MCSValue
                                         , ROW_NUMBER() OVER (PARTITION BY Object_Goods_Retail.Id ORDER BY ObjectHistory_Price.Id DESC) AS Ord
                                    FROM Object_Goods_Main
                                    
                                         INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = Object_Goods_Main.Id
                                                                       AND Object_Goods_Retail.RetailId = vbObjectId
                                                                       
                                         INNER JOIN tmpPriceAll ON tmpPriceAll.GoodsId = Object_Goods_Retail.Id
                                         
                                         INNER JOIN ObjectHistory AS ObjectHistory_Price
                                                                  ON ObjectHistory_Price.ObjectId = tmpPriceAll.ObjectId
                                                                 AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                                                 AND ObjectHistory_Price.StartDate <= Object_Goods_Main.DateLeftTheMarket - INTERVAL '45 day'
                                                                 AND ObjectHistory_Price.EndDate > Object_Goods_Main.DateLeftTheMarket - INTERVAL '45 day'
                                                                 
                                         INNER JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSValue
                                                                       ON ObjectHistoryFloat_MCSValue.ObjectHistoryId = ObjectHistory_Price.Id
                                                                      AND ObjectHistoryFloat_MCSValue.DescId = zc_ObjectHistoryFloat_Price_MCSValue()
                                    
                                    WHERE Object_Goods_Main.isLeftTheMarket = FALSE
                                      AND Object_Goods_Main.DateAddToOrder = CURRENT_DATE
                                      AND COALESCE (ObjectHistoryFloat_MCSValue.ValueData, 0) >= 3)
                                      
                            SELECT tmpPriceAll.UnitId
                                 , tmpPriceAll.GoodsId
                                 , tmpPriceAll.Price
                                 , CASE WHEN COALESCE (tmpPriceAll.MCSValue, 0) < COALESCE (tmpLeftTheMarket.MCSValue, 0) THEN tmpLeftTheMarket.MCSValue ELSE tmpPriceAll.MCSValue END MCSValue
                                 , tmpPriceAll.MCSValue_min
                                 , tmpPriceAll.Layout
                            FROM tmpPriceAll
                            
                                 LEFT JOIN tmpLeftTheMarket ON tmpLeftTheMarket.GoodsId = tmpPriceAll.GoodsId
                                                           AND tmpLeftTheMarket.UnitId = tmpPriceAll.UnitId
                                                           AND tmpLeftTheMarket.Ord = 1
                                                           
                            WHERE CASE WHEN COALESCE (tmpPriceAll.MCSValue, 0) < COALESCE (tmpLeftTheMarket.MCSValue, 0) THEN tmpLeftTheMarket.MCSValue ELSE tmpPriceAll.MCSValue END > 0 
                               OR COALESCE(tmpPriceAll.Layout, 0) > 0
                            UNION ALL
                            SELECT inUnitId   AS UnitId
                                 , tmpLayoutAll.GoodsId
                                 , 0::TFloat               AS Price
                                 , tmpLayoutAll.Amount     AS MCSValue
                                 , 0::TFloat               AS MCSValue_min
                                 , tmpLayoutAll.Amount     AS Layout
                            FROM tmpLayoutAll
                            
                                 LEFT JOIN tmpPriceAll ON tmpPriceAll.GoodsId = tmpLayoutAll.GoodsId
                            
                            WHERE COALESCE(tmpLayoutAll.Amount, 0) > 0
                              AND COALESCE(tmpPriceAll.GoodsId, 0) = 0;
                           
                           
        ANALYSE tmpPrice;

    -- raise notice 'Value 22: %', CLOCK_TIMESTAMP();


              -- ������ �� ������. �������
       CREATE TEMP TABLE tmpGoodsCategory ON COMMIT DROP AS
                                   SELECT ObjectLink_Child_retail.ChildObjectId AS GoodsId
                                        , ObjectFloat_Value.ValueData           AS Value
                                   FROM Object AS Object_GoodsCategory
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Unit
                                                             ON ObjectLink_GoodsCategory_Unit.ObjectId = Object_GoodsCategory.Id
                                                            AND ObjectLink_GoodsCategory_Unit.DescId = zc_ObjectLink_GoodsCategory_Unit()
                                                            AND ObjectLink_GoodsCategory_Unit.ChildObjectId = inUnitId
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Goods
                                                             ON ObjectLink_GoodsCategory_Goods.ObjectId = Object_GoodsCategory.Id
                                                            AND ObjectLink_GoodsCategory_Goods.DescId = zc_ObjectLink_GoodsCategory_Goods()
                                       INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                              ON ObjectFloat_Value.ObjectId = Object_GoodsCategory.Id
                                                             AND ObjectFloat_Value.DescId = zc_ObjectFloat_GoodsCategory_Value()
                                                             AND COALESCE (ObjectFloat_Value.ValueData,0) <> 0
                                       -- ������� �� ����� ����
                                       INNER JOIN ObjectLink AS ObjectLink_Main_retail
                                                             ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_GoodsCategory_Goods.ChildObjectId
                                                            AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                       INNER JOIN ObjectLink AS ObjectLink_Child_retail
                                                             ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                            AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                       INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                             ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                            AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                            AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                                   WHERE Object_GoodsCategory.DescId = zc_Object_GoodsCategory()
                                     AND Object_GoodsCategory.isErased = FALSE;
                                   

        ANALYSE tmpGoodsCategory;

    -- raise notice 'Value 23: %', CLOCK_TIMESTAMP();

             -- ������ ������������� 224
       CREATE TEMP TABLE tmpGoods_224 ON COMMIT DROP AS
                               SELECT tmpPrice.GoodsId
                               FROM tmpPrice
                                -- �������� GoodsMainId
                                LEFT JOIN  ObjectLink AS ObjectLink_Child
                                                      ON ObjectLink_Child.ChildObjectId = tmpPrice.GoodsId
                                                     AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                LEFT JOIN  ObjectLink AS ObjectLink_Main
                                                      ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                     AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

                                INNER JOIN ObjectBoolean AS ObjectBoolean_Resolution_224
                                                         ON ObjectBoolean_Resolution_224.ObjectId = ObjectLink_Main.ChildObjectId
                                                        AND ObjectBoolean_Resolution_224.DescId = zc_ObjectBoolean_Goods_Resolution_224()
                                                        AND COALESCE (ObjectBoolean_Resolution_224.ValueData, FALSE) = TRUE;
                              

        ANALYSE tmpGoods_224;

    -- raise notice 'Value 24: %', CLOCK_TIMESTAMP();


    -- ������ �����������
       CREATE TEMP TABLE tmpSupplierFailures ON COMMIT DROP AS
       WITH tmpOrderExternal AS (
                             SELECT min(Movement_OrderExternal.OperDate) AS DateStart
                                  , max(Movement_OrderExternal.OperDate) AS DateEnd
                             FROM Movement AS Movement_OrderExternal
                                  INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                             ON MovementBoolean_Deferred.MovementId = Movement_OrderExternal.Id
                                                            AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                                            AND MovementBoolean_Deferred.ValueData = TRUE
                                  INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                ON MovementLinkObject_Unit.MovementId = Movement_OrderExternal.Id
                                                               AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_To()
                                                               AND MovementLinkObject_Unit.ObjectId = inUnitId
                                  
                             WHERE Movement_OrderExternal.DescId = zc_Movement_OrderExternal()
                               AND Movement_OrderExternal.StatusId = zc_Enum_Status_Complete())
                                      
                             SELECT DISTINCT 
                                    SupplierFailures.OperDate
                                  , SupplierFailures.DateFinal
                                  , SupplierFailures.GoodsId
                                  , SupplierFailures.JuridicalId
                                  , SupplierFailures.ContractId
                             FROM lpSelect_PriceList_SupplierFailuresAll_Date(inUnitId
                                                                             , COALESCE((SELECT tmpOrderExternal.DateStart FROM tmpOrderExternal), CURRENT_DATE)
                                                                             , COALESCE((SELECT tmpOrderExternal.DateEnd FROM tmpOrderExternal), CURRENT_DATE)
                                                                             , vbUserId) AS SupplierFailures;

        ANALYSE tmpSupplierFailures;

    -- raise notice 'Value 25: % %', CLOCK_TIMESTAMP(), (SELECT Count(*) FROM tmpSupplierFailures);

       CREATE TEMP TABLE tmpMI_OrderExternal ON COMMIT DROP AS
                             SELECT MI_OrderExternal.ObjectId                AS GoodsId
                                  , SUM (MI_OrderExternal.Amount) ::TFloat   AS Amount
                             FROM Movement AS Movement_OrderExternal
                                  INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                             ON MovementBoolean_Deferred.MovementId = Movement_OrderExternal.Id
                                                            AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                                            AND MovementBoolean_Deferred.ValueData = TRUE
                                  INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                ON MovementLinkObject_Unit.MovementId = Movement_OrderExternal.Id
                                                               AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_To()
                                                               AND MovementLinkObject_Unit.ObjectId = inUnitId
                                  INNER JOIN MovementItem AS MI_OrderExternal
                                                          ON MI_OrderExternal.MovementId = Movement_OrderExternal.Id
                                                         AND MI_OrderExternal.DescId = zc_MI_Master()
                                                         AND MI_OrderExternal.isErased = FALSE
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = Movement_OrderExternal.Id
                                                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                               ON MovementLinkObject_Contract.MovementId = Movement_OrderExternal.Id
                                                              AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                   ON MILinkObject_Goods.MovementItemId = MI_OrderExternal.Id
                                                                  AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                  LEFT JOIN tmpSupplierFailures ON tmpSupplierFailures.OperDate <= Movement_OrderExternal.OperDate
                                                               AND tmpSupplierFailures.DateFinal > Movement_OrderExternal.OperDate
                                                               AND tmpSupplierFailures.GoodsId = MILinkObject_Goods.ObjectId
                                                               AND tmpSupplierFailures.JuridicalId = MovementLinkObject_From.ObjectId
                                                               AND tmpSupplierFailures.ContractId = MovementLinkObject_Contract.ObjectId
                                  
                             WHERE Movement_OrderExternal.DescId = zc_Movement_OrderExternal()
                               AND Movement_OrderExternal.StatusId = zc_Enum_Status_Complete()
                               AND COALESCE (tmpSupplierFailures.GoodsId, 0) = 0
                             GROUP BY MI_OrderExternal.ObjectId
                             HAVING SUM (MI_OrderExternal.Amount) <> 0;
                             
        ANALYSE tmpMI_OrderExternal;

    -- raise notice 'Value 26: %', CLOCK_TIMESTAMP();
                             
        -- �������� �������� ������� ����� �������� � ���
        PERFORM lpInsertUpdate_MovementItemFloat(inDescId         := zc_MIFloat_AmountSecond()
                                                ,inMovementItemId := lpInsertUpdate_MovementItem_OrderInternal(ioId         := tmp.MovementItemId
                                                                                                              ,inMovementId := vbMovementId
                                                                                                              ,inGoodsId    := tmp.GoodsId
                                                                                                              ,inAmount     := tmp.Amount
                                                                                                              ,inAmountManual:= NULL
                                                                                                              ,inPrice      := tmp.Price
                                                                                                              ,inUserId     := vbUserId)
                                                ,inValueData       := tmp.ValueData
                                                )
                                                
        FROM ( WITH    
                          
            -- ��������� ��� �� �������� �� ������. �������, ���� � ������. ������� �������� ������
              Object_Price AS (SELECT COALESCE (tmpPrice.UnitId, inUnitId) AS UnitId
                                         , COALESCE (tmpPrice.GoodsId, tmpGoodsCategory.GoodsId) AS GoodsId
                                         , COALESCE (tmpPrice.Price, 0)                :: TFloat AS Price
                                         --, COALESCE (tmpPrice.MCSValue, 0)  ::TFloat AS MCSValue
                                         , CASE WHEN COALESCE (tmpGoodsCategory.Value, 0) <= COALESCE (tmpPrice.MCSValue, 0)
                                                THEN COALESCE (tmpPrice.MCSValue,0)
                                                ELSE tmpGoodsCategory.Value
                                           END ::TFloat AS MCSValue

                                         , COALESCE (tmpPrice.MCSValue_min, 0)         :: TFloat AS MCSValue_min
                                         , COALESCE(tmpPrice.Layout, 0)                :: TFloat AS Layout
                                    FROM tmpPrice
                                         FULL JOIN tmpGoodsCategory ON tmpGoodsCategory.GoodsId = tmpPrice.GoodsId
                                    WHERE COALESCE (tmpGoodsCategory.Value, 0) <> 0
                                       OR COALESCE (tmpPrice.MCSValue, 0) <> 0
                               )

            , MovementItemSaved AS (SELECT T1.Id,
                                           T1.Amount,
                                           T1.ObjectId
                                    FROM (SELECT MovementItem.Id,
                                                 MovementItem.Amount,
                                                 MovementItem.ObjectId,
                                                 ROW_NUMBER() OVER(PARTITION BY MovementItem.ObjectId Order By MovementItem.Id) as Ord
                                          FROM MovementItem
                                          WHERE MovementItem.MovementId = vbMovementId
                                            AND MovementItem.isErased = FALSE
                                         ) AS T1
                                    WHERE T1.Ord = 1
                                   )
              , Income AS (SELECT MovementItem_Income.ObjectId    as GoodsId
                                , SUM (MovementItem_Income.Amount) as Amount_Income
                           FROM _tmpMovement AS Movement_Income
                                INNER JOIN MovementItem AS MovementItem_Income
                                                        ON Movement_Income.Id = MovementItem_Income.MovementId
                                                       AND MovementItem_Income.DescId = zc_MI_Master()
                                                       AND MovementItem_Income.isErased = FALSE
                                INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                              ON Movement_Income.Id = MovementLinkObject_To.MovementId
                                                             AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                             AND MovementLinkObject_To.ObjectId = inUnitId
                                INNER JOIN MovementDate AS MovementDate_Branch
                                                        ON MovementDate_Branch.MovementId = Movement_Income.Id
                                                       AND MovementDate_Branch.DescId = zc_MovementDate_Branch()
                                                       -- AND MovementDate_Branch.ValueData >= CURRENT_DATE
                                                       AND MovementDate_Branch.ValueData BETWEEN CURRENT_DATE - INTERVAL '15 DAY' AND CURRENT_DATE + INTERVAL '7 DAY'
                        WHERE Movement_Income.DescId = zc_Movement_Income()
                          AND Movement_Income.StatusId = zc_Enum_Status_UnComplete()
                        GROUP BY MovementItem_Income.ObjectId
                        HAVING SUM (MovementItem_Income.Amount) > 0
                     )
            , tmpMI_Send AS (SELECT MovementItem.ObjectId     AS GoodsId
                                  , SUM (MovementItem.Amount) AS Amount
                             FROM _tmpMovement AS Movement
                                    INNER JOIN MovementItem AS MovementItem
                                                            ON MovementItem.MovementId = Movement.Id
                                                           AND MovementItem.DescId     = zc_MI_Master()
                                                           AND MovementItem.isErased   = FALSE
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                                 AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                                 AND MovementLinkObject_To.ObjectId   = inUnitId
                                    -- ����������� - ����� ����� ��� �����������, �� ������ ����
                                    /*INNER JOIN MovementBoolean AS MovementBoolean_isAuto
                                                               ON MovementBoolean_isAuto.MovementId = Movement.Id
                                                              AND MovementBoolean_isAuto.DescId     = zc_MovementBoolean_isAuto()
                                                              AND MovementBoolean_isAuto.ValueData  = TRUE*/
                                    /*LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                                              ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                             AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()*/
                             WHERE Movement.DescId = zc_Movement_Send()
                                  AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                  --AND COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = FALSE
                                  -- AND Movement.OperDate >= CURRENT_DATE - INTERVAL '14 DAY' AND Movement.OperDate < CURRENT_DATE + INTERVAL '14 DAY'
                                  AND Movement.OperDate >= CURRENT_DATE - INTERVAL '30 DAY' AND Movement.OperDate < CURRENT_DATE + INTERVAL '30 DAY'
                             GROUP BY MovementItem.ObjectId
                            )


   -- �������� ���������� ���� (��� � ����� ������� VIP)
   , tmpMovementChek AS (SELECT Movement.Id
                         FROM MovementBoolean AS MovementBoolean_Deferred
                              INNER JOIN _tmpMovement AS Movement 
						                              ON Movement.Id     = MovementBoolean_Deferred.MovementId
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
                              INNER JOIN _tmpMovement AS Movement 
						                              ON Movement.Id     = MovementString_CommentError.MovementId
                                                 AND Movement.DescId = zc_Movement_Check()
                                                 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId = inUnitId
                         WHERE MovementString_CommentError.DescId = zc_MovementString_CommentError()
                           AND MovementString_CommentError.ValueData <> ''
                         )
   , tmpReserve AS (SELECT MovementItem.ObjectId             AS GoodsId
                         , SUM (MovementItem.Amount)::TFloat AS Amount
                    FROM tmpMovementChek
                         INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovementChek.Id
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = FALSE
                         LEFT JOIN MovementBoolean AS MovementBoolean_NotMCS
                                                   ON MovementBoolean_NotMCS.MovementId = tmpMovementChek.Id
                                                  AND MovementBoolean_NotMCS.DescId     = zc_MovementBoolean_NotMCS()
                    WHERE COALESCE (MovementBoolean_NotMCS.ValueData, False) = False
                    GROUP BY MovementItem.ObjectId
                    )
   , tmpRemains AS (SELECT Object_Price.UnitId
                         , Object_Price.GoodsId
                         , SUM (COALESCE (Container.Amount, 0)) AS Amount
                    FROM Object_Price
                         LEFT JOIN Container ON Container.WhereObjectId = Object_Price.UnitId
                                            AND Container.ObjectId = Object_Price.GoodsId
                                            AND Container.DescId = zc_Container_Count()
                                            AND Container.Amount <> 0
                    GROUP BY Object_Price.UnitId
                           , Object_Price.GoodsId
                    )
              -- ���������
              -- ��� ������������ ���-�� ���������� �� ������� ������� ������ ������ �� ���������� ����� - ��������� �������� ������� �� �����
              SELECT COALESCE(MovementItemSaved.Id,0) AS MovementItemId
                   , Object_Price.GoodsId
                   , COALESCE (MovementItemSaved.Amount, 0) AS Amount
                   , Object_Price.Price AS Price
                   , CASE -- ���� ���_��� = 0 ��� ��� <= ���_���
                          WHEN (COALESCE (Object_Price.MCSValue_min, 0) = 0 OR (COALESCE (Container.Amount, 0) <= COALESCE (Object_Price.MCSValue_min, 0)))
                           -- ���� ������ ��� ����� ��� �� 0.5
                           AND 0.5 <= ROUND (Object_Price.MCSValue - (COALESCE (Container.Amount, 0) - COALESCE (tmpReserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (Income.Amount_Income, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                               THEN CASE -- ��� ������ ���
                                         WHEN Object_Price.MCSValue >= 0.1 AND Object_Price.MCSValue < 10
                                         -- � 1 >= ��� - ������� - "��������" - "�������" - "������" - "������"
                                          AND 1 >= ROUND (Object_Price.MCSValue - (COALESCE (Container.Amount, 0) - COALESCE (tmpReserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (Income.Amount_Income, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                                              THEN -- ��������� �����
                                                   CEIL (Object_Price.MCSValue - (COALESCE (Container.Amount, 0) - COALESCE (tmpReserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (Income.Amount_Income, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))

                                         -- ��� ������ ���
                                         WHEN Object_Price.MCSValue >= 10
                                         -- � 1 >= ��� - ������� - "��������" - "�������" - "������" - "������"
                                          AND 1 >= CEIL (Object_Price.MCSValue - (COALESCE (Container.Amount, 0) - COALESCE (tmpReserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (Income.Amount_Income, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                                              THEN -- ���������
                                                   ROUND  (Object_Price.MCSValue - (COALESCE (Container.Amount, 0) - COALESCE (tmpReserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (Income.Amount_Income, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))

                                         ELSE -- ��������� �����
                                              FLOOR (Object_Price.MCSValue - (COALESCE (Container.Amount, 0) - COALESCE (tmpReserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (Income.Amount_Income, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                                    END
                          ELSE 0
                     END                          :: TFloat AS ValueData
              FROM Object_Price
            -- LEFT OUTER JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                -- ON ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                               -- AND ContainerLinkObject_Unit.ObjectId = Object_Price.UnitId
                   LEFT JOIN tmpRemains AS Container
                                        ON Container.UnitId  = Object_Price.UnitId
                                       AND Container.GoodsId = Object_Price.GoodsId

                   LEFT OUTER JOIN MovementItemSaved ON MovementItemSaved.ObjectId = Object_Price.GoodsId

                   INNER JOIN Object_Goods_View ON Object_Goods_View.Id      = Object_Price.GoodsId
                                               AND (Object_Goods_View.IsClose = FALSE OR Object_Price.Layout > 0)

                   LEFT OUTER JOIN Income ON Income.GoodsId = Object_Price.GoodsId

                   LEFT OUTER JOIN tmpMI_Send ON tmpMI_Send.GoodsId = Object_Price.GoodsId

                   LEFT OUTER JOIN tmpMI_OrderExternal ON tmpMI_OrderExternal.GoodsId = Object_Price.GoodsId

                   -- ���-�� ���������� ����
                   LEFT JOIN tmpReserve ON tmpReserve.GoodsId = Object_Goods_View.Id

              GROUP BY Object_Price.UnitId,
                       Object_Price.GoodsId,
                       Object_Price.MCSValue,
                       COALESCE (Object_Price.MCSValue_min, 0),
                       Object_Price.Price,
                       MovementItemSaved.Id,
                       MovementItemSaved.Amount,
                       Object_Price.MCSValue,
                       Object_Goods_View.MinimumLot,
                       tmpMI_Send.Amount,
                       Income.Amount_Income,
                       tmpMI_OrderExternal.Amount,
                       COALESCE (tmpReserve.Amount, 0),
                       COALESCE (Container.Amount, 0)

              HAVING CASE WHEN (COALESCE (Object_Price.MCSValue_min, 0) = 0 OR (COALESCE (Container.Amount, 0) <= COALESCE (Object_Price.MCSValue_min, 0)))
                              AND 0.5 <= ROUND (Object_Price.MCSValue - (COALESCE (Container.Amount, 0) - COALESCE (tmpReserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (Income.Amount_Income, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                          THEN CASE WHEN Object_Price.MCSValue >= 0.1 AND Object_Price.MCSValue < 10 AND (1 >= ROUND (Object_Price.MCSValue - (COALESCE (Container.Amount, 0) - COALESCE (tmpReserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (Income.Amount_Income, 0) - COALESCE (tmpMI_OrderExternal.Amount,0)))
                                         THEN CEIL (Object_Price.MCSValue - (COALESCE (Container.Amount, 0) - COALESCE (tmpReserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (Income.Amount_Income, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                                    WHEN Object_Price.MCSValue >= 10 AND 1 >= CEIL (Object_Price.MCSValue - (COALESCE (Container.Amount, 0) - COALESCE (tmpReserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (Income.Amount_Income, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                                         THEN ROUND  (Object_Price.MCSValue - (COALESCE (Container.Amount, 0) - COALESCE (tmpReserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (Income.Amount_Income, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                                    ELSE FLOOR (Object_Price.MCSValue - (COALESCE (Container.Amount, 0) - COALESCE (tmpReserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (Income.Amount_Income, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                               END
                          ELSE 0
                     END > 0
       ) AS tmp;

    -- raise notice 'Value 3: %', CLOCK_TIMESTAMP();

       -- RAISE EXCEPTION 'ok' ;

       -- ������������� ������ ���������� ��� ����� � ������������ - ����������, ������������� �������
       PERFORM
            lpInsertUpdate_MovementItemFloat(inDescId         := zc_MIFloat_AmountManual()
                                            ,inMovementItemId := MovementItemSaved.Id
                                            ,inValueData      := -- ��������� ����� AllLot
                                                                 CEIL ((-- ���������
                                                                        MovementItemSaved.Amount
                                                                        -- ���������� ��������������
                                                                      + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                                                        -- ���-�� �������
                                                                      + COALESCE (MIFloat_ListDiff.ValueData, 0)
                                                                        -- ���-�� ���
                                                                      + COALESCE (MIFloat_AmountSUA.ValueData, 0)
                                                                       ) / COALESCE (CASE WHEN Object_Goods.MinimumLot = 0 THEN 1 ELSE Object_Goods.MinimumLot END, 1)
                                                                      )
                                                               * COALESCE (CASE WHEN Object_Goods.MinimumLot = 0 THEN 1 ELSE Object_Goods.MinimumLot END, 1)
                                            )
        FROM MovementItem AS MovementItemSaved
            INNER JOIN MovementItemFloat AS MIFloat_AmountSecond
                                         ON MIFloat_AmountSecond.MovementItemId = MovementItemSaved.Id
                                        AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
            LEFT JOIN MovementItemFloat AS MIFloat_ListDiff
                                        ON MIFloat_ListDiff.MovementItemId = MovementItemSaved.Id
                                       AND MIFloat_ListDiff.DescId = zc_MIFloat_ListDiff()
            LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountSUA
                                              ON MIFloat_AmountSUA.MovementItemId = MovementItemSaved.Id
                                             AND MIFloat_AmountSUA.DescId         = zc_MIFloat_AmountSUA()

            INNER JOIN Object_Goods_View AS Object_Goods
                                         ON Object_Goods.Id = MovementItemSaved.ObjectId
        WHERE MovementItemSaved.MovementId = vbMovementId;

    -- raise notice 'Value 4: %', CLOCK_TIMESTAMP();

      -- �������� ��� ����� SUN
      IF EXISTS (SELECT 1 FROM ObjectBoolean AS ObjectBoolean_SUN WHERE ObjectBoolean_SUN.ObjectId = inUnitId AND ObjectBoolean_SUN.DescId = zc_ObjectBoolean_Unit_SUN())
      THEN
          PERFORM gpUpdate_MI_OrderInternal_AmountReal_RemainsSun (inMovementId:= vbMovementId
                                                                 , inUnitId    := inUnitId
                                                                 , inSession   := inSession
                                                                  );
      END IF;

    -- raise notice 'Value 5: %', CLOCK_TIMESTAMP();

       /*30.09 -
         � ������� ����� � ������., ��� �������  � ������� ���� �������� ����� 1 ����
        (��� � ���  �������� ������� �������) - ������������� ��������  ���-�� ��� ������.
        �� ��� ������� �� ������� �� ������, ����� ���� ����� ��� �������� � �����, �� � ���� ���� � �� ��� �� ����������. **����
        ��� ����� ����� �������� ����� ��������
       */

       -- ������� "�������" ������, ������� �� ������ �������� ����� ����
       CREATE TEMP TABLE _tmpMI_OrderInternal_Master (MovementItemId Integer, GoodsId Integer, Amount TFloat, Layout TFloat,  Price TFloat, MCS TFloat, CalcAmountAll TFloat, PartionGoodsDate TDateTime) ON COMMIT DROP;
       INSERT INTO _tmpMI_OrderInternal_Master (MovementItemId, GoodsId, Amount, Price, MCS, Layout, CalcAmountAll, PartionGoodsDate)
       SELECT tmp.Id, tmp.GoodsId, tmp.Amount, tmp.Price, tmp.MCS, tmp.Layout, tmp.CalcAmountAll, tmp.PartionGoodsDate
       FROM gpSelect_MovementItem_OrderInternal_Master (vbMovementId, FALSE, FALSE, FALSE, inSession) AS tmp
       ;
	   
	   ANALYSE _tmpMI_OrderInternal_Master;

    -- raise notice 'Value 6: %', CLOCK_TIMESTAMP();

       --������������� AmountManual, ���� ������ ��� �� ����� ���
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountManual()
                                               , tmp.MovementItemId
                                               -- ��������� ����� AllLot
                                               , CEIL (tmp.MCS / COALESCE (CASE WHEN Object_Goods.MinimumLot = 0 THEN 1 ELSE Object_Goods.MinimumLot END, 1)                                                                      )
                                                               * COALESCE (CASE WHEN Object_Goods.MinimumLot = 0 THEN 1 ELSE Object_Goods.MinimumLot END, 1) :: TFloat
                                                )
       FROM _tmpMI_OrderInternal_Master AS tmp
            INNER JOIN Object_Goods_View AS Object_Goods
                                         ON Object_Goods.Id = tmp.GoodsId
       WHERE tmp.CalcAmountAll > tmp.MCS AND COALESCE (tmp.MCS,0) <> 0;      

       -- �������� Amount, AmountManual, AmountSecond ��� ������� �� ������ �������� ����� ����
       PERFORM lpInsertUpdate_MovementItem (tmp.MovementItemId, zc_MI_Master(), tmp.GoodsId, vbMovementId, 0 :: TFloat, NULL)
             , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountManual(), tmp.MovementItemId, 0 :: TFloat)
             , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecond(), tmp.MovementItemId, 0 :: TFloat)
       FROM _tmpMI_OrderInternal_Master AS tmp
       WHERE tmp.PartionGoodsDate < CASE WHEN COALESCE (tmp.Layout, 0) > 0 THEN vbDate9 ELSE vbDate180 END;
    END IF;

    -- raise notice 'Value 7: %', CLOCK_TIMESTAMP();
    --
    IF EXISTS(  SELECT Movement.Id
                FROM Movement
                    JOIN MovementLinkObject AS MovementLinkObject_Unit
                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                WHERE
                    Movement.StatusId = zc_Enum_Status_UnComplete()
                    AND
                    Movement.DescId = zc_Movement_OrderInternal()
                    AND
                    Movement.OperDate = vbOperDate
                    AND
                    MovementLinkObject_Unit.ObjectId = inUnitId
             )
    THEN
        outOrderExists := TRUE;
    ELSE
        outOrderExists := FALSE;
    END IF;
 
    -- !!!�������� ��� �����!!!
    IF inSession = zfCalc_UserAdmin()
    THEN
       RAISE EXCEPTION '���� ������ ������� ��� <%> <%> <%>', inSession, outOrderExists, (SELECT COUNT(*) FROM MovementItem WHERE MovementItem.MovementId = vbMovementId);
    END IF;
    
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.   ������ �.�.
 22.03.21                                                                                      *
 03.12.18         *
 02.11.18         *
 12.06.17         *
 27.12.16         * add tmpMI_OrderExternal.Amount
 15.03.16         * add Object_Goods_View.IsClose = FALSE
 02.02.16                                        * add MovementItem_Income.isErased = FALSE
 29.08.15                                                                        * ObjectPrice.MCSIsClose = False
 31.07.15                                                                        *
*/

-- ����
-- 
SELECT * FROM gpInsertUpdate_MovementItem_OrderInternalMCSLayout (inUnitId := 377605, inNeedCreate:= True, inSession:= zfCalc_UserAdmin())	