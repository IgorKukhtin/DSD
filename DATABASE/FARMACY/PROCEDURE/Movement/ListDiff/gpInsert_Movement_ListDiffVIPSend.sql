-- Function: gpInsert_Movement_ListDiffVIPSend()

DROP FUNCTION IF EXISTS gpInsert_Movement_ListDiffVIPSend (Text, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_ListDiffVIPSend(
    IN inJSON                Text      , -- json 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbGoodsName TVarChar;
    DECLARE vbUnitName TVarChar;
    DECLARE vbAmountSend TFloat;
    DECLARE vbRemains TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);
  
    --DROP TABLE IF EXISTS tblListDiffJSON;
    
    -- из JSON в таблицу
    CREATE TEMP TABLE tblListDiffJSON
    (
     Id			           Integer   ,
     MovementId			   Integer   ,
     UnitId                Integer   ,
     UnitSendId            Integer   ,
     AmountSend            TFloat    ,


     isUrgently            Boolean   ,
     isOrder               Boolean
    ) ON COMMIT DROP;

    INSERT INTO tblListDiffJSON
    SELECT *
    FROM json_populate_recordset(null::tblListDiffJSON, replace(replace(replace(inJSON, '&quot;', '\"'), CHR(9),''), CHR(10),'')::json);
    
    -- Контроль остатка
    WITH tmpListDiffVIPSend AS (SELECT tblListDiffJSON.UnitSendId      AS UnitId 
                                     , MovementItem.ObjectId           AS GoodsId
                                     , SUM(tblListDiffJSON.AmountSend) AS AmountSend
                                FROM tblListDiffJSON
                                     
                                     INNER JOIN MovementItem ON MovementItem.Id = tblListDiffJSON.Id
                                     
                                WHERE COALESCE(tblListDiffJSON.UnitSendId, 0) <> 0
                                  AND tblListDiffJSON.AmountSend > 0
                                GROUP BY tblListDiffJSON.UnitSendId
                                       , MovementItem.ObjectId ),
         tmpContainer AS (SELECT tmpListDiffVIPSend.GoodsId
                               , tmpListDiffVIPSend.UnitId
                               , SUM(Container.Amount)                       AS Amount
                          FROM tmpListDiffVIPSend
                          
                               INNER JOIN Container ON Container.DescId = zc_Container_Count()
                                                   AND Container.Amount <> 0
                                                   AND Container.ObjectId = tmpListDiffVIPSend.GoodsId
                                                   AND Container.WhereObjectId = tmpListDiffVIPSend.UnitId
                          GROUP BY tmpListDiffVIPSend.GoodsId
                                 , tmpListDiffVIPSend.UnitId
                          HAVING SUM(Container.Amount) > 0
                         ),
         tmpLayoutMovement AS (SELECT Movement.Id                                             AS Id
                                    , COALESCE(MovementBoolean_PharmacyItem.ValueData, FALSE) AS isPharmacyItem
                               FROM Movement
                                    LEFT JOIN MovementBoolean AS MovementBoolean_PharmacyItem
                                                              ON MovementBoolean_PharmacyItem.MovementId = Movement.Id
                                                             AND MovementBoolean_PharmacyItem.DescId = zc_MovementBoolean_PharmacyItem()
                               WHERE Movement.DescId = zc_Movement_Layout()
                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                              ),
         tmpLayout AS (SELECT Movement.ID                        AS Id
                            , MovementItem.ObjectId              AS GoodsId
                            , MovementItem.Amount                AS Amount
                            , Movement.isPharmacyItem            AS isPharmacyItem
                       FROM tmpLayoutMovement AS Movement
                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                   AND MovementItem.DescId = zc_MI_Master()
                                                   AND MovementItem.isErased = FALSE
                                                   AND MovementItem.Amount > 0
                       WHERE MovementItem.ObjectId IN (SELECT DISTINCT tmpListDiffVIPSend.GoodsId  FROM tmpListDiffVIPSend)
                      ),
         tmpLayoutUnit AS (SELECT Movement.ID                        AS Id
                                , MovementItem.ObjectId              AS UnitId
                           FROM tmpLayout AS Movement
                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId = zc_MI_Child()
                                                       AND MovementItem.isErased = FALSE
                                                       AND MovementItem.Amount > 0
                          ),
          tmpLayoutUnitCount AS (SELECT tmpLayoutUnit.ID                  AS Id
                                      , count(*)                          AS CountUnit
                                 FROM tmpLayoutUnit
                                 GROUP BY tmpLayoutUnit.ID
                                 ),
          tmpLayoutAll AS (SELECT tmpLayout.GoodsId                  AS GoodsId
                                , tmpUnit.Id                         AS UnitId
                                , tmpLayout.Amount                   AS Amount
                           FROM tmpLayout
                           
                                INNER JOIN (SELECT DISTINCT tmpListDiffVIPSend.UnitId AS ID FROM tmpListDiffVIPSend) AS tmpUnit ON 1 = 1
                                
                                LEFT JOIN ObjectBoolean AS Unit_PharmacyItem
                                                        ON Unit_PharmacyItem.ObjectId  = tmpUnit.Id
                                                       AND Unit_PharmacyItem.DescId    = zc_ObjectBoolean_Unit_PharmacyItem()
                                 
                                LEFT JOIN tmpLayoutUnit ON tmpLayoutUnit.Id     = tmpLayout.Id
                                                       AND tmpLayoutUnit.UnitId = tmpUnit.Id

                                LEFT JOIN tmpLayoutUnitCount ON tmpLayoutUnitCount.Id     = tmpLayout.Id
                                 
                           WHERE (tmpLayoutUnit.UnitId = tmpUnit.Id OR COALESCE (tmpLayoutUnitCount.CountUnit, 0) > 0)
                             AND (COALESCE (Unit_PharmacyItem.ValueData, False) = False OR tmpLayout.isPharmacyItem = True)
                           )
        -- Отложенные перемещения
       , tmpMovementID AS (SELECT
                                Movement.Id
                              , Movement.DescId
                         FROM Movement
                         WHERE Movement.DescId IN (zc_Movement_Send(), zc_Movement_Check())
                          AND Movement.StatusId = zc_Enum_Status_UnComplete()
                          AND Movement.OperDate >= CURRENT_DATE - INTERVAL '1 MONTH'
                       )
       , tmpMovementSend AS (SELECT
                                  Movement.Id
                                , MovementLinkObject_From.ObjectId AS UnitId
                           FROM tmpMovementID AS Movement

                                INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                              ON MovementLinkObject_From.MovementId = Movement.Id
                                                             AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                                LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                                           ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                          AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

                           WHERE Movement.DescId = zc_Movement_Send()
                             AND COALESCE(MovementBoolean_Deferred.ValueData, FALSE) = FALSE

                           )
       , tmpSend AS (SELECT
                                  Movement.UnitId
                                , MovementItem.ObjectId    AS GoodsId
                                , SUM(MovementItem.Amount) AS Amount
                           FROM tmpMovementSend AS Movement

                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId = zc_MI_Master()
                                                       AND MovementItem.isErased = FALSE

                           GROUP BY Movement.UnitId
                                  , MovementItem.ObjectId
                            )
       -- Отложенные чеки
     , tmpMovementCheck AS (SELECT Movement.Id
                            FROM tmpMovementID AS Movement
                            WHERE Movement.DescId = zc_Movement_Check())
     , tmpMovReserveAll AS (
                           SELECT Movement.Id
                           FROM MovementBoolean AS MovementBoolean_Deferred
                                INNER JOIN tmpMovementCheck AS Movement ON Movement.Id     = MovementBoolean_Deferred.MovementId
                           WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                             AND MovementBoolean_Deferred.ValueData = TRUE
                           UNION ALL
                           SELECT Movement.Id
                           FROM MovementString AS MovementString_CommentError
                                INNER JOIN tmpMovementCheck AS Movement ON Movement.Id     = MovementString_CommentError.MovementId
                           WHERE MovementString_CommentError.DescId = zc_MovementString_CommentError()
                             AND MovementString_CommentError.ValueData <> ''
                           )
     , tmpMovReserveId AS (SELECT DISTINCT Movement.Id
                               ,  MovementLinkObject_Unit.ObjectId AS UnitId
                           FROM tmpMovReserveAll AS Movement
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                               ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                              AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                           )
     , tmpReserve AS (SELECT Movement.UnitId
                           , MovementItem.ObjectId     AS GoodsId
                           , SUM(MovementItem.Amount)  AS Amount
                      FROM tmpMovReserveId AS Movement

                           INNER JOIN MovementItem AS MovementItem
                                                   ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.isErased   = FALSE

                      GROUP BY Movement.UnitId
                             , MovementItem.ObjectId
                      )
     , tmpObject_Price AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                         AND ObjectFloat_Goods_Price.ValueData > 0
                                        THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                        ELSE ROUND (Price_Value.ValueData, 2)
                                   END :: TFloat                           AS Price
                                 , MCS_Value.ValueData                     AS MCSValue
                                 , Price_Goods.ChildObjectId               AS GoodsId
                                 , ObjectLink_Price_Unit.ChildObjectId     AS UnitId
                            FROM tmpListDiffVIPSend
                            
                               INNER JOIN ObjectLink AS Price_Goods 
                                                     ON Price_Goods.DescId        = zc_ObjectLink_Price_Goods()
                                                    AND Price_Goods.ChildObjectId = tmpListDiffVIPSend.GoodsId
                                                              
                               INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                                     ON ObjectLink_Price_Unit.ObjectId = Price_Goods.ObjectId
                                                    AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                                    AND ObjectLink_Price_Unit.ChildObjectId = tmpListDiffVIPSend.UnitId
                                                   
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
                            )                          
                                     
    SELECT Object_Goods_Main.Name
         , Object_Unit.ValueData
         , tmpListDiffVIPSend.AmountSend
         , FLOOR(Container.Amount - 
                 COALESCE (tmpObject_Price.MCSValue, 0) - 
                 COALESCE (tmpLayoutAll.Amount, 0) - 
                 COALESCE (tmpReserve.Amount, 0) - 
                 COALESCE (tmpSend.Amount, 0))::TFloat          AS Amount
    INTO vbGoodsName, vbUnitName, vbAmountSend, vbRemains
    FROM tmpListDiffVIPSend
         
         LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.Id = tmpListDiffVIPSend.GoodsId
         LEFT JOIN Object_Goods_Main   AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId

         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpListDiffVIPSend.UnitId
         
         LEFT JOIN tmpContainer AS Container
                                ON Container.GoodsId = tmpListDiffVIPSend.GoodsId
                               AND Container.UnitId = tmpListDiffVIPSend.UnitId
                               
         LEFT JOIN tmpObject_Price ON tmpObject_Price.UnitId = tmpListDiffVIPSend.UnitId
                                  AND tmpObject_Price.GoodsId = tmpListDiffVIPSend.GoodsId 
         
         LEFT JOIN tmpLayoutAll ON tmpLayoutAll.UnitId = tmpListDiffVIPSend.UnitId
                               AND tmpLayoutAll.GoodsId = tmpListDiffVIPSend.GoodsId 
            
         LEFT JOIN tmpReserve ON tmpReserve.UnitId = tmpListDiffVIPSend.UnitId
                             AND tmpReserve.GoodsId = tmpListDiffVIPSend.GoodsId 
            
         LEFT JOIN tmpSend ON tmpSend.UnitId = tmpListDiffVIPSend.UnitId
                          AND tmpSend.GoodsId = tmpListDiffVIPSend.GoodsId 
                          
    WHERE FLOOR(COALESCE (Container.Amount, 0) - 
                COALESCE (tmpObject_Price.MCSValue, 0) - 
                COALESCE (tmpLayoutAll.Amount, 0) - 
                COALESCE (tmpReserve.Amount, 0) - 
                COALESCE (tmpSend.Amount, 0)) < tmpListDiffVIPSend.AmountSend
   ;

    IF COALESCE (vbGoodsName, '') <> ''
    THEN
    
      RAISE EXCEPTION 'Ошибка.Как минимум у одного товара <%> по подразделению <%> остаток для распределения <%> меньше чем распределено <%>. Надо перераспределить товар по подразделениям.', 
                       vbGoodsName, vbUnitName, vbRemains, CASE WHEN vbAmountSend < 0 THEN 0 ELSE vbAmountSend END;
    END IF;

    -- Создаем перемещения
    CREATE TEMP TABLE _tmpSend  (UnitId_from Integer
                               , UnitId_to Integer
                               , isUrgently Boolean
                               , GoodsId Integer
                               , Amount TFloat
                               , MovementId Integer
                               , MovementItemId Integer
                     ) ON COMMIT DROP;

    INSERT INTO _tmpSend
    SELECT tblListDiffJSON.UnitSendId
         , tblListDiffJSON.UnitId
         , tblListDiffJSON.isUrgently
         , MovementItem.ObjectId
         , SUM(tblListDiffJSON.AmountSend) 
         , 0
         , 0
    FROM tblListDiffJSON
                                     
         INNER JOIN MovementItem ON MovementItem.Id = tblListDiffJSON.Id
                                     
    WHERE COALESCE(tblListDiffJSON.UnitSendId, 0) <> 0
      AND tblListDiffJSON.AmountSend > 0
    GROUP BY tblListDiffJSON.UnitSendId
           , tblListDiffJSON.UnitId
           , tblListDiffJSON.isUrgently
           , MovementItem.ObjectId;
    
    IF EXISTS(SELECT  1 FROM _tmpSend)
    THEN
  
       -- создали документы
       UPDATE _tmpSend SET MovementId = tmp.MovementId
       FROM (SELECT tmp.UnitId_from
                  , tmp.UnitId_to
                  , tmp.isUrgently
                  , gpInsertUpdate_Movement_SendVIP (ioId               := 0
                                                   , inFromId           := UnitId_from
                                                   , inToId             := UnitId_to
                                                   , inisUrgently       := isUrgently
                                                   , inSession          := inSession
                                                    ) AS MovementId

             FROM (SELECT DISTINCT _tmpSend.UnitId_from
                                 , _tmpSend.UnitId_to 
                                 , _tmpSend.isUrgently 
                   FROM _tmpSend 
                   WHERE _tmpSend.Amount > 0) AS tmp
            ) AS tmp
       WHERE _tmpSend.UnitId_from = tmp.UnitId_from
         AND _tmpSend.UnitId_to   = tmp.UnitId_to
         AND _tmpSend.isUrgently  = tmp.isUrgently
       ;

       -- Заполнили товаром
       UPDATE _tmpSend SET MovementItemId = tmp.MovementItemId
       FROM (SELECT _tmpSend.MovementId
                  , _tmpSend.GoodsId
                  , lpInsertUpdate_MovementItem_Send (ioId                   := 0
                                                    , inMovementId           := _tmpSend.MovementId
                                                    , inGoodsId              := _tmpSend.GoodsId
                                                    , inAmount               := _tmpSend.Amount
                                                    , inAmountManual         := 0
                                                    , inAmountStorage        := 0
                                                    , inReasonDifferencesId  := 0
                                                    , inCommentSendID        := 0
                                                    , inUserId               := vbUserId
                                                     ) AS MovementItemId
             FROM _tmpSend 
             WHERE _tmpSend.Amount > 0
            ) AS tmp
       WHERE _tmpSend.MovementId = tmp.MovementId
         AND _tmpSend.GoodsId    = tmp.GoodsId
            ;
    
       -- Прописали в лист отказов сколько перемемтили
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSend(), tblListDiffJSON.Id, MAX(COALESCE(MIFloat_AmountSend.ValueData, 0)) + SUM(tblListDiffJSON.AmountSend))
       FROM tblListDiffJSON
                                                                                  
            LEFT JOIN MovementItemFloat AS MIFloat_AmountSend
                                        ON MIFloat_AmountSend.MovementItemId = tblListDiffJSON.Id
                                       AND MIFloat_AmountSend.DescId = zc_MIFloat_AmountSend() 

       WHERE COALESCE(tblListDiffJSON.UnitSendId, 0) <> 0
         AND tblListDiffJSON.AmountSend > 0
       GROUP BY tblListDiffJSON.Id;
    END IF;
    
    IF EXISTS(SELECT tblListDiffJSON.Id
              FROM tblListDiffJSON
              WHERE tblListDiffJSON.isOrder = True)
    THEN
      PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_OrderInternal(), tblListDiffJSON.Id, True)
      FROM tblListDiffJSON
      WHERE tblListDiffJSON.isOrder = True;
    END IF;
    
    -- !!!ВРЕМЕННО для ТЕСТА!!!
    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION 'Тест прошел успешно для <%>', inSession;
    END IF;    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 28.07.21                                                      *
*/  
  
select * from gpInsert_Movement_ListDiffVIPSend(inJson := '[{"id":450691607,"movementid":24505733,"unitid":8393158,"unitsendid":13338606,"amountsend":1,"isurgently":"False","isorder":"True"}]' ,  inSession := '3');